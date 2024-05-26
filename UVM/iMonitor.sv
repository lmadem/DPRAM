//Input Monitor Class

class iMonitor extends uvm_monitor;
  `uvm_component_utils(iMonitor)
  
  virtual memory_if.tb_mon_in vif;
  
  //TLM port to connect iMonitor and Scoreboard
  uvm_analysis_port #(packet) analysis_port;
  
    
  //current monitored transaction 
  packet pkt;
  
  //constructor
  function new(string name = "iMonitor", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  
endclass
    

function void iMonitor::build_phase(uvm_phase phase);
  super.build_phase(phase);
  analysis_port = new("analysis_port", this);
endfunction
    
    
function void iMonitor::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if(!uvm_config_db#(virtual memory_if.tb_mon_in)::get(this, "", "iMon_if", vif))
    begin
      `uvm_fatal("iMon", "iMonitor virtual interface is not set");
    end
endfunction
    
    
task iMonitor::run_phase(uvm_phase phase);
  forever
    begin
      @(vif.cb_mon_in.wdata);
      if(vif.cb_mon_in.addr == 'h20) continue; //skip, as it is CSR addr
      if(vif.cb_mon_in.wr == 1'b0) continue; //skip, incase of not a write
      pkt = packet::type_id::create("pkt", this);
      pkt.addr = vif.cb_mon_in.addr;  //address
      pkt.data = vif.cb_mon_in.wdata; //write data
      `uvm_info(get_type_name(), pkt.convert2string(), UVM_MEDIUM);
      analysis_port.write(pkt);
    end
endtask
