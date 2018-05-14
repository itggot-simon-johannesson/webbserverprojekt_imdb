class User < BaseClass

    attr_reader :id, :username, :firstname, :lastname, :mail, :password, :type

    table_name 'user'

    column_name 'id', required: true, unique: true
    column_name 'username', required: true
    column_name 'firstname', required: true
    column_name 'lastname', required: true
    column_name 'mail', required: true, unique: true
    column_name 'password', required: true, crypt: true
    column_name 'type', required: true, default: "normal"
    
    def initialize(hash)
        @id = hash["id"]
        @username = hash["username"]
        @firstname = hash["firstname"]
        @lastname = hash["lastname"]
        @mail = hash["mail"]
        @password = hash["password"]
        @type = hash["type"]
    end

    def self.login(params)
        db = SQLite3::Database.open('db/imdb.sqlite')
        user = User.get(params["mail"], "mail", false)
        if !user || BCrypt::Password.new(user.password) != params["password"]
            return false
        end
        return user
    end

end