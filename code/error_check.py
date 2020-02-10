import re
import os


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
            print('Error: ' + m[0])
            break

    if len(m) == 0:
        print('Success.')


if __name__ == '__main__':
    log1 = os.path.join('./output/log', 'clean.log')
    error_check(log1)

    log2 = os.path.join('./output/log', 'analysis.log')
    error_check(log2)
