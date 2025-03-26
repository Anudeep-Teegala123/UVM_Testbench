class fifo_base_sequence #(parameter FIFO_DEPTH = 8, parameter DATA_WIDTH = 8) extends uvm_sequence#(fifo_transaction);
	`uvm_object_utils(fifo_base_sequence) 

	function new(string name="fifo_base_sequence");
		super.new(name);
	endfunction
	
	 fifo_transaction trans;
	`uvm_declare_p_sequencer (fifo_sequencer) 
	
	
	virtual task body();
	`uvm_info("BASE_SEQ",$sformatf ("Running Body task of Base Sequence()"), UVM_MEDIUM)
	    repeat(10) begin
			trans=fifo_transaction#(FIFO_DEPTH,DATA_WIDTH)::type_id::create("trans");
			start_item(trans);
			assert(trans.randomize());
			finish_item(trans);
		end
	endtask
   
 endclass