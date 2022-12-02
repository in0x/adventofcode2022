#import "Basic";
#import "File";
#import "String";

main :: () {
    file_contents := read_entire_file("02.txt");
    round_inputs := split(file_contents, "\n");

    score := 0;
    
    for round: round_inputs {
        if round.count < 3 continue;

        o_sel := round[0] - #char "A" + 1; // map from "A".."C" -> 1..3
        p_sel := round[2] - 23 - #char "A" + 1; // map from "X" -> "A" -> 1..3

        DRAW :: 3;
        WIN  :: 6;        
        if o_sel == p_sel score += DRAW;  
        else if ((o_sel % 3) + 1) == p_sel score += WIN;
        
        score += p_sel;
    }

    print("First score %\n", score);

    Mode :: enum { Draw; Win; Loss; }
    get_score :: (choice: u8, mode: Mode) -> int {
        a_val : int = #char "A";
        choice_val := cast(int) choice - a_val;
        return (choice_val + cast(int) mode) % 3 + 1;
    }

    actual_score := 0;

    for round: round_inputs {
        if round.count < 3 continue;

        o_sel := round[0];
        p_sel := round[2];
        mode := Mode.Loss;
        
        if p_sel == #char "Z" {
            actual_score += 6;
            mode = Mode.Win;
        } else if p_sel == #char "Y" {
            actual_score += 3;
            mode = Mode.Draw;
        }
        
        actual_score += get_score(o_sel, mode);
    }

    print("Second score %", actual_score);
}
