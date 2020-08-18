require 'rails_helper'

RSpec.describe "チャットールームの削除機能", type: :system do
  before do
    @room = FactoryBot.build(:room)
    @room_user = FactoryBot.create(:room_user)
  end

  it 'チャットルームを削除すると、関連するメッセージがすべて削除されていること' do
    # サインインする
    sign_in(@room_user.user)

    # 作成されたチャットルームへ遷移する
    click_on(@room_user.room.name)

    # メッセージ情報を5つDBに追加する
    expect{
      5.times do |i|
        #FactoryBot.create(:message, room_id: @room_user.room.id, user_id: @room_user.user.id)
        fill_in 'message_content', with: Faker::Lorem.sentence
        find('input[type = "submit"]').click
      end
    }.to change { @room_user.room.messages.count }.by(5)

    # 「チャットを終了する」ボタンをクリックすることで、作成した5つのメッセージが削除されていることを期待する
    expect{
      find_link("チャットを終了する",  href: room_path(@room_user.room)).click
    }.to change { @room_user.room.messages.count }.by(-5)

    # ルートページに遷移されることを期待する
    expect(current_path).to eq root_path
  end
end