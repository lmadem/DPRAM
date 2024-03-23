//Top Module
module top();
  logic clk;
  initial clk = 0;
  always #5 clk = ~clk;
  
  intf intf_inst(clk); //Interface Instantiation
  
  //DUT Instantiation
  dpram dut_inst(.clk(clk),.reset(intf_inst.reset),.wr_en(intf_inst.wr_en),.rd_en(intf_inst.rd_en),.wr_addr(intf_inst.wr_addr),.rd_addr(intf_inst.rd_addr),.data_in(intf_inst.data_in),.data_out(intf_inst.data_out)); 
  
  //The tb_inst will used to Instantiate the SV testbench(Alltests.sv)
  testbench tb_inst(.clk(clk),.vif(intf_inst.tb_mod_port)); 
  
  //The test_inst is used to Instantiate the SV testbench(test.sv); This includes the SV environment
  //test test_inst(.vif(intf_inst.tb_mod_port));
  
 initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(1);
      $dumpvars(0,top.dut_inst);
    end
  
endmodule