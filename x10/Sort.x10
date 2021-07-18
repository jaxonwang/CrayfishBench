import x10.util.ArrayList;
import x10.io.File;
import x10.io.Console;

public class Sort {

    static val UPPER_LIMIT=4294967295;

    public static def main (args: Rail[String]) {

        val world = Place.places();
        val local_numbers = PlaceLocalHandle.make[ArrayList[Long]](world, ()=> new ArrayList[Long]());

        val c = Clock.make();

        for (d_a in world){
            at (d_a) async clocked (c){

                val world_size = Place.numPlaces();
                val chunk_size: Long = (UPPER_LIMIT + 1 )/ world_size;

                val input_nums = args.size / world_size;
                val input_range_start = input_nums * here.id();
                val input_range_end = input_nums * (here.id() + 1);
                // print input
                Console.OUT.print("input: ");
                for (i in input_range_start..(input_range_end-1)){
                    Console.OUT.print(args(i) + " ");
                }
                Console.OUT.println();

                for (i in input_range_start..(input_range_end-1)){
                    val input_file = new File(args(i));
                    val numbers = new Rail[ArrayList[Long]](world_size, new ArrayList[Long]());

                    for (line in input_file.lines()) {
                        val num = Long.parse(line);
                        numbers(get_partition(num, chunk_size)).add(num);
                    }

                    here_println("parse input:" + i + " done.");

                    finish{
                        for (d in world) at (d) async {
                            atomic {
                                local_numbers().addAll(numbers(d.id()).toRail());
                            }
                        }
                    }
                    here_println("distribute input:" + i + " done");
                }

                Clock.advanceAll();
                here_println("Sync done");

                local_numbers().sort();
                here_println(local_numbers()(0).toString());
                here_println("sort done");
            }
        }

    }

    static def get_partition (value: Long, chunk_size: Long) : Long {
        return value / chunk_size;
    }

    static def here_println(msg: String){
        Console.OUT.println(here.toString() + ": " + msg);
    }
}
