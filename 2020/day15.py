import time

def play(numbers, stop_count):
    start_time = time.time()

    number_turns = {}
    last_number_spoken = None

    for i in range(stop_count):
        number_spoken = None

        if i < len(numbers):
            number_spoken = numbers[i]
        else:
            turns_read = number_turns[last_number_spoken]
            if len(turns_read) == 1:
                number_spoken = 0
            else:
                number_spoken = turns_read[-1] - turns_read[-2]

        number_turns.setdefault(number_spoken, []).append(i)
        last_number_spoken = number_spoken

        if i % 1000000 == 0:
            print("on turn", i, "the number spoken was", last_number_spoken)

    print("took", time.time() - start_time, "seconds")
    return last_number_spoken

print("test [0,3,6]; expecting 436, got", play([0, 3, 6], 2020))
print("test [1,3,2]; expecting 1, got", play([1, 3, 2], 2020))
print("test [2,1,3]; expecting 10, got", play([2, 1, 3], 2020))
print("test [1,2,3]; expecting 27, got", play([1, 2, 3], 2020))
print("test [2,3,1]; expecting 78, got", play([2, 3, 1], 2020))
print("test [3,2,1]; expecting 438, got", play([3, 2, 1], 2020))
print("test [3,1,2]; expecting 1836, got", play([3, 1, 2], 2020))

print("part 1", play([6,13,1,15,2,0], 2020))
print("part 2", play([6,13,1,15,2,0], 30000000))