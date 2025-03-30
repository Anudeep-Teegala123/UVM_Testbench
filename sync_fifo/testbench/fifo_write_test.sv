class fifo_write_test extends fifo_base_test;
  `uvm_component_utils(fifo_write_test)
  
  // constructor
  function new(string name = "fifo_write_test",uvm_component parent=null);
    super.new(name,parent);   
  endfunction
  
  fifo_write_sequence#(16,16) seq;
 
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);    
    seq = fifo_write_sequence#(16,16)::type_id::create("seq");
  endfunction
  
    
  // run_phase - starting the test
  task run_phase(uvm_phase phase);    
    phase.raise_objection(this);
    seq.start(env.agnt.seqr);
    phase.drop_objection(this);
    //set a drain-time for the environment if desired
    phase.phase_done.set_drain_time(this, 30);
  endtask
  
endclass