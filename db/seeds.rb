Category.create(:name => "Single")
Category.create(:name => "Plural")
Category.create(:name => "Stage")
Category.create(:name => "Full Game")
Category.create(:name => "Player")

User.create(
  :login => "Blargel",
  :email => "LargeBagel@gmail.com",
  :password => "asdfjkl;",
  :password_confirmation => "asdfjkl;",
  :admin => true
)