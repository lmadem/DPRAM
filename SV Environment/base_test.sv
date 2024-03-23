//Base_Test Class : Super Class
`include "environment.sv"
class base_test;
  string name; ////Used to identify this component throughout the simulation time
  bit [31:0] no_of_pkts; //Number of packets, incoming input from test
  virtual intf.tb_mod_port vif; //Virtual Interface
  virtual intf.tb_mon_in vif_mon_in; //Virtual Interface, iMonitor
  virtual intf.tb_mon_out vif_mon_out; //Virtual Interface, oMonitor
  string testname; //Used to identify the testcase, incoming input from test
  
  environment env; //environment instance
  
  extern function new(input virtual intf.tb_mod_port vif,
                      input virtual intf.tb_mon_in vif_mon_in,
                      input virtual intf.tb_mon_out vif_mon_out,
                      string name,
                      string testname,
                      bit [31:0] no_of_pkts);
  extern virtual function void build();
  extern virtual task run();    
endclass

//Constructor
function base_test::new(input virtual intf.tb_mod_port vif,
                        input virtual intf.tb_mon_in vif_mon_in,
                        input virtual intf.tb_mon_out vif_mon_out,
                        string name,
                        string testname,
                        bit [31:0] no_of_pkts);
  this.vif = vif;
  this.vif_mon_in = vif_mon_in;
  this.vif_mon_out = vif_mon_out;
  this.name = name;
  this.testname = testname;
  this.no_of_pkts = no_of_pkts;
endfunction
    
//build function is to build the environment class
function void base_test::build();
  env = new("Environment",testname,vif,vif_mon_in,vif_mon_out,no_of_pkts);
  env.build();
endfunction

//run function is to invoke the run task in environment class
task base_test::run();
  $display("[%s] run started at time=%t", this.name, $realtime);
  build();
  env.run();
  $display("[%s] run ended at time=%t", this.name, $realtime);
endtask
    

