# Function to print the game board.
def print_board(board)
  puts "-------------"
  (0..2).each do |i|
    print "| "
    (0..2).each do |j|
      position = i * 3 + j
      print "#{position + 1} | " if board[position] == " "
      print "#{board[position]} | " if board[position] != " "
      end
      puts "\n-------------"
    end
  end
  
  # Function to check if someone has won the game.
  def check_win(board, player)
    # Possible winning combinations.
    wins = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
  
    wins.each do |win|
      if board[win[0]] == board[win[1]] && board[win[1]] == board[win[2]] && board[win[0]] == player
        return true
      end
    end
  
    false
  end
  
  # Function to check if the game has ended in a draw.
  def check_draw(board)
    !board.include?(" ")
  end
  
  # Function to generate possible moves.
  def generate_moves(board)
    moves = []
    (0..8).each do |i|
      moves << i + 1 if board[i] == " "
    end
    moves
  end
  
  # Function for the Minimax algorithm with alpha-beta pruning.
  def minimax(board, depth, maximizing_player, alpha, beta)
    # Check if the game has ended.
    if check_win(board, "X")
      return -1
    elsif check_win(board, "O")
      return 1
    elsif check_draw(board)
      return 0
    end
  
    if maximizing_player
      max_eval = -Float::INFINITY
      generate_moves(board).each do |move|
        board[move - 1] = "O"
        eval = minimax(board, depth + 1, false, alpha, beta)
        board[move - 1] = " "
        max_eval = [max_eval, eval].max
        alpha = [alpha, eval].max
        break if beta <= alpha
      end
      max_eval
    else
      min_eval = Float::INFINITY
      generate_moves(board).each do |move|
        board[move - 1] = "X"
        eval = minimax(board, depth + 1, true, alpha, beta)
        board[move - 1] = " "
        min_eval = [min_eval, eval].min
        beta = [beta, eval].min
        break if beta <= alpha
      end
      min_eval
    end
  end
  
  # Function for the AI's move using the Minimax algorithm with alpha-beta pruning.
  def make_ai_move(board)
    best_eval = -Float::INFINITY
    best_move = nil
    alpha = -Float::INFINITY
    beta = Float::INFINITY
    generate_moves(board).each do |move|
      board[move - 1] = "O"
      eval = minimax(board, 0, false, alpha, beta)
      board[move - 1] = " "
      if eval > best_eval
        best_eval = eval
        best_move = move
      end
    end
    board[best_move - 1] = "O"
  end
  
  # Function for player's move.
  def make_player_move(board)
    while true
      print "Enter the position (1-9): "
      move = gets.chomp.to_i
      if move >= 1 && move <= 9
        if board[move - 1] == " "
          board[move - 1] = "X"
          break
        else
          puts "Invalid position. Please try again."
        end
      else
        puts "Invalid position. Enter a number from 1 to 9."
      end
    end
  end
  
  # Main function of the game.
  def play_game
    player_score = 0
    ai_score = 0
  
    loop do
      board = Array.new(9, " ")
      current_player = "X"
  
      loop do
        system("clear") || system("cls")
        print_board(board)
  
        if current_player == "X"
          make_player_move(board)
        else
          make_ai_move(board)
        end
  
        if check_win(board, current_player)
          system("clear") || system("cls")
          print_board(board)
          puts "The player #{current_player} win!"
          if current_player == "X"
            player_score += 1
          else
            ai_score += 1
          end
          puts "Score: Player #{player_score} - #{ai_score} AI"
          break
        elsif check_draw(board)
          system("clear") || system("cls")
          print_board(board)
          puts "The game ends in a draw!"
          puts "Score: Player #{player_score} - #{ai_score} AI"
          break
        end
  
        current_player = current_player == "X" ? "O" : "X"
      end
  
      puts
      loop do
        print "Do you want to play again? (y/n): "
        play_again = gets.chomp.downcase
        if play_again == "y"
          break
        elsif play_again == "n"
          return
        else
          puts "Invalid option. Enter 'y' to play again or 'n' to quit."
        end
      end
    end
  end
  
  # Start the game
  play_game
  