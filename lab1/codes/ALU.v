`define  AND 3'b000
`define  XOR 3'b001
`define  SLL 3'b010
`define  ADD 3'b011
`define  SUB 3'b100
`define  MUL 3'b101
`define  ADDI 3'b110
`define  SRAI 3'b111

module ALU
(
    data1_i,
    data2_i,
    ALUCtrl_i,
    data_o,
);

// Ports
input   signed  [31:0]  data1_i;
input   signed  [31:0]  data2_i;
input   [2:0]           ALUCtrl_i;
output  signed  [31:0]  data_o;

assign data_o = (ALUCtrl_i == `AND) ? data1_i &   data2_i: // and
                (ALUCtrl_i == `XOR) ? data1_i ^   data2_i: // xor
                (ALUCtrl_i == `SLL) ? data1_i <<  data2_i: // sll
                (ALUCtrl_i == `ADD) ? data1_i +   data2_i: // add
                (ALUCtrl_i == `SUB) ? data1_i -   data2_i: // sub
                (ALUCtrl_i == `MUL) ? data1_i *   data2_i: // mul
                (ALUCtrl_i == `ADDI) ? data1_i +   data2_i: // addi
                (ALUCtrl_i == `SRAI) ? data1_i >>> data2_i[4:0]: // sra
                32'b0;

endmodule