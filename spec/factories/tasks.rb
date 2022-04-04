FactoryBot.define do
  factory :task do
    name { 'テストを書く' }
    description { 'RSpec&Capybara&FactoryBotを準備する' }
    # user.rbで定義した:userという名前のFactoryをについて、Taskモデルに定義されたuserという名前の関連を生成するのに利用する.名前の類推。
    user
  end
end