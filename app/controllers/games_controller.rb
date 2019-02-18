require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << ('A'..'Z').to_a.sample
    end
  end

  def score
    session[:cumulated_score] ||= 0
    @user_word = params['word'].upcase
    @letters = params['letters']
    @cumulated_score = session[:cumulated_score]
    letters = @letters.split(',')
    @user_word.split('').each do |letter|
      if letters.include?(letter)
        letters.delete(letter)
      else
        @result = 'illegal letter'
        return ''
      end
    end
    url = 'https://wagon-dictionary.herokuapp.com/' + @user_word
    response = JSON.parse(open(url).read)
    if response['found']
      @result = 'word match'
      @user_score = response['length']
      session[:cumulated_score] += @user_score
      @cumulated_score = session[:cumulated_score]
    else
      @result = 'not English word'
    end
  end

  def reset
    session[:cumulated_score] = 0
    render :score
  end
end
