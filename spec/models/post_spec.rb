require "rails_helper"

RSpec.describe Post, type: :model do
  it "タイトル、画像がある場合、有効である" do
    user = User.create(name: "test", email: "test@example.com", uid: "testuid")
    # ユーザが投稿したとする
    post = user.posts.create(
      title: "テスト",
      image: "test.jpg"
    )
    expect(post.save).to be_truthy
  end
  
  it "タイトルがない場合、無効である" do
    user = User.create(name: "test", email: "test@example.com", uid: "testuid")
    # ユーザが投稿したとする
    post = user.posts.create(
      title: nil,
      image: "test.jpg"
    )
    expect(post.save).to be_falsey
  end

  it "画像がない場合、無効である" do
    user = User.create(name: "test", email: "test@example.com", uid: "testuid")
    # ユーザが投稿したとする
    post = user.posts.create(
      title: "test",
      image: nil
    )
    expect(post.save).to be_falsey
  end

  it "画像が重複している場合、無効である" do
    user = User.create(name: "test", email: "test@example.com", uid: "testuid")
    # ユーザが投稿したとする
    post_a = user.posts.create(
      title: "test",
      image: "test.jpg"
    )
    post_b = user.posts.create(
      title: "test",
      image: "test.jpg"
    )
    expect(post_b.save).to be_falsey
  end

  it "タイトルが32文字以上の場合、無効である" do
    user = User.create(name: "test", email: "test@example.com", uid: "testuid")
    # ユーザが投稿したとする
    post = user.posts.create(
      title: "テストテストテストテストテストテストテストテストテストテストテスト",
      image: "test.jpg"
    )
    expect(post.save).to be_falsey
  end

  it "コンテンツが255文字以上の場合、無効である" do
    user = User.create(name: "test", email: "test@example.com", uid: "testuid")
    # ユーザが投稿したとする
    post = user.posts.create(
      title: "テスト",
      image: "test.jpg",
      content: "テキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキスト"
    )
    expect(post.save).to be_falsey
  end

  it "投稿を削除すると、その投稿のいいねも削除されること" do
    user_a = User.create(name: "test_a", email: "test1@example.com", uid: "testuid")
    user_b = User.create(name: "test_b", email: "test2@example.com", uid: "testuid")
    # ユーザAが投稿したとする
    post = user_a.posts.create(title: "テスト", image: "test.jpg")
    # ユーザBがユーザAの投稿に対していいねしたとする
    user_b.likes.create(user_id: 2, post_id: 1)

    expect{ post.destroy }.to change{ Like.count }.by(-1)
  end
end
