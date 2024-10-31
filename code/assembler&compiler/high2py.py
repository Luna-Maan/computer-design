import re
import sys

if len(sys.argv) >= 3:
    inputfile = sys.argv[1]
    outputfile = sys.argv[2]
elif len(sys.argv) == 2:
    inputfile = sys.argv[1]
    outputfile = "high.py"
else:
    inputfile = "high.ovt"
    outputfile = "high.py"

if len(sys.argv) == 6:
    printOutput = sys.argv[3] == "True"
    printOutput2 = sys.argv[4] == "True"
    pixelsPerUpdate = int(sys.argv[5])
else:
    printOutput = True
    printOutput2 = True
    pixelsPerUpdate = 1

def parse_and_replace(match):

    var_name = match.group(1)
    rows = int(match.group(2), 16)
    cols = int(match.group(3), 16)
    elements_hex = re.findall(r'\((\w+)\)', match.group(4))
    
    # Convert elements from hex to integers
    elements = [int(el, 16) for el in elements_hex]
    
    # Reshape elements into the specified 2D list structure
    matrix = [elements[i * cols: (i + 1) * cols] for i in range(rows)]
    
    # Format the result as a replacement line
    replacement_line = f"{var_name} = {matrix}"
    return replacement_line

def hex_to_decimal(s):
    try:
        # Try to convert the string to an integer with base 16
        return str(int(s, 16))
    except ValueError:
        # If conversion fails, return None or some indication it is not hex
        return s



ass = open(inputfile, "r")
a = ass.read()
ass.close()

a = a.split('\n')

for i in range(0, len(a)):
    a[i] = a[i].split(' ')

j=0
for i in range(0,len(a)):
    if len(a[j]) == 0:
        a.pop(j)
        j-=1
    elif a[j][0] == "const":
        a.pop(j)
        j-=1
    elif a[j][0] == "exit":
        a.pop(j)
        j-=1
    j+=1

for i in range(0,len(a)):
    for j in range(0,len(a[i])):
        if a[i][j] == "fwhile":
            a[i][j] = "while"


        if a[i][j] == "f=":
            a[i][j] = "="
        
        if a[i][j] == "inttof":
            a[i][j] = a[i][j+2]
            a[i][j+2] = a[i][j+1]
            a[i][j+1] = '='
        if "output" in a[i][j]:
            a[i][j] = a[i][j] + '('
            a[i][j+1] = ''
            a[i].append(')')

        a[i][j] = hex_to_decimal(a[i][j])



print(a)
for i in range(0,len(a)):
    a[i] = ' '.join(a[i])

for i in range(0,len(a)):
    # Extract variable name, dimensions, and elements in hex
    match = re.match(r'(\w+)\s*=\s*\w+\[(\w+)\]\[(\w+)\]\s*((?:\(\w+\)\s*)+)', a[i])
    
    if match:
        a[i] = parse_and_replace(match)
    


print(a)

a = '\n'.join(a)

pyemul = f"""import numpy as np
import matplotlib.pyplot as plt

a = np.zeros((256,256))
#plt.imshow(a)
#plt.show(block = False)
#plt.pause(0.2)

count = 0
x=0
y=0
value = 1
def output2(b):
    global value
    value = int(b)
    if {printOutput2}:
        print(value)

def output(b):
    global x
    x=int(b)
    if {printOutput}:
        print(x)

def output0(b):
    global x
    x=int(b)
    if {printOutput}:
        print(x)

def output1(b):
    global y
    global a
    global count
    y= int(b)
    a[y][x] = value
    count += 1
    if count % {pixelsPerUpdate} == 0:
        plt.imshow(a)
        plt.show(block = False)
        plt.pause(0.001)
"""

print(pyemul + a + "\nplt.imshow(a)\nplt.show()")



machine = open(outputfile, "w")
machine.write(pyemul + a + "\nplt.imshow(a)\nplt.show()")
machine.close()