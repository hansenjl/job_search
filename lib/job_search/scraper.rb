require 'colorize'
class JobSearch::Scraper

    SITE_TO_SCRAPE = "https://phoenix.craigslist.org/"
    @@all_categories = []
    @@all_links = []
    @@all_jobs = []
    @@all_job_links = []

    # create categories for user to select from
    def self.scrape_site
        uri = SITE_TO_SCRAPE
        doc = Nokogiri::HTML(open(uri))

        #create categories for user to select from
        doc.search('.jobs .cats a').each.with_index(1) do |category, index|
            category = category.attr('href').split("d/").last.split("/").first
            @@all_categories << "#{index}. " + "#{category}".colorize(:green)
        end
        
        #go through each category of the 'jobs section' on craigslist and add to @@all array
        doc.search('.jobs .cats a').each do |link| 
            link = link.attr('href')
            link[0] = "" #remove
            @@all_links << uri + link 
        end
    end

    def self.scrape_category_for_job_links(category_link)
        doc = Nokogiri::HTML(open(category_link))
        doc.search('.rows .result-info a').each do |row|
            job_link = row.attr('href')
            @@all_job_links << job_link unless job_link == '#'
        end
    end

    def self.scrape_job_link(job_selection)
        doc = Nokogiri::HTML(open(job_selection))

        # (title, date, compensation, employment_type, body)
        JobSearch::Job.new(
            doc.search('.postingtitletext #titletextonly').text.strip, #title
            doc.search('.date.timeago').children[0].text.strip, #date
            doc.search('.attrgroup').text.strip.split(": ")[1],
            doc.search('.attrgroup').text.strip.split(" ").last,
            doc.search('#postingbody').text.split("\n").join("").strip.split("  ").last#body
        )   
        binding.pry
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
end