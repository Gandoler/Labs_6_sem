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

logic [31:0] sum;
logic [31:0] pc;

assign instr_addr_o = pc;

logic [31:0] imm_jump;
logic [31:0] jal_jump;

logic jal;
logic jalr;
logic branch;
logic flag;
logic grp_we;

logic [4:0] rd;

logic [4:0] rf_ra1;
logic [4:0] rf_ra2;
logic [4:0] rf_wa;

assign rf_ra1 = instr_i[19:15];
assign rf_ra2 = instr_i[24:20];
assign rf_wa = instr_i[11:7];

logic [31:0] rf_rd1;
logic [31:0] rf_rd2;

assign mem_wd_o = rf_rd2;

logic [31:0] imm_i;
logic [31:0] imm_u;
logic [31:0] imm_s;
logic [31:0] imm_b;
logic [31:0] imm_j;
                  
assign imm_i = { {20{instr_i[31]}}, instr_i[31:20] };
assign imm_u = { instr_i[31:12], 12'h000 };
assign imm_s = { {20{instr_i[31]}}, instr_i[31:25], instr_i[11:7] };
assign imm_b = {  {19{instr_i[31]}}, instr_i[31],
                instr_i[7], instr_i[30:25],
                instr_i[11:8], 1'b0 };
assign imm_j = {  {11{instr_i[31]}},
                instr_i[31], instr_i[19:12],
                instr_i[20], instr_i[30:21], 1'b0 };

logic [31:0] wb_data;

logic [1:0] a_sel;
logic [2:0] b_sel;
logic wb_sel;
logic [4:0]  alu_op;
logic [31:0] alu_result;
logic [31:0] wb_a;
logic [31:0] wb_b;


always_comb
begin
    case(branch)
    'b1: imm_jump = imm_b;
    default: imm_jump = imm_i;
    endcase
end

always_comb
begin
    case((flag && branch) || jal)
    'b1: jal_jump = imm_jump;
    default: jal_jump = 'd4;
    endcase
end

fulladder32 fa(
    .a_i        (jalr ? rf_rd1 : pc),
    .b_i        (jalr ? imm_jump : jal_jump),
    .carry_i    (0),
    
    .sum_o      (sum),
    .carry_o    (carry_dummy)
);

always_comb
begin
    case(wb_sel)
    'b1: wb_data = mem_rd_i;
    default: wb_data = mem_addr_o;
    endcase
end

always_comb
begin
    case(a_sel)
    'd2: wb_a = 'd0;
    'd1: wb_a = pc;
    default: wb_a = rf_rd1;
    endcase
end

always_comb
begin
    case(b_sel)
    'd4: wb_b = 'd4;
    'd3: wb_b = imm_s;
    'd2: wb_b = imm_u;
    'd1: wb_b = imm_i;
    default: wb_b = rf_rd2;
    endcase
end

alu_riscv alu (
    .a_i        (wb_a),
    .b_i        (wb_b),
    .alu_op_i   (alu_op),
    
    .flag_o     (flag),
    .result_o   (mem_addr_o)
);

rf_riscv rf (
    .clk_i          (clk_i),
    .write_enable_i (grp_we),
    
    .write_addr_i   (rf_wa),
    .read_addr1_i   (rf_ra1),
    .read_addr2_i   (rf_ra2),
    
    .write_data_i   (wb_data),
    .read_data1_o   (rf_rd1),
    .read_data2_o   (rf_rd2)
);

decoder_riscv main_decoder(
    .fetched_instr_i    (instr_i),
    
    .a_sel_o            (a_sel),
    .b_sel_o            (b_sel),
    .alu_op_o           (alu_op),

    .mem_req_o          (mem_req_o),
    .mem_we_o           (mem_we_o),
    .mem_size_o         (mem_size_o),
  
    .gpr_we_o           (grp_we),
    .wb_sel_o           (wb_sel),

    .branch_o           (branch),
    .jal_o              (jal),
    .jalr_o             (jalr)
);

always_ff @(posedge clk_i) begin
    if (!stall_i) begin
        if (rst_i) pc <= 0;
        else pc <= jalr ? { sum[31:1], 1'b0 } : sum;
    end
    
 endmodule
