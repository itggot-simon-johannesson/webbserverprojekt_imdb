class BaseClass

    def self.table_name(name)
        @table_name = name
    end

    def self.column_name(names, options = nil)
        @column_names ||= {}
        @column_names[names] = options
    end

    # def initialize(hash)
    #     @column_names.keys.each do |column_name|
    #         instance_variable_set("@#{column_name}", hash["#{column_name}"])
    #         p "@#{column_name}"
    #     end
    # end

    def self.exist?(value, column_name, like)
        empty = []

        if @column_names.has_key?(column_name)
            db = SQLite3::Database.open('db/imdb.sqlite')
            db.results_as_hash = true

            if like == true
                value = "%#{value}%"
                result_from_db = db.execute("SELECT * FROM #{@table_name} WHERE #{column_name} LIKE ?", value)
                result_from_db_new = []

                if result_from_db == empty
                    return false
                else
                    result_from_db.each_with_index do |value, i|
                        result_from_db_new << (result_from_db[i].select { |key| key.class == String })
                    end
                    
                    return result_from_db_new
                end

            else
                result_from_db = db.execute("SELECT * FROM #{@table_name} WHERE #{column_name} IS ?", value)


                if result_from_db == empty
                    return false
                else
                    return result_from_db.first.select { |key| key.class == String }
                end

            end
            
        else
            return false
        end        
    end

    def self.get(value, column_name, like)

        result_from_db = self.exist?(value, column_name, like)

        if result_from_db == false
            false
        end

        if result_from_db.kind_of?(Array)
            result_from_db_new = []
            result_from_db.each do |object|
                result_from_db_new << self.new(object)
            end

            return result_from_db_new

        elsif result_from_db
            return self.new(result_from_db)
        else
            return false
        end
    end

    def self.remove(value, column_name, like)
        
        result_from_db = self.exist?(value, column_name, like)

        if result_from_db
            db = SQLite3::Database.open('db/imdb.sqlite')

            if like == true
                value = "%#{value}%"
                db.execute("DELETE FROM #{@table_name} WHERE #{column_name} LIKE ?", value)
            else
                db.execute("DELETE FROM #{@table_name} WHERE #{column_name} IS ?", value)
            end
           
            return true
        else
            return false
        end
    end

    def self.create(params)
        column_names = @column_names
        db = SQLite3::Database.open('db/imdb.sqlite')
        
        column_names.each do |column_name|
            
            params["type"] = column_name[1][:default] if column_name[1][:default]

            if column_name[1][:primary_key]
                
            end

            if column_name[1][:required] and column_name[0] != "id"
                return "#{column_name[0]} is not filled in" if params[column_name[0]] == nil
            end

            if column_name[1][:unique] and column_name[0] != "id"
                result_from_db = self.exist?(params[column_name[0]], column_name[0], false)
                return "#{column_name[0]} already exists" if result_from_db
            end

            if column_name[1][:crypt]
                params[column_name[0]] = BCrypt::Password.create(params[column_name[0]])
            end

        end

        columns = params.keys.join(", ")
        values = params.values.join("', '")
        db.execute("INSERT INTO #{@table_name} (#{columns}) VALUES ('#{values}')")

        return true

    end

end