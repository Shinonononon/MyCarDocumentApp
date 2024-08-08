require 'rails_helper'

RSpec.describe "Navigation", type: :system do
  let(:first_department) { FactoryBot.create(:department_first) }
  let!(:super_admin) { FactoryBot.create(:super_admin, department: first_department) }
  let!(:admin) { FactoryBot.create(:admin, department: first_department) }
  let!(:dept_admin) { FactoryBot.create(:dept_admin, department: first_department) }
  let!(:employee) { FactoryBot.create(:first_employee, department: first_department) }

  before do
    driven_by(:rack_test)
  end

  context 'SuperAdminユーザーの場合' do
    before do
      sign_in super_admin
      visit root_path
    end

    it 'Home画面がロールに合わせて正しく表示される' do
      expect(page).to have_link('社員リストへ', href: super_admin_employees_path)
      expect(page).to have_link('部署リストへ', href: departments_path)
      expect(page).to have_link('新しい社員を作成', href: new_super_admin_employee_path)
      expect(page).to have_content 'ユーザーからのQ&A想定'
    end

    it '社員一覧リンクが表示され、正しいページに遷移する' do
      expect(page).to have_link('社員一覧', href: super_admin_employees_path, id: 'SAdmin-EmpList')
      click_link 'SAdmin-EmpList'
      expect(current_path).to eq super_admin_employees_path
    end

    it '部署一覧リンクが表示され、正しいページに遷移する' do
      expect(page).to have_link('部署一覧', href: departments_path, id: 'SAdmin-DeptList')
      click_link 'SAdmin-DeptList'
      expect(current_path).to eq departments_path
    end

    it '新しい社員リンクが表示され、正しいページに遷移する' do
      expect(page).to have_link('新しい社員', href: new_super_admin_employee_path, id: 'SAdmin-NewEmp')
      click_link 'SAdmin-NewEmp'
      expect(current_path).to eq new_super_admin_employee_path
    end
  end

  context 'Adminユーザーの場合' do
    before do
      sign_in admin
      visit root_path
    end

    it 'Home画面がロールに合わせて正しく表示される' do
      expect(page).to have_link('社員リストへ', href: admin_employees_path)
      expect(page).to have_link('部署リストへ', href: departments_path)
      expect(page).to have_link('新しい社員を作成', href: new_admin_employee_path)
      expect(page).to have_content 'ユーザーからのQ&A想定'
    end

    it '社員一覧リンクが表示され、正しいページに遷移する' do
      expect(page).to have_link('社員一覧', href: admin_employees_path, id: 'Admin-EmpList')
      click_link 'Admin-EmpList'
      expect(current_path).to eq admin_employees_path
    end

    it '部署一覧リンクが表示され、正しいページに遷移する' do
      expect(page).to have_link('部署一覧', href: departments_path, id: 'Admin-DeptList')
      click_link 'Admin-DeptList'
      expect(current_path).to eq departments_path
    end

    it '新しい社員リンクが表示され、正しいページに遷移する' do
      expect(page).to have_link('新しい社員', href: new_admin_employee_path, id: 'Admin-NewEmp')
      click_link 'Admin-NewEmp'
      expect(current_path).to eq new_admin_employee_path
    end
  end

  context 'DepartmentAdminユーザーの場合' do
    before do
      sign_in dept_admin
      visit root_path
    end

    it 'Home画面がロールに合わせて正しく表示される' do
      expect(page).to have_link('社員リストへ', href: department_admin_employees_path)
    end

    it '社員一覧リンクが表示され、正しいページに遷移する' do
      expect(page).to have_link('社員一覧', href: department_admin_employees_path, id: 'DeptAdmin-EmpList')
      click_link 'DeptAdmin-EmpList'
      expect(current_path).to eq department_admin_employees_path
    end
  end

  context '一般ユーザーの場合' do
    before do
      sign_in employee
      visit root_path
    end

    it '書類リンクが表示され、正しいページに遷移する' do
      expect(page).to have_link('書類', href: uploads_documents_path, id: 'my-document')
      click_link 'my-document'
      expect(current_path).to eq uploads_documents_path
    end

    it 'マイアカウントリンクが表示され、正しいページに遷移する' do
      expect(page).to have_link('マイアカウント', href: employee_path(employee), id: 'my-account')
      click_link 'my-account'
      expect(current_path).to eq employee_path(employee)
    end
  end

  context 'ログアウトリンクのテスト' do
    before do
      sign_in super_admin
      visit root_path
    end

    it 'ログアウトリンクが表示され、クリックするとログイン画面に遷移する' do
      expect(page).to have_link('ログアウト', href: destroy_employee_session_path, id: 'sign-out')
      click_link 'sign-out'
      expect(current_path).to eq new_employee_session_path
      expect(page).to have_content('ログアウト済みです')
    end
  end

  context '未ログインユーザーの場合' do
    before do
      visit root_path
    end

    it 'ログインリンクが表示され、正しいページに遷移する' do
      expect(page).to have_link('ログイン', href: new_employee_session_path)
      click_link 'ログイン'
      expect(current_path).to eq new_employee_session_path
    end
  end
end
