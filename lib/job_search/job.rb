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

    def descriptor
        puts "Job title:        #{self.title}"
        puts "Job post-date:    #{self.date}"
        puts "Job location:     #{self.location}"
        puts "Job Description   #{self.body}"
    end

    def self.all
        @@all
    end

end