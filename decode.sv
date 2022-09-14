
module DECODE
    #(parameter DATA_WIDTH = 32)
    (
        clk,
        reset,
        i_Instruction,
        i_Port3_Write_Data,
        i_PC,
        i_CPSR,

        o_PC_Src,
        o_Operand1,
        o_Operand2,
        o_ALU_OpCode,
        o_Memory_Write_Enable,
        o_Memory_Write_Data,
        o_Memory_to_Port3_Write_Enable,
        o_Register_Bus
    );

    input  logic clk;
    input  logic reset;
    input  logic [31:0] i_Instruction;
    input  logic [31:0] i_Port3_Write_Data;
    input  logic [31:0] i_PC;
    input  logic [3:0] i_CPSR;

    output logic o_PC_Src;
    output logic [31:0] o_Operand1;
    output logic [31:0] o_Operand2;
    output logic [2:0] o_ALU_OpCode;
    output logic o_Memory_Write_Enable;
    output logic [31:0] o_Memory_Write_Data;
    output logic o_Memory_to_Port3_Write_Enable;
    output logic [(DATA_WIDTH * 16) - 1:0] o_Register_Bus;

    logic [3:0] Cond;
    logic [1:0] Op;
    logic [5:0] Funct;
    logic [3:0] Rn;
    logic [3:0] Rd;
    logic [3:0] Rm;
    logic [23:0] Immediate_24;

    assign Cond = i_Instruction[31:28];
    assign Op = i_Instruction[27:26];
    assign Funct = i_Instruction[25:20];
    assign Rn = i_Instruction[19:16];
    assign Rd = i_Instruction[15:12];
    assign Rm = i_Instruction[3:0];
    assign Immediate_24 = i_Instruction[23:0];

    logic Port3_Write_Enable;
    logic Port1_Read_Address_Src;
    logic Port2_Read_Address_Src;
    logic [1:0] Immediate_Src;
    logic Operand2_Src;

    logic [31:0] Immediate_32;

    logic [3:0] Port1_Read_Address;
    logic [3:0] Port2_Read_Address;

    assign Port1_Read_Address = Port1_Read_Address_Src ? 15 : Rn;
    assign Port2_Read_Address = Port2_Read_Address_Src ? Rd : Rm;

    logic [DATA_WIDTH - 1:0] PC_Plus4;
    assign PC_Plus4 = i_PC + 4;

    logic [DATA_WIDTH - 1:0] Operand2;

    assign o_Operand2 = Operand2_Src ? Immediate_32 : Operand2;
    assign o_Memory_Write_Data = Operand2;

    Control_Unit #(.DATA_WIDTH(DATA_WIDTH)) control_unit (
        .clk(clk),
        .reset(reset),
        .i_Cond(Cond),
        .i_Op(Op),
        .i_Funct(Funct),
        .i_Rd(Rd),
        .i_CPSR(i_CPSR),

        .o_PC_Src(o_PC_Src),
        .o_Port3_Write_Enable(Port3_Write_Enable),
        .o_Memory_Write_Enable(o_Memory_Write_Enable),
        .o_Memory_to_Port3_Write_Enable(o_Memory_to_Port3_Write_Enable),
        .o_Port1_Read_Address_Src(Port1_Read_Address_Src),
        .o_Port2_Read_Address_Src(Port2_Read_Address_Src),
        .o_Immediate_Src(Immediate_Src),
        .o_Operand2_Src(Operand2_Src),
        .o_ALU_OpCode(o_ALU_OpCode)
    );

    Immediate_Select imm_select(
        .i_Immediate_24(Immediate_24),
        .i_Immediate_Src(Immediate_Src),
        
        .o_Immediate_32(Immediate_32)
    );

    Register_File #(.DATA_WIDTH(DATA_WIDTH)) register_file (
        .clk(clk),
        .reset(reset),
        .i_Port1_Read_Address(Port1_Read_Address),
        .i_Port2_Read_Address(Port2_Read_Address),
        .i_Port3_Write_Enable(Port3_Write_Enable),
        .i_Port3_Write_Address(Rd),
        .i_Port3_Write_Data(i_Port3_Write_Data),
        .i_PC(PC_Plus4),

        .o_Port1_Read_Data(o_Operand1),
        .o_Port2_Read_Data(Operand2),
        .o_Register_Bus(o_Register_Bus)
    );
 
endmodule