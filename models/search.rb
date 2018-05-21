class Search

    # attr_reader :search, :film, :user, :worker

    # def initialize(hash)
    #     @search = hash["search"]
    #     @film = hash["film"]
    #     @user = hash["user"]
    #     @worker = hash["worker"]
    # end

    def self.path(filter)

        path = "/search?"

        filter.each_with_index do |setting, i|

            path += "#{filter.keys[i]}=#{filter.values[i]}&"
            
        end

        return path[0..-2].gsub!(" ", "#{" ".encode}")

    end

end