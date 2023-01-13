`define  AND 3'b000
`define  XOR 3'b001
`define  SLL 3'b010
`define  ADD 3'b011
`define  SUB 3'b100
`define  MUL 3'b101
`define  ADDI 3'b110
`define  SRAI 3'b111


module  ALU(
    data1_i,
    data2_i,
    ALUCtrl_i,
    data_o,
    Zero_o
);

input   signed [31:0]  data1_i;
input   signed [31:0]  data2_i;
input   [2:0]   ALUCtrl_i;
output  [31:0]  data_o;
output          Zero_o;

reg      signed [31:0]  tmp;
assign  data_o = tmp;
assign Zero_o = 0;

always @(data1_i or data2_i or ALUCtrl_i) begin
    case (ALUCtrl_i)
    `AND: tmp = data1_i & data2_i;
    `XOR: tmp = data1_i ^ data2_i;
    `SLL: tmp = data1_i << data2_i;
    `ADD: tmp = data1_i + data2_i;
    `SUB: tmp = data1_i - data2_i;
    `MUL: tmp = data1_i * data2_i;
    `ADDI: tmp = data1_i + data2_i;
    `SRAI: tmp = data1_i >>> data2_i[4:0];
    endcase
end


endmodule