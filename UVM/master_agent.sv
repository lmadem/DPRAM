//Master agent

class master_agent extends uvm_agent;
  `uvm_component_utils(master_agent)
  
  driver drvr;
  iMonitor iMon;
  sequencer seqr;
  
  //pass through port
  uvm_analysis_port #(packet) ap;
  
  //constructor
  function new(string name = "master_agent", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
endclass
    
    
function void master_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);
  ap = new("ap", this);
  
  if(is_active == UVM_ACTIVE) 
    begin
      seqr = sequencer::type_id::create("seqr", this);
      drvr = driver::type_id::create("drvr", this);
    end
  
  iMon = iMonitor::type_id::create("iMon", this);
endfunction
    
   
function void master_agent::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if(is_active == UVM_ACTIVE)
    begin
      drvr.seq_item_port.connect(seqr.seq_item_export);
    end
  
  iMon.analysis_port.connect(this.ap);
endfunction
