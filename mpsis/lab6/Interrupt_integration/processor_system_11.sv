`timescale 1ns / 1ps

module processor_system_11 (
  input  logic        clk_i,
  input  logic        rst_i
);

//##############################################################################################
// instr mem + core
logic [31:0] instr;
logic [31:0] instr_addr;

instr_mem IMemory (
        .addr_i(instr_addr),            //instr_addr
        .read_data_o(instr)             //instr
    );
//##############################################################################################
// core + lsu
logic           stall;
logic           CORE_REQ;
logic           CORE_WE;
logic   [2:0]   CORE_SIZE;
logic   [31:0]  CORE_WD;
logic   [31:0]  CORE_ADDR;
logic   [31:0]  CORE_RD; 

logic           irq_req;     // not conected
logic           irq_ret;  // not conected

 processor_core core(   
        .clk_i(clk_i),                  //clk_i            
        .rst_i(rst_i),                  //rst_i
        .instr_addr_o(instr_addr),      //instr_addr
        .instr_i(instr),                //instr
        .mem_rd_i(CORE_RD),                  //mem_rd-----corerd
        .mem_req_o(CORE_REQ),            // mew_REQ
        .mem_we_o(CORE_WE),              //men_WE 
        .mem_size_o(CORE_SIZE),          //mem_szie
        .mem_wd_o(CORE_WD),              //mem_wd
        .mem_addr_o(CORE_ADDR),          //mem_addr
        .stall_i(stall),                 //STAL
        
        .irq_req_i(irq_req ),
        .irq_ret_o(irq_ret)
    );
  

//##############################################################################################
// lsu +    D_MEMORY
logic           MEM_REQ;
logic           MEM_WE;
logic           MEM_READY;
logic   [3:0]   MEM_BE;
logic   [31:0]  MEM_WD;
logic   [31:0]  MEM_A;
logic   [31:0]  MEM_RD; 

data_mem DMemory (
        .clk_i(clk_i),                  //clk_i
        .mem_req_i(MEM_REQ),            //REQ
        .write_enable_i(MEM_WE),        //WE          
        .byte_enable_i(MEM_BE),  //BE
        .write_data_i(MEM_WD),          //WD
        .addr_i(MEM_A),              //ADDR
        .read_data_o(MEM_RD),                //RD
        .ready_o(MEM_READY)
    );



lsu LSU (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .core_req_i(CORE_REQ),
    .core_we_i(CORE_WE),
    .core_size_i(CORE_SIZE),
    .core_addr_i(CORE_ADDR),
    .core_wd_i(CORE_WD),
    .core_rd_o(CORE_RD),
    .core_stall_o(stall),
    .mem_req_o(MEM_REQ),
    .mem_we_o(MEM_WE),
    .mem_be_o(MEM_BE),
    .mem_addr_o(MEM_A),
    .mem_wd_o(MEM_WD),
    .mem_rd_i(MEM_RD),
    .mem_ready_i(MEM_READY)
);
endmodule
