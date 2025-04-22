`timescale 1ns / 1ps

module processor_system_7(
  input  logic        clk_i,
  input  logic        rst_i
);
logic [31:0] instr;

// core + D Memory 
logic [31:0] mem_wd;
logic [31:0] mem_addr;
logic [ 3:0] byte_enable_i = 4'b1111; // core :: mem size
logic        mem_we;
logic [31:0] RD;        // core :: mem rd


// core + D Memory  +  stal
logic        mem_req;

// core  +  stal
logic        core_stall_o;

//D Memory
logic        READY;             // not connected
        
// core 
logic [ 2:0] mem_size;          // not connected

// core + IN Memory
logic [31:0] instr;
logic [31:0] instr_addr;
//##############################################################################################
reg        stall_reg;
assign core_stall_o = (mem_req && stall_reg) ;

 always_ff @(posedge clk_i) begin
        if(rst_i) begin
            stall_reg <= 1'b0;
        end else begin
            stall_reg <= core_stall_o;
        end
    end
//##############################################################################################
data_mem DMemory (
        .clk_i(clk_i),                  //clk_i
        .mem_req_i(mem_req),            //REQ
        .write_enable_i(mem_we),        //WE          
        .byte_enable_i(byte_enable_i),  //BE
        .write_data_i(mem_wd),          //WD
        .addr_i(mem_addr),              //ADDR
        .read_data_o(RD)                //RD
    );
    
    
instr_mem IMemory (
        .addr_i(instr_addr),            //instr_addr
        .read_data_o(instr)             //instr
    );


 processor_core core(   
        .clk_i(clk_i),                  //clk_i            
        .rst_i(rst_i),                  //rst_i
        .instr_addr_o(instr_addr),      //instr_addr
        .instr_i(instr),                //instr
        .mem_rd_i(RD),                  //mem_rd-----corerd
        .mem_req_o(mem_req),            // mew_REQ
        .mem_we_o(mem_we),              //men_WE 
        .mem_size_o(mem_size),          //mem_szie
        .mem_wd_o(mem_wd),              //mem_wd
        .mem_addr_o(mem_addr),          //mem_addr
        .stall_i(core_stall_o)                 //STAL
    );
  
 
  
endmodule
