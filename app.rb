# --------------------------------- CLASSES ---------------------------------
class String
	def is_i?
		/\d/ === self
	end
end

class Game
	# Game methods & variables...
	# Possibly some of these? Not sure yet...
	# @player_1
	# @player_2
	# @game_board

	# misc methods
	# play_game
	# grid methods
	# turn methods
	# robot methods
end

class Player
	attr_accessor :name, :weapon, :robot

	def initialize (name, weapon, robot=false)
		@name = name
		@weapon = weapon
		@robot = robot
	end

	def index
		puts "  Your name is #{@name}."
		puts "  Your weapon is \"#{@weapon}\"."
		line_break
	end
end

class Square
	attr_accessor :id, :contents, :occupied

	def initialize(id)
		@id = id
		@contents = id
		@occupied = false
	end
end

# --------------------------------- METHODS ---------------------------------
# •••• Misc methods ••••

def line_break
	puts ""
end

def cue_music(cue="start")
	line_break
	if cue == "stop"
		puts "[**Awesome theme music fades**]"
	else
		puts "[**Awesome theme music**]"
	end
	line_break
end

def get_a_yes?
	response = gets.chomp.strip.downcase

	if response.include? "y"
		true	
	elsif response.include? "n"
		false
	else
		line_break
		puts "Sorry..."
		puts "--Yes or no?"
		get_a_yes?
	end
end

def ready_to_rock
	puts "--Are you ready to rock?!"
	
	if get_a_yes?
		line_break
		puts "Alrightletsdoit!"
	else
		line_break
		puts "I'mma ask you again."
		ready_to_rock
	end
end

def number_of_players
	response = gets.chomp.strip.to_i

	if response == 1
		line_break
		puts "Awesome!"
		1
	elsif response == 2
		line_break
		puts "Perfect!"
		2
	else
		line_break
		puts "--So... 1 or 2?"
		number_of_players
	end
end

def play_again?
	puts "--Would you like to play again?"

	if get_a_yes?
		line_break
		true
	else
		false
	end
end

def visible_response?(string)
	if string.nil? || string.empty?
		false
	else
		true
	end
end

# •••• Grid methods ••••

def create_game_board
	# Generates initial board as an array of Squares, where square.id == array.index[square]
	board_array = []
	9.times do |id|
		new_square = Square.new(id)
		board_array << new_square
	end
	board_array
end

def view_game_board(arr)
	# Displays dynamic board via the array generated in create_game_board
	line_break
	puts "    ---------"

	arr.each do |square|
		current_index = square.id

		# Display rows appropriately
		if current_index == 0 || current_index == 3 || current_index == 6
			square_at_index_plus_1 = arr[ current_index + 1 ]
			square_at_index_plus_2 = arr[ current_index + 2 ]
			
			puts "    [#{square.contents}][#{square_at_index_plus_1.contents}][#{square_at_index_plus_2.contents}]"
		end
	end
	
	puts "    ---------"
	line_break
end

def first_view(game_board)
	puts "Now, imagine a tic-tac-toe game board..."
	puts "--Hit enter when you think you've got a good one."
	gets

	
	view_game_board(game_board)
	
	puts "...great job."
	line_break
	
	puts "So, when it's your turn, just select the number corresponding to the square you want to slay. I mean claim."
	puts "--Got it? Hit enter when you're ready."
	gets
end

# •••• Create player methods ••••

def create_player(name, other_player_weapon=nil)


	weapon = choose_weapon(name)
	line_break
	
	if weapon == other_player_weapon
		puts "Holdup holdup holdup. You can't have the same weapon!"
		create_player(name, other_player_weapon)
	else
		Player.new(name, weapon)
	end
end

def choose_name
	name = gets.chomp.strip.capitalize
	if !(visible_response?(name))
		puts "Sorry, invisible names don't fly 'round here."
		puts "--Try agin. What's your name?"
		choose_name
	else
		line_break
		name
	end
end

