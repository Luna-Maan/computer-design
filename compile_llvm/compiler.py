import llvmlite.binding as llvm

# TODO: implement printf
# TODO: implement function calls with arguments and return values
# TODO: implement branching instructions
# TODO: implement load/store instructions
# TODO: implement unsigned operations correcrtly
BINOP = {
    "add":  "add",
    "sub":  "sub",
    "mul":  "mult",

    "udiv": "div",
    "sdiv": "div",


    "shl":  "shl",
    "lshr": "shr",

    "or":   "or",
    "xor":  "xor",
    "and":  "and",
}

ICMP_MAP = {
    "==":  "JumpEq",
    "!=":  "JumpNE",
    ">":   "JumpGt",
    ">=":  "JumpGE",
    "<":   "JumpLt",
    "<=":  "JumpLE",
}

class RASMAssemblyCompiler:
    def __init__(self):
        self.reg_map = {}
        self.next_reg = 0
        self.instructions = []
        self.labels = {}

    def get_reg(self, llvm_val):
        """Maps LLVM virtual registers to reg0-reg31."""
        if llvm_val not in self.reg_map:
            self.reg_map[llvm_val] = f"reg{self.next_reg}"
            self.next_reg += 1
        return self.reg_map[llvm_val]
    
    def format_operand(self, val, is_indirect=False):
        """
        Formats operand based on RASM notation:
        a   -> value
        <a> -> register
        """
        if hasattr(val, 'constant'):
            return str(val.constant)
        else:
            reg = self.get_reg(val)
            return f"<{reg}>" if not is_indirect else reg
        
    def emit_binop(self, opcode, src1, src2, dst):
        rasm_op = BINOP.get(opcode)
        if rasm_op:
            rasm_src1 = self.format_operand(src1)
            rasm_src2 = self.format_operand(src2)
            rasm_dst = self.get_reg(dst)
            return f"{rasm_op} {rasm_src1} {rasm_src2} {rasm_dst}"




    def compile(self, ir_text):
        mod = llvm.parse_assembly(ir_text)
        
        for func in mod.functions:
            self.instructions.append(f"label {func.name}")
            for block in func.blocks:
                # Add label for the block (block.name doesnt always exist)
                block_label = block.name if block.name else f"block_{id(block)}"
                self.instructions.append(f"label {block_label}")

                for instr in block.instructions:
                    line = self.translate_instr(instr)
                    if line:
                        self.instructions.append(f"    {line}")
        
        return "\n".join(self.instructions)

    def translate_instr(self, instr):
        opcode = instr.opcode
        ops = list(instr.operands)
        
        # Mapping LLVM to RASM keywords
        if opcode in BINOP:
            return self.emit_binop(opcode, ops[0], ops[1], instr)
        
        if opcode == "call":
            # we dont support only declarations
            if not ops[0].name:
                return f"; Unsupported instruction: {instr}"

            return f"call {ops[0].name}"
        
        if opcode == "ret":
            return "ret"
        
        return f"; Unsupported instruction: {opcode}"

# open file and read IR code`
with open("compile_llvm/loop.ll", "r") as f:
    ir_code = f.read()

compiler = RASMAssemblyCompiler()

with open("output.rasm", "w") as f:
    f.write(compiler.compile(ir_code))