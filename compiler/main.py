import sys

COMMANDS = {
    'LOAD' : '0000',
    'STORE' : '0001',
    'ADD' : '0010',
    'SUB' : '0011',
    'INC' : '0100',
    'DEC' : '0101',
    'JNZ' : '0110',
    'JZ' : '0111',
    'JNSB' : '1000',
    'JMP' : '1001',
    'HALT' : '1010'
}

CONSTS = {
    'INDF' : '111111',
    'FSR' : '111110'
}

OPERAND_LENGTH = 6

def compile(path):    
    result_commands = []
    for i, line in enumerate(open(path, 'r')):
        opcode = ''
        elements = line.strip().split()
        if len(elements) > 0:
            command = elements[0]
            if not command in COMMANDS:
                print('Invalid command: {}'.format(command))
                return
            else:
                opcode = COMMANDS[command]
            if len(elements) > 1:
                operand = elements[1]
            else:
                operand = ''
            operand_repr = operand if operand else '1'*OPERAND_LENGTH
            if operand_repr in CONSTS:
                operand_repr = CONSTS[operand_repr]
            command_number = bin(i)[2:].zfill(OPERAND_LENGTH)
            result_commands.append('"{}" & "{}", -- {} : {} {}'.format(opcode, operand_repr, command_number, command, operand))
    return '\n'.join(result_commands)


def main():
    print(compile(sys.argv[1]))

if __name__ == '__main__':
    main()
