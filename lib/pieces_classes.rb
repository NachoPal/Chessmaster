class ChessPieceFactory

	def create_piece_by_type(piece_type, piece_position)
		
		piece_name = piece_type[0]
		piece_color = piece_type[1]

		names_hash = {:pawn => Pawn.new(piece_color, piece_position),
		:knight => Knight.new(piece_color, piece_position),
		:bishop => Bishop.new(piece_color, piece_position),
		:rook => Rook.new(piece_color, piece_position),
		:queen => Queen.new(piece_color, piece_position),
		:king => King.new(piece_color, piece_position)}

		names_hash[piece_name]
	end
end

module RookMovement

	def rook_movement(destination_position)
		
		x_dest = destination_position[0]
		y_dest = destination_position[1]

		(x_dest == @x_init || y_dest == @y_init)
	end

	def rook_get_path_to_destination(destination_position)

		x_dest = destination_position[0]
		y_dest = destination_position[1]

		@path_to_destination = []

		if(x_dest == @x_init)		
			vertical_direction(x_dest,y_dest)
		else
			horizontal_direction(x_dest,y_dest)
		end
			@path_to_destination
	end

	def vertical_direction(x_dest,y_dest)

		if(y_dest > @y_init)		
				(@y_init+1..y_dest-1).to_a.each do |y|				
					@path_to_destination << [x_dest, y] 
				end
		else
				(y_dest+1..@y_init-1).to_a.reverse.each do |y|
					@path_to_destination << [x_dest, y]
				end
			end
	end

	def horizontal_direction(x_dest,y_dest)

		if(x_dest > @x_init)			
				(@x_init+1..x_dest-1).to_a.each do |x|		
					@path_to_destination << [x, y_dest]
				end
		else
				(x_dest+1..@x_init-1).to_a.reverse.each do |x|					
					@path_to_destination << [x, y_dest]
				end
			end		
	end
end

module BishopMovement

	def bishop_movement(destination_position)
		
		x_dest = destination_position[0]
		y_dest = destination_position[1]

		y_offset = @y_init - y_dest

		if(x_dest == @x_init + y_offset)
			true
		elsif(x_dest == @x_init - y_offset)
			true
		else false
		end
	end

	def bishop_get_path_to_destination(destination_position)

		x_dest = destination_position[0]
		y_dest = destination_position[1]

		@path_to_destination = []

		if(x_dest > @x_init)		
			east_direction(x_dest,y_dest)
		else
			west_direction(x_dest,y_dest)
		end
			@path_to_destination
	end

	def east_direction(x_dest,y_dest)

		y = @y_init

		if(y_dest > @y_init)
				(@x_init+1..x_dest-1).to_a.each do |x|		
					y+=1
					@path_to_destination << [x, y] 
				end
		else
				(@x_init+1..x_dest-1).to_a.each do |x|					
					y-=1
					@path_to_destination << [x, y]
				end
			end
	end

	def west_direction(x_dest,y_dest)
		
		if(y_dest > @y_init)			
				(x_dest+1..@x_init-1).to_a.reverse.each do |x|				
					y = @y_init+=1
					@path_to_destination << [x, y]		
				end
		else
				(x_dest+1..@x_init-1).to_a.reverse.each do |x|	
					y = @y_init-=1
					@path_to_destination << [x, y]
				end
			end		
	end
end

class ChessPiece

	attr_accessor :piece_color
	attr_accessor :initial_position
	attr_accessor :x_init
	attr_accessor :y_init

	def initialize(piece_color, initial_position)

		@piece_color = piece_color
		@initial_position = initial_position
		@x_init = @initial_position[0]
		@y_init = @initial_position[1]
	end
end

class Pawn < ChessPiece

	attr_accessor :has_moved
	attr_accessor :to_kill

	def initialize(piece_color, initial_position)

		super(piece_color, initial_position)
		@has_moved = false
		@to_kill = false
	end

	def movement_allowed(destination_position)

		x_dest = destination_position[0]
		y_dest = destination_position[1]
		y_offset = (@y_init - y_dest) 
		x_offset = (@x_init - x_dest)

		if(standar_movement(x_offset, y_offset))
			return []
		elsif(kill_movement(x_offset, y_offset))
			@to_kill = true
			return []
		elsif(first_movement(x_offset, y_offset) && @has_moved == false)
			return []
		else
			false
		end
	end

	def standar_movement(x_offset, y_offset)
		if(@piece_color == :white && x_offset == 0 && y_offset == -1 )
				true
		elsif(@piece_color == :black && x_offset == 0 && y_offset == 1 )
				true
		else false
		end
	end

	def kill_movement(x_offset, y_offset)
		if(@piece_color == :white && x_offset.abs == 1 && y_offset == -1 )
				true
		elsif(@piece_color == :black && x_offset.abs == 1 && y_offset == 1 )
				true
		else false
		end
	end

	def first_movement(x_offset, y_offset)
		if(@piece_color == :white && x_offset == 0 && y_offset == -2 )
				true
		elsif(@piece_color == :black && x_offset == 0 && y_offset == 2 )
				true
		else false
		end
	end    
end

class Knight < ChessPiece

	include BishopMovement
	include RookMovement

	def movement_allowed(destination_position)
		
		x_dest = destination_position[0]
		y_dest = destination_position[1]
		x_offset = (x_dest - @x_init).abs
		y_offset = (y_dest - @y_init).abs
		
		if !(bishop_movement(destination_position) || rook_movement(destination_position))
			if (y_offset <= 2 && x_offset <= 2)
				return []
			else false
			end
		else false
		end
	end
end

class Bishop < ChessPiece

	include BishopMovement

	def movement_allowed(destination_position)
		if(bishop_movement(destination_position))
			bishop_get_path_to_destination(destination_position)
		else false
		end
	end
end

class Rook < ChessPiece

	include RookMovement

	def initialize(piece_color, initial_position)
		super(piece_color, initial_position)
		@has_moved = false
	end

	def movement_allowed(destination_position)
		if(rook_movement(destination_position))
			rook_get_path_to_destination(destination_position)
		else false
		end		
	end
end 

class Queen < ChessPiece

	include BishopMovement
	include RookMovement

	def movement_allowed(destination_position)

		if(rook_movement(destination_position))
			rook_get_path_to_destination(destination_position)

		elsif(bishop_movement(destination_position))		
			bishop_get_path_to_destination(destination_position)
		else false
		end	
	end
end

class King < ChessPiece

	include BishopMovement
	include RookMovement

	attr_accessor :has_moved

	def initialize(piece_color, initial_position)

		super(piece_color, initial_position)
		@has_moved = false
	end

	def movement_allowed(destination_position)

		x_dest = destination_position[0]
		y_dest = destination_position[1]

		if((@x_init - x_dest).abs < 2 && (@y_init - y_dest).abs < 2)
			if(bishop_movement(destination_position) || rook_movement(destination_position))
				return []
			end
		else
			false
		end
	end
end   