class fifo_sequencer#(parameter FIFO_DEPTH = 8, parameter DATA_WIDTH = 8) extends uvm_sequencer#(fifo_transaction#(FIFO_DEPTH, DATA_WIDTH));
	`uvm_component_param_utils (fifo_sequencer#(FIFO_DEPTH, DATA_WIDTH))
	function new (string name="fifo_sequencer", uvm_component parent);
		super.new (name, parent);
	endfunction

endclass