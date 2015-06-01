class IOHandler

	def read_pieces(file)

		initial_pieces = []
		file_data = IO.readlines(file)

		file_data.each do |piece|
			
			file_data = piece.chomp.split(',')
			file_data[0] = file_data[0].to_sym
			file_data[1] = file_data[1].to_sym
			file_data[2] = [file_data[2][0].to_i, file_data[2][1].to_i]
			initial_pieces << file_data
		end

		initial_pieces 
	end

	def to_print(x_length, y_length, board_placed)

		system "clear"
		puts ""
		piece_abbreviation = {Rook => "Rk", Knight => "Kn", Bishop => "Bs",
							  Queen => "Qn", King => "Kg", Pawn => "Pw"}

		(1..y_length).to_a.reverse.each_with_index do |y, i|	
			print (y_length - i).to_s+" |"
			(1..x_length).to_a.each do |x|	
				
				position = [x, y]
				piece_class = piece_abbreviation[board_placed[position].class]
				(piece_class != nil)?(print piece_class+"|"):(print "  |")
			end
			puts ""
			print "  "
			(1..x_length).each do
					print "---"
			end
			puts ""
		end

		print "   "

		('A'..(x_length + 64).chr).to_a.each do |x|
			print x+"  "
		end
		puts ""
	end

	def read_movements(file)

		file_data = IO.readlines(file)

		file_data.each_with_index do |movements, i|
			file_data[i] = movements.chomp.split(',')
		end

		file_data
	end
end