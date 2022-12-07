`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.11.2021 22:38:18
// Design Name: 
// Module Name: riscv_reg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module riscv_reg(   input clk, 
                    input [2:0] func3,
                    input [4:0] rd_addr, 
                    input [31:0] rd_data_in, 
                    input [4:0] rs1_addr, 
                    input [4:0] rs2_addr, 
                    input write_enable, 
                    input mem_wr,
                    output reg [31:0] rs1_data, 
                    output reg [31:0] rs2_data );

reg [31:0] reg_file [0:31];

initial 
begin
    reg_file[0] = 32'h00000000;
    reg_file[1] = 32'h00000000;
//    reg_file[2] = 32'h00000001;
    reg_file[2] = 32'h0;
    reg_file[3] = 32'h0;
    reg_file[4] = 32'h0;
    reg_file[5] = 32'h0;
    reg_file[6] = 32'h0;
    reg_file[7] = 32'h0;
    reg_file[8] = 32'h0;
    reg_file[9] = 32'h0;
    reg_file[10] = 32'h0;
    reg_file[11] = 32'h0;
    reg_file[12] = 32'hF000000F;
    reg_file[13] = 32'h0;
    reg_file[14] = 32'h0;
    reg_file[15] = 32'h0;
    reg_file[16] = 32'h0;
    reg_file[17] = 32'h0;
    reg_file[18] = 32'h0;
    reg_file[19] = 32'h0;
    reg_file[20] = 32'h0;
    reg_file[21] = 32'h0;
    reg_file[22] = 32'h0;
    reg_file[23] = 32'h0;
    reg_file[24] = 32'h0;
    reg_file[25] = 32'h0;
    reg_file[26] = 32'h0;
    reg_file[27] = 32'h0;
    reg_file[28] = 32'h0;
    reg_file[29] = 32'h0;
    reg_file[30] = 32'h0;
    reg_file[31] = 32'h0;
end 

always @ (posedge clk) begin
    if (write_enable == 1)begin
        if(rd_addr[4:0] != 5'd0)
            if(mem_wr == 0)
                reg_file[rd_addr] = rd_data_in;
            else
                begin
                case(func3)
                    3'b000:begin
                        reg_file[rd_addr] = {{24{rd_data_in[7]}}, rd_data_in[7:0]};
                        end
                    3'b001:begin
                        reg_file[rd_addr] = {{16{rd_data_in[15]}}, rd_data_in[15:0]};
                        end
                    3'b010:begin
                        reg_file[rd_addr] = rd_data_in;
                        end
                    3'b100:begin
                        reg_file[rd_addr] = {{24{0}}, rd_data_in[7:0]};
                        end
                    3'b101:begin
                        reg_file[rd_addr] = {{16{0}}, rd_data_in[15:0]};
                        end
                endcase
                end
        end
    else begin
        rs1_data = reg_file[rs1_addr];
        rs2_data = reg_file[rs2_addr];
    end
end
endmodule
