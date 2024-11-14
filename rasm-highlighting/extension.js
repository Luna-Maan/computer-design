// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
const vscode = require('vscode');


// RASM FILES

const tokenTypes = ['class', 'interface', 'enum', 'function', 'variable', 'function'];
const tokenModifiers = ['declaration', 'documentation'];
const legend = new vscode.SemanticTokensLegend(tokenTypes, tokenModifiers);

var declaredConstants = new Set();
var declaredVariables = new Set();
var declaredLabels = new Set();

const provider = {
    provideDocumentSemanticTokens: function (document) {
        const tokensBuilder = new vscode.SemanticTokensBuilder(legend);
        const text = document.getText();
        const lines = text.split(/\r?\n/);

        console.log("HELLO\nHELLO\nHELLO\nHELLO")

        declaredConstants = new Set();
        declaredVariables = new Set();
        declaredLabels = new Set();

        // Keywords that declare a variable as the third word
        const declarationKeywordsThree = new Set([
            "and", "or", "nand", "nor", "xor", "xnor", "test",
            "add", "addc", "sub", "subb", "mult", "div",
            "shl", "shr", "shrc", "rotl", "rotr", "fadd", "fsub",
            "fmult", "fdiv"
        ]);

        const declarationKeywordsTwo = new Set([
            "ftoint", "inttof", "copyptr", "copy",
            "not", "high", "inc", "dec"
        ])


        lines.forEach((line, lineIndex) => {
            console.log(line)
            const words = line.trim().split(/\s+/);

            words.forEach((word, wordIndex) => {
                const lowerWord = word.toLowerCase();

                // Detect 'const' and mark the next word as a constant
                if (lowerWord === 'const' && words[wordIndex + 1]) {
                    const constantName = words[wordIndex + 1];
                    declaredConstants.add(constantName);
                }

                // Detect 'import' and mark the next word as a label
                else if (word === 'import' && words[wordIndex + 1]) {
                    const fullName = words[wordIndex + 1];
                    const labelName = fullName.split('.').slice(0, -1).join('.'); // remove the extension (e.g. .rasm)
                    declaredLabels.add(labelName);
                }

                // Detect 'label' and mark the next word as a label
                if (word === 'label' && words[wordIndex + 1]) {
                    const labelName = words[wordIndex + 1];
                    declaredLabels.add(labelName);
                }
            });

            const firstWordLower = words[0].toLowerCase();
            // Check if line starts with one of the keywords and has at least four words
            if (declarationKeywordsThree.has(firstWordLower) && words.length > 3) {
                const variableName = words[3];
                declaredVariables.add(variableName);
            }

            // Check if line starts with one of the keywords and has at least three words
            if (declarationKeywordsTwo.has(firstWordLower) && words.length > 2) {
                const variableName = words[2];
                declaredVariables.add(variableName);
            }

            // Highlight further uses of declared constants
            declaredConstants.forEach(variable => {
                // Use word boundaries to avoid partial matches and matches with variables within < and >
                const regex = new RegExp(`(?<![<>])\\b${variable}\\b(?![<>])`, 'g');
                let match;
                while ((match = regex.exec(line)) !== null) {
                    const start = match.index;
                    tokensBuilder.push(
                        new vscode.Range(
                            new vscode.Position(lineIndex, start),
                            new vscode.Position(lineIndex, start + variable.length)
                        ),
                        'variable'
                    );
                }
            });

            // Highlight each occurrence of declared variables between < and >
            declaredVariables.forEach(variable => {
                // Match variables only if they appear between `<` and `>`
                const regex = new RegExp(`<${variable}>`, 'g');
                let match;
                while ((match = regex.exec(line)) !== null) {
                    const start = match.index + 1; // Exclude `<` from the start
                    tokensBuilder.push(
                        new vscode.Range(
                            new vscode.Position(lineIndex, start),
                            new vscode.Position(lineIndex, start + variable.length)
                        ),
                        'variable'
                    );
                }
            });

            // Highlight each occurrence of declared variables between < and >
            declaredLabels.forEach(variable => {
                // Use word boundaries to avoid partial matches and matches with variables within < and >
                const regex = new RegExp(`(?<![<>])\\b${variable}\\b(?![<>])`, 'g');
                let match;
                while ((match = regex.exec(line)) !== null) {
                    const start = match.index;
                    tokensBuilder.push(
                        new vscode.Range(
                            new vscode.Position(lineIndex, start),
                            new vscode.Position(lineIndex, start + variable.length)
                        ),
                        'function'
                    );
                }
            });
        });

        return tokensBuilder.build();
    }
};

