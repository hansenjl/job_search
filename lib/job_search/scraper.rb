class JobSearch::Scraper
    SITE_TO_SCRAPE = "https://phoenix.craigslist.org/"

    def self.scrape_site
        uri = SITE_TO_SCRAPE
        doc = Nokogiri::HTML(open(uri))

        #create categories for user to select from
        doc.search('.jobs .cats a').each.with_index(1) do |link, index|
            category = link.attr('href').split("d/").last.split("/").first
            link = link.attr('href')
            link[0] = "" #remove
            link = uri + link



            JobSearch::Category.new(category, link)
        end
    end

    def self.scrape_category_for_job_links(category)
        doc = Nokogiri::HTML(open(category.link))
        doc.search('.rows .result-info a').each do |row|
            job_link = row.attr('href')
            title = row.text
            JobSearch::Job.new(category, job_link, title) unless job_link == '#'
        end
    end

    def self.scrape_job_link(job)
        doc = Nokogiri::HTML(open(job.link))
        unless doc.search('.attrgroup').text.split(": ")[1].nil?
            job.compensation = doc.search('.attrgroup').text.split(": ")[1].split("\n").first
        end

        #format the date before setting it in job object
        date = doc.search('.date.timeago').children[0].text.strip
        year, month, date_time = date.split('-')
        day, time = date_time.split(" ")
        job.date = "#{month}-#{day}-#{year} at #{time}."

        job.title = doc.search('.postingtitletext #titletextonly').text.strip
        job.employment_type = doc.search('.attrgroup').text.strip.split(" ").last, #job type
        job.body = doc.search('#postingbody').text.split("\n").join(" ").gsub("                    QR Code Link to This Post                    ", "").strip
    end
end