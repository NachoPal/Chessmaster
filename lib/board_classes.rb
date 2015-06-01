class Board

	attr_reader :x_length
	attr_reader :y_length
	attr_reader :board_placed
	attr_reader :round
	attr_reader :turn
	attr_reader :valid_color

	def initialize(x_length, y_length, users)

		@x_length = x_length
		@y_length = y_length
		@users = users
		@board = []
		@board_placed = {}
		@log = {}
		@turn = 1
		@round = 1
		@valid_color = :white
	end

	def to_initialize_game(initial_pieces, factory)

		initial_pieces.each do |piece|
			
			piece_type = piece[0..1]
			piece_position = piece[2]
			piece_manufactered = factory.create_piece_by_type( piece_type, piece_position)
			@board << piece_manufactered
		end
		
		to_place_on_board
	end

	def active_user
		@active_user = @users[@turn%2]
		@valid_color = @active_user.color_and_name.keys[0]
		@user_name = @active_user.color_and_name.values[0]
		@user_name
	end

	def to_place_on_board

		@board.each do |piece|

			coord = piece.initial_position
			@board_placed[coord] = piece
		end
		@log[1] = @board_placed.clone
	end

	def check_list_of_movements(movements)

		movements.each do |movement|

			initial_position = movement[0]
			destination_position = movement[1]

			piece = @board_placed[initial_position]

			no_overflow = (check_overflow(destination_position))
			path_to_destination = piece.movement_allowed(destination_position)

			if(path_to_destination.class == Array)
				no_collision = check_collision(destination_position, initial_position, path_to_destination)
			else 
				no_collision = path_to_destination
			end

			puts (no_overflow && no_collision)
			if(no_overflow && no_collision)
				save_movement(initial_position, destination_position)
			end
		end
	end

	def check_overflow(destination_position)

		!(destination_position[0] > @x_length || destination_position[1] > @y_length) 
	end

	def check_collision(destination_position, initial_position, path_to_destination)
		
		piece = @board_placed[initial_position]
		destination_piece = @board_placed[destination_position]

		if(check_collision_on_the_way(path_to_destination))
				return check_collision_on_destination(piece, destination_piece)
		else 
			return false
		end			
	end

	def check_collision_on_the_way(path_to_destination)

		path_to_destination.each do |position|

			if (@board_placed[position])			
				return false 
			end
		end

		return true
	end

	def check_collision_on_destination(piece, destination_piece)

		if (destination_piece == nil)
			if(piece.class == Pawn && piece.to_kill == true)
				piece.to_kill = false
				return false
			end
			piece.has_moved = true if (piece.class == King || piece.class == Rook || piece.class == Pawn)
			return true
		elsif (destination_piece && (destination_piece.piece_color == piece.piece_color))
			return false
		else
			if(piece.class == Pawn && piece.to_kill == true)
				piece.to_kill = false
				piece.has_moved = true
				return true
			elsif(piece.class == Pawn && piece.to_kill == false)
				return false
			end
			piece.has_moved = true if (piece.class == King || piece.class == Rook)
			return true
		end
	end

	def save_movement(initial_position, destination_position)

		@board_placed[destination_position] = @board_placed[initial_position]
		@board_placed[destination_position].initial_position = destination_position
		@board_placed[destination_position].x_init = destination_position[0]
		@board_placed[destination_position].y_init = destination_position[1]
		@board_placed[initial_position] = nil
		
		@round+=1 if @turn%2 == 0
		@turn+=1
		@log[@turn] = @board_placed.clone
		binding.pry
		true
	end
end

class User

	attr_reader :color_and_name

	def initialize(color_and_name)
		
		@color_and_name = color_and_name
		@dead_pieces = []
	end
end












