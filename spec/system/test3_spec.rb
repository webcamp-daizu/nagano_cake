require 'rails_helper'

describe "製作～発送", type: :system do
  let!(:admin) { create(:admin) }
  let!(:customer) { create(:customer) }
  let!(:genre) { create(:genre) }
  let!(:item) { create(:item, genre: genre) }
  let!(:order) { create(:order, customer: customer) }
  let!(:order_item) { create(:order_item, order: order, item: item) }

  context "管理者としてログインした場合" do
    before "管理者としてログインする" do
      visit new_admin_session_path
      fill_in "admin[email]", with: admin.email
      fill_in "admin[password]", with: admin.password
      click_button "ログイン"
    end
    describe "画面遷移機能" do
      it "1.トップ画面が表示される" do
        expect(current_path).to eq "/admin"
      end
      it "2.注文詳細画面が表示される" do
        click_link order.created_at.strftime("%Y/%m/%d %H:%M:%S")
        expect(current_path).to eq "/admin/orders/" + order.id.to_s
      end
      it "7.管理者ログイン画面に遷移する" do
        click_link "ログアウト"
        expect(current_path).to eq "/admin/sign_in"
      end
    end
    context "注文詳細画面に遷移した場合" do
      before do
        visit admin_order_path(order)
      end
      it "3.注文ステータスが「入金確認」、製作ステータスが「製作待ち」に更新される" do
        select "入金確認", from: "order[order_status]"
        page.all(".btn-success")[0].click
        expect(page).to have_select("order_item[make_status]", selected: "製作待ち")
      end
      it "4.注文ステータスが「製作中」に更新される" do
        select "製作中", from: "order_item[make_status]"
        page.all(".btn-success")[1].click
        expect(page).to have_select("order[order_status]", selected: "製作中")
      end
      it "5.注文ステータスが「発送準備中」に更新される" do
        select "製作完了", from: "order_item[make_status]"
        page.all(".btn-success")[1].click
        expect(page).to have_select("order[order_status]", selected: "発送準備中")
      end
      context "注文ステータスを発送済みに変更した場合" do
        before do
          select "発送済み", from: "order[order_status]"
          page.all(".btn-success")[0].click
        end
        it "6.注文ステータスが「発送済み」に更新される" do
          expect(page).to have_select("order[order_status]", selected: "発送済み")
        end
        context "会員としログインした場合" do
          before "会員としてログインする" do
            visit new_customer_session_path
            fill_in "customer[email]", with: customer.email
            fill_in "customer[password]", with: customer.password
            click_button "ログイン"
          end
          describe "ヘッダー変更機能" do
            it "9.ヘッダがログイン後の表示に変わっている" do
              expect(page).to have_content "ようこそ、" + customer.full_name + "さん！"
            end
          end
          describe "ヘッダーの画面遷移機能" do
            it "8.トップ画面に遷移する" do
              expect(current_path).to eq "/"
            end
            it "10.マイページが表示される" do
              click_link "マイページ"
              expect(current_path).to eq "/customer"
            end
            it "11.注文履歴一覧に遷移する" do
              visit customer_path
              find('a[href = "/orders"]', text: "一覧を見る").click
              expect(current_path).to eq "/orders"
            end
            it "12.注文履歴詳細画面に遷移する" do
              visit orders_path
              find("a", text: "表示する").click
              expect(current_path).to eq "/orders/" + order.id.to_s
            end
          end
          describe "注文ステータス変更機能" do
            it "13.注文のステータスが「発送済み」になっている" do
              visit order_path(order)
              expect(page).to have_content "発送済み"
            end
          end
        end
      end
    end
  end
end