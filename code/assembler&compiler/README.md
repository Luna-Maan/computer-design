# Assembler, Compiler and Transpiler Documentation

## Assembler, Compiler and Transpiler Scripts

### `assemblerimport.py`
- Assembles assembly code.
- Default input: `assembly.rasm`.
- Default output: `MachineCode.out`.
- **SECOND OUTPUT**: writes to `RomData.hex` for use in the computer. The path is hardcoded at the top of the script and must be changed to match the computer's file structure.
- Usage:
  - With no arguments: uses `assembly.ovt` as input.
  - With one argument: uses the specified file as input.
  - With two arguments: uses the first as input and the second as output.

### `hcompiler.py`
- Compiles high-level code to assembly that `assemblerimport.py` can assemble.
- Default input: `high.ovt`.
- Default output: `assembly.rasm`.
- Usage:
  - With no arguments: uses `high.ovt` as input.
  - With one argument: uses the specified file as output. (This is so it works with `HIGHcompile.bat`.)
  - With two arguments: uses the first as input and the second as output.

### `high2py.py`
- Transpiles high-level code to Python.
- Default input: `high.ovt`.
- Default output: `high.py`.
- Usage:
  - With no arguments: uses `high.ovt` as input.
  - With one argument: uses the specified file as input.
  - With two arguments: uses the first as input and the second as output.

## Batch Files for Terminal Use

### `RASM.bat`
- Performs the same function as `assemblerimport.py`.
- Default input: `assembly.rasm`.
- Default output: `MachineCode.out`.
- **SECOND OUTPUT**: writes to `RomData.hex` for use in the computer. The path is hardcoded at the top of the script and must be changed to match the computer's file structure.
- When `assembler&compiler` folder is added to PATH, the batch file can be used in the terminal:
~~~
     RASM [inputPath] [outputPath]
~~~
- Usage:
  - With no arguments: uses `assembly.ovt` as input.
  - With one argument: uses the specified file as input.
  - With two arguments: uses the first as input and the second as output.

### `HIGHcompile.bat`
- Runs both `hcompiler.py` and `assemblerimport.py` in sequence.
- When assembler&compiler folder is added to PATH, it can be used in the terminal:
~~~
     HIGHcompile [inputPath] [outputPath]
~~~
- Usage:
  - With no arguments: uses `high.ovt` as input and `MachineCode.out` as output.
  - With one argument: uses the specified file as input.
  - With two arguments: uses the first as input and the second as output.
- It will always create an assembly file called `a.rasm`

### `HIGH2PY.bat`
- Performs the same function as `high2py.py`.
- When assembler&compiler folder is added to PATH, it can be used in the terminal:
~~~
     HIGH2PY [inputPath] [outputPath] [outputBool Output2Bool pixelsPerUpdate]
~~~
- Usage:
  - With no arguments: uses `high.ovt` as input.
  - With one argument: uses the specified file as input.
  - With two arguments: uses the first as input and the second as output.
  - With five arguments: uses the first as input, the second as output, the third as a boolean for outputting values written to output or output1, the fourth as a boolean for outputting the output2, and the fifth as the number of pixels per update. It defaults to `True True 1` when 2 or less arguments are given e.g. `HIGH2PY high.ovt high.py True True 1`
- `pixelsPerUpdate` is per how many pixels written to the screen the screen will update. The screen always updates when the program ends.

