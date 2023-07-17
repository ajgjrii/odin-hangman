require 'json'
require_relative 'words'
require_relative 'visuals'
require_relative 'gameplay'
require_relative 'savedata'
require_relative 'hangman'

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



