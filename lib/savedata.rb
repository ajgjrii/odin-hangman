module SaveData
  def save()
    # save instance variables as a hash
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

    File.open("progress.json", "w") do |file| # write data to json
      file.write(JSON.dump(data))
    end
    puts "Progress saved."
  end

  def continue() # information to be loaded from JSON file
    if File.exist?("progress.json")
      data = JSON.parse(File.read("progress.json")) # read JSON file
      # below are all the instance variables to be updated
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

  def clear_save_file() # deletes progress.json if it exists
    if File.exist?("progress.json")
      File.delete("progress.json")
    end
  end
end
