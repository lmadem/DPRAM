//driver class

class driver extends uvm_driver #(packet);
  `uvm_component_utils(driver)
  
  bit [31:0] pkt_id;
  virtual memory_if.tb vif;
  bit send_rsp;
  
  //constructor
  function new(string name = "driver", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task write(input packet pkt);
  extern virtual task read(input packet pkt);
  extern virtual task drive_reset();
  extern virtual task drive(packet pkt);
  extern virtual task config_reg_write(packet pkt);
  extern virtual task config_reg_read(packet pkt);
  extern virtual task drive_stimulus(packet pkt);
endclass
    
task driver::run_phase(uvm_phase phase);
  forever
    begin
      seq_item_port.get_next_item(req);
      drive(req);
      seq_item_port.item_done();
      
      if(req.kind == STIMULUS)
        pkt_id++;
      `uvm_info("driver", $sformatf("Driver %0s Transaction %0d Completed", req.kind.name(), pkt_id), UVM_MEDIUM);
    end
endtask
    
 
task driver::drive(packet pkt);
  case(req.kind)
    RESET : drive_reset();
    CSR_WRITE : config_reg_write(req);
    CSR_READ : config_reg_read(req);
    STIMULUS : drive_stimulus(req);
    default : begin
      `uvm_warning("driver", "Unknown packet received in driver");
    end
  endcase
endtask
    

task driver::drive_stimulus(packet pkt);
  if(pkt.wr)
    write(pkt);
  if(send_rsp) 
    begin
      rsp = packet::type_id::create("rsp", this);
      rsp.slv_rsp = (vif.slv_rsp == 1'b1) ? OK : ERROR;
      rsp.set_id_info(pkt);
      seq_item_port.put_response(rsp);
    end
  if(pkt.rd)
    read(pkt);
endtask
    

function void driver::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  void'(uvm_config_db#(bit)::get(this, "", "set_resp_for_drvr", send_rsp));
  if(!uvm_config_db#(virtual memory_if.tb)::get(this, "", "drvr_if", vif))
    begin
      `uvm_fatal("DRVR_VIF_ERR", "Virtual Interface in Driver is NULL");
    end
endfunction
    
 
task driver::write(input packet pkt);
  @(vif.cb);
  `uvm_info("DRVR_WR", "Write Transaction Started.....", UVM_FULL);
  vif.cb.wr <= pkt.wr;
  vif.cb.addr <= pkt.addr;
  vif.cb.wdata <= pkt.data;
  @(vif.cb);
  vif.cb.wr <= 1'b0;
  `uvm_info("DRVR_WR", $sformatf("Write Transaction Ended with addr=%0d, data=%0d", pkt.addr, pkt.data), UVM_HIGH);
endtask
    
    
task driver::read(input packet pkt);
  `uvm_info("DRVR_RD", "Read Transaction Started.....", UVM_FULL);
  vif.cb.rd <= pkt.rd;
  vif.cb.addr <= pkt.addr;
  repeat(2) @(vif.cb);
  vif.cb.rd <= 1'b0;
  `uvm_info("DRVR_RD", $sformatf("Read Transaction Ended with addr=%0d", pkt.addr), UVM_HIGH);
endtask
    

task driver::drive_reset();
  `uvm_info("RST", "Reset Transaction Started...", UVM_FULL);
  vif.reset <= 1'b1;
  repeat(2) @(vif.cb);
  vif.reset <= 1'b0;
  `uvm_info("RST", "Reset Transaction Ended...", UVM_HIGH);
endtask
    
            
task driver::config_reg_write(packet pkt);
  `uvm_info("CSR_WR", "Configuration Write Transaction Started....", UVM_FULL);
  vif.cb.addr <= pkt.addr;
  vif.cb.wdata <= pkt.data;
  vif.cb.wr <= 1'b1;
  repeat(2) @(vif.cb);
  vif.cb.wr <= 1'b0;
  `uvm_info("CSR_WR", "Configuration Write Transaction Ended....", UVM_HIGH);
endtask
    
task driver::config_reg_read(packet pkt);
  `uvm_info("CSR_RD", "Configuration Read Transaction Started....", UVM_FULL);
  vif.cb.addr <= pkt.addr;
  vif.cb.rd <= 1'b1;
  repeat(2) @(vif.cb);
  vif.cb.rd <= 1'b0;
  pkt.data = vif.cb.rdata;
  `uvm_info("CSR_RD", "Configuration Read Transaction Ended....", UVM_HIGH);
endtask
    
    
    
    
    
    
    
    
    
