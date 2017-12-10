`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:58:16 11/11/2017
// Design Name:   Traffic
// Module Name:   C:/Users/IQBAL/Documents/Xilinx/Lab_7/test.v
// Project Name:  Lab_7
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Traffic
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test;

	// Inputs
	reg clk;
	reg reset;
	reg sensor_north;
	reg sensor_south;

	// Outputs
	wire [2:0] North_LEDs;
	wire [2:0] East_LEDs;
	wire [2:0] South_LEDs;
	wire [2:0] West_LEDs;

	// Instantiate the Unit Under Test (UUT)
	Traffic uut (
		.clk(clk), 
		.reset(reset), 
		.sensor_north(sensor_north), 
		.sensor_south(sensor_south), 
		.North_LEDs(North_LEDs), 
		.East_LEDs(East_LEDs), 
		.South_LEDs(South_LEDs), 
		.West_LEDs(West_LEDs)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;	sensor_north = 0;	sensor_south = 0;	#200;
		reset = 1;	sensor_north = 0;	sensor_south = 0;	#200;
		reset = 0;	sensor_north = 1;	sensor_south = 0;	#200;
		reset = 0;	sensor_north = 1;	sensor_south = 1;	#200;
		reset = 0;	sensor_north = 0;	sensor_south = 1;	#200;
		reset = 0;	sensor_north = 0;	sensor_south = 0;	#200;
		reset = 1;	sensor_north = 0;	sensor_south = 0;	#200;
		reset = 0;	sensor_north = 0;	sensor_south = 1;	#200;
		reset = 0;	sensor_north = 1;	sensor_south = 0;	#200;
		reset = 0;	sensor_north = 1;	sensor_south = 1;	#200;
	end
	always #1 clk=~clk;
endmodule

