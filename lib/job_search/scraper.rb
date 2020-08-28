require 'colorize'
class JobSearch::Scraper
    SITE_TO_SCRAPE = "https://phoenix.craigslist.org/"
    # @@all_categories = []
    # @@all_links = []
    # @@all_jobs = []
    # @@all_job_links = []

    # create categories for user to select from
    def self.scrape_site
        uri = SITE_TO_SCRAPE
        doc = Nokogiri::HTML(open(uri))

        #create categories for user to select from
        doc.search('.jobs .cats a').each.with_index(1) do |category, index|
            category = category.attr('href').split("d/").last.split("/").first
            JobSearch::Job.all_categories << "#{index}. " + "#{category}".colorize(:green)
        end
        
        #go through each category of the 'jobs section' on craigslist and add to @@all array
        doc.search('.jobs .cats a').each do |link| 
            link = link.attr('href')
            link[0] = "" #remove
            JobSearch::Job.all_links << uri + link 
        end
    end

    def self.scrape_category_for_job_links(category_link)
        doc = Nokogiri::HTML(open(category_link))

        doc.search('.rows .result-info a').each do |row|
            job_link = row.attr('href')
            JobSearch::Job.all_job_links << job_link unless job_link == '#'
        end
    end

    def self.scrape_job_link(job_selection)
        doc = Nokogiri::HTML(open(job_selection))
        
        unless doc.search('.attrgroup').text.split(": ")[1].nil?
            pay = doc.search('.attrgroup').text.split(": ")[1].split("\n").first
        end

        #format the date before setting it in job object
        date = doc.search('.date.timeago').children[0].text.strip
        year, month, date_time = date.split('-')
        day, time = date_time.split(" ") 
        date = "#{month}-#{day}-#{year} at #{time}."

        JobSearch::Job.new(
            doc.search('.postingtitletext #titletextonly').text.strip, #title
            pay, #compensation
            doc.search('.attrgroup').text.strip.split(" ").last, #job type
            doc.search('#postingbody').text.split("\n").join(" ").gsub("                    QR Code Link to This Post                    ", "").strip#body
        )   
        JobSearch::Job.all[0].date = date #date
    end
end