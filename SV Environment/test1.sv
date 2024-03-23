//Test1 : driving one full packet(covering all the address locations linearly in the memory) and performing write operation followed by read operation.

//Test2 : driving a bunch of packets(each packet covers the write opeartion followed by read operation for all the address locations linearly in the memory)

//The test1 class implements testcase1 and testcase2
`include "base_test.sv"
class test1 extends base_test;
  
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