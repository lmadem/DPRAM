//This is a simple DUAL-PORT RAM Design
module dpram(clk,reset,wr_en,rd_en,wr_addr,rd_addr,data_in,data_out);
  input clk; //Clock
  input reset; //Synchronous Reset
  input wr_en; //Write Enable Control Signal
  input rd_en; //Read Enable Control Signal
  input [3:0] wr_addr; //4 bit Write Address 
  input [3:0] rd_addr; //4 bit Read Address
  input [7:0] data_in; //8 bit Data In
  output reg [7:0] data_out; //8 bit Data Out
  integer i;
  
  reg [7:0] mem [15:0]; //Memory of 16 addresses and 8-bit wide
  
  always @(posedge clk)
    begin
      if(reset)
        begin
          mem[15] <= 0;
          mem[14] <= 0;
          mem[13] <= 0;
          mem[12] <= 0;
          mem[11] <= 0;
          mem[10] <= 0;
          mem[9] <= 0;
          mem[8] <= 0;
          mem[7] <= 0;
          mem[6] <= 0;
          mem[5] <= 0;
          mem[4] <= 0;
          mem[3] <= 0;
          mem[2] <= 0;
          mem[1] <= 0;
          mem[0] <= 0;
        end
      else if(wr_en)
        begin
          mem[wr_addr] <= data_in;
        end
      else
        begin
          mem[wr_addr] <= mem[wr_addr];
        end
    end
  
  always @(posedge clk)
    begin
      if(reset)
        begin
          data_out <= 0;
        end
      else if(rd_en)
        begin
          data_out <= mem[rd_addr];
        end
      else
        begin
          data_out <= data_out;
        end
    end 
endmodule   

