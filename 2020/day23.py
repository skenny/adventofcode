import time
import logging

logging.basicConfig(level=logging.INFO)

class circular_linked_list:

    def __init__(self, values):
        self.node_refs_by_value = {}

        first_node = node(values[0])
        self.node_refs_by_value[values[0]] = first_node

        self.current = first_node

        curr = self.current
        for value in values[1:]:
            new_node = node(value)
            self.insert_node(new_node, curr)
            curr = new_node

    def __repr__(self):
        this_current = self.current
        values = []
        while True:
            this_current_val = str(this_current.value)
            if this_current == self.current:
                values.append("({})".format(this_current_val))
            else:
                values.append(this_current_val)
            if (this_current.next is self.current):
                break
            this_current = this_current.next
        return " ".join(values)

    def next(self):
        self.current = self.current.next

    def insert_node(self, node, after):
        node.prev = after
        node.next = after.next
        node.next.prev = node
        after.next = node
        self.node_refs_by_value[node.value] = node

    def reattach_nodes(self, nodes, after):
        first_node = nodes[0]
        last_node = nodes[-1]

        first_node.prev = after
        last_node.next = after.next
        last_node.next.prev = last_node
        after.next = first_node

    def remove_node(self, node):
        node.prev.next = node.next
        node.next.prev = node.prev
        if self.current == node:
            self.current = node.next
        return node

    def remove_next_n_nodes(self, n):
        removed_nodes = []

        this_current = self.current
        for i in range(n):
            removed_nodes.append(this_current.next)
            this_current = this_current.next

        self.current.next = removed_nodes[-1].next
        self.current.next.prev = self.current

        return removed_nodes

    def find(self, value):
        if value in self.node_refs_by_value:
            return self.node_refs_by_value[value]
        return None

class node:

    def __init__(self, value):
        self.value = value
        self.prev = self
        self.next = self

    def __repr__(self):
        return str(self.value)

def test_circular_linked_list():
    ll = circular_linked_list([1,2,3,4,5,6,7,8,9])
    print("99?", ll.find(99))
    
    print(ll)
    for i in range(10):
        ll.next()
        print(ll)

    ll.insert_node(node(25), ll.find(4))
    print(ll)

    print(ll.remove_node(ll.current))
    print(ll)

    print(ll.remove_node(ll.find(7)))
    print(ll)

def play(cup_nums, num_turns):
    min_cup = min(cup_nums)
    max_cup = max(cup_nums)

    #logging.debug("playing with {} cups (min={}, max={})".format(len(cup_nums), min_cup, max_cup))

    cups = circular_linked_list(cup_nums)

    for turn in range(1, num_turns + 1):
        #logging.debug("-- move {} --".format(turn))
        #logging.debug("cups:  {}".format(cups))

        current_cup = cups.current
        
        next_3_nodes = cups.remove_next_n_nodes(3)
        next_3_values = [n.value for n in next_3_nodes]
        
        #logging.debug("pick up: {}".format(", ".join([str(n) for n in next_3_nodes])))

        target_cup_value = current_cup.value - 1
        while True:
            if target_cup_value < min_cup:
                target_cup_value = max_cup
            if target_cup_value in next_3_values:
                target_cup_value -= 1
                continue
            break

        #logging.debug("destination: {}\n".format(target_cup_value))

        target_cup = cups.find(target_cup_value)
        for i in range(3):
            cups.insert_node(next_3_nodes[i], target_cup)
            target_cup = next_3_nodes[i]

        cups.next()
    
    c = cups.find(1)
    cups_after_1 = []
    for i in range(8):
        c = c.next
        cups_after_1.append(str(c.value))
    
    print("-- final --")
    print("cups > 1:  {}".format(" ".join(cups_after_1)))

#test_circular_linked_list()
play([int(s) for s in list("389125467")], 10)
play([int(s) for s in list("389125467")], 100)
play([int(s) for s in list("598162734")], 100)

start = time.time()
many_cups = [int(s) for s in list("598162734")]
max_cup = max(many_cups)
for i in range(1_000_000 - max_cup):
    many_cups.append(max_cup + i + 1)
play(many_cups, 10_000_000)
print("took {} seconds".format(time.time() - start))
