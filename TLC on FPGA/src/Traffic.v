`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Seecs, NUST
// Engineer: Saad Iqbal, Noor Muhammad Malik, Tayyab Hassan
// 
// Create Date:    13:46:47 11/11/2017 
// Design Name: 	 Adaptive Traffic Control
// Module Name:    Traffic 
// Project Name: 
// Target Devices: Virtex-5 ML-507 Board
// Tool versions: 
// Description: 
//
// Dependencies: one_sec_clk.v
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Traffic(clk,
					reset,
					sensor_north,
					sensor_south,
					North_LEDs,
					East_LEDs,
					South_LEDs,
					West_LEDs
					);
	input					clk, reset, sensor_north, sensor_south;
	output reg	[2:0]	North_LEDs, East_LEDs, South_LEDs, West_LEDs;
	
	parameter			T1 = 4'd2, T2= 4'd2, T3= 4'd4, T4= 4'd8;
	parameter			E = 4'b0000, ES = 4'b0001, EW = 4'b0010,	S = 4'b0011, SW = 4'b0100;
	parameter			W = 4'b0101, WN = 4'b0110, WE = 4'b0111,	N = 4'b1000, NE = 4'b1001;
	parameter			C1 = 3'b100, C2 = 3'b110,	C3 = 3'b010,	C4 = 3'b001;
	
	reg			[3:0]	p_state = 4'b0000, n_state = 4'b0001;
	wire					clk_p5s;
	reg					clk_adapt = 0;
	reg					transition = 0;
	reg			[3:0]	require_delay;
	reg			[3:0]	count = 4'b0001;
	
	assign				reset_n = ~reset;	
	
//measuring current required delay	
	always @(sensor_north, sensor_south, transition)
	begin
		if (transition)
			require_delay = T1;
		else if (sensor_north & sensor_south)
			require_delay = T2;
		else if (!sensor_north & !sensor_south)
			require_delay = T4;
		else
			require_delay = T3;
	end

//obtaining 0.5 sec clock		
	pone_sec_clk clock1 (.clk_in	(clk),
							  .clk_out	(clk_p5s)
							  );
	
//obtaining adaptive delay clock	
	always @(posedge clk_p5s, negedge reset_n)
	begin
		if (reset_n == 0)
		begin
			count <= 4'd1;
			clk_adapt <= 0;
		end
		else
		begin
			if (count == require_delay)
			begin
				count <= 4'd1;
				clk_adapt <= 1;
			end
			else
			begin
				count <= count + 4'd1;
				clk_adapt <= 0 ;
			end
		end
	end

//obtaining current state and transition bit value					
	always @(sensor_north, sensor_south, p_state)
	begin
		case (p_state)
			E: 
			begin				
				if (sensor_south)
				begin
					n_state = ES;
					transition = 0;
				end
				else
				begin
					n_state = EW;
					transition = 0;
				end
			end
			ES:
			begin
				n_state = S;
				transition = 1;
			end
			EW:
			begin
				n_state = W;
				transition = 1;
			end
			S:
			begin
				n_state = SW;
				transition = 0;
			end
			SW:
			begin
				n_state = W;
				transition = 1;
			end
			W:
			begin				
				if (sensor_north)
				begin
					n_state = WN;
					transition = 0;
				end
				else
				begin
					n_state = WE;
					transition = 0;
				end
			end
			WN:
			begin
				n_state = N;
				transition = 1;
			end
			WE:
			begin
				n_state = E;
				transition = 1;
			end
			N:
			begin
				n_state = NE;
				transition = 0;
			end
			NE:
			begin
				n_state = E;
				transition = 1;
			end
			default:
			begin
				n_state = E;
				transition = 0;
			end
		endcase
	end

//assigning value to present state with async reset		
	always @(posedge clk_adapt, negedge reset_n)
	begin
		if (reset_n==0)
			p_state <= E;
		else
			p_state <= n_state;
	end

//assign output depending upon p_state		
	always @(p_state)
	begin
		case (p_state)
			E:
			begin
				North_LEDs	= C1; 
				East_LEDs	= C4;
				South_LEDs	= C1;
				West_LEDs	= C1;
			end
			ES:
			begin
				North_LEDs	= C1;
				East_LEDs	= C3;
				South_LEDs	= C2;
				West_LEDs	= C1;
			end
			EW:
			begin
				North_LEDs	= C1;
				East_LEDs	= C3;
				South_LEDs	= C1;
				West_LEDs	= C2;
			end
			S:
			begin
				North_LEDs	= C1;
				East_LEDs	= C1;
				South_LEDs	= C4;
				West_LEDs	= C1;
			end
			SW:
			begin
				North_LEDs	= C1;
				East_LEDs	= C1;
				South_LEDs	= C3;
				West_LEDs	= C2;
			end
			W:
			begin
				North_LEDs	= C1;
				East_LEDs	= C1;
				South_LEDs	= C1;
				West_LEDs	= C4;
			end
			WN:
			begin
				North_LEDs	= C2;
				East_LEDs	= C1;
				South_LEDs	= C1;
				West_LEDs	= C3;
			end
			WE:
			begin
				North_LEDs	= C1;
				East_LEDs	= C2;
				South_LEDs	= C1;
				West_LEDs	= C3;
			end
			N:
			begin
				North_LEDs	= C4;
				East_LEDs	= C1;
				South_LEDs	= C1;
				West_LEDs	= C1;
			end
			NE:
			begin
				North_LEDs	= C3;
				East_LEDs	= C2;
				South_LEDs	= C1;
				West_LEDs	= C1;
			end
			default:
			begin
				North_LEDs	= C1;
				East_LEDs	= C4;
				South_LEDs	= C1;
				West_LEDs	= C1;
			end
		endcase
	end
endmodule
