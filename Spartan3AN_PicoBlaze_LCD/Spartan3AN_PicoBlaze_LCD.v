`timescale 1ns / 1ps
/*
 * Spartan3AN_PicoBlaze_LCD.v
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
 *		  Device : XC3S700AN - 4FGG484
 *		  Board  : Spartan-3AN Starter Kit.
 *
 *      Revision History:
 *			Rev 1.0.0 - (ErnestoARC) First release 19/06/2015.
 */
//////////////////////////////////////////////////////////////////////////////////

module Spartan3AN_PicoBlaze_LCD(
	//////////// CLOCK //////////
	CLK_50M,
	//////////// LCD //////////
	LCD_DB,
	LCD_E,
	LCD_RS,
	LCD_RW
);

//=======================================================
//  PARAMETER declarations
//=======================================================
parameter  LCD_PORT_ID = 8'h00;

//=======================================================
//  PORT declarations
//=======================================================

input  wire        CLK_50M;
output wire  		 [7:0] LCD_DB;
output wire  		 LCD_E;
output wire  		 LCD_RS;
output wire  		 LCD_RW;

//=======================================================
//  REG/WIRE declarations
//=======================================================
wire [7:0] Lcd_Port;

//=======================================================
//  Structural coding
//=======================================================


//******************************************************************//
// Instantiate PicoBlaze and the Program ROM.                       // 
//******************************************************************//

  wire    [9:0] address;
  wire    [17:0] instruction;
  wire    [7:0] port_id;
  wire    [7:0] out_port;
  wire    [7:0] in_port;
  wire          write_strobe;
  wire          read_strobe;
  wire          interrupt;
  wire          reset;		

  kcpsm3 kcpsm3_inst (
    .address(address),
    .instruction(instruction),
    .port_id(port_id),
    .write_strobe(write_strobe),
    .out_port(out_port),
    .read_strobe(read_strobe),
    .in_port(in_port),
    .interrupt(interrupt),
    .interrupt_ack(),
    .reset(reset),
    .clk(CLK_50M));

  picocode picocode_inst (
    .address(address),
    .instruction(instruction),
    .clk(CLK_50M)); 
	 
	PicoBlaze_OutReg	#(.LOCAL_PORT_ID(LCD_PORT_ID)) Lcd_Port_inst(
	 .clk(CLK_50M),
	 .reset(reset),
	 .port_id(port_id),
	 .write_strobe(write_strobe),
	 .out_port(out_port),
	 .new_out_port(Lcd_Port));
//=======================================================
// 			Connections & assigns
//======================================================= 

//******************************************************************//
// Input PicoBlaze Interface.                       					  // 
//******************************************************************//
assign in_port = 8'h00;
assign interrupt = 1'b0;
assign reset = 1'b0;
//******************************************************************//
// Output PicoBlaze Interface.                       					  // 
//******************************************************************//

assign LCD_E=Lcd_Port[0];
assign LCD_RW=Lcd_Port[1];
assign LCD_RS=Lcd_Port[2];
assign LCD_DB={Lcd_Port[7:4],4'bzzzz};


endmodule
