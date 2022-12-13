#import "Basic";
#import "File";
#import "String";
#import "Sort";

Op :: enum { Add; Mul; Sq; }

Monkey :: struct {
    items: [..]u64;
    op: Op;
    op_val: u64;
    test_val: u64;
    true_next: int;
    false_next: int;
};

main :: () {
    file_contents := read_entire_file("11.txt");
    lines := split(file_contents, "\n");
    if !lines[lines.count - 1] then pop(*lines);

    monkeys: [..]Monkey;
    
    i := 0;
    while i < lines.count {
        m := array_add(*monkeys);
        {
            tok := split(lines[i + 1], " ");
            for i: 4 .. tok.count - 1 {
                item := cast(u64)parse_int(*tok[i]);
                array_add(*m.items, item);
            }
        }
        {
            /* assert(scan2(trim(lines[i + 2]), "Operation: new = old * %", *m.op_val)); */
            tok := split(lines[i + 2], " ");
            if contains(tok[6], "*") {
                m.op = Op.Mul;
            } else {
                m.op = Op.Add;
            }

            val, success := parse_int(*tok[7]);
            if !success then m.op = Op.Sq;
            else m.op_val = cast(u64)val;
        }
        {
            tok := split(lines[i + 3], " ");
            m.test_val = cast(u64)parse_int(*tok[5]);
        }
        {
            tok := split(lines[i + 4], " ");
            m.true_next = parse_int(*tok[9]);
        }
        {
            tok := split(lines[i + 5], " ");
            m.false_next = parse_int(*tok[9]);
        }

        assert(m.true_next != monkeys.count - 1);
        assert(m.false_next != monkeys.count - 1);
        i += 7;
    }

    modulo: u64 = 1;
    for * monkeys modulo *= it.test_val;
    
    scores: [..]u64;
    array_resize(*scores, monkeys.count);
    for i: 1..10000 {
        for *m: monkeys {
            m_idx := it_index;
            for old_item: m.items {
                scores[m_idx] += 1;
                item: u64;
                if m.op == {
                    case Op.Add; item = old_item + m.op_val;
                    case Op.Mul; item = old_item * m.op_val;
                    case Op.Sq;  item = old_item * old_item;
                }

                // item /= 3; // not done in part 2
                item = item % modulo;
                idx := ifx (item % m.test_val) == 0 then m.true_next else m.false_next;
                array_add(*monkeys[idx].items, item);
            }
            m.items.count = 0; // ???
            // clear array
        }

        /* print("% -------------------------------------\n", i); */
        /* for monkeys print("%\n", it); */
        /* print("-------------------------------------\n"); */
    }

    gt := (a: u64, b: u64) -> int {
        if a < b return 1;
        else if a > b return -1;
        else return 0;
    };
    quick_sort(scores, gt);
    print("%\n", scores);
    print("%\n", scores[0] * scores[1]);
}
