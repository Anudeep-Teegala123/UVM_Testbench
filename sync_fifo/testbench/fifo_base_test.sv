class fifo_base_test extends uvm_test;
	`uvm_component_utils(fifo_base_test) 

	function new(string name="fifo_base_test",uvm_component parent=null);
		super.new(name,parent);
	endfunction
	
    fifo_env#(16,16) env;
	virtual fifo_if vif;
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase); 
        env = fifo_env#(16,16)::type_id::create("env",this);
		uvm_config_db#(virtual fifo_if)::set(this, "env", "vif", vif);
    
    	if(! uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif)) begin
        	`uvm_error("build_phase","Test virtual interface failed")
      	end
	endfunction
	
	virtual task run_phase(uvm_phase phase);
		fifo_base_sequence seq = fifo_base_sequence#(8,8)::type_id::create("seq",this);	
		
		// Raise objection - else this test will not consume simulation time*
		phase.raise_objection (this);
	    $display("%t Starting sequence fifo_seq run_phase",$time);
		// Start the sequence on a given sequencer
		seq.start (env.agnt.seqr);
	    //#200;
        // Set drain time to allow monitor/scoreboard to process remaining transactions
    	phase.phase_done.set_drain_time(this, 50);  // 50ns for propagation
		// Drop objection - else this test will not finish
		phase.drop_objection (this);
       $display("%t Finished sequence fifo_seq run_phase from fifo_base_test", $time);
	endtask
	
	// end_of_elobaration phase
	virtual function void end_of_elaboration_phase(uvm_phase phase);
	  // Print the UVM topology
	  print();
	endfunction
	
endclass