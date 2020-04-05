require 'rails_helper'

describe 'ApplicationRecord check' do
  context 'when ApplicationRecord does not exist' do
    it 'does not complain' do
      expect(defined?(ApplicationRecord)).to be_falsy
      expect { Wallaby::ActiveRecord::ModelFinder.new.all }.not_to raise_error
    end
  end

  context 'when ApplicationRecord exists' do
    it 'raises ArgumentError' do
      stub_const('ApplicationRecord', Class.new(ActiveRecord::Base))
      expect { Wallaby::ActiveRecord::ModelFinder.new.all }.to raise_error ArgumentError
    end
  end
end
