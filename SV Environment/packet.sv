//Packet Class
typedef enum {IDLE,RESET,STIMULUS} pkt_type; //Used to identify the packet type while driving stimulus to DUT
class packet;
  rand bit [7:0] data_in[]; //A dynamic array consists of randomized inputs of size 8-bit 
  rand bit [3:0] wr_addr[]; //A dynamic array consists of randomized inputs of size 4-bit 
  rand bit [3:0] rd_addr[]; //A dynamic array consists of randomized inputs of size 4-bit 
  bit wr_en,rd_en; //Including write and read enable control signals in the packet class
  bit [7:0] data_out; // 8-bit data out, used to capture output data signal from Output Monitor
  pkt_type kind; //Packet type
  bit [3:0] reset_cycles; //Reset Cycles, will not be randomized
  rand bit [3:0] addr; //Will be useful in testcase 3 & 4, randomized address
  rand bit [7:0] data; //Will be useful in testcase 3 & 4, randomized data
  
  bit [7:0] inp_stream[$]; //An input queue of size 8-bit for each element, will be used to capture driven packet
  bit [7:0] outp_stream[$]; //An output queue of size 8-bit for each element, will be used to capture the  packet from DUT
  string name; //Used to identify this component throughout the simulation time
  packet pkt; // Packet handle
  
  //Constraint for data_in
  constraint c1{data_in.size() == 16;
                foreach(data_in[i])
                  data_in[i] inside {[10:110]};
                unique {data_in};
                        }
  
  //Constraint for wr_addr
  constraint c2{wr_addr.size() == 16;
                foreach(wr_addr[i])
                  wr_addr[i] inside {[0:15]};
                unique {wr_addr};
                        }
  
  //Constraint for rd_addr
  constraint c3{rd_addr.size() == 16;
                foreach(rd_addr[i])
                  rd_addr[i] inside {[0:15]};
                unique {rd_addr};
                        }

  extern function new(string name);
  extern function void display(packet pkt);
  extern function void copy(packet rhs);
  extern function bit compare(packet rhs);
  
endclass

//Constructor
function packet::new(string name);
  this.name = name;
endfunction

//Function to display the packet content
function void packet::display(packet pkt);
  foreach(pkt.data_in[i])
    $write(" %h",pkt.data_in[i]);
  $display("\n");
endfunction

//Deep copy function
function void packet::copy(packet rhs);
  if(rhs == null)
    begin
      $display("[%s] Error Null object passed to copy method", this.name);
      return;
    end
  else
    begin
      this.data_in = rhs.data_in;
      this.wr_addr = rhs.wr_addr;
      this.rd_addr = rhs.wr_addr;
      this.addr = rhs.addr;
      this.data = rhs.data;
    end
endfunction
    
//Function to compare the driven packet and received packet, used in scoreboard for validating    
function bit packet::compare(packet rhs);
  bit result;
  if(this.data_in.size() != rhs.outp_stream.size)
    begin
      $display("[%s] Comparison Error", this.name);
      $display("Generated Packet size = %d :: Collected Packet size = %d", this.data_in.size(), rhs.outp_stream.size);
      $display("Input Packet:", this.data_in);
      $display("Output Packet:", rhs.outp_stream);
      result = 0;
    end
  else
    begin
      foreach(this.data_in[i])
        begin
          if(this.data_in[i] != rhs.outp_stream[i])
            begin
              $display("Comparison Error");
              $display("Exp data : %h :: Act data : %h", this.data_in[i], rhs.outp_stream[i]);
              result = 0;
            end
          else
            result = 1;
        end
      $display("Input Packet:", this.data_in);
      $display("Output Packet:", rhs.outp_stream);
    end
  return result;
endfunction