import os
import subprocess


def llvm_gen_ir(source: str, output: str):
    os.chdir('./deps/rush/crates/rush-compiler-llvm/')

    input_path = os.path.realpath(source)
    output_path = os.path.realpath(output)

    print(input_path)

    subprocess.run(
        f'cargo r {input_path}',
        shell=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    ).check_returncode()


if __name__ == '__main__':
    llvm_gen_ir('./listings/fib.rush', './listings/fib.ll')
