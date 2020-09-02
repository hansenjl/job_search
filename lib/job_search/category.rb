# will contain attr accessors for links and name of category
# IMPORTANT: A Method called Jobs, that will return the associated Jobs; will be an array of the scraped associated jobs
# one "all" variable that holds the categories and info will be pulled from them.

class JobSearch::Category
    @@all = []
    attr_accessor :link, :category_name

    def initialize(link, category_name)
        @link = link
        @category_name = category_name
    end

    def jobs

    end

    # should hold all categories and info will be pulled from them.
    def self.all
        @@all
    end
end
