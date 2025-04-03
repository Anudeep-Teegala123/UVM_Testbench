//`timescale 1ns / 1ns
module edge_detector_tb();
  reg clk, reset, a_i;
  wire rising_edge_o, falling_edge_o;
  
  // Registers to store delayed versions of a_i for edge detection
  reg a_i_d;
  // Registers to store edge conditions for 1 cycle before checking
  reg was_rising_edge, was_falling_edge;
  
  initial begin
    clk = 0;
    reset = 1;
    a_i = 0;
    a_i_d = 0;
    was_rising_edge = 0;
    was_falling_edge = 0;
  end
  
  always #5 clk = ~clk;
  
  // Instantiate DUT
  edge_detector dut (
    .clk(clk),
    .reset(reset),
    .a_i(a_i),
    .rising_edge_o(rising_edge_o),
    .falling_edge_o(falling_edge_o)
  );

  // Track delayed versions of a_i (for edge detection)
  always @(posedge clk) begin
    if (!reset) begin
      a_i_d  <= a_i;    // 1-cycle delay
    end
  end

  // Store edge conditions for 1 cycle before checking
  always @(posedge clk) begin
    if (!reset) begin
      was_rising_edge  <= (a_i && !a_i_d);  // Detect rising edge
      was_falling_edge <= (!a_i && a_i_d);  // Detect falling edge
    end
  end

  //Assertions to detect correct transitions
  always @(posedge clk) begin
    if (!reset) begin
      //$display("At %0t: a_i=%b, a_i_d=%b,rising_edge_o=%b, falling_edge_o=%b",
               //$time, a_i, a_i_d,rising_edge_o, falling_edge_o);
      
      // Check outputs 1 cycle after edge condition
      if (was_rising_edge) begin
        assert (rising_edge_o == 1) else $error("Rising edge not detected!");
      end
      if (was_falling_edge) begin
        assert (falling_edge_o == 1) else $error("Falling edge not detected!");
      end
    end
  end

  // Test sequence
  initial begin
    // Release reset
    @(posedge clk);
    reset = 0;

    // Test edge transitions (synchronous to clock)
    @(posedge clk); a_i = 1;  // Rising edge (detected next cycle)
    @(posedge clk); a_i = 0;  // Falling edge
    @(posedge clk); a_i = 1;  // Rising edge
    @(posedge clk); a_i = 0;  // Falling edge

    // Random transitions
    for (int i = 0; i < 10; i++) begin
      @(posedge clk);
      a_i = $urandom_range(0, 1);
    end

    // Reset test
    @(posedge clk); reset = 1;
    @(posedge clk); reset = 0;

    #50 $finish;
  end

  // Waveform dumping
  initial begin
    $dumpvars(0, edge_detector_tb);
    $dumpfile("waves.vcd");
  end
endmodule