module sync_fifo #(parameter FIFO_DEPTH=8, parameter DATA_WIDTH=8)
	(fifo_if.DUT fifo_sync_if); //using DUT modport
	
	localparam FIFO_DEPTH_LOG = $clog2(FIFO_DEPTH);
	
	//multidimensional array to store the data
    reg [DATA_WIDTH-1:0] fifo [0:FIFO_DEPTH-1] = '{default:0};
	
	reg [FIFO_DEPTH_LOG:0] write_pointer;
	reg [FIFO_DEPTH_LOG:0] read_pointer;
	
	always_ff @(posedge fifo_sync_if.clk or negedge fifo_sync_if.rst) begin
		if(!fifo_sync_if.rst) 
			write_pointer <= 0;
        else if (fifo_sync_if.write && !fifo_sync_if.full) begin
            fifo[write_pointer[FIFO_DEPTH_LOG-1:0]] <= fifo_sync_if.data_in;
            $display("@%0t: Wrote fifo[%0d] = %0d", $time, write_pointer[FIFO_DEPTH_LOG-1:0], fifo_sync_if.data_in);
			write_pointer <= write_pointer+1;
        end
	end
	
    always_ff @(posedge fifo_sync_if.clk or negedge fifo_sync_if.rst) begin
    	if (!fifo_sync_if.rst) begin
        	read_pointer <= 0;
        	fifo_sync_if.data_out <= 0;
    	end
    	else if (fifo_sync_if.read && !fifo_sync_if.empty) begin
            fifo_sync_if.data_out <= fifo[read_pointer[FIFO_DEPTH_LOG-1:0]];
        	read_pointer <= read_pointer + 1;        	
    	end
	end
	
	// Declare the empty/full logic
    assign fifo_sync_if.empty = (read_pointer == write_pointer);
	assign fifo_sync_if.full  = (read_pointer == {~write_pointer[FIFO_DEPTH_LOG], write_pointer[FIFO_DEPTH_LOG-1:0]});
	
endmodule