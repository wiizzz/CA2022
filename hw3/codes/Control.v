`define Rtype   7'b0110011
`define Itype   7'b0010011

module  Control(
    Op_i,
    ALUOp_o,
    ALUSrc_o,
    RegWrite_o
);

input   [6:0]   Op_i;

output  [1:0]   ALUOp_o;
output          ALUSrc_o;
output          RegWrite_o;

assign ALUOp_o = (Op_i == `Rtype)? 2'b10:
                 (Op_i == `Itype)? 2'b01: 2'bx;

assign ALUSrc_o = (Op_i == `Rtype)? 1'b0:
                 (Op_i == `Itype)? 1'b1: 1'bx;

assign RegWrite_o = 1'b1;


endmodule