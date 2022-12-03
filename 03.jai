#import "Basic";
#import "File";
#import "String";
#import "Sort";
#import "Hash_Table";

main :: () {
    file_contents := read_entire_file("03.txt");
    inventories := split(file_contents, "\n");
    if !inventories[inventories.count - 1] pop(*inventories);

    score_item :: (c: u8) -> int {
        if c < 91 return cast(int)c - 64 + 26;
        else return cast(int)c - 96;
    };
    
    score := 0;
    for inventories {
        sv := cast([] u8) it;
        lhs := array_view(sv, 0, sv.count / 2);
        rhs := array_view(sv, sv.count / 2, sv.count - sv.count / 2);
        quick_sort(lhs, x => x);
        quick_sort(rhs, x => x);
        i := 0;
        j := 0;

        while true {
            if i >= lhs.count break;
            if j >= rhs.count break;

            if lhs[i] == rhs[j] {
                score += score_item(lhs[i]);
                break;
            }
            else if lhs[i] < rhs[j] i += 1;
            else j += 1;
        }
    }

    print("Match score %\n", score);

    // TODO(phil): Something about sorting the string slice does something
    // unexpected, these whole strings dont print right after doing the sort
    
    file_contents = read_entire_file("03.txt");
    inventories = split(file_contents, "\n");
    if !inventories[inventories.count - 1] pop(*inventories);

    matches := 0;
    badge_score := 0;
    group_idx := 0;
    while group_idx < inventories.count {
        table: Table(u8, int);

        print("%\n", inventories[group_idx]);
        
        for cast([] u8)inventories[group_idx] {
            table_set(*table, it, 1);
        }

        for cast([] u8)inventories[group_idx + 1] {
            p_val := table_find_pointer(*table, it);
            if p_val then <<p_val = 2;
        }

        for cast([] u8)inventories[group_idx + 2] {
            p_val := table_find_pointer(*table, it);
            if p_val {
                if <<p_val == 2 {
                    <<p_val = 3;
                    badge_score += score_item(it);
                    matches += 1;
                    /* print("Iter % match % score %\n", matches, it, badge_score); */
                    break;
                }
            }
        }

        group_idx += 3;
    }

    print("Badge score %\n", badge_score);
    
    /* T := string; */
    /* ti := cast(*Type_Info) T; */
    /* tis := cast(*Type_Info_Struct) ti; */
    /* for * tis.members { */
    /*     if !it continue; */
    /*     print("%\n", it.type); */
    /* } */

    /* s :: "Steve"; */
    /* ti_s := type_info(type_of(s)); */

    /* for member: ti_s.members { */
    /*     print("%\n", member); */
    /* } */
    
    /* print("%", type_of(inventories)); */
}
