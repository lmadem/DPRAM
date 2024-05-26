//custom scoreboard component - In order sequences

class custom_scoreboard #(type T=packet) extends uvm_scoreboard;
  typedef custom_scoreboard #(T) scb_type;
  `uvm_component_param_utils(scb_type)
  
  //The $typename system function returns a string that represents the resolved type of its argument
  const static string type_name = $sformatf("custom_scoreboard#(%0s)", $typename(T));
  
  virtual function string get_type_name();
    return type_name;
  endfunction
  
  `uvm_analysis_imp_decl(_inp)
  `uvm_analysis_imp_decl(_outp)
  
  uvm_analysis_imp_inp #(T, scb_type) mon_inp;
  uvm_analysis_imp_outp #(T, scb_type) mon_outp;
  
  T q_in[$];
  bit [31:0] m_matches, m_mismatches;
  bit [31:0] tot_pkt_recvd;
  
  function new(string name = "custom_scoreboard", uvm_component parent=null);
    super.new(name, parent);
    `uvm_info(get_type_name(), "NEW custom scoreboard", UVM_NONE);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon_inp = new("mon_inp", this);
    mon_outp = new("mon_outp", this);
  endfunction
  
  virtual function void write_inp(T pkt);
    T pkt_in;
    $cast(pkt_in, pkt.clone());
    q_in.push_front(pkt_in);
  endfunction
  
  virtual function void write_outp(T recvd_pkt);
    T ref_pkt;
    tot_pkt_recvd++;
    ref_pkt = q_in.pop_back();
    if(ref_pkt.compare(recvd_pkt))
      begin
        m_matches++;
        `uvm_info("SCB", $sformatf("packet %0d matched", tot_pkt_recvd), UVM_NONE);
      end
    else
      begin
        m_mismatches++;
        `uvm_error("SCB", $sformatf("packet %0d mis_matches, expected = %0s::received = %0s", tot_pkt_recvd, ref_pkt.convert2string(), recvd_pkt.convert2string()));
      end
  endfunction
  
  
  virtual function void extract_phase(uvm_phase phase);
    uvm_config_db#(int)::set(null, "uvm_test_top.env", "matches", m_matches);
    uvm_config_db#(int)::set(null, "uvm_test_top.env", "mis_matches", m_mismatches);
  endfunction
  
  function void report_phase(uvm_phase phase);
    `uvm_info("SCB", $sformatf("Scoreboard completed with matches = %0d mismatches = %0d", m_matches, m_mismatches), UVM_NONE);
  endfunction
  
  
endclass
