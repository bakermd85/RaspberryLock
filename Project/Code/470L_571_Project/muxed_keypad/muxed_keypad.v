
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:20:51 10/08/2017 
// Design Name: 
// Module Name:    muxed_keypad 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module muxed_keypad(input clock,
						  input wire [2:0] col,
						  output reg [7:0] sseg,
						  output reg ssegcolon,
						  output reg [3:0] ssegd,
						  output reg [3:0] row);

	reg [3:0] number;
	reg [13:0] counter = 0;
	
	localparam row1 = 4'b0001;
	localparam row4 = 4'b0010;
	localparam row7 = 4'b0100;
	localparam rowS = 4'b1000;

	initial begin
		row <= row1;
		ssegcolon <= 1;
    	ssegd <= 4'b1001;
		sseg <= 8'b11111111;
	end
	
	always @(posedge clock) begin
		if(counter < 5208) counter = counter + 1;
		else begin
			counter = 0;

			case(row)
				row1: row <= row4;
				row4: row <= row7;
				row7: row <= rowS;
				rowS: row <= row1;
				default: row <= row1;
			endcase
		end
	end
	
	always @(posedge clock) begin
		case(row) 
			4'b0001 : begin
				if(col[0] == 1) number <= 4'b0001; //1
				else if(col[1] == 1) number <= 4'b0010; //2
				else if(col[2] == 1) number <= 4'b0011; //3
			end
			4'b0010 : begin
				if(col[0] == 1) number <= 4'b0100; //4
				else if(col[1] == 1) number <= 4'b0101; //5
				else if(col[2] == 1) number <= 4'b0110; //6
			end
			4'b0100 : begin
				if(col[0] == 1) number <= 4'b0111; //7
				else if(col[1] == 1) number <= 4'b1000; //8
				else if(col[2] == 1) number <= 4'b1001; //9			
			end
			4'b1000 : begin
				//else if(col == 1) number <= 4'b0001; //#
				if(col[1] == 1) number <= 4'b0000; //0
				//else if(col == 1) number <= 4'b0011;	//*			
			end
			default : number <= 4'b1111; 
		endcase
	end
		
	always @ (posedge clock) begin
		case(number)
		   4'b0000 : sseg <= 8'b11000000; //0
			4'b0001 : sseg <= 8'b11111001; //1
			4'b0010 : sseg <= 8'b10100100; //2
			4'b0011 : sseg <= 8'b10110000; //3
			4'b0100 : sseg <= 8'b10011001; //4
		   4'b0101 : sseg <= 8'b10010010; //5
			4'b0110 : sseg <= 8'b10000010; //6
			4'b0111 : sseg <= 8'b11111000; //7
			4'b1000 : sseg <= 8'b10000000; //8
			4'b1001 : sseg <= 8'b10011000; //9		
			default : sseg <= 8'b11111111; //Blank
		endcase
	end

endmodule

