import argparse
import sys
import os
import random


def gen(start, end, num, f):
    nums = [str(random.randint(start, end)) for _i in range(num)]
    out = "\n".join(nums)
    f.write(out)

if __name__ == "__main__":

    if len(sys.argv) != 6 :
        print("Usage: sort.py N Dir Start End NumPerFile")
        sys.exit(1)

    p_num = int(sys.argv[1])
    dest_dir = sys.argv[2]
    start = int(sys.argv[3])
    end = int(sys.argv[4])
    num_per_file = int(sys.argv[5])
    assert(os.path.isdir(dest_dir));

    for i in range(p_num):
        with open(dest_dir + "/data_sort_{}".format(i), "w") as f:
            gen(start, end, num_per_file, f)


