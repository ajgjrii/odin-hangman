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
    unique_letters = @play.chars.uniq
    @guesses_to_win = unique_letters.count
  end

end

module Visuals
  def generate_blanks(word)
    word.length.times do
      @blanks.push("__")
    end
  end

  def the_hangman(file_name, index)
    root_directory = File.expand_path('..', __dir__)
    root_path = File.join(root_directory, file_name)
    file_contents = File.readlines(root_path)
    puts file_contents[index..index+9]
  end


end

module GamePlay
  def letter_entry()
    letter = ""

    loop do
      print "To guess, input a letter. \n "
      letter = gets.chomp.downcase
      break if letter.match?(/^[a-z]$/) && letter.length == 1 && \
        !letters_used.include?(letter)
      if letters_used.include?(letter) == true
        puts "You have used that letter already. Try again."
      else
        puts "Invalid entry. Try again."
      end

    end
    letter
  end

  def player_turn(letter)
    add_to_counter = false

    @play.each_char.with_index do |char, index|
      if letter == char
        @blanks[index] = letter
        add_to_counter = true
      end
    end

    @letters_used.push(letter)

    if !add_to_counter
      @incorrect_guesses += 1
      @hangman_index += 10
      puts "OH NO! Incorrect! \n "
    end

    if add_to_counter
      @correct_guesses += 1
      puts "HUZZAH! Correct! \n "
    end
  end

  def game_over_check()
    if @correct_guesses == @guesses_to_win
      puts "Congratulations! You are victorious!"
      @game_over = true
    end

    if @incorrect_guesses == 7
      puts "FAILURE! The correct word was: #{@play}"
      @game_over = true
    end
  end

end
class HangMan
  include Words, Visuals, GamePlay
  attr_accessor :play, :blanks, :incorrect_guesses, :correct_guesses, \
    :game_over, :letters_used, :hangman_index

  def initialize
    @play = ""
    @blanks = []
    @letters_used = []
    @incorrect_guesses = 0
    @correct_guesses = 0
    @guesses_to_win = 0
    @hangman_index = 0
    @game_over = false
  end

  def blanks
    @blanks.join("  ")
  end

  def guesses
    puts "There have been #{@correct_guesses} correct guesses so far."
    puts "There have been #{@incorrect_guesses} incorrect guesses so far."
    puts "The letters you have used are: #{@letters_used.join("  ")}"
  end

end

def play_hangman()
  game = HangMan.new
  dict = game.dictionary_to_array('dictionary.txt') # reads txt file for dictionary
  play = game.game_dictionary(5, 12, dict) # only allows 5-12 letter words
  game.game_word(play) # selects a word from game_dictionary at random
  game.generate_blanks(game.play) # creates an array of blanks for "game board"
  p game.blanks # prints the letters to guess
  game.the_hangman('hangman_display.txt',game.hangman_index)

  until game.game_over
    guess = game.letter_entry
    game.player_turn(guess)
    p game.blanks
    game.the_hangman('hangman_display.txt',game.hangman_index)
    game.guesses
    game.game_over_check
  end

end

play_hangman()
