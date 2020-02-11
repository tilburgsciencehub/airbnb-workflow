import re
import os
import argparse


def error_check(_log):

    if not _log:
        return

    if not _log.endswith('.log'):
        print('ERROR : {0} is NOT a log file.'.format(_log))
        return

    f = open(_log, 'r')
    for l in f.readlines():
        m = re.findall(r'r\(\d{1,4}\)', l)
        if len(m) != 0:
            print(_log + ': Error ' + m[0])
            break

    if len(m) == 0:
        print(_log + ': Success')


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("logfile", type=str,
                        help="check the errors of stata program")
    args = parser.parse_args()
    return args.logfile


if __name__ == '__main__':
    logfile = parse_args()
    _log = os.path.join('.', logfile)
    error_check(_log)
