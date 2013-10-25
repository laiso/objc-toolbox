require 'spec_helper'

require File.join(File.dirname(__FILE__), '../lib/db')

module ObjCToolBox
  module Db
    describe GithubRepo do
      before do
        @repo = GithubRepo.create({name: 'JSONKit', fork: 123, star: 456})
      end
      it 'should be @repo == JSONKit' do
        expect(@repo.name).to eq 'JSONKit'
      end
    end
  end
end