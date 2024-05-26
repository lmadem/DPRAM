//in_order_sequence by extending from base_sequence
class in_order_sequence extends base_sequence;
  `uvm_object_utils(in_order_sequence)
  
  //rand variable addr to generate unique address for write operation
  rand bit [3:0] addr;
  
  //queue to store generated addr values (on addr) for read operation
  bit [3:0] q_addr[$];
  
  //custom constructor
  function new (string name="in_order_sequence");
	super.new(name);
  endfunction

  
  task body();
    bit [31:0] count;
    REQ rand_pkt;
    rand_pkt = packet::type_id::create("rand_pkt",,get_full_name());
    //Generate WRITE stimulus for WRITE operation into DUT
    repeat(pkt_count) 
      begin
        `uvm_create(req);
        void'(rand_pkt.randomize());
        req.copy(rand_pkt);
        //Generate unique address for WRITE operation
        void'(this.randomize() with {!(addr inside {q_addr});});
        //Store the generated addr value in q_addr for read operation
        q_addr.push_back(addr);
        
        //Assign generated addr to req.addr for WRITE operation
        req.addr = addr;
        
        //Enable WRITE operation and disable READ operation
        req.wr = 1;
        req.rd = 0;
        
        start_item(req);
        finish_item(req);
        count++;
        `uvm_info("WRITE", $sformatf("Write Transactionn %0d Completed with addr=%0d", count, req.addr), UVM_MEDIUM);
      end
    
    //Shuffle the address so it becomes out of order addr 
    //q_addr.shuffle();
    count = 0;
    
    //Generate READ stimulus for READ operation into DUT
    repeat(pkt_count) 
      begin
        `uvm_create(req);
        //Assign addr values from q_addr to req.addr for READ operation
        req.addr = q_addr.pop_front();
        
        //Enable READ operation and disable WRITE operation
        req.rd = 1;
        req.wr = 0;
        
        start_item(req); 
        finish_item(req);
        count++;
        `uvm_info("READ",$sformatf("Read Transaction %0d Completed addr=%0d",count,req.addr),UVM_MEDIUM);
      end
  endtask

endclass
