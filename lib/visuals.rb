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
