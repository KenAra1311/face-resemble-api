require "rails_helper"

RSpec.describe Like, type: :model do
  it "別のユーザの投稿に対していいねをした場合、有効である" do
    user_a = User.create(name: "test_a", email: "test1@example.com", uid: "testuid")
    user_b = User.create(name: "test_b", email: "test2@example.com", uid: "testuid")
    # ユーザAが投稿したとする
    user_a.posts.create(title: "テスト", image: "test.jpg")
    # ユーザBがユーザAの投稿に対していいねしたとする
    like = user_b.likes.create(user_id: 2, post_id: 1)

    expect(like.save).to be_truthy
  end
  it "別のユーザの投稿に対して2回以上いいねをした場合、無効である" do
    user_a = User.create(name: "test_a", email: "test1@example.com", uid: "testuid")
    user_b = User.create(name: "test_b", email: "test2@example.com", uid: "testuid")
    # ユーザAが投稿したとする
    user_a.posts.create(title: "テスト", image: "test.jpg")
    # ユーザBがユーザAの投稿に対していいねしたとする
    like_a = user_b.likes.create(user_id: 2, post_id: 1)
    like_a.save
    like_b = user_b.likes.create(user_id: 2, post_id: 1)

    expect(like_b.save).to be_falsey
  end
end
