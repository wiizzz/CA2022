module ALU_Control(
    funct_i,
    ALUOp_i,
    ALUCtrl_o
);
input   [9:0]   funct_i;
input   [1:0]   ALUOp_i;
output  [2:0]   ALUCtrl_o;

assign ALUCtrl_o = (ALUOp_i == 2'b10)?(
(funct_i == 10'b0000000111)? 3'b000:    //and
(funct_i == 10'b0000000100)? 3'b001:    //xor
(funct_i == 10'b0000000001)? 3'b010:    //sll
(funct_i == 10'b0000000000)? 3'b011:    //add
(funct_i == 10'b0100000000)? 3'b100:    //sub
(funct_i == 10'b0000001000)? 3'b101: 3'bx   //mul
):
((ALUOp_i == 2'b01)?(
  (funct_i == 10'b0100000101)? 3'b111:3'b110  
):3'bx);


endmodule
