require 'pry'
require_relative './lib/pieces_classes.rb'
require_relative './lib/board_classes.rb'
require_relative './lib/io_classes.rb'


#======================================================================
file = "initial_board_pieces_positions.txt"
file2 = "pieces_movements.txt"

chess_piece_factory = ChessPieceFactory.new
io_handler = IOHandler.new
user1 = User.new({:white => "Nacho"})
user2 = User.new({:black => "Bea"})
board = Board.new(8,8, [user2, user1])


initial_pieces = io_handler.read_pieces(file)
pieces_movements_file = io_handler.read_movements(file2)

board.to_initialize_game(initial_pieces, chess_piece_factory)

i=0
while i < 20 do
	sleep(1)

	io_handler.to_print(board.x_length, board.y_length, board.board_placed)

	puts "Round: #{board.round}, Turn: #{board.turn}, Player: #{board.active_user}"
	piece_movement = gets.chomp
	movement = piece_movement.split(',')

	x_init = movement[0][0].bytes[0] - 64
	y_init = movement[0][1].to_i

	x_dest = movement[1][0].bytes[0] - 64 
	y_dest = movement[1][1].to_i

	initial_position = [x_init, y_init]
	destination_position = [x_dest, y_dest]
	
	piece_movement = [[initial_position, destination_position]]
	if (board.board_placed[initial_position].piece_color == board.valid_color)
		if board.check_list_of_movements(piece_movement)
			i+=1
		end
	else
		puts "Move your pieces"
	end
end










