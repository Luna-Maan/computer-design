// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
const vscode = require('vscode');

const tokenTypes = ['class', 'interface', 'enum', 'function', 'variable'];
const tokenModifiers = ['declaration', 'documentation'];
const legend = new vscode.SemanticTokensLegend(tokenTypes, tokenModifiers);

const provider = {
    provideDocumentSemanticTokens: function (document) {
        const tokensBuilder = new vscode.SemanticTokensBuilder(legend);

        // Define non-variable instruction keywords that don't allow variable assignments
        const nonVariableInstructions = new Set(['jump', 'label', 'ujumplt', 'jumplt']);

        // Parse each line of the document
        const lines = document.getText().split('\n');
        for (let lineIndex = 0; lineIndex < lines.length; lineIndex++) {
            const line = lines[lineIndex].trim();

            // Skip comment lines
            if (line.startsWith(';')) continue;

            // Tokenize the line by whitespace to split the instruction and arguments
            const tokens = line.split(/\s+/);

            // Check if the line is empty or has no instruction
            if (tokens.length < 2) continue;

            const instruction = tokens[0].toLowerCase();

            // Check if this is a writable instruction and not in the set of non-variable instructions
            if (!nonVariableInstructions.has(instruction)) {
                // Loop through each token after the instruction
                for (let i = 1; i < tokens.length; i++) {
                    const token = tokens[i];

                    // Match variables that are standalone words or wrapped in < and >
                    const variableMatch = token.match(/^<?(\w+)>?$/);

                    if (variableMatch) {
                        const variableName = variableMatch[1];

                        // Check if this is the last token in the instruction (writable variable)
                        if (i === tokens.length - 1) {
                            // Calculate character positions for the variable in the document line
                            const startPos = line.indexOf(token);
                            const endPos = startPos + token.length;

                            // Push the token as a writable variable
                            tokensBuilder.push(
                                new vscode.Range(new vscode.Position(lineIndex, startPos), new vscode.Position(lineIndex, endPos)),
                                'variable',
                                ['declaration']
                            );
                        }
                    }
                }
            }
        }

        return tokensBuilder.build();
    }
};




const selector = { language: 'rasm', scheme: 'file' }; // register for all Java documents from the local file system

vscode.languages.registerDocumentSemanticTokensProvider(selector, provider, legend);