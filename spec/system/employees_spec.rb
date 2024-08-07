require 'rails_helper'

RSpec.describe "Employees", type: :system do
  let(:first_department) { FactoryBot.create(:department_first) }
  let!(:super_admin) { FactoryBot.create(:super_admin, department: first_department) }
  let!(:dept_admin) { FactoryBot.create(:dept_admin, department: first_department) }
  let!(:employee) { FactoryBot.create(:first_employee, department: first_department) }
  before do
    driven_by(:rack_test)
  end

  describe '複数ユーザーアクセス' do
    context '制限がかかっている場所にアクセスした場合' do
      it '制限されたページにアクセスできない' do
        sign_in dept_admin
        visit admin_employees_path
        expect(page).to have_content 'アクセス権限がありません'
      end
    end
  end

  # describe '合法ログイン' do
  #   before do
  #     sign_in employee
  #   end

  #   context '合法的にログインした場合' do
  #     # it 'Homeに遷移し、「ログインしました」というメッセージが表示される' do
  #     #   expect(current_path).to eq root_path
  #     #   expect(page).to have_content 'ログインしました。'
  #     # end
  #     it 'ログアウトするとログイン画面に遷移し、「ログアウトしました」というメッセージが表示される' do
  #       click_link 'sign-out'
  #       expect(current_path).to eq new_employee_session_path
  #       expect(page).to have_content 'ログアウト済みです'
  #     end
  #   end
  # end

  describe 'General違法ログイン' do
    before do
      sign_in employee
    end

    context "違法でアクセスしようとした場合" do
      it 'スーパーアドミンの画面に違法アクセスしようとすると弾かれる' do
        visit super_admin_employees_path
        expect(current_path).to eq pages_index_path
        expect(page).to have_content 'アクセス権限がありません'
      end

      it 'アドミンの画面に違法アクセスしようとすると弾かれる' do
        visit admin_employees_path
        expect(current_path).to eq pages_index_path
        expect(page).to have_content 'アクセス権限がありません'
      end

      it '部署アドミンの画面に違法アクセスしようとすると弾かれる' do
        visit department_admin_employees_path
        expect(current_path).to eq pages_index_path
        expect(page).to have_content 'アクセス権限がありません'
      end
    end

    context "違法でNewEmployeeしようとした場合" do
      it 'そもそもnew_adminにアクセスできない' do
        visit new_admin_employee_path
        expect(current_path).not_to eq new_admin_employee_path
        expect(page).to have_content 'アクセス権限がありません'
      end

      it 'そもそもnew_super_adminにアクセスできない' do
        visit new_super_admin_employee_path
        expect(current_path).not_to eq new_super_admin_employee_path
        expect(page).to have_content 'アクセス権限がありません'
      end

      it '無理やり作ろうとしても無駄ですよ' do
        page.driver.post admin_employees_path, params: {
          employee: {
            name: "New User",
            name_kana: "にゅーゆーざー",
            employee_number: "N12345",
            email: "newuser@example.com",
            password: "password",
            password_confirmation: "password",
            department_id: first_department.id
          }
        }
        expect(Employee.find_by(email: "newuser@example.com")).to be_nil
        expect(Employee.find_by(name: "New User")).to be_nil
        expect(Employee.find_by(employee_number: "N12345")).to be_nil
      end
    end
  end

  describe '部署アドミン違法ログイン' do
    before do
      sign_in dept_admin
    end

    context "違法でアクセスしようとした場合" do
      it 'スーパーアドミンの画面に違法アクセスしようとすると弾かれる' do
        visit super_admin_employees_path
        expect(current_path).to eq pages_index_path
        expect(page).to have_content 'アクセス権限がありません'
      end

      it 'アドミンの画面に違法アクセスしようとすると弾かれる' do
        visit admin_employees_path
        expect(current_path).to eq pages_index_path
        expect(page).to have_content 'アクセス権限がありません'
      end
    end

    context "違法でNewEmployeeしようとした場合" do
      it 'そもそもnew_adminにアクセスできない' do
        visit new_admin_employee_path
        expect(current_path).not_to eq new_admin_employee_path
        expect(page).to have_content 'アクセス権限がありません'
      end

      it 'そもそもnew_super_adminにアクセスできない' do
        visit new_super_admin_employee_path
        expect(current_path).not_to eq new_super_admin_employee_path
        expect(page).to have_content 'アクセス権限がありません'
      end

      it '無理やり作ろうとしても無駄ですよ' do
        page.driver.post admin_employees_path, params: {
          employee: {
            name: "New User",
            name_kana: "にゅーゆーざー",
            employee_number: "N12345",
            email: "newuser@example.com",
            password: "password",
            password_confirmation: "password",
            department_id: first_department.id
          }
        }
        expect(Employee.find_by(email: "newuser@example.com")).to be_nil
        expect(Employee.find_by(name: "New User")).to be_nil
        expect(Employee.find_by(employee_number: "N12345")).to be_nil
      end
    end
  end

  describe 'SuperAdminの動作テスト' do
    before do
      sign_in super_admin
    end

    context 'indexページ' do
      it '従業員の一覧が表示される' do
        visit super_admin_employees_path
        expect(page).to have_content(employee.name)
        expect(page).to have_content(employee.employee_number)
        expect(page).to have_content(first_department.name)
      end

      it '名前で従業員を検索できる' do
        visit super_admin_employees_path
        fill_in 'search_name', with: employee.name
        click_button '検索'
        expect(page).to have_content(employee.name)
      end
    end

    context 'showページ' do
      it '従業員の詳細が表示される' do
        visit super_admin_employee_path(employee)
        expect(page).to have_content(employee.name)
        expect(page).to have_content(employee.employee_number)
        expect(page).to have_content(first_department.name)
      end
    end

    context 'createページ' do
      it '新しい従業員を作成できる' do
        visit new_super_admin_employee_path

        fill_in 'employee_name', with: '新しい従業員'
        fill_in 'employee_name_kana', with: 'シンエイジョウギン'
        fill_in 'employee_employee_number', with: 'E67890'
        fill_in 'employee_email', with: 'new.employee@example.com'
        fill_in 'employee_password', with: 'password'
        fill_in 'employee_password_confirmation', with: 'password'
        select first_department.name, from: 'employee_department_id'
        click_button "社員を作成"

        expect(page).to have_content('アカウントが作成されました')
        expect(page).to have_content('新しい従業員')
      end
    end

    context 'editページ' do
      it '既存の従業員を更新できる' do
        visit edit_super_admin_employee_path(employee)

        fill_in 'employee_name', with: '更新された従業員'
        fill_in 'employee_password', with: 'aaabbb'
        fill_in 'employee_password_confirmation', with: 'aaabbb'
        click_button '編集'

        expect(page).to have_content('アカウントが更新されました')
        expect(page).to have_content('更新された従業員')
      end
    end

    describe 'SuperAdminの動作テスト' do
      context 'destroy' do
        it '従業員を削除できる' do
          visit super_admin_employee_path(employee)
          click_link '削除'
          expect(page).to have_content 'アカウントが削除されました'
        end
      end
    end
  end
end
