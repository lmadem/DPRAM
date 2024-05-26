package mem_env_pkg;

typedef enum {STIMULUS,RESET,WRITE,READ,CSR_WRITE,CSR_READ} pkt_type_e;
typedef enum {OK,ERROR} slv_response_type_e;

// UVM class library compiled in a package
import uvm_pkg::*;
`include "uvm_macros.svh"


//transaction class
`include "packet.sv"

//sequences
`include "base_sequence.sv"
`include "reset_sequence.sv"
`include "config_sequence.sv"
`include "wr_sequence.sv"
`include "in_order_sequence.sv"
`include "out_of_order_sequence.sv"
`include "shutdown_sequence.sv"

//components
`include "sequencer.sv"
`include "driver.sv"
`include "iMonitor.sv"

`include "oMonitor.sv"

`include "master_agent.sv"

`include "slave_agent.sv"

`include "coverage.sv"

`include "scoreboard.sv"

`include "custom_scoreboard.sv"

`include "out_of_order_scoreboard.sv"

`include "environment.sv"

endpackage 
