class Worker < BaseClass

    attr_reader :id, :firstname, :lastname, :type

    table_name 'worker'

    column_name 'id', required: true, unique: true, primary_key: true
    column_name 'firstname', required: true
    column_name 'lastname', required: true
    column_name 'type', required: true, default: "normal"
    
    def initialize(hash)
        @id = hash["id"]
        @firstname = hash["firstname"]
        @lastname = hash["lastname"]
        @type = hash["type"]
    end

end