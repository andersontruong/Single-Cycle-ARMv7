module Main_Decoder
    (
        i_Op,
        i_Immediate_Enable,
        i_Set_Condition,

        o_Port3_Write_Enable,
        o_Memory_Write_Enable,
        o_Memory_to_Port3_Write_Enable,
        o_Operand2_Src,
        o_Immediate_Src,
        o_Port1_Read_Address_Src,
        o_Port2_Read_Address_Src,
        o_IfBranch,
        o_IfDP
    );

    input  logic [1:0] i_Op;
    input  logic i_Immediate_Enable;
    input  logic i_Set_Condition;

    output logic o_Port3_Write_Enable;
    output logic o_Memory_Write_Enable;
    output logic o_Memory_to_Port3_Write_Enable;
    output logic o_Operand2_Src;
    output logic [1:0] o_Immediate_Src;
    output logic o_Port1_Read_Address_Src;
    output logic o_Port2_Read_Address_Src;
    output logic o_IfBranch;
    output logic o_IfDP;


    assign o_Port3_Write_Enable = &~i_Op | (~i_Op[1] & i_Op[0] & i_Set_Condition);

    assign o_Memory_Write_Enable = ~i_Op[1] & i_Op[0] & ~i_Set_Condition; // Op = 01 and L bit = 0

    assign o_Memory_to_Port3_Write_Enable = ~i_Op[1] & i_Op[0] & i_Set_Condition; // Op = 01 and L bit = 1

    assign o_Operand2_Src = |{ i_Op, i_Immediate_Enable, i_Set_Condition }; // Src = 0 when DP with Register

    assign o_Immediate_Src = i_Op;

    assign o_Port1_Read_Address_Src = i_Op[1];

    assign o_Port2_Read_Address_Src = i_Op[0];

    assign o_IfBranch = i_Op[1] & ~i_Op[0];

    assign o_IfDP = &~i_Op;

endmodule