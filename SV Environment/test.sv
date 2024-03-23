`include "package.sv"
program automatic test(intf vif);
  
  import memory_pkg::*;
  //`include "test1.sv"
  //`include "test2.sv"
  //`include "test3.sv"
  `include "test4.sv"
  
  //test1 t1;
  //test2 t2;
  //test3 t3;
  test4 t4;
  initial
    begin
      $display("[Program Block] Simulation Started at time=%t", $realtime);
      t4 = new(vif.tb_mod_port, vif.tb_mon_in, vif.tb_mon_out, "Test4", "TestCase4", 10);
      t4.run();
      $display("[Program Block] Simulation Started at time=%t", $realtime);
    end
  
endprogram