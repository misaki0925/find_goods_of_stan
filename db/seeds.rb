@member = ["高地優吾", "京本大我", "田中樹", "松村北斗", "ジェシー", "森本慎太郎"]
@member.each do |member|
Member.create!{
  name: "#{member}"
}
end

User.create!{
  email: ENV["EMAIL"]
  password: ENV["PASSWORD"]
}
