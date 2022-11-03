`timescale 1ns / 1ps

module ALU_tb();

    reg [3:0] OpCode;
    reg [31:0] Op1;
    reg [31:0] Op2;
    wire [31:0] Out;
    wire NFlag;
    wire ZFlag;
    wire CFlag;
    wire VFlag;
    
    ALU obj(OpCode, Op1, Op2, Out, NFlag, ZFlag, CFlag, VFlag);
    
    initial begin
        for (integer opc = 0; opc < 16; opc = opc + 1'b1) begin
            OpCode = opc;
            for (integer i = 0; i < 4; i = i + 1'b1) begin
                Op1 = $random;
                Op2 = $random;
                #5;
            end
        end
        $stop;
    end

endmodule
