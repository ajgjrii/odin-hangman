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
