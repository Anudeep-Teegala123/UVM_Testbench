// Different DFF

module d_ff(
  input     logic      clk,
  input     logic      reset,

  input     logic      d_i,

  output    logic      q_norst_o,
  output    logic      q_syncrst_o,
  output    logic      q_asyncrst_o
);
  
  always@(posedge clk) begin
    q_norst_o<=d_i;
  end
    
  //Synchronous FF
  always @(posedge clk) begin
    if(reset)
      q_syncrst_o<=0;
    else
      q_syncrst_o<=d_i;
  end
  
  //Asynchronous FF
  always@(posedge clk or posedge reset) begin
    if(reset)
      q_asyncrst_o<=0;
    else
      q_asyncrst_o<=d_i;
  end
endmodule
