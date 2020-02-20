require "rails_helper"

describe "PostAPI", type: :request do
  it "post を全て取得する" do
    user = User.create(name: "test", email: "test@example.com", uid: "testuid")
    10.times do |i|
      user.posts.create(title: "テスト", image: "test#{i}.jpg")
    end

    get "/v1/posts"
    json = JSON.parse(response.body)

    # リクエスト成功を表す200が返ってきたか確認
    expect(response.status).to eq(200)
    # 正しい数の user が返されたか確認
    expect(json.length).to eq(10)
  end
  it "post を user_id で絞り、取得する" do
    user = User.create(name: "test", email: "test@example.com", uid: "testuid")
    post = user.posts.create(title: "テスト", image: "test.jpg")

    get "/v1/posts?user_id=#{user.id}"
    json = JSON.parse(response.body)

    # リクエスト成功を表す200が返ってきたか確認
    expect(response.status).to eq(200)
    # 要求した特定の user のみ取得したか確認
    expect(json[0]['title']).to eq(post.title)
  end
  it "post を作成する" do
    user = User.create(name: "test", email: "test@example.com", uid: "testuid")
    valid_params = { title: "テスト", image: "https://res.cloudinary.com/hpcbhm1bd/image/upload/v1581986740/profile_images/Kingdom_Hearts_In_High_Definition_eqek0r.jpg", user_id: user.id }

    # データが作成されている事を確認
    expect{ post "/v1/posts", params: { post: valid_params } }.to change{ Post.count }.by(+1)
    # リクエスト成功を表す201が返ってきたか確認
    expect(response.status).to eq(201)
  end
  # 以下のテストは cloudinary API に接続するため、少し処理が重いです
  it 'post を削除する' do
    user = User.create(name: "test", email: "test@example.com", uid: "testuid")
    post = user.posts.create(title: "テスト", image: "cloudinary/test.jpg", file_name: "test.jpg")

    # データが削除されているか確認
    expect{ delete "/v1/posts/#{post.id}" }.to change{ Post.count }.by(-1)
    # リクエスト成功を表す200が返ってきたか確認
    expect(response.status).to eq(200)
  end
end
