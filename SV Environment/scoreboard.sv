//Scoreboard Class
class scoreboard;
  mailbox_inst driverbox; //Mailbox Instance, will be connected between input monitor and scoreboard
  mailbox_inst receiverbox; //Mailbox Instance, will be connected between output monitor and scoreboard
  packet pkt2sent; //Packet Driven :: iMonitor
  packet pkt2cmp; //Packet Collected :: oMonitor
  string name; //Used to identify this component throughout the simulation time
  string testname; //Used to identify the testcase, incoming input from test
  
  bit [31:0] pkts_received; //Used to count the number of transactions
  bit [31:0] m_matches; //Calculates the number of matches
  bit [31:0] m_mismatches; //Calculates the number of mismatches
  
  extern function new(input mailbox_inst driverbox, receiverbox, string name, string testname);
  extern virtual task run();
  extern function void report();
    
endclass
    
//Constructor
function scoreboard::new(input mailbox_inst driverbox, receiverbox,string name, string testname);
  this.driverbox = driverbox;
  this.receiverbox = receiverbox;
  this.name = name;
  this.testname = testname;
endfunction
    
//run task to obtain packets from imonitor and omonitor and do the in-order comparison
task scoreboard::run();
  $display("[%s] run started at time=%t", this.name, $realtime);
  if(testname == "TestCase3" | testname == "TestCase4")
    begin
      while(1)
        begin
          this.driverbox.peek(this.pkt2sent);
          this.receiverbox.peek(this.pkt2cmp);
          $display(pkt2sent.inp_stream);
          $display(pkt2cmp.outp_stream);
          this.pkts_received++;
          $display("[%s] Check Packet Received%d", this.name,pkts_received);
          $display("[%s] packet%d received at time=%t", this.name, this.pkts_received, $realtime);
          foreach(pkt2sent.inp_stream[i])
            begin
              if(pkt2sent.inp_stream[i] == pkt2cmp.outp_stream[i])
                begin
                  this.m_matches++;
                  $display("[%s] packet%d matched", this.name, this.pkts_received);
                end
              else
                begin
                  this.m_mismatches++;
                  $display("[%s] ERROR :: Packet%d mismatched at time=%0t",this.name,this.pkts_received,$realtime);
                end
            end 
          pkt2sent.inp_stream.delete();
          pkt2cmp.outp_stream.delete();
        end
    end
  else begin
  while(1)
    begin
      this.driverbox.peek(this.pkt2sent);
      this.receiverbox.peek(this.pkt2cmp);
      this.pkts_received++;
      $display("[%s] packet%d received at time=%t", this.name, this.pkts_received, $realtime);
      if(this.pkt2sent.compare(this.pkt2cmp))
        begin
          this.m_matches++;
          $display("[%s] packet%d matched", this.name, this.pkts_received);
        end
      else
        begin
          this.m_mismatches++;
          $display("[%s] ERROR :: Packet%d mismatched at time=%0t",this.name,this.pkts_received,$realtime);
        end
    end
  end
  $display("[%s] run ended at time=%t", this.name, $realtime);
endtask

//function to print the recieved transactions, matches, and mismatches
function void scoreboard::report();
  $display("[%s] Report: Total Packets Received=%d ",this.name,this.pkts_received); 
  $display("[%s] Report: Matches=%d Mis_Matches=%d ",this.name,this.m_matches,this.m_mismatches); 
endfunction

