
`include "defines.v"

module id(

	input wire										rst,
	input wire[`InstAddrBus]			pc_i,
	input wire[`InstBus]          inst_i,

	input wire[`RegBus]           reg1_data_i,
	input wire[`RegBus]           reg2_data_i,

	//送到regfile的信�?
	output reg                    reg1_read_o,
	output reg                    reg2_read_o,     
	output reg[`RegAddrBus]       reg1_addr_o,
	output reg[`RegAddrBus]       reg2_addr_o, 	      
	
	//送到执行阶段的信�?
	output reg[`AluOpBus]         aluop_o,
	output reg[`AluSelBus]        alusel_o,
	output reg[`RegBus]           reg1_o,
	output reg[`RegBus]           reg2_o,
	output reg[`RegAddrBus]       wd_o,
	output reg                    wreg_o,

	input wire[`RegAddrBus]       ex_wd_i,
	input wire[`RegBus]           ex_wdata_i,  
	input wire                    ex_wreg_i,

	input wire[`RegAddrBus]       mem_wd_i,
	input wire[`RegBus]           mem_wdata_i,
	input wire                    mem_wreg_i

);

  wire[5:0] op = inst_i[31:26];
  wire[4:0] op2 = inst_i[10:6];
  wire[5:0] op3 = inst_i[5:0];
  wire[4:0] op4 = inst_i[20:16];
  //保存指令�?要的立即�?
  reg[`RegBus]	imm;
  //指令有效
  reg instvalid;
  
 //**********   对指令进行译�?*********
	
always @(*) begin
   if(rst == `RstEnable) begin
        aluop_o <=  `EXE_NOP_OP;
        alusel_o <= `EXE_RES_NOP;
        wd_o    <=  `NOPRegAddr;
        wreg_o  <=  `WriteDisable;
        instvalid   <=  `InstInvalid;
        reg1_read_o <=  1'b0;
        reg2_read_o <=  1'b0;
        reg1_addr_o <=  `NOPRegAddr;
        reg2_addr_o <=  `NOPRegAddr;
        imm         <=  32'h0;
    end else begin
        aluop_o <=  `EXE_NOP_OP;
        alusel_o <= `EXE_RES_NOP;
        wd_o    <=  inst_i[15:11];
        wreg_o  <=  `WriteDisable;
        instvalid   <=  `InstInvalid;
        reg1_read_o <=  1'b0;
        reg2_read_o <=  1'b0;
        reg1_addr_o <=  inst_i[25:21];  //默认第一个操作数寄存器为端口1读取的寄存器
        reg2_addr_o <=  inst_i[20:16];  //默认第二个操作寄存器为端�????2读取的寄存器
        imm         <=  `ZeroWord; 

        //判断指令
        case (op)
            `EXE_SLTIU:begin
                //指令写入寄存�????
                wreg_o <= `WriteEnable;
                //运算的子类型是算数比较运�????		
                aluop_o <= `EXE_SLTIU_OP;
                //运算类型是算术运�????
                alusel_o <= `EXE_RES_ARITHMETIC; 
                //通过Regfile的读端口1读取寄存�????
                reg1_read_o <= 1'b1;	
                reg2_read_o <= 1'b0;	
                //指令执行�????要的立即�????  	
                imm <= {{16{0}}, inst_i[15:0]};//{{16{inst_i[15]}}, inst_i[15:0]}
                //指令执行�????要写的目的寄存器		
                wd_o <= inst_i[20:16];		  	
                instvalid <= `InstValid;   //指令有效
            end 
            default:begin
            end 
        endcase
    end
end//always
	
/*********************************************************************************
***************************	第二阶段：确定进行运算的源操作数1***************************
*********************************************************************************/
//regfile读端�?1的输出�??
always @ (*)
begin
	if(rst == `RstEnable)
		reg1_o <= `ZeroWord;
	else 
	// 对于源操作数，若是目前端口的读取得寄存器数据地址�?  执行阶段的要写入的目的寄存器  ，那么直接将执行的结果作为reg1_o的�?��??
	//这个数相当于是要写入的数�?
		if((reg1_read_o == 1'b1) && (ex_wreg_i == 1'b1) && (ex_wd_i == reg1_addr_o) )
			reg1_o <= ex_wdata_i;	
		else
			//对于要是目的寄存器，我们要读取的寄存器其实是�?终访存要写入的寄存器，那么访存的数据就直接作为源操作数进行处�?
			if((reg1_read_o == 1'b1) && (mem_wreg_i == 1'b1) && (mem_wd_i == reg1_addr_o) )
				reg1_o <= mem_wdata_i ;
			else 
				if(reg1_read_o == 1'b1)
					reg1_o <= reg1_data_i;
				else 
					if(reg1_read_o == 1'b0)
						reg1_o <= imm;				//立即�?
					else 
						reg1_o <= `ZeroWord;
end

/*********************************************************************************
***************************	第三阶段：确定进行运算的源操作数2***************************
*********************************************************************************/
//regfile读端�?2的输出�??
always @ (*)
begin
	if(rst == `RstEnable)
		reg2_o <= `ZeroWord;
	else 
	// 对于源操作数，若是目前端口的读取得寄存器数据地址�?  执行阶段的要写入的目的寄存器  ，那么直接将执行的结果作为reg2_o的�?��??
	//这个数相当于是要写入的数�?
		if((reg2_read_o == 1'b1) && (ex_wreg_i == 1'b1) && (ex_wd_i == reg2_addr_o) )
			reg2_o <= ex_wdata_i;	
		else
			//对于要是目的寄存器，我们要读取的寄存器其实是�?终访存要写入的寄存器，那么访存的数据就直接作为源操作数进行处�?
			if((reg2_read_o == 1'b1) && (mem_wreg_i == 1'b1) && (mem_wd_i == reg2_addr_o) )
				reg2_o <= mem_wdata_i ;
			else 
				if(reg2_read_o == 1'b1)
					reg2_o <= reg2_data_i;
				else 
					if(reg2_read_o == 1'b0)
						reg2_o <= imm;				//立即�?
					else 
						reg2_o <= `ZeroWord;
end

endmodule