def choose_weapon(player_name)
	puts "--Alright #{player_name}, choose your weapon. Any non-numeric character will do."
	weapon = gets.chomp.strip.slice(0)

	if !(visible_response?(weapon))
		puts "Sorry, no invisible weapons."
		choose_weapon(player_name)
	elsif weapon.is_i?
		line_break
		puts "Nah. No numbers."
		choose_weapon(player_name)
	else
		weapon
	end
end

# •••• Robot methods ••••

def create_robot(player_1)
	robot = [["Turingborg", "A"], ["Lovelacetron", "A"], ["Hopperborg", "G"], ["Matzdroid", "Y"], ["#{player_1.name}tron", "X"]].sample

	robot_name = robot[0]
	robot_weapon = robot[1]
	# Make sure weapons aren't duplicate
	robot_weapon = verify_weapon(robot_weapon, player_1.weapon)

	Player.new(robot_name, robot_weapon, robot=true)
end

def verify_weapon(robot_weapon, player_1_weapon)
	if robot_weapon == player_1_weapon
		robot_weapon = ["∫", "∑", "π", "ƒ", "µ", "Ω"].sample
		verify_weapon(robot_weapon, player_1_weapon)
	else
		robot_weapon
	end
end

def robot_choice(game_board)
	# if # Robot is in a winning position
	# 	choice = # Go for the win
	# elsif # Player 1 is in a winning position
	# 	choice = # Block player 1
	# else
	# 	choice = rand(9)
	# end

	choice = rand(9)

	if valid_choice?(choice, game_board)
		choice
	else
		robot_choice(game_board)
	end
end

# •••• Turn methods ••••

def take_turn(player, game_board)
	if player.robot
		puts "Robot's turn..."
		chosen_square = game_board[robot_choice(game_board)]
	else
		puts "It's your turn, #{player.name}."
		chosen_square = game_board[get_choice(game_board)]
	end
	
	# Updates square's instance variables
	chosen_square.contents = player.weapon
	chosen_square.occupied = true

	view_game_board(game_board)
	puts "#{player.name} chose square #{chosen_square.id}."
end

def get_choice(game_board)
	puts "--Which square do you choose?"
	choice = gets.chomp.strip

	if !(choice.is_i?) || !(valid_choice?(choice, game_board))
		line_break
		puts "Sorry, that choice is invalid. Try again!"
		get_choice(game_board)
	else
		choice.to_i
	end
end

def valid_choice?(choice, game_board)
	if choice.class == String
		choice = choice.to_i
	end
	# Various invalid choices: must be numeric between 0-8, and square cannot be occupied
	if (choice >= 0 && choice <= 8) && !(game_board[choice].occupied)
		true
	else
		false
	end
end

def winner?(game_board)
	# Assign each Square.contents to a variable
	zero = game_board[0].contents
	one = game_board[1].contents
	two = game_board[2].contents
	three = game_board[3].contents
	four = game_board[4].contents
	five = game_board[5].contents
	six = game_board[6].contents
	seven = game_board[7].contents
	eight = game_board[8].contents

	# All possible winning combinations
	if  ( zero == one && zero == two 	)||
		( zero == four && zero == eight	)||
		( zero == three && zero == six 	)||
		( one == four && one == seven 	)||
		( two == four && two == six 	)||
		( two == five && two == eight	)||
		( three == four && three == five)||
		( six == seven && six == eight 	)
		true
	else
		false
	end
	
end

