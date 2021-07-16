use crayfish::place;
use crayfish::place::Place;
use crayfish::at;

#[crayfish::activity]
async fn fib(n:usize) -> usize{
    if n <= 2 {
        return 1;
    }

    let here = place::here();
    let world_size = place::world_size();
    let right = (here as usize + 1) % world_size;
    let left = (here as usize + world_size - 1) % world_size;

    crayfish::finish!{
        let f1_fut = at!(right as Place, fib(n - 1));
        let f2_fut = at!(left as Place, fib(n - 2));
        f1_fut.await + f2_fut.await
    }
}

#[crayfish::main]
async fn main(args: Vec<String>){
    let n = if args.len() > 1{
        args[1].parse::<usize>().unwrap()
    }else{
        10usize
    };
    if place::here() == 0 {
        crayfish::finish!{
            let f = at!(place::here(), fib(n)).await;
            println!("fib({}) = {}", n, f);
        };
    }
}
