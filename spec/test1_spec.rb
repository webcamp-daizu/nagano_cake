require 'rails_helper'

describe 'adminテスト', type: :system do
  let(:admin) { create(:admin) }
  let(:item) { create(:item) }
  let!(:genre) { create(:genre) }
  before do
    visit new_admin_session_path
    fill_in 'admin[email]', with: admin.email
    fill_in 'admin[password]', with: admin.password
    click_button 'Log in'
  end


  describe 'ログイン・管理者トップ画面のテスト' do
    context '表示画面の確認' do
      it '1.管理者トップ画面が表示される' do
        expect(current_path).to eq '/admin'
      end
      it '2.ジャンル一覧画面が表示される' do
        click_link 'ジャンル一覧'
        expect(current_path).to eq '/admin/genres'
      end
      it '13.管理者ログイン画面に遷移する' do
        click_link 'ログアウト'
        expect(current_path).to eq '/admin/sign_in'
      end
    end
  end


  describe 'ジャンル一覧画面のテスト' do
    before do
      visit admin_genres_path
    end
    context 'ボタン・リンクの確認' do
      it '3.追加したジャンルが表示されている' do
        fill_in 'genre[name]', with: 'test'
        click_button '新規登録'
        expect(page).to have_content 'test'
      end
      it '4.商品一覧画面が表示される' do
        click_on '商品一覧'
        expect(current_path).to eq '/admin/items'
      end
    end
  end


  describe '商品一覧画面のテスト' do
    before do
      visit admin_items_path
    end
    context 'ボタン・リンクの確認' do
      it '5.商品新規登録画面が表示される' do
        click_on '新規登録'
        expect(current_path).to eq '/admin/items/new'
      end
    end
  end


  describe '商品新規登録画面のテスト' do
    2.times do
      before do
        visit new_admin_item_path
      end
      context 'ボタン・リンクの確認' do
        before do
          select genre.name, from: 'item[genre_id]'
          fill_in 'item[name]', with: Faker::Lorem.characters(number: 5)
          fill_in 'item[description]', with: Faker::Lorem.characters(number: 20)
          fill_in 'item[tax_encluded_price]', with: 1000
          image_path = Rails.root.join('app/assets/images/test.jpg')
          attach_file('item[image]', image_path)
        end
        it '自分の新しい投稿が正しく保存される' do
          expect { click_button '新規登録' }.to change(Item, :count).by(1)
        end
        it '6.登録した商品の詳細画面に遷移する' do
          click_button '新規登録'
          expect(current_path).to eq '/admin/items/' + Item.last.id.to_s
        end
        it '8.登録した商品が表示されている' do
          click_button '新規登録'
          visit admin_items_path
          expect(page).to have_content Item.last.name.to_s
        end
      end
    end
  end


  describe '商品詳細画面のテスト' do
    before do
      visit admin_items_path(item)
    end
    context 'ボタン・リンクの確認' do
      it '7.商品一覧画面が表示される' do
        click_on '商品一覧'
        expect(current_path).to eq '/admin/items'
      end
    end
  end


end
