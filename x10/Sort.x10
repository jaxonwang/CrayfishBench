import x10.util.ArrayList;
import x10.io.File;
import x10.io.Console;

public class Sort {

    static val DIM=2;
    static val CLUSTERS=4;
    static val POINTS=2000;
    static val ITERATIONS=50;
    static val UPPER_LIMIT=4294967295;

    public static def main (args: Rail[String]) {

        val world = Place.places();
        val local_numbers = PlaceLocalHandle.make[ArrayList[Long]](world, ()=> new ArrayList[Long]());

        val data_dir = args(0);
        val world_size = Place.numPlaces();
        val chunk_size: Long = (UPPER_LIMIT + 1 )/ world_size;

        val numbers = new Rail[ArrayList[Long]](world_size);
        for (i in 0..(numbers.size-1)) {
            numbers(i) = new ArrayList[Long]();
        }

        val first_file = new File(data_dir + "/data_sort_test");

        for (line in first_file.lines()) {
            val num = Long.parse(line);
            numbers(get_partition(num, chunk_size)).add(num);
        }

        Console.OUT.println("parse done.");

        finish{
            for (d in world) at (d) async {
                atomic {
                    local_numbers().addAll(numbers(d.id()).toRail());
                }
            }
        }

        Console.OUT.println("distribute done");

        for (d in world) {
            finish{
                at (d) async {
                    local_numbers().sort();
                    for (i in local_numbers()) {
                        Console.OUT.println(i);
                        break;
                    }
                }
            }
        }

        Console.OUT.println("sort done");

    }

    static def get_partition (value: Long, chunk_size: Long) : Long {
        val ret = value / chunk_size;
        return ret;
    }
}