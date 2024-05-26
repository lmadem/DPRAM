//shutdown_sequence extends from base_sequence
class shutdown_sequence extends base_sequence;
  `uvm_object_utils(shutdown_sequence)
  
  bit [31:0] csr_dropped;
  
  //constructor
  function new(string name = "shutdown_sequence");
    super.new(name);
  endfunction
  
  extern virtual task body();
endclass
    
    
    
task shutdown_sequence::body();
  `uvm_create(req);
  req.addr = 'h26; //addr of csr4_dropped_register
  req.kind = CSR_READ;
  start_item(req);
  finish_item(req);
  csr_dropped = req.data;
  uvm_config_db#(bit [31:0])::set(get_sequencer(), "", "dropped_count", csr_dropped);
  `uvm_info("SHUTDOWN_SEQ", $sformatf("csr_dropped_count = %0d", req.data), UVM_MEDIUM);
  `uvm_info("SHUTDOWN_SEQ", "Shutdown Sequence CSR_READ Completed", UVM_MEDIUM);
endtask
