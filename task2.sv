`default_nettype none



module task5 (
output logic [1:0] credit,
output logic drop,
input logic coinInserted, //new output logic
input logic [1:0] coin, //changed slightly
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
      if((coin == 2'b01) && (coinInserted == 1'b1)) begin  //new comment
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
          && coinInserted == 1'b1) begin //exits waiting state if coinInserted
                                         // == 0
        nextState = nothing_wait;
      end
      else begin
        nextState = nothing;
      end
    end

    credit1_nosoda_wait: begin
      if((coin == 2'b01 | coin == 2'b10  | coin == 2'b11)  
          && coinInserted == 1'b1) begin
        nextState = credit1_nosoda_wait;
      end
      else begin
        nextState = credit1_nosoda;
      end
    end

    credit2_nosoda_wait: begin
      if((coin == 2'b01 | coin == 2'b10  | coin == 2'b11)  
          && coinInserted == 1'b1) begin
        nextState = credit2_nosoda_wait;
      end
      else begin
        nextState = credit2_nosoda;
      end
    end

    credit3_nosoda_wait: begin
      if((coin == 2'b01 | coin == 2'b10  | coin == 2'b11)  
          && coinInserted == 1'b1) begin
        nextState = credit3_nosoda_wait;
      end
      else begin
        nextState = credit3_nosoda;
      end
    end

    mult_of_4_wait: begin
      if((coin == 2'b01 | coin == 2'b10  | coin == 2'b11)  
          && coinInserted == 1'b1) begin
        nextState = mult_of_4_wait;
      end
      else begin
        nextState = mult_of_4;
      end
    end

    credit1_soda_wait: begin
      if((coin == 2'b01 | coin == 2'b10  | coin == 2'b11)  
          && coinInserted == 1'b1) begin
        nextState = credit1_soda_wait;
      end
      else begin
        nextState = credit1_soda;
      end
    end

    credit2_soda_wait: begin
      if((coin == 2'b01 | coin == 2'b10  | coin == 2'b11)  
          && coinInserted == 1'b1) begin
        nextState = credit2_soda_wait;
      end
      else begin
        nextState = credit2_soda;
      end
    end

    credit3_soda_wait: begin 
      if((coin == 2'b01 | coin == 2'b10  | coin == 2'b11)  
          && coinInserted == 1'b1) begin
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
      nothing: begin
        if(coin == 2'b01) begin //circle
          credit = 2'b01;
          drop = 1'b0;
        end
        else if (coin == 2'b10) begin //triangle
          credit = 2'b11;
          drop = 1'b0;
        end
        else if (coin == 2'b11) begin //pentagon
          credit = 2'b01;
          drop = 1'b1;
        end
        else begin //invalid coin
          credit = 2'b00;
          drop = 1'b0;

        end
      end
      credit1_nosoda: begin
        if(coin == 2'b01) begin //circle
          credit = 2'b10;
          drop = 1'b0;
        end
        else if (coin == 2'b10) begin //triangle
          credit = 2'b00;
          drop = 1'b1;
        end
        else if (coin == 2'b11) begin //pentagon
          credit = 2'b10;
          drop = 1'b1;
        end
        else begin //invalid coin
          credit = 2'b01;
          drop = 1'b0;

        end
      end
      credit2_nosoda: begin
        if(coin == 2'b01) begin //circle
          credit = 2'b11;
          drop = 1'b0;
        end
        else if (coin == 2'b10) begin //triangle
          credit = 2'b01;
          drop = 1'b1;
        end
        else if (coin == 2'b11) begin //pentagon
          credit = 2'b11;
          drop = 1'b1;
        end
        else begin //invalid coin
          credit = 2'b10;
          drop = 1'b0;

        end
      end
      credit3_nosoda: begin
        if(coin == 2'b01) begin //circle
          credit = 2'b00;
          drop = 1'b1;
        end
        else if (coin == 2'b10) begin //triangle
          credit = 2'b10;
          drop = 1'b1;
        end
        else if (coin == 2'b11) begin //pentagon
          credit = 2'b00;
          drop = 1'b1;
        end
        else begin //invalid coin
          credit = 2'b11;
          drop = 1'b0;

        end
      end
      mult_of_4: begin
        if(coin == 2'b01) begin //circle
          credit = 2'b01;
          drop = 1'b0;
        end
        else if (coin == 2'b10) begin //triangle
          credit = 2'b11;
          drop = 1'b0;
        end
        else if (coin == 2'b11) begin //pentagon
          credit = 2'b01;
          drop = 1'b1;
        end
        else begin //invalid coin
          credit = 2'b00;
          drop = 1'b0;

        end
      end
      credit1_soda: begin
        if(coin == 2'b01) begin //circle
          credit = 2'b10;
          drop = 1'b0;
        end
        else if (coin == 2'b10) begin //triangle
          credit = 2'b00;
          drop = 1'b1;
        end
        else if (coin == 2'b11) begin //pentagon
          credit = 2'b10;
          drop = 1'b1;
        end
        else begin //invalid coin
          credit = 2'b01;
          drop = 1'b0;

        end
      end
      credit2_soda: begin
        if(coin == 2'b01) begin //circle
          credit = 2'b11;
          drop = 1'b0;
        end
        else if (coin == 2'b10) begin //triangle
          credit = 2'b01;
          drop = 1'b1;
        end
        else if (coin == 2'b11) begin //pentagon
          credit = 2'b11;
          drop = 1'b1;
        end
        else begin //invalid coin
          credit = 2'b10;
          drop = 1'b0;

        end
      end
      credit3_soda: begin
        if(coin == 2'b01) begin //circle
          credit = 2'b00;
          drop = 1'b1;
        end
        else if (coin == 2'b10) begin //triangle
          credit = 2'b10;
          drop = 1'b1;
        end
        else if (coin == 2'b11) begin //pentagon
          credit = 2'b00;
          drop = 1'b1;
        end
        else begin //invalid coin
          credit = 2'b11;
          drop = 1'b0;

        end
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
        drop = 1'b0;
        credit = 2'b00;

      end
      credit1_soda_wait: begin
        drop = 1'b0;
        credit = 2'b01;
 
      end
      credit2_soda_wait: begin
        drop = 1'b0;
        credit = 2'b10;

      end
      credit3_soda_wait: begin
        drop = 1'b0;
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

module loading_master_fsm(input logic correct_location,
                          input logic win,
                          input logic endgame,
                          output logic enable, clear,
                          input logic reset, clock);
    enum logic {nothing = 1'b0, set = 1'b1} currState, nextState;

    
    always_comb begin
        case(currState)
            nothing: begin
                nextState = correct_location ? set : nothing;
                enable = correct_location ? 1'b1 : 1'b0;
                clear = correct_location ? 1'b0 : 1'b1;
            end

            set: begin
                nextState = (win | endgame) ? nothing : set;
                enable = 1'b0;
                clear = (win | endgame) ? 1'b1 : 1'b0;
            end

        endcase
    end

    always_ff @(posedge clock, posedge reset)
        if(reset)
            currState <= nothing;
        else
            currState <= nextState;

endmodule: loading_master_fsm;

module game_control_fsm(input logic win,
                        input logic end_game,
                        input logic gradeit,
                        input logic game_can_start,
                        output logic round_enable,
                        output logic round_clear,
                        input logic clock, reset);
enum logic [1:0] {nothing = 2'b00, play = 2'b01, waitt = 2'b10} 
                                                  currState, nextState;
always_comb begin
    case(currState)
      nothing: begin
        nextState = (game_can_start) ? play : nothing;
        round_enable = 1'b0; //increments the round count
        //ask in oh what if gradeit is asserted at the same time as game_start
        round_clear = (game_can_start) ? 1'b1 : 1'b0;
      end

      play: begin
        if(end_game | win) begin
          nextState = nothing;
          round_enable = 1'b0;
          round_clear = 1'b0;

        end
        else if (~end_game && ~win && gradeit) begin
          nextState = play;
          round_enable = 1'b0;
          round_clear = 1'b0;

        end
        else begin //here ~end_game && ~win && ~gradeit
          nextState = waitt;
          round_enable = 1'b0;
          round_clear = 1'b0;
        end

      end

      waitt: begin
        if(end_game | win) begin
          nextState = nothing;
          round_enable = 1'b0;
          round_clear = 1'b0;

        end
        else if (~end_game && ~win && gradeit) begin
          nextState = play;
          round_enable = 1'b1;
          round_clear = 1'b0;

        end
        else begin //here ~end_game && ~win && ~gradeit
          nextState = waitt;
          round_enable = 1'b0;
          round_clear = 1'b0;
        end

      end
    endcase
end
always_ff @(posedge clock, posedge reset)
        if(reset)
            currState <= nothing;
        else
            currState <= nextState;





endmodule: game_control_fsm

module task2(input logic coinInserted,
             input logic [1:0] coinValue,
             output logic [3:0] numGames, RoundNumber,
             input logic startGame,
             //input logic loadnumGames,
             //input logic loadGuess,
             //input logic [11:0] MasterPattern, //ask in oh
             input logic [11:0] GuessPattern,
             input logic [2:0] LoadShape, 
             input logic [1:0] ShapeLocation,
             input logic LoadShapeNow, 
             output logic GameWon,
             output logic GameOver,
             input logic clock, reset, GradeIt);
    logic [1:0] credit;
    logic game_paid_for;
    task5 task5_dut(.credit,.drop(game_paid_for),.coinInserted,
    .coin(coinValue),.clock, .reset);

    
    logic AltB, numGames_eq_0, AgtB;
    Counter #(4) game_counter(.en(game_paid_for && ~numGames_eq_0), 
                      .clear(1'b0), 
                      .load(reset),  //resets to 7 available games
                      .up(1'b0), 
                      .D(4'd7), 
                      .clock, 
                      .Q(numGames));
    //add comment
    
    MagComp #(4) check_available_games_gt_0(.A(numGames), .B(4'd0),
                                   .AltB, .AeqB(numGames_eq_0), .AgtB);
    
    logic numGames_lt_7, AeqB_second_comparator, AgtB_second_comparator;
    MagComp #(4) check_available_games_lt_7(.A(numGames), .B(4'd7),
                                    .AltB(numGames_lt_7),
                                    .AeqB(AeqB_second_comparator),
                                    .AgtB(AgtB_second_comparator));
    logic [3:0] num_games_can_be_played;
    //ask about paying for up to 7 available games

    logic game_can_start, cannot_start;
    assign game_can_start = numGames_lt_7 && startGame && ~cannot_start
                            && (num_games_can_be_played > 0);


    Counter #(4) games_payed_counter(.en(game_paid_for || game_can_start), 
                      .clear(1'b0), 
                      .load(reset), 
                      .up(game_paid_for), 
                      .D(4'd0), 
                      .clock, 
                      .Q(num_games_can_be_played));

    logic [3:0] D_intermediate;
    logic Round_en, Round_cl;

    Counter #(4) round_counter(.en(Round_en), 
                      .clear(Round_cl), 
                      .load(1'b0), 
                      .up(1'b1), 
                      .D(D_intermediate), 
                      .clock, 
                      .Q(RoundNumber));

    logic [3:0] Znarly, Zood;
    Comparator #(4) determine_if_win(.A(Znarly), .B(4'd4), .AeqB(GameWon));
    Comparator #(4) determine_end_game(.A(RoundNumber), .B(4'd8), 
                                       .AeqB(GameOver));
    

    //loading in master
    logic en_master3, clear_master3;
    logic [2:0] master3_bit_pattern;
    Register #(3) load_master3(.D(LoadShape), .en(en_master3 && LoadShapeNow), 
                               .clear(clear_master3), .clock,
                               .Q(master3_bit_pattern));
    
    logic en_master2, clear_master2;
    logic [2:0] master2_bit_pattern;
    Register #(3) load_master2(.D(LoadShape), .en(en_master2 && LoadShapeNow), 
                               .clear(clear_master2), .clock,
                               .Q(master2_bit_pattern));
    
    logic en_master1, clear_master1;
    logic [2:0] master1_bit_pattern;
    Register #(3) load_master1(.D(LoadShape), .en(en_master1 && LoadShapeNow), 
                               .clear(clear_master1), .clock,
                               .Q(master1_bit_pattern));
   
    logic en_master0, clear_master0;
    logic [2:0] master0_bit_pattern;
    Register #(3) load_master0(.D(LoadShape), .en(en_master0 && LoadShapeNow), 
                               .clear(clear_master0), .clock,
                               .Q(master0_bit_pattern));
   
    logic correct_location_3, correct_location_2, 
          correct_location_1, correct_location_0;
    
    always_comb begin
      if(ShapeLocation == 2'd0) begin
        correct_location_0 = 1'b1;
        correct_location_1 = 1'b0;
        correct_location_2 = 1'b0;
        correct_location_3 = 1'b0;
      end
        
      else if (ShapeLocation == 2'd1) begin
        correct_location_0 = 1'b0;
        correct_location_1 = 1'b1;
        correct_location_2 = 1'b0;
        correct_location_3 = 1'b0;
      end 
      else if (ShapeLocation == 2'd2) begin
        correct_location_0 = 1'b0;
        correct_location_1 = 1'b0;
        correct_location_2 = 1'b1;
        correct_location_3 = 1'b0;
      end 

      else begin
        correct_location_0 = 1'b0;
        correct_location_1 = 1'b0;
        correct_location_2 = 1'b0;
        correct_location_3 = 1'b1;
      end  

    end





    loading_master_fsm master_3(.correct_location(correct_location_3),
                          .win(GameWon),
                          .endgame(GameOver),
                          .enable(en_master3), 
                          .clear(clear_master3),
                          .reset,
                          .clock);

    loading_master_fsm master_2(.correct_location(correct_location_2),
                          .win(GameWon),
                          .endgame(GameOver),
                          .enable(en_master2), 
                          .clear(clear_master2),
                          .reset,
                          .clock);
    

    loading_master_fsm master_1(.correct_location(correct_location_1),
                          .win(GameWon),
                          .endgame(GameOver),
                          .enable(en_master1), 
                          .clear(clear_master1),
                          .reset,
                          .clock);
    
    loading_master_fsm master_0(.correct_location(correct_location_0),
                          .win(GameWon),
                          .endgame(GameOver),
                          .enable(en_master0), 
                          .clear(clear_master0),
                          .reset,
                          .clock);

    logic [11:0] MasterPattern;
    assign MasterPattern = (master3_bit_pattern << 9) | 
                           (master2_bit_pattern << 6) |
                           (master1_bit_pattern << 3) |
                           (master0_bit_pattern);



    assign cannot_start = (master3_bit_pattern == 0) |
                          (master2_bit_pattern == 0) |
                          (master1_bit_pattern == 0) |
                          (master0_bit_pattern == 0);



    task1 calculate_for_one_round(.Guess_actual(GuessPattern), 
                                  .Master(MasterPattern),
                                  .GradeIt,
                                  .clock,
                                  .reset,
                                  .Znarly,
                                  .Zood);


    game_control_fsm game_control(.win(GameWon),
                     .end_game(GameOver),
                     .gradeit(GradeIt),
                     .game_can_start(game_can_start),
                     .round_enable(Round_en),
                     .round_clear(Round_cl),
                     .clock, 
                     .reset);
endmodule: task2

module task2_test;
logic coinInserted; //input
logic [1:0] coinValue;  //input
logic [3:0] numGames, RoundNumber;  //output
logic startGame; //input
//logic loadGuess;//input

logic [11:0] GuessPattern;//input
logic [2:0] LoadShape; //input
logic [1:0] ShapeLocation; //input
logic LoadShapeNow; //input
logic GameWon;//output
logic GameOver;//output
logic clock, reset, GradeIt; //input

task2 DUTT(.*);












    initial begin
      clock = 0;
      
      forever #5 clock = ~clock;
      
      
    end
    

    initial begin 
    GuessPattern <= 12'b001_001_010_010; //test case TTCC
    coinValue <= 2'b11;
    coinInserted <= 1'b1;
    LoadShapeNow <= 1'b1;
    reset <= 1;
    GradeIt <= 0;
    @(posedge clock);
    reset <= 0;
    
    LoadShape <= 3'b101;
    ShapeLocation <= 2'b11;
    @(posedge clock);
    startGame <= 1;
    @(posedge clock);
    LoadShape <= 3'b110;
    ShapeLocation <= 2'b10;
    @(posedge clock);

    coinValue <= 2'b00;
    startGame <= 1;
    @(posedge clock);
    LoadShape <= 3'b100;
    ShapeLocation <= 2'b01;
    @(posedge clock);
    startGame <= 1;
    @(posedge clock);
    LoadShape <= 3'b001;
    ShapeLocation <= 2'b00; //Master is IZDT
    @(posedge clock);
    startGame <= 1;
    @(posedge clock);
    startGame <= 0;
    @(posedge clock);
    GradeIt <= 1;
    
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    GradeIt <= 0;
    @(posedge clock);
    @(posedge clock);
    //Guess is O O D D below
    GuessPattern <= 12'b011_011_100_100;
    @(posedge clock);
    GradeIt <= 1;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    GradeIt <= 0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    //Guess is IICC
    GuessPattern <= 12'b101_101_010_010;
    @(posedge clock);
    GradeIt <= 1;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    GradeIt <= 0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    //Guess is IOTZ
    GuessPattern <= 12'b101_011_001_110;
    @(posedge clock);
    GradeIt <= 1;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    GradeIt <= 0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    //guess is TIZD
    GuessPattern <= 12'b001_101_110_100;
    @(posedge clock);
    GradeIt <= 1;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    GradeIt <= 0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    //guess is IZDT
    //GuessPattern <= 12'b101_110_100_001;

    //tizd
    GuessPattern <= 12'b001_101_110_100;
    @(posedge clock);
    GradeIt <= 1;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    GradeIt <= 0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);

    GuessPattern <= 12'b001_101_110_100;
    @(posedge clock);
    GradeIt <= 1;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    GradeIt <= 0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);

    //GuessPattern <= 12'b001_101_110_100;
    //guess is IZDT
    GuessPattern <= 12'b101_110_100_001;
    @(posedge clock);
    GradeIt <= 1;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    GradeIt <= 0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);



    


    coinValue <= 2'b10;//triangle
    coinInserted <= 1'b1;
    


    GuessPattern <= 12'b001_001_010_010; //test case TTCC
    startGame <= 1;
    @(posedge clock);
    
    coinValue <= 2'b00;
    @(posedge clock);
    GradeIt <= 1;
    startGame <= 0;
    coinValue <= 2'b00;

    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    GradeIt <= 0;
    @(posedge clock);
    @(posedge clock);
    //Guess is O O D D below
    GuessPattern <= 12'b011_011_100_100;
    @(posedge clock);
    GradeIt <= 1;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    GradeIt <= 0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    //Guess is IICC
    GuessPattern <= 12'b101_101_010_010;
    @(posedge clock);
    GradeIt <= 1;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    GradeIt <= 0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    //Guess is IOTZ
    GuessPattern <= 12'b101_011_001_110;
    @(posedge clock);
    GradeIt <= 1;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    GradeIt <= 0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    //guess is TIZD
    GuessPattern <= 12'b001_101_110_100;
    @(posedge clock);
    GradeIt <= 1;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    GradeIt <= 0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    //guess is IZDT
    //GuessPattern <= 12'b101_110_100_001;

    //tizd
    GuessPattern <= 12'b001_101_110_100;
    @(posedge clock);
    GradeIt <= 1;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    GradeIt <= 0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);

    GuessPattern <= 12'b001_101_110_100;
    @(posedge clock);
    GradeIt <= 1;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    GradeIt <= 0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);

    //GuessPattern <= 12'b001_101_110_100;
    //guess is IZDT
    GuessPattern <= 12'b101_110_100_001;
    @(posedge clock);
    GradeIt <= 1;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    GradeIt <= 0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);



    //new game
    startGame <= 1;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    GradeIt <= 1;
    @(posedge clock);
    GradeIt <= 0;
    @(posedge clock);
    @(posedge clock);


    $finish;
    end
endmodule: task2_test
