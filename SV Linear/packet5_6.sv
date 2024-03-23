//This packet class is used for testcases 5 and 6
class packet5_6;
  rand bit [7:0] data_in;
  randc bit [3:0] wr_addr;
  bit [3:0] rd_addr;
  bit wr_en,rd_en;
  bit [7:0] data_out;
endclass