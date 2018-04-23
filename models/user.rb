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

    def self.login(submitted_mail, submitted_password)
        db = SQLite3::Database.open('db/imdb.sqlite')
        user = Users.info_by_mail(submitted_mail)
        if !user || BCrypt::Password.new(user.password) != submitted_password
            return false
        end
        return user
    end

    def self.create_old(user_info)
        db = SQLite3::Database.open('db/imdb.sqlite')
        empty = []
        
        username = user_info[0]
        firstname = user_info[1]
        lastname = user_info[2]
        mail = user_info[3]
        password = user_info[4]
        type = "normal"
    
        if db.execute('SELECT username FROM users WHERE username IS ?', username) == empty and db.execute('SELECT mail FROM users WHERE mail IS ?', mail) == empty
            password = BCrypt::Password.create(password)
            user_info = db.execute('INSERT INTO users (username, firstname, lastname, mail, password, type) VALUES (?, ?, ?, ?, ?, ?)', [username, firstname, lastname, mail, password, type])
            puts "SUXSES!"
            return Users.new(user_info)
        else
            puts "ERROR: USER ALREADY EXISTS"
        end

    end

end