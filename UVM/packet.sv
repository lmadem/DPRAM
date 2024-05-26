`define AWIDTH 8
`define DWIDTH 32
//Transaction class - packet
class packet extends uvm_sequence_item;
  rand logic [`AWIDTH - 1 : 0] addr;
  rand logic [`DWIDTH - 1 : 0] data;
  
  bit wr = 1; //write enable
  bit rd = 1; //read enable
  
  pkt_type_e kind;
  slv_response_type_e slv_rsp;
  
  bit [`AWIDTH - 1 : 0] prev_addr;
  bit [`DWIDTH - 1 : 0] prev_data;
  
  constraint valid {
    addr inside {[0:15]};
    data inside {[10:9999]};
    data != prev_addr;
    addr != prev_addr;
  }
  
  function void post_randomize();
    prev_addr = addr;
    prev_data = data;
  endfunction
  
  `uvm_object_utils_begin(packet)
  `uvm_field_int(addr, UVM_ALL_ON)
  `uvm_field_int(data, UVM_ALL_ON)
  `uvm_object_utils_end
  
  virtual function string convert2string();
    return $sformatf("addr = %0d, data = %0d", addr, data);
  endfunction
  
  //standard custom constructor
  function new(string name = "packet");
    super.new(name);
  endfunction
endclass
