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
    //ָ���ַ
    input wire[`InstAddrBus] pc_i,  
    //ָ��
    input wire[`InstBus] inst_i,    

    //��һ���Ĵ�����������
    input wire[`RegBus] reg1_data_i,
    //�ڶ����Ĵ�����������
    input wire[`RegBus] reg2_data_i,
    
    //��һ���Ĵ�����ʹ��
    output reg reg1_read_o,
    //�ڶ����Ĵ�����ʹ��
    output reg reg2_read_o,
    //��һ���Ĵ�����ַ
    output reg[`RegAddrBus] reg1_addr_o,
    //�ڶ����Ĵ�����ַ
    output reg[`RegAddrBus] reg2_addr_o,
    
    //��������
    output reg[`AluOpBus] aluop_o,
    //����������
    output reg[`AluSelBus] alusel_o,
    //���������1
    output reg[`RegBus] reg1_o,
    //���������2
    output reg[`RegBus] reg2_o,
    //д��Ĵ�����ַ
    output reg[`RegAddrBus] wd_o,
    //�Ƿ�Ҫд��Ĵ���
    output reg wreg_o 
    );
    //ָ����� oriֻ��26:31bit��ֵ
    wire[5:0] op = inst_i[31:26];
    wire[4:0] op2 = inst_i[10:6];
    wire[5:0] op3 = inst_i[5:0];
    wire[4:0] op4 = inst_i[20:16];

    //������
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
