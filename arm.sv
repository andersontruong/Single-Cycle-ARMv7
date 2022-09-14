module arm
    #(parameter DATA_WIDTH = 32, parameter DATA_CAPACITY = 16) // #(.DATA_WIDTH(DATA_WIDTH))
    (
        clk,
        reset,

        o_Output,
        o_R0,
        o_R1,
        o_R2,
        o_R3,
        o_R4,
        o_R5,
        o_R6,
        o_R7,
        o_R8,
        o_R9,
        o_R10,
        o_R11,
        o_R12,
        o_R13,
        o_R14,
        o_R15,
        
        o_D0,
        o_D1,
        o_D2,
        o_D3,
        o_D4,
        o_D5,
        o_D6,
        o_D7,
        o_D8,
        o_D9,
        o_D10,
        o_D11,
        o_D12,
        o_D13,
        o_D14,
        o_D15
    );

    input  logic clk;
    input  logic reset;

    output logic [DATA_WIDTH - 1:0] o_Output;
    output logic [DATA_WIDTH - 1:0] o_R0;
    output logic [DATA_WIDTH - 1:0] o_R1;
    output logic [DATA_WIDTH - 1:0] o_R2;
    output logic [DATA_WIDTH - 1:0] o_R3;
    output logic [DATA_WIDTH - 1:0] o_R4;
    output logic [DATA_WIDTH - 1:0] o_R5;
    output logic [DATA_WIDTH - 1:0] o_R6;
    output logic [DATA_WIDTH - 1:0] o_R7;
    output logic [DATA_WIDTH - 1:0] o_R8;
    output logic [DATA_WIDTH - 1:0] o_R9;
    output logic [DATA_WIDTH - 1:0] o_R10;
    output logic [DATA_WIDTH - 1:0] o_R11;
    output logic [DATA_WIDTH - 1:0] o_R12;
    output logic [DATA_WIDTH - 1:0] o_R13;
    output logic [DATA_WIDTH - 1:0] o_R14;
    output logic [DATA_WIDTH - 1:0] o_R15;

    output logic [DATA_WIDTH - 1:0] o_D0;
    output logic [DATA_WIDTH - 1:0] o_D1;
    output logic [DATA_WIDTH - 1:0] o_D2;
    output logic [DATA_WIDTH - 1:0] o_D3;
    output logic [DATA_WIDTH - 1:0] o_D4;
    output logic [DATA_WIDTH - 1:0] o_D5;
    output logic [DATA_WIDTH - 1:0] o_D6;
    output logic [DATA_WIDTH - 1:0] o_D7;
    output logic [DATA_WIDTH - 1:0] o_D8;
    output logic [DATA_WIDTH - 1:0] o_D9;
    output logic [DATA_WIDTH - 1:0] o_D10;
    output logic [DATA_WIDTH - 1:0] o_D11;
    output logic [DATA_WIDTH - 1:0] o_D12;
    output logic [DATA_WIDTH - 1:0] o_D13;
    output logic [DATA_WIDTH - 1:0] o_D14;
    output logic [DATA_WIDTH - 1:0] o_D15;

    logic [(DATA_WIDTH*16) - 1:0] m_Register_Bus;
    logic [(DATA_WIDTH * DATA_CAPACITY) - 1:0] m_Data_Bus;

    assign o_R0 = m_Register_Bus[31 : 0];
    assign o_R1 = m_Register_Bus[63 : 32];
    assign o_R2 = m_Register_Bus[95 : 64];
    assign o_R3 = m_Register_Bus[127 : 96];
    assign o_R4 = m_Register_Bus[159 : 128];
    assign o_R5 = m_Register_Bus[191 : 160];
    assign o_R6 = m_Register_Bus[223 : 192];
    assign o_R7 = m_Register_Bus[255 : 224];
    assign o_R8 = m_Register_Bus[287 : 256];
    assign o_R9 = m_Register_Bus[319 : 288];
    assign o_R10 = m_Register_Bus[351 : 320];
    assign o_R11 = m_Register_Bus[383 : 352];
    assign o_R12 = m_Register_Bus[415 : 384];
    assign o_R13 = m_Register_Bus[447 : 416];
    assign o_R14 = m_Register_Bus[479 : 448];
    assign o_R15 = m_Register_Bus[511 : 480];

    assign o_D0 = m_Data_Bus[31:0];
    assign o_D1 = m_Data_Bus[63:32];
    assign o_D2 = m_Data_Bus[95:64];
    assign o_D3 = m_Data_Bus[127:96];
    assign o_D4 = m_Data_Bus[159:128];
    assign o_D5 = m_Data_Bus[191:160];
    assign o_D6 = m_Data_Bus[223:192];
    assign o_D7 = m_Data_Bus[255:224];
    assign o_D8 = m_Data_Bus[287:256];
    assign o_D9 = m_Data_Bus[319:288];
    assign o_D10 = m_Data_Bus[351:320];
    assign o_D11 = m_Data_Bus[383:352];
    assign o_D12 = m_Data_Bus[415:384];
    assign o_D13 = m_Data_Bus[447:416];
    assign o_D14 = m_Data_Bus[479:448];
    assign o_D15 = m_Data_Bus[511:480];

    assign o_Output = Output;

    logic [DATA_WIDTH - 1:0] m_PC;
    logic [DATA_WIDTH - 1:0] m_Instruction;
    logic m_PC_Src;

    logic [DATA_WIDTH - 1:0] Operand1;
    logic [DATA_WIDTH - 1:0] Operand2;
    logic [2:0] ALU_OpCode;
    logic [3:0] CPSR;

    logic [DATA_WIDTH - 1:0] ALU_Result;
    logic Memory_Write_Enable;
    logic [DATA_WIDTH - 1:0] Memory_Write_Data;
    logic Memory_to_Port3_Write_Enable;
    logic [DATA_WIDTH - 1:0] Output;

    FETCH #(.DATA_WIDTH(DATA_WIDTH)) fetch (
        .clk(clk),
        .reset(reset),
        .i_PC_Src(m_PC_Src),
        .i_Branch_Address(Output),
        .o_PC(m_PC),
        .o_Instruction(m_Instruction)
    );

    DECODE #(.DATA_WIDTH(DATA_WIDTH)) decode(
        .clk(clk),
        .reset(reset),
        .i_Instruction(m_Instruction),
        .i_Port3_Write_Data(o_Output),
        .i_PC(m_PC),
        .i_CPSR(CPSR),

        .o_PC_Src(m_PC_Src),
        .o_Operand1(Operand1),
        .o_Operand2(Operand2),
        .o_ALU_OpCode(ALU_OpCode),
        .o_Memory_Write_Enable(Memory_Write_Enable),
        .o_Memory_Write_Data(Memory_Write_Data),
        .o_Memory_to_Port3_Write_Enable(Memory_to_Port3_Write_Enable),
        .o_Register_Bus(m_Register_Bus)
    );

    ALU #(.DATA_WIDTH(DATA_WIDTH)) alu(
        .i_Operand1(Operand1),
        .i_Operand2(Operand2),
        .i_ALU_OpCode(ALU_OpCode),

        .o_CPSR(CPSR),
        .o_ALU_Result(ALU_Result)
    );

    DATA_MEMORY #(.DATA_WIDTH(DATA_WIDTH)) data_memory(
        .clk(clk),
        .reset(reset),
        .i_Memory_Write_Enable(Memory_Write_Enable),
        .i_Memory_Address(ALU_Result),
        .i_Memory_Write_Data(Memory_Write_Data),
        .i_Memory_to_Port3_Write_Enable(Memory_to_Port3_Write_Enable),

        .o_Output(Output),
        .o_Data_Bus(m_Data_Bus)
    );

endmodule