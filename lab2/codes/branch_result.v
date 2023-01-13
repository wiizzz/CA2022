module  branch_result
(
    Zero_i,
    Branch_i,
    result_o
);

input   Zero_i, Branch_i;
output result_o;

assign result_o = Zero_i && Branch_i;

endmodule