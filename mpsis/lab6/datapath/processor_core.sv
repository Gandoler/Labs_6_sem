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
endmodule
