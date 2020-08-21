require 'nokogiri'
require 'open-uri'
require 'pry'
require 'colorize'
require_relative 'version'

class JobSearch::CLI 

    @@categories_to_display = [] #holds all created categories with their number
    @@jobs_within_category = []
    @@jobs_to_print = []

    def program_run
        greeting
        which_category? #a message asking which category user wants to choose
        create_and_display_categories #create, AND display the categories

        category_selection = gets.strip #gather user input
        user_category_selection(category_selection) #takes user input and returns the corresponding category

        create_and_display_all_job_listings #displays all job links withing specific category, with a corresponding number
        print_job_listings #prints the job listings within a specific category
        user_job_selection #allows user to select which job they want more information on, and will begin scraping it
        # explore_the_job #code for viewing information about the selected job
        view_another_job_or_category? #allows you to choose to view another job, or another category 
    end

    def greeting
        puts "Welcome to the Craigslist Job Search!".colorize(:blue)
        puts "Please choose from a category below:".colorize(:blue)
        sleep(3)
    end

    def which_category?
        puts "Which category would you like more information on?".colorize(:yellow)
        puts "Choose the corresponding number from the list to get more information.".colorize(:yellow)
        puts "For example, enter '1' for 'accounting-finance' job information.".colorize(:yellow)
        sleep(3)
    end 

    def create_and_display_categories
        categories = JobSearch::Scraper.scrape_site
        categories.collect.with_index(1) do |category, i|
            category = category.attr('href').split("d/").last.split("/").first
            puts "#{i}. #{category}"
            @@categories_to_display << "#{i}. #{category}"
        end
    end   

    def user_category_selection(input)
        @@categories_to_display.each.with_index(1) do |selection, i|
            number, job_category = selection.split(".")
            if input == number
                puts "You've selected the category" + "#{job_category}!".colorize(:red)
                # sleep(3)
                category_link = JobSearch::Scraper.all_links[i - 1] #scrape this link
                JobSearch::Scraper.scrape_category_for_job_links(category_link) #scrape this
            end
        end
    end

    def create_and_display_all_job_listings
        puts "Which job would you like more information on?".colorize(:green)
        JobSearch::Scraper.all_job_links.each do |link|
            @@jobs_within_category << "#{link}"
        end

        puts "Available jobs in this category:".colorize(:blue)
        puts "--------------------------------"
        @@jobs_within_category.each do |j|
            #grabs the last part of the link to create a job
            @@jobs_to_print << j.split("/d/").last.split('/').first
        end
    end

    def print_job_listings
        @@jobs_to_print.each.with_index(1) do |job, i|
            puts "#{i}." + "#{job}".colorize(:red)
        end
    end

    def user_job_selection
        input = gets.strip
        @@jobs_within_category.each.with_index(1) do |job, i|
            if i.to_s == input 
                puts "You've selected option number #{i}, for #{job}!".colorize(:yellow)
                sleep(3)
                JobSearch::Scraper.scrape_job_link(job)
            end
        end
    end

    def explore_the_job
        puts "What information would you like to know about the job you selected?".colorize(:yellow)
        puts "Enter 'title' for job title."
        puts "Enter 'details' for job details."
        puts "Enter 'job type' for the type of employement."
        input = gets.strip

        if input == 1

        job = JobSearch::Job.all.last
        job.descriptor
    end

    def view_another_job_or_category?
        puts "Would you like to make another selection?"
        puts "To continue, enter 'yes'."
        puts "Type 'exit' to end the program"
        input = gets.strip
        if input == 'yes'
            JobSearch::CLI.reset_program
            program_run
        elsif input == 'exit'
            puts "Thank you, and good luck with your job search!"
        end
    end

    def self.reset_program
        @@categories_to_display = [] 
        @@jobs_within_category = []
        @@jobs_to_print = []
        JobSearch::Scraper.destroy_all
        JobSearch::Job.destroy_all
    end
end

# git add . | git commit -m "" | git push