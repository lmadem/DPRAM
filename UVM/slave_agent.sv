//Slave agent

class slave_agent extends uvm_agent;
  `uvm_component_utils(slave_agent)
  
  oMonitor oMon;
  //pass through port
  uvm_analysis_port #(packet) ap;
  
  //constructor
  function new(string name = "slave_agent", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
endclass
    
    
function void slave_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);
  ap = new("slave_ap", this);
  oMon = oMonitor::type_id::create("oMon", this);
endfunction
    
   
function void slave_agent::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  oMon.analysis_port.connect(this.ap);
endfunction
