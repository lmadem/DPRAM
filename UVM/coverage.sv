//coverage component

class coverage extends uvm_subscriber#(packet);
  `uvm_component_utils(coverage)
  
  real coverage_score;
  packet pkt;
  
  covergroup cov_mem with function sample(packet pkt);
    coverpoint pkt.addr {
      bins addr[] = {[0:15]};
    }
  endgroup
  
  //constructor
  function new(string name = "coverage", uvm_component parent);
    super.new(name, parent);
    cov_mem = new;
  endfunction
  
  virtual function void write(T t);
    if(!$cast(pkt, t.clone))
      begin
        `uvm_fatal("COV", "Transaction object is NULL in coverage component");
      end
    
    cov_mem.sample(pkt);
    coverage_score = cov_mem.get_coverage();
    
    `uvm_info("COV", $sformatf("Coverage = %0f%%", coverage_score), UVM_MEDIUM);
  endfunction 
  
  virtual function void extract_phase(uvm_phase phase);
    uvm_config_db#(real)::set(null, "uvm_test_top.env", "cov_score", coverage_score);
  endfunction
endclass
