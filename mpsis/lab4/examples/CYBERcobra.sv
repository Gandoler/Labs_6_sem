module CYBERcobra (
  input  logic         clk_i,
  input  logic         rst_i,
  input  logic [15:0]  sw_i,
  output logic [31:0]  out_o
);

  // Внутренние сигналы
  logic [31:0] pc;              // Программный счетчик
  logic [31:0] next_pc;         // Следующее значение программного счетчика
  logic [31:0] instruction;     // Текущая инструкция
  logic [31:0] alu_result;      // Результат выполнения АЛУ
  logic [31:0] reg_write_data;  // Данные для записи в регистровый файл
  logic [31:0] reg_read_data1;  // Данные из первого порта чтения регистрового файла
  logic [31:0] reg_read_data2;  // Данные из второго порта чтения регистрового файла
  logic [4:0]  alu_op;          // Код операции АЛУ
  logic        reg_write_en;    // Разрешение записи в регистровый файл
  logic [31:0] imm;             // Непосредственное значение (immediate)
  logic [31:0] branch_target;   // Цель ветвления
  logic        branch_taken;    // Флаг взятия ветвления

  // Счетчик команд
  always_ff @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
      pc <= 32'b0;
    end else begin
      pc <= next_pc;
    end
  end

  // Память инструкций
  logic [31:0] imem [0:127];  // Память инструкций (128 слов)
  initial begin
    $readmemh("program.mem", imem);
  end
  assign instruction = imem[pc[31:2]];  // Чтение инструкции по адресу pc

  // Регистровый файл
  register_file reg_file (
    .clk_i(clk_i),
    .write_enable_i(reg_write_en),
    .read_addr1_i(instruction[19:15]),
    .read_addr2_i(instruction[24:20]),
    .write_addr_i(instruction[11:7]),
    .write_data_i(reg_write_data),
    .read_data1_o(reg_read_data1),
    .read_data2_o(reg_read_data2)
  );

  // АЛУ
  alu alu (
    .a_i(reg_read_data1),
    .b_i(reg_read_data2),
    .alu_op_i(alu_op),
    .result_o(alu_result),
    .flag_o()
  );

  // Логика для управления мультиплексорами и сигналами
  always_ff @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
      next_pc <= 32'b0;
    end else begin
      // По умолчанию следующее значение PC = PC + 4
      next_pc <= pc + 4;
      
      // Логика для вычисления цели ветвления
      imm <= {{20{instruction[31]}}, instruction[31:20]};  // Пример для I-типа инструкций
      branch_target <= pc + imm;
      branch_taken <= (instruction[6:0] == 7'b1100011) && (alu_result == 0);  // Пример для B-типа инструкций
      
      if (branch_taken) begin
        next_pc <= branch_target;
      end
    end
  end

  always_ff @(posedge clk_i) begin
    // Логика для выбора источника записи в регистровый файл
    reg_write_data <= alu_result;

    // Логика для разрешения записи в регистровый файл
    reg_write_en <= (instruction[6:0] == 7'b0110011);  // Пример для R-типа инструкций

    // Логика для выбора операции АЛУ
    alu_op <= instruction[14:12];  // Пример для R-типа инструкций
  end

  // Выходной сигнал
  assign out_o = alu_result;

endmodule
