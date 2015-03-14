# --------------------------------- CLASSES ---------------------------------
class String
	def is_i?
		/\d/ === self
	end
end

class Player
	def initialize (id, name, weapon)
		@id = id
		@name = name
		@weapon = weapon
	end

	def index
		puts "Player #{@id}:"
		puts "  Your name is #{@name}."
		puts "  Your weapon is a \"#{@weapon}\"."
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

	def find_by_id(id)
		# ?
	end

end
# --------------------------------- METHODS ---------------------------------
def line_break
	puts ""
end

def ready_to_rock?
	puts "--Are you ready to rock?!"
	response = gets.chomp.downcase

	if response.include? "y"
		line_break
		puts "Alrightletsdoit!"
		true
	else
		line_break
		puts "I'mma ask you again."
		ready_to_rock?
	end
end

def number_of_players
	response = gets.chomp.to_i

	if response == 1
		line_break
		puts "Working on this..."
		puts "Not ready yet..."
		puts "--So... 2 players or, 2 players?"
		number_of_players
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
	
	puts "---------"

	arr.each do |i|
		current_id = i.instance_variable_get(:@id)

		# Create rows where appropriate
		if current_id == 0 || current_id == 3 || current_id == 6
			# Square@id == arr.index
			i_plus_1 = arr[ current_id + 1 ]
			i_plus_2 = arr[ current_id + 2 ]
			
			puts "[#{i.instance_variable_get(:@contents)}][#{i_plus_1.instance_variable_get(:@contents)}][#{i_plus_2.instance_variable_get(:@contents)}]"
		end
	end

	puts "---------"
	line_break
end

def first_grid(arr)
	puts "Now, imagine a tic-tac-toe board..."
	puts "--Hit enter when you think you've got a good one."
	gets
	view_grid(arr)
	puts "...great job."
	puts "It's swell. And super easy to use: on your turn, just select the number corresponding to the square you want to slay. I mean claim."
	puts "--Got it? Hit enter if you're ready."
	gets
end

# •••• CREATE_PLAYER ••••

def create_player(id, other_players_weapon, name="")
	if name == ""
		name = choose_name(id)
		line_break
	end

	weapon = choose_weapon(name)
	line_break
	
	# Prevents Player being created without weapon, due to unsupported or duplicate weapon
	if weapon_exists?(weapon) && weapon != other_players_weapon
		Player.new(id, name, weapon)
	elsif weapon_exists?(weapon) && weapon == other_players_weapon
		puts "Holdup holdup holdup. You can't have the same weapon!"
		create_player(id, other_players_weapon, name)
	else
		create_player(id, other_players_weapon, name)
	end
end

def choose_name(id)
	puts "--Player #{id}, what is your name?"
	name = gets.chomp.capitalize
end

def choose_weapon(name)
	puts "--Alright #{name}, choose your weapon. Any non-numeric character will do."
	response = gets.chomp

	if response == "" || response == " "
		puts "Sorry, invisible weapons don't count."
		choose_weapon(name)
	else
		response = response.slice(0)
		if response.is_i?
			line_break
			puts "Nah. No numbers."
			choose_weapon(name)
		else
			weapon = response
		end
	end
end

def weapon_exists?(weapon)
	if weapon != ""
		true
	else
		false
	end
end

# •••• TAKE_TURN ••••

def take_turn(player)
	puts "It's your turn #{player.instance_variable_get(:@name)}."
	choice = get_choice
	
	puts "You choose #{choice}"
	# Select instance from choice
end

def get_choice
	puts "--Which square do you choose?"
	choice = gets.chomp

	if invalid_choice?(choice)
		line_break
		puts "Sorry, that choice is invalid. Try again!"
		get_choice
	else
		choice
	end
end

def invalid_choice?(choice)
	# Various invalid choices
	if choice.is_i? && choice.to_i > -1 && choice.to_i < 9 
		false
	else
		true
	end
end

# --------------------------------- STORY STARTS HERE ---------------------------------
line_break
puts "[**Awesome theme music**]"
line_break

puts "Hey! Welcome to tic-tac-toe."

ready_to_rock?

puts "--How many players? 1 or 2?"
type_of_game = number_of_players.to_i


# The following instance of Player creates an empty player, aids in preventing duplicates
nobody = Player.new(0, "", "")
game_over = false

# Game starts here
if type_of_game == 1
	# One-player biz goes here
elsif type_of_game == 2
	# Two-Player game
	player_1 = create_player(1, nobody.weapon_is)
	player_2 = create_player(2, player_1.weapon_is)

	# Take care of players with the same name
	if player_1.name_is == player_2.name_is
		player_2.instance_variable_set(:@name, "#{player_2.name_is} II")
	end

	# Display player profiles
	player_1.index
	player_2.index

	# Build tic-tac-toe board
	board = create_grid
	first_grid(board)

	# Take turns
	turn_counter = 0
	while !game_over do
		if turn_counter.even?
			player = player_1
		else
			player = player_2
		end
		take_turn(player)
		game_over = true
	end
end
