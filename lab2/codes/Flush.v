module Flush(
    IFID_Flush_i,
    IDEX_Flush_i,
    IFID_branch_PC_i,
    IDEX_branch_PC_i,
    IFID_Flush_o,
    branch_PC_o
);

input   IFID_Flush_i;
input   IDEX_Flush_i;
input   [31:0]  IFID_branch_PC_i;
input   [31:0]  IDEX_branch_PC_i;
output  reg  IFID_Flush_o;
output  reg  [31:0]  branch_PC_o;


always @(*) begin
    IFID_Flush_o = 0;
    if(IDEX_Flush_i == 1)begin
        branch_PC_o = IDEX_branch_PC_i;
        IFID_Flush_o = 1;
    end
    else if(IFID_Flush_i == 1)begin
        branch_PC_o = IFID_branch_PC_i;
        IFID_Flush_o = 1;
    end
    else begin
        IFID_Flush_o = 0;
    end
end


endmodule