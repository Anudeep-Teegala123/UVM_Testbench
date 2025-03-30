class fifo_transaction #(parameter FIFO_DEPTH = 8, parameter DATA_WIDTH = 8) extends uvm_sequence_item;
  `uvm_object_param_utils(fifo_transaction#(FIFO_DEPTH,DATA_WIDTH))   
	rand bit [DATA_WIDTH-1:0] data_in;
	rand bit read, write;
	bit full,empty;
	bit [DATA_WIDTH-1:0] data_out;
	
	function new(string name="fifo_transaction");
		super.new(name);
	endfunction
	
endclass
