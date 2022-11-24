from functools import reduce

INPUT_FILE = "day18-input"

def read_input(file):
    with open(file, "r") as fin:
        return [l.strip() for l in fin.readlines()]

def evaluate_expr(expr, plus_first):
    #print("evaluating", expr, "(plus first)" if plus_first else "")
    expr = expr.replace(' ', '')

    operands = []
    operators = []

    for c in list(expr):
        if c.isdigit():
            operands.append(int(c))
        elif c in ("+", "*", "("):
            operators.append(c)
        elif c == ")":
            nested_operators = []
            nested_operands = []
            while True:
                operator = operators.pop()
                if operator == "(":
                    break
                nested_operators.insert(0, operator)
                if len(nested_operands) == 0:
                    nested_operands.insert(0, operands.pop())
                nested_operands.insert(0, operands.pop())
            result = evaluate_simple_expr(nested_operands, nested_operators, plus_first)
            operands.append(result)

    return evaluate_simple_expr(operands, operators, plus_first)

def evaluate_simple_expr(operands, operators, plus_first):
    if (plus_first):
        i = 0
        while operators.count("+") > 0:
            if operators[i] == "+":
                operator = operators.pop(i)
                lhs = operands.pop(i)
                rhs = operands.pop(i)
                operands.insert(i, evaluate_op(operator, lhs, rhs))
            else:
                i += 1

    lhs = operands.pop(0)
    for operator in operators:
        rhs = operands.pop(0)
        lhs = evaluate_op(operator, lhs, rhs)
    
    return lhs

def evaluate_op(op, lhs, rhs):
    return lhs * rhs if op == "*" else lhs + rhs

def run_tests(plus_first):
    print("testing", "plus first" if plus_first else "in order")
    for t in [
        "1 + 2 * 3 + 4 * 5 + 6", 
        "1 + (2 * 3) + (4 * (5 + 6))",
        "2 * 3 + (4 * 5)", 
        "5 + (8 * 3 + 9 + 3 * 4 * 3)",
        "5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))", 
        "((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2"
    ]:
        print("\t{} = {}".format(t, evaluate_expr(t, plus_first)))

def run(input_file):
    exprs = read_input(input_file)
    print("part 1:", reduce(lambda total, expr: total + evaluate_expr(expr, False), exprs, 0))
    print("part 2:", reduce(lambda total, expr: total + evaluate_expr(expr, True), exprs, 0))

run_tests(False)
run_tests(True)
run(INPUT_FILE)
