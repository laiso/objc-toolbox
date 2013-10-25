require 'pathname'
require 'cocoapods'

module ObjCToolBox
  class CocoaPods
    # @return [Pod::Spec]
    #
    #  {"name"=>"ZYActivity",
    #   "version"=>"0.0.1",
    #   "summary"=>"Easier UIActivity inheritance.",
    #   "homepage"=>"https://github.com/marianoabdala/ZYActivity",
    #   "license"=>{"type"=>"MIT", "file"=>"README.md"},
    #   "authors"=>{"Mariano Abdala"=>"mariano@zerously.com"},
    #   "source"=>
    #       {"git"=>"https://github.com/marianoabdala/ZYActivity.git", "tag"=>"0.0.1"},
    #   "platforms"=>{"ios"=>"6.0"},
    #   "source_files"=>"ZYActivity/*",
    #   "requires_arc"=>true}
    def all_pods
      pods = []
      Pod::SourcesManager.all_sets.each do |p|
        spec = load_spec(p.highest_version_spec_path)
        pods.push spec if spec && get_github_repo_url(spec)
      end
      pods
    end

    def get_github_repo_url(pod)
      url = pod.source[:git]
      url if /https:\/\/github.com\/.+\/.+\.git/ =~ url
    end

    :private

    def load_spec(path)
      begin
        file = File.open path
        spec = instance_eval(file.read())
      rescue Exception => ex
        puts "[ERROR] Can't load #{path} / #{ex}\n"
      ensure
        file.close
      end
      spec
    end
  end
end
