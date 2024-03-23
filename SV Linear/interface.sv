//Interface
interface intf(input clk);
  logic clk;
  logic reset;
  logic wr_en,rd_en; //wr_en = 1 for enable and 0 for disable
  logic [3:0] wr_addr,rd_addr; //rd_en = 1 for enable and 0 for disable
  logic [7:0] data_in;
  logic [7:0] data_out;
  
  //Clocking Block; Directions are w.r.t testbench
  clocking cb@(posedge clk);  
    default input #0ns output #0ns;
    output wr_en,rd_en,wr_addr,rd_addr,data_in;
    input data_out;
  endclocking
  
  //Clocking Block : Input Monitor
  clocking cb_mon_in@(posedge clk);
    default input #0ns;
    input wr_en,rd_en,wr_addr,rd_addr,data_in;
  endclocking
  
  //Clocking Block : Output Monitor
  clocking cb_mon_out@(posedge clk);
    default input #0ns;
    input wr_en,rd_en,wr_addr,rd_addr,data_out;
  endclocking
  
  //Modport for specifying directions
  modport tb_mod_port(clocking cb,output reset);
  modport tb_mon_in  (clocking cb_mon_in);
  modport tb_mon_out  (clocking cb_mon_out);

endinterface