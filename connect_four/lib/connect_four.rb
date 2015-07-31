class ConnectFour

  attr_accessor :player1, :player2, :current_player, :board

  def initialize
    black = "\u2687".encode('utf-8')
    white = "\u2688".encode('utf-8')
    @player1 = Player.new("Player 1", black)
    @player2 = Player.new("Player 2", white)
    @current_player = player1
    @board = Board.new
  end

  def start_game
    display_intro
    game_turn
  end

  def game_turn
    until @board.board_full? || @board.four_in_a_row?(@current_player.color)
      board.display_board
      move = get_player_input
      @board.place_piece(move, @current_player.color)
      if @board.board_full?
        board.display_board
        puts "The board is full! Tie game."
        if play_again?
          new_game
        else
          exit
        end
      elsif @board.four_in_a_row?(@current_player.color)
        board.display_board
        puts "Congratulations, #{current_player.name}! You win!"
        if play_again?
          new_game
        else
          exit
        end
      end
      switch_players
    end
  end

  def display_intro
    puts "Welcome to Connect Four!"
    puts "#{player1.name} will be #{player1.color} and #{player2.name} will be #{player2.color}."
  end

  def switch_players
    @current_player == @player1 ? @current_player = @player2 : @current_player = @player1
  end

  def get_player_input
    move = nil
    until (0..6).include?(move) && @board.space_open?(move)
      print "#{@current_player.name}, please enter a placement column (1-7). "
      move = gets.to_i - 1
      if !(0..6).include?(move)
        puts "That is not a valid entry.  Please enter a number between 1 and 7."
      elsif !@board.space_open?(move)
        puts "That column is already full.  Please try again."
      end
    end
    move
  end

  def play_again?
    print "Do you want to play again? "
    entry = gets.downcase
    if entry.include? "y"
      return true
    else
      return false
    end
  end 

  def new_game
    puts ""
    game = ConnectFour.new
    game.start_game
  end
end

class Player 

  attr_accessor :name, :color

  def initialize(name, color)
    @name = name
    @color = color
  end
end

class Board

  def initialize
    @board = create_board
    @empty_square = "_"
  end

  def create_board
    board = []
    6.times do 
      board.push(["_", "_", "_", "_", "_", "_", "_"])
    end
    board
  end

  def display_board
    puts ""
    @board.reverse.each do |row|
      print  "| #{row.join(' | ')} |"
      puts " "
    end
     puts ""
     print "  #{[1,2,3,4,5,6,7].join("   ")}" 
     puts ""
     puts ""
     @board
  end

  # Returns false when a column is full (@board[5] is the top column position.)
  def space_open?(move)
     @board[5][move] == @empty_square ? true : false
  end

  def board_full?
    @board.each do |i|
      if i.include?(@empty_square)
        return false
      end
    end
    return true
  end

  def place_piece(move, color)
    count = 0
    while count < 6
      if @board[count][move] != @empty_square
        count += 1
      else
        return @board[count][move] = color
      end
    end
  end

  def check(row, space)
    @board[row][space]
  end

  def four_in_a_row?(color)
    index = 0
    vertical = 0
    diagonal_right = 0
    diagonal_left = 0
    # Checks for horizontal wins.
    @board.each do |row|
      if row.join.match("#{color * 4}")
        return true
      end
    end
    # Iterates through each space in the board.  When a piece that matches the
    # current player's color is found, the method goes through a series of if
    # statements which check for subsequent pieces 3 spaces above this piece.
    # If a piece is found in the correct position, a counter increases by one.
    @board.each_with_index do |row, column|
      row.each_with_index do |item, ind|
        if item == color
          index = ind
          # Checks for vertical wins.
          if (column + 1).between?(0, 5) && item == @board[column + 1][index]            
            vertical = 1
            if (column + 2).between?(0, 5) && item == @board[column + 2][index]  
              vertical = 2
              if (column + 3).between?(0, 5) && item == @board[column + 3][index]
                vertical = 3
              end
            end
          end
          # Checks for diagonally right wins.
          if (column + 1).between?(0, 5) && item == @board[column + 1][index + 1] 
            diagonal_right = 1
            if (column + 2).between?(0, 5) && item == @board[column + 2][index + 2] 
              diagonal_right = 2
              if (column + 3).between?(0, 5) && item == @board[column + 3][index + 3]
                diagonal_right = 3
              end
            end
          end
          # Checks for diagonally left wins.
          if (column + 1).between?(0, 5) && item == @board[column + 1][index - 1] 
            diagonal_left = 1 
            if (column + 2).between?(0, 5) && item == @board[column + 2][index - 2] 
              diagonal_left = 2
              if (column + 3).between?(0, 5) && item == @board[column + 3][index - 3] 
                diagonal_left = 3
              end
            end
          end
        end
        # When any counter equals 3, it means four pieces have been found in a row.
        if vertical == 3 || diagonal_right == 3 || diagonal_left == 3
          return true
        end
      end
    end
    false
  end
end

game = ConnectFour.new
game.start_game