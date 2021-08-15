`timescale 1ns / 1ps
`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/15 16:07:29
// Design Name: 
// Module Name: inst_rom
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


module inst_rom(
    input wire ce,
    input wire[`InstAddrBus] addr,
    output reg[`InstBus] inst
    );

    reg[`InstBus] inst_mem[0:`InstMemNum-1];
    initial $readmemh("E:/Program/Fpga/Project/mips_ch4/mips_ch4.srcs/sources_1/new/inst_rom.data", inst_mem);

    always @(*) begin
        if(ce == `ChipDisable) begin
            inst <= `ZeroWord;
        end else begin
            inst <= inst_mem[addr[`InstMemNumLog2+1:2]];
        end
    end
endmodule
