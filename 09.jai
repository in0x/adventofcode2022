#import "Basic";
#import "File";
#import "String";
#import "Math";

Vec2i :: struct {
    x, y: s32;
}

operator + :: (a: Vec2i, b: Vec2i) -> Vec2i {
    return Vec2i.{ a.x + b.x, a.y + b.y };
}

operator - :: (a: Vec2i, b: Vec2i) -> Vec2i {
    return Vec2i.{ a.x - b.x, a.y - b.y };
}

operator == :: (a: Vec2i, b: Vec2i) -> bool {
    return a.x == b.x && a.y == b.y;
}

length :: (v: Vec2i) -> float {
    return sqrt(cast(float)v.x * cast(float)v.x + cast(float)v.y * cast(float)v.y);
}

channel_norm :: (v: *Vec2i) {
    if v.x then v.x /= abs(v.x);
    if v.y then v.y /= abs(v.y);
}

main :: () {
    file_contents := read_entire_file("09.txt");
    lines := split(file_contents, "\n");
    if !lines[lines.count - 1] then pop(*lines);

    rope: [10]Vec2i;

    unique_pos: [..]Vec2i;
    array_add(*unique_pos, Vec2i.{0, 0});

    for line: lines {
        tokens := split(line, " ");
        dir := tokens[0];
        cnt := parse_int(*tokens[1]);
          
        move_dir: Vec2i;
        if      dir == "R" move_dir = Vec2i.{1,0};
        else if dir == "L" move_dir = Vec2i.{-1, 0}; 
        else if dir == "U" move_dir = Vec2i.{0 , 1};
        else if dir == "D" move_dir = Vec2i.{0, -1};

        for i: 1..cnt {
            rope[0] += move_dir;
            for i: 1..rope.count - 1 {        
                dist :=  rope[i - 1] - rope[i];

                if length(dist) >= 2.0 {
                    channel_norm(*dist);
                    rope[i] += dist;
                }
            }
            
            new_pos := true;
            for unique_pos {
                if it == rope[9] {
                    new_pos = false;
                    break;
                }
            }
            if new_pos then array_add(*unique_pos, rope[9]);
        }
    }

    print("#Pos=%\n", unique_pos.count);
}
