module Users
  class GetUserCommand

    USERS = [
      { id: 1, name:'Tori', email: 'tori.wood@grpc.com'},
      { id: 2, name:'Max', email: 'max.wood@sleepyboi.co'}
    ]

    def self.get_user(email)
      USERS.find{ |user| user[:email] == email }
    end
  end
end
