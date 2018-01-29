class Users

    attr_reader :firstname, :lastname, :username, :mail, :password, :id

    def initialize(array)
        @firstname = array[0]
        @lastname = array[1]
        @username = array[2]
        @mail = array[3]
        @password = array[4]
        @id = array[5]
    end

    def self.create(user_info)
        db = SQLite3::Database.open('db/imdb.sqlite')
        empty = []
        
        firstname = user_info[0]
        lastname = user_info[1]
        username = user_info[2]
        mail = user_info[3]
        password = user_info[4]
    
        if db.execute('SELECT username FROM users WHERE username IS ?', username) == empty or db.execute('SELECT mail FROM users WHERE mail IS ?', mail) == empty
            password = BCrypt::Password.create(password)
            user_info = db.execute('INSERT INTO users (username, firstname, lastname, mail, password) VALUES (?, ?, ?, ?, ?)', [username, firstname, lastname, mail, password])
            return Users.new(user_info)
        else
            puts "ERROR: USER ALREADY EXISTS"
        end

    end

    def self.login(user_info)
        db = SQLite3::Database.open('db/imdb.sqlite')
        empty = []

        mail = user_info[0]
        password = user_info[1]

        if db.execute('SELECT mail FROM users WHERE mail IS ?', mail) == empty
            puts "ERROR: USER DOES NOT EXIST"
        else
            if  db.execute('SELECT ', )
            end
        end


    end

end