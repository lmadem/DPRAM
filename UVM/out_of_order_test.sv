class out_of_order_test extends base_test;
  `uvm_component_utils(out_of_order_test)
  bit [31:0] pkt_count;
  
  function new (string name="out_of_order_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  //Implement build phase to configure sequence
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    //Set packet count
    pkt_count = 16;

    //Set(configure) packet count to sequence
    uvm_config_db#(int)::set(this, "env.m_agent.seqr", "item_count", pkt_count);
    

    //Set(configure) total packet count to environment for test PASS and FAIL
    uvm_config_db#(int)::set(this, "env", "tot_pkt_count", pkt_count);
    
    uvm_config_db#(bit)::set(this,"env.m_agent.drvr", "set_resp_for_drvr", 1'b0);
        
    
    //Configure inorder_sequence to seqr's main_phase
    uvm_config_db#(uvm_object_wrapper)::set(this,"env.m_agent.seqr.main_phase","default_sequence",out_of_order_sequence::get_type());
  endfunction
        
endclass	
