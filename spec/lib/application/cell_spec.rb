require 'spec_helper'

RSpec.describe Minesweeper::Cell do
  let(:cell) { described_class.new }

  describe "#toggle_bomb_flag!" do
    it "transition state from initial to marked_as_bomb" do
      expect { cell.toggle_bomb_flag! }.
        to change { cell.status }.from(:initial).to(:marked_as_bomb)
    end

    it "transition state from marked_as_bomb back to initial" do
      cell.toggle_bomb_flag!
      expect { cell.toggle_bomb_flag! }.
        to change { cell.status }.from(:marked_as_bomb).to(:initial)
    end

    it "do nothing if cell has been opened" do
      cell.status = :opened
      expect { cell.toggle_bomb_flag! }.
        not_to change { cell.status }
    end
  end

  describe "#make_it_bomb!" do
    it "set bomb flag on cell" do
      expect { cell.make_it_bomb! }.to change { cell.bomb? }.from(false).to(true)
    end

    context "if alrady a bomb" do
      before { cell.bomb = true }

      it "return false" do
        expect(cell.make_it_bomb!).to eq false
      end

      it "change nothing" do
        expect { cell.make_it_bomb! }.not_to change { cell.bomb }
      end
    end
  end
end