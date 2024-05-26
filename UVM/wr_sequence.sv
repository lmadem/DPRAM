//wr_sequence extends from base_sequence
class wr_sequence extends base_sequence;
  `uvm_object_utils(wr_sequence)
  
  //constructor
  function new (string name="wr_sequence");
	super.new(name);
  endfunction
  
  
  task body();
    bit [31:0] count;
    REQ rand_pkt;
    rand_pkt=packet::type_id::create("rand_pkt",,get_full_name());
    repeat(pkt_count) 
      begin
        `uvm_create(req);
        void'(rand_pkt.randomize());
        req.copy(rand_pkt);
        start_item(req);
        finish_item(req);
        get_response(rsp);
        count++;
        `uvm_info("WR_SEQ",$sformatf("Transaction %0d Completed with response=%0s \n",count, rsp.slv_rsp.name()),UVM_MEDIUM);
      end
  endtask

endclass

