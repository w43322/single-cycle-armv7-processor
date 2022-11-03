module Shifter(
    input [4:0] Amount,
    input [1:0] Type,
    input [31:0] In,
    output [31:0] Out
);
    reg [31:0] Shifter_Result;
    always @ (*) begin
        case (Type)
            /*LSL*/2'b00: Shifter_Result <= In << Amount;
            /*LSR*/2'b01: Shifter_Result <= In >> Amount;
            /*ASR*/2'b10: Shifter_Result <= $signed(In) >>> Amount;
            /*ROR*/2'b11: Shifter_Result <= In >> Amount | In << (-Amount);
        endcase
    end
    assign Out = Shifter_Result;
endmodule
