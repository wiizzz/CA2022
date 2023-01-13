module  Branch
(
    Branch_i,
    predict_i,
    Imm_i,
    PC_i,
    Flush_o,
    PC_o
);

input           Branch_i;
input           predict_i;
input   [31:0]  Imm_i;
input   [31:0]  PC_i;
output          Flush_o;
output  [31:0]  PC_o;

reg     Flush_o;

assign PC_o = PC_i + (Imm_i << 1);

always@(Branch_i or predict_i)begin
    Flush_o = 1'b0;
    if(Branch_i && predict_i)begin
        Flush_o = 1'b1;
    end
end

endmodule