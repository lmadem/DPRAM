//Outpur Monitor Class

class oMonitor extends uvm_monitor;
  `uvm_component_utils(oMonitor)
  
  virtual memory_if.tb_mon_out vif;
  
  //TLM port to connect oMonitor and Scoreboard
  uvm_analysis_port #(packet) analysis_port;
  
    
  //current monitored transaction 
  packet pkt;
  
  //constructor
  function new(string name = "oMonitor", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  
endclass
    

function void oMonitor::build_phase(uvm_phase phase);
  super.build_phase(phase);
  analysis_port = new("analysis_port", this);
endfunction
    
    
function void oMonitor::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if(!uvm_config_db#(virtual memory_if.tb_mon_out)::get(this, "", "oMon_if", vif))
    begin
      `uvm_fatal(get_type_name(), "oMonitor virtual interface is not set");
    end
endfunction
    
    
task oMonitor::run_phase(uvm_phase phase);
  forever
    begin
      @(vif.cb_mon_out.rdata)
      if(vif.cb_mon_out.addr == 'h26) continue; //skip, as it is CSR addr
      if(vif.cb_mon_out.rdata === 'z || vif.cb_mon_out.rdata === 'x) 
        continue; //skip, when the data_out is in high impedence state
      pkt = packet::type_id::create("pkt", this);
      pkt.addr = vif.cb_mon_out.addr;  //address
      pkt.data = vif.cb_mon_out.rdata; //read data
      `uvm_info(get_type_name(), pkt.convert2string(), UVM_MEDIUM);
      analysis_port.write(pkt); 
      
    end
endtask
