`timescale 1ns / 1ps
`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/15 11:30:09
// Design Name: 
// Module Name: openmips
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
module openmips(
    input wire clk,
    input wire rst,
    
    input wire[`RegBus] rom_data_i,
    output wire[`RegBus] rom_addr_o,
    output wire rom_ce_o
    );

    //IF/IDģ��������IDģ��ı���
    wire[`InstAddrBus] pc;
    wire[`InstAddrBus] id_pc_i;
    wire[`InstBus] id_inst_i;

    //��������׶�IDģ�������ID/EXģ����������
    wire[`AluOpBus] id_aluop_o;
    wire[`AluSelBus] id_alusel_o;
    wire[`RegBus] id_reg1_o;
    wire[`RegBus] id_reg2_o;
    wire id_wreg_o;
    wire[`RegAddrBus] id_wd_o;

    //����ID/EXģ�������EXģ����������
    wire[`AluOpBus] ex_aluop_i;
    wire[`AluSelBus] ex_alusel_i;
    wire[`RegBus] ex_reg1_i;
    wire[`RegBus] ex_reg2_i;
    wire ex_wreg_i;
    wire[`RegAddrBus] ex_wd_i;

    //����ִ�н׶�EX�����EX/MEMģ������
    wire ex_wreg_o;
    wire[`RegAddrBus] ex_wd_o;
    wire[`RegBus] ex_wdata_o;

    //����EX/MEMģ��������ô�׶�MNMģ�������
    wire mem_wreg_i;
    wire[`RegAddrBus] mem_wd_i;
    wire[`RegBus] mem_wdata_i;

    //���ӷô�׶�MEM�������MEM/WBģ�������
    wire mem_wreg_o;
    wire[`RegAddrBus] mem_wd_o;
    wire[`RegBus] mem_wdata_o;

    //����MEM/WBģ���������д�׶ε�����
    wire wb_wreg_i;
    wire[`RegAddrBus] wb_wd_i;
    wire[`RegBus] wb_wdata_i;

    //��������׶�ID��ͨ�üĴ���Regfileģ��
    wire reg1_read;
    wire reg2_read;
    wire[`RegBus] reg1_data;
    wire[`RegBus] reg2_data;
    wire[`RegAddrBus] reg1_addr;
    wire[`RegAddrBus] reg2_addr;

    //pc_regʵ����
    pc_reg u_pc_reg(
    	.clk (clk ),
        .rst (rst ),
        .pc  (pc  ),
        .ce  (rom_ce_o  )
    );
    
    assign rom_addr_o = pc;

    //IF/IDģ������
    if_id u_if_id(
    	.clk     (clk     ),
        .rst     (rst     ),
        .if_pc   (pc      ),
        .if_inst (rom_data_i ),
        .id_pc   (id_pc_i   ),
        .id_inst (id_inst_i )
    );

    //����׶�ID����
    id u_id(
    	.rst         (rst            ),
        .pc_i        (id_pc_i        ),
        .inst_i      (id_inst_i      ),
        .reg1_data_i (reg1_data      ),
        .reg2_data_i (reg2_data      ),
        .reg1_read_o (reg1_read      ),
        .reg2_read_o (reg2_read      ),
        .reg1_addr_o (reg1_addr      ),
        .reg2_addr_o (reg2_addr      ),
        .aluop_o     (id_aluop_o     ),
        .alusel_o    (id_alusel_o    ),
        .reg1_o      (id_reg1_o      ),
        .reg2_o      (id_reg2_o      ),
        .wd_o        (id_wd_o        ),
        .wreg_o      (id_wreg_o      )
    );
    
    //ͨ�üĴ���Regfile����
    regfile u_regfile(
    	.clk    (clk    ),
        .rst    (rst    ),
        .we     (wb_wreg_i ),
        .waddr  (wb_wd_i  ),
        .wdata  (wb_wdata_i  ),
        .re1    (re1_read    ),
        .raddr1 (reg1_addr ),
        .rdata1 (reg1_data ),
        .re2    (re2_read    ),
        .raddr2 (reg2_addr ),
        .rdata2 (reg2_data )
    );

    //ID/EXģ������
    id_ex u_id_ex(
    	.clk       (clk       ),
        .rst       (rst       ),
        .id_aluop  (id_aluop_o  ),
        .id_alusel (id_alusel_o ),
        .id_reg1   (id_reg1_o   ),
        .id_reg2   (id_reg2_o   ),
        .id_wd     (id_wd_o     ),
        .id_wreg   (id_wreg_o   ),
        .ex_aluop  (ex_aluop_i  ),
        .ex_alusel (ex_alusel_i ),
        .ex_reg1   (ex_reg1_i   ),
        .ex_reg2   (ex_reg2_i   ),
        .ex_wd     (ex_wd_i     ),
        .ex_wreg   (ex_wreg_i   )
    );
    
    //EXģ������
    ex u_ex(
    	.rst      (rst      ),
        .aluop_i  (ex_aluop_i  ),
        .alusel_i (ex_alusel_i ),
        .reg1_i   (ex_reg1_i   ),
        .reg2_i   (ex_reg2_i   ),
        .wd_i     (ex_wd_i     ),
        .wreg_i   (ex_wreg_i   ),
        .wd_o     (ex_wd_o     ),
        .wreg_o   (ex_wreg_o   ),
        .wdata_o  (ex_wdata_o  )
    );
    
    //EX/MEMģ������
    ex_mem u_ex_mem(
    	.clk       (clk       ),
        .rst       (rst       ),
        .ex_wd     (ex_wd_o     ),
        .ex_wreg   (ex_wreg_o   ),
        .ex_wdata  (ex_wdata_o  ),
        .mem_wd    (mem_wd_i    ),
        .mem_wreg  (mem_wreg_i  ),
        .mem_wdata (mem_wdata_i )
    );
    
    //MEMģ������
    mem u_mem(
    	.rst     (rst     ),
        .wd_i    (mem_wd_i    ),
        .wreg_i  (mem_wreg_i  ),
        .wdata_i (mem_wdata_i ),
        .wd_o    (mem_wd_o    ),
        .wreg_o  (mem_wreg_o  ),
        .wdata_o (mem_wdata_o )
    );
    
    //MEM/WBģ������
    mem_wb u_mem_wb(
    	.clk       (clk       ),
        .rst       (rst       ),
        .mem_wd    (mem_wd_o    ),
        .mem_wreg  (mem_wreg_o  ),
        .mem_wdata (mem_wdata_o ),
        .wb_wd     (wb_wd_i     ),
        .wb_wreg   (wb_wreg_i   ),
        .wb_wdata  (wb_wdata_i  )
    );
    

endmodule
