 import uvm_pkg::*;
`include "uvm_macros.svh"

`include "fifo_transaction.sv"
`include "fifo_interface.sv"
`include "fifo_sequencer.sv"
`include "fifo_sequence.sv"
`include "fifo_wr_rd_seq.sv"
`include "fifo_driver.sv"
`include "fifo_monitor.sv"
`include "fifo_agent.sv"
`include "fifo_scoreboard.sv"
`include "fifo_env.sv"
`include "fifo_base_test.sv"
`include "fifo_wr_rd_test.sv"

module tb_top;	 
	
	bit clk;
	bit rst;
	//Clock Generatio
	initial begin
		clk=0;
		forever #5 clk=~clk;
	end
	//Reset Generation
    initial begin
        rst = 0;
        #2 rst =1;
    end
	
	localparam MY_FIFO_DEPTH = 8;
	localparam MY_DATA_WIDTH = 8;
	
    fifo_if #(MY_FIFO_DEPTH,MY_DATA_WIDTH) ff_if(clk,rst);
	sync_fifo #(.FIFO_DEPTH(MY_FIFO_DEPTH), .DATA_WIDTH(MY_DATA_WIDTH)) dut0(ff_if.DUT);	
		
	initial begin 
      uvm_config_db#(virtual fifo_if#(MY_FIFO_DEPTH,MY_DATA_WIDTH))::set(null,"*","vif",ff_if);
	end
	
	initial begin
		$display("Starting UVM Test.......");
	  //run_test("fifo_base_test");
      run_test("fifo_wr_rd_test");
	end
    initial begin 
        $dumpfile("dump.vcd"); 
        $dumpvars;
    end
endmodule