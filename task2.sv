`default_nettype none



module task5 (
output logic [1:0] credit,
output logic drop,
input logic coinInserted, //new output logic
input logic coin[1:0], //changed slightly
input logic clock, reset);
enum logic [3:0] {nothing = 4'b0000,
                  credit1_nosoda = 4'b0001,
                  credit2_nosoda = 4'b0010,
                  credit3_nosoda = 4'b0011,
                  mult_of_4 = 4'b0100,
                  credit1_soda = 4'b0101,
                  credit2_soda = 4'b0110,
                  credit3_soda = 4'b0111,
                  nothing_wait = 4'b1000,
                  credit1_nosoda_wait = 4'b1001,
                  credit2_nosoda_wait = 4'b1010,
                  credit3_nosoda_wait = 4'b1011,
                  mult_of_4_wait = 4'b1100,
                  credit1_soda_wait = 4'b1101,
                  credit2_soda_wait = 4'b1110,
                  credit3_soda_wait = 4'b1111} currState, nextState;


//next state logic here
//wait states keep the state constant when coin is asserted over consecutive 
//clock edges
always_comb begin
  case(currState)
    nothing: begin
      if(coin == 2'b01 && coinInserted == 1'b1) begin
        nextState = credit1_nosoda_wait;
      end
      else if(coin == 2'b10 && coinInserted == 1'b1) begin
        nextState = credit3_nosoda_wait;
      end
      else if(coin == 2'b11 && coinInserted == 1'b1) begin
        nextState = credit1_soda_wait;
      end
      else begin
        nextState = nothing;
      end
    end

    credit1_nosoda: begin
      if(coin == 2'b01 && coinInserted == 1'b1) begin
        nextState = credit2_nosoda_wait;
      end
      else if(coin == 2'b10 && coinInserted == 1'b1) begin
        nextState = mult_of_4_wait;
      end
      else if(coin == 2'b11 && coinInserted == 1'b1) begin
        nextState = credit2_soda_wait;
      end
      else begin
        nextState = credit1_nosoda;
      end
    end

    credit2_nosoda: begin
      if(coin == 2'b01 && coinInserted == 1'b1) begin
        nextState = credit3_nosoda_wait;
      end
      else if(coin == 2'b10 && coinInserted == 1'b1) begin
        nextState = credit1_soda_wait;
      end
      else if(coin == 2'b11 && coinInserted == 1'b1) begin
        nextState = credit3_soda_wait;
      end
      else begin
        nextState = credit2_nosoda;
      end
    end

    credit3_nosoda: begin
      if(coin == 2'b01 && coinInserted == 1'b1) begin
        nextState = mult_of_4_wait;
      end
      else if(coin == 2'b10 && coinInserted == 1'b1) begin
        nextState = credit2_soda_wait;
      end
      else if(coin == 2'b11 && coinInserted == 1'b1) begin
        nextState = mult_of_4_wait;
      end
      else begin
        nextState = credit3_nosoda;
      end
    end

    mult_of_4: begin
      if(coin == 2'b01 && coinInserted == 1'b1) begin
        nextState = credit1_nosoda_wait;
      end
      else if(coin == 2'b10 && coinInserted == 1'b1) begin
        nextState = credit3_nosoda_wait;
      end
      else if(coin == 2'b11 && coinInserted == 1'b1) begin
        nextState = credit1_soda_wait;
      end
      else begin
        nextState = nothing;
      end
    end

    credit1_soda: begin
      if(coin == 2'b01 && coinInserted == 1'b1) begin
        nextState = credit2_nosoda_wait;
      end
      else if(coin == 2'b10 && coinInserted == 1'b1) begin
        nextState = mult_of_4_wait;
      end
      else if(coin == 2'b11 && coinInserted == 1'b1) begin
        nextState = credit2_soda_wait;
      end
      else begin
        nextState = credit1_nosoda;
      end
    end

    credit2_soda: begin
      if(coin == 2'b01 && coinInserted == 1'b1) begin
        nextState = credit3_nosoda_wait;
      end
      else if(coin == 2'b10 && coinInserted == 1'b1) begin
        nextState = credit1_soda_wait;
      end
      else if(coin == 2'b11 && coinInserted == 1'b1) begin
        nextState = credit3_soda_wait;
      end
      else begin
        nextState = credit2_nosoda;
      end
    end

    credit3_soda: begin
      if(coin == 2'b01 && coinInserted == 1'b1) begin
        nextState = mult_of_4_wait;
      end
      else if(coin == 2'b10 && coinInserted == 1'b1) begin
        nextState = credit2_soda_wait;
      end
      else if(coin == 2'b11 && coinInserted == 1'b1) begin
        nextState = mult_of_4_wait;
      end
      else begin
        nextState = credit3_nosoda;
      end
    end

    nothing_wait: begin
      if((coin == 2'b01 | coin == 2'b10  | coin == 2'b11)  
          && coinInserted == 1'b0) begin //exits waiting state if coinInserted
                                         // == 0
        nextState = nothing_wait;
      end
      else begin
        nextState = nothing;
      end
    end

    credit1_nosoda_wait: begin
      if((coin == 2'b01 | coin == 2'b10  | coin == 2'b11)  
          && coinInserted == 1'b0) begin
        nextState = credit1_nosoda_wait;
      end
      else begin
        nextState = credit1_nosoda;
      end
    end

    credit2_nosoda_wait: begin
      if((coin == 2'b01 | coin == 2'b10  | coin == 2'b11)  
          && coinInserted == 1'b0) begin
        nextState = credit2_nosoda_wait;
      end
      else begin
        nextState = credit2_nosoda;
      end
    end

    credit3_nosoda_wait: begin
      if((coin == 2'b01 | coin == 2'b10  | coin == 2'b11)  
          && coinInserted == 1'b0) begin
        nextState = credit3_nosoda_wait;
      end
      else begin
        nextState = credit3_nosoda;
      end
    end

    mult_of_4_wait: begin
      if((coin == 2'b01 | coin == 2'b10  | coin == 2'b11)  
          && coinInserted == 1'b0) begin
        nextState = mult_of_4_wait;
      end
      else begin
        nextState = mult_of_4;
      end
    end

    credit1_soda_wait: begin
      if((coin == 2'b01 | coin == 2'b10  | coin == 2'b11)  
          && coinInserted == 1'b0) begin
        nextState = credit1_soda_wait;
      end
      else begin
        nextState = credit1_soda;
      end
    end

    credit2_soda_wait: begin
      if((coin == 2'b01 | coin == 2'b10  | coin == 2'b11)  
          && coinInserted == 1'b0) begin
        nextState = credit2_soda_wait;
      end
      else begin
        nextState = credit2_soda;
      end
    end

    credit3_soda_wait: begin 
      if((coin == 2'b01 | coin == 2'b10  | coin == 2'b11)  
          && coinInserted == 1'b0) begin
        nextState = credit3_soda_wait;
      end
      else begin
        nextState = credit3_soda;
      end
    end

 
    default: begin 
      if(coin == 2'b01 | coin == 2'b10  | coin == 2'b11) begin
        nextState = credit3_soda_wait;
      end
      else begin
        nextState = credit3_soda;
      end
    end
  endcase
end



//output logic here
always_comb begin
    credit = 2'b00; drop = 1'b0;
    case (currState)
      nothing: credit = 2'b00;
      credit1_nosoda: begin

        credit = 2'b01;
      end
      credit2_nosoda: begin

        credit = 2'b10;
      end
      credit3_nosoda: begin

        credit = 2'b11;
      end
      mult_of_4: begin
        drop = 1'b1;
        credit = 2'b00;
      end
      credit1_soda: begin
        drop = 1'b1;
        credit = 2'b01;
      end
      credit2_soda: begin
        drop = 1'b1;
        credit = 2'b10;
      end
      credit3_soda: begin
        drop = 1'b1;
        credit = 2'b11;
      end
      nothing_wait: begin
        credit = 2'b00;
        drop = 1'b0;

      end
      credit1_nosoda_wait: begin
        drop = 1'b0;
        credit = 2'b01;

      end
      credit2_nosoda_wait: begin
        drop = 1'b0;
        credit = 2'b10;

      end
      credit3_nosoda_wait: begin
        drop = 1'b0;
        credit = 2'b11;

      end
      mult_of_4_wait: begin
        drop = 1'b1;
        credit = 2'b00;

      end
      credit1_soda_wait: begin
        drop = 1'b1;
        credit = 2'b01;
 
      end
      credit2_soda_wait: begin
        drop = 1'b1;
        credit = 2'b10;

      end
      credit3_soda_wait: begin
        drop = 1'b1;
        credit = 2'b11;

      end
      
     
      default: begin
        credit=2'b00;
        drop = 1'b0;
      end

    endcase
end

always_ff @(posedge clock)
  if (reset)
    currState <= nothing; 
  else
    currState <= nextState;
endmodule: task5




module task2(input logic coinInserted,
             input logic [1:0] coinValue,
             output logic [3:0] numGames, RoundNumber,
             input logic startGame,
             input logic [11:0] MasterPattern, GuessPattern,
             input logic [2:0] LoadShape, ShapeLocation,
             input logic LoadShapeNow, 
             output logic GameWon
             input logic clock, reset);
    logic [1:0] credit;
    logic game_paid_for;
    task5 task5_dut(.credit,.drop(game_paid_for),.coinInserted,
    .coin(coinValue),.clock, .reset);

    logic Num_games_available_en;
    
    Counter #(3) dut_first_counter(.en(game_paid_for && ~numGames_eq_0), 
                      .clear(1'b0), 
                      .load(reset), 
                      .up(1'b0), 
                      .D(3'd7), 
                      .clock, 
                      .Q(numGames));
    logic AltB, numGames_eq_0, AgtB;
    Comparator #(3) dut_first_comp(.A(numGames), .B(3'd0),
                                   .AltB, .AeqB(numGames_eq_0), .AgtB);
    
    logic numGames_lt_7, AeqB_second_comparator, AgtB_second_comparator;
    Comparator #(3) dut_second_comp(.A(numGames), .B(3'd7),
                                    .AltB(numGames_lt_7),
                                    .AeqB(AeqB_second_comparator),
                                    .AgtB(AgtB_second_comparator));

    logic game_can_start, cannot_start;
    assign game_can_start = numGames_lt_7 && startGame && cannot_start;

    


endmodule: task2

