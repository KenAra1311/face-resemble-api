require "rails_helper"

RSpec.describe User, type: :model do
  it "ユーザ名、メアド、パスワード（uid）がある場合、有効である" do
    user = User.new(
      name: "test",
      email: "test@example.com",
      uid: "testuid",
    )
    expect(user.save).to be_truthy
  end

  it "ユーザ名がない場合、無効である" do
    user = User.new(
      name: nil,
      email: "test@example.com",
      uid: "testuid",
    )
    expect(user.save).to be_falsey
  end

  it "メアドがない場合、無効である" do
    user = User.new(
      name: "test",
      email: nil,
      uid: "testuid",
    )
    expect(user.save).to be_falsey
  end

  it "パスワード（uid）がない場合、無効である" do
    user = User.new(
      name: "test",
      email: "test@example.com",
      uid: nil,
    )
    expect(user.save).to be_falsey
  end

  it "ユーザ名が16文字以上の場合、無効である" do
    user = User.new(
      name: "test_test_test_test",
      email: "test@example.com",
      uid: "testuid",
    )
    expect(user.save).to be_falsey
  end

  it "メールアドレスが32文字以上の場合、無効である" do
    user = User.new(
      name: "test",
      email: "test.1234567890.sample@example.com",
      uid: "testuid",
    )
    expect(user.save).to be_falsey
  end

  it "メールアドレスが重複している場合、無効である" do
    user_a = User.new(
      name: "test_a",
      email: "test@example.com",
      uid: "testuid",
    )
    user_a.save
    user_b = User.new(
      name: "test_b",
      email: "test@example.com",
      uid: "testuid",
    )
    expect(user_b.save).to be_falsey
  end
  
  it "メールアドレスがフォーマット通りではない場合、無効である" do
    user = User.new(
      name: "test",
      email: "test",
      uid: "testuid",
    )
    expect(user.save).to be_falsey
  end

  it "パスワードが6文字以下の場合、無効である" do
    user = User.new(
      name: "test",
      email: "test@example.com",
      uid: "test",
    )
    expect(user.save).to be_falsey
  end

  it "パスワードが32文字以上の場合、無効である" do
    user = User.new(
      name: "test",
      email: "test@example.com",
      uid: "testuid_testuid_testuid_testuid_testuid",
    )
    expect(user.save).to be_falsey
  end

  it "ユーザを削除すると、そのユーザの投稿も削除されること" do
    user = User.create(name: "test", email: "test@example.com", uid: "testuid")
    # ユーザが投稿したとする
    user.posts.create(title: "テスト", image: "test.jpg")

    expect{ user.destroy }.to change{ Post.count }.by(-1)
  end

  it "ユーザを削除すると、そのユーザのいいねも削除されること" do
    user_a = User.create(name: "test_a", email: "test1@example.com", uid: "testuid")
    user_b = User.create(name: "test_b", email: "test2@example.com", uid: "testuid")
    # ユーザAが投稿したとする
    user_a.posts.create(title: "テスト", image: "test.jpg")
    # ユーザBがユーザAの投稿に対していいねしたとする
    user_b.likes.create(user_id: 2, post_id: 1)

    expect{ user_b.destroy }.to change{ Like.count }.by(-1)
  end
end
