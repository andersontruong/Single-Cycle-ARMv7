module DATA_MEMORY
    #(parameter DATA_WIDTH, parameter DATA_CAPACITY = 16)
    (
        clk,
        reset,
        i_Memory_Write_Enable,
        i_Memory_Address,
        i_Memory_Write_Data,
        i_Memory_to_Port3_Write_Enable,

        o_Output,
        o_Data_Bus
    );

    input  logic clk;
    input  logic reset;
    input  logic i_Memory_Write_Enable;
    input  logic [DATA_WIDTH - 1:0] i_Memory_Address;
    input  logic [DATA_WIDTH - 1:0] i_Memory_Write_Data;
    input  logic i_Memory_to_Port3_Write_Enable;

    output logic [DATA_WIDTH - 1:0] o_Output;
    output logic [(DATA_WIDTH * DATA_CAPACITY) - 1:0] o_Data_Bus;
    
    logic [DATA_WIDTH - 1:0] m_Memory_Read_Data;

    assign o_Output = i_Memory_to_Port3_Write_Enable ? m_Memory_Read_Data : i_Memory_Address;

    Memory #(.DATA_WIDTH(DATA_WIDTH), .DATA_CAPACITY(DATA_CAPACITY)) memory (
        .clk(clk),
        .reset(reset),
        .i_Memory_Write_Enable(i_Memory_Write_Enable),
        .i_Memory_Address(i_Memory_Address),
        .i_Memory_Write_Data(i_Memory_Write_Data),
        
        .o_Memory_Read_Data(m_Memory_Read_Data),
        .o_Data_Bus(o_Data_Bus)
    );

endmodule

module Memory
    #(parameter DATA_WIDTH = 32, parameter DATA_CAPACITY = 16)
    (
        clk,
        reset,
        i_Memory_Write_Enable,
        i_Memory_Address,
        i_Memory_Write_Data,

        o_Memory_Read_Data,
        o_Data_Bus
    );

    input  logic clk;
    input  logic reset;
    input  logic i_Memory_Write_Enable;
    input  logic [DATA_WIDTH - 1:0] i_Memory_Address;
    input  logic [DATA_WIDTH - 1:0] i_Memory_Write_Data;

    output logic [DATA_WIDTH - 1:0] o_Memory_Read_Data;
    output logic [(DATA_WIDTH * DATA_CAPACITY) - 1:0] o_Data_Bus;

    // 16 Memory Data

    logic [DATA_WIDTH - 1:0] memory [0:DATA_CAPACITY - 1];

    assign o_Memory_Read_Data = memory[i_Memory_Address];

    integer o;
    always @(*) begin
        for (o = 0; o < DATA_CAPACITY; o = o + 1) begin
            o_Data_Bus[o*DATA_WIDTH + DATA_WIDTH - 1 : o*DATA_WIDTH] <= memory[o];
        end
    end

    integer i = 0;
    always_ff @(posedge clk, posedge reset) begin
        if (reset)
            for (i = 0; i < DATA_CAPACITY; i++)
                memory[i] <= DATA_WIDTH'b0;
        else if (i_Memory_Write_Enable)
            memory[i_Memory_Address] <= i_Memory_Write_Data;
    end

endmodule