//Input Monitor Class
//Developed a robust Input Monitor to handle multiple cases
class iMonitor;
  virtual intf.tb_mon_in vif; //Virtual Interface Instance
  mailbox_inst mbx_imon_outbox; //Mailbox Instance, will be connected between Input Monitor and Scoreboard
  packet pkt2sent; //Packet Handle
  bit [31:0] pkts_sent; //Used to count the number of collected packets in input monitor
  string name; ///Used to identify this component throughout the simulation time
  string testname; //Used to identify the testcase, incoming input from test
  
  extern function new(string name, string testname, mailbox_inst mbx_imon_outbox,  virtual intf.tb_mon_in vif);
  extern virtual task run();
  extern function void report();
endclass

//Constructor
function iMonitor::new(string name, string testname, mailbox_inst mbx_imon_outbox,  virtual intf.tb_mon_in vif);
  this.name = name;
  this.testname = testname;
  this.mbx_imon_outbox = mbx_imon_outbox;
  this.vif = vif;
endfunction
    
//run task to capture the driven input packets into DUT
task iMonitor::run();
  bit [7:0] data[$];
  $display("[%s] run started at time=%0t ",this.name,$realtime); 
  if(testname == "TestCase3" | testname == "TestCase4") begin
    forever
      begin
        @(posedge vif.cb_mon_in.wr_en);
        begin
          while(1)
            begin
              pkt2sent = new(name);
              pkt2sent.inp_stream.delete();
              @(vif.cb_mon_in);
              pkt2sent.inp_stream.push_back(vif.cb_mon_in.data_in);
              mbx_imon_outbox.put(pkt2sent);
              this.pkts_sent++;
              $display("Component :[%s] [%s] :: data=%h", this.name, this.testname, pkt2sent.inp_stream[0]);
              $display("[%s] Sent packet%d to scoreboard inbox at time=%t ", this.name, this.pkts_sent, $realtime);
              begin
                packet temp;
                #0 while(mbx_imon_outbox.num >= 1) void'(mbx_imon_outbox.try_get(temp));
              end
              break;
            end
        end
      end
  end
  else begin
  forever
    begin
      @(posedge vif.cb_mon_in.wr_en);
      while(1)
        begin
          if(vif.cb_mon_in.wr_en == 1'b0)
            begin
              pkt2sent = new(name);
              pkt2sent.data_in = data;
              mbx_imon_outbox.put(pkt2sent);
              this.pkts_sent++;
              pkt2sent.display(pkt2sent);
              $display("[%s] Sent packet%d to scoreboard inbox at time=%t ", this.name, this.pkts_sent, $realtime); 
              
              begin
                packet pkt_temp;
                #0 while(mbx_imon_outbox.num >= 1)
                  void'(mbx_imon_outbox.try_get(pkt_temp));
              end
              
              data.delete();
              break;
            end
          data.push_back(vif.cb_mon_in.data_in);
          @(vif.cb_mon_in);
        end //end of while
    end //end of forever
  end
  $display("[%s] run ended at time=%0t ",this.name, $realtime);
endtask
    
//function to display collected packets in input monitor
function void iMonitor::report();
  $display("[%s] Report: Total Packets Received=%d ",this.name, pkts_sent); 
endfunction
    
    
