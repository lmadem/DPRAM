//Test5 : driving full packet(covering all the address locations randomly in the memory) and performing write operation followed by read operation

//Test6 : driving a bunch of packets(each packet covers the write and read operation for all the address locations randomly in the memory)

//The class test2 implements testcase5 and testcase6
`include "base_test.sv"
class test2 extends base_test;
  
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