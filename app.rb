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

	def weapon_is
		@weapon
	end

	def id_is
		@id
	end
end

# --------------------------------- FUNCTIONS ---------------------------------
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

def view_grid
	puts "---------"
	puts "[#{}][#{}][#{}]"
	puts "[#{}][#{}][#{}]"
	puts "[#{}][#{}][#{}]"
	puts "---------"
	line_break
end

def first_grid
	puts "Now, imagine a grid."
	puts "--(Hit enter when you've done so...)"
	gets
	view_grid
	puts "...great job."
	line_break
end


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
	puts "--Alright #{name}, choose your weapon. Any non-numerical character will do."
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

# Game starts in here
if type_of_game == 1
	# One-player biz goes here
elsif type_of_game == 2
	# Two-Player game
	player_1 = create_player(1, nobody.weapon_is)
	player_2 = create_player(2, player_1.weapon_is)

	player_1.index
	player_2.index

	first_grid
end
