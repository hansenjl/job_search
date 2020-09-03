class JobSearch::Category

    @@all = [] #all categories


    attr_accessor :category_name, :link, :jobs

    def initialize(category_name, link)
        @category_name = category_name
        @link = link
        @@all << self
    end

    def jobs  #select the jobs that belong to this instance of a category
        JobSearch::Job.all.select do |job|
            job.category == self
        end
    end

    #will hold all the categories scraped based on user selection
    def self.all
        @@all
    end

    def self.destroy_all
        @@all.clear
    end

end
