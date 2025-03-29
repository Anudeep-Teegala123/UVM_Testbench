class fifo_scoreboard #(parameter FIFO_DEPTH=8, parameter DATA_WIDTH=8) extends uvm_scoreboard; 
  `uvm_component_param_utils(fifo_scoreboard #(FIFO_DEPTH, DATA_WIDTH))

  uvm_analysis_imp #(fifo_transaction #(FIFO_DEPTH,DATA_WIDTH), fifo_scoreboard #(FIFO_DEPTH,DATA_WIDTH)) scb_analysis_port;
  fifo_transaction#(FIFO_DEPTH,DATA_WIDTH) item_queue[$:FIFO_DEPTH];
  fifo_transaction#(FIFO_DEPTH,DATA_WIDTH) trans;
  
  bit [DATA_WIDTH-1:0] mem[$];
  bit [DATA_WIDTH-1:0] exp_data;
  bit read_delay_clk;  // Delay flag

  function new(string name="fifo_scoreboard", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    scb_analysis_port = new("scb_analysis_port", this);
  endfunction  
  
  function void write(fifo_transaction#(FIFO_DEPTH,DATA_WIDTH) item);
    item_queue.push_back(item);
  endfunction  
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      wait(item_queue.size() > 0);
      trans = item_queue.pop_front();
      $display("@%0t: [SCOREBOARD] Read transaction: data_out=%0d, Received from Monitor", $time, trans.data_out);
      if (trans.write == 1 && !trans.full) begin
        mem.push_back(trans.data_in);
        `uvm_info("SCOREBOARD", $sformatf("Write: %0d, mem size: %0d", trans.data_in, mem.size()), UVM_HIGH)
      end
      
      if (trans.read == 1 || read_delay_clk != 0) begin
        if (read_delay_clk == 0) begin
          read_delay_clk = 1;  // Set delay on first read transaction
        end
        else begin
          if (trans.read == 0) read_delay_clk = 0;  // Clear if no read
          if (mem.size() > 0) begin
            exp_data = mem.pop_front();
            $display("@%0t: [SCOREBOARD] Popped mem data: data_out=%0d, Received from Monitor", $time, exp_data);
            if (trans.data_out == exp_data) begin
              `uvm_info("SCOREBOARD", $sformatf("------ :: EXPECTED MATCH  :: ------"), UVM_MEDIUM)
              `uvm_info("SCOREBOARD", $sformatf("Exp Data: %0d, Req data=%0d", exp_data, trans.data_out), UVM_MEDIUM)
            end
            else begin
              `uvm_error("SCOREBOARD", $sformatf("------ ::  FAILED MATCH  :: ------"))
              `uvm_info("SCOREBOARD", $sformatf("Exp Data: %0d, Req data=%0d", exp_data, trans.data_out), UVM_MEDIUM)
            end
          end
        end
      end
      else begin
        read_delay_clk = 0;  // Reset delay if no read
      end
    end
  endtask  
endclass