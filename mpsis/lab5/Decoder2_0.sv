module decoder_mega (
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
wire logic [2:0]  funct3 ;
wire logic [6:0]  funct7;
wire logic [6:0] opcode;

assign funct3 = fetched_instr_i[14:12];
assign funct7 = fetched_instr_i[31:25];
assign opcode = fetched_instr_i[6:0];

  always_comb begin

    //Определение значение по умолчанию
   




 //Проверка на то что 2 младших бита opcode равны '11'
    if(fetched_instr_i[1:0]) begin
    
    
    
 

    end
    else begin 
      illegal_instr_o = 1; 
    end
end
endmodule



