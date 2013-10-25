require 'octokit'

require './lib/cocoapods'
require './lib/db/github_repo'

module ObjCToolBox
  class Fetcher
    DEFAULT_REQUEST_LIMIT = 10

    def initialize
      @gh = Octokit::Client.new
      @cocoapods = CocoaPods.new
    end

    # @return [Sawyer::Resource] octokit
    #
    # => {:id=>11996252,
    #:name=>"Hatena-Bookmark-iOS-SDK",
    #    :full_name=>"hatena/Hatena-Bookmark-iOS-SDK",
    #    :owner=>
    #    #<Sawyer::Resource:0x007fc024a8a160
    #    @_agent=<Sawyer::Agent https://api.github.com/>,
    #    @_fields=#<Set: {:login, :id, :gravatar_id, :type}>,
    #        @_metaclass=#<Class:#<Sawyer::Resource:0x007fc024a8a160>>,
    #            @_rels=
    #                #<Sawyer::Relation::Map: [:avatar, :self, :html, :followers, :following, :gists, :starred, :subscriptions, :organizations, :repos, :events, :received_events]>,
    #                @attrs=
    #                    {:login=>"hatena",
    #                     :id=>14185,
    #                     :gravatar_id=>"0a5fcdd6e4d181e86f675fb56a133500",
    #                     :type=>"Organization"}>,
    #            :private=>false,
    #:description=>"Integrate Hatena Bookmark  into your application",
    #    :fork=>false,
    #:created_at=>2013-08-09 08:12:14 UTC,
    #:updated_at=>2013-09-20 16:02:58 UTC,
    #:pushed_at=>2013-09-12 06:41:57 UTC,
    #:homepage=>"",
    #    :size=>920,
    #    :watchers_count=>49,
    #    :language=>"Objective-C",
    #    :has_issues=>true,
    #:has_downloads=>true,
    #:has_wiki=>true,
    #:forks_count=>5,
    #    :open_issues_count=>2,
    #    :forks=>5,
    #    :open_issues=>2,
    #    :watchers=>49,
    #    :master_branch=>"master",
    #    :default_branch=>"master",
    #    :network_count=>5,
    #    :organization=>
    #    #<Sawyer::Resource:0x007fc024a80c50
    #    @_agent=<Sawyer::Agent https://api.github.com/>,
    #    @_fields=#<Set: {:login, :id, :gravatar_id, :type}>,
    #        @_metaclass=#<Class:#<Sawyer::Resource:0x007fc024a80c50>>,
    #            @_rels=
    #                #<Sawyer::Relation::Map: [:avatar, :self, :html, :followers, :following, :gists, :starred, :subscriptions, :organizations, :repos, :events, :received_events]>,
    #                @attrs=
    #                    {:login=>"hatena",
    #                     :id=>14185,
    #                     :gravatar_id=>"0a5fcdd6e4d181e86f675fb56a133500",
    #                     :type=>"Organization"}>}
    def fetch_repos
      fetch_repos_from_specs @cocoapods.all_pods
    end

    def fetch_repos_from_specs(pods)
      result = []
      counter = 0
      pods.each do |p|
        return result if counter > DEFAULT_REQUEST_LIMIT

        unless Db::GithubRepo.where(:pod_name=>p.name).exists?
          repo = fetch_repo @cocoapods.get_github_repo_url(p)
          result.push create_document repo, p.name
          counter += 1
        end
      end
      result
    end

    :private
    def create_document(repo, pod_name)
      owner = repo[:owner][:login] if repo[:owner]

      Db::GithubRepo.new(
          :_id=>repo[:id],
          :owner=>owner,
          :name=>repo[:name],
          :pod_name=>pod_name,
          :fork=>repo[:forks_count],
          :watch=>repo[:watchers_count],
          :issue=>repo[:open_issues_count],
          :network=>repo[:network_count],
          :updated_at=>repo[:updated_at],
      )
    end
    def fetch_repo(url)
      result = {}
      begin
        repo = Octokit::Repository.from_url url.sub('.git', '')
        result = @gh.repo(repo)
      rescue Octokit::Error => error
        puts "[ERROR][Octokit] #{error}"
      end
      result
    end
  end
end