const selector = { language: 'rasm', scheme: 'file' }; // register for all rasm documents from the local file system

vscode.languages.registerDocumentSemanticTokensProvider(selector, provider, legend);







// MACHINE CODE FILES

const MachineCodeHoverProvider = {
    provideHover(document, position, token) {
        const wordRange = document.getWordRangeAtPosition(position, /\b[0-9A-Fa-f]{16}\b/);
        const word = document.getText(wordRange).toUpperCase();

        const byteHex = word.slice(1, 4); // Last 12 bits of the first 4 digits in hex
        const byteValue = parseInt(byteHex, 16);

        const threeArgInstructions = {
            0x01: "JUMPGT",
            0x02: "JUMPEQ",
            0x03: "JUMPGE",
            0x04: "JUMPLT",
            0x05: "JUMPNE",
            0x06: "JUMPLE",
            0x08: "AND",
            0x09: "OR",
            0x0a: "NAND",
            0x0b: "NOR",
            0x0c: "XOR",
            0x0d: "XNOR",
            0x0e: "TEST",
            0x10: "ADD",
            0x11: "ADDC",
            0x12: "SUB",
            0x13: "SUBB",
            0x14: "MULT",
            0x15: "DIV",
            0x18: "SHL",
            0x19: "SHLC",
            0x1a: "SHR",
            0x1b: "SHRC",
            0x1c: "ROTL",
            0x1d: "ROTR",
            0x101: "UJUMPGT",
            0x102: "UJUMPEQ",
            0x103: "UJUMPGE",
            0x104: "UJUMPLT",
            0x105: "UJUMPNE",
            0x106: "UJUMPLE",
            0x210: "FADD",
            0x211: "FSUB",
            0x212: "FMULT",
            0x210: "FDIV",
            0x210: "FTOINT",
            0x210: "INTTOF",
            0x201: "FJUMPGT",
            0x202: "FJUMPEQ",
            0x203: "FJUMPGE",
            0x204: "FJUMPLT",
            0x205: "FJUMPNE",
            0x206: "FJUMPLE",
            0x400: "CALL",
            0x527: "RET",
            0x507: "RET",
        }

        const twoArgInstructions = {
            0x07: "JUMP",
            0x0f: "NOT",
            0x4f: "HIGH",
            0x16: "INC",
            0x17: "DEC",
            0x1e: "COPY",
            0x107: "UJUMP",
            0x207: "FJUMP",
            0x710: "COPYPTR",
        }

        let instruction;
        let numberOfArgs
        let a = (byteValue & 0x80) == 0;
        let b = (byteValue & 0x40) == 0;
        let c = (byteValue & 0x20) == 0;
        if (threeArgInstructions.hasOwnProperty(byteValue & 0xF1F)) { // mask the 3 bits for pointer args
            instruction = threeArgInstructions[byteValue & 0xF1F];
            numberOfArgs = 3;
        } else if (twoArgInstructions.hasOwnProperty(byteValue & 0xF5F)) { // mask the 2 bits for pointer args
            instruction = twoArgInstructions[byteValue & 0xF5F];
            numberOfArgs = 2;
        } else if (byteValue & 0xF1F == 0x600) {
            instruction = "EXIT";
            numberOfArgs = 0;
        } else if (byteValue & 0xF1F == 0x601) {
            instruction = "HLT";
            numberOfArgs = 0;
        }


        // Convert the second, third, and fourth 4-digit hex values to decimal
        const secondHex = word.slice(4, 8);
        const thirdHex = word.slice(8, 12);
        const fourthHex = word.slice(12, 16);

        const second = parseInt(secondHex, 16);
        const third = parseInt(thirdHex, 16);
        const fourth = parseInt(fourthHex, 16);

        // Format the values based on flags
        const secondFormatted = a ? `<${second}>` : second;
        const thirdFormatted = b ? `<${third}>` : third;
        const fourthFormatted = c ? `<${fourth}>` : fourth;


        let hoverText;
        if (numberOfArgs == 3) {
            hoverText = `\`\`\`rasm\n${instruction} ${secondFormatted} ${thirdFormatted} ${fourthFormatted}\n\`\`\`\n`;
        }
        else {
            hoverText = `\`\`\`rasm\n${instruction} ${secondFormatted} ${fourthFormatted}\n\`\`\`\n`;
        }

        return new vscode.Hover(hoverText);
    }
};

const machineSelector = { language: 'machine', scheme: 'file' };

vscode.languages.registerHoverProvider(machineSelector, MachineCodeHoverProvider);