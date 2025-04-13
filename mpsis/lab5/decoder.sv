module decoder (
  input  logic [31:0]  fetched_instr_i,
  output logic [1:0]   a_sel_o,
  output logic [2:0]   b_sel_o,
  output logic [4:0]   alu_op_o,
  output logic [2:0]   csr_op_o,
  output logic         csr_we_o,
  output logic         mem_req_o,
  output logic         mem_we_o,
  output logic [2:0]   mem_size_o,
  output logic         gpr_we_o,
  output logic [1:0]   wb_sel_o,
  output logic         illegal_instr_o,
  output logic         branch_o,
  output logic         jal_o,
  output logic         jalr_o,
  output logic         mret_o
);
  import decoder_pkg::*;

//  Для удобства дальнейшего описания модуля, 
//  рекомендуется сперва создать сигналы opcode, 
//  func3, func7 и присвоить им соответствующие биты входного сигнала инструкции.
assign funct3 = fetched_instr_i[14:12];
assign funct7 = fetched_instr_i[31:25];
assign opcode = fetched_instr_i[6:0];

always_comb begin
    //Внутри блока always_comb до начала блока case можно указать базовые значения для всех выходных сигналов. 
    //Это не то же самое, что вариант default в блоке case. Здесь вы можете описать состояния, которые будут использованы чаще всего, 
    //и в этом случае, присваивание сигналу будет выполняться только в том месте, где появится инструкция, требующая значение этого сигнала, 
    //отличное от базового. пусть все нули
    illegal_instr_o = 1'b0;     //Сигнал о некорректной инструкции	
    mret_o = 1'b0;              //Сигнал об инструкции возврата из прерывания/исключения mret
    jalr_o = 1'b0;              //Сигнал об инструкции безусловного перехода jalr
    jal_o = 1'b0;               //Сигнал об инструкции безусловного перехода jal	
    branch_o = 1'b0;            //Сигнал об инструкции условного перехода	
    wb_sel_o = 2'b00;            //Управляющий сигнал мультиплексора для выбора данных, записываемых в регистровый файл
    alu_op_o = ALU_ADD;         //Операция АЛУ	
    csr_we_o = 1'b0;            //Разрешение на запись в CSR	
    csr_op_o = 3'd0;            //Операция модуля CSR	
    mem_req_o = 1'b0;           //Запрос на доступ к памяти (часть интерфейса памяти)	
    mem_we_o = 1'b0;            //Сигнал разрешения записи в память, «write enable» (при равенстве нулю происходит чтение)
    gpr_we_o = 1'b0;            //	Сигнал разрешения записи в регистровый файл
    a_sel_o = 2'd0;             //Управляющий сигнал мультиплексора для выбора первого операнда АЛУ
    b_sel_o = 3'd0;             //Управляющий сигнал мультиплексора для выбора второго операнда АЛУ	
    mem_size_o = 3'd0;          //Управляющий сигнал для выбора размера слова при чтении-записи в память (часть интерфейса памяти)
//#####################################################################################################################################################################################################
    case (opcode)
        LOAD_OPCODE, STORE_OPCODE: begin
        //LOAD	00000	Записать в rd данные из памяти по адресу rs1+imm
        //STORE	01000	Записать в память по адресу rs1+imm данные из 
            mem_req_o = 1'b1;                                          // разрешаем доступ к памяти
            gpr_we_o = (opcode == LOAD_OPCODE) ? 1'b1 : 1'b0;          // load : gpr_we_o=1                        // store: gpr_we_o= 0               :::разрешение записи в регистровый файл 
            wb_sel_o = (opcode == LOAD_OPCODE) ? 2'b01 : wb_sel_o;     // load :   wb_sel_o =  01                  // wb_sel_o = 00:default                        :::выбор данных, записываемых в регистровый файл  
            mem_we_o = (opcode == STORE_OPCODE) ? 1'b1 : 1'b0;         // load :   mem_we_o =  0                   //store: mem_we_o = 1               :::разрешения записи в память
            b_sel_o = (opcode == STORE_OPCODE) ? 3'b101 : 3'b001;      // load :   b_sel_o =  001                  //store: b_sel_o =  b101            :::выбора второго операнда АЛУ	
            
            case(funct3)
                LDST_B, LDST_H, LDST_W, LDST_BU, LDST_HU: mem_size_o = funct3;    // проверка на соответсвия командам размера 
                default: illegal_instr_o = 1'b1;                                  // иначе ошибка операции 
            endcase
        end 
                                                                                     //итого
//store:
//  mem_req_o = 1'b1;
//  gpr_we_o= 0;
//  wb_sel_o = 00:default;
//  mem_we_o = 1; 
//  b_sel_o =  b101; 
//     ::DEFAULT::
//    alu_op_o = ALU_ADD;
//    a_sel_o = 2'd0; 
//    mem_size_o = 3'd0;  

//#####################################################################################################################################################################################################

      
        OP_IMM_OPCODE, OP_OPCODE: begin
            gpr_we_o = 1'b1;
            alu_op_o = funct3;
            case(funct3)
                ALU_ADD, ALU_SLTS, ALU_SLTU, ALU_XOR, ALU_OR, ALU_AND: alu_op_o = funct3;
                default: illegal_instr_o = 1'b1;
            endcase
        end

        AUIPC_OPCODE: begin
            a_sel_o = 2'd1;
            b_sel_o = 3'd2;
            gpr_we_o = 1'b1;
        end
        
        BRANCH_OPCODE: begin
//        localparam ALU_LTS  = 5'b11100;  // Less Than Signed                      FUNCT3<----100 
//        localparam ALU_LTU  = 5'b11110;  // Less Than Unsigned                    FUNCT3<----110
//        localparam ALU_GES  = 5'b11101;  // Great [or] Equal signed               FUNCT3<----101    
//        localparam ALU_GEU  = 5'b11111;  // Great [or] Equal unsigned             FUNCT3<----111    
//        localparam ALU_EQ   = 5'b11000;  // Equal                                 FUNCT3<----000
//        localparam ALU_NE   = 5'b11001;  // Not Equal                             FUNCT3<----001    
            alu_op_o = {2'b11, funct3};
            branch_o = 1'b1;    // просто поставить флаг бренча
        end
        
        JALR_OPCODE: begin
          // 
            a_sel_o = 2'd1;    
            b_sel_o = 3'd4; 
            gpr_we_o = 1'b1; //разрешение на записть в регистровый файл
            jalr_o = 1'b1; // ставим флаг перехода
        end
        
        JAL_OPCODE: begin
            a_sel_o = 2'd1;
            b_sel_o = 3'd4; 
            gpr_we_o = 1'b1;
            jal_o = 1'b1;
        end
        
        SYSTEM_OPCODE: begin
            case(funct3)
                3'b000: begin
                    case(fetched_instr_i[31:7])
                        25'b001100000010_00000_000_00000: mret_o = 1'b1;
                        default: illegal_instr_o = 1'b1;
                    endcase
                end
                3'b001, 3'b010, 3'b011, 3'b101, 3'b110, 3'b111: begin
                    csr_op_o = funct3;
                    csr_we_o = 1'b1;
                    gpr_we_o = 1'b1;
                    wb_sel_o = 2'd2;
                end
                default: illegal_instr_o = 1'b1;
            endcase
        end

        default: illegal_instr_o = 1'b1;
    endcase
end

endmodule


