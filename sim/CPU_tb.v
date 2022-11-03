`timescale 1ns / 1ps
module CPU_tb();
    reg CLK100MHZ = 1'b0;
    
    wire [3:0] REG1ADDR;
    wire [3:0] REG2ADDR;
    wire [9:0] PCREG;
    wire [9:0] MEMADDR;
    wire [31:0] INST;
    wire [31:0] DATAM;
    wire [31:0] DATA1;
    wire [31:0] DATA2;
    wire ITYP, RTYP, DTYP, BTYP;
    CPU obj(CLK100MHZ, 1'b0, 1'b0, REG1ADDR, REG2ADDR, PCREG, MEMADDR, INST, DATAM, DATA1, DATA2, ITYP, RTYP, DTYP, BTYP);
    
    initial begin
        for (integer i = 0; i < 10000 * 2 - 1; i = i + 1'b1) begin
            #0.5;
            CLK100MHZ = ~CLK100MHZ;
        end
        $stop;
    end
    
endmodule
