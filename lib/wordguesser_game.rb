class WordGuesserGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service
  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses
  attr_accessor :word_with_guesses
  attr_accessor :check_win_or_lose
  def initialize(word)
    @word = word
    @guesses = ""
    @wrong_guesses = ""
    @word_with_guesses = "-" *  word.length
    @failedCounter = 0
    @check_win_or_lose = :play
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start { |http|
      return http.post(uri, "").body
    }
  end

  def guess alphabet
    if alphabet == '' || alphabet == '%' || alphabet == nil
      raise ArgumentError 
    end
    if alphabet.match?(/[^a-z]/) || alphabet == @guesses ||  alphabet == @wrong_guesses
      return false
    end
    if @word.include?(alphabet)
      a = (0 ... @word.length).find_all { |i| @word[i,1] == alphabet }
      a.each do |i|
        @word_with_guesses[i] = alphabet
      end  
      @guesses = alphabet
      if @word_with_guesses.index('-') == nil
        @check_win_or_lose = :win
      end
    else
      @wrong_guesses = alphabet
      @failedCounter = @failedCounter+1
      if @failedCounter == 7
        @check_win_or_lose = :lose
      end
    end
    return true
  end

end
