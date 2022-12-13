#import "Basic";
#import "File";
#import "String";

// "a" min height -> "z" max height
// S -> start, E -> end
// S has height a, E has height z
// next step can increase elevation at most by one, but it can reduce elevation unrestricted

VISIBLE_ASCII :: " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";

Coord :: struct {
    x, y: int;
}

operator + :: (a: Coord, b: Coord) -> Coord {
    return Coord.{ a.x + b.x, a.y + b.y };
}

operator == :: (a: Coord, b: Coord) -> bool {
    return a.x == b.x && a.y == b.y;
}

node_id_counter := 0;

Node :: struct {
    id: int;
    coord: Coord;
    next, prev: *Node;
}

Queue :: struct {
    head, tail: Node;
}

make_queue :: () -> *Queue {
    q := New(Queue);
    q.head.id = node_id_counter;
    node_id_counter += 1;
    q.tail.id = node_id_counter;
    node_id_counter += 1;
    q.head.next = *q.tail;
    q.tail.prev = *q.head;
    return q;
}

pop :: (q: *Queue) -> *Node {
    if q.tail.prev == *q.head && q.head.next == *q.tail {
        return null;
    }

    ret := q.tail.prev;
    ret.prev.next = *q.tail;
    q.tail.prev = ret.prev;
    ret.prev = null;
    ret.next = null;
    return ret;
}

push :: (q: *Queue) -> *Node {
    node := New(Node);
    node.id = node_id_counter;
    node_id_counter += 1;
    node.next = q.head.next;
    node.prev = *q.head;
    q.head.next.prev = node;
    q.head.next = node;
    return node;
}

main :: () {
    file_contents := read_entire_file("12.txt");
    grid := split(file_contents, "\n");
    if !grid[grid.count - 1] then pop(*grid);

    start, end: Coord;
    for y: 0..grid.count - 1 {
        for x: 0..grid[y].count - 1 {
            if grid[y][x] == #char "S" {
                start.x = x;
                start.y = y;
                print("Found start %\n", start);
            }
            if grid[y][x] == #char "E" {
                end.x = x;
                end.y = y;
                print("Found end %\n", end);
            }
        }
    }

    dirs := Coord.[Coord.{1, 0}, Coord.{-1, 0}, Coord.{0, 1}, Coord.{0, -1}];

    // for part 2
    start = end;
    
    q := make_queue();
    defer free(q);
    first := push(q);
    first.coord = start;

    visited: [..][..]bool;
    array_resize(*visited, grid.count);
    for * visited {
        array_resize(it, grid[0].count);
    }

    came_from: [..][..]Coord;
    array_resize(*came_from, grid.count);
    for * came_from {
        array_resize(it, grid[0].count);
        for *c: (<<it) {
            c.x = -1;
            c.y = -1;
        }
    }

    visited[start.y][start.x] = true;
    
    cur := pop(q);

    /* while cur != null && cur.coord != end { */
    while cur != null && grid[cur.coord.y][cur.coord.x] != #char "a" {
        for d: dirs {
            n := cur.coord + d;
            if n.x < 0 || n.x >= grid[0].count then continue;
            if n.y < 0 || n.y >= grid.count then continue;
            if visited[n.y][n.x] then continue;

            cur_ht := cast(int) grid[cur.coord.y][cur.coord.x];
            nxt_ht := cast(int) grid[n.y][n.x];
            
            if nxt_ht == #char "E" {
                nxt_ht = cast(int) #char "z";
            } else {
                nxt_ht = cast(int) to_lower(grid[n.y][n.x]);
            }

            if cur_ht == #char "E" {
                cur_ht = cast(int) #char "z";
            } else {
                cur_ht = cast(int) to_lower(grid[cur.coord.y][cur.coord.x]);
            }
            
            /* if (nxt_ht - cur_ht) <= 1 { */
            if (cur_ht - 1) <= nxt_ht {
                print("step % -> %\n",
                      slice(VISIBLE_ASCII, cur_ht - #char " ", 1),
                      slice(VISIBLE_ASCII, nxt_ht - #char " ", 1));
                nxt_node := push(q);
                nxt_node.coord = n;
                visited[n.y][n.x] = true;
                came_from[n.y][n.x] = cur.coord;
            }
        }

        free(cur);
        cur = pop(q);
    }

    // for part 2
    end = cur.coord;
    print("End reached: %\n", end);
    
    steps := 0;
    trace := end;
    while trace != start {
        steps += 1;
        print("from % back to % , % -> %\n", came_from[trace.y][trace.x], trace,
            slice(VISIBLE_ASCII, grid[came_from[trace.y][trace.x].y][came_from[trace.y][trace.x].x] - #char " ", 1), 
            slice(VISIBLE_ASCII, grid[trace.y][trace.x] - #char " ", 1), 
        );
        // print("from % back to %\n", trace, came_from[trace.y][trace.x]);

        trace = came_from[trace.y][trace.x];
    }

    print("Steps taken %\n", steps);
}
