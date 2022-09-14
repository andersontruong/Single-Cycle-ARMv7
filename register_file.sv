module Register_File
    #(parameter DATA_WIDTH = 32)
    (  
        clk,
        reset,
        i_Port1_Read_Address,
        i_Port2_Read_Address,
        i_Port3_Write_Enable,
        i_Port3_Write_Address,
        i_Port3_Write_Data,
        i_PC,

        o_Port1_Read_Data,
        o_Port2_Read_Data,
        o_Register_Bus
    );

    input  logic clk;
    input  logic reset;
    input  logic [3:0] i_Port1_Read_Address;
    input  logic [3:0] i_Port2_Read_Address;
    input  logic i_Port3_Write_Enable;
    input  logic [3:0]i_Port3_Write_Address;
    input  logic [DATA_WIDTH - 1:0] i_Port3_Write_Data;
    input  logic [DATA_WIDTH - 1:0] i_PC;

    output logic [DATA_WIDTH - 1:0] o_Port1_Read_Data;
    output logic [DATA_WIDTH - 1:0] o_Port2_Read_Data;

    output logic [(DATA_WIDTH * 16) - 1:0] o_Register_Bus;

    // Memory
    logic [DATA_WIDTH - 1:0] memory [0:14];
    
    integer j;
    always_comb begin
        for (j = 0; j < 15; j = j + 1) o_Register_Bus[32*j + 31 : 32*j] <= memory[j]; 
        o_Register_Bus[32*15 + 31 : 32*15] <= i_PC;
    end
        

    assign o_Port1_Read_Data = i_Port1_Read_Address == 15 ? i_PC : memory[i_Port1_Read_Address];
    assign o_Port2_Read_Data = i_Port2_Read_Address == 15 ? i_PC : memory[i_Port2_Read_Address];

    integer i = 0;
    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            for (i = 0; i < 15; i = i + 1)
                memory[i] = 32'b0;
            
        end
        else if (i_Port3_Write_Enable) begin
            memory[i_Port3_Write_Address] = i_Port3_Write_Data;
        end
    end

endmodule