`include "mem_env_pkg.sv"
program mem_program(memory_if pif);

import uvm_pkg::*;
import mem_env_pkg::*;

`include "base_test.sv"
`include "mem_test.sv"
`include "in_order_test.sv"
`include "out_of_order_test.sv"

initial begin
  $timeformat(-9, 1, "ns", 10);

  uvm_config_db#(virtual memory_if)::set(null,"uvm_test_top","master_if",pif);
  
 run_test();

end

endprogram

