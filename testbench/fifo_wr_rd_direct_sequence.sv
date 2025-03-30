class fifo_wr_rd_sequence #(parameter FIFO_DEPTH = 8, parameter DATA_WIDTH = 8) extends uvm_sequence#(fifo_transaction#(FIFO_DEPTH, DATA_WIDTH));
  `uvm_object_utils(fifo_wr_rd_sequence#(FIFO_DEPTH, DATA_WIDTH)) 

  function new(string name="fifo_base_sequence");
    super.new(name);
  endfunction
  
  fifo_transaction#(FIFO_DEPTH, DATA_WIDTH) trans;
   
  virtual task body();
    `uvm_info("BASE_SEQ", "Running Body task of WR RD Sequence()", UVM_MEDIUM)
    // Write 3 values
    trans = fifo_transaction#(FIFO_DEPTH, DATA_WIDTH)::type_id::create("trans");
    start_item(trans);
    trans.write = 1; trans.read = 0; trans.data_in = 188;
    finish_item(trans);
    
    start_item(trans);
    trans.write = 1; trans.read = 0; trans.data_in = 150;
    finish_item(trans);
    
    start_item(trans);
    trans.write = 1; trans.read = 0; trans.data_in = 178;
    finish_item(trans);
    
    // Read 3 times
    start_item(trans);
    trans.write = 0; trans.read = 1;
    finish_item(trans);
    
    start_item(trans);
    trans.write = 0; trans.read = 1;
    finish_item(trans);
    
    start_item(trans);
    trans.write = 0; trans.read = 1;
    finish_item(trans);
    
    start_item(trans);
    trans.write = 0; trans.read = 0;
    finish_item(trans);
  endtask
endclass