require 'rails_helper'

describe "登録情報変更〜退会", type: :system do
  let!(:admin) { create(:admin) }
  let!(:customer) { create(:customer) }
  let!(:genre) { create(:genre) }
  let!(:item) { create(:item, genre: genre) }

  describe "会員としてログインした場合" do
    before "会員としてログインする" do
      visit new_customer_session_path
      fill_in "customer[email]", with: customer.email
      fill_in "customer[password]", with: customer.password
      click_button "ログイン"
    end
    describe "ヘッダーの画面遷移機能" do
      it "7.トップ画面が表示される,15.トップ画面が表示される" do
        click_link "NaganoCake"
        expect(current_path).to eq "/"
      end
      it "16.マイページに遷移する" do
        click_link "マイページ"
        expect(current_path).to eq "/customer"
      end
      it "商品一覧に遷移する" do
        click_link "商品一覧"
        expect(current_path).to eq "/items"
      end
      it "ログアウトする" do
        click_link "ログアウト"
        expect(current_path).to eq "/"
        expect(page).to have_content "ログアウトしました。"
      end
    end
    describe "商品詳細表示機能" do
      before "トップ画面に遷移し、任意の商品画像を押下する" do
        visit root_path
        find('a[href = "/items/1"]', text: "").click
      end
      it "8.該当商品の詳細画面に遷移する" do
        expect(current_path).to eq "/items/" + item.id.to_s
      end
      it "9.商品情報が正しく表示されている" do
        expect(page).to have_content item.name
        expect(page).to have_content item.description
        expect(page).to have_content item.add_tax_included_price.to_s(:delimited)
      end
    end
    context "配送先一覧画面に遷移した場合" do
      before "配送先一覧画面に遷移する" do
        visit customer_path
        find('a[href = "/shipping_addresses"]', text: "一覧を見る").click
      end
      it "4.配送先一覧画面に遷移する,17.配送先一覧画面に遷移する" do
        expect(current_path).to eq "/shipping_addresses"
      end
      context "配送先を新規登録した場合" do
        before "各項目を入力し、登録ボタンを押下する" do
          visit shipping_addresses_path
          fill_in 'shipping_address[post_code]', with: "9999999"
          fill_in 'shipping_address[address]', with: "z県"
          fill_in 'shipping_address[name]', with: "山田花子"
          click_button "新規登録"
        end
        it "5.自画面が再描画される" do
          expect(current_path).to eq "/shipping_addresses"
        end
        it "6.登録した内容が表示されている,18.「５」で登録した住所が表示されている" do
          expect(page).to have_content "9999999"
          expect(page).to have_content "z県"
          expect(page).to have_content "山田花子"
        end
        context "カートに商品を入れた場合" do
          before "商品ページに遷移し、商品個数を選択後、カートに入れるをクリックする" do
            visit item_path(item)
            select "10", from: "quantity"
            click_button "カートに入れる"
          end
          it "10.カート画面に遷移する" do
            expect(current_path).to eq "/cart_items"
          end
          it "11.カートの中身が正しく表示されている" do
            expect(page).to have_content item.name
            expect(page).to have_content 10
          end
          context "注文情報入力画面に遷移した場合" do
            before "注文情報入力画面に遷移する" do
              visit cart_items_path
              click_link "情報入力に進む"
            end
            it "12.情報入力画面に遷移する" do
              expect(current_path).to eq "/orders/new"
            end
            it "13.「５」で登録した住所が選択できるようになっている" do
              expect(page).to have_select("shipping_address_id", options: [ShippingAddress.last.in_one_line] )
            end
            context "注文を確定した場合" do
              before "任意の支払方法、登録した住所を選択し、購入ボタンを押下する" do
                select ShippingAddress.last.in_one_line, from: "shipping_address_id"
                click_button "保存する"
                click_button "注文を確定する"
              end
              it "14.サンクスページに遷移する" do
                expect(current_path).to eq "/orders/thankyou"
              end
            end
          end
        end
      end
    end
    context "会員編集画面に遷移した場合" do
      before "会員編集画面に遷移する" do
        visit customer_path
        find('a[href = "/customer/edit"]', text: "編集する").click
      end
      it "1.会員情報編集画面に遷移する,20.会員情報編集画面が表示される" do
        expect(current_path).to eq "/customer/edit"
      end
      context "会員情報を変更した場合" do
        before "マイページに遷移し、全項目を変更し、保存ボタンを押下する" do
          visit edit_customer_registration_path
          fill_in 'customer[last_name]', with: "last"
          fill_in 'customer[first_name]', with: "first"
          fill_in 'customer[last_name_kana]', with: "ラスト"
          fill_in 'customer[first_name_kana]', with: "ファースト"
          fill_in 'customer[post_code]', with: "9999999"
          fill_in 'customer[address]', with: "z県"
          fill_in 'customer[phone_number]', with: "99999999999"
          fill_in 'customer[email]', with: "test@test.com"
          click_button "編集内容を保存"
        end
        it "2.マイページに遷移する" do
          expect(current_path).to eq "/customer"
        end
        it "3.変更した内容が表示される" do
          expect(page).to have_content "last"
          expect(page).to have_content "first"
          expect(page).to have_content "ラスト"
          expect(page).to have_content "ファースト"
          expect(page).to have_content "9999999"
          expect(page).to have_content "z県"
          expect(page).to have_content "99999999999"
          expect(page).to have_content "test@test.com"
        end
        context "会員が退会する場合" do
          before "退会ボタンを押下する" do
            visit edit_customer_registration_path
            click_link "退会する"
          end
          it "21.アラートが表示される" do
            expect(current_path).to eq "/customer/withdraw_confirm"
            expect(page).to have_content "本当に退会しますか？"
          end
          context "退会が完了した場合" do
            before "退会を完了する" do
              click_link "退会する"
            end
            it "22.トップ画面に遷移する" do
              expect(current_path).to eq "/"
            end
            it "23.ヘッダが未ログイン状態になっている" do
              expect(page).to have_content "About"
              expect(page).to have_content "商品一覧"
              expect(page).to have_content "sign up"
              expect(page).to have_content "log in"
            end
            it "24.ログイン画面に遷移する,25.ログインが不可" do
              visit new_customer_session_path
              fill_in "customer[email]", with: "test@test.com"
              fill_in "customer[password]", with: customer.password
              click_button "ログイン"
              expect(current_path).to eq "/customer/sign_in"
              expect(page).to have_content "退会済みのアカウントです"
            end
            context "管理者としてログインした場合" do
              before "管理者としてログインする" do
                visit new_admin_session_path
                fill_in "admin[email]", with: admin.email
                fill_in "admin[password]", with: admin.password
                click_button "ログイン"
              end
              it "26.管理者トップ画面(顧客の注文履歴一覧)が表示される" do
                expect(current_path).to eq "/admin"
              end
              context "会員一覧画面に遷移した場合" do
                before "ヘッダから会員一覧画面へのリンクを押下する" do
                  click_link "会員一覧"
                end
                it "27.会員一覧画面が表示される" do
                  expect(current_path).to eq "/admin/customers"
                end
                it "28.「２２」で退会したユーザが「退会」になっている" do
                  expect(page).to have_content "退会"
                end
                context "会員情報詳細画面に遷移した場合" do
                  before "ヘッダから会員一覧画面へのリンクを押下する" do
                    click_link "lastfirst"
                  end
                  it "29.退会したユーザーの会員情報詳細設計画面に遷移する" do
                    expect(current_path).to eq "/admin/customers/" + customer.id.to_s
                  end
                  it "30.「２」で変更した住所が表示されている" do
                    expect(page).to have_content "z県"
                  end
                end
              end
              context "ログアウトした場合" do
                before "ヘッダからログアウトを行う" do
                  click_link "ログアウト"
                end
                it "31.管理者ログイン画面が表示される" do
                  expect(current_path).to eq "/admin/sign_in"
                  expect(page).to have_content "ログアウトしました。"
                end
              end
            end
          end
        end
      end
    end
  end
end