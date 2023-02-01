import os
import sys
import subprocess
from pathlib import Path


def llvm_gen_ir(source: str, output: str):
    input_path = os.path.realpath(source)
    output_path = os.path.realpath(output)

    start_dir = os.path.realpath(os.curdir)
    os.chdir('./deps/rush/crates/rush-compiler-llvm/')

    subprocess.run(
        f'cargo r {input_path}',
        shell=True,
    ).check_returncode()

    os.rename('output.ll', output_path)
    os.chdir(start_dir)

    print(f'generated {output_path}')


def riscv_asm(source: str, output: str):
    input_path = os.path.realpath(source)
    output_path = os.path.realpath(output)

    start_dir = os.path.realpath(os.curdir)
    os.chdir('./deps/rush/crates/rush-compiler-risc-v/')

    subprocess.run(
        f'cargo r {input_path}',
        shell=True,
    ).check_returncode()

    os.rename('output.s', output_path)
    os.chdir(start_dir)

    print(f'generated {output_path}')


def lint_all():
    rush_files = list(Path('.').rglob('*.rush'))
    for rush_path in rush_files:
        if str(rush_path).startswith('deps/rush'):
            continue
        input_path = os.path.realpath(rush_path)

        start_dir = os.path.realpath(os.curdir)
        os.chdir('./deps/rush/crates/rush-analyzer/')

        res = subprocess.run(
            f'cargo r {input_path}',
            shell=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
        )

        if res.returncode:
            print("\x1b[1;31m=== CHECK FAILURE ===\x1b[1;m")
            sys.stdout.buffer.write(res.stderr)
            sys.stdout.buffer.write(res.stdout)

            exit(1)

        os.chdir(start_dir)
        print(f'ok: {input_path}')
    print("\x1b[1;32m=== CHECK SUCCESS ===\x1b[1;m")


if __name__ == '__main__':
    if len(sys.argv) != 2:
        print(f'Expected exactly one argument, got {len(sys.argv) - 1}')
        exit(1)

    if sys.argv[1] == 'check':
        lint_all()
    elif sys.argv[1] == 'build':
        llvm_gen_ir('./listings/fib.rush', './listings/generated/fib.ll')
        llvm_gen_ir('./listings/simple.rush', './listings/generated/simple.ll')
        riscv_asm(
            './listings/riscv_simple.rush',
            './listings/generated/riscv_simple.s',
        )
    else:
        print(f'Invalid command-line argument: {sys.argv[1]}')
        exit(1)
