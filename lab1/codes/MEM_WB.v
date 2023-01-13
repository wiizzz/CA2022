module MEM_WB
(
    clk_i,
    start_i,
    RegWrite_i,
    MemtoReg_i,
    ALU_result_i,
    data_i,
    RDaddr_i, 
    RegWrite_o,
    MemtoReg_o,
    ALU_result_o,
    data_o,
    RDaddr_o, 
);

input   clk_i;
input   start_i;
input   RegWrite_i;
input   MemtoReg_i;
input   [31:0]  ALU_result_i;
input   [31:0]  data_i;
input   [4:0]   RDaddr_i;
output   RegWrite_o;
output   MemtoReg_o;
output  [31:0]  ALU_result_o;
output  [31:0]  data_o;
output  [4:0]   RDaddr_o;

reg             RegWrite_o;
reg             MemtoReg_o;
reg     [31:0]  ALU_result_o;
reg     [31:0]  data_o;
reg     [4:0]   RDaddr_o;

always@(posedge clk_i) begin
    if(start_i)begin
        RegWrite_o <= RegWrite_i;
        MemtoReg_o <= MemtoReg_i;
        ALU_result_o <= ALU_result_i;
        data_o <= data_i;
        RDaddr_o <= RDaddr_i;
    end
end



endmodule