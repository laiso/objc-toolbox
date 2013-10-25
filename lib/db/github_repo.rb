require 'mongoid'

module ObjCToolBox
  module Db
    class GithubRepo
      include Mongoid::Document

      field :name
      field :pod_name
      field :watch, :type=>Numeric, :default => 0
      field :fork, :type=>Numeric, :default => 0
      field :issue, :type=>Numeric, :default => 0

      field :updated_at, :type => DateTime
      field :created_at, :type => DateTime, :default => lambda{Time.now}
    end
  end
end