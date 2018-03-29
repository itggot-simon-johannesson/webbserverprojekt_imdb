class Films < BaseClass

    attr_reader :id, :title

    table_name 'films'

    def initialize(array)
        @id = array[0]
        @title = array[1]
    end

    def self.create(title)
        db = SQLite3::Database.open('db/imdb.sqlite')

        db.execute('INSERT INTO films (id, title) VALUES (?, ?)', [nil, title])
        info = db.execute('SELECT * FROM films WHERE title IS ?', title).first
        puts "SUXSES!"
        return Films.new(info)
    end

    def self.info_by_id(id)
        db = SQLite3::Database.open('db/imdb.sqlite')
        film_info = db.execute('SELECT * FROM films WHERE id IS ?', id).first
        return Films.new(film_info)
    end

    def self.info_by_title(title)
        db = SQLite3::Database.open('db/imdb.sqlite')

        if db.execute("SELECT * FROM films WHERE title LIKE ? ", title.downcase)[0] == nil
            return nil
        else
            films_info = []
            films = db.execute("SELECT * FROM films WHERE title LIKE ? ", title.downcase)

            films.each do |film|
                films_info << Films.new(film)
            end

            return films_info
        end

    end



end