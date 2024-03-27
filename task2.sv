`default_nettype none


module BCDtoSevenSegment
(input logic [3:0] bcd,
output logic [6:0] segment);
  always_comb
    unique case (bcd)
      4'b0000: segment = ~(7'b011_1111);
      4'b0001: segment = ~(7'b000_0110);
      4'b0010: segment = ~(7'b101_1011);
      4'd3: segment = ~(7'b100_1111);
      4'd4: segment = ~(7'b110_0110);
      4'd5: segment = ~(7'b110_1101);
      4'd6: segment = ~(7'b111_1101);
      4'd7: segment = ~(7'b000_0111);
      4'd8: segment = ~(7'b111_1111);
      4'd9: segment = ~(7'b110_0111);
      default: segment = ~(7'bxxx_xxxx);
    endcase
endmodule: BCDtoSevenSegment



module BCDtoSevenSegment_2bitinput
(input logic [1:0] bcd,
output logic [6:0] segment);
  always_comb
    unique case (bcd)
      2'b00: segment = ~(7'b011_1111);
      2'b01: segment = ~(7'b000_0110);
      2'b10: segment = ~(7'b101_1011);
      2'd3: segment = ~(7'b100_1111);
      

    endcase
endmodule: BCDtoSevenSegment_2bitinput




module chipInterface(input logic [17:0] SW, 
                     output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
							output logic [7:0] LEDG,
							input logic [3:0] KEY,
							input logic CLOCK_50, //this and below are the inputs to vga master
							output logic [7:0] VGA_R, VGA_G, VGA_B,
							output logic VGA_BLANK_N, VGA_CLK, VGA_SYNC_N,
							output logic VGA_VS, VGA_HS);


   logic reset, circle, triangle, pentagon, UART_RXD;
   logic manualMode, manualClockL;
   logic manualCircleL, manualTriangleL, manualPentagonL;
   logic clock;
	logic [1:0] coin;
	
	//more arguments to vga master
   logic [3:0] numGames;
   logic loadNumGames;
   logic [3:0] roundNumber;
   logic [11:0] guess;
   logic loadGuess;
   logic [3:0] znarly, zood;
   logic loadZnarlyZood;
   logic clearGame;

   logic [11:0] masterPattern;
   logic displayMasterPattern;


   mastermindVGA vga(.CLOCK_50(CLOCK_50),// VGA display signals -- route directly to FPGA pins
             .VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B),
             .VGA_BLANK_N(VGA_BLANK_N), .VGA_CLK(VGA_CLK), .VGA_SYNC_N(VGA_SYNC_N),
             .VGA_VS(VGA_VS), .VGA_HS(VGA_HS),
// game information
             .numGames(numGames),
             .loadNumGames(loadNumGames),
// Items for a particular round
             .roundNumber(roundNumber),
             .guess(guess),            
             .loadGuess(loadGuess),
             .znarly, .zood,
             .loadZnarlyZood,
             .clearGame,
// master patterns
             .masterPattern,
             .displayMasterPattern,
             .reset
);


   //assign reset = SW[0];
   /*assign manualMode = 1'b1;
   assign manualClockL = KEY[0];
   assign manualCircleL = KEY[1];
   assign manualTriangleL = KEY[2];
   assign manualPentagonL = KEY[3];*/



   /*coinAccepter ca (.CLOCK_50, // pin Y2
    .reset,
    .UART_RXD,
    .circle, .triangle, .pentagon,
    .manualMode, .manualClockL,
    .manualCircleL, .manualTriangleL, .manualPentagonL,
    .clock);*/
   always_comb begin
	  if(circle) 
	    coin <= 2'b01;
	  else if(triangle)
	    coin <= 2'b10;
	  else if(pentagon)
	    coin <= 2'b11;
	  else
	    coin <= 2'b00;
	
	end
	
   logic [1:0] CoinValue;
	logic CoinInserted, StartGame;
	logic [11:0] Guess;
	logic GradeIt;
   logic [2:0] LoadShape;
	logic [1:0] ShapeLocation;
	logic LoadShapeNow;
	logic [3:0] Znarly, Zood, RoundNumber, NumGames;
	logic GameWon, debug;
	
   assign CoinValue = SW[17:16]; 	
	//assign CoinInserted = KEY[1];
	//assign StartGame = KEY[2];
	assign Guess = SW[11:0];
	
	//assign GradeIt = KEY[3]; //Active when pressed
	assign LoadShape = SW[2:0];
   assign ShapeLocation = SW[4:3];
  //assign LoadShapeNow = KEY[3]; //Active when pressed
	
	
	BCDtoSevenSegment bcd3(.bcd(Znarly), .segment(HEX3));
	BCDtoSevenSegment bcd2(.bcd(Zood), .segment(HEX2));
	BCDtoSevenSegment bcd1(.bcd(RoundNumber), .segment(HEX1));
	BCDtoSevenSegment bcd0(.bcd(NumGames), .segment(HEX0));



   //assign GameWon = LEDG[0];
	assign LEDG[0] = GameWon;
   //assign reset = KEY[0] ;//Asynchronous!
   assign clock = CLOCK_50;// So fast!
   assign debug = SW[15]; 
	
	
	logic key0_not, key1_not, key2_not, key3_not;
	assign key0_not = ~KEY[0];
	assign key1_not = ~KEY[1];
	assign key2_not = ~KEY[2];
	assign key3_not = ~KEY[3];
	Synchronizer
    (.async(key0_not), .clock,
     .sync(reset));
	  Synchronizer
    (.async(key1_not), .clock,
     .sync(CoinInserted));
	   Synchronizer
    (.async(key2_not), .clock,
     .sync(StartGame));
	  Synchronizer
    (.async(key3_not), .clock,
     .sync(LoadShapeNow));
	  
	  Synchronizer
    (.async(key3_not), .clock,
     .sync(GradeIt));
	
	logic random;
	assign LEDG[2] = CoinInserted;
	
	
	/*BCDtoSevenSegment bcd3(.bcd(Znarly), .segment(HEX3));
	BCDtoSevenSegment bcd2(.bcd(Zood), .segment(HEX2));
	BCDtoSevenSegment bcd1(.bcd(RoundNumber), .segment(HEX1));
	BCDtoSevenSegment bcd0(.bcd(NumGames), .segment(HEX0));*/
	BCDtoSevenSegment bcdddd(.bcd(LoadShape), .segment(HEX4));
	BCDtoSevenSegment_2bitinput bcddd(.bcd(ShapeLocation), .segment(HEX5));
	logic cannot_start;
	assign LEDG[3] = (cannot_start);
	assign LEDG[4] = ~KEY[3];
	logic GameOver;
	
   task2 task2_module(.coinInserted(CoinInserted),
             .coinValue(CoinValue),
             .numGames_can_be_played(NumGames), .RoundNumber(RoundNumber),
             .startGame(StartGame),
             //input logic loadnumGames,
             //input logic loadGuess,
             //input logic [11:0] MasterPattern, //ask in oh
             .GuessPattern(Guess), 
             .LoadShape(LoadShape), 
             .ShapeLocation(ShapeLocation),
             .LoadShapeNow, 
             .GameWon,
             .GameOver,
				 .cannot_start,
             .clock, .reset, .GradeIt);

endmodule: chipInterface


/*module chipInterface(input logic [17:0] SW, 
                     output logic [6:0] HEX0, HEX1, HEX2, HEX3, 
							output logic [7:0] LEDG,
							output logic [17:0] LEDR,
							input logic [3:0] KEY,
							input logic CLOCK_50, //this and below are the inputs to vga master
							output logic [7:0] VGA_R, VGA_G, VGA_B,
							output logic VGA_BLANK_N, VGA_CLK, VGA_SYNC_N,
							output logic VGA_VS, VGA_HS);
							
	 assign LEDR[0] = ~KEY[0];
    assign LEDR[1] = ~KEY[1];
    assign LEDR[2] = ~KEY[2];
    
					
endmodule: chipInterface*/
