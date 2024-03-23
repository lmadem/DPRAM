//Output Monitor
class oMonitor;
  virtual intf.tb_mon_out vif; //Virtual Interface Instance
  mailbox_inst mbx_recvr_outbox; //Mailbox Instance, will be connected between Output Monitor and Scoreboard
  packet pkt2receive; //Packet Handle
  string name; //Used to identify this component throughout the simulation time
  string testname; //Used to identify the testcase, incoming input from test
  bit [31:0] pkts_received; //Used to count the number of collected packets in output monitor
  extern function new(string name, string testname, mailbox_inst mbx_recvr_outbox, virtual intf.tb_mon_out vif);
  extern task run();
  extern function void report();
endclass
 
//Constructor
function oMonitor::new(string name, string testname, mailbox_inst mbx_recvr_outbox, virtual intf.tb_mon_out vif);
  this.mbx_recvr_outbox = mbx_recvr_outbox;
  this.vif = vif;
  this.name = name;
  this.testname = testname;
endfunction

//run task to capture the collected output packets from DUT    
task oMonitor::run();
  bit [7:0] data[$];
  $display("[%s] run started at time=%0t ",this.name,$realtime); 
  if(testname == "TestCase3" | testname == "TestCase4") begin
    forever
      begin
        @(posedge vif.cb_mon_out.rd_en)
        while(1)
          begin
            pkt2receive = new(name);
            pkt2receive.outp_stream.delete();
            repeat(2) @(vif.cb_mon_out);
            pkt2receive.outp_stream.push_back(vif.cb_mon_out.data_out);
            mbx_recvr_outbox.put(pkt2receive);
            pkts_received++;
            $display("Component :[%s] [%s] :: data=%h", this.name, this.testname, pkt2receive.outp_stream[0]);
            $display("[%s] Sent packet%d to scoreboard outbox at time=%t ", this.name, this.pkts_received, $realtime); 
            
            begin
              packet temp;
              #0 while(mbx_recvr_outbox.num >= 1) void'(mbx_recvr_outbox.try_get(temp));
            end
            break;
          end
      end
  end
  else begin
  forever
    begin
      @(posedge vif.cb_mon_out.rd_en);
      while(1)
        begin
          if(vif.cb_mon_out.rd_en == 1'b0)
            begin
              pkt2receive = new(name);
              pkt2receive.outp_stream = data;
              mbx_recvr_outbox.put(pkt2receive);
              pkts_received++;
              pkt2receive.display(pkt2receive);
              $display("[%s] Sent packet%d to scoreboard outbox at time=%t ", this.name, this.pkts_received, $realtime); 
             
              
              begin
                packet pkt_temp;
                #0 while(mbx_recvr_outbox.num >= 1)
                  void'(mbx_recvr_outbox.try_get(pkt_temp));
              end
              
              data.delete();
              break;
            end
          data.push_back(vif.cb_mon_out.data_out);
          @(vif.cb_mon_out);
        end //end of while
    end //end of forever
  end
  $display("[%s] run ended at time=%0t ",this.name, $realtime);
endtask
 
//function to display collected packets in output monitor
function void oMonitor::report();
  $display("[%s] Report: Total Packets Received=%d ",this.name, pkts_received); 
endfunction