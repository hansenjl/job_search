require 'nokogiri'
require 'open-uri'
require 'pry'
require 'colorize'
require_relative 'version'

class JobSearch::Job
    @@all = [] #holds all instances of a job

    attr_accessor :title, :date, :body, :location
    def initialize(title, date = nil, body = nil, location = nil)
        @title = title
        @date = date
        @body = body
        @location = location
        @@all << self 
    end

    def create_jobs
        #code to create jobs in a specific way
    end

end