module data_mem(
  input  logic        clk_i,
  input  logic        mem_req_i,
  input  logic        write_enable_i,
  input  logic [31:0] addr_i,
  input  logic [31:0] write_data_i,
  output logic [31:0] read_data_o
);

logic [31:0] RAM [0:1023]; 

always_ff @(posedge clk_i) begin

    if (mem_req_i)
        begin
            if (addr_i > 16383)
                read_data_o <= 32'hdead_beef;
                
            else
            begin
                if (write_enable_i)
                    begin
                        RAM[addr_i / 4] <= write_data_i;
                        read_data_o <= 32'hfa11_1eaf;
                    end
                else
                    begin
                        read_data_o <= RAM[addr_i / 4];
                    end
            end
        end
    else
        read_data_o <= 32'hfa11_1eaf;
        
end
endmodule