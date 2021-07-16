use crayfish::collective;
use crayfish::logging::*;
use crayfish::place;
use crayfish::place::Place;
use crayfish::shared::PlaceLocal;
use crayfish::shared::PlaceLocalWeak;
use std::io::BufRead;
use std::io::BufReader;
use std::sync::Mutex;

const UPPER_LIMIT: usize = 4294967295;

fn get_partition(value: usize, chunk_size: usize) -> usize {
    value / chunk_size
}

#[crayfish::activity]
async fn update_numbers(nums: Vec<usize>, ptr: PlaceLocalWeak<Mutex<Vec<usize>>>) {
    let mt = ptr.upgrade().unwrap();
    let mut local_nums = mt.lock().unwrap();
    local_nums.extend_from_slice(&nums[..]);
}

#[crayfish::main]
pub async fn main(args: Vec<String>) {
    let local_numbers = PlaceLocal::new(Mutex::new(Vec::<usize>::default()));

    collective::barrier().await;

    let data_dir = std::path::PathBuf::from(&args[1]);
    let world_size = place::world_size();
    let chunk_size = (UPPER_LIMIT + 1) / world_size;

    let mut numbers = vec![];
    for _ in 0..world_size {
        numbers.push(Vec::<usize>::default());
    }

    if place::here() == 0 {
        let first_file = std::fs::File::open(data_dir.join("data_sort_0")).unwrap();
        let bf = BufReader::new(first_file);
        for line in bf.lines() {
            let num = line.unwrap().parse::<usize>().unwrap();
            numbers[get_partition(num, chunk_size)].push(num);
        }

        info!("parse done");

        crayfish::finish! {
            for (dst, num) in numbers.into_iter().enumerate(){
                crayfish::ff!(dst as Place, update_numbers(num, local_numbers.downgrade()));
            }
        }
    }

    collective::barrier().await;

    info!("distributed done");
    let mut handle = local_numbers.lock().unwrap();
    handle.sort_unstable();
    println!("{}", handle[0]);

    info!("sort done");
}
