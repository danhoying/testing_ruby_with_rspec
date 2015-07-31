require './lib/connect_four'

describe "ConnectFour" do

  black = "\u2687".encode('utf-8')
  white = "\u2688".encode('utf-8')

  let(:game) { ConnectFour.new }

  context "#start_game" do
    it "displays a welcome message" do
      expect(game.display_intro)
    end

    it "sets the current player to player1" do
      expect(game.current_player).to eql game.player1
    end
  end

  context "#game_turn" do
    it "switches players after each turn" do
      expect(game.current_player).to eql game.player1
      game.switch_players
      expect(game.current_player).to eql game.player2
    end

    it "gets the player's input" do
      allow(game).to receive(:gets).and_return('2')
      expect(game.get_player_input).to eql 1
    end
  end

  context "game over" do
    it "asks the player to play another game" do
      allow(game).to receive(:gets).and_return('y')
      expect(game.play_again?).to be true
      allow(game).to receive(:gets).and_return('n', '4', '/n')
      expect(game.play_again?).to be false
    end
  end

  describe "Player" do

    context "#initialize" do
      it "initializes player objects" do
        expect(game.player1).to be_an_instance_of Player
        expect(game.player1).to be_an_instance_of Player
      end

      it "initializes player name and color" do
        expect(game.player1.name).to eql "Player 1"
        expect(game.player2.name).to eql "Player 2"
        expect(game.player1.color).to eql black
        expect(game.player2.color).to eql white
      end
    end
  end

  describe "Board" do

    before :each do
      @board = Board.new
    end

    context "#initialize" do
      it "initializes the board object" do
        expect(@board).to be_an_instance_of Board
      end

      it "displays the game board" do
        expect(@board).to be_truthy
        expect(@board.display_board).to eql @board.create_board
      end
    end

    context "place piece" do
      it "places the appropriate piece on the board" do
        @board.place_piece(2, black)
        expect(@board.check(0, 2)).to eql black
      end

      it "places pieces above each other, not on top" do
        @board.place_piece(2, black)
        @board.place_piece(2, white)
        expect(@board.check(0, 2)).to eql black
        expect(@board.check(1, 2)).to eql white
      end

      it "doesn't allow placement of pieces when the column is full" do
        @board.place_piece(3, black)
        @board.place_piece(3, black)
        @board.place_piece(3, black)
        expect(@board.space_open?(3)).to eql true
        @board.place_piece(3, black)
        @board.place_piece(3, black)
        @board.place_piece(3, black)
        expect(@board.space_open?(3)).to eql false
      end

      it "recognizes when the board is completely full" do 
        expect(@board.board_full?).to eql false
        6.times do 
          @board.place_piece(0, black)
          @board.place_piece(1, black)
          @board.place_piece(2, black)
          @board.place_piece(3, black)
          @board.place_piece(4, black)
          @board.place_piece(5, black)
          @board.place_piece(6, black)
        end
        expect(@board.board_full?).to eql true
      end
    end

    context "check for win" do
      it "recognizes 4 in a row vertically" do
        expect(@board.four_in_a_row?(black)).to eql false
        @board.place_piece(2, black)
        @board.place_piece(2, black)
        @board.place_piece(2, black)
        @board.place_piece(2, black)
        expect(@board.four_in_a_row?(black)).to eql true
      end

      it "doesn't count 4 pieces that are not in a row vertically" do
        @board.place_piece(2, black)
        @board.place_piece(2, black)
        @board.place_piece(2, black)
        @board.place_piece(2, white)
        @board.place_piece(2, black)
        expect(@board.four_in_a_row?(black)).to eql false
      end

      it "recognizes 4 in a row horizontally" do
        @board.place_piece(0, black)
        @board.place_piece(1, black)
        @board.place_piece(2, black)
        @board.place_piece(3, black)
        expect(@board.four_in_a_row?(black)).to eql true
      end

      it "doesn't count 4 pieces that are not in a row horizontally" do
        @board.place_piece(0, black)
        @board.place_piece(1, black)
        @board.place_piece(2, black)
        @board.place_piece(4, black)
        expect(@board.four_in_a_row?(black)).to eql false
      end

      it "recognizes 4 in a row diagonally right" do
        expect(@board.four_in_a_row?(black)).to eql false
        @board.place_piece(0, black)
        @board.place_piece(1, white)
        @board.place_piece(1, black)
        @board.place_piece(2, white)
        @board.place_piece(2, white)
        @board.place_piece(2, black)
        @board.place_piece(3, white)
        @board.place_piece(3, white)
        @board.place_piece(3, white)
        @board.place_piece(3, black)
        expect(@board.four_in_a_row?(black)).to eql true
      end

      it "recognizes 4 in a row diagonally left" do
        expect(@board.four_in_a_row?(black)).to eql false
        @board.place_piece(6, black)
        @board.place_piece(5, white)
        @board.place_piece(5, black)
        @board.place_piece(4, white)
        @board.place_piece(4, white)
        @board.place_piece(4, black)
        @board.place_piece(3, white)
        @board.place_piece(3, white)
        @board.place_piece(3, white)
        @board.place_piece(3, black)
        expect(@board.four_in_a_row?(black)).to eql true
      end
    end
  end
end