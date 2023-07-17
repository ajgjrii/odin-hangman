class HangMan
  include Words, Visuals, GamePlay, SaveData
  attr_accessor :play, :blanks, :incorrect_guesses, :correct_guesses, \
    :game_over, :letters_used, :hangman_index, :continue_file

  def initialize
    @play = "" # word for the game
    @blanks = [] # will display array of "__" for each letter in @play
    @letters_used = [] # will update when a letter is used
    @incorrect_guesses = 0
    @correct_guesses = 0
    @guesses_to_win = 0 # will match the number of unique letters in @play
    @hangman_index = 0 # increment by 10 to get a new hangman image
    @game_over = false # change to true when game over conditions are met
    @continue_file = false # will change if a continue file is loaded
  end

  def blanks # displays blanks as a string
    @blanks.join("  ")
  end

  def guesses # prints information about guesses after each turn
    puts "There have been #{@correct_guesses} correct guesses so far."
    puts "There have been #{@incorrect_guesses} incorrect guesses so far."
    puts "The letters you have used are: #{@letters_used.join("  ")}"
  end

end
