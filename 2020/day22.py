import time

def read_input(file):
    player1_cards = []
    player2_cards = []
    working_array = None
    with open(file, "r") as fin:
        for l in fin.readlines():
            l = l.strip()
            if l == "Player 1:":
                working_array = player1_cards
            elif l == "Player 2:":
                working_array = player2_cards
            elif l.isdigit():
                working_array.append(int(l))
    return (player1_cards, player2_cards)

def play(player1_cards, player2_cards, recursive_combat_enabled):
    player1_cards_copy = player1_cards.copy()
    player2_cards_copy = player2_cards.copy()

    winner, winning_cards = play_game(1, player1_cards_copy, player2_cards_copy, recursive_combat_enabled)

    #print("\n== Post-game results ==")
    #print("Winner's deck: {}\n".format(", ".join(str(c) for c in winning_cards)))
    #print("Player 2's deck: {}".format(", ".join(str(c) for c in player2_cards)))

    score = 0
    for i, card in enumerate(reversed(winning_cards)):
        score += (i + 1) * card
    return score

def play_game(game_num, player1_cards, player2_cards, recursive_combat_enabled):
    prev_rounds = {}
    round_num = 0
    winner = None

    #print("\n=== Game {} ===\n".format(game_num))

    while len(player1_cards) > 0 and len(player2_cards) > 0:
        round_num += 1

        if recursive_combat_enabled:
            round_state = str([player1_cards, player2_cards])
            if round_state in prev_rounds:
                #print("Deck state repeats previous round, instant win for player 1!")
                return (1, player1_cards)
            prev_rounds[round_state] = True

        #print("-- Round {} (Game {}) --".format(round_num, game_num))
        #print("Player 1's deck: {}".format(", ".join(str(c) for c in player1_cards)))
        #print("Player 2's deck: {}".format(", ".join(str(c) for c in player2_cards)))

        p1 = player1_cards.pop(0)
        p2 = player2_cards.pop(0)

        #print("Player 1 plays: {}".format(p1))
        #print("Player 2 plays: {}".format(p2))

        round_winner = None
        if recursive_combat_enabled and p1 <= len(player1_cards) and p2 <= len(player2_cards):
            #print("Playing a sub-game to determine the winner...")
            sub_game_winner, sub_game_winning_cards = play_game(game_num + 1, player1_cards[:p1], player2_cards[:p2], True)
            #print("The winner of game {} is player {}!".format(game_num + 1, sub_game_winner))
            round_winner = sub_game_winner
        else:
            round_winner = 1 if p1 > p2 else 2

        #print("Player {} wins round {} of game {}!\n".format(round_winner, round_num, game_num))
        if round_winner == 1:
            player1_cards.append(p1)
            player1_cards.append(p2)
        else:
            player2_cards.append(p2)
            player2_cards.append(p1)

    if len(player1_cards) > 0:
        return (1, player1_cards)
    return (2, player2_cards)

def run(label, input_file):
    player1_cards, player2_cards = read_input(input_file)
    start1 = time.time()
    print("{} 1: {} ({}s)".format(label, play(player1_cards, player2_cards, False), time.time() - start1))
    start2 = time.time()
    print("{} 2: {} ({}s)".format(label, play(player1_cards, player2_cards, True), time.time() - start2))

run("test", "day22-input-test")
run("part", "day22-input")
