class BaseClass

    def initialize(array)

        @id = array[0]
        @username = array[1]
        @firstname = array[2]
        @lastname = array[3]
        @mail = array[4]
        @password = array[5]
        @type = array[6]
    end

    def self.get(column_name, value, like)
        db = SQLite3::Database.open('db/imdb.sqlite')

        if like
            value = "%" + value + "%"
            like = "like"
        else
            like = "is"
        end

        if !column_name or !value
            return "hello"
        end

        db.results_as_hash = true
        result_from_db = db.execute("SELECT * FROM #{@table_name} WHERE #{column_name} #{like} ?", value).first
        p result_from_db = result_from_db.select { |key| key.class == String }
        return self.new(result_from_db)
    end


    # def self.info_by_id(id)
    #     db = SQLite3::Database.open('db/imdb.sqlite')
    #     db.results_as_hash = true
    #     result_from_db = db.execute("SELECT * FROM #{@table_name} WHERE id IS ?", id).first
    #     p result_from_db = result_from_db.select { |key| key.class == String }
    #     return self.new(result_from_db)
    # end

    def self.table_name(name)
        @table_name = name
    end


end