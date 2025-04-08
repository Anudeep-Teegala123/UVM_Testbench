// A simple ALU

module alu_eightbit(
  input     logic [7:0]   a_i,
  input     logic [7:0]   b_i,
  input     logic [2:0]   op_i,

  output    logic [7:0]   alu_o
);

  typedef enum bit[2:0] {ADD=3'b000,SUB,SLL,LSR,AND,OR,XOR,EQL} alu_op;
  alu_op op;
  always_comb begin
    op=alu_op'(op_i);
    case (op)
      ADD : alu_o = a_i + b_i; //Addition
      SUB : alu_o = a_i - b_i; //Subtraction
      SLL : alu_o = a_i << b_i; //Shift Left
      LSR : alu_o = a_i >> b_i; //Right shift
      AND : alu_o = a_i & b_i; //AND
      OR  : alu_o = a_i | b_i; //OR
      XOR : alu_o = a_i ^ b_i; //XOR
      EQL : alu_o = (a_i == b_i) ? 8'h1:8'h0; //Equality
      default: alu_o = 0;
    endcase
  end
endmodule