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


  // сумматор RD1 и SE_imm_I
  logic [31:0] sum;
  logic [31:0] sum_const;

  //знакорасширения SE или обычного расширения
  logic [11:0] imm_I;
  logic [11:0] imm_S;
  logic [12:0] imm_B;
  logic [20:0] imm_J; 
  logic [4:0]  imm_Z;

//######################################################################### 
//              Декодер
  logic [31:0]  fetched_instr_i,//1л
  logic         branch_o,//2л
  logic         jal_o,//3л
  logic         jalr_o,//4л
  logic         mret_o,//5л
  logic         illegal_instr_o,//6л
  logic         csr_we_o,//7л
  logic [2:0]   csr_op_o,//8л
  
  logic [1:0]   a_sel_o,//1п
  logic [2:0]   b_sel_o,//2п
  logic [4:0]   alu_op_o,//3п
  logic [1:0]   wb_sel_o,//4п
  logic         mem_we_o,//5п
  logic         mem_req_o,//6п
  logic [2:0]   mem_size_o,//7п
  
  logic         gpr_we_o//низ
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
    //assign sum = RD1 + SE_imm_I; // самый 
    // Модуль сумматора 
  adder32 pc_adder(
    .a_i(RD1),                  
    .b_i(SE_imm_I),                  
    .sum_o(sum),                
    .carry_i('0)                     // Вход переноса (не используется здесь)
  );

  assign sum_const = { sum[31:1], 1'b0 }; // делаем сумму четной
//#########################################################################
  assign RA1 = instr_i[19:15];   // адресс 1 регистра из инструкции
  assign RA2 = instr_i[24:20];   // адресс 2 регистра из инструкции
  assign WA = instr_i[11:7];     // адресс регистра для записи из инструкции

  assign imm_I = instr_i[31:20];                                                                   // константа типа I из инструкции
  assign imm_U = assign imm_U = { instr_i[31:12], 12'h000 };                                       // константа типа U из инструкции
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
  assign WE = gpr_we && stall_i // для остановки
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
      //2'd2: wb_data = csr_wd;
      default: wb_data = 0;
    endcase
  end



endmodule
