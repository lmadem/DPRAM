//config_sequence extends from base_sequence
class config_sequence extends base_sequence;
  `uvm_object_utils(config_sequence)
  
  //constructor
  function new(string name = "config_sequence");
    super.new(name);
  endfunction
  
  task body();
    begin
      `uvm_create(req);
      req.addr = 'h20; //csr3_CHIP_EN
      req.data = 'h1;
      req.kind = CSR_WRITE;
      start_item(req);
      finish_item(req);
      `uvm_info("CONFIG_SEQ", "Config CSR_WRITE sequence transaction completed\n", UVM_MEDIUM);
    end
  endtask
endclass
