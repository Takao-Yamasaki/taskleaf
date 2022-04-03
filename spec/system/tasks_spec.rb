require 'rails_helper'

describe 'タスク管理機能', type: :system do
  describe '一覧表示機能' do
    before do
      # ユーザーAを作成しておく（テストデータの準備）
      user_a = FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com')
      # 作成者がユーザーAであるタスクを作成しておく（テストデータの準備）
      FactoryBot.create(:task, name: '最初のタスク', user: user_a)
    end

    context 'ユーザーがログインしているとき' do
      before do
        # ユーザーAでブラウザからログインする（前提となっているユーザーを操作しておく）
        # ログイン画面にアクセスする
        visit login_path
        # メールアドレスを入力する
        fill_in 'メールアドレス', with: 'a@example.com'
        # パスワードを入力する
        fill_in 'パスワード', with: 'password'
        # 「ログインする」ボタンを押す
        click_button 'ログインする'
      end

      it 'ユーザーAが作成したタスクが表示される' do
        # 作成済みのタスクの名称が画面上に表示されていることの確認
        expect(page).to have_content '最初のタスク'
      end
    end

    context 'ユーザーBがログインしているとき' do
      before do
        FactoryBot.create(:user, name: 'ユーザーB', email: 'b@example.com')
        visit login_path
        fill_in 'メールアドレス', with: 'b@example.com'
        fill_in 'パスワード', with: 'password'
        click_button 'ログインする'
      end
      it 'ユーザーAが作成したタスクが表示されていない' do
        expect(page).to have_no_content '最初のタスク'
      end
    end
  end
end