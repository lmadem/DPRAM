//top module
`include "mem_interface.sv"
`include "program_mem.sv"

module top;
  //parameters for address width, data width, and memory size
  parameter reg [15:0] ADDR_WIDTH = 8;
  parameter reg [15:0] DATA_WIDTH = 32;
  parameter reg [15:0] MEM_SIZE = 16;
  
  //clock declaration
  bit clk;
  
  //clock generation
  always #5 clk = ~clk;
  
  //DUT Instanstiation
  memory_if #(ADDR_WIDTH, DATA_WIDTH, MEM_SIZE) mem_if(clk);
  
  memory_rtl #(ADDR_WIDTH, DATA_WIDTH, MEM_SIZE) dut_inst(.clk(clk),
                                                          .reset(mem_if.reset),
                                                          .wr(mem_if.wr),
                                                          .rd(mem_if.rd),
                                                          .addr(mem_if.addr),
                                                          .wdata(mem_if.wdata),
                                                          .rdata(mem_if.rdata),
                                                          .response(mem_if.slv_rsp)
                                                         );
  mem_program ptest(mem_if);
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(0,top.dut_inst);
    end
endmodule
