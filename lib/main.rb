require 'json'

module Words # methods which impact word use for the game
  def dictionary_to_array(file_name) # reads the dictionary and converts to array
    root_directory = File.expand_path('..', __dir__) # finds root directory
    root_path = File.join(root_directory, file_name) # joins root with file name
    file_contents = File.read(root_path) # reads the entire contents of the file
    file_contents.split # returns file as an array
  end

  def game_dictionary(low,high,dictionary) # sets game dictionary based on parameters
    game_dictionary = []
    for word in dictionary do # iterates through words in an array
      if word.length >= low && word.length <= high # looks for words of certain length
        game_dictionary.push(word) # adds these words to game_dictionary
      end
    end
    game_dictionary # returns game_dictionary as array
  end

  def game_word(dictionary) # sets word for the game
    @play = dictionary.sample # updates @play to random word from dictionary parameter
    unique_letters = @play.chars.uniq # used to determine how many unique letters
    @guesses_to_win = unique_letters.count # count needed to determine win condition
  end

end

module Visuals # methods which generate game visuals
  def generate_blanks(word) # generates an array with "__" as elements
    word.length.times do # creates a new element for every letter in a word
      @blanks.push("__")
    end
  end

  def the_hangman(file_name, index) # creates the display of the hangman
    root_directory = File.expand_path('..', __dir__)
    root_path = File.join(root_directory, file_name)
    file_contents = File.readlines(root_path)
    puts file_contents[index..index+9] # only displays 10 lines of file at a time
  end


end

module GamePlay
  def self.instructions(file_name)
    root_directory = File.expand_path('..', __dir__)
    root_path = File.join(root_directory, file_name)
    puts file_contents = File.readlines(root_path)
  end

  def letter_entry() # loop for user input of a letter
    letter = ""

    loop do # remain here until loop break
      print "To guess, input a letter. Input 1 to save your progress and close.\n "
      letter = gets.chomp.downcase
      break if (letter.match?(/^[a-z]$/) || letter == "1") && letter.length == 1 && \
        !letters_used.include?(letter) # must be one character that hasn't been used

      if letters_used.include?(letter) == true # execute if input is used letter
        puts "You have used that letter already. Try again."
      else # all other invalid entries
        puts "Invalid entry. Try again."
      end

    end
    letter # returns letter; need for player_turn
  end

  def player_turn(letter) # loop for player turn
    add_to_counter = false  # by default, assume answer is wrong

    @play.each_char.with_index do |char, index| # iterate to check for match
      if letter == char
        @blanks[index] = letter # rewrite @blanks array with correct letter
        add_to_counter = true # answer was correct
      end
    end

    @letters_used.push(letter) # updates used letters array with current letter

    if !add_to_counter # execute if no matches found with iteration
      @incorrect_guesses += 1 # need for game lose conditions
      @hangman_index += 10 # updates index for the_hangman visuals
      puts "OH NO! Incorrect! \n "
    end

    if add_to_counter # execute if a match is found
      @correct_guesses += 1 # need for game win conditions
      puts "HUZZAH! Correct! \n "
    end
  end

  def game_over_check() # conditions needed to end the game
    if @correct_guesses == @guesses_to_win # found all unique letters
      puts "Congratulations! You are victorious!"
      @game_over = true
    end

    if @incorrect_guesses == 7 # full hangman was displayed
      puts "FAILURE! The correct word was: #{@play}"
      @game_over = true
    end
  end

end

module SaveData
  def save()
    data = {
      "play" => @play,
      "blanks" => @blanks,
      "letters_used" => @letters_used,
      "incorrect_guesses" => @incorrect_guesses,
      "correct_guesses" => @correct_guesses,
      "guesses_to_win" => @guesses_to_win,
      "hangman_index" => @hangman_index,
      "game_over" => @game_over
    }
    File.open("progress.json", "w") do |file|
      file.write(JSON.dump(data))
    end
    puts "Progress saved."
  end

  def continue()
    if File.exist?("progress.json")
      data = JSON.parse(File.read("progress.json"))
      @play = data["play"]
      @blanks = data["blanks"]
      @letters_used = data["letters_used"]
      @incorrect_guesses = data["incorrect_guesses"]
      @correct_guesses = data["correct_guesses"]
      @guesses_to_win = data["guesses_to_win"]
      @hangman_index = data["hangman_index"]
      @game_over = data["game_over"]
      @continue_file = true
      puts "Progress loaded."
    else
      puts "No progress file found."
    end
  end

  def clear_save_file()
    if File.exist?("progress.json")
      File.delete("progress.json")
    end
  end
end

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
    @continue_file = false
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

def play_hangman() # main game loop
  GamePlay.instructions('introduction.txt') # display intro information
  choice = ""
  loop do
    choice = gets.chomp
    break if choice == "1" || choice == "2"
    puts "Invalid entry. Try again."
  end

  game = HangMan.new # creates a new instance of HangMan
  dict = game.dictionary_to_array('dictionary.txt') # reads txt file for dictionary
  play = game.game_dictionary(5, 12, dict) # only allows 5-12 letter words
  game.game_word(play) # selects a word from game_dictionary at random
  game.generate_blanks(game.play) # creates an array of blanks for "game board"

  if choice == "1" # selection to start a new game
    puts "STARTING A NEW GAME."
  elsif choice == "2" # selection to load a save file
    game.continue # updates saved instance variables
    if game.continue_file == true # game file was found
      game.guesses # print the guesses that were used
    else # no game file was found
      puts "STARTING A NEW GAME."
    end
  end

  puts game.blanks # prints the letters to guess
  game.the_hangman('hangman_display.txt',game.hangman_index) # prints starting hangman

  until game.game_over # loop until @game_over is true
    guess = game.letter_entry # take a user input for a letter guess

    if guess == "1" # will save progress and exit the game
      game.save
      exit
    end

    game.player_turn(guess) # execute player_turn method after accepting letter
    puts game.blanks # prints updated blanks
    game.the_hangman('hangman_display.txt',game.hangman_index) # prints updated hangman
    game.guesses # prints guess information
    game.game_over_check # check for game over conditions
  end
  game.clear_save_file # deletes any save progress at the conclusion of a game

end

play_hangman()



