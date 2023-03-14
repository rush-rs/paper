#!/bin/python3
# This file is intended to be used as a tokei cache
# it maps a directory (to be counted) to a git commit and the cached loc

import sys
import subprocess
import json
from pathlib import Path

CACHE_FILE: str = './tokei.cache.json'


def write_json(data: {}):
    with open(CACHE_FILE, 'w') as file:
        json.dump(data, file)


def read_json():
    with open(CACHE_FILE, 'r') as file:
        data = json.load(file)
        return data


def get_commit(path: str):
    res = subprocess.run(
        f'git -C {path} rev-parse --short HEAD',
        shell=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    res.check_returncode()
    return res.stdout.decode('utf-8').rstrip()


def count(path: str, data: {}):
    commit = get_commit(path)
    if path in data:
        if data[path]['commit'] == commit:
            print('using cache', file=sys.stderr)
            return data[path]['loc']

    res = subprocess.run(
        f'tokei {path} -o json',
        shell=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    res.check_returncode()

    print('using fresh data', file=sys.stderr)
    tokei_data = json.loads(res.stdout)
    loc = tokei_data['Total']['code']

    data[path] = {
        'commit': commit,
        'loc': loc,
    }

    write_json(data)
    return loc


if __name__ == '__main__':
    cache_file = Path(CACHE_FILE)

    if not cache_file.is_file():
        write_json({})

    if len(sys.argv) != 2:
        print(f'Expected exactly one argument (path), found {len(sys.argv)}')
        exit(1)

    cache = read_json()
    try:
        sys.stdout.buffer.write(bytes(str(count(sys.argv[1], cache)), 'utf-8'))
    except:
        pass
