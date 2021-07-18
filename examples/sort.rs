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

    let global_input_files = &args[1..];
    let local_id = place::here() as usize;
    let world_size = place::world_size();

    let start_input = global_input_files.len() / world_size * local_id;
    let end = global_input_files.len() / world_size * (local_id + 1);
    let my_inputs = &global_input_files[start_input..end];
    info!("inputs {:?}", my_inputs);

    let chunk_size = (UPPER_LIMIT + 1) / world_size;

    collective::barrier().await;
    for file_name in my_inputs.iter() {
        let mut numbers = vec![vec![];world_size];
        let input_file = std::fs::File::open(file_name).unwrap();
        let bf = BufReader::new(input_file);
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
    handle.sort();
    println!("{}", handle[0]);

    info!("sort done");
}
