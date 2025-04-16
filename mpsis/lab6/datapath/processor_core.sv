module processor_core (
  input  logic        clk_i,
  input  logic        rst_i,

  input  logic        stall_i,
  input  logic [31:0] instr_i,
  input  logic [31:0] mem_rd_i,

  output logic [31:0] instr_addr_o,
  output logic [31:0] mem_addr_o,
  output logic [ 2:0] mem_size_o,
  output logic        mem_req_o,
  output logic        mem_we_o,
  output logic [31:0] mem_wd_o
);
 
  
  // консанты для мультиплексторов
  localparam ZERO = 32'd0;
  localparam FOUR = 32'd4;

  // получаемые константы
  logic [11:0] imm_I;
  logic [11:0] imm_S;
  logic [12:0] imm_B;
  logic [20:0] imm_J; 
  logic [4:0]  imm_Z;

//######################################################################### 
//              Декодер
  
  logic         b;//2л
  logic         jal;//3л
  logic         jalr;//4л
  logic         mret;//5л
  logic         illegal_instr;//6л
  logic         csr_we;//7л
  logic [2:0]   csr_op;//8л
  
  logic [1:0]   a_sel;//1п
  logic [2:0]   b_sel;//2п
  logic [4:0]   alu_op;//3п
  logic [1:0]   wb_sel;//4п
  logic         mem_we;//5п
  logic         mem_req;//6п
  logic [2:0]   mem_size;//7п
  
  logic         gpr_we;//низ
//#########################################################################
//    связь с регистровым файлом
  logic [4:0]  RA1;
  logic [4:0]  RA2;
  logic [4:0]  WA;
  logic [31:0] RD1;
  logic [31:0] RD2;
  logic        WE;
  logic [31:0] wb_data;
//#########################################################################
//    хранения значения b
  logic        SE_imm_I;
  logic        imm_U;
  logic [31:0] SE_imm_S;
//#########################################################################
//    связь с АЛУ
  logic [31:0] a_i;
  logic [31:0] b_i;
  logic [31:0] result_o;
  logic        flag;
//#########################################################################
//    связь с PC
  logic [31:0] sum_for_PC;
  logic [31:0] PC;
  logic [31:0] SE_imm_B;
  logic [31:0] SE_imm_J;
  logic [31:0] jal_mult;
  logic [31:0] branch_mult;
