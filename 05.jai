#import "Basic";
#import "File";
#import "String";

VISIBLE_ASCII :: " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";

main :: () {
    file_contents := read_entire_file("05.txt");
    lines := split(file_contents, "\n");
    if !lines[lines.count - 1] then pop(*lines);

    part_idx := lines.count - 1;
    while part_idx > 0 {
        if lines[part_idx][0] != #char "m"  break;
        part_idx -= 1;
    }

    n := 0; {
        for c: cast([]u8) lines[part_idx - 1] {
            if c >= #char "0" && c <= #char "9" {
                n = c - 48;
            }
        } 
    }

    print("Num stacks %\n", n);
    
    stacks := NewArray(n, [..]u8);
    
    for < i: part_idx - 2..0 {
        for j: 0..lines[i].count - 1 {
            stk_idx := j / 4;
            if lines[i][j] == #char "[" {
                array_add(*stacks[stk_idx], lines[i][j + 1]);
            } 
        }
    }

    part_idx += 1; // skip the empty break line;

    /* print_stks :: (arr: [3][..] u8) { */
    /*     height := max(max(arr[0].count, arr[1].count), arr[2].count); */
    /*     for 0..height - 1 { */
    /*         if arr[0].count */
    /*     } */
    /* } */

    helper: [..]u8;
    
    for i: part_idx..lines.count - 1 {
        tokens := split(lines[i], " ");
        cnt := parse_int(*tokens[1]);
        from := parse_int(*tokens[3]) - 1;
        to := parse_int(*tokens[5]) - 1;

        print("move % from % to %\n", cnt, from, to);
        /* for i: 0..cnt - 1 { */
        /*     val := pop(*stacks[from]); */
        /*     array_add(*stacks[to], val); */
        /* }  */ // part 1
        
        for i: 0..cnt - 1 {
            val := pop(*stacks[from]);
            array_add(*helper, val);
        }

        while helper {
            val := pop(*helper);
            array_add(*stacks[to], val);
        }
    }

    /* slice(VISIBLE_ASCII, key - #char " ", 1); */
    for stk: stacks {
        top := stk[stk.count - 1];
        to_print := slice(VISIBLE_ASCII, top - #char " ", 1);
        print("%", to_print);
    }
    print("\nfin\n");
}
