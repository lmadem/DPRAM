//Environment Class
class environment;
  bit [31:0] no_of_pkts; //Number of packets, incoming input from test
  
  virtual intf.tb_mod_port vif; //Virtual Interface
  virtual intf.tb_mon_in vif_mon_in; //Virtual Interface, iMonitor
  virtual intf.tb_mon_out vif_mon_out; //Virtual Interface, oMonitor
  
  mailbox_inst mbx_gen_drv; //will be connected to generator and driver
  mailbox_inst mbx_imon_scbin; //will be connected to iMonitor and Scoreboard Inbox
  mailbox_inst mbx_omon_scbout; //will be connected to oMonitor and Scoreboard Outbox
  string name; //Used to identify this component throughout the simulation time
  string testname; //Used to identify the testcase, incoming input from test
  
  generator gen; //generator instance
  driver drv; //driver instance
  iMonitor mon_in; //iMonitor instance
  oMonitor mon_out; //oMonitor instance
  scoreboard scb; //Scoreboard instance
  
  extern function new(string name,
                      string testname,
                      input virtual intf.tb_mod_port vif,
                      input virtual intf.tb_mon_in vif_mon_in,
                      input virtual intf.tb_mon_out vif_mon_out,
                      input [31:0] no_of_pkts);
  
  extern function void build();
  extern virtual task run();
  extern function void report();
endclass
 
//Constructor   
function environment::new(string name,
                          string testname,
                          input virtual intf.tb_mod_port vif,
                          input virtual intf.tb_mon_in vif_mon_in,
                          input virtual intf.tb_mon_out vif_mon_out,
                          input [31:0] no_of_pkts);
  this.name = name;
  this.testname = testname;
  this.vif = vif;
  this.vif_mon_in = vif_mon_in;
  this.vif_mon_out = vif_mon_out;
  this.no_of_pkts = no_of_pkts;

endfunction
    
//Build function is to establish the connection between components
function void environment::build();
  $display("[%s] build started at time=%t", this.name, $realtime);
  mbx_gen_drv = new(1);
  mbx_imon_scbin = new;
  mbx_omon_scbout = new;
  gen = new("Generator",testname,mbx_gen_drv,no_of_pkts);
  drv = new("Driver",testname,mbx_gen_drv,vif);
  mon_in = new("iMonitor",testname,mbx_imon_scbin,vif_mon_in);
  mon_out = new("oMonitor",testname,mbx_omon_scbout,vif_mon_out);
  scb = new(mbx_imon_scbin,mbx_omon_scbout,"Scoreboard",testname);
  $display("[%s] build ended at time=%t", this.name, $realtime);
endfunction

//run task to trigger the run and start tasks in components
task environment::run();
  $display("[%s] run started at time=%t", this.name, $realtime);
  fork
    gen.start();
    drv.run();
    mon_in.run();
    mon_out.run();
    scb.run();
  join_any
  
  wait(scb.pkts_received == no_of_pkts);
  repeat(10) @(vif.cb);
  report();
  $display("[%s] run ended at time=%t", this.name, $realtime);
endtask
    
//function to invoke the report function in components
function void environment::report();
  $display("\n[%s] ****** Report Started **********",this.name); 
  gen.report();
  drv.report();
  mon_in.report();
  mon_out.report();
  scb.report();
  
  $display("\n*****************************************"); 
  if(scb.m_mismatches ==0 && (no_of_pkts == scb.pkts_received))
    begin
      $display("***********TEST PASSED ************ ");
      $display("Matches=%0d Mis_matches=%0d",scb.m_matches,scb.m_mismatches); 
    end
  else 
    begin
      $display("*********TEST FAILED ************ "); 
      $display("Matches=%0d Mis_matches=%0d",scb.m_matches,scb.m_mismatches); 
    end
  $display("****************************************\n "); 
  
  $display("[Environment] ******** Report ended******** \n"); 
endfunction