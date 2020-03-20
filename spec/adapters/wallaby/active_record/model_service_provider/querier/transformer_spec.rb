require 'rails_helper'

describe Wallaby::ActiveRecord::ModelServiceProvider::Querier::Transformer do
  describe 'simple keywords' do
    it 'transforms' do
      expect(subject.apply(string: 'something')).to eq('something')
      expect(subject.apply([{ string: 'something' }, { string: 'else' }])).to eq(%w(something else))
    end

    context 'when no rules found' do
      it 'returns nil' do
        expect(subject.apply(null: [])).to be_nil
        expect(subject.apply([{ string: [] }, { string: [] }])).to eq(['', ''])
      end
    end
  end

  describe 'simple colon_queries' do
    it 'transforms' do
      expect(subject.apply(left: 'field', op: ':', right: { string: 'key' }).list).to eq([{ left: 'field', op: :eq, right: 'key' }])
      expect(subject.apply(left: 'field', op: ':', right: [{ string: 'key1' }, { string: 'key2' }]).list).to eq([{ join: :or, left: 'field', op: :in, right: %w(key1 key2) }])
    end

    describe 'general colon_queries' do
      it 'transforms' do
        expect(subject.apply(left: 'field', op: ':', right: { string: 'key' }).list).to eq([{ left: 'field', op: :eq, right: 'key' }])
        expect(subject.apply(left: 'field', op: ':=', right: { string: 'key' }).list).to eq([{ left: 'field', op: :eq, right: 'key' }])
        expect(subject.apply(left: 'field', op: ':!', right: { string: 'key' }).list).to eq([{ left: 'field', op: :not_eq, right: 'key' }])
        expect(subject.apply(left: 'field', op: ':!=', right: { string: 'key' }).list).to eq([{ left: 'field', op: :not_eq, right: 'key' }])
        expect(subject.apply(left: 'field', op: ':~', right: { string: 'key' }).list).to eq([{ left: 'field', op: :matches, right: '%key%' }])
        expect(subject.apply(left: 'field', op: ':^', right: { string: 'key' }).list).to eq([{ left: 'field', op: :matches, right: 'key%' }])
        expect(subject.apply(left: 'field', op: ':$', right: { string: 'key' }).list).to eq([{ left: 'field', op: :matches, right: '%key' }])
        expect(subject.apply(left: 'field', op: ':!~', right: { string: 'key' }).list).to eq([{ left: 'field', op: :does_not_match, right: '%key%' }])
        expect(subject.apply(left: 'field', op: ':!^', right: { string: 'key' }).list).to eq([{ left: 'field', op: :does_not_match, right: 'key%' }])
        expect(subject.apply(left: 'field', op: ':!$', right: { string: 'key' }).list).to eq([{ left: 'field', op: :does_not_match, right: '%key' }])
        expect(subject.apply(left: 'field', op: ':>', right: { string: 'key' }).list).to eq([{ left: 'field', op: :gt, right: 'key' }])
        expect(subject.apply(left: 'field', op: ':>=', right: { string: 'key' }).list).to eq([{ left: 'field', op: :gteq, right: 'key' }])
        expect(subject.apply(left: 'field', op: ':<', right: { string: 'key' }).list).to eq([{ left: 'field', op: :lt, right: 'key' }])
        expect(subject.apply(left: 'field', op: ':<=', right: { string: 'key' }).list).to eq([{ left: 'field', op: :lteq, right: 'key' }])
        expect(subject.apply(left: 'field', op: ':', right: [{ string: 'key1' }, { string: 'key2' }]).list).to eq([{ join: :or, left: 'field', op: :in, right: %w(key1 key2) }])
        expect(subject.apply(left: 'field', op: ':=', right: [{ string: 'key1' }, { string: 'key2' }]).list).to eq([{ join: :or, left: 'field', op: :in, right: %w(key1 key2) }])
        expect(subject.apply(left: 'field', op: ':!', right: [{ string: 'key1' }, { string: 'key2' }]).list).to eq([{ join: :and, left: 'field', op: :not_in, right: %w(key1 key2) }])
        expect(subject.apply(left: 'field', op: ':!=', right: [{ string: 'key1' }, { string: 'key2' }]).list).to eq([{ join: :and, left: 'field', op: :not_in, right: %w(key1 key2) }])
        expect(subject.apply(left: 'field', op: ':<>', right: [{ string: 'key1' }, { string: 'key2' }]).list).to eq([{ join: :and, left: 'field', op: :not_in, right: %w(key1 key2) }])
        expect(subject.apply(left: 'field', op: ':()', right: [{ string: 'key1' }, { string: 'key2' }]).list).to eq([{ left: 'field', op: :between, right: 'key1'..'key2' }])
        expect(subject.apply(left: 'field', op: ':!()', right: [{ string: 'key1' }, { string: 'key2' }]).list).to eq([{ left: 'field', op: :not_between, right: 'key1'..'key2' }])
      end
    end

    context 'when op is not found' do
      it 'returns nil' do
        expect(subject.apply(left: 'field', op: ':::', right: { string: 'key' })).to be_nil
      end
    end

    context 'when op is between but value is invalid' do
      it 'returns nil' do
        expect(subject.apply(left: 'field', op: ':()', right: [{ string: 'key' }])).to be_nil
        expect(subject.apply(left: 'field', op: ':()', right: [{ null: nil }, { string: 'key' }])).to be_nil
        expect(subject.apply(left: 'field', op: ':!()', right: [{ string: 'key' }])).to be_nil
        expect(subject.apply(left: 'field', op: ':!()', right: [{ null: nil }, { string: 'key' }])).to be_nil
      end
    end
  end
end
