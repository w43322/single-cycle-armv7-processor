module ConditionChecker(
    input [3:0] In,
    input NFlag,
    input ZFlag,
    input CFlag,
    input VFlag,
    output Out
);
    reg ConditionIsMet;
    always @ (*) begin
        case (In)
            /*EQ*/ 4'b0000: ConditionIsMet <= ZFlag;
            /*NE*/ 4'b0001: ConditionIsMet <= ~ZFlag;
            /*CS*/ 4'b0010: ConditionIsMet <= CFlag;
            /*CC*/ 4'b0011: ConditionIsMet <= ~CFlag;
            /*MI*/ 4'b0100: ConditionIsMet <= NFlag;
            /*PL*/ 4'b0101: ConditionIsMet <= ~NFlag;
            /*VS*/ 4'b0110: ConditionIsMet <= VFlag;
            /*VC*/ 4'b0111: ConditionIsMet <= ~VFlag;
            /*HI*/ 4'b1000: ConditionIsMet <= CFlag & ~ZFlag;
            /*LS*/ 4'b1001: ConditionIsMet <= ~CFlag | ZFlag;
            /*GE*/ 4'b1010: ConditionIsMet <= ~(NFlag ^ VFlag);
            /*LT*/ 4'b1011: ConditionIsMet <= NFlag ^ VFlag;
            /*GT*/ 4'b1100: ConditionIsMet <= ~ZFlag & ~(NFlag ^ VFlag);
            /*LE*/ 4'b1101: ConditionIsMet <= ZFlag | (NFlag ^ VFlag);
            /*Always*/ 4'b1110: ConditionIsMet <= 1'b1;
            default: ConditionIsMet <= 1'b0;
        endcase
    end
    assign Out = ConditionIsMet;
endmodule
