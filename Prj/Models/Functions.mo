function  pick_array

    input Real z;   // uniformly distributed random input
    input Real[:] P;   // probability distribution
    output Integer w;  // Random variable
    protected Integer i;
    protected Real y;

    algorithm
    i := 1;
    y := P[i];
    while ((z > y) and (i < size(P, 1))) loop
        i := i + 1;
        y := y + P[i];
    end while;
    w := i;

end pick_array;


function pick_matrix

    input Real z;   // uniformly random input
    input Integer x;  // present state
    input Real[:,:] Matrix;   // Transition Matrix
    output Integer next_state;  // next state

    protected Integer i;
    protected Real y;

    algorithm
        i := 1;
        y := Matrix[x, i];
        while ((z > y) and (i < size(Matrix, 1))) loop
            i := i + 1;
            y := y + Matrix[x, i];
        end while;
        next_state := i;

end pick_matrix;


function unsigned_integer

    input Integer x;
    output Integer y;

    algorithm
        if x < 0 then
            y := -x;
        else
            y := x;
        end if;

end unsigned_integer;
