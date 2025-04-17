
module riscv_unit(
    input logic clk_i,
    input logic rst_i
    );
    
    logic [31:0] instr_addr;
    logic [31:0] instr;
    logic [31:0] core_rd;
    logic [31:0] RD;
    
    logic        mem_req;
    logic        mem_we;
    logic [ 2:0] mem_size;
    logic [31:0] mem_wd;
    logic [31:0] mem_addr;
    
    logic        req;
    logic        WE;
    logic [ 3:0] BE;
    logic [31:0] WD;
    logic [31:0] A;
    
    logic        READY;
    logic        stall;
    
    logic [31:0] irq_req;
    logic [31:0] irq_ret;
    
    assign irq_req = 32'd0;
    
    // Подключение модуля Load/Store
    riscv_lsu Load_Store_Unit (
        .rst_i(rst_i),
        .core_rd_o(core_rd),
        .mem_ready_i(READY),
        .core_stall_o(stall),
        .core_req_i(mem_req),
        .core_we_i(mem_we),
        .core_size_i(mem_size),
        .core_wd_i(mem_wd),
        .core_addr_i(mem_addr),
        .mem_req_o(req),
        .mem_we_o(WE),
        .mem_be_o(BE),
        .mem_wd_o(WD),
        .mem_addr_o(A),
        .mem_rd_i(RD),
        .clk_i(clk_i)
    );
    
    // Подключение модуля памяти инструкций
    instr_mem Instruction_Memory (
        .addr_i(instr_addr),
        .read_data_o(instr)
    );
    
    // Подключение внешней памяти
    ext_mem Data_Memory (
        .clk_i(clk_i),
        .read_data_o(RD),
        .ready_o(READY),
        .mem_req_i(req),
        .write_enable_i(WE),
        .write_data_i(WD),
        .byte_enable_i(BE),
        .addr_i(A)
    );
    
    // Подключение процессорного ядра
    riscv_core Core (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .instr_addr_o(instr_addr),
        .instr_i(instr),
        .mem_rd_i(core_rd),
        .mem_req_o(mem_req),
        .mem_we_o(mem_we),
        .mem_size_o(mem_size),
        .mem_wd_o(mem_wd),
        .mem_addr_o(mem_addr),
        .stall_i(stall),
        .irq_req_i(irq_req),
        .irq_ret_o(irq_ret)
    );
endmodule
