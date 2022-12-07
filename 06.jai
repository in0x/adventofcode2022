#import "Basic";
#import "File";
#import "String";

main :: () {
    message := read_entire_file("06.txt");
    print("%", message);
    start := 0;
    end := 1;
    while end < message.count {      
        to_print := slice(message, start, end - start);
        print("%\n", to_print);

        unique := true;
        for i: start..end - 1 {
            if message[i] == message[end] {
                start = i + 1; 
                unique = false;
                break;
            }
        }

        if unique {
            if (end - start + 1) == 14 {
                break;
            }
        }

        end += 1;
    }

    print("Unique: %\n", slice(message, start, end - start));
    print("Marker after % received\n", end + 1);
}

// mjqjp qmgbljsphdztnv jfqwrcgsmlb
