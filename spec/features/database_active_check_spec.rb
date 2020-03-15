require 'rails_helper'

describe 'Database active check' do
  let(:model_class) { Blog }
  let(:model_decorator) { Wallaby::ActiveRecord::ModelDecorator.new model_class }

  context 'when database does not exist' do
    it 'returns empty hash' do
      expect(::ActiveRecord::Base).to receive(:connected?).and_return(false)
      expect(model_decorator.fields).to eq({})
    end
  end

  context 'when table does not exist' do
    let(:model_class) { stub_const 'NotFoundTable', Class.new(ActiveRecord::Base) }

    it 'returns empty hash' do
      expect(::ActiveRecord::Base.connected?).to be_truthy
      expect(model_class.table_exists?).to be_falsy
      expect(model_decorator.fields).to eq({})
    end
  end
end
