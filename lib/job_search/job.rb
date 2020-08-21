require 'nokogiri'
require 'open-uri'
require 'pry'
require 'colorize'
require_relative 'version'

class JobSearch::Job
    @@all = [] #holds all instances of a job

    attr_accessor :title, :date, :compensation, :employment_type, :body
    def initialize(title = nil, date = nil, compensation = nil, employment_type = nil, body = nil)
        @title = title
        @date = date
        @compensation = compensation 
        @employment_type = employment_type
        @body = body

        @@all << self 
    end

    def descriptor
        puts "Job title:        #{self.title}".colorize(:red)
        puts "Job post-date:    #{self.date}".colorize(:red)
        puts "Job compensation: #{self.compensation}".colorize(:green)
        puts "Employement type: #{self.employment_type}".colorize(:green)
        puts "Job Description:  #{self.body}".colorize(:blue)
    end

    def self.all
        @@all
    end

    def self.destroy_all
        @@all.clear()
    end
end