require 'spec_helper'

RSpec.describe 'exceptions' do
  describe 'messages' do
    it 'raise GameOver' do
      expect { raise Minesweeper::GameOver }.to raise_exception(Minesweeper::GameOver)
      expect { raise Minesweeper::GameOver }.to raise_error('You Lost')
    end

    it 'raise GameWon' do
      expect { raise Minesweeper::GameWon }.to raise_exception(Minesweeper::GameWon)
      expect { raise Minesweeper::GameWon }.to raise_error('You Won')
    end
  end
end