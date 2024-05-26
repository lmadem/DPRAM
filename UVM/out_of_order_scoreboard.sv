//parameterized out_of_order_scoreboard (typed to packet) by extending from uvm_scoreboard
class out_of_order_scoreboard #(type T=packet) extends uvm_scoreboard;
  
  //scb_type typed to out_of_order_scoreboard#(T)
  typedef out_of_order_scoreboard #(T) scb_type;
  `uvm_component_param_utils(scb_type)
  
  //type_name of const static string type
  const static string type_name = $sformatf("out_of_order_sequence #(%0s)", $typename(T));
  
  //get_type_name method
  virtual function string get_type_name();
    return type_name;
  endfunction
  
  //custom analysis ports to receive packet from iMon/oMonitor
  `uvm_analysis_imp_decl(_inp)
  `uvm_analysis_imp_decl(_outp)
  
  //analysis port to receive packet from iMonitor
  uvm_analysis_imp_inp #(T, scb_type) mon_inp;
  
  //analysis port to receive packet from oMonitor
  uvm_analysis_imp_outp #(T, scb_type) mon_outp;
  
  //queue q_inp to store packets from all monitors
  T q_inp[$];
  
  //Define variables m_matches and m_mismatches
  bit [31:0] m_matches, m_mismatches;
  
  //variables no_of_pkts_recvd to keep track of packet count
  bit [31:0] no_of_pkts_recvd;
  
  //custom constructor
  function new(string name = "out_of_order_scoreboard", uvm_component parent);
    super.new(name, parent);
    `uvm_info(get_type_name(), "NEW Scoreboard", UVM_NONE);
  endfunction
  
  //build_phase to construct object for analysis ports
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    //Construct object for mon_inp analysis port
    mon_inp = new("mon_inp", this);
    
    //Construct object for mon_outp analysis port
    mon_outp = new("mon_outp", this);
  endfunction
  
  //write_inp to receive packets from iMonitor and store in q_inp
  virtual function void write_inp(T pkt);
    T pkt_in;
    //clone the received pkt 
    $cast(pkt_in, pkt.clone());
    //Store the cloned pkt_in 
    q_inp.push_back(pkt_in);
  endfunction
  
  //write_outp to receive packets from oMonitor and search and compare
  virtual function void write_outp(T recvd_pkt);
    T ref_pkt;
    int get_index[$];
    int index;
    bit done;
    //Keep track of the received pkt count
    no_of_pkts_recvd++;
    
    //Search for matching pkt in q_inp with addr as the search criteria
    get_index = q_inp.find_index() with (item.addr == recvd_pkt.addr);
    
    //Loop through all matched indices 
    foreach(get_index[i])
      begin
        index = get_index[i];
        //get the pkt object from q_inp 
        ref_pkt = q_inp[index];
        
        //Compare recived pkt with the ref_pkt object from q_inp
        if(ref_pkt.compare(recvd_pkt))
          begin
            //Increment the m_matches count if pkt matches
            m_matches++;
 
            //Delete matched pkt from q_inp	
            q_inp.delete(index);
            done = 1;
       
            `uvm_info("SCB_MATCH",$sformatf("Packet %0d Matched",no_of_pkts_recvd),UVM_NONE);
            
            //Break the foreach loop as we have matching pkt	
            break;
          end
        //Loop through untill all indices exhaust in get_index
        else 
          done = 0;
      end
    
    //Increment m_mismatches count as none of the pkt from q_inp matches
    if(!done) 
      begin
        m_mismatches++;
        `uvm_error("SCB_NO_MATCH", $sformatf("*****Matching Packet NOT found for the pkt_id = %0d*****", no_of_pkts_recvd));
        `uvm_info("SCB", $sformatf("Expected::%0s", ref_pkt.convert2string()), UVM_NONE);
        `uvm_info("SCB", $sformatf("Received::%0s", recvd_pkt.convert2string()), UVM_NONE);
      end
  endfunction
    
    
    //Implement extract_phase to send m_matches/m_mismatches count to environment
    virtual function void extract_phase(uvm_phase phase);
      
      //use uvm_config_db::set to send m_matches count to environment
      uvm_config_db#(int)::set(null, "uvm_test_top.env", "matches", m_matches);
      
      //use uvm_config_db::set to send m_mismatches count to environment
      uvm_config_db#(int)::set(null, "uvm_test_top.env", "mis_matches", m_mismatches);
    endfunction
    
    
    //Define report_phase to print m_matches/m_mismatches count
    function void report_phase(uvm_phase phase);
      `uvm_info("SCB", $sformatf("Scoreboard completed with matches=%0d mismatches=%0d", m_matches, m_mismatches), UVM_NONE);
    endfunction
    
endclass

    



