import os

# Function to print the game board.
def printBoard(board):
    print("-------------")
    for i in range(3):
        print("|", end=" ")
        for j in range(3):
            print(board[i*3+j], "|", end=" ")
        print("\n-------------")

# Function to check if someone has won the game.
def checkWin(board, player):
    # Possible winning combinations.
    wins = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]

    for win in wins:
        if board[win[0]] == board[win[1]] == board[win[2]] == player:
            return True

    return False

# Function to check if the game has ended in a draw.
def checkDraw(board):
    return " " not in board

# Function to generate possible moves.
def generateMoves(board):
    return [i+1 for i in range(9) if board[i] == " "]

# Minimax algorithm with alpha-beta pruning.
def minimax(board, depth, maximizingPlayer, alpha, beta):
    # Check if the game has ended.
    if checkWin(board, "X"):
        return -1
    elif checkWin(board, "O"):
        return 1
    elif checkDraw(board):
        return 0

    if maximizingPlayer:
        maxEval = float("-inf")
        for move in generateMoves(board):
            board[move-1] = "O"
            eval = minimax(board, depth + 1, False, alpha, beta)
            board[move-1] = " "
            maxEval = max(maxEval, eval)
            alpha = max(alpha, eval)
            if beta <= alpha:
                break
        return maxEval
    else:
        minEval = float("inf")
        for move in generateMoves(board):
            board[move-1] = "X"
            eval = minimax(board, depth + 1, True, alpha, beta)
            board[move-1] = " "
            minEval = min(minEval, eval)
            beta = min(beta, eval)
            if beta <= alpha:
                break
        return minEval

# Function for the AI's move using the Minimax algorithm with alpha-beta pruning.
def makeAIMove(board):
    bestEval = float("-inf")
    bestMove = None
    alpha = float("-inf")
    beta = float("inf")
    for move in generateMoves(board):
        board[move-1] = "O"
        eval = minimax(board, 0, False, alpha, beta)
        board[move-1] = " "
        if eval > bestEval:
            bestEval = eval
            bestMove = move
    board[bestMove-1] = "O"

# Function for player's move.
def makePlayerMove(board):
    while True:
        try:
            move = int(input("Enter the position. (1-9): "))
            if move >= 1 and move <= 9:
                if board[move-1] == " ":
                    board[move-1] = "X"
                    break
                else:
                    print("Invalid position. Please try again.")
            else:
                print("Invalid position. Enter a number from 1 to 9.")
        except ValueError:
            print("Invalid input. Enter a number from 1 to 9.")

# Main function of the game.
def playGame():
    player_score = 0
    ai_score = 0

    while True:
        board = [" "] * 9
        currentPlayer = "X"

        while True:
            os.system("cls" if os.name == "nt" else "clear")
            printBoard([str(i) if x == " " else x for i, x in enumerate(board, 1)])

            if currentPlayer == "X":
                makePlayerMove(board)
            else:
                makeAIMove(board)

            if checkWin(board, currentPlayer):
                os.system("cls" if os.name == "nt" else "clear")
                printBoard([str(i) if x == " " else x for i, x in enumerate(board, 1)])
                print("The player", currentPlayer, "win!")
                if currentPlayer == "X":
                    player_score += 1
                else:
                    ai_score += 1
                print("Score: Player", player_score, "-", ai_score, "AI")
                break
            elif checkDraw(board):
                os.system("cls" if os.name == "nt" else "clear")
                printBoard([str(i) if x == " " else x for i, x in enumerate(board, 1)])
                print("The game ends in a draw!")
                print("Score: Player", player_score, "-", ai_score, "AI")
                break

            currentPlayer = "O" if currentPlayer == "X" else "X"

        while True:
            play_again = input("Do you want to play again? (y/n): ")
            if play_again.lower() == "y":
                break
            elif play_again.lower() == "n":
                return
            else:
                print("Invalid input. Enter 'y' to play again or 'n' to quit.")

# Start the game
playGame()
