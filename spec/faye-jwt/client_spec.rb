require 'spec_helper'

RSpec.describe FayeJwt::Client do
  subject { client }
  let(:client) { FayeJwt::Client.new(access_token) }
  let(:secret) { 'SECRET' }
  let(:access_token) { JWT.encode({:any => :thing}, secret ) }
  let(:callback) { Proc.new {|message| } }
  let(:message) { {'channel' => '/meta/handshake'} }

  describe '#outgoing' do
    before { client.outgoing(message, callback) }
    it { expect(message['Authorization']).to eq 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhbnkiOiJ0aGluZyJ9.vqyYYUMmTwC_57fkN7kSdjAZToRcdTPLZteaR6pev3M'  }
  end

  describe '#incoming' do
    context 'when Authentication failed' do
      let(:message) { {'channel' => '/meta/handshake', 'error' => 'Authentication failed.'} }
      after { client.incoming(message, callback) }
      it { expect(callback).not_to receive(:call)  }
    end

    context 'without error' do
      after { client.incoming(message, callback) }
      it { expect(callback).to receive(:call)  }
    end

    context 'with other errors' do
      let(:message) { {'channel' => '/meta/handshake', 'error' => 'any'} }
      after { client.incoming(message, callback) }
      it { expect(callback).to receive(:call)  }
    end
  end

  describe '.publish' do
    let(:url) { 'http://example.com/' }
    let(:channel) { '/test' }
    let(:data) { 'data' }
    let(:body) { OpenStruct.new(:body => '') }
    after { FayeJwt::Client.publish(url, channel, data, access_token) }
    it { expect(Net::HTTP).to receive(:post_form).with(URI.parse(url), {:message=>"[{\"channel\":\"/test\",\"data\":\"data\",\"Authorization\":\"Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhbnkiOiJ0aGluZyJ9.vqyYYUMmTwC_57fkN7kSdjAZToRcdTPLZteaR6pev3M\"}]"}).and_return(body) }
  end
end
