require 'spec_helper'

module ObjCToolBox
  describe 'Fetcher' do
    describe '#fetch_all_repo' do
      stub_pods = load_object('spec/fixture/pods/1.yaml')
      before do
        Pod::SourcesManager.stub(:all_sets).and_return(stub_pods)
      end
      it 'should be fetch one repository data with API' do
        fetcher=Fetcher.new
        repos=fetcher.fetch_all_repo()

        expect(repos.length).to eq 1
      end
    end
  end
end