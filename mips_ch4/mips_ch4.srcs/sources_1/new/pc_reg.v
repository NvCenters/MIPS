`timescale 1ns / 1ps
`include "defines.v" 
//////////////////////////////////////////////////////////////////////////////////
// Company: NUC
// Engineer: Sunruixi
// 
// Create Date: 2021/08/14 17:17:40
// Design Name: PC
// Module Name: pc_reg
// Project Name: MIPS CPU
// Target Devices: 
// Tool Versions: 
// Description:给出指令地址 
// Dependencies: defines.v
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pc_reg(
    input wire clk,
    input wire rst,
    output reg[`InstAddrBus] pc,
    output reg ce 
    );
    always @(posedge clk ) begin
        if (rst == `RstEnable) begin
            ce <= `ChipDisable;
        end else begin  //复位结束后，指令储存器使能
            ce <= `ChipEnable;
        end
    end

    always @(posedge clk ) begin
        if (ce == `ChipDisable) begin
            pc <= 32'h0000_0000;
        end else begin
            pc <= pc+ 4'h4;     //由于指令大小4个字节，取指每次加4
        end
    end
endmodule
