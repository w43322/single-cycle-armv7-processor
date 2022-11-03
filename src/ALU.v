module ALU(
    input [3:0] OpCode,
    input [31:0] Op1,
    input [31:0] Op2,
    output [31:0] Out,
    output NFlag,
    output ZFlag,
    output CFlag,
    output VFlag
);
    reg [32:0] ALU_result;
    always @ (*) begin
        case (OpCode)
            /*AND*/4'b0000: ALU_result <= Op1 & Op2;
            /*EOR*/4'b0001: ALU_result <= Op1 ^ Op2;
            /*SUB*/4'b0010: ALU_result <= Op1 - Op2;
            /*RSB*/4'b0011: ALU_result <= Op2 - Op1;
            /*ADD*/4'b0100: ALU_result <= Op1 + Op2;
            /*ADC*/
            /*SBC*/
            /*RSC*/
            /*TST*/4'b1000: ALU_result <= Op1 & Op2;
            /*TEQ*/4'b1001: ALU_result <= Op1 ^ Op2;
            /*CMP*/4'b1010: ALU_result <= Op1 - Op2;
            /*CMN*/4'b1011: ALU_result <= Op1 + Op2;
            /*ORR*/4'b1100: ALU_result <= Op1 | Op2;
            /*MOV*/4'b1101: ALU_result <= Op2;
            /*BIC*/4'b1110: ALU_result <= Op1 & ~Op2;
            /*MVN*/4'b1111: ALU_result <= ~Op2;
            default: ALU_result <= 33'b0;
        endcase
    end
    assign Out = ALU_result[31:0];
    assign NFlag = ALU_result[31];
    assign ZFlag = ALU_result == 33'b0;
    assign CFlag = ALU_result[32];
    assign VFlag = (OpCode == 4'b0100 || OpCode == 0'b1011) & (Op1[31] & Op2[31] & ~NFlag | ~Op1[31] & ~Op2[31] & NFlag)
                 | (OpCode == 4'b0010 || OpCode == 0'b1010) & (Op1[31] & ~Op2[31] & ~NFlag | ~Op1[31] & Op2[31] & NFlag)
                 | OpCode == 4'b0011 & (Op2[31] & ~Op1[31] & ~NFlag | ~Op2[31] & Op1[31] & NFlag);
endmodule
