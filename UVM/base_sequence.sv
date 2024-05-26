//base_sequence extends from uvm_sequence; type to packet transaction class

class base_sequence extends uvm_sequence #(packet);
  bit [31:0] pkt_count;
  
  `uvm_object_utils(base_sequence)
  
  //constructor
  function new(string name = "base_sequence");
    super.new(name);
    set_automatic_phase_objection(1); //UVM-1.2
  endfunction
  
  extern virtual task pre_start();
  extern virtual task body();
  
endclass
    
task base_sequence::pre_start();
  int temp_count;
  if(!uvm_config_db #(int)::get(this.get_sequencer(), "", "item_count", pkt_count))
    begin
      `uvm_warning("Base_SEQ", "packet count is not set at sequencer level::hence generating 1 transaction")
      pkt_count = 1;                  
    end
  
endtask
    
task base_sequence::body();
  repeat(pkt_count)
    begin
      `uvm_do(req);
    end
endtask
