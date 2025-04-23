`timescale 1ns / 1ps

/* -----------------------------------------------------------------------------
* Project Name   : Architectures of Processor Systems (APS) lab work
* Organization   : National Research University of Electronic Technology (MIET)
* Department     : Institute of Microdevices and Control Systems
* Author(s)      : Nikita Bulavin
* Email(s)       : nekkit6@edu.miet.ru

See https://github.com/MPSU/APS/blob/master/LICENSE file for licensing details.
* ------------------------------------------------------------------------------
*/
`timescale 1ns / 1ps
module individual_task_tb();
    
    reg clk;
    reg rst;

    processor_system_11 DUT(
    .clk_i(clk),
    .rst_i(rst)
    );
//################################################################################
//      logic         write_enable;
//      logic [4:0]   read_addr1;  
//      logic [4:0]   read_addr2;   
//      logic [4:0]   write_addr;  
//      logic [31:0]  write_data; 
//      logic [31:0]  read_data1;  
//      logic [31:0]  read_data2;
      
//       assign write_enable = DUT.core.RF.write_enable_i;  
//       assign read_addr1 = DUT.core.RF.read_addr1_i;  
//       assign read_addr2 = DUT.core.RF.read_addr2_i;  
//       assign write_addr = DUT.core.RF.write_addr_i;  
//       assign write_data = DUT.core.RF.write_data_i;  
//       assign read_data1 = DUT.core.RF.read_data1_o;  
//       assign read_data2 = DUT.core.RF.read_data2_o;  
//################################################################################
// processor CORE
        logic [31:0] RD2;
        logic [31:0] result_o;
        logic [31:0] PC;
//      logic [31:0] mem_addr;
//      logic [ 2:0] mem_size;
//      logic        mem_req;
//      logic        mem_we;
      logic [31:0] WD;
        logic [31:0] instr;   
//      logic [31:0] mem_rd;
    
    assign RD2 = DUT.core.mem_wd_o;
    assign result_o = DUT.core.mem_addr_o;
    assign PC = DUT.core.instr_addr_o;
    assign instr = DUT.core.instr_i;
    assign WD = DUT.core.WD;
//################################################################################
//alu
//    logic [31:0]  b_i;
//    logic [31:0]  a_i;
//    logic [4:0]   alu_op_i;
//    logic [31:0]  result_o;
//    logic         flag_o;
    
//    assign a_i = DUT.core.ALU.a_i;
//    assign b_i = DUT.core.ALU.b_i;
//    assign alu_op_i = DUT.core.ALU.alu_op_i;
//    assign result_o = DUT.core.ALU.result_o;
//    assign flag_o = DUT.core.ALU.flag_o;


  initial clk = 0;
    always #10 clk = ~clk;
    initial begin
      $display( "\nTest has been started.");
      rst = 1;
      #40;
      rst = 0;
      #800;
      $display("\n The test is over \n See the internal signals of the module on the waveform \n");
      $finish;
      #5;
        $display("You're trying to run simulation that has finished. Aborting simulation.");
      $fatal();
  end

stall_seq: assert property (
    @(posedge DUT.core.clk_i) disable iff ( DUT.core.rst_i )
    DUT.core.mem_req_o |-> (DUT.core.stall_i || $past(DUT.core.stall_i))
)else $error("\nincorrect implementation of stall signal\n");

stall_seq_fall: assert property (
  @(posedge DUT.core.clk_i) disable iff ( DUT.core.rst_i )
    (DUT.core.stall_i) |=> !DUT.core.stall_i
)else $error("\nstall must fall exact one cycle after rising\n");
endmodule
