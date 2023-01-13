module ID_EX
(
    clk_i,
    start_i,
    RegWrite_i,
    MemtoReg_i,
    MemRead_i,
    MemWrite_i,
    ALUOp_i,
    ALUSrc_i,
    data1_i,
    data2_i,
    Imm_i,
    funct_i,
    RS1addr_i,
    RS2addr_i,
    RDaddr_i, 

    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,
    ALUOp_o,
    ALUSrc_o,
    data1_o,
    data2_o,
    Imm_o,
    funct_o,
    RS1addr_o,
    RS2addr_o,
    RDaddr_o, 
);

input   clk_i;
input   start_i;
input   RegWrite_i;
input   MemtoReg_i;
input   MemRead_i;
input   MemWrite_i;
input   [1:0]   ALUOp_i;
input   ALUSrc_i;
input   [31:0]  data1_i;
input   [31:0]  data2_i;
input   [31:0]  Imm_i;
input   [9:0]   funct_i;
input   [4:0]   RS1addr_i;
input   [4:0]   RS2addr_i;
input   [4:0]   RDaddr_i;

output   RegWrite_o;
output   MemtoReg_o;
output   MemRead_o;
output   MemWrite_o;
output  [1:0]   ALUOp_o;
output  ALUSrc_o;
output  [31:0]  data1_o;
output  [31:0]  data2_o;
output  [31:0]  Imm_o;
output  [9:0]   funct_o;
output  [4:0]   RS1addr_o;
output  [4:0]   RS2addr_o;
output  [4:0]   RDaddr_o;

reg             RegWrite_o;
reg             MemtoReg_o;
reg             MemRead_o;
reg             MemWrite_o;
reg     [1:0]   ALUOp_o;
reg             ALUSrc_o;
reg     [31:0]  data1_o; 
reg     [31:0]  data2_o;
reg     [31:0]  Imm_o;
reg     [9:0]   funct_o;
reg     [4:0]   RS1addr_o;
reg     [4:0]   RS2addr_o;
reg     [4:0]   RDaddr_o;

always@(posedge clk_i) begin
    if(start_i)begin
        RegWrite_o <= RegWrite_i;
        MemtoReg_o <= MemtoReg_i;
        MemRead_o <= MemRead_i;
        MemWrite_o <= MemWrite_i;
        ALUOp_o <= ALUOp_i;
        ALUSrc_o <= ALUSrc_i;
        data1_o <= data1_i;
        data2_o <= data2_i;
        Imm_o <= Imm_i;
        funct_o <= funct_i;
        RS1addr_o <= RS1addr_i;
        RS2addr_o <= RS2addr_i;
        RDaddr_o <= RDaddr_i;
    end
end

endmodule