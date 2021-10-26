require 'rails_helper'

describe 'ECサイトテスト', type: :system do
  let(:admin) { create(:admin) }
  let(:customer) { create(:customer) }
  let!(:genre) { create(:genre) }
  let!(:item) { create(:item) }
  before do
    visit root_path
    click_link 'Sign up'
  end
  context '新規登録画面へのリンクを押下する' do
    it '1. 新規登録画面が表示される' do
      expect(current_path).to eq '/customer/sign_up'
    end
  end
  context '必要事項を入力して登録ボタンを押下する' do
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
      click_button '新規登録'
    end
    it '2. マイページに遷移する' do
      expect(current_path).to eq '/customer'
    end
    it '3 & 4. 新規登録画面で入力した情報が表示されており、ヘッダーリンクも更新されている' do
      expect(page).to have_content "test@test.com"
      expect(page).to have_content "test"
      expect(page).to have_content "test1"
      expect(page).to have_content "テスト"
      expect(page).to have_content "テストイ"
      expect(page).to have_content "東京都"
      expect(page).to have_content "0000000"
      expect(page).to have_content "00000000000"
      mypage_link = find_all('a')[1].native.inner_text
      expect(mypage_link).to match(/マイページ/i)
      items_link = find_all('a')[2].native.inner_text
      expect(items_link).to match(/商品一覧/i)
      cart_link = find_all('a')[3].native.inner_text
      expect(cart_link).to match(/カート/i)
      signout_link = find_all('a')[4].native.inner_text
      expect(signout_link).to match(/ログアウト/i)
    end
    context 'ヘッダーのロゴ画像を押下する' do
      before do
        find('a[href="/"]').click
      end
      it '5. トップ画面に遷移する' do
        expect(current_path).to eq '/'
      end
      context '任意の商品画像を押下する' do
        before do
          find('a[href="/items/1"]').click
        end
        it '6 & 7. 該当商品の詳細画面に遷移し、商品情報が正しく表示されている' do
          expect(current_path).to eq '/items/1'
          @item = Item.last
          expect(page).to have_content @item.name
          expect(page).to have_content @item.description
          expect(page).to have_content @item.add_tax_included_price.to_s(:delimited)
          # expect(page).to have_content @item.image
        end
        context '個数を選択し、カートに入れるボタンを押下する' do
          before do
            select(value = "2", from: "quantity")
            click_on 'カートに入れる'
          end
          it '8 & 9. カート画面に遷移し、カートの中身が正しく表示されている' do
            expect(current_path).to eq '/cart_items'
            @item = Item.last
            @cart_item = CartItem.last
            expect(page).to have_content @item.name
            expect(page).to have_content @cart_item.quantity
            expect(page).to have_content @item.add_tax_included_price.to_s(:delimited)
            expect(page).to have_content (@item.add_tax_included_price * @cart_item.quantity).to_s(:delimited)
            # expect(page).to have_content @item.image
          end
          context '買い物を続けるボタンを押下する' do
            it '10. トップ画面に遷移する' do
              click_on '買い物を続ける'
              expect(current_path).to eq '/'
            end
          end
        end
      end
    end
    context 'ヘッダの商品一覧へのリンクを押下する' do
      before do
        click_link '商品一覧'
      end
      it '11. 商品一覧画面に遷移する' do
        expect(current_path).to eq '/items'
      end
      context '任意の商品画像を押下する' do
        before do
          find('a[href="/items/1"]').click
        end
        it '12. 該当商品の詳細画面に遷移し、商品情報が正しい' do
          expect(current_path).to eq '/items/1'
          @item = Item.last
          expect(page).to have_content @item.name
          expect(page).to have_content @item.description
          expect(page).to have_content @item.add_tax_included_price.to_s(:delimited)
        end
        context '個数を選択し、カートに入れるボタンを押下する' do
          before do
            select(value = "1", from: "quantity")
            click_on 'カートに入れる'
          end
          it '13 & 14. カート画面に遷移し、情報が正しく表示されている.' do
            expect(current_path).to eq '/cart_items'
            @item = Item.last
            @cart_item = CartItem.last
            expect(page).to have_content @item.name
            expect(page).to have_content @cart_item.quantity
            expect(page).to have_content @item.add_tax_included_price.to_s(:delimited)
            expect(page).to have_content (@item.add_tax_included_price * @cart_item.quantity).to_s(:delimited)
            # expect(page).to have_content @item.image
          end
          context '商品の個数を変更し、更新ボタンを押下する' do
            before do
              select(value = "2", from: "quantity")
              click_on '変更する'
            end
            it '15. 合計表示が正しく更新される' do
              @item = Item.last
              @cart_item = CartItem.last
              expect(page).to have_content (@item.add_tax_included_price * @cart_item.quantity).to_s(:delimited)
            end
          end
          context '16. 情報入力に進むボタンを押下する' do
            before do
              click_on '情報入力に進む'
            end
            it '情報入力画面に遷移する' do
              expect(current_path).to eq '/orders/new'
            end
            context '支払方法を選択し、住所をテキスト入力し確認画面に進むボタンを押下する、' do
              before do
                choose "payment_method_credit_card"
                choose "address_number_3"
                fill_in 'address', with: "東京都"
                fill_in 'post_code', with: "1234567"
                fill_in 'name', with: "花子"
                click_on '確認画面へ進む'
              end
              it '17 & 18 & 19. 注文確認画面に遷移する' do
                expect(current_path).to eq '/orders/check'
              end
              it '20. 選択した商品、合計金額、配送方法などが表示されている' do
                @cart_item = CartItem.last
                @item = Item.last
                @shipping_address = ShippingAddress.last
                expect(page).to have_content @shipping_address.name
                expect(page).to have_content @shipping_address.address
                expect(page).to have_content @shipping_address.post_code
                expect(page).to have_content "800"
                expect(page).to have_content (@item.add_tax_included_price * @cart_item.quantity + 800).to_s(:delimited)
                expect(page).to have_content "クレジットカード"
              end
              context '注文を確定ボタンを押下する' do
                before do
                  click_button '注文を確定する'
                end
                it '21. サンクスページに遷移する' do
                  expect(current_path).to eq '/orders/thankyou'
                end
                context 'ヘッダのマイページへのリンクを押下する' do
                  before do
                    click_link 'マイページ'
                  end
                  it '22. マイページに遷移する' do
                    expect(current_path).to eq '/customer'
                  end
                  context '注文履歴一覧へのリンクを押下する' do
                    before do
                      find('a[href="/orders"]').click
                    end
                    it '23. 注文履歴一覧画面が表示される' do
                      expect(current_path).to eq '/orders'
                    end
                    context '先ほどの注文の詳細表示ボタンを押下する' do
                      before do
                        click_on '表示する'
                      end
                      it '24. 注文詳細画面が表示される' do
                        expect(current_path).to eq '/orders/1'
                      end
                      it '25. 注文内容が正しく表示されている' do
                        @order = Order.last
                        @order_item = OrderItem.last
                        expect(page).to have_content @order.created_at.strftime("%Y/%m/%d")
                        expect(page).to have_content @order.post_code
                        expect(page).to have_content @order.address
                        expect(page).to have_content @order.name
                        expect(page).to have_content @order.payment_method_i18n
                        expect(page).to have_content @order.order_status_i18n
                        expect(page).to have_content @order_item.item.name
                        expect(page).to have_content @order_item.tax_included_price.to_s(:delimited)
                        expect(page).to have_content @order_item.quantity
                        expect(page).to have_content @order_item.sum_of_price.to_s(:delimited)
                        expect(page).to have_content @order.order_items_total_price.to_s(:delimited)
                        expect(page).to have_content @order.shipping_fee.to_s(:delimited)
                        expect(page).to have_content @order.total_price.to_s(:delimited)
                      end
                      it '26. ステータスが「入金待ち」になっている' do
                        expect(page).to have_content "入金待ち"
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
