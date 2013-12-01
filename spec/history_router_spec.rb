require 'spec_helper'
require 'vienna/history_router'

describe Vienna::HistoryRouter do
  describe '#update' do
    it 'updates path' do
      subject.navigate('/foo')
      expect(subject.path).to eq('/foo')
    end

    it 'calls #match with the new path' do
      expect(subject).to receive('match').with('/new_url')
      subject.navigate('/new_url')
    end
  end

  describe '#route' do
    it 'should add a new route' do
      subject.route('/users') {}
      expect(subject.routes.size).to eq(1)

      subject.route('/hosts') {}
      expect(subject.routes.size).to eq(2)
    end
  end

  describe '#match' do
    it 'returns nil when no routes on router' do
      expect(subject.match('/foo')).to be_nil
    end

    it 'returns the matching route for the path' do
      a = subject.route('/foo') {}
      b = subject.route('/bar') {}

      expect(subject.match('/foo')).to eq(a)
      expect(subject.match('/bar')).to eq(b)
    end

    it 'returns nil when no matching route' do
      subject.route('/foo') {}
      subject.route('/bar') {}

      expect(subject.match('/baz')).to be_nil
    end
  end
end
