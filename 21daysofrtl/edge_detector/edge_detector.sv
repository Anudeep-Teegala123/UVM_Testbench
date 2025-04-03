//Edge Detector Design
//The detection happens one cycle after the transition
module edge_detector (
  input     wire    clk,
  input     wire    reset,
  input     wire    a_i,
  output    reg     rising_edge_o,
  output    reg     falling_edge_o
);
  reg a_i_prev;

  always @(posedge clk) begin
    if (reset) begin
      rising_edge_o  <= 0;
      falling_edge_o <= 0;
      a_i_prev       <= a_i; // Ensure a_i_prev matches a_i after reset
    end else begin
      a_i_prev       <= a_i; //Once cycle delay
      rising_edge_o  <= (a_i & ~a_i_prev);
      falling_edge_o <= (~a_i & a_i_prev);      
    end
  end 
  
  /*always @(posedge clk) begin
    if (!reset) begin
      $display("Module at %0t: a_i=%b, a_i_prev=%b, rising_edge_o=%b, falling_edge_o=%b", $time, a_i, a_i_prev, rising_edge_o, falling_edge_o);
    end
  end*/
  
  // Track stable reset state
  reg reset_done=0;
  always @(posedge clk) reset_done <= !reset;

  // Assertions to verify edge transitions
  property rising_edge_check;
    @(posedge clk) disable iff (!reset_done)
    (a_i && !a_i_prev) |=> (rising_edge_o);
  endproperty
  assert property (rising_edge_check);

  property falling_edge_check;
    @(posedge clk) disable iff (!reset_done)
    (!a_i && a_i_prev) |=> (falling_edge_o);
  endproperty
  assert property (falling_edge_check);

endmodule