def winning_position?(game_board)
	zero = game_board[0].contents
	one = game_board[1].contents
	two = game_board[2].contents
	three = game_board[3].contents
	four = game_board[4].contents
	five = game_board[5].contents
	six = game_board[6].contents
	seven = game_board[7].contents
	eight = game_board[8].contents

	zero_is_occupied = game_board[0].occupied
	one_is_occupied = game_board[1].occupied
	two_is_occupied = game_board[2].occupied
	three_is_occupied = game_board[3].occupied
	four_is_occupied = game_board[4].occupied
	five_is_occupied = game_board[5].occupied
	six_is_occupied = game_board[6].occupied
	seven_is_occupied = game_board[7].occupied
	eight_is_occupied = game_board[8].occupied


	# [0][1][2]
	# [3][4][5]
	# [6][7][8]


	if 	( zero == one 	 && !two_is_occupied 	) ||
		( zero == four 	 && !eight_is_occupied 	) ||
		( zero == three  && !six_is_occupied 	) ||
		( one == two 	 && !zero_is_occupied 	) ||
		( one == four 	 && !seven_is_occupied 	) ||
		( two == four  	 && !six_is_occupied 	) ||
		( two == five 	 && !eight_is_occupied 	) ||
		( three == six 	 && !zero_is_occupied 	) ||
		( three == four  && !five_is_occupied 	) ||
		( four == five 	 && !three_is_occupied 	) ||
		( four == six	 && !two_is_occupied 	) ||
		( four == seven  && !one_is_occupied 	) ||
		( four == eight  && !zero_is_occupied 	) ||
		( five == eight  && !two_is_occupied 	) ||
		( six == seven	 && !eight_is_occupied 	) ||
		( seven == eight && !six_is_occupied 	)
		true
	else
		false
	end
end

# •••• The game itself ••••

def play_game(player_1)
	game_over = false

	# --- Select game mode ---
	line_break
	puts "Will you be playing with a friend or a robot?"
	puts "--Enter 1 if you need a robot to be your friend. (One-player game)"
	puts "--Enter 2 if you already have a friend. (Two-player game)"
	type_of_game = number_of_players

	if type_of_game == 1
		player_2 = create_robot(player_1)
		line_break
	else
		# Two-Player game
		puts "--Player 2, what's your name?"
		player_2 = create_player(choose_name, player_1.weapon)

		# Take care of players with the same name
		if player_1.name == player_2.name
			player_2.name = "#{player_2.name} II"
		end
	end

	# --- Display player profiles ---
	puts "Player 1:"
	player_1.index

	puts player_2.robot ? "Robot:" : "Player 2:"
	player_2.index

	# --- Build tic-tac-toe game board ---
	game_board = create_game_board
	first_view(game_board)

	# --- Take turns ---
	turn_counter = 0
	while !game_over do

		# -- Determine whose turn it is --
		player = turn_counter.even? ? player_1 : player_2

		take_turn(player, game_board)

		# Check for winner after 3 turns by player_1
		if turn_counter > 3
			if winner?(game_board)

				puts "...!!!"
				line_break
				
				puts "Congratulations, #{player.name}! Your ferocious use of the \"#{player.weapon}\" has lead you to victory."
				puts "--Well done. Press enter to continue."
				gets
				
				# - If player 2 won, offer position of Player 1 -
				if player == player_2 && !(player_2.robot)
					puts "#{player.name}, you have earned the right to claim the Player 1 position."
					puts "--Will you take it?"

					if get_a_yes?
						player_1 = player_2
						line_break
						puts "#{player.name} is now Player One!"
						line_break
					else
						line_break
						puts "Ok. By your grace, #{player_1.name} will remain Player 1."
						line_break
					end
				end

				game_over = true
				break
			end
		end

		turn_counter += 1

		# Check for a draw
		if turn_counter > 6
			if !winning_position?(game_board)
				puts "Well... it's a draw."
				puts "Good game, though."
				line_break
				game_over = true
			end
		end
	end

	if play_again?
		line_break
		puts "Awesome! Here we go #{player_1.name}."
		play_game(player_1)
	else
		line_break
		puts "Ok. Thanks for playing!"
		cue_music("stop")
	end	
end

# --------------------------------- STORY STARTS HERE ---------------------------------
cue_music

puts "Hi! Welcome to tic-tac-toe."

# Create first player
puts "--What is your name?"
player_1 = create_player(choose_name)

puts "Sweet."
ready_to_rock

play_game(player_1)