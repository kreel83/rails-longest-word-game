require 'open-uri'

class GamesController < ApplicationController
  LETTERS = %w(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)

  def new
    @selection = []
    10.times do
      @selection << LETTERS.sample()
    end

  end

  def score
    word = params[:word]
    selection = params[:selection].split(',')

    present = test_if_exist_in_grid(word, selection)
    if !present
      @response = "sorry but #{word.upcase} can't be built out of #{selection.join(',')}"
    else
      url = "https://wagon-dictionary.herokuapp.com/#{word}"
      data = JSON.parse(open(url).read)
      if !data['found']
        @response = "sorry but #{word.upcase} does not seem to ben a valid English word..."
      else
        @response = "Congratulation! #{word.upcase} is a valid English word!"
        session['score'] = 0 if session['score'].nil?
        session['score'] += word.size
        @score = session['score']
      end
    end
  end

  private

  def test_if_exist_in_grid(word, selection)
    sel = selection
    present = true
    word.upcase.split('').each do |w|
      pos = sel.index(w)
      if pos
        sel.delete_at(pos)
      else
        present = false
      end
    end
    present
  end
end
