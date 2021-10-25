require 'rails_helper'

describe 'adminテスト', type: :system do
  let(:admin) { create(:admin) }
  let(:item) { create(:item) }
  let!(:genre) { create(:genre) }
  before do
    visit new_admin_session_path
    fill_in 'admin[email]', with: admin.email
    fill_in 'admin[password]', with: admin.password
    click_button 'ログイン'
  end
  describe 'ログイン・管理者トップ画面のテスト' do
    context 'メールアドレス・パスワードでログインする' do
      it '1.管理者トップ画面が表示される' do
        expect(current_path).to eq '/admin'
      end
    end
    context 'ヘッダからジャンル一覧へのリンクを押下する' do
      before do
        click_link 'ジャンル一覧'
      end
      it '2.ジャンル一覧画面が表示される' do
        expect(current_path).to eq '/admin/genres'
      end
      context '必要事項を入力し、登録ボタンを押下する' do
        it '3.追加したジャンルが表示されている' do
          fill_in 'genre[name]', with: 'test'
          click_button '新規登録'
          expect(page).to have_content 'test'
        end
      end
      context 'ヘッダから商品一覧へのリンクを押下する' do
        before do
          click_link '商品一覧'
        end
        it '4.商品一覧画面が表示される' do
          expect(current_path).to eq '/admin/items'
        end
        context '新規登録ボタンを押下する' do
          before do
            find('a[href="/admin/items/new"]').click
          end
          it '5.商品新規登録画面が表示される' do
            expect(current_path).to eq '/admin/items/new'
          end
          context '必要事項を入力して登録ボタンを押下する' do
            before do
              select genre.name, from: 'item[genre_id]'
              fill_in 'item[name]', with: Faker::Lorem.characters(number: 5)
              fill_in 'item[description]', with: Faker::Lorem.characters(number: 20)
              fill_in 'item[tax_encluded_price]', with: 1000
              image_path = Rails.root.join('app/assets/images/test.jpg')
              attach_file('item[image]', image_path)
              click_button '新規登録'
            end
            it '6.登録した商品の詳細画面に遷移する' do
              expect(current_path).to eq '/admin/items/' + Item.last.id.to_s
            end
            context 'ヘッダから商品一覧へのリンクを押下する' do
              before do
                click_link '商品一覧'
              end
              it '7.商品一覧画面が表示される' do
                expect(current_path).to eq '/admin/items'
              end
              it '8.登録した商品が表示されている' do
                expect(page).to have_content Item.last.name.to_s
              end
            end
          end
        end
      end
    end
  end
  describe '商品新規登録画面のテスト' do
    context '新規登録ボタンを押下する' do
      before do
        click_link '商品一覧'
        find('a[href="/admin/items/new"]').click
      end
      it '9.商品新規登録画面が表示される' do
        expect(current_path).to eq '/admin/items/new'
      end
      context '必要事項を入力して登録ボタンを押下する' do
        before do
          select genre.name, from: 'item[genre_id]'
          fill_in 'item[name]', with: Faker::Lorem.characters(number: 5)
          fill_in 'item[description]', with: Faker::Lorem.characters(number: 20)
          fill_in 'item[tax_encluded_price]', with: 1000
          image_path = Rails.root.join('app/assets/images/test.jpg')
          attach_file('item[image]', image_path)
          click_button '新規登録'
        end
        it '登録した商品の詳細画面に遷移する' do
          expect(current_path).to eq '/admin/items/' + Item.last.id.to_s
        end
        context '必要事項を入力して登録ボタンを押下する(2商品目)' do
          before do
            click_link '商品一覧'
            find('a[href="/admin/items/new"]').click
            select genre.name, from: 'item[genre_id]'
            fill_in 'item[name]', with: Faker::Lorem.characters(number: 5)
            fill_in 'item[description]', with: Faker::Lorem.characters(number: 20)
            fill_in 'item[tax_encluded_price]', with: 1000
            image_path = Rails.root.join('app/assets/images/test.jpg')
            attach_file('item[image]', image_path)
            click_button '新規登録'
            binding.pry
          end
          it '10.登録した商品の詳細画面に遷移する' do
            expect(current_path).to eq '/admin/items/' + Item.last.id.to_s
          end
          context 'ヘッダから商品一覧へのリンクを押下する' do
            before do
              click_link '商品一覧'
            end
            it '11.商品一覧画面が表示される' do
              expect(current_path).to eq '/admin/items'
            end
            it '12.登録した商品が表示されている' do
              expect(page).to have_content Item.last.name.to_s
            end
          end
          it '13.管理者ログイン画面に遷移する' do
            click_link 'ログアウト'
            expect(current_path).to eq '/admin/sign_in'
          end
        end
      end
    end
  end
end
