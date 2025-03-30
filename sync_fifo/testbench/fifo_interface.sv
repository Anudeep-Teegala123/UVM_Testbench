interface fifo_if #(parameter FIFO_DEPTH = 8,parameter DATA_WIDTH = 8)(input logic clk, rst);
	logic [DATA_WIDTH-1:0] data_in;
	logic [DATA_WIDTH-1:0] data_out;
	logic read,write;
	logic empty;
	logic full;	 
	logic [$clog2(FIFO_DEPTH)+1:0]fifo_count;
	
	clocking driver_cb @(posedge clk);
		output data_in;
		output read,write;
		input full,empty;
		input data_out;
		input fifo_count;
	endclocking
	
	clocking monitor_cb @(posedge clk);
		input data_in;
		input read,write;
		input full,empty;
		input data_out;
		input fifo_count;
	endclocking
	
	modport DUT(
		input clk, 
		input rst,
		input data_in,
		input data_out,
		input read, write,
		output empty,full
	);
	
	modport DRIVER(clocking driver_cb,input clk,rst);
	modport MONITOR(clocking monitor_cb,input clk,rst);
endinterface