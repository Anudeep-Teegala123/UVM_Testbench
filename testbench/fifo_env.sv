class fifo_env#(FIFO_DEPTH=8, DATA_WIDTH=8) extends uvm_env;
	`uvm_component_utils(fifo_env);

	function new(string name="fifo_env", uvm_component parent=null);
		super.new(name,parent);
	endfunction
	
	fifo_scoreboard#(FIFO_DEPTH,DATA_WIDTH)	fifo_scb;
	fifo_agent#(FIFO_DEPTH,DATA_WIDTH) agnt;
	
	virtual function void build_phase(uvm_phase phase);
	    super.build_phase(phase);
		fifo_scb = fifo_scoreboard#(FIFO_DEPTH,DATA_WIDTH)::type_id::create("fifo_scb",this);
		agnt = fifo_agent#(FIFO_DEPTH,DATA_WIDTH)::type_id::create("agnt", this);
	endfunction
	
	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		agnt.mon.mon_analysis_port.connect(fifo_scb.scb_analysis_port);
		uvm_report_info("FIFO_ENVIRONMENT", "connect_phase, Connected monitor to scoreboard");
    endfunction

 endclass