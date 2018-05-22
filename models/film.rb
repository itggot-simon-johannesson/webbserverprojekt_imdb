class Film < BaseClass

    attr_reader :id, :title

    table_name 'film'

    column_name 'id', required: true, unique: true, primary_key: true
    column_name 'title', required: true

    

end