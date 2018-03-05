class Users

    attr_reader :id, :username, :firstname, :lastname, :mail, :password, :type

    def initialize(array)
        @id = array[0]
        @username = array[1]
        @firstname = array[2]
        @lastname = array[3]
        @mail = array[4]
        @password = array[5] 
        @type = array[6]   
    end

    def self.create(user_info)
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

    def self.login(user_info, session)
        db = SQLite3::Database.open('db/imdb.sqlite')
        empty = []

        mail = user_info[0]
        password = user_info[1]

        if db.execute('SELECT password FROM users WHERE mail IS ?', mail) == empty
            puts "ERROR: WRONG MAIL OR PASSWORD"
            return
        else
            encrypted_password = db.execute('SELECT password FROM users WHERE mail IS ?', mail).first.first
            uncrypted_password = BCrypt::Password.new(encrypted_password)
        end

        if db.execute('SELECT mail FROM users WHERE mail IS ?', mail) == empty or uncrypted_password != password
            puts "ERROR: WRONG MAIL OR PASSWORD"
        else
            session[:mail] =  mail
            session[:login] = true
            puts "SUXES"
        end
    end

    def self.info_by_id(id)
        db = SQLite3::Database.open('db/imdb.sqlite')
        user_info = db.execute('SELECT * FROM users WHERE id IS ?', id).first
        return Users.new(user_info)
    end

    def self.info_by_mail(mail)
        db = SQLite3::Database.open('db/imdb.sqlite')
        user_info = db.execute('SELECT * FROM users WHERE mail IS ?', mail).first
        return Users.new(user_info)
    end

end