`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.10.2023 18:38:57
// Design Name: 
// Module Name: ricsv_lsu
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

module riscv_lsu(
    input logic clk_i,
    input logic rst_i,

    // ��������� � �����
    input  logic        core_req_i,
    input  logic        core_we_i,
    input  logic [ 2:0] core_size_i,
    input  logic [31:0] core_addr_i,
    input  logic [31:0] core_wd_i,
    output logic [31:0] core_rd_o,
    output logic        core_stall_o,

    // ��������� � �������
    output logic        mem_req_o,
    output logic        mem_we_o,
    output logic [ 3:0] mem_be_o,
    output logic [31:0] mem_addr_o,
    output logic [31:0] mem_wd_o,
    input  logic [31:0] mem_rd_i,
    input  logic        mem_ready_i
    );

    import riscv_pkg::*;
    
    logic [ 1:0] byte_offset;
    logic        half_offset;
    
    logic [ 3:0] mem_be_w;
    logic [ 3:0] mem_be_h;
    logic [ 3:0] mem_be_b;
    
    logic [31:0] core_rd_w;
    logic [31:0] core_rd_h;
    logic [31:0] core_rd_hu;
    logic [31:0] core_rd_b;
    logic [31:0] core_rd_bu;
    
    logic [31:0] mem_wd_w;
    logic [31:0] mem_wd_h;
    logic [31:0] mem_wd_b;
    
    logic [ 7:0] first_byte;
    logic [ 7:0] second_byte;
    logic [ 7:0] third_byte;
    logic [ 7:0] fourth_byte;
    
    logic [31:0] SE_first_byte;
    logic [31:0] SE_second_byte;
    logic [31:0] SE_third_byte;
    logic [31:0] SE_fourth_byte;
    
    logic [31:0] ZE_first_byte;
    logic [31:0] ZE_second_byte;
    logic [31:0] ZE_third_byte;
    logic [31:0] ZE_fourth_byte;
    
    logic [15:0] first_half_word;
    logic [15:0] second_half_word;
    
    logic [31:0] SE_first_half_word;
    logic [31:0] SE_second_half_word;
    
    logic [31:0] ZE_first_half_word;
    logic [31:0] ZE_second_half_word;
    
    logic        stall_reg;
    
    assign mem_addr_o = core_addr_i;
    
    assign byte_offset = core_addr_i[1:0];
    assign half_offset = core_addr_i[1];
    
    assign mem_be_w = 4'b1111;
    assign mem_be_b = 4'b0001 << byte_offset;
    
    assign core_rd_w = mem_rd_i;
    
    assign mem_wd_w = core_wd_i;
    assign mem_wd_h = { {2{core_wd_i[15:0]}} };
    assign mem_wd_b = { {4{core_wd_i[ 7:0]}} };
    
    assign first_byte   = mem_rd_i[ 7: 0];
    assign second_byte  = mem_rd_i[15: 8];
    assign third_byte   = mem_rd_i[23:16];
    assign fourth_byte  = mem_rd_i[31:24];
    
    // �������� ���������� ��� ��������� ������
    assign SE_first_byte  = { {24{ first_byte[7]}},  first_byte };
    assign SE_second_byte = { {24{second_byte[7]}}, second_byte };
    assign SE_third_byte  = { {24{ third_byte[7]}},  third_byte };
    assign SE_fourth_byte = { {24{fourth_byte[7]}}, fourth_byte };
    
    // ����������� ���������� ��� ��������� ������
    assign ZE_first_byte  = { 24'd0,  first_byte };
    assign ZE_second_byte = { 24'd0, second_byte };
    assign ZE_third_byte  = { 24'd0,  third_byte };
    assign ZE_fourth_byte = { 24'd0, fourth_byte };
    
    assign first_half_word  = mem_rd_i[15:0];
    assign second_half_word = mem_rd_i[31:16];
    
    // �������� ���������� ��� ���������
    assign SE_first_half_word  = { {16{ first_half_word[15]}},  first_half_word };
    assign SE_second_half_word = { {16{second_half_word[15]}}, second_half_word };
    
    // ����������� ���������� ��� ���������
    assign ZE_first_half_word  = { 16'd0,  first_half_word };
    assign ZE_second_half_word = { 16'd0, second_half_word };
    
    // ������������� ��� ������ ������ ��� ������ �������� �����
    always_comb begin
        case(half_offset)
            1'b0: mem_be_h <= 4'b0011;
            1'b1: mem_be_h <= 4'b1100;
       endcase
    end
    
    // ������������� ��� ������ ����������������� �����
    always_comb begin
        case(byte_offset)
            2'b00: core_rd_b <= SE_first_byte;
            2'b01: core_rd_b <= SE_second_byte;
            2'b10: core_rd_b <= SE_third_byte;
            2'b11: core_rd_b <= SE_fourth_byte;
        endcase
    end
    
    // ������������� ��� ������ ������������������� �����
    always_comb begin
        case(byte_offset)
            2'b00: core_rd_bu <= ZE_first_byte;
            2'b01: core_rd_bu <= ZE_second_byte;
            2'b10: core_rd_bu <= ZE_third_byte;
            2'b11: core_rd_bu <= ZE_fourth_byte;
        endcase
    end
    
    // ������������� ��� ������ ����������������� ���������
    always_comb begin
        case(half_offset)
            1'b0: core_rd_h <= SE_first_half_word;
            1'b1: core_rd_h <= SE_second_half_word;
        endcase
    end
    
    // ������������� ��� ������ ������������������� ���������
    always_comb begin 
        case(half_offset)
            1'b0: core_rd_hu <= ZE_first_half_word;
            1'b1: core_rd_hu <= ZE_second_half_word;
        endcase
    end
    
    // ������������� ��� ������� mem_be_o
    always_comb begin
        case(core_size_i)
            LDST_W: mem_be_o <= mem_be_w;
            LDST_H: mem_be_o <= mem_be_h; // mem_be_h ������� �� ��������������
            LDST_B: mem_be_o <= mem_be_b; // mem_be_b ������� �� ������ �����
            default:
                mem_be_o <= 0;
        endcase
    end
    
    // ������������� ��� ������� core_rd_o
    always_comb begin
        case(core_size_i)
            LDST_W:  core_rd_o <= core_rd_w;
            LDST_H:  core_rd_o <= core_rd_h;
            LDST_B:  core_rd_o <= core_rd_b;
            LDST_BU: core_rd_o <= core_rd_bu;
            LDST_HU: core_rd_o <= core_rd_hu;
            default:
                core_rd_o <= 0;
        endcase
    end
    
    // ������������� ��� ������� mem_wd_o
    always_comb begin
        case(core_size_i)
            LDST_W: mem_wd_o <= mem_wd_w;
            LDST_H: mem_wd_o <= mem_wd_h;
            LDST_B: mem_wd_o <= mem_wd_b;
            default:
                mem_wd_o <= 0;
        endcase
    end
    
    
    /*always_comb begin
        case(half_offset)
            1'b0:
            begin
            mem_be_h   <= 4'b0011;
            core_rd_h  <= SE_first_half_word;
            core_rd_h  <= ZE_first_half_word;
            end
            1'b1:
            begin
            mem_be_h   <= 4'b1100;
            core_rd_h  <= SE_second_half_word;
            core_rd_hu <= ZE_second_half_word;
            end
        endcase
        
        case(byte_offset)
            2'b00:
            begin
                core_rd_b  <=  SE_first_byte;
                core_rd_bu <=  ZE_first_byte;
            end
            2'b01:
            begin
                core_rd_b  <= SE_second_byte;
                core_rd_bu <= ZE_second_byte;
            end
            2'b10:
            begin
                core_rd_b  <=  SE_third_byte;
                core_rd_bu <=  ZE_third_byte;
            end
            2'b11:
            begin
                core_rd_b  <= SE_fourth_byte;
                core_rd_bu <= ZE_fourth_byte;
            end
        endcase
        
        case(core_size_i)
            // ������������� ��� mem_be_o
            LDST_W: 
            begin
                mem_be_o <= mem_be_w;
                core_rd_o <= core_rd_w;
                mem_wd_o <= mem_wd_w;
            end
            LDST_H:
            begin
                mem_be_o <= mem_be_h; // mem_be_h ������� �� ��������������
                core_rd_o <= core_rd_h;
                mem_wd_o <= mem_wd_h;
            end
            LDST_B:
            begin
                mem_be_o <= mem_be_b; // mem_be_b ������� �� ������ �����
                core_rd_o <= core_rd_b;
                mem_wd_o <= mem_wd_b;
            end
            LDST_BU:
            begin
                core_rd_o <= core_rd_bu;
            end
            LDST_HU:
            begin
                core_rd_o <= core_rd_hu;
            end
            
        endcase
    end
    */
    
    assign core_stall_o = ~(mem_ready_i && stall_reg) && core_req_i;
    
    always_ff @(posedge clk_i) begin
        if(rst_i) begin
            stall_reg <= 1'b0;
        end else begin
            stall_reg <= core_stall_o;
        end
    end
    
    
    assign mem_req_o = core_req_i;
    assign mem_we_o  = core_we_i;
    
endmodule
