#import "Basic";
#import "File";
#import "String";

print_pixel :: (reg: int, cycle: int) {
    if ((cycle % 40) - 1) == (reg - 1) || ((cycle % 40) - 1) == reg || ((cycle % 40) - 1) == (reg + 1) {
        print("#");
    }
    else print(".");
}

main :: () {
    file_contents := read_entire_file("10.txt");
    lines := split(file_contents, "\n");
    if !lines[lines.count - 1] then pop(*lines);

    cycle := 1;
    reg := 1;
    strength := 0;
    markers := int.[20, 60, 100, 140, 180, 220];
    line_ends := int.[40, 80, 120, 160, 200, 240];
    for line: lines {
        tokens := split(line, " ");

        if array_find(markers, cycle) {
            strength += reg * cycle;
        }

        print_pixel(reg, cycle);
        
        if array_find(line_ends, cycle) {
            print("\n");
        }
        
        if tokens.count == 1 {
            cycle += 1;
        }
        else {
            cycle += 1;
            if array_find(markers, cycle) {
                strength += reg * cycle;
            }
            
            print_pixel(reg, cycle);
            
            if array_find(line_ends, cycle) {
                print("\n");
            }
            
            cycle += 1;
            reg += parse_int(*tokens[1]);
        }
    }

    print("\nTotal %\n", strength);
}
