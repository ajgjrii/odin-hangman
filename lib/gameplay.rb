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
