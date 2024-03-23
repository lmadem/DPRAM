//Test4 : Simultaneous write and read operations with same write address and read address location in the memory
`include "base_test.sv"
class test4 extends base_test;
  
  function new(input virtual intf.tb_mod_port vif_in,
               input virtual intf.tb_mon_in  vif_mon_in,
               input virtual intf.tb_mon_out  vif_mon_out,
	           string name,
               string testname,
               bit [31:0] no_of_pkts=1);
    super.new(vif_in,vif_mon_in,vif_mon_out,name,testname,no_of_pkts);
  endfunction
  
  
  virtual task run();
    $display("[%s] run started at time=%0t",this.name,$realtime);
    build();
    env.run();
    $display("[%s] run ended at time=%0t",this.name,$realtime);
  endtask

  
endclass