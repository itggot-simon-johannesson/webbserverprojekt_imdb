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
    
        if db.execute('SELECT username FROM users WHERE username IS ?', username).first.first == empty and db.execute('SELECT mail FROM users WHERE mail IS ?', mail).first.first == empty
            password = BCrypt::Password.create(password)
            user_info = db.execute('INSERT INTO users (username, firstname, lastname, mail, password) VALUES (?, ?, ?, ?, ?)', [username, firstname, lastname, mail, password])
            return Users.new(user_info)
        else
            puts "ERROR: USER ALREADY EXISTS"
        end

    end

    def self.login(user_info, session)
        db = SQLite3::Database.open('db/imdb.sqlite')
        empty = []

        mail = user_info[0]
        password = user_info[1]

        encrypted_password = db.execute('SELECT password FROM users WHERE mail IS ?', mail).first.first
        uncrypted_password = BCrypt::Password.new(crypted_password)

        if db.execute('SELECT mail FROM users WHERE mail IS ?', mail) == empty or uncrypted_password != password
            puts "ERROR: WRONG MAIL OR PASSWORD"
        else
            session[:name] = mail
            session[:login] = true
            puts "SUXES"
        end


    end

end