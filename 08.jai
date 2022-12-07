#import "Basic";
#import "File";
#import "String";

main :: () {
    file_contents := read_entire_file("08.txt");
    lines := split(file_contents, "\n");
    if !lines[lines.count - 1] then pop(*lines);

    grid: [..][..]int;
    array_resize(*grid, lines.count);
    for i: 0..lines.count - 1 {
        input := slice(lines[i], 0, lines[i].count - 1);
        array_resize(*grid[i], input.count);
        for j: 0..input.count - 1 {
            grid[i][j] = input[j] - 48;
        }
    }

    scenic: [..][..]int;
    array_resize(*scenic, grid.count);
    for * scenic {
        array_resize(it, grid[0].count);
    }

    for r: 0..scenic.count - 1 {
        for c: 0..scenic[r].count - 1 {
            scenic[r][c] = 1;
        }
    }

    visible: [..][..]bool;
    array_resize(*visible, grid.count);
    for * visible {
        array_resize(it, grid[0].count);
    }

    for r: 0..visible.count - 1 {
        visible[r][0] = true;
        visible[r][visible[r].count - 1] = true;
    }

    for c: 0..visible[0].count - 1 {
        visible[0][c] = true;
        visible[visible.count - 1][c] = true;
    }

    for r: 1..grid.count - 2 {
        max_tree := grid[r][0];
        for c: 1..grid[r].count - 2 {
            if max_tree < grid[r][c] {
                visible[r][c] = true;
            }
            max_tree = max(max_tree, grid[r][c]);
        }
        
        max_tree = grid[r][grid[r].count - 1];
        for < c: grid[r].count - 2..1 {
            if max_tree < grid[r][c] {
                visible[r][c] = true;
            }
            max_tree = max(max_tree, grid[r][c]);
        } 
    }

    for c: 1..grid[0].count - 2 {
        max_tree := grid[0][c];
        for r: 1..grid.count - 2 {
            if max_tree < grid[r][c] {
                visible[r][c] = true;
            }
            max_tree = max(max_tree, grid[r][c]);
        }

        max_tree = grid[grid.count - 1][c];
        for < r: grid.count - 2..1 {
            if max_tree < grid[r][c] {
                visible[r][c] = true;
            }
            max_tree = max(max_tree, grid[r][c]);
        }
    }

    num_visible := 0;
    for r: visible {
        for c: r {
            if c then num_visible += 1;
        }
    }

    for r: 1..grid.count - 2 {
        for c: 1..grid[r].count - 2 {
            x := c;
            score := 0;
            while true {
                score += 1;
                x -= 1;
                if x <= 0 || grid[r][x] >= grid[r][c] break;
            }
            scenic[r][c] *= score;
            
            x = c;
            score = 0;
            while true {
                score += 1;
                x += 1;
                if x >= grid[r].count - 1 || grid[r][x] >= grid[r][c] break;
            }
            scenic[r][c] *= score;
            
            y := r;
            score = 0;
            while true {
                score += 1;
                y -= 1;
                if y <= 0 || grid[y][c] >= grid[r][c] break;
            }
            scenic[r][c] *= score;
            
            y = r;
            score = 0;
            while true {
                score += 1;
                y += 1;
                if y >= grid.count - 1 || grid[y][c] >= grid[r][c] break;
            }
            scenic[r][c] *= score;
        }
    }
    
    max_scenic := 0;
    for r: scenic {
        for c: r {
            max_scenic = max(max_scenic, c);
        }
    }
    
    print("Visible %\n", num_visible);
    print("Scenic %\n", max_scenic);
}
