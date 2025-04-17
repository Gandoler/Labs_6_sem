`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.10.2023 14:34:21
// Design Name: 
// Module Name: csr_controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module csr_controller(

  input  logic        clk_i,
  input  logic        rst_i,
  input  logic        trap_i,

  input  logic [ 2:0] opcode_i,

  input  logic [11:0] addr_i,
  input  logic [31:0] pc_i,
  input  logic [31:0] mcause_i,
  input  logic [31:0] rs1_data_i,
  input  logic [31:0] imm_data_i,
  input  logic        write_enable_i,

  output logic [31:0] read_data_o,
  output logic [31:0] mie_o,
  output logic [31:0] mepc_o,
  output logic [31:0] mtvec_o
);

import csr_pkg::*;

logic [31:0] one_operation;
logic [31:0] two_operation;
logic [31:0] three_operation;
logic [31:0] four_operation;
logic [31:0] five_operation;
logic [31:0] six_operation;

logic [31:0] csr_operation;

assign one_operation   = rs1_data_i;
assign two_operation   = rs1_data_i | read_data_o;
assign three_operation = (~(rs1_data_i)) & read_data_o;
assign four_operation  = imm_data_i;
assign five_operation  = imm_data_i | read_data_o;
assign six_operation   = (~(imm_data_i)) & read_data_o;

logic one_en;
logic two_en;
logic three_en;
logic four_wen;
logic five_wen;
logic four_en;
logic five_en;


logic [31:0] mepc_i;
logic [31:0] mscratch;
logic [31:0] mcause;
logic [31:0] mcause_o;

    always_comb begin
        case(opcode_i)
            3'b001: csr_operation <= one_operation;
            3'b010: csr_operation <= two_operation;
            3'b011: csr_operation <= three_operation;
            3'b101: csr_operation <= four_operation;
            3'b110: csr_operation <= five_operation;
            3'b111: csr_operation <= six_operation;
            default:
                csr_operation <= 0;
        endcase    
    end
    
    always_comb begin
        one_en   <= 0;
        two_en   <= 0;
        three_en <= 0;
        four_wen  <= 0;
        five_wen  <= 0;
        case(addr_i)
            12'h304: one_en   <= 1;
            12'h305: two_en   <= 1;
            12'h340: three_en <= 1;
            12'h341: four_wen  <= 1;
            12'h342: five_wen  <= 1;
            default:
            begin
                one_en   <= 0;
                two_en   <= 0;
                three_en <= 0;
                four_wen  <= 0;
                five_wen  <= 0;
            end
        endcase
    end
    
    assign four_en = four_wen | trap_i;
    assign five_en = five_wen  | trap_i;
    
    always_comb begin
        case(trap_i)
            1'b0: mepc_i <= csr_operation;
            1'b1: mepc_i <= pc_i;
        endcase
    end
    
    always_comb begin
        case(trap_i)
            1'b0: mcause <= csr_operation;
            1'b1: mcause <= mcause_i;
        endcase
    end
    
    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            mie_o <= 0;
        end else if (one_en) begin
            mie_o <= csr_operation;
        end
    end
    
    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            mtvec_o <= 0;
        end else if (two_en) begin
            mtvec_o <= csr_operation;
        end
    end
    
    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            mscratch <= 0;
        end else if (three_en) begin
            mscratch <= csr_operation;
        end
    end
    
    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            mepc_o <= 0;
        end else if (four_en) begin
            mepc_o <= mepc_i;
        end
    end
    
    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            mcause_o <= 0;
        end else if (five_en) begin
            mcause_o <= mcause;
        end
    end
    
    always_comb begin
        case(addr_i)
            12'h304: read_data_o <= mie_o;
            12'h305: read_data_o <= mtvec_o; 
            12'h340: read_data_o <= mscratch; 
            12'h341: read_data_o <= mepc_o; 
            12'h342: read_data_o <= mcause_o; 
            default:
                 read_data_o <= 0;
        endcase
    end
    
endmodule