//#########################################################################
//   получение значений с команд и суматоров
//   сумматор RD1 и SE_imm_I ---------------------тот что самый левый
  logic [31:0] sum;
  adder32 pc_adder( // импортозамещение
    .a_i(RD1),                  
    .b_i(SE_imm_I),                  
    .sum_o(sum),                
    .carry_i('0)                     // Вход переноса (не используется здесь)
  );

  logic [31:0] sum_const;
  assign sum_const = { sum[31:1], 1'b0 }; // делаем сумму четной 
  // Обратите внимание, что младший бит этой суммы должен быть обнулен  таково требование спецификации [1, стр. 28].
//#########################################################################
  assign RA1 = instr_i[19:15];   // адресс 1 регистра из инструкции
  assign RA2 = instr_i[24:20];   // адресс 2 регистра из инструкции
  assign WA = instr_i[11:7];     // адресс регистра для записи из инструкции

  assign imm_I = instr_i[31:20];                                                                   // константа типа I из инструкции
  assign imm_U = { instr_i[31:12], 12'h000 };                                                      // константа типа U из инструкции
  assign imm_S = { instr_i[31:25], instr_i[11:7] };                                                // константа типа S из инструкции
  assign imm_B = { instr_i[31], instr_i[7], instr_i[30:25], instr_i[11:8], 1'b0 };                 // константа типа B из инструкции
  assign imm_J = { instr_i[31], instr_i[19:12], instr_i[20], instr_i[30:21], 1'b0 };               // константа типа J из инструкции
  assign imm_Z = instr_i[19:15];                                                                   // константа типа Z из инструкции

  assign SE_imm_I = { {20{imm_I[11]}}, imm_I };   // Знаковое расширение до 32 бит 
  assign SE_imm_S = { {20{imm_S[11]}}, imm_S };  // Знаковое расширение до 32 бит 
  assign SE_imm_B = { {19{imm_B[12]}}, imm_B };  // Знаковое расширение до 32 бит 
  assign SE_imm_J = { {11{imm_J[20]}}, imm_J };  // Знаковое расширение до 32 бит 
  assign ZE_imm_Z = { 27'd0, imm_Z};

//    появился вход stall_i, приостанавливающий обновление программного счётчика.
  assign WE = gpr_we && stall_i; // для остановки
//#########################################################################
//    мультиплексор для выбора операнда  a_i
  always_comb begin
    case(a_sel)
      2'd0: a_i = RD1;
      2'd1: a_i = PC;
      2'd2: a_i = ZERO;
      default: a_i = 0;
    endcase
  end
//#########################################################################
//    мультиплексор для выбора операнда  b_i
  always_comb begin
    case(b_sel)
      3'd0: b_i = RD2;
      3'd1: b_i = SE_imm_I;
      3'd2: b_i = imm_U;
      3'd3: b_i = SE_imm_S;
      3'd4: b_i = FOUR;
      default: b_i = 0;
    endcase
  end
//#########################################################################
//     мультиплексор для wb_data
  always_comb begin
    case(wb_sel)
      2'd0: wb_data = result_o;
      2'd1: wb_data = mem_rd_i;
      //2'd2: wb_data = csr_wd; // возможно позже завезут
      default: wb_data = 0;
    endcase
  end
//#########################################################################
//     мультиплексор branch
  always_comb begin
    case(b)
      1'b0: branch_mult = SE_imm_J;
      1'b1: branch_mult = SE_imm_B;
    endcase
  end
//#########################################################################
//    мультиплексор jal
  always_comb begin
    case((flag && b) || jal)
      1'b0: jal_mult = FOUR;
      1'b1: jal_mult = branch_mult;
    endcase
  end
//#########################################################################
//    сумматор переходов
  logic [31:0] summator;
//    assign summator = PC + jal_mult;  
   adder32 pc_adder2(// импортозамещение
    .a_i(PC),                  
    .b_i(jal_mult),                  
    .sum_o(summator),                
    .carry_i('0)                     // Вход переноса (не используется здесь)
  );

//#########################################################################

   //подключение main_decoder
  mega_decoder decoder(
   .fetched_instr_i(instr_i),
  .a_sel_o(a_sel),
  .b_sel_o(b_sel),
  .alu_op_o(alu_op),
  .csr_op_o(csr_op),
  .csr_we_o(csr_we),
  .mem_req_o(mem_req),
  .mem_we_o(mem_we),
  .mem_size_o(mem_size),
  .gpr_we_o(gpr_we),
  .wb_sel_o(wb_sel),
  .illegal_instr_o(illegal_instr),
  .branch_o(branch),
  .jal_o(jal),
  .jalr_o(jalr),
  .mret_o(mret)
  );

  // подключение Register_File
  register_file RF(
    .clk_i(clk_i),
    .read_addr1_i(RA1),
    .read_addr2_i(RA2),
    .write_addr_i(WA),
    .write_data_i(wb_data),
    .read_data1_o(RD1),
    .read_data2_o(RD2),
    .write_enable_i(WE)
  );

  //подключенией ALU
  alu ALU(
    .a_i(a_i),
    .b_i(b_i),
    .alu_op_i(alu_op),
    .flag_o(flag),
    .result_o(result_o)
  );
  
   // соединение выходов
  assign instr_addr_o = PC;
  assign mem_addr_o = result_o;
  assign mem_wd_o = RD2;
  //#########################################################################
//  модуль pc

//    мультиплексор jalr
  always_comb begin
    case(jalr)
      1'b0: sum_for_PC = summator;
      1'b1: sum_for_PC = sum_const;
    endcase
  end
  
//always_ff @(posedge clk_i) begin
//    if (!stall_i) begin
//        if (rst_i) PC <= ZERO;
//        else PC <= jalr ? sum_const : sum_for_PC;//    мультиплексор jalr

//    end
    
//    if (jal || jalr) RD1 <= PC + FOUR;
//end


  always_ff @(posedge clk_i) begin
    if(rst_i) begin
      PC <= ZERO;
    end 
    else begin
      if(!stall_i)
        PC = sum_for_PC;
      end
    end

endmodule
