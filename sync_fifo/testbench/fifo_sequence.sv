class fifo_base_sequence #(parameter FIFO_DEPTH = 8, parameter DATA_WIDTH = 8) 
    extends uvm_sequence #(fifo_transaction #(FIFO_DEPTH, DATA_WIDTH));
    `uvm_object_param_utils(fifo_base_sequence #(FIFO_DEPTH, DATA_WIDTH))

    function new(string name = "fifo_base_sequence");
        super.new(name);
    endfunction

    fifo_transaction #(FIFO_DEPTH, DATA_WIDTH) trans;

    virtual task body();
        `uvm_info("BASE_SEQ", $sformatf("Running Body task of Base Sequence()"), UVM_MEDIUM)
        repeat(10) begin
            trans = fifo_transaction #(FIFO_DEPTH, DATA_WIDTH)::type_id::create("trans");
            start_item(trans);
            assert(trans.randomize());
            finish_item(trans);
        end
    endtask
endclass

// 2. write_sequence - "write" type
class fifo_write_sequence #(parameter FIFO_DEPTH = 8, parameter DATA_WIDTH = 8) 
    extends uvm_sequence #(fifo_transaction #(FIFO_DEPTH, DATA_WIDTH));
    `uvm_object_param_utils(fifo_write_sequence #(FIFO_DEPTH, DATA_WIDTH))   

    function new(string name = "fifo_write_sequence");
        super.new(name);
    endfunction

    fifo_transaction #(FIFO_DEPTH, DATA_WIDTH) trans;
  
    virtual task body();
        $display("Starting UVM Seq Body ...");
        repeat(16) begin
            trans = fifo_transaction #(FIFO_DEPTH, DATA_WIDTH)::type_id::create("trans");
            start_item(trans);
          //assert(trans.randomize() with {trans.write == 1; trans.read == 0;}); //Giving Error: RUNTIME_0153 Expression '~super.uvm_sequence~0' in the parameter assignment is a hierarchical reference to an object that has not been created yet. in EDA Playground using Aldec Reviera Pro 2023.04 Simulator
            assert(trans.randomize());  // Randomize all rand fields, including data_in
        	trans.write = 1;  // Override to ensure write-only behavior
       		trans.read = 0;
            finish_item(trans);
            set_response_queue_depth(15);
        end
    endtask
endclass

//------------------------------------------------------------------------
// 3. read_sequence - "read" type
class fifo_read_sequence #(parameter FIFO_DEPTH = 8, parameter DATA_WIDTH = 8) 
    extends uvm_sequence #(fifo_transaction #(FIFO_DEPTH, DATA_WIDTH));
    `uvm_object_param_utils(fifo_read_sequence #(FIFO_DEPTH, DATA_WIDTH))

  fifo_transaction #(FIFO_DEPTH, DATA_WIDTH) trans;  // Declare req explicitly

    function new(string name = "fifo_read_sequence");
        super.new(name);
    endfunction

    virtual task body();
        repeat(8) begin
          trans = fifo_transaction #(FIFO_DEPTH, DATA_WIDTH)::type_id::create("trans");
          start_item(trans);
          //assert(req.randomize() with {req.read == 1; req.write == 0;}); //Getting run-time error with the simulator
            assert(trans.randomize());  // Randomize all rand fields, including data_in
        	trans.write = 0;  // Override to ensure write-only behavior
       		trans.read = 1;
            finish_item(trans);
            set_response_queue_depth(15);
        end
    endtask
endclass


//write complete then read complete sequence

class fifo_wr_then_rd_sequence #(parameter FIFO_DEPTH = 8, parameter DATA_WIDTH = 8) 
    extends uvm_sequence #(fifo_transaction #(FIFO_DEPTH, DATA_WIDTH));
    `uvm_object_param_utils(fifo_wr_then_rd_sequence #(FIFO_DEPTH, DATA_WIDTH))

    fifo_write_sequence #(FIFO_DEPTH, DATA_WIDTH) wr_seq;
    fifo_read_sequence #(FIFO_DEPTH, DATA_WIDTH) rd_seq;
    `uvm_declare_p_sequencer(fifo_sequencer#(FIFO_DEPTH, DATA_WIDTH))
    function new(string name = "fifo_wr_then_rd_sequence");
        super.new(name);
    endfunction

    virtual task body();
        wr_seq = fifo_write_sequence #(FIFO_DEPTH, DATA_WIDTH)::type_id::create("wr_seq");
        
      	wr_seq.start(p_sequencer, this);
     	rd_seq = fifo_read_sequence #(FIFO_DEPTH, DATA_WIDTH)::type_id::create("rd_seq");
        rd_seq.start(p_sequencer, this);
    endtask
endclass
//--------------------------------------------------------------------------

        
// 5. write_read_sequence - "write" followed by "read" 

//used in wr_rd_test.sv
//write read back to back

class fifo_write_read_sequence #(parameter FIFO_DEPTH = 8, parameter DATA_WIDTH = 8) 
    extends uvm_sequence #(fifo_transaction #(FIFO_DEPTH, DATA_WIDTH));
    `uvm_object_param_utils(fifo_write_read_sequence #(FIFO_DEPTH, DATA_WIDTH))

    fifo_transaction #(FIFO_DEPTH, DATA_WIDTH) req;  // Declare req explicitly

    function new(string name = "fifo_write_read_sequence");
        super.new(name);
    endfunction

    virtual task body();
        repeat(5) begin
            // Write transaction
            req = fifo_transaction #(FIFO_DEPTH, DATA_WIDTH)::type_id::create("req");
            start_item(req);
            assert(req.randomize() with {req.write == 1; req.read == 0;});
            finish_item(req);

            // Read transaction
            req = fifo_transaction #(FIFO_DEPTH, DATA_WIDTH)::type_id::create("req");
            start_item(req);
            assert(req.randomize() with {req.write == 0; req.read == 1;});
            finish_item(req);

            //set_response_queue_error_report_disabled(1);
        end
    endtask
endclass      
        

//6. write_read_parallel_sequence - "write" & "read" 

//used in wr_rd_test.sv

class fifo_wr_rd_parallel_seq #(parameter FIFO_DEPTH = 8, parameter DATA_WIDTH = 8) 
    extends uvm_sequence #(fifo_transaction #(FIFO_DEPTH, DATA_WIDTH));
    `uvm_object_param_utils(fifo_wr_rd_parallel_seq #(FIFO_DEPTH, DATA_WIDTH))

    fifo_write_sequence #(FIFO_DEPTH, DATA_WIDTH) wr_seq;
    fifo_read_sequence #(FIFO_DEPTH, DATA_WIDTH) rd_seq;
    fifo_transaction #(FIFO_DEPTH, DATA_WIDTH) trans;

    function new(string name = "fifo_wr_rd_parallel_seq");
        super.new(name);
    endfunction

    virtual task body();
      trans = fifo_transaction #(FIFO_DEPTH, DATA_WIDTH)::type_id::create("trans");
      start_item(trans);
      assert(trans.randomize())
      trans.write =1; 
      trans.read = 0;
      finish_item(trans);

        repeat(8) begin
          trans = fifo_transaction #(FIFO_DEPTH, DATA_WIDTH)::type_id::create("trans");
          start_item(trans);
          assert(trans.randomize())
          trans.write = 1; 
          trans.read = 1;
          finish_item(trans);
          set_response_queue_depth(15);
       end
    endtask
endclass