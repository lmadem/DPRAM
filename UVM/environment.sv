class environment extends uvm_env;
  `uvm_component_utils(environment)
  
  bit [31:0] exp_pkt_count;
  bit [31:0] m_matches,m_mismatches;
  bit [31:0] csr4_dropped_cnt;
  real tot_cov_score;
  bit cov_enable;
  
  master_agent  m_agent;
  slave_agent   s_agent;
  //scoreboard    scb;  //generic scoreboard
  //custom_scoreboard #(packet) scb; //In-order scoreboard
  out_of_order_scoreboard #(packet) scb; //out_of_order_scoreboard
  coverage      cov_comp;
  
  function new (string name="environment",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void report_phase(uvm_phase phase);
  extern virtual function void extract_phase(uvm_phase phase);
endclass	

function void environment::build_phase(uvm_phase phase);
  super.build_phase(phase);
  
  m_agent = master_agent::type_id::create("m_agent",this);
  s_agent = slave_agent::type_id::create("s_agent",this);
  //generic scoreboard
  //scb = scoreboard::type_id::create("scb",this);
  
  //Construct object for inorder_scoreboard
  //scb = custom_scoreboard#(packet)::type_id::create("scb",this);
  
  //Construct object for out_of_order_scoreboard
  scb = out_of_order_scoreboard#(packet)::type_id::create("scb", this);
    
    
  void'(uvm_config_db#(bit)::get(this,"","enable_coverage",cov_enable));
  if(cov_enable)
    cov_comp = coverage::type_id::create("cov_comp",this);
endfunction

function void environment::connect_phase(uvm_phase phase);
  m_agent.ap.connect(scb.mon_inp);
  s_agent.ap.connect(scb.mon_outp);
  if(cov_enable) 
    m_agent.ap.connect(cov_comp.analysis_export);
endfunction

function void environment::extract_phase(uvm_phase phase);
  void'(uvm_config_db#(int)::get(this,"m_agent.seqr","item_count",exp_pkt_count)); 
  void'(uvm_config_db#(int)::get(this,"","matches",m_matches));    
  void'(uvm_config_db#(int)::get(this,"","mis_matches",m_mismatches));   
  void'(uvm_config_db#(real)::get(this,"","cov_score",tot_cov_score));  
  void'(uvm_config_db#(bit [31:0])::get(this,"m_agent.seqr","dropped_count",csr4_dropped_cnt));
endfunction

function void environment::report_phase(uvm_phase phase);
  bit [31:0] tot_scb_cnt;
  tot_scb_cnt= m_matches + m_mismatches;
  if(exp_pkt_count != tot_scb_cnt) 
    begin
      `uvm_info("","******************************************",UVM_NONE);
      `uvm_info("FAIL","Test Failed due to packet count MIS_MATCH",UVM_NONE); 
      `uvm_info("FAIL",$sformatf("exp_pkt_count=%0d Received_in_scb=%0d ",exp_pkt_count,tot_scb_cnt),UVM_NONE); 
      `uvm_fatal("FAIL","******************Test FAILED ************");
    end
  else if(m_mismatches != 0) 
    begin
      `uvm_info("","******************************************",UVM_NONE);
      `uvm_info("FAIL","Test Failed due to mis_matched packets in scoreboard",UVM_NONE); 
      `uvm_info("FAIL",$sformatf("matched_pkt_count=%0d mis_matched_pkt_count=%0d ",m_matches,m_mismatches),UVM_NONE); 
      `uvm_fatal("FAIL","******************Test FAILED ***************");
    end
  else 
    begin
      `uvm_info("PASS","******************Test PASSED ***************",UVM_NONE);
      `uvm_info("PASS",$sformatf("exp_pkt_count=%0d Received_in_scb=%0d ",exp_pkt_count,tot_scb_cnt),UVM_NONE); 
      `uvm_info("PASS",$sformatf("matched_pkt_count=%0d mis_matched_pkt_count=%0d ",m_matches,m_mismatches),UVM_NONE); 
      `uvm_info("PASS",$sformatf("Coverage=%0f%%",tot_cov_score),UVM_NONE); 
      `uvm_info("PASS","******************************************",UVM_NONE);
    end
endfunction

