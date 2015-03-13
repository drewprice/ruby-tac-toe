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
	line_break
	puts "---------"
	puts "[#{}][#{}][#{}]"
	puts "[#{}][#{}][#{}]"
	puts "[#{}][#{}][#{}]"
	puts "---------"
	line_break
end

def first_grid
	puts "Now, imagine a grid..."
	view_grid
	puts "...great job."
end

def create_player(id)
	name = choose_name(id)
	line_break

	weapon = choose_weapon(name)
	line_break
	
	Player.new(id, name, weapon)
end

def choose_name(id)
	puts "--Player #{id}, what is your name?"
	name = gets.chomp.capitalize
end

def choose_weapon(name)
	puts "--Alright #{name}, choose your weapon. Any non-numerical character will do."
	weapon = gets.chomp.slice(0)

	if weapon.is_i?
		puts "Nah. No numbers."
		choose_weapon(name)
	elsif weapon == "" || weapon == " "
		puts "Sorry, invisible weapons don't count."
		choose_weapon(name)
	end

	weapon
end

# --------------------------------- STORY STARTS HERE ---------------------------------
line_break
puts "[**Awesome theme music**]"
line_break

puts "Hey! Welcome to tic-tac-toe."

ready_to_rock?

puts "--How many players? 1 or 2?"
type_of_game = number_of_players.to_i


if type_of_game == 1
	# One-player biz goes here
elsif type_of_game == 2
	# Two-Player game
	create_player(1)
	Player.all
end
