# --------------------------------- CLASSES ---------------------------------
class String
	def is_i?
		/\d/ === self
	end
end

class Player
	def initialize (id, name, weapon, robot=false)
		@id = id
		@name = name
		@weapon = weapon
	end

	def index
		puts "  Your name is #{@name}."
		puts "  Your weapon is \"#{@weapon}\"."
		line_break
	end

	def id_is
		@id
	end

	def name_is
		@name
	end

	def weapon_is
		@weapon
	end
end

class Square
	def initialize(id)
		@id = id
		@contents = id
		@occupied = false
	end

	def id_is
		@id
	end

	def contents_are
		@contents
	end

	def occupied?
		@occupied
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
	response = gets.chomp.downcase

	if response.include? "y"
		true	
	else
		false
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
	response = gets.chomp.to_i

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

# •••• Grid methods ••••

def create_grid
	# Generates initial grid as an array with Squares

	grid_array = []
	9.times do |id|
		new_square = Square.new(id)
		grid_array << new_square
	end
	grid_array
end

def view_grid(arr)
	# Displays dynamic grid
	
	line_break
	puts "    ---------"

	arr.each do |i|
		current_square_index = i.instance_variable_get(:@id)

		# Create rows where appropriate
		if current_square_index == 0 || current_square_index == 3 || current_square_index == 6
			# Square.id == arr.index
			i_plus_1 = arr[ current_square_index + 1 ]
			i_plus_2 = arr[ current_square_index + 2 ]
			
			puts "    [#{i.instance_variable_get(:@contents)}][#{i_plus_1.instance_variable_get(:@contents)}][#{i_plus_2.instance_variable_get(:@contents)}]"
		end
	end
	
	puts "    ---------"
	line_break
end

def first_grid(arr)
	puts "Now, imagine a tic-tac-toe board..."
	puts "--Hit enter when you think you've got a good one."
	gets
	view_grid(arr)
	puts "...great job."
	line_break
	puts "So, when it's your turn, just select the number corresponding to the square you want to slay. I mean claim."
	puts "--Got it? Hit enter when you're ready."
	gets
end

# •••• Create player methods ••••

def create_player(id, other_player_weapon=nil, name=nil)
	# The following conditional is skipped for recursive cases where name has been defined but weapon has not; see the elsif below
	if name.nil?
		name = choose_name(id)
		line_break
	end

	weapon = choose_weapon(name)
	line_break
	
	if weapon == other_player_weapon
		puts "Holdup holdup holdup. You can't have the same weapon!"
		create_player(id, other_player_weapon, name)
	else
		Player.new(id, name, weapon)
	end
end

def choose_name(player_id)
	if player_id == 1
		puts "--What's your name?"
	else
		puts "--Player #{player_id}, what's your name?"
	end
	gets.chomp.strip.capitalize
end

def choose_weapon(player_name)
	puts "--Alright #{player_name}, choose your weapon. Any non-numeric character will do."
	response = gets.chomp.strip.slice(0)

	if response.nil?
		puts "Sorry, invisible weapons don't count."
		choose_weapon(player_name)
	elsif response.is_i?
		line_break
		puts "Nah. No numbers."
		choose_weapon(player_name)
	else
		response
	end
end

# •••• Robot methods ••••

def create_robot(player_1)
	player_1_name = player_1.instance_variable_get(:@name)
	player_1_weapon = player_1.instance_variable_get(:@weapon)

	robot = [["Turingborg", "A"], ["Lovelacetron", "A"], ["Hopperborg", "G"], ["Matzdroid", "Y"], ["#{player_1_name}tron", "ø"]].sample

	robot_name = robot[0]
	robot_weapon = robot[1]
	# Make sure weapons are duplicate
	robot_weapon = verify_weapon(robot_weapon, player_1_weapon)

	Player.new(0, robot_name, robot_weapon)
end

def verify_weapon(robot_weapon, player_1_weapon)
	if robot_weapon == player_1_weapon
		robot_weapon = ["∫", "∑", "π", "ƒ", "µ", "Ω"].sample
		verify_weapon(robot_weapon, player_1_weapon)
	else
		robot_weapon
	end
end

def robot_choice(array)
	choice = rand(9)
	if invalid_choice?(choice, array)
		robot_choice(array)
	else
		choice
	end
end

# •••• Turn methods ••••

