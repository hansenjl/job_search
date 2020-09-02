# require 'nokogiri'
# require 'open-uri'
# require 'pry'
# require 'colorize'
require_relative 'version'

class JobSearch::CLI 
    @@categories_to_display = [] 
    @@jobs_within_category = []
    @@jobs_to_print = []

    def program_run
        greeting
        create_and_display_categories
        user_category_selection 
        create_and_display_all_job_listings
        print_job_listings
        user_job_selection 
        explore_the_job 
        view_another_job_or_category?
    end

    def greeting
        puts "Welcome to the Craigslist Job Search!".colorize(:blue)
        puts "Please choose from a category below:".colorize(:blue)
        sleep(2)

        puts "Which category would you like more information on?".colorize(:yellow)
        puts "Choose the corresponding number from the list to get more information.".colorize(:yellow)
        puts "For example, enter '1' for 'accounting-finance' job information.".colorize(:yellow)
        sleep(4)
    end

    def create_and_display_categories
        categories = JobSearch::Scraper.scrape_site #store site data in categories variable
        JobSearch::Category.all.each.with_index(1) {|category, index| puts "#{index}. #{category.category_name}"}
    end   

    def user_category_selection
        input = gets.strip
        JobSearch::Job.all_categories.find.with_index(1) do |selection, i|
            
            if (1..@@categories_to_display.size).include?(input.to_i)
                number, job_category = selection.split(".")

                if selection.include?(input)
                    puts "You've selected the category" + "#{job_category}!".colorize(:red)
                    sleep(2)
                    category_link = JobSearch::Job.all_links[i - 1] #scrape this link
                    JobSearch::Scraper.scrape_category_for_job_links(category_link) #scrape this
                end

            else
                puts "Sorry, that's not valid input, please try again.".upcase.colorize(:red)
                puts "Choose the corresponding number from the list to get more information.".colorize(:yellow)
                puts "For example, enter '1' for 'accounting-finance' job information.".colorize(:yellow)

                user_category_selection
            end
        end
    end

    def create_and_display_all_job_listings
        puts "Which job would you like more information on?".colorize(:green)

        JobSearch::Job.all_job_links.each { |link| @@jobs_within_category << "#{link}" }

        puts "Available jobs in this category:".colorize(:blue)
        puts "--------------------------------"

        @@jobs_within_category.each { |j| @@jobs_to_print << j.split("/d/").last.split('/').first }
    end

    def print_job_listings
        @@jobs_to_print.each.with_index(1) { |job, i| puts "#{i}." + "#{job}".colorize(:red) }
    end

    def user_job_selection
        input = gets.strip.downcase
        
        @@jobs_within_category.find.with_index(1) do |job, i|
            if (1..@@jobs_within_category.size).include?(input.to_i)
                if i.to_s == input 
                    puts "You've selected option number #{i}, for #{@@jobs_to_print[i - 1]}!".colorize(:green)
                    puts "Here is the job link if you'd like to view the job page: " + "#{job}".colorize(:light_blue)
                    sleep(3)
                    JobSearch::Scraper.scrape_job_link(job)
                end
            else
                puts "Sorry, that's not valid input. Please try again.".upcase.colorize(:red)
                user_job_selection
            end
        end
    end

    def explore_the_job
        job = JobSearch::Job.all.last
        
        puts "What information would you like to know about the job you selected?".colorize(:yellow)
        puts "Enter 'title' or '1' for job title.".colorize(:yellow)
        puts "Enter 'details' or '2' for job details.".colorize(:yellow)
        puts "Enter 'job type' or '3' for the type of employement (PT/FT, hourly, etc.).".colorize(:yellow)
        puts "Enter 'pay' or '4' to get the job's compensation.".colorize(:yellow)
        puts "Enter 'overall' or '5' if you would like to view all details at once.".colorize(:yellow)
        puts "Enter 'done' if you are finished viewing information about the job.".colorize(:yellow)

        input = gets.strip.downcase
        if input == '1' || input == 'title'
            puts "#{job.title}".colorize(:green)
        elsif input == '2' || input == 'details'
            puts "#{job.body}".colorize(:green)
        elsif input == '3' || input == 'job type'
            puts "#{job.employment_type}".colorize(:green)
        elsif input == '4' || input == 'pay'
            puts "#{job.compensation}".colorize(:green)
        elsif input == '5' || input == 'overall'
            puts "#{job.descriptor}".colorize(:green)
        elsif input == 'done'
            puts "All finished with this job?".colorize(:yellow)
        else 
            puts "Please select one of the inputs mentioned above.".upcase.colorize(:red)
        end
        sleep(2)

        explore_the_job unless input == 'done'
    end

    def view_another_job_or_category?
        puts "Would you like to make another selection?"
        puts "To continue, enter 'yes'."
        puts "Type 'exit' to end the program"

        input = gets.strip.downcase
        
        if input == 'yes'
            JobSearch::CLI.reset_program
            program_run #start program again
        elsif input == 'exit'
            puts "Thank you, and good luck with your job search!".colorize(:green) #end program
        else
            puts "SORRY, BUT ".colorize(:red) + "'#{input}'".colorize(:blue) + " IS NOT A VALID OPTION...TRY AGAIN PLEASE.".colorize(:red)
            view_another_job_or_category?
        end
    end

    def self.reset_program
        @@categories_to_display = [] 
        @@jobs_within_category = []
        @@jobs_to_print = []
        JobSearch::Job.destroy_all
    end
end