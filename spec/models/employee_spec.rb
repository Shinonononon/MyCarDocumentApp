require 'rails_helper'

RSpec.describe Employee, type: :model do
  describe 'バリデーション' do
    let(:first_deparment) { FactoryBot.create(:department_first) }
    let!(:employee) { FactoryBot.create(:first_employee, department: first_deparment) }
    it '名前が必要であること' do
      employee.name = nil
      expect(employee).not_to be_valid
    end
    it '名前のカナが必要であること' do
      employee.name_kana = nil
      expect(employee).not_to be_valid
    end

    it '従業員番号が必要であること' do
      employee.employee_number = 'E11111'
      expect(employee).to be_valid
    end

    it '部署IDが必要であること' do
      employee.department = nil
      expect(employee).not_to be_valid
    end
  end

  # describe 'dont_delete_last_super_admin' do
  #   let(:first_deparment) { FactoryBot.create(:department_first) }
  #   let!(:employee) { FactoryBot.create(:super_admin, department: first_deparment) }
  #   context 'スーパーアドミンが一人の時' do
  #     it do
  #   end
  # end


  describe 'ラストのsuper_adminを消したりロール変えられないやつ' do
    let(:first_deparment) { FactoryBot.create(:department_first) }
    let!(:super_admin) { FactoryBot.create(:super_admin, department: first_deparment) }

    context 'スーパーアドミンが一人の時' do
      let!(:first_employee) { FactoryBot.create(:first_employee, department: first_deparment) }
      it 'roleが変更できない' do
        expect(super_admin.can_edit_last_super_admin(1)).to eq false
        expect(super_admin.errors[:base]).to include("スーパー管理者が一人になるため、ロールの編集ができません。")
      end
      it '削除が中断され、エラーメッセージが追加されること' do
        expect {
          super_admin.destroy
        }.not_to change(Employee, :count)
        expect(super_admin.errors[:base]).to include("スーパー管理者が一人になるため、ロールの削除ができませんでした。")
      end
      it '名前とか他の場所は普通に変更可能' do
        super_admin.update(name: 'スーパーアドミンさん', email: 'super_man@example.com', employee_number: 'S12345')
        expect(super_admin.name).to eq 'スーパーアドミンさん'
        expect(super_admin.email).to eq 'super_man@example.com'
        expect(super_admin.employee_number).to eq 'S12345'
      end
      it '普通に他のemployeeはロール変えられる' do
        role = Role.create(name: 'admin')
        first_employee.update_role(role.id)
        expect(first_employee.roles.first.name).to eq 'admin'
      end
      it 'もちろんスーパー管理者にもなれる' do
        first_employee.update_role(super_admin.roles.first.id)
        expect(first_employee.roles.first.name).to eq 'super_admin'
      end
      it '普通に名前も変えられる' do
        first_employee.update(name: '田中')
        expect(first_employee.name).to eq '田中'
      end
      it '普通に消せる' do
        expect { first_employee.destroy }.to change(Employee, :count).by(-1)
        expect(Employee.exists?(first_employee.id)).to be_falsey
      end
    end

    context 'スーパーアドミン二人いる時' do
      let!(:second_employee) { FactoryBot.create(:second_employee, department: first_deparment) }
      before do
        second_employee.update_role(super_admin.roles.first.id)
      end
      it 'trueになる' do
        expect(second_employee.roles.first.name).to eq 'super_admin'
        expect(second_employee.can_edit_last_super_admin(1)).to eq true
      end
    end
  end


  # pending "add some examples to (or delete) #{__FILE__}"


end
