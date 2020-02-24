require "rails_helper"

describe "LikeAPI", type: :request do
  before do
    # ユーザの登録
    user_a = User.create(name: "test_a", email: "test1@example.com", uid: "testuid")
    user_b = User.create(name: "test_b", email: "test2@example.com", uid: "testuid")
    # 各ユーザが投稿したとする
    user_a.posts.create(title: "テスト", image: "test1.jpg")
    user_b.posts.create(title: "テスト", image: "test2.jpg")
    # 各ユーザが別ユーザの投稿に対していいねしたとする
    user_a.likes.create(user_id: 1, post_id: 2)
    user_b.likes.create(user_id: 2, post_id: 1)
  end

  it "like を全て取得する" do
    get "/v1/likes"
    json = JSON.parse(response.body)

    # リクエスト成功を表す200が返ってきたか確認
    expect(response.status).to eq(200)
    # 正しい数の user が返されたか確認
    expect(json.length).to eq(2)
  end

  it "like を作成する" do
    user_c = User.create(name: "test_c", email: "test3@example.com", uid: "testuid")
    # ユーザCがユーザAの投稿に対していいねしたとする
    valid_params = { user_id: 3, post_id: 1 }

    # データが作成されている事を確認
    expect{ post "/v1/likes", params: { like: valid_params } }.to change{ Like.count }.by(+1)
    # リクエスト成功を表す201が返ってきたか確認
    expect(response.status).to eq(201)
  end

  it "like を作成した数だけ post の count の数値が +1 する" do
    # ユーザを追加で10人作成する
    for i in 3..12 do
      User.create(name: "test", email: "test#{i}@example.com", uid: "testuid")
    end
    # それぞれのユーザがユーザAの投稿に対していいねしたとする
    for i in 3..12 do
      post "/v1/likes", params: { like: { user_id: i, post_id: 1 } }
    end

    # リクエスト成功を表す201が返ってきたか確認
    expect(response.status).to eq(201)

    # ユーザAの post の count を取得
    get "/v1/posts?id=1"
    json = JSON.parse(response.body)

    # リクエスト成功を表す200が返ってきたか確認
    expect(response.status).to eq(200)
    # 正しい数の user が返されたか確認
    expect(json[0]['count']).to eq(10)
  end

  it "like を削除する" do
    # データが削除されているか確認
    expect{ delete "/v1/likes/1" }.to change{ Like.count }.by(-1)
    # リクエスト成功を表す200が返ってきたか確認
    expect(response.status).to eq(200)
  end

  it "like を削除した数だけ post の count の数値が -1 する" do
    # データが削除されているか確認
    expect{ delete "/v1/likes/1" }.to change{ Like.count }.by(-1)
    # リクエスト成功を表す200が返ってきたか確認
    expect(response.status).to eq(200)

    # ユーザBの post の count を取得
    get "/v1/posts?id=2"
    json = JSON.parse(response.body)

    # リクエスト成功を表す200が返ってきたか確認
    expect(response.status).to eq(200)
    # 正しい数の user が返されたか確認
    expect(json[0]['count']).to eq(-1)
  end
end
