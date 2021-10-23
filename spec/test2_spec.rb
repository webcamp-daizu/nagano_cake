require 'rails_helper'

describe 'ECサイトテスト', type: :system do
  let(:admin) { create(:admin) }
  let(:customer) { create(:customer) }
  let!(:genre) { create(:genre) }
  let!(:item) { create(:item) }

  before do
    visit root_path
  end

  describe 'トップページのテスト' do
    context '表示画面の確認' do
      it '1.新規登録画面が表示される' do
        click_link 'sign up'
        expect(current_path).to eq '/customer/sign_up'
      end
    end
  end


  describe '新規登録画面のテスト' do
    before do
      visit new_customer_registration_path
      fill_in 'customer[email]', with: "test@test.com"
      fill_in 'customer[last_name]', with: "test"
      fill_in 'customer[first_name]', with: "test1"
      fill_in 'customer[last_name_kana]', with: "テスト"
      fill_in 'customer[first_name_kana]', with: "テストイ"
      fill_in 'customer[address]', with: "東京都"
      fill_in 'customer[post_code]', with: "0000000"
      fill_in 'customer[phone_number]', with: "00000000000"
      fill_in 'customer[password]', with: 'password'
      fill_in 'customer[password_confirmation]', with: 'password'
    end
    context '表示画面の確認' do
      it '2.マイページに遷移する' do
        expect { click_button '新規登録' }.to change(Customer.all, :count).by(1)
        expect(current_path).to eq '/customer'
      end
    end
    context '表示画面の確認' do
      it '3 & 4.新規登録画面で入力した情報が表示されており、ヘッダーリンクも更新されている' do
        click_button '新規登録'
        expect(page).to have_content "test@test.com"
        expect(page).to have_content "test"
        expect(page).to have_content "test1"
        expect(page).to have_content "テスト"
        expect(page).to have_content "テストイ"
        expect(page).to have_content "東京都"
        expect(page).to have_content "0000000"
        expect(page).to have_content "00000000000"
        mypage_link = find_all('a')[2].native.inner_text
        expect(mypage_link).to match(/マイページ/i)
        items_link = find_all('a')[3].native.inner_text
        expect(items_link).to match(/商品一覧/i)
        cart_link = find_all('a')[4].native.inner_text
        expect(cart_link).to match(/カート/i)
        signout_link = find_all('a')[5].native.inner_text
        expect(signout_link).to match(/ログアウト/i)
        click_link 'NaganoCake'
        expect(current_path).to eq '/'
        click_link find_all('a')[6]
        expect(items_link).to match(/商品一覧/i)
      end
    end
  end

end
