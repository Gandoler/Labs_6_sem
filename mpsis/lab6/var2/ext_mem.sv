module ext_mem(
  input  logic        clk_i,
  input  logic        mem_req_i,
  input  logic        write_enable_i,
  input  logic [ 3:0] byte_enable_i,
  input  logic [31:0] addr_i,
  input  logic [31:0] write_data_i,
  output logic [31:0] read_data_o,
  output logic        ready_o
);

logic [31:0] read_data;

assign ready_o = 1'b1;


logic [31:0] ram [1024];

logic [31:0] addr;
assign addr = addr_i >> 2;

always_ff @(posedge clk_i) begin
  if(!mem_req_i | write_enable_i) begin
    read_data_o <= 32'hfa11_1eaf;
  end
  else if (addr < 32'd1024) begin
    read_data_o <= read_data;
  end
  else begin
    read_data_o <= 32'hdead_beaf;
  end
end

always_comb begin
  if(mem_req_i) begin
    read_data <= ram[addr];
  end
  else begin
    read_data <= 32'd0;
  end
end

always_ff @(posedge clk_i) begin
  if(mem_req_i) begin
    if(write_enable_i && byte_enable_i[0])
      ram [addr_i[31:2]] [7:0]  <= write_data_i[7:0];
    if(write_enable_i && byte_enable_i[1])
      ram [addr_i[31:2]] [15:8] <= write_data_i[15:8];
    if(write_enable_i && byte_enable_i[2])
      ram [addr_i[31:2]] [23:16] <= write_data_i[23:16];
    if(write_enable_i && byte_enable_i[3])
      ram [addr_i[31:2]] [31:24] <= write_data_i[31:24];
  end
end

endmodule
