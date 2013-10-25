#!/usr/bin/env ruby

require './lib/db'

require './lib/fetcher'
require './lib/cocoapods'
require './lib/db/github_repo'

def main
  client = ObjCToolBox::Fetcher.new

  cocoapods = ObjCToolBox::CocoaPods.new
  pods = cocoapods.all_pods


  while (true)
    repos = client.fetch_repos_from_specs pods
    repos.each do |repo|
      puts "#{repo.pod_name}"
      repo.save!
    end

    sleep 3
  end

end

if __FILE__ == $0
  main()
end