def take_turn(player, array)
	player_id = player.instance_variable_get(:@id)
	player_name = player.instance_variable_get(:@name)
	player_weapon = player.instance_variable_get(:@weapon)
	
	
	# Find particular instance of square based on player's choice
	if player_id == 0
		choice = array[robot_choice(array)]
		puts "#{player_name}'s turn..."
	else
		puts "It's your turn, #{player_name}."
		choice = array[get_choice(array).to_i] # As psuedo code, choice = Square found by instance variable @id
	end
	
	# Updates square's instance variables
	choice.instance_variable_set(:@contents, player_weapon)
	choice.instance_variable_set(:@occupied, true)

	view_grid(array)

	if player_id == 0
		puts "#{player_name} chose square #{choice.instance_variable_get(:@id)}."
		line_break
	end
end

def get_choice(array)
	puts "--Which square do you choose?"
	choice = gets.chomp

	if invalid_choice?(choice, array)
		line_break
		puts "Sorry, that choice is invalid. Try again!"
		get_choice(array)
	else
		choice
	end
end

def invalid_choice?(choice, array)
	# The following condition handles Fixnum choices from the robot
	if choice.class == Fixnum
		choice = choice.to_s
	end

	# Various invalid choices: must be numeric between 0-8, and square cannot be occupied
	if (choice.is_i? && choice.to_i > -1 && choice.to_i < 9) && !(array[choice.to_i].instance_variable_get(:@occupied))
		false
	else
		true
	end
end

def winner?(array)
	# Assign each Square.contents to a variable
	zero = array[0].instance_variable_get(:@contents)
	one = array[1].instance_variable_get(:@contents)
	two = array[2].instance_variable_get(:@contents)
	three = array[3].instance_variable_get(:@contents)
	four = array[4].instance_variable_get(:@contents)
	five = array[5].instance_variable_get(:@contents)
	six = array[6].instance_variable_get(:@contents)
	seven = array[7].instance_variable_get(:@contents)
	eight = array[8].instance_variable_get(:@contents)

	# All possible winning combinations
	if  ( zero == one && zero == two 	) 	||
		( zero == four && zero == eight ) 	||
		( zero == three && zero == six 	)	||
		( one == four && one == seven 	)	||
		( two == four && two == six 	)	||
		( two == five && two == eight 	)	||
		( three == four && three == five)	||
		( six == seven && six == eight 	)
		
		true
	else
		false
	end
	
end

def draw?(array)
	# It's a draw unless any square is NOT occupied
	draw = true
	array.each do |square|
		if !(square.instance_variable_get(:@occupied))
			draw = false
		end
	end
	draw
end

# •••• The game itself ••••

def play_game(player)
	game_over = false

	# Select game mode
	line_break
	puts "Will you be playing with a friend or a robot?"
	puts "--Enter 1 if you need a robot to be your friend. (One-player game)"
	puts "--Enter 2 if you already have a friend. (Two-player game)"
	type_of_game = number_of_players


	if type_of_game == 1
		# One-player biz goes here
		player_1 = player
		player_2 = create_robot(player)
		line_break
	elsif type_of_game == 2
		# Two-Player game
		player_1 = player
		player_2 = create_player(2, player_1.weapon_is)

		# Take care of players with the same name
		if player_1.name_is == player_2.name_is
			player_2.instance_variable_set(:@name, "#{player_2.name_is} II")
		end
	end

	# Display player profiles
	puts "Player 1:"
	player_1.index

	if player_2.instance_variable_get(:@id) == 0
		puts "Robot:"
	else
		puts "Player 2:"
	end

	player_2.index

	# Build tic-tac-toe board
	board = create_grid
	first_grid(board)

	# Take turns
	turn_counter = 0
	while !game_over do
		# Determine whose turn it is
		if turn_counter.even?
			player = player_1
		else
			player = player_2
		end

		take_turn(player, board)
		
		if winner?(board)
			puts "...!!!"
			line_break
			puts "Congratulations, #{player.instance_variable_get(:@name)}! Your ferocious use of the \"#{player.instance_variable_get(:@weapon)}\" has lead you to victory."
			puts "--Well done. Press enter to continue."
			gets
			# If player 2 won, offer Player 1 position
			if player == player_2 && player_2.instance_variable_get(:@id) != 0
				puts "#{player.instance_variable_get(:@name)}, you have earned the right to claim the Player 1 position."
				puts "--Will you take it?"

				if get_a_yes?
					player_1 = player_2
					line_break
					puts "#{player.instance_variable_get(:@name)} is now Player One!"
					line_break
				else
					line_break
					puts "Ok. By your grace, #{player_1.instance_variable_get(:@name)} will remain Player 1."
					line_break
				end
			end
			game_over = true
		elsif draw?(board)
			puts "Well... it's a draw."
			puts "Good game, though."
			line_break
			game_over = true
		else
			turn_counter += 1
		end
	end

	if play_again?
		line_break
		puts "Awesome! Here we go #{player_1.instance_variable_get(:@name)}."
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
player_1 = create_player(1)

puts "Sweet."
ready_to_rock

play_game(player_1)