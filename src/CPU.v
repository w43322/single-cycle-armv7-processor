module CPU(
    input Clock,
    input Reset,
    input Halt,
    output [3:0] REG1ADDR,
    output [3:0] REG2ADDR,
    output [9:0] PCREG,
    output [9:0] MEMADDR,
    output [31:0] INST,
    output [31:0] DATAM,
    output [31:0] DATA1,
    output [31:0] DATA2,
    output ITYP,
    output RTYP,
    output DTYP,
    output BTYP
);

    assign REG1ADDR = Register_ReadAddr1;
    assign REG2ADDR = Register_ReadAddr2;
    assign PCREG = PC;
    assign MEMADDR = DataMemory_RWAddr;
    assign INST = Instruction;
    assign DATAM = DataMemory_ReadData;
    assign DATA1 = Register_ReadData1;
    assign DATA2 = Register_ReadData2;
    assign ITYP = I_Type;
    assign RTYP = R_Type;
    assign DTYP = D_Type;
    assign BTYP = B_Type;
    
    /*Condition Check*/
    wire [3:0] ConditionChecker_In = Instruction[31:28];
    wire ConditionChecker_Out;
    ConditionChecker condchk(ConditionChecker_In, NFlag, ZFlag, CFlag, VFlag, ConditionChecker_Out);

    /*Type Check*/
    wire [2:0] Type = Instruction[27:25];
    wire I_Type, R_Type, D_Type, B_Type;
    GetType gettype(ConditionChecker_Out, Type, I_Type, R_Type, D_Type, B_Type);

    /*PC & Insturction Memory (ROM)*/
    reg [9:0] PC = 10'd0;
    wire [31:0] Instruction;
    InstructionMemory im(PC, Instruction);
    /*PC increment or Branch*/
    wire [9:0] BranchOffset = B_Type ? {Instruction[7:0], 2'b0} : 10'd4;
    always @ (posedge Clock) begin
        if (Reset) begin
            PC <= 10'd0;
        end else begin
            if (Halt) begin
                PC <= PC;
            end else begin
                PC <= PC + BranchOffset;
            end
        end
    end
    
    /*Registers*/
    wire [3:0] Register_ReadAddr1 = Instruction[19:16];
    wire [3:0] Register_ReadAddr2 = D_Type ? Register_WriteAddr : Instruction[3:0];
    wire [3:0] Register_WriteAddr = Instruction[15:12];
    wire Register_WriteEnable =  ~Halt & ~Reset & (WriteALUResult | D_Type & Instruction[20]);
    wire [31:0] Register_WriteData = D_Type ? DataMemory_ReadData : ALU_Out;
    wire [31:0] Register_ReadData1;
    wire [31:0] Register_ReadData2;
    Registers regs(Register_ReadAddr1, Register_ReadAddr2, Register_ReadData1, Register_ReadData2,
                   Clock, Register_WriteEnable, Register_WriteAddr, Register_WriteData);
    
    /*Shifter*/
    reg [4:0] Shifter_Amount;
    reg [1:0] Shifter_Type;
    reg [31:0] Shifter_In;
    wire [31:0] Shifter_Out;
    always @ (*) begin
        if (I_Type) begin
            Shifter_Amount <= {Instruction[11:8], 1'b0};
            Shifter_Type <= 2'b11;
            Shifter_In <= {{24{Instruction[7]}}, Instruction[7:0]};
        end else begin
            Shifter_Amount <= Instruction[11:7];
            Shifter_Type <= Instruction[6:5];
            Shifter_In <= Register_ReadData2;
        end
    end
    Shifter sftr(Shifter_Amount, Shifter_Type, Shifter_In, Shifter_Out);
    
    /*ALU*/
    wire [3:0] ALU_OpCode = Instruction[24:21];
    wire [31:0] ALU_Op1 = Register_ReadData1;
    wire [31:0] ALU_Op2 = Shifter_Out;
    wire [31:0] ALU_Out;
    wire ALU_NFlag, ALU_ZFlag, ALU_CFlag, ALU_VFlag;
    ALU alu(ALU_OpCode, ALU_Op1, ALU_Op2, ALU_Out, ALU_NFlag, ALU_ZFlag, ALU_CFlag, ALU_VFlag);
    reg NFlag, ZFlag, CFlag, VFlag;
    wire WriteALUResult = (I_Type | R_Type) & (~ALU_OpCode[3] | ALU_OpCode[2]);
    
    /*Flags*/
    wire UpdateFlags = ~Halt & ~Reset & (I_Type | R_Type) & Instruction[20];
    always @ (posedge Clock) begin
        if (UpdateFlags) begin
            NFlag <= ALU_NFlag;
            ZFlag <= ALU_ZFlag;
            CFlag <= ALU_CFlag;
            VFlag <= ALU_VFlag;
        end
    end
    
    /*Data Memory (RAM)*/
    reg [9:0] DataMemory_RWAddr;
    wire [31:0] DataMemory_WriteData = Register_ReadData2;
    wire DataMemory_WriteEnable = ~Halt & ~Reset & D_Type & ~Instruction[20];
    wire [31:0] DataMemory_ReadData;
    always @ (*) begin
        if (Instruction[23]) begin
            DataMemory_RWAddr = Register_ReadData1[9:0] + Instruction[9:0];
        end else begin
            DataMemory_RWAddr = Register_ReadData1[9:0] - Instruction[9:0];
        end
    end
    DataMemory dm(DataMemory_RWAddr, DataMemory_WriteData, Clock, DataMemory_WriteEnable, DataMemory_ReadData);
    
endmodule
