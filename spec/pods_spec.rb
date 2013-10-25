require 'spec_helper'
require 'cocoapods'

module ObjCToolBox
  describe 'CocoaPods' do
    stub_pods = load_object('spec/fixture/pods.yaml')
    before do
      Pod::SourcesManager.stub(:all_sets).and_return(stub_pods)
      @pods = CocoaPods.new
      @all_pods = @pods.all_pods
    end
    describe '#all_pods' do
      it '@all_pods and stub_pods is same length' do
        expect(@all_pods.length).to eq stub_pods.length
      end
      it 'Pod::Spec in all_pods' do
        @all_pods[0].class.to_s.should eq 'Pod::Specification'
      end
    end
    describe '#get_github_repo_url' do
      before do
        @pod = Pod::Spec.new do |s|
          s.source = {git: 'https://github.com/marianoabdala/ZYActivity.git'}
        end
      end
      it 'return url if github’s repo' do
        url = @pods.get_github_repo_url @pod
        url.should eq 'https://github.com/marianoabdala/ZYActivity.git'
      end
      it 'return nil if not github’s repo' do
        p = Pod::Spec.new do |s|
          s.source = {git: 'https://MorganKennedy@bitbucket.org/MorganKennedy/sqlayout.git'}
        end
        url = @pods.get_github_repo_url p
        expect(url).to be_nil
      end
      it 'return nil if not git source' do
        p = Pod::Spec.new do |s|
          s.source = {}
        end
        url = @pods.get_github_repo_url p
        expect(url).to be_nil
      end
    end
  end
end