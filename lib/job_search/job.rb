require 'nokogiri'
require 'open-uri'
require 'pry'
require 'colorize'
require_relative 'version'

class JobSearch::Job
    @@all = [] #holds all instances of a job
    @@all_categories = []
    @@all_links = []
    @@all_jobs = []
    @@all_job_links = []

    attr_accessor :title, :date, :compensation, :employment_type, :body, :link
    def initialize(title = nil, compensation = nil, employment_type = nil, body = nil)
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
        puts "Employment type: #{self.employment_type}".colorize(:green)
        puts "Job Description:  #{self.body}".colorize(:blue)
    end

    def self.all
        @@all
    end

    def self.all_links
        @@all_links
    end

    def self.all_categories
        @@all_categories
    end

    def self.all_jobs
        @@all_jobs
    end

    def self.all_job_links
        @@all_job_links
    end

    def self.destroy_all
        @@all_categories.clear
        @@all_links.clear
        @@all_jobs.clear
        @@all_job_links.clear
        @@all.clear
    end
end