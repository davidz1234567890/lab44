`default_nettype none


module findmin(input logic [3:0] A, B,
               output logic [3:0] min);
    always_comb begin
        if(A <= B)
          min = A;
        else 
          min = B;

    end


endmodule: findmin


module fsm(input logic grade_it, reset, clock,
        output logic load, clear);
    
    enum logic {nothing = 1'b0, A = 1'b1} currState, nextState;
    always_comb begin
        case(currState) 
            nothing: begin
                nextState = grade_it ? A : nothing;
                clear = grade_it ? 0 : 1;
                load = grade_it ? 1 : 0;
            end
            A: begin
                nextState = grade_it ? A : nothing;
                clear = grade_it ? 0 : 1;
                load = 0;//grade_it ? 1 : 0;
            end


        endcase


    end

    always_ff @(posedge clock, posedge reset)
        if(reset)
            currState <= nothing;
        else
            currState <= nextState;

endmodule: fsm


module task1(input logic [11:0] Guess_actual, Master,
             input logic GradeIt,
             input logic clock,
             input logic reset,
             output logic [3:0] Znarly,
             output logic [3:0] Zood);
    
    logic load, clear;
    logic [11:0] Guess;

    Register #(12) dutt1(.en(load), .clear(clear), .D(Guess_actual),
                         .clock(clock), .Q(Guess));
    fsm dutt2(.grade_it(GradeIt), .reset(reset), .clock(clock), .load(load),
              .clear(clear));


    logic [7:0] g3, g2, g1, g0, m3, m2, m1, m0;
    Decoder #(8) dut1(.I(Guess[11:9]), .en(1'b1), .D(g3));
    Decoder #(8) dut2(.I(Guess[8:6]), .en(1'b1), .D(g2));
    Decoder #(8) dut3(.I(Guess[5:3]), .en(1'b1), .D(g1));
    Decoder #(8) dut4(.I(Guess[2:0]), .en(1'b1), .D(g0));
    Decoder #(8) dut5(.I(Master[11:9]), .en(1'b1), .D(m3));
    Decoder #(8) dut6(.I(Master[8:6]), .en(1'b1), .D(m2));
    Decoder #(8) dut7(.I(Master[5:3]), .en(1'b1), .D(m1));
    Decoder #(8) dut8(.I(Master[2:0]), .en(1'b1), .D(m0));
    

    logic [2:0] guessT, guessC, guessO, guessD, guessI, guessZ,
                masterT, masterC, masterO, masterD, masterI, masterZ;
    assign guessT = g3[1] + g2[1] + g1[1] + g0[1];

    assign guessC = g3[2] + g2[2] + g1[2] + g0[2];
    assign guessO = g3[3] + g2[3] + g1[3] + g0[3];
    assign guessD = g3[4] + g2[4] + g1[4] + g0[4];
    assign guessI = g3[5] + g2[5] + g1[5] + g0[5];
    assign guessZ = g3[6] + g2[6] + g1[6] + g0[6];



    assign masterT = m3[1] + m2[1] + m1[1] + m0[1];

    assign masterC = m3[2] + m2[2] + m1[2] + m0[2];
    assign masterO = m3[3] + m2[3] + m1[3] + m0[3];
    assign masterD = m3[4] + m2[4] + m1[4] + m0[4];
    assign masterI = m3[5] + m2[5] + m1[5] + m0[5];
    assign masterZ = m3[6] + m2[6] + m1[6] + m0[6];

    logic [3:0] min_T, min_C, min_O, min_D, min_I, min_Z;
    assign min_T = (guessT <= masterT) ? guessT : masterT;
    assign min_C = (guessC <= masterC) ? guessC : masterC;
    assign min_O = (guessO <= masterO) ? guessO : masterO;
    assign min_D = (guessD <= masterD) ? guessD : masterD;
    assign min_I = (guessI <= masterI) ? guessI : masterI;
    assign min_Z = (guessZ <= masterZ) ? guessZ : masterZ;

    logic [3:0] match_3, match_2, match_1, match_0;//, min_I, min_Z;
    //logic [3:0] Znarly, Zood;
    assign Znarly = (Master[11:9] == Guess[11:9]) +
                    (Master[8:6] == Guess[8:6]) +
                    (Master[5:3] == Guess[5:3]) + 
                    (Master[2:0] == Guess[2:0]);
    assign Zood = (min_T + min_C + min_O + min_D + min_I + min_Z) - Znarly;


    
    



endmodule: task1






module testbench();
    logic [11:0] Guess_actual, Master;
             logic GradeIt;
             logic clock;
             logic reset;
             logic [3:0] Znarly;
             logic [3:0] Zood;
    task1 dut(.*);

    initial begin
      clock = 0;
      reset = 1;
      #1 reset <= 0;
      forever #5 clock = ~clock;
    end


    initial begin
        Master <= 12'b101_110_100_001;
        Guess_actual <= 12'b101_110_100_001;
        GradeIt <= 0;
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        Guess_actual <= 12'b001_001_010_010;
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        GradeIt <= 1;
        @(posedge clock);
        @(posedge clock);
        Guess_actual <= 12'b101_011_001_110;
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        GradeIt <= 0;
        @(posedge clock);
        @(posedge clock);
        Guess_actual <= 12'b011_011_100_100;
        @(posedge clock);
        GradeIt <= 1;
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);





        $finish;
    end



endmodule: testbench
