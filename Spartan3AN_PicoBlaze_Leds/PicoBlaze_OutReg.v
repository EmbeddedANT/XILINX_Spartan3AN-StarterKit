`timescale 1ns / 1ps
/*
 * Spartan3AN_PicoBlaze_Leds.v
 *
 *  ___       _         _   _       _ ___ _ _ ___
 *	| __._ _ _| |_ ___ _| |_| |___ _| | . | \ |_ _|
 *	| _>| ' ' | . / ._/ . / . / ._/ . |   |   || |
 *	|___|_|_|_|___\___\___\___\___\___|_|_|_\_||_|
 *
 *
 *  Created on	: 20/07/2015
 *      Author	: Ernesto Andres Rincon Cruz
 *      Web		: www.embeddedant.org
 *		  Device : EP4CE22F17C6N
 *		  Board  : DEO-NANO
 *
 *      Revision History:
 *			Rev 1.0.0 - (ErnestoARC) First release 19/06/2015.
 */
//////////////////////////////////////////////////////////////////////////////////


module PicoBlaze_OutReg
	#(parameter LOCAL_PORT_ID = 8'h00)
	(
	clk,
	reset,
	port_id,
	write_strobe,
	out_port,
	new_out_port);
//=======================================================
//  PARAMETER declarations
//=======================================================


//=======================================================
//  PORT declarations
//=======================================================
input  wire        clk;
input  wire        reset;
input  wire    	 [7:0] port_id;
input  wire        write_strobe;
input  wire        [7:0] out_port;
output reg  		 [7:0] new_out_port;
//=======================================================
//  REG/WIRE declarations
//=======================================================
reg RegEnable=1;





//=======================================================
//  Structural coding
//=======================================================

	always @ (*)
	begin
		if (write_strobe == 1)
			begin
				case (port_id)
					LOCAL_PORT_ID: RegEnable = 1;
					default: RegEnable = 0;
				endcase
			end
		else
			RegEnable=0;
	end
	
	
	
	always @ (posedge clk, posedge reset)
	begin
		if(reset == 1)
			new_out_port <= 8'h00;
		else
			begin
				if(RegEnable == 1)
					new_out_port <= out_port;
				else
					new_out_port <= new_out_port;
			end
	end
	
//=======================================================
// 			Connections & assigns
//======================================================= 

endmodule
