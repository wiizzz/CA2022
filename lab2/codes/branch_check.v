module  branch_check
(
    Branch_i,
    branch_result_i,
    predict_i,
    Imm_i,
    PC_i,
    Flush_o,
    PC_o
);

input           Branch_i;
input           branch_result_i;
input           predict_i;
input   [31:0]  Imm_i;
input   [31:0]  PC_i;
output          Flush_o;
output  [31:0]  PC_o;

reg     Flush_o;
reg     PC_o;

always@(Branch_i or branch_result_i or predict_i)begin
    Flush_o = 1'b0;
    if(branch_result_i != predict_i && Branch_i)begin
        Flush_o = 1'b1;

        if(branch_result_i)begin
            PC_o = PC_i + (Imm_i << 1); //taken
        end
        else begin
            PC_o = PC_i + 4;    //not taken
        end
    end
end

endmodule