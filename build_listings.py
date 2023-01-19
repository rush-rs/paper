import os
import subprocess


def llvm_gen_ir(source: str, output: str):

    input_path = os.path.realpath(source)
    output_path = os.path.realpath(output)

    start_dir = os.path.realpath(os.curdir)
    os.chdir('./deps/rush/crates/rush-compiler-llvm/')

    print(f'generated {output_path}')

    subprocess.run(
        f'cargo r {input_path}',
        shell=True,
    ).check_returncode()

    os.rename('output.ll', output_path)

    os.chdir(start_dir)


if __name__ == '__main__':
    llvm_gen_ir('./listings/fib.rush', './listings/generated/fib.ll')
    llvm_gen_ir('./listings/simple.rush', './listings/generated/simple.ll')
