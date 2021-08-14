`timescale 1ns / 1ps
`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/14 20:27:34
// Design Name: 
// Module Name: id
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


module id(
    input wire rst,
    //指令地址
    input wire[`InstAddrBus] pc_i,  
    //指令
    input wire[`InstBus] inst_i,    

    //第一个寄存器输入内容
    input wire[`RegBus] reg1_data_i,
    //第二个寄存器输入内容
    input wire[`RegBus] reg2_data_i,
    
    //第一个寄存器读使能
    output reg reg1_read_o,
    //第二个寄存器读使能
    output reg reg2_read_o,
    //第一个寄存器地址
    output reg[`RegAddrBus] reg1_addr_o,
    //第二个寄存器地址
    output reg[`RegAddrBus] reg2_addr_o,
    
    //运算类型
    output reg[`AluOpBus] aluop_o,
    //运算子类型
    output reg[`AluSelBus] alusel_o,
    //运算操作数1
    output reg[`RegBus] reg1_o,
    //运算操作数2
    output reg[`RegBus] reg2_o,
    //写入寄存器地址
    output reg[`RegAddrBus] wd_o,
    //是否要写入寄存器
    output reg wreg_o 
    );
    //指令功能码 ori只看26:31bit的值
    wire[5:0] op = inst_i[31:26];
    wire[4:0] op2 = inst_i[10:6];
    wire[5:0] op3 = inst_i[5:0];
    wire[4:0] op4 = inst_i[20:16];

    //立即数
    reg[`RegBus] imm;
    reg instvalid;

    always @(*) begin
        if(rst == `RstEnable) begin
            aluop_o <= `EXE_NOP_OP;
            alusel_o <= `EXE_RES_NOP;
            wd_o <= `NOPRegAddr;
            wreg_o <= `WriteDisable;
            instvalid <= `InstValid;
            reg1_read_o <= 1'b0;
            reg2_read_o <= 1'b0;
            reg1_addr_o <= `NOPRegAddr;
            reg2_addr_o <= `NOPRegAddr;
            imm <= 32'h0;
        end else begin
            aluop_o <= `EXE_NOP_OP;
            alusel_o <= `EXE_RES_NOP;
            wd_o <= inst_i[15:11];
            wreg_o <= `WriteDisable;
            instvalid <= `InstInvalid;
            reg1_read_o <= 1'b0;
            reg2_read_o <= 1'b0;
            reg1_addr_o <= inst_i[25:21];
            reg2_addr_o <= inst_i[20:16];
            imm <= `ZeroWord;   

        case(op)
        `EXE_ORI: begin
            wreg_o <= `WriteEnable;
            aluop_o <= `EXE_OR_OP;
            alusel_o <= `EXE_RES_LOGIC;
            reg1_read_o <= 1'b1;
            reg2_read_o <= 1'b0;
            imm <= {16'h0, inst_i[15:0]};
            wd_o <= inst_i[20:16];
            instvalid <= `InstValid;
        end
            default:begin
                end
        endcase
    end
    end

    always @(*) begin
        if(rst == `RstEnable) begin
            reg1_o <= `ZeroWord;
        end else if(reg1_data_i == 1'b1) begin
            reg1_o <= reg1_data_i;
        end else if(reg1_read_o == 1'b0) begin
            reg1_o <= imm;
        end else begin
            reg1_o <= `ZeroWord;
        end
    end

    always @(*) begin
        if(rst == `RstEnable) begin
            reg2_o <= `ZeroWord;
        end else if(reg2_read_o == 1'b1) begin
            reg2_o <= reg2_data_i;
        end else if(reg2_read_o == 1'b0) begin
            reg2_o <= imm;
        end else begin
            reg2_o <= `ZeroWord;
        end
    end
endmodule
