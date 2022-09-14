module Control_Unit
    #(parameter DATA_WIDTH = 32)
    (
        clk,
        reset,
        i_Cond,
        i_Op,
        i_Funct,
        i_Rd,
        i_CPSR,

        o_PC_Src,
        o_Port3_Write_Enable,
        o_Memory_Write_Enable,
        o_Memory_to_Port3_Write_Enable,
        o_Port1_Read_Address_Src,
        o_Port2_Read_Address_Src,
        o_Immediate_Src,
        o_Operand2_Src,
        o_ALU_OpCode,
    );

    input  logic clk;
    input  logic reset;
    input  logic [3:0] i_Cond;
    input  logic [1:0] i_Op;
    input  logic [5:0] i_Funct;
    input  logic [3:0] i_Rd;
    input  logic [3:0] i_CPSR;

    output logic o_PC_Src;
    output logic o_Port3_Write_Enable;
    output logic o_Memory_Write_Enable;
    output logic o_Memory_to_Port3_Write_Enable;
    output logic o_Port1_Read_Address_Src;
    output logic o_Port2_Read_Address_Src;
    output logic [1:0] o_Immediate_Src;
    output logic o_Operand2_Src;
    output logic [2:0] o_ALU_OpCode;

    logic Immediate_Enable;
    logic [3:0] OpCode;
    logic Set_Condition;

    assign Immediate_Enable = i_Funct[5];
    assign OpCode = i_Funct[4:1];
    assign Set_Condition = i_Funct[0];

    logic IfBranch;
    logic Port3_Write_Enable;
    logic Memory_to_Port3_Write_Enable;
    logic IfDP;

    Main_Decoder md(
        .i_Op(i_Op),
        .i_Immediate_Enable(Immediate_Enable),
        .i_Set_Condition(Set_Condition),

        .o_Port3_Write_Enable(Port3_Write_Enable),
        .o_Memory_Write_Enable(o_Memory_Write_Enable),
        .o_Memory_to_Port3_Write_Enable(Memory_to_Port3_Write_Enable),
        .o_Operand2_Src(o_Operand2_Src),
        .o_Immediate_Src(o_Immediate_Src),
        .o_Port1_Read_Address_Src(o_Port1_Read_Address_Src),
        .o_Port2_Read_Address_Src(o_Port2_Read_Address_Src),
        .o_IfBranch(IfBranch),
        .o_IfDP(IfDP)
    );

    logic IfCondition;
    logic [3:0] CPSR;
    
    Check_Condition check(
        .i_Cond(i_Cond),
        .i_CPSR(CPSR),
        .o_IfCondition(IfCondition)
    );

    ALU_Decoder alu_decoder(
        .clk(clk),
        .reset(reset),
        .i_OpCode(OpCode),
        .i_Set_Condition(Set_Condition),
        .i_CPSR(i_CPSR),
        .i_IfCondition(IfCondition),
        .i_IfDP(IfDP),

        .o_ALU_OpCode(o_ALU_OpCode),
        .o_CPSR(CPSR)
    );

    assign o_PC_Src = IfCondition & (((i_Rd == 15) & Port3_Write_Enable) | IfBranch);
    assign o_Port3_Write_Enable = IfCondition & Port3_Write_Enable;
    assign o_Memory_to_Port3_Write_Enable = IfCondition & Memory_to_Port3_Write_Enable;

endmodule