
`include "defines.v"

module ex(

	input wire										rst,
	
	//送到执行阶段的信息
	input wire[`AluOpBus]         aluop_i,
	input wire[`AluSelBus]        alusel_i,
	input wire[`RegBus]           reg1_i,
	input wire[`RegBus]           reg2_i,
	input wire[`RegAddrBus]       wd_i,
	input wire                    wreg_i,

	
	output reg[`RegAddrBus]       wd_o,
	output reg                    wreg_o,
	output reg[`RegBus]						wdata_o
	
);
//保存算术运算结果
reg[`RegBus] arithmeticres;


wire reg1_lt_reg2;			//第一个操作数是否小于第二个操作数
	//无符号数比较，直接使用比较运算符reg1_i < reg2_i
assign reg1_lt_reg2 = (reg1_i < reg2_i);


//依据aluop_i指示的运算子类型进行运算
always @ (*) begin
    if(rst == `RstEnable)begin
		arithmeticres <= `ZeroWord;
	end else begin
        case (aluop_i)
            `EXE_SLTIU_OP: begin
                arithmeticres <= reg1_lt_reg2;
            end
            default: begin
                arithmeticres <= `ZeroWord;
            end
            
        endcase
    end

end//always

//选择运算结果
always @ (*)begin
    wd_o <= wd_i ;   //要写的目的寄存器地址
    wreg_o <= wreg_i;
    case (alusel_i)
        `EXE_RES_ARITHMETIC: begin//算数运算
            wdata_o <= arithmeticres;
        end

        default: begin
            wdata_o <= `ZeroWord;
        end
    endcase
end//always

endmodule // 