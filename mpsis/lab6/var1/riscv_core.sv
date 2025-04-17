`timescale 1ns / 1ps


module riscv_core(
    input  logic        clk_i,
    input  logic        rst_i,

    input  logic        stall_i,
    input  logic        irq_req_i,
    input  logic [31:0] instr_i,
    input  logic [31:0] mem_rd_i,

    output logic [31:0] instr_addr_o,
    output logic [31:0] mem_addr_o,
    output logic [ 2:0] mem_size_o,
    output logic        mem_req_o,
    output logic        mem_we_o,
    output logic        irq_ret_o,
    output logic [31:0] mem_wd_o
);

logic [11:0] imm_I;
logic [19:0] imm_U;
logic [11:0] imm_S;
logic [11:0] imm_B;
logic [19:0] imm_J;

logic [31:0] imm_I_SE;
logic [31:0] imm_U_SE;
logic [31:0] imm_S_SE;
logic [31:0] imm_B_SE;
logic [31:0] imm_J_SE;

logic [31:0] RD1;
logic [31:0] RD2;
logic [31:0] WD;
logic [31:0] alu_a;
logic [31:0] alu_b;
logic [31:0] alu_res;
logic [31:0] jalr_PC;
logic [31:0] PC;

logic [4:0] RA1;
logic [4:0] RA2;
logic [4:0] WA;

logic jalr;
logic jal;
logic b;
logic flag;
logic [1:0] wb_sel;
logic gpr_we;
logic WE;

logic [1:0] a_sel;
logic [2:0] b_sel;
logic [4:0] alu_op;



logic mret;
logic illegal_instr;
logic irq;
logic trap;
logic mem_we;
logic mem_req;
logic csr_we;
logic [2:0] csr_op;
logic [31:0] csr_wd;
logic [31:0] mcause;
logic [31:0] mepc;
logic [31:0] mtvec;
logic [31:0] mie;
logic [31:0] irq_cause;



assign imm_I = instr_i[31:20];
assign imm_U = instr_i[31:12];
assign imm_S = {instr_i[31:25], instr_i[11:7]};
assign imm_B = {instr_i[31], instr_i[7], instr_i[30:25], instr_i[11:8]};
assign imm_J = {instr_i[31], instr_i[19:12], instr_i[20], instr_i[30:21]};
assign imm_Z = instr_i[19:15];

assign imm_I_SE = {{20{imm_I[11]}}, imm_I};
assign imm_U_SE = {imm_U, 12'b0};
assign imm_S_SE = {{20{imm_S[11]}}, imm_S};
assign imm_B_SE = {{19{imm_B[11]}}, imm_B, 1'b0};
assign imm_J_SE = {{11{imm_J[11]}}, imm_J, 1'b0};

assign imm_Z_ZE = {27'b0, imm_Z};

assign jalr_PC = RD1 + imm_I_SE; 
assign {RA2, RA1} = instr_i[24:15];
assign WA = instr_i[11:7];

assign instr_addr_o = PC;
assign mem_addr_o = alu_res;
assign mem_wd_o = RD2;



assign WE = gpr_we && ~(stall_i | trap);
assign mem_we_o = mem_we & ~(trap);
assign mem_req_o = mem_req & ~(trap);
assign trap = irq | illegal_instr;
assign mcause = illegal_instr ? 32'h0000_0002 : irq_cause;



always_comb begin
   
    case (wb_sel)
        0: WD <= alu_res;
        1: WD <= mem_rd_i;
        2: WD <= csr_wd;
    endcase
    
    case (a_sel)
        0: alu_a <= RD1;
        1: alu_a <= PC;
        2: alu_a <= 0;
    endcase

    case (b_sel)
        0: alu_b <= RD2;
        1: alu_b <= imm_I_SE;
        2: alu_b <= imm_U_SE;
        3: alu_b <= imm_S_SE;
        4: alu_b <= 4;
    endcase
end



always_ff @(posedge clk_i or posedge rst_i) begin
    if  (rst_i) PC <= 32'd0;
    
    else begin
        if (~stall_i) begin 

            if (mret) begin
                PC <= mepc;
            end

            else begin
                if (trap) begin
                    PC <= mtvec;
                end
                else begin
                    if (jalr) PC <= {jalr_PC[31:1], 1'b0};
                    else begin
                        if (jal || (flag && b)) begin
                            if (b) PC <= PC + imm_B_SE;
                            else PC <= PC + imm_J_SE;
                        end
                        else PC <= PC + 4;
                    end
                end
            end
        end
    end
end

alu_riscv alu
(
  .alu_op_i  (alu_op), 
  .a_i       (alu_a),
  .b_i       (alu_b),                                                                                     
  .result_o  (alu_res),
  .flag_o    (flag)
);

rf_riscv register_file
(
    .clk_i         (clk_i),
    .read_addr1_i  (RA1),
    .read_addr2_i  (RA2),
    .write_addr_i  (WA),
    .write_data_i  (WD),
    .write_enable_i(WE),
    .read_data1_o  (RD1),
    .read_data2_o  (RD2)
);

decoder_riscv decoder(
  .fetched_instr_i  (instr_i),
  
  .a_sel_o          (a_sel), 
  .b_sel_o          (b_sel),    
  .alu_op_o         (alu_op),
  .mem_req_o        (mem_req),
  .mem_we_o         (mem_we),
  .mem_size_o       (mem_size_o), 
  .gpr_we_o         (gpr_we),
  .wb_sel_o         (wb_sel), 
  .branch_o         (b),
  .jal_o            (jal),
  .jalr_o           (jalr),

  .mret_o           (mret),
  .csr_op_o         (csr_op),
  .csr_we_o         (csr_we),
  .illegal_instr_o  (illegal_instr)
);

csr_controller csr_ctrl(
    .clk_i          (clk_i),
    .rst_i          (rst_i),
    .trap_i         (trap),

    .opcode_i       (csr_op),

    .addr_i         (instr_i[31:20]),
    .pc_i           (PC),
    .mcause_i       (mcause),
    .rs1_data_i     (RD1),
    .imm_data_i     (imm_Z_ZE),
    .write_enable_i (csr_we),

    .read_data_o    (csr_wd),
    .mie_o          (mie),
    .mepc_o         (mepc),
    .mtvec_o        (mtvec)
);

interrupt_controller int_ctrl(
    .clk_i          (clk_i),
    .rst_i          (rst_i),
    .exception_i    (illegal_instr),
    .irq_req_i      (irq_req_i),
    .mie_i          (mie[0]),
    .mret_i         (mret),

    .irq_ret_o      (irq_ret_o),
    .irq_cause_o    (irq_cause),
    .irq_o          (irq)
);


endmodule
