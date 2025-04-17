
module riscv_lsu(
    input  logic        clk_i,
    input  logic        rst_i,

    // Интерфейс с ядром
    input  logic        core_req_i,
    input  logic        core_we_i,
    input  logic [ 2:0] core_size_i,
    input  logic [31:0] core_addr_i,
    input  logic [31:0] core_wd_i,
    output logic [31:0] core_rd_o,
    output logic        core_stall_o,

    // Интерфейс с памятью
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
    assign mem_wd_h = {2{core_wd_i[15:0]}}; // расширение полуслова на все 32 бита
    assign mem_wd_b = {4{core_wd_i[ 7:0]}}; // расширение байта на все 32 бита

    // Выделение отдельных байт из входного слова
    assign first_byte   = mem_rd_i[ 7: 0];
    assign second_byte  = mem_rd_i[15: 8];
    assign third_byte   = mem_rd_i[23:16];
    assign fourth_byte  = mem_rd_i[31:24];

    // Знаковое расширение отдельных байт до 32 бит
    assign SE_first_byte  = { {24{ first_byte[7]}},  first_byte };
    assign SE_second_byte = { {24{second_byte[7]}}, second_byte };
    assign SE_third_byte  = { {24{ third_byte[7]}},  third_byte };
    assign SE_fourth_byte = { {24{fourth_byte[7]}}, fourth_byte };

    // Беззнаковое расширение отдельных байт до 32 бит
    assign ZE_first_byte  = { 24'd0,  first_byte };
    assign ZE_second_byte = { 24'd0, second_byte };
    assign ZE_third_byte  = { 24'd0,  third_byte };
    assign ZE_fourth_byte = { 24'd0, fourth_byte };

    // Полуслова
    assign first_half_word  = mem_rd_i[15:0];
    assign second_half_word = mem_rd_i[31:16];

    // Знаковое расширение полуслова до 32 бит
    assign SE_first_half_word  = { {16{ first_half_word[15]}},  first_half_word };
    assign SE_second_half_word = { {16{second_half_word[15]}}, second_half_word };

    // Беззнаковое расширение полуслова до 32 бит
    assign ZE_first_half_word  = { 16'd0,  first_half_word };
    assign ZE_second_half_word = { 16'd0, second_half_word };

    // Генерация маски байтов для полуслова
    always_comb begin
        case(half_offset)
            1'b0: mem_be_h <= 4'b0011;
            1'b1: mem_be_h <= 4'b1100;
        endcase
    end

    // Мультиплексоры на чтение байтов (знаковое и беззнаковое)
    always_comb begin
        case(byte_offset)
            2'b00: begin
                core_rd_b  <= SE_first_byte;
                core_rd_bu <= ZE_first_byte;
            end
            2'b01: begin
                core_rd_b  <= SE_second_byte;
                core_rd_bu <= ZE_second_byte;
            end
            2'b10: begin
                core_rd_b  <= SE_third_byte;
                core_rd_bu <= ZE_third_byte;
            end
            2'b11: begin
                core_rd_b  <= SE_fourth_byte;
                core_rd_bu <= ZE_fourth_byte;
            end
        endcase
    end

    // Мультиплексоры на чтение полуслов (знаковое и беззнаковое)
    always_comb begin
        case(half_offset)
            1'b0: begin
                core_rd_h  <= SE_first_half_word;
                core_rd_hu <= ZE_first_half_word;
            end
            1'b1: begin
                core_rd_h  <= SE_second_half_word;
                core_rd_hu <=
