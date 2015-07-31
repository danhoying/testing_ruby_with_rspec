require './lib/tic_tac_toe'

describe "TicTacToe Game" do

  let(:game) { TicTacToe.new }
  let(:player1) { Player.new("Player 1", 'X') }
  let(:player2) { Player.new("Player 2", 'O') }
  let(:board) { Board.new }
  let(:winner) { nil }
  let(:current_player) { player2 }

  describe "TicTacToe" do

    context "#initialize" do
      it "displays instructions and board" do
        expect(board.instructions)
        expect(board.display_board)
      end
    end

    context "#start_game" do
      it "sets current player to player 1" do
        expect(game.swap_players) == player1
      end
    end

    context "#take_turn" do
      it "checks for a winner" do
        board.board = [" ", "O", "O", " ", "O", "O", "O", "O", "O"]
        expect(board.check(6)).to eql 'O'
        expect(board.check(7)).to eql 'O'
        expect(board.check(8)).to eql 'O'
        expect(game.is_winner?) == true
      end
    end
  end

  describe "Player" do

    context "#initialize" do
      it "intializes player objects" do
        expect(player1).to be_an_instance_of Player
        expect(player2).to be_an_instance_of Player
      end

      it "intializes player name and symbol" do
        expect(player1.name).to eql "Player 1"
        expect(player2.name).to eql "Player 2"
        expect(player1.symbol).to eql 'X'
        expect(player2.symbol).to eql 'O'
      end
    end
  end

  describe "Board" do

    context "#initialize" do
      it "initializes the game board" do
        expect(board).to be_an_instance_of Board
      end

      it "intializes an empty board" do
        expect(board) == [" ", " ", " ", " ", " ", " ", " ", " ", " "]
      end
    end

    context "#check symbol placement on board" do
      it "places the correct symbol" do
        expect(board.place_symbol(2, 'X')).to eql 'X'
        expect(board.place_symbol(2, 'O')).to eql 'O'
      end

      it "doesn't place on an already taken square" do
        board.board = [" ", "X", "X", " ", "X", "X", "X", "X", "X"]
        expect(board.space_open?(2)).to eql false
        expect(board.space_open?(3)).to eql true
      end

      it "recognizes when the board is full" do
        board.board = ["X", "O", "X", "O", "X", "O", "O", "O", "X"]
        expect(board.board_full?).to eql true
        board.board = [" ", "X", "X", " ", "X", "X", "X", "X", "X"]
        expect(board.board_full?).to eql false
      end
    end
  end
end