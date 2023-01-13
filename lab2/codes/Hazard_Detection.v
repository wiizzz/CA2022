module Hazard_Detection
(
    MemRead_i,
    RDaddr_i,
    RS1addr_i,
    RS2addr_i,
    PCWrite_o,
    Stall_o,
    NoOp_o
);

input   MemRead_i;
input   [4:0]   RDaddr_i;
input   [4:0]   RS1addr_i;
input   [4:0]   RS2addr_i;
output  PCWrite_o;
output  Stall_o;
output  NoOp_o;

reg     PCWrite_o;
reg     Stall_o;
reg     NoOp_o;


always@(MemRead_i or RDaddr_i or RS1addr_i or RS2addr_i)begin
    PCWrite_o = 1'b1;
    Stall_o = 1'b0;
    NoOp_o = 1'b0;
    if(MemRead_i && ((RDaddr_i == RS1addr_i) || (RDaddr_i == RS2addr_i)))begin
        PCWrite_o = 1'b0;
        Stall_o = 1'b1;
        NoOp_o = 1'b1;
    end
end

endmodule