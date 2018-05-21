class Film < BaseClass

    attr_reader :id, :title

    table_name 'film'

    column_name 'id', required: true, unique: true
    column_name 'title', required: true

    def initialize(hash)
        @id = hash["id"]
        @title = hash["title"]
    end

end