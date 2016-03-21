require 'spec_helper'

RSpec.describe FayeJwt::Server do
  subject { server }
  let(:server) { FayeJwt::Server.new(secret) }
  let(:secret) { 'SECRET' }
  let(:callback) { Proc.new {|message| } }

  describe '#incoming' do
    after { server.incoming({'channel' => '/meta/handshake'}, callback) }
    it { expect(server).to receive(:authenticate)  }
  end

  describe '#incoming' do
    let(:message) { {'Authorization' => '123', 'jwt' => '123'} }
    before { server.outgoing(message, callback) }
    it { expect(message['Authorization']).to eq(nil)  }
    it { expect(message['jwt']).to eq(nil)  }
  end

  describe '#authenticate' do
    subject { @result }
    let(:access_token) { JWT.encode({:any => :thing}, secret ) }
    let(:authorization) { "bearer #{access_token}" }
    let(:message) { {'subscription' => '/test', 'Authorization' => authorization } }
    before { @result = server.authenticate(message) }

    context 'with correct access_token' do
      it { should eq true }
      it { expect(message).to eq({"subscription"=>"/test", "Authorization"=>"bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhbnkiOiJ0aGluZyJ9.vqyYYUMmTwC_57fkN7kSdjAZToRcdTPLZteaR6pev3M", "jwt"=>{"payload"=>{"any"=>"thing"}, "header"=>{"typ"=>"JWT", "alg"=>"HS256"}}}) }
    end

    context 'with incorrect message' do
      let(:message) { {'subscription' => '/test'} }
      it { should eq false }
    end
    
    context 'with incorrect authorization' do
      let(:authorization) { access_token }
      it { should eq false }
    end
    
    context 'with incorrect access_token' do
      context 'with incorrect secret' do
        let(:access_token) { JWT.encode({:any => :thing}, 'wrong' ) }
        it { should eq false }
      end

      context 'with incorrect format' do
        let(:access_token) { 'access_token' }
        it { should eq false }
      end
    end
  end
end
