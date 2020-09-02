class JobSearch::Category
    
    @@all = [] #all categories
    @@jobs = [] #all job link from a category

    attr_accessor :category_name, :link, :jobs

    def initialize(category_name, link)
        @category_name = category_name
        @link = link

        @@all << self
    end

    #returns the jobs that were scraped based on selection
    #a category has many jobs
    def self.jobs
        @@jobs
    end

    #will hold all the categories scraped based on user selection
    def self.all
        @@all
    end

    def self.destroy_all
        @@all.clear
        @@jobs.clear
    end

end
