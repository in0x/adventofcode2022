#import "Basic";
#import "File";
#import "String";
#import "Debug";
#import "Sort";

Node :: struct {
    size: int = 0;
    first_child: int = -1;
    next_sibling: int = -1;
    name: string;
}

//   /
//  a -> b -> c -> d
// e -> f -> g -> h
//i

// TODO: why cant we use []. if tree is a pointer, read up about pointers vs references
find_dirs_to_del :: (tree: *[..]Node, cur: int, all_dirs: *[..]int) -> int {
    if cur == -1 return 0;
    /* if tree[cur].size > 0 return tree[cur].size; */
    cur_node := (<<tree)[cur];
    size := cur_node.size;
    size += find_dirs_to_del(tree, cur_node.first_child, all_dirs);

    if cur_node.size == 0 {
        print("% %\n", cur_node.name, size);
        array_add(all_dirs, size);
    }

    size += find_dirs_to_del(tree, cur_node.next_sibling, all_dirs);
    return size;
}

main :: () {    
    file_contents := read_entire_file("07.txt");
    lines := split(file_contents, "\n");
    if !lines[lines.count - 1] then pop(*lines);

    for lines {
        for i: 0..it.count - 1 {
            if it[i] == #char "\r" then it[i] = #char " "; 
            if it[i] == #char "\t" then it[i] = #char " ";
        }
    }

    tree: [..]Node;;
    {
        root : Node;
        root.name = "/";
        array_add(*tree, root);
    }

    push :: (stack: *[..]int, val: int) { array_add(stack, val); }
    top :: (stack: *[..]int) -> int { return (<<stack)[stack.count - 1]; }
    dir_stack: [..]int;
    push(*dir_stack, 0);

    /* attach_to_debugger(); */
    /* breakpoint(); */
    
    for lines {
        tokens := split(it, " ");
        
        if contains(tokens[0], "\$") {
            if contains(tokens[1], "cd") {
                if contains(tokens[2], "/") {
                    while top(*dir_stack) != 0 {
                        pop(*dir_stack);
                    }
                }
                else if contains(tokens[2], "..") {
                    pop(*dir_stack);
                }
                else { // move to child
                    dir_name := tokens[2];
                    cd := top(*dir_stack);
                    cd = tree[cd].first_child;
                    while tree[cd].name != dir_name {                        
                        cd = tree[cd].next_sibling;
                    }
                    push(*dir_stack, cd);
                }
            }
            // ignore ls
        }
        else {
            node := array_add(*tree);
            node.name = trim(copy_string(tokens[1]));
            
            if !contains(tokens[0], "dir") {
                node.size = parse_int(*tokens[0]);
            }

            cd := top(*dir_stack);
            if tree[cd].first_child == -1 {
                tree[cd].first_child = tree.count - 1;
            }
            else {
                cd = tree[cd].first_child;
                while tree[cd].next_sibling != -1 {
                    cd = tree[cd].next_sibling;
                }
                tree[cd].next_sibling = tree.count - 1;
            };
        }
    }

    all_dirs: [..]int;
    find_dirs_to_del(*tree, 0, *all_dirs);


    compare := (l: int, r: int) -> s64 {
        if l < r then return 1;
        else if l > r then return -1;
        else return 0;
    };
    
    quick_sort(all_dirs, compare);

    root_dir_size := all_dirs[0];
    space_left := 70000000 - root_dir_size;
    space_needed := 30000000 - space_left;

    print("% %\n", space_left, space_needed);
    // 25874010
    //  4125990
    
    for < all_dirs {
        if it >= space_needed {
            print("Free % bytes\n", it);
            break;
        }
    }

    // 44125990
    // 4473403
}
