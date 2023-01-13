module CPU
(
    clk_i, 
    rst_i,
);

// Ports
input               clk_i;
input               rst_i;

// PC & Instruction memory
wire     [31:0]     pc_i;
wire     [31:0]     pc_o;
wire     [31:0]     Add_PC_o;
wire     [31:0]     instr_o;

// IF_ID
wire     [31:0]     IF_ID_pc_o;
wire     [31:0]     IF_ID_instr_o;

// Control
wire     [6:0]      Opcode;
wire     [1:0]      ALUOp_o;
wire                ALUSrc_o;
wire                RegWrite_o;
wire                MemtoReg_o;
wire                MemRead_o;
wire                MemWrite_o;
wire                Branch_o;

// ID_EX 
wire                ID_EX_RegWrite_o;
wire                ID_EX_MemtoReg_o;
wire                ID_EX_MemRead_o;
wire                ID_EX_MemWrite_o;
wire                ID_EX_Branch_o;
wire     [1:0]      ID_EX_ALUOp_o;
wire                ID_EX_ALUSrc_o;
wire     [4:0]      ID_EX_RDaddr_o;
wire     [31:0]     ID_EX_RS1data_o;
wire     [31:0]     ID_EX_RS2data_o;
wire     [31:0]     ID_EX_Imm_o;
wire     [9:0]      ID_EX_funct_o;
wire     [4:0]      ID_EX_RS1addr_o;
wire     [4:0]      ID_EX_RS2addr_o;
wire     [31:0]     ID_EX_pc_o;

// EX_MEM
wire                EX_MEM_RegWrite_o;
wire                EX_MEM_MemtoReg_o;
wire                EX_MEM_MemRead_o;
wire                EX_MEM_MemWrite_o;
wire     [31:0]     EX_MEM_ALU_result_o;
wire     [31:0]     EX_MEM_RS2data_o;
wire     [4:0]      EX_MEM_RDaddr_o;

// MEM_WB
wire                MEM_WB_RegWrite_o;
wire                MEM_WB_MemtoReg_o;
wire     [31:0]     MEM_WB_ALU_result_o;
wire     [31:0]     MEM_WB_Memdata_o;
wire     [4:0]      MEM_WB_RDaddr_o;

// Registers & Imm_Gen
wire     [4:0]      RS1addr_i;
wire     [4:0]      RS2addr_i;
wire     [4:0]      RDaddr_i;
wire     [31:0]     RS1data_o;
wire     [31:0]     RS2data_o;
wire     [31:0]     RDdata_i;
wire     [11:0]     Imm_i;
wire     [31:0]     Imm_o;

// Hazard Detection Unit
wire                PCWrite;
wire                NoOp_o;
wire                Stall_o;

// Forwarding Unit
wire     [1:0]      ForwardA_o;
wire     [1:0]      ForwardB_o;
wire     [31:0]     ForwardAdata_o;
wire     [31:0]     ForwardBdata_o;

//Branch Predictor
wire    predict_o;

// Branch Unit
wire                flush;
wire                IFID_Flush;
wire                IDEX_Flush;
wire     [31:0]     branch_PC;
wire     [31:0]     IFID_branch_PC;
wire     [31:0]     IDEX_branch_PC;

// ALU
wire     [2:0]      ALUCtrl_o;
wire     [31:0]     ALUdata_i;
wire     [31:0]     ALUdata_o;
wire                Zero_o;

//Branch result(EX stage)
wire                branch_result_o;

wire     [31:0]     Memdata_o;
wire     [9:0]      funct_i;

