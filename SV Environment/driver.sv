//Driver Class
//Created a robust driver to handle mutliple tests
class driver;
  virtual intf.tb_mod_port vif; //Virtual Interface Instance
  mailbox_inst mbx_drv_inbox; // Mailbox Instance, will be connected to driver and generator
  packet pkt2send; //Packet handle
  bit [31:0] no_of_pkts_recvd; //Used to count the no of packets received from generator
  string name; //Used to identify this component throughout the simulation time
  string testname; //Used to identify the testcase, incoming input from test
  
  extern function new(string name, string testname, mailbox_inst mbx_drv_inbox, virtual intf.tb_mod_port vif);
  extern virtual task run();
  extern virtual task drive(packet pkt2send);
  extern virtual task drive_reset(packet pkt2send);
  extern virtual task drive_stimulus(packet pkt2send);
  extern virtual task write(packet pkt2send);
  extern virtual task read(packet pkt2send);
  extern virtual task writeread(packet pkt2send);
  extern virtual task write_read(packet pkt2send);
  extern function void report();
endclass
    
//Constructor
function driver::new(string name, string testname, mailbox_inst mbx_drv_inbox, virtual intf.tb_mod_port vif);
  this.name = name;
  this.testname = testname;
  this.mbx_drv_inbox = mbx_drv_inbox ;
  this.vif = vif;
endfunction
    
//The run task will obtain the packet from generator and invoke other tasks   
task driver::run();
  $display("[%s] started at time=%t",this.name,$realtime);
    forever
      begin
        this.mbx_drv_inbox.get(pkt2send);
        no_of_pkts_recvd++;
        $display("[%s] Check", this.name);
        $display(pkt2send);
        $display("Packets %d :: addr = %d, data = %h", no_of_pkts_recvd, pkt2send.addr, pkt2send.data);
        $display("[%s] Inbox %d\n", this.name, this.mbx_drv_inbox.num());
        $display("[%s] Received  [%s] packet%d from generator at time=%t", this.name, pkt2send.kind.name(),no_of_pkts_recvd,$realtime); 
        drive(pkt2send);
        $display("[%s] Done with [%s] packet%d from generator at time=%t", this.name, pkt2send.kind.name(),no_of_pkts_recvd,$realtime); 
      end
  $display("[%s] ended at time=%t",this.name,$realtime);
endtask 

//drive task will trigger tasks based on packet type
task driver::drive(packet pkt2send);
  case(pkt2send.kind)
      RESET : drive_reset(pkt2send);
      STIMULUS : drive_stimulus(pkt2send);
    default : $display("[%s] [Error] unknown packet received in %s", this.name, this.name);
  endcase
endtask

//drive_reset task is to drive reset transaction into DUT
task driver::drive_reset(packet pkt2send);
  $display("[%s] Driving [%s] transaction into DUT at time=%t",this.name, this.pkt2send.kind.name(),$realtime); 
  vif.reset <= 1'b1;
  repeat(pkt2send.reset_cycles) @(vif.cb);
  vif.reset <= 1'b0;
  $display("[%s] Driving [%s] transaction completed at time=%t",this.name, this.pkt2send.kind.name(),$realtime); 
endtask
    
//drive_stimulus task is to drive stimulus into DUT 
task driver::drive_stimulus(packet pkt2send);
  if(testname == "TestCase3") 
    writeread(pkt2send);
  else if(testname == "TestCase4")
    write_read(pkt2send);
  else
    begin
      write(pkt2send);
      read(pkt2send);
    end
endtask
 
//write task is to perform write operation
task driver::write(packet pkt2send);
  $display("[%s] write operation started at time=%0t",this.name,$realtime);
  vif.cb.wr_en <= 1'b1;
  for(int i=0; i<pkt2send.data_in.size(); i++)
    begin
      if(testname == "TestCase1")
        begin
          vif.cb.wr_addr <= i;
          vif.cb.data_in <= pkt2send.data_in[i];
          @(vif.cb);
        end
      else if(testname == "TestCase2")
        begin
          vif.cb.wr_addr <= pkt2send.wr_addr[i];
          vif.cb.data_in <= pkt2send.data_in[i];
          @(vif.cb);
        end
    end
  vif.cb.wr_en <= 1'b0;
  $display("[%s] write operation ended at time=%0t",this.name,$realtime); 
endtask
    
//read task is to perform read operation
task driver::read(packet pkt2send);
  @(vif.cb);
  $display("[%s] read operation started at time=%0t",this.name,$realtime);
  vif.cb.rd_en <= 1'b1;
  for(int i=0; i<pkt2send.data_in.size(); i++)
    begin
      if(testname == "TestCase1")
        begin
          vif.cb.rd_addr <= i;
          @(vif.cb);
        end
      else if(testname == "TestCase2")
        begin
          vif.cb.rd_addr <= pkt2send.rd_addr[i];
          @(vif.cb);
        end
    end
  vif.cb.rd_en <= 1'b0;
  $display("[%s] write operation ended at time=%0t",this.name,$realtime); 
endtask

//writeread task is to perform simultaneous writeread operation, used for testcase3
task driver::writeread(packet pkt2send);
  @(vif.cb);
  vif.cb.wr_en <= 1'b1;
  vif.cb.rd_en <= 1'b1;
  repeat(2)
    begin
      vif.cb.wr_addr <= 4'h8;
      vif.cb.rd_addr <= 4'h8;
      vif.cb.data_in <= pkt2send.data;
      @(vif.cb);
    end
  vif.cb.wr_en <= 1'b0;
  vif.cb.rd_en <= 1'b0;
  //@(vif.cb);
endtask
    
//write_read task is to perform simultaneous writeread operation, used for testcase4
task driver::write_read(packet pkt2send);
  @(vif.cb);
  vif.cb.wr_en <= 1'b1;
  vif.cb.rd_en <= 1'b1;
  repeat(2)
    begin
      vif.cb.wr_addr <= pkt2send.addr;
      vif.cb.rd_addr <= pkt2send.addr;
      vif.cb.data_in <= pkt2send.data;
      @(vif.cb);
    end
  vif.cb.wr_en <= 1'b0;
  vif.cb.rd_en <= 1'b0;
  //@(vif.cb);
endtask
    
//function to display the number of received from generator
function void driver::report();
  $display("[%s] Report: Total Packets Driven = %d ",this.name,no_of_pkts_recvd); 
endfunction



    
