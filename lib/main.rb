module Words
  def dictionary_to_array(file_name) # reads the dictionary file at root directory
    root_directory = File.expand_path('..', __dir__)
    root_path = File.join(root_directory, file_name)
    file_contents = File.read(root_path)
    file_contents.split # returns file as an array
  end

  def game_dictionary(low,high,dictionary) # sets game dictionary based on parameters
    game_dictionary = []
    for word in dictionary do
      if word.length >= low && word.length <= high
        game_dictionary.push(word)
      end
    end
    game_dictionary
  end

  def game_word(dictionary) # sets game dictionary based on parameters
    @play = dictionary.sample
  end

end

module Visuals
  def generate_blanks(word)
    word.length.times do
      @blanks.push("__")
    end
  end

def player_turn(letter)
  add_to_counter = false

  @play.each_char.with_index do |char, index|
    if letter == char
      @blanks[index] = letter
      add_to_counter = true
    end
  end

  if !add_to_counter
    @incorrect_guesses += 1
  end
end

end

class HangMan
  include Words, Visuals
  attr_accessor :play, :blanks, :incorrect_guesses

  def initialize
    @play = ""
    @blanks = []
    @incorrect_guesses = 0
  end

  def blanks
    @blanks.join("  ")
  end

  def guesses
    puts "There have been #{@incorrect_guesses} incorrect guesses so far."
  end

end

game = HangMan.new
full_dictionary = game.dictionary_to_array('dictionary.txt')
game_dictionary = game.game_dictionary(5,12,full_dictionary)
game_word = game.game_word(game_dictionary)
game.generate_blanks(game_word)
p game.play
p game.blanks
turn = game.player_turn("a")
puts "Updated blanks below"
p game.blanks
game.guesses