//Instruction Fetch
assign Opcode = IF_ID_instr_o[6:0];
assign RS1addr_i = IF_ID_instr_o[19:15];
assign RS2addr_i = IF_ID_instr_o[24:20];
assign RDaddr_i = IF_ID_instr_o[11:7];
assign funct_i = {IF_ID_instr_o[31:25],IF_ID_instr_o[14:12]};
assign Imm_i =    (Opcode == 7'b0100011) ? {IF_ID_instr_o[31:25], IF_ID_instr_o[11:7]}: // sw
                    (Opcode == 7'b1100011) ? {IF_ID_instr_o[31], IF_ID_instr_o[7], IF_ID_instr_o[30:25], IF_ID_instr_o[11:8]}: // beq
                    IF_ID_instr_o[31:20];   //lw or I type

Adder Add_PC(
    .data1_in   (pc_o),
    .data2_in   (32'd4),
    .data_o     (Add_PC_o)
);

MUX32 MUX_PC(
    .data1_i    (Add_PC_o),
    .data2_i    (branch_PC),
    .select_i   (flush),
    .data_o     (pc_i)
);

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .PCWrite_i  (PCWrite),
    .pc_i       (pc_i),
    .pc_o       (pc_o)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (pc_o), 
    .instr_o    (instr_o)
);

IF_ID IF_ID(
    .clk_i      (clk_i),
    .stall_i    (Stall_o),
    .flush_i    (flush),
    .inst_i     (instr_o),
    .PC_i       (pc_o),

    .inst_o    (IF_ID_instr_o),
    .PC_o       (IF_ID_pc_o)
);

Control Control(
    .Op_i       (Opcode),
    .NoOp_i     (NoOp_o),
    .ALUOp_o    (ALUOp_o),
    .ALUSrc_o   (ALUSrc_o),
    .RegWrite_o (RegWrite_o),
    .MemtoReg_o (MemtoReg_o),
    .MemRead_o  (MemRead_o),
    .MemWrite_o (MemWrite_o),
    .Branch_o   (Branch_o)
);

branch_predictor branch_predictor(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .Branch_i   (ID_EX_Branch_o),
    .update_i   (branch_result_o),
    .result_i   (predict_o),
    .predict_o   (predict_o)   
);

//decode stage branch unit
Branch ID_Branch_Unit(
    .Branch_i       (Branch_o),
    .predict_i      (predict_o),
    .Imm_i          (Imm_o),
    .PC_i           (IF_ID_pc_o),
    .Flush_o        (IFID_Flush),
    .PC_o           (IFID_branch_PC)
);

Registers Registers(
    .clk_i       (clk_i),
    .RS1addr_i   (RS1addr_i),
    .RS2addr_i   (RS2addr_i),
    .RDaddr_i    (MEM_WB_RDaddr_o), 
    .RDdata_i    (RDdata_i),
    .RegWrite_i  (MEM_WB_RegWrite_o), 
    .RS1data_o   (RS1data_o), 
    .RS2data_o   (RS2data_o)
);

Sign_Extend Sign_Extend(
    .data_i     (Imm_i),
    .data_o     (Imm_o)
);

Hazard_Detection Hazard_Detection(
    .MemRead_i      (ID_EX_MemRead_o),
    .RDaddr_i       (ID_EX_RDaddr_o),
    .RS1addr_i      (RS1addr_i),
    .RS2addr_i      (RS2addr_i),
    
    .PCWrite_o      (PCWrite),
    .Stall_o        (Stall_o),
    .NoOp_o         (NoOp_o)  
);

ID_EX ID_EX(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .flush_i    (IDEX_Flush),
    .RegWrite_i (RegWrite_o),
    .MemtoReg_i (MemtoReg_o),
    .MemRead_i  (MemRead_o),
    .MemWrite_i (MemWrite_o),
    .Branch_i   (Branch_o),
    .ALUOp_i    (ALUOp_o),
    .ALUSrc_i   (ALUSrc_o),
    .data1_i    (RS1data_o), 
    .data2_i    (RS2data_o),
    .Imm_i      (Imm_o),
    .funct_i    (funct_i),
    .RS1addr_i  (RS1addr_i), 
    .RS2addr_i  (RS2addr_i),
    .RDaddr_i   (RDaddr_i),
    .PC_i       (IF_ID_pc_o),

    .RegWrite_o (ID_EX_RegWrite_o),
    .MemtoReg_o (ID_EX_MemtoReg_o),
    .MemRead_o  (ID_EX_MemRead_o),
    .MemWrite_o (ID_EX_MemWrite_o),
    .Branch_o   (ID_EX_Branch_o),
    .ALUOp_o    (ID_EX_ALUOp_o),
    .ALUSrc_o   (ID_EX_ALUSrc_o),
    .data1_o    (ID_EX_RS1data_o), 
    .data2_o    (ID_EX_RS2data_o),
    .Imm_o      (ID_EX_Imm_o),
    .funct_o    (ID_EX_funct_o),
    .RS1addr_o  (ID_EX_RS1addr_o), 
    .RS2addr_o  (ID_EX_RS2addr_o),
    .RDaddr_o   (ID_EX_RDaddr_o),
    .PC_o       (ID_EX_pc_o)
);

Forwarding ForwardingUnit(
    .EX_RS1addr_i   (ID_EX_RS1addr_o),
    .EX_RS2addr_i   (ID_EX_RS2addr_o),
    .MEM_RegWrite_i (EX_MEM_RegWrite_o),
    .MEM_RDaddr_i   (EX_MEM_RDaddr_o),
    .WB_RegWrite_i  (MEM_WB_RegWrite_o),
    .WB_RDaddr_i    (MEM_WB_RDaddr_o),
    
    .ForwardA_o     (ForwardA_o),
    .ForwardB_o     (ForwardB_o)
);

MUX32_4 ForwardA(
    .data1_i    (ID_EX_RS1data_o),
    .data2_i    (RDdata_i),
    .data3_i    (EX_MEM_ALU_result_o),
    .select_i   (ForwardA_o),
    .data_o     (ForwardAdata_o)
);

MUX32_4 ForwardB(
    .data1_i    (ID_EX_RS2data_o),
    .data2_i    (RDdata_i),
    .data3_i    (EX_MEM_ALU_result_o),
    .select_i   (ForwardB_o),
    .data_o     (ForwardBdata_o)
);

MUX32 MUX_ALUSrc(
    .data1_i    (ForwardBdata_o),
    .data2_i    (ID_EX_Imm_o),
    .select_i   (ID_EX_ALUSrc_o),
    .data_o     (ALUdata_i)
);

ALU_Control ALU_Control(
    .funct_i    (ID_EX_funct_o),
    .ALUOp_i    (ID_EX_ALUOp_o),
    .ALUCtrl_o  (ALUCtrl_o)
);

ALU ALU(
    .data1_i    (ForwardAdata_o),
    .data2_i    (ALUdata_i),
    .ALUCtrl_i  (ALUCtrl_o),
    .data_o     (ALUdata_o),
    .Zero_o     (Zero_o)
);

//AND gate
branch_result branch_result(
    .Zero_i     (Zero_o),
    .Branch_i   (ID_EX_Branch_o),
    .result_o   (branch_result_o)
);

branch_check branch_check(
    .Branch_i           (ID_EX_Branch_o),
    .branch_result_i    (branch_result_o),
    .predict_i          (predict_o),
    .Imm_i              (ID_EX_Imm_o),
    .PC_i               (ID_EX_pc_o),
    .Flush_o            (IDEX_Flush),
    .PC_o               (IDEX_branch_PC)
);

//handle flush and branch_PC
Flush Flush(
    .IFID_Flush_i       (IFID_Flush),
    .IDEX_Flush_i       (IDEX_Flush),
    .IFID_branch_PC_i   (IFID_branch_PC),
    .IDEX_branch_PC_i   (IDEX_branch_PC),
    .IFID_Flush_o       (flush),
    .branch_PC_o        (branch_PC)
);

EX_MEM EX_MEM(
    .clk_i          (clk_i),
    .rst_i          (rst_i),
    .RegWrite_i     (ID_EX_RegWrite_o),
    .MemtoReg_i     (ID_EX_MemtoReg_o),
    .MemRead_i      (ID_EX_MemRead_o),
    .MemWrite_i     (ID_EX_MemWrite_o),
    .ALU_result_i   (ALUdata_o),
    .RS2data_i      (ForwardBdata_o),
    .RDaddr_i       (ID_EX_RDaddr_o),

    .RegWrite_o (EX_MEM_RegWrite_o),
    .MemtoReg_o (EX_MEM_MemtoReg_o),
    .MemRead_o  (EX_MEM_MemRead_o),
    .MemWrite_o (EX_MEM_MemWrite_o),
    .ALU_result_o   (EX_MEM_ALU_result_o),
    .RS2data_o  (EX_MEM_RS2data_o),
    .RDaddr_o   (EX_MEM_RDaddr_o)
);

Data_Memory Data_Memory(
    .clk_i       (clk_i), 
    .addr_i      (EX_MEM_ALU_result_o), 
    .MemRead_i   (EX_MEM_MemRead_o),
    .MemWrite_i  (EX_MEM_MemWrite_o),
    .data_i      (EX_MEM_RS2data_o),
    .data_o      (Memdata_o)
);

MEM_WB MEM_WB(
    .clk_i          (clk_i),
    .rst_i          (rst_i),
    .RegWrite_i     (EX_MEM_RegWrite_o),
    .MemtoReg_i     (EX_MEM_MemtoReg_o),
    .ALU_result_i   (EX_MEM_ALU_result_o),
    .data_i         (Memdata_o),
    .RDaddr_i       (EX_MEM_RDaddr_o),

    .RegWrite_o     (MEM_WB_RegWrite_o),
    .MemtoReg_o     (MEM_WB_MemtoReg_o),
    .ALU_result_o   (MEM_WB_ALU_result_o),
    .data_o         (MEM_WB_Memdata_o),
    .RDaddr_o       (MEM_WB_RDaddr_o)
);

MUX32 MUX_WriteSrc(
    .data1_i    (MEM_WB_ALU_result_o),
    .data2_i    (MEM_WB_Memdata_o),
    .select_i   (MEM_WB_MemtoReg_o),
    .data_o     (RDdata_i)
);

endmodule