//Generator Class
class generator;
  mailbox_inst mbx_gen_outbox; //Mailbox Instance, will be connected to driver and generator
  packet pkt_gen; //Packet handle, used for randomization
  packet pkt; //Packet handle, used for deep copy
  string name; //Used to identify this component throughout the simulation time
  string testname; //Used to identify the testcase, incoming input from test
  bit [31:0] no_of_pkts; //Incoming input from test
  bit [31:0] pkt_count; // Used to count the randomized packets generated in generator
  
  extern function new(string name, string testname, mailbox_inst mbx_gen_outbox, bit [31:0] no_of_pkts=1);
  extern virtual task gen();
  extern virtual task start();
  extern function void report();
endclass
    
//Constructor
function generator::new(string name, string testname, mailbox_inst mbx_gen_outbox, bit [31:0] no_of_pkts=1);
  this.name = name;
  this.testname = testname;
  this.no_of_pkts = no_of_pkts;
  this.mbx_gen_outbox = mbx_gen_outbox;
  this.pkt_gen = new(name);
endfunction
    
//Based on the input:testname, the task::gen() randomizes the packet   
task generator::gen();
  if(testname == "TestCase1")
    begin
      this.pkt_gen.wr_addr.rand_mode(0);
      this.pkt_gen.rd_addr.rand_mode(0);
      this.pkt_gen.addr.rand_mode(0);
      this.pkt_gen.data.rand_mode(0);
      this.pkt_gen.c2.constraint_mode(0);
      this.pkt_gen.c3.constraint_mode(0);
      if(!this.pkt_gen.randomize())
        begin
          $display("Randomization Failed");
          $finish;
        end
      else
        begin
          $display("[%s] Randomization Successful",this.name);
          this.pkt_gen.display(pkt_gen);
        end
    end
  else if(testname == "TestCase2")
    begin
      this.pkt_gen.addr.rand_mode(0);
      this.pkt_gen.data.rand_mode(0);
      if(!this.pkt_gen.randomize())
        begin
          $display("Randomization Failed");
          $finish;
        end
      else
        begin
          $display("[%s] Randomization Successful",this.name);
          this.pkt_gen.display(pkt_gen);
        end
    end
  else if(testname == "TestCase3" | testname == "TestCase4")
    begin
      this.pkt_gen.wr_addr.rand_mode(0);
      this.pkt_gen.rd_addr.rand_mode(0);
      this.pkt_gen.data_in.rand_mode(0);
      this.pkt_gen.c1.constraint_mode(0);
      this.pkt_gen.c2.constraint_mode(0);
      this.pkt_gen.c3.constraint_mode(0);
      if(!this.pkt_gen.randomize())
        begin
          $display("Randomization Failed");
          $finish;
        end
      else
        begin
          $display("[%s] Randomization Successful",this.name);
          $display("[%s] Randomized Packet",this.testname);
          $display("addr = %d, data=%h", pkt_gen.addr, pkt_gen.data);
        end
    end
endtask
    
//Task to generate stimuli and place it in the mailbox for driver
task generator::start();
  $display("[%s] Started at %t", this.name, $realtime);
  //Sending first packet as Reset Packet
  pkt = new(name);
  pkt.kind = RESET;
  pkt.reset_cycles = 3;
  $display("[%s] Sending [%s] packet to driver at time=%t",this.name, pkt.kind.name(),$realtime);
  mbx_gen_outbox.put(pkt);
  
  //Generating the normal stimuli
  repeat(no_of_pkts) 
    begin
      if(testname == "TestCase3" | testname == "TestCase4")
         begin
           this.gen();
           pkt = new(name);
           pkt.copy(pkt_gen);
           pkt.kind = STIMULUS;
           mbx_gen_outbox.put(pkt);
           pkt_count++;
           $display("[%s] Check",this.name);
           $display("Packet %d :: %p", pkt_count,pkt);
           $display("[%s] outbox is %d", this.name, this.mbx_gen_outbox.num());
           $display("[%s] Sent [%s] packet%d to driver at time=%t",this.name, pkt.kind.name(),pkt_count,$realtime);
         end
      else
        begin
          this.gen();
          pkt = new(name);
          pkt.copy(pkt_gen);
          pkt.kind = STIMULUS;
          mbx_gen_outbox.put(pkt);
          pkt_count++;
          $display("[%s] outbox is %d", this.name, this.mbx_gen_outbox.num());
          $display("[%s] Sent [%s] packet%d to driver at time=%t",this.name, pkt.kind.name(),pkt_count,$realtime); 
        end
    end
  $display("[%s] Ended at %t", this.name, $realtime);
endtask    
    
//Function to display the no of packets driven from test    
function void generator::report();
  $display("[%s] Report : Total Packets Generated : %d", this.name, this.no_of_pkts);
endfunction


