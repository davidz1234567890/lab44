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
                                                        input logic UART_RXD,
                                                        input logic CLOCK_50, //this and below are the inputs to vga master
                                                        output logic [7:0] VGA_R, VGA_G, VGA_B,
                                                        output logic VGA_BLANK_N, VGA_CLK, VGA_SYNC_N,
                                                        output logic VGA_VS, VGA_HS);


   logic reset, circle, triangle, pentagon;
   logic manualMode, manualClockL;
   logic manualCircleL, manualTriangleL, manualPentagonL;
   logic clock;
        logic [1:0] CoinValue;

        //more arguments to vga master
   logic [3:0] numGames;
   logic loadNumGames;
   logic [3:0] RoundNumber;
   logic [11:0] Guess;
   logic loadGuess;
   logic [3:0] Znarly, Zood;
   logic loadZnarlyZood;
   logic clearGame;

   logic [11:0] MasterPattern;
   logic displayMasterPattern;
   logic en_master3, en_master2, en_master1, en_master0;

   assign displayMasterPattern = SW[15];

   mastermindVGA vga(.CLOCK_50(CLOCK_50),
             .VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B),
             .VGA_BLANK_N(VGA_BLANK_N), .VGA_CLK(VGA_CLK), .VGA_SYNC_N(VGA_SYNC_N),
             .VGA_VS(VGA_VS), .VGA_HS(VGA_HS),

             .numGames(numGames),
             .loadNumGames(loadNumGames),

             .roundNumber(RoundNumber),
             .guess(Guess),
             .loadGuess(loadGuess),
             .znarly(Znarly), .zood(Zood),
             .loadZnarlyZood,
             .clearGame,

             .masterPattern(MasterPattern),
             .displayMasterPattern,
             .reset);



        logic intermediate_key3;
        /*always_comb begin
          if ((~cannot_start) && (StartGame) && (numGames > 4'd0)) begin
            GradeIt = intermediate_key3;
                 LoadShapeNow = intermediate_key3;
                end
          else begin
            LoadShapeNow = intermediate_key3;
                 GradeIt = 0;
           end

        end*/

        logic CoinInserted, StartGame;

        logic GradeIt;
   logic [2:0] LoadShape;
        logic [1:0] ShapeLocation;
        logic LoadShapeNow;

        logic GameWon, debug;

   assign CoinValue = SW[17:16];

        assign Guess = SW[11:0];


        assign LoadShape = SW[2:0];
   assign ShapeLocation = SW[4:3];



        BCDtoSevenSegment bcd3(.bcd(Znarly), .segment(HEX3));
        BCDtoSevenSegment bcd2(.bcd(Zood), .segment(HEX2));
        BCDtoSevenSegment bcd1(.bcd(RoundNumber), .segment(HEX1));
        BCDtoSevenSegment bcd0(.bcd(numGames), .segment(HEX0));



        assign LEDG[0] = GameWon;

   assign clock = CLOCK_50;
   //assign debug = SW[15];


        assign LEDG[6] = en_master2;
        assign LEDG[7] = en_master3;
        logic key0_not, key1_not, key2_not, key3_not;
        assign key0_not = ~KEY[0];
        assign key1_not = ~KEY[1];
        assign key2_not = ~KEY[2];
        assign key3_not = ~KEY[3];

        Synchronizer s0(.async(key0_not), .clock,
     .sync(reset));

          Synchronizer s1(.async(key1_not), .clock,
     .sync(CoinInserted));

           Synchronizer s2(.async(key2_not), .clock,
     .sync(StartGame));



          Synchronizer s3(.async(key3_not), .clock,
    .sync(LoadShapeNow));

        //assign LoadShapeNow = 1'b1;
        assign LEDG[1] = LoadShapeNow;
        assign LEDG[2] = CoinInserted;


        BCDtoSevenSegment bcdddd(.bcd(LoadShape), .segment(HEX4));
        BCDtoSevenSegment_2bitinput bcddd(.bcd(ShapeLocation), .segment(HEX5));
        logic cannot_start;
        assign LEDG[3] = cannot_start;
        assign LEDG[4] = en_master0;
        assign LEDG[5] = en_master1;
        logic GameOver;

   task2 task2_module(.coinInserted(CoinInserted),
             .coinValue(CoinValue),
             .numGames_can_be_played(numGames), .RoundNumber(RoundNumber),
             .startGame(StartGame),
             .loadNumGames,
             .loadGuess,
             .MasterPattern,
             .GuessPattern(Guess),
             .LoadShape,
             .ShapeLocation(ShapeLocation),
             .LoadShapeNow,
             .GameWon,
             .GameOver,
                                 .cannot_start,
             .clock, .reset, .GradeIt,
                                 .en_master3, .en_master2, .en_master1, .en_master0);

endmodule: chipInterface


//Here

