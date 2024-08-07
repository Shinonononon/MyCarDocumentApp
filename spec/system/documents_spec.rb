require 'rails_helper'

RSpec.describe "Documents", type: :system do
  let(:first_department) { FactoryBot.create(:department_first) }
  let!(:employee1) { FactoryBot.create(:first_employee, department: first_department) }
  let!(:employee2) { FactoryBot.create(:second_employee, department: first_department) }
  before do
    driven_by(:rack_test)
  end

  describe '書類提出テスト' do
    context '手順を踏んで提出' do
      before do
        sign_in employee1
        visit root_path
      end
      it 'そもそもボタンちゃんとある？' do
        expect(page).to have_content '新規提出をはじめる'
      end
      it 'ページ移る？' do
        click_link '新規提出をはじめる'
        expect(page).to have_content '免許証 提出画面'
      end
      it 'ルートから最後の提出まで' do
        click_link '新規提出をはじめる'
        fill_in '有効期限', with: "2024-11-11"
        click_button '保存'
        expect(page).to have_content '車検証 提出画面'
        fill_in '有効期限', with: "2024-11-11"
        click_button '保存'
        expect(page).to have_content '自賠責保険 提出画面'
        fill_in '有効期限', with: "2024-11-11"
        click_button '保存'
        expect(page).to have_content '任意保険 提出画面'
        fill_in '有効期限', with: "2024-11-11"
        click_button '保存'
        expect(page).to have_content '提出された書類の有効期限一覧'
      end
      it '提出してないと書類ないよね？' do
        visit uploads_documents_path(employee1)
        expect(page).to have_content '提出されている免許証はありません。'
        expect(page).to have_content '提出されている車検証はありません。'
        expect(page).to have_content '提出されている自賠責保険はありません。'
        expect(page).to have_content '提出されている任意保険はありません。'
      end
    end

    context 'すでに書類を持っている場合' do
      let!(:driver_license) { create(:driver_license, employee: employee2) }
      let!(:vehicle_inspection) { create(:vehicle_inspection, employee: employee2) }
      let!(:compulsory_insurance) { create(:compulsory_insurance, employee: employee2) }
      let!(:optional_insurance) { create(:optional_insurance, employee: employee2) }
      before do
        sign_in employee2
        visit root_path
      end
      it 'ルートパスには書類ページへボタン' do
        expect(page).to have_content '書類ページへ'
      end
      it 'ちゃんとデータある？' do
        visit uploads_documents_path(employee2) # 実際に免許証を表示するページに遷移
        expect(page).to have_content('有効期限:')
        expect(page).to have_content(driver_license.expiration_date)
        expect(page).to have_content(vehicle_inspection.expiration_date)
        expect(page).to have_content(compulsory_insurance.expiration_date)
        expect(page).to have_content(optional_insurance.expiration_date)
      end
    end
  end
  # モデルスペックだと一々面倒なのでここでバリデーションテストします
  describe 'バリデーション働いてる？' do
    context '過去の日付で提出できない' do
      before do
        sign_in employee1
      end
      it '免許証出す時' do
        visit new_uploads_driver_license_path
        fill_in '有効期限', with: Date.today - 1.month
        click_button '保存'
        expect(page).to have_content "過去の日付では提出できません。書類の更新をしてください。"
      end
      it '車検証出す時' do
        visit new_uploads_vehicle_inspection_path
        fill_in '有効期限', with: Date.today - 1.month
        click_button '保存'
        expect(page).to have_content "過去の日付では提出できません。書類の更新をしてください。"
      end
      it '自賠責保険出す時' do
        visit new_uploads_compulsory_insurance_path
        fill_in '有効期限', with: Date.today - 1.month
        click_button '保存'
        expect(page).to have_content "過去の日付では提出できません。書類の更新をしてください。"
      end
      it '任意保険出す時' do
        visit new_uploads_optional_insurance_path
        fill_in '有効期限', with: Date.today - 1.month
        click_button '保存'
        expect(page).to have_content "過去の日付では提出できません。書類の更新をしてください。"
      end
    end
  end

  # pending "add some scenarios (or delete) #{__FILE__}"
end
