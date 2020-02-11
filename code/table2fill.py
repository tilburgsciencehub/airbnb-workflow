import re
import os
import argparse


def table2fill(_table, _out):

    if not _table:
        return

    f = open(_table, 'r')
    o = open(_out, 'w')
    for l in f.readlines():
        m1 = re.sub(r'\{', '<', l)
        m2 = re.sub(r'\}', '>', m1)
        m3 = re.sub(r'r\d+\t', '', m2)
        m4 = re.sub(r'c\d+\t', '', m3)
        o.writelines(m4)
    f.close()
    o.close()


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("tablefile", type=str,
                        help="Fix table so as to fill into writings")
    args = parser.parse_args()
    return args.tablefile


if __name__ == '__main__':
    tablefile = parse_args()
    _table = os.path.join('.', tablefile)
    _out = os.path.join('.', 'output/table/temp.txt')
    print(_table)
    print(_out)
    table2fill(_table, _out)
    os.remove(_table)
    os.rename(_out, _table)
