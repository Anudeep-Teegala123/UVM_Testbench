module mux_2to1_tb;
  reg a_i;
  reg b_i;
  reg sel_i;
  wire y_o;
  
  mux_2to1 dut(.a_i(a_i),.b_i(b_i),.sel_i(sel_i),.y_o(y_o));
  
  initial begin
    //$dumpfile("day1.vcd");
    //$dumpvars(0, tb_mux_2to1);
    // Case I - select a_i
    a_i = 8'h5;
    b_i = 8'h10;
    sel_i = 1'b0;
    #10;
    if (y_o !== a_i) $display("Test Case 1 Failed");
        else $display("Test Case 1 Passed");
    // Case Ii - select b_i
    a_i = 8'h2;
    b_i = 8'h4;
    sel_i = 1'b1;
    #10;
    if (y_o !== b_i) $display("Test Case 2 Failed");
        else $display("Test Case 2 Passed");
    //Case 3: Random values
    a_i = $random;
    b_i = $random;
    sel_i = $random % 2;
    #10;
    $finish;
  end
endmodule