module CPU
(
    clk_i, 
    rst_i,
    start_i
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;

wire [31:0] instr_addr, instr;
wire [31:0] pc;
wire [6:0] opcode;
wire [9:0] funct;
wire [4:0] rs1, rs2, rd;
wire [11:0] imm;
wire [31:0] rs1_data, rs2_data;
wire zero_o;

assign opcode = instr[6:0];
assign rs1 = instr[19:15];
assign rs2 = instr[24:20];
assign rd = instr[11:7];
assign funct = {instr[31:25],instr[14:12]};
assign imm = instr[31:20];


wire RegWrite;
wire select;
wire [1:0] ALUOp;
wire [2:0] ALUCtrl;
wire [31:0] SignExtend;
wire [31:0] ALU_data2;
wire [31:0] ALU_result;

Control Control(
    .Op_i       (opcode),
    .ALUOp_o    (ALUOp),
    .ALUSrc_o   (select),
    .RegWrite_o (RegWrite)
);



Adder Add_PC(
    .data1_in   (instr_addr),
    .data2_in   (32'd4),
    .data_o     (pc)
);


PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .pc_i       (pc),
    .pc_o       (instr_addr)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (instr_addr), 
    .instr_o    (instr)
);

Registers Registers(
    .clk_i      (clk_i),
    .RS1addr_i   (rs1),
    .RS2addr_i   (rs2),
    .RDaddr_i   (rd), 
    .RDdata_i   (ALU_result),
    .RegWrite_i (RegWrite), 
    .RS1data_o   (rs1_data), 
    .RS2data_o   (rs2_data) 
);


MUX32 MUX_ALUSrc(
    .data1_i    (rs2_data),
    .data2_i    (SignExtend),
    .select_i   (select), 
    .data_o     (ALU_data2)
);



Sign_Extend Sign_Extend(
    .data_i     (imm),
    .data_o     (SignExtend) 
);

  

ALU ALU(
    .data1_i    (rs1_data),
    .data2_i    (ALU_data2),
    .ALUCtrl_i  (ALUCtrl),
    .data_o     (ALU_result), 
    .Zero_o     (zero_o)
);



ALU_Control ALU_Control(
    .funct_i    (funct),
    .ALUOp_i    (ALUOp),  
    .ALUCtrl_o  (ALUCtrl) 
);


endmodule

