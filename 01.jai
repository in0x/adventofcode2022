#import "Basic";
#import "File";
#import "String";
#import "Sort";

// duplicate of split in String, but preserves the separators
split_by :: (s: string, separator: string) -> [] string {
    results: [..] string;
    results.allocator = __temporary_allocator;

    remainder := s;
        while remainder {
        found, left, right := split_from_left(remainder, separator);
        if found {
            array_add(*results, left);
            array_add(*results, separator);
        } else {
            array_add(*results, remainder);
            break;
        }

        remainder = right;
    }

    if !remainder array_add(*results, "");   
    return results;
}

Score :: struct {
    cnt : int;
    idx : int;
}

main :: () {
    file_contents := read_entire_file("01.txt");
    lines_in_file := split_by(file_contents, "\n"); 

    scores : [..] Score;
    cur_score := array_add(*scores);
    
    for line: lines_in_file {
        if line {
            cur_score.cnt += parse_int(*line);
        } else {
            cur_score.idx = scores.count;
            cur_score = array_add(*scores);
        }
    }

    compare := (l: Score, r: Score) -> s64 {
        if l.cnt < r.cnt {
            return 1;
        } else if l.cnt > r.cnt {
            return -1;
        } else {
            return 0;
        }
    };
    
    quick_sort(scores, compare);

    total_score := 0;
    for i: 0..2 {
        total_score += scores[i].cnt;
    }

    print("Total top 3 score: %\n", total_score);
}
