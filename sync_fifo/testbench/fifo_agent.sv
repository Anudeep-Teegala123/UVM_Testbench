 class fifo_agent #(parameter FIFO_DEPTH = 8, parameter DATA_WIDTH = 8) extends uvm_agent;
    `uvm_component_param_utils(fifo_agent #(FIFO_DEPTH, DATA_WIDTH))

	function new(string name="fifo_agent",uvm_component parent=null);
		super.new(name,parent);
	endfunction
	
    fifo_driver#(FIFO_DEPTH, DATA_WIDTH)      drv;
    fifo_sequencer#(FIFO_DEPTH, DATA_WIDTH) 	 seqr;
	fifo_monitor#(FIFO_DEPTH,DATA_WIDTH) 	 mon;  
	
	//Utility and Field macros
	/*`uvm_component_utils_begin(fifo_agent#(FIFO_DEPTH, DATA_WIDTH))
		`uvm_field_object(seqr, UVM_ALL_ON)
		`uvm_field_object(drv, UVM_ALL_ON)
		`uvm_field_object(mon, UVM_ALL_ON)
	`uvm_component_utils_end */
	
	virtual function void build_phase(uvm_phase phase);
	    super.build_phase(phase);
        drv=fifo_driver#(FIFO_DEPTH, DATA_WIDTH)::type_id::create("drv", this);
		seqr=fifo_sequencer#(FIFO_DEPTH, DATA_WIDTH)::type_id::create("seqr", this);
		mon=fifo_monitor#(FIFO_DEPTH,DATA_WIDTH)::type_id::create("mon", this);
	endfunction
	
	virtual function void connect_phase(uvm_phase phase);
	    super.connect_phase(phase);
	    drv.seq_item_port.connect(seqr.seq_item_export);
	    uvm_report_info("FIFO_AGENT", "connect_phase, Connected driver to sequencer");
    endfunction
  
 endclass  