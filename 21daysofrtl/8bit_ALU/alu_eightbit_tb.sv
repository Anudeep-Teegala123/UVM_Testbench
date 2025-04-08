// Simple ALU TB

module alu_eightbit_tb ();

  logic [7:0] a_i;
  logic [7:0] b_i;
  logic [2:0] op_i;
  logic [7:0] alu_o;
  
  alu_eightbit dut(.a_i(a_i),.b_i(b_i),.op_i(op_i),.alu_o(alu_o));
  
  initial begin
    a_i=0;
    b_i=0;
    op_i=3'b000;
    
    //Direct Cases
    #5;
    a_i = 5;
    b_i = 3;
    op_i = 3'b000; // ADD
    #5;
    a_i = 5;
    b_i = 3;
    op_i = 3'b001; //SUB
    #5;
    a_i = 5;
    b_i = 3;
    op_i = 3'b010; //SLL
    #5;
    a_i = 5;
    b_i = 3;
    op_i = 3'b011; //LSR
    #5;
    a_i = 5;
    b_i = 3;
    op_i = 3'b100; //AND
    #5;
    a_i = 5;
    b_i = 3;
    op_i = 3'b101; //OR
    #5;
    a_i = 5;
    b_i = 3;
    op_i = 3'b110; //XOR
    #5;
    a_i = 5;
    b_i = 3;
    op_i = 3'b111; //EQL
    
    //Random values and operations   
    for(int i=0;i<15;i++) begin
      a_i=$random;
      b_i=$random;
      op_i=$random;
    end
    #50;
    $finish;
  end

endmodule