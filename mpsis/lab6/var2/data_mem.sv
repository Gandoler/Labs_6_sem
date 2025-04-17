`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.09.2023 06:05:26
// Design Name: 
// Module Name: data_mem
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

module data_mem(
    input logic         clk_i,
    input logic         mem_req_i,
    input logic         write_enable_i,
    input logic  [31:0] addr_i,
    input logic  [31:0] write_data_i,
    output logic [31:0] read_data_o
    );
    
    logic [31:0] memory [4096];
    
    always_ff @(posedge clk_i) begin
        if((mem_req_i == 1 & (addr_i < 0 & addr_i > 16383)) | write_enable_i == 0) begin
            read_data_o <= 32'hdead_beef;
        end if(mem_req_i == 1 & (addr_i >= 0 & addr_i <= 16383)) begin
            read_data_o <= memory[addr_i/4];
        end if(mem_req_i == 0 | write_enable_i == 1) begin
            read_data_o <= 32'hfa11_1eaf;
        end
    end
    
    always_ff @(posedge clk_i) begin
        if(mem_req_i == 1 & write_enable_i == 1) begin
            memory[addr_i/4] <= write_data_i;
        end
     end
endmodule
