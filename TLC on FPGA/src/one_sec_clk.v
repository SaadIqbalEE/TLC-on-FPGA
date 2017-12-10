`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SEECS, NUST
// Engineer: Saad
// 
// Create Date:    13:47:32 11/11/2017 
// Design Name: 
// Module Name:    pone_sec_clk 
// Project Name: 
// Target Devices: Virtex-5 ML-507
// Tool versions: 
// Description: Generate 1Hz clk from 100 MHz source
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module pone_sec_clk(clk_in,
						 clk_out
						 );
		
	input 		clk_in;
	output reg 	clk_out = 0;
	
	reg [26:0]	clk_reg = 27'd0;
				
	always @(posedge clk_in)
	begin
		if(clk_reg == 27'd50000000)
		begin
			clk_out <= 1;
			clk_reg <= 27'd1;
		end
		else
		begin
			clk_reg <= clk_reg+ 27'd1;
			clk_out <= 0;
		end
	end		
endmodule
