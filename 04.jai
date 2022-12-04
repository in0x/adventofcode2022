#import "Basic";
#import "File";
#import "String";

main :: () {
    file_contents := read_entire_file("04.txt");
    lines := split(file_contents, "\n");
    if !lines[lines.count - 1] then pop(*lines);

    num_contained := 0;
    num_overlap := 0;
    for lines {
        parse_range :: (in: string) -> (int, int) {
            tokens := split(in, "-");
            assert(tokens.count == 2);
            open, s1 := parse_int(*tokens[0]);
            close, s2 := parse_int(*tokens[1]);
            assert(s1);
            assert(s2);
            return open, close;
        }
        
        pairs := split(it, ",");
        assert(pairs.count == 2);
        o1, c1 := parse_range(pairs[0]);
        o2, c2 := parse_range(pairs[1]);

        if o1 <= o2 && c1 >= c2 num_contained += 1;
        else if o2 <= o1 && c2 >= c1 num_contained += 1;

        if o1 >= o2 && o1 <= c2 num_overlap += 1;
        else if o2 >= o1 && o2 <= c1 num_overlap += 1;
    }

    print("Num contained %\n", num_contained);
    print("Num overlap %\n", num_overlap);
}
