module  IF_ID
(
    clk_i,
    start_i,
    Stall_i,
    Flush_i,
    instr_i,
    PC_i,
    instr_o,
    PC_o
);

input   clk_i;
input   start_i;
input   Stall_i;
input   Flush_i;
input   [31:0]  instr_i;
input   [31:0]  PC_i;
output  [31:0]  instr_o;
output  [31:0]  PC_o;

reg     [31:0]  instr_o;
reg     [31:0]  PC_o;

always@(posedge clk_i)begin
    if(Flush_i)begin
        instr_o = 32'b0;
        PC_o = 32'b0;
    end
    else if(start_i && !Stall_i)begin
        instr_o = instr_i;
        PC_o = PC_i;
    end
end

endmodule

