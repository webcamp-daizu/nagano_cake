FactoryBot.define do
  factory :customer do
    email {"testtest@test.com"}
    password {"111111"}
    password_confirmation {"111111"}
    last_name {"test"}
    first_name {"test1"}
    last_name_kana {"テスト"}
    first_name_kana {"テスト"}
    address {"a県"}
    post_code {"0000000"}
    phone_number {"00000000000"}
  end
end