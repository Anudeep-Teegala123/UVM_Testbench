// DFF TB

module dff_tb ();
  reg clk;
  reg reset;
  reg d_i;
  
  wire q_norst_o;
  wire q_syncrst_o;
  wire q_asyncrst_o;
  
  d_ff dut(.clk(clk),.reset(reset),.d_i(d_i),.q_norst_o(q_norst_o),.q_syncrst_o(q_syncrst_o),.q_asyncrst_o(q_asyncrst_o));
  initial clk=0;
  always #5 clk=~clk;
  
  initial begin
    reset = 1;
    d_i=0;
    #5; reset = 0;    
    #10; d_i=0;
    #10; d_i=1;
    #10; d_i=0;
    #5; reset=1;
    #10; d_i=0;
    #10; d_i=1;
    #10; d_i=0;

    #50;
    $finish;
  end
endmodule
