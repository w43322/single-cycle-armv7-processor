module GetType(
    input ConditionIsMet,
    input [2:0] Type,
    output I_Type,
    output R_Type,
    output D_Type,
    output B_Type
);
    assign I_Type = ConditionIsMet & ~Type[2] & ~Type[1] & Type[0];
    assign R_Type = ConditionIsMet & ~Type[2] & ~Type[1] & ~Type[0];
    assign D_Type = ConditionIsMet & ~Type[2] & Type[1] & ~Type[0];
    assign B_Type = ConditionIsMet & Type[2] & ~Type[1] & Type[0];
endmodule
