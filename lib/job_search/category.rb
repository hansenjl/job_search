# will contain attr accessors for links and name of category
# IMPORTANT: A Method called Jobs, that will return the associated Jobs; will be an array of the scraped associated jobs
# one "all" variable that holds the categories and info will be pulled from them.

class JobSearch::Category
    @@all = []
    attr_accessor :category_name, :link, :jobs

    def initialize(category_name, link)
        @category_name = category_name
        @link = link
        @jobs = []

        @@all << self
    end

    #returns the jobs that were scraped based on selection
    #a category has many jobs
    def jobs
        @jobs
    end

    #will hold all the categories scraped based on user selection
    def self.all
        @@all
    end

    
end
