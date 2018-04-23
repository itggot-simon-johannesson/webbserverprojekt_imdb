class BaseClass

    def self.table_name(name)
        @table_name = name
    end

    def self.column_name(names, options = nil)
        @column_names ||= {}
        @column_names[names] = options
    end

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

    #INTE KLAR
    def self.create(params)
        params
        column_names = @column_names
        result_from_db = self.exist?(params[column_name.first], column_names.first, false)
        
        column_names.each do |column_name|

            if column_name[1][:unique]
                if result_from_db
                    return "#{column_name} already exists"
                end
            end

            if column_name[1][:crypt]

            end

            if column_name[1][:required]
                if 
                end
            end 


        end   
        
        # db = SQLite3::Database.open('db/imdb.sqlite')

        # db.execute("
            
        #     INSERT INTO #{@table_name}
        #     (
                
        #     )
            
            
        #     ")

    end




end