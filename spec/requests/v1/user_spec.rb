require "rails_helper"

describe "UserAPI", type: :request do
  it "user を全て取得する" do
    10.times do |i|
      User.create(name: "test", email: "test#{i}@example.com", uid: "testuid")
    end

    get "/v1/users"
    json = JSON.parse(response.body)

    # リクエスト成功を表す200が返ってきたか確認
    expect(response.status).to eq(200)
    # 正しい数の user が返されたか確認
    expect(json[0].length).to eq(10)
  end
  it "user を id で絞り、1つだけ取得する" do
    user = User.create(name: "test", email: "test@example.com", uid: "testuid")

    get "/v1/users?id=#{user.id}"
    json = JSON.parse(response.body)

    # リクエスト成功を表す200が返ってきたか確認
    expect(response.status).to eq(200)
    # 要求した特定の user のみ取得したか確認
    expect(json[0]['name']).to eq(user.name)
  end
  it "user を uid で絞り、1つだけ取得する" do
    user = User.create(name: "test", email: "test@example.com", uid: "testuid")

    get "/v1/users?uid=#{user.uid}"
    json = JSON.parse(response.body)

    # リクエスト成功を表す200が返ってきたか確認
    expect(response.status).to eq(200)
    # 要求した特定の user のみ取得したか確認
    expect(json['name']).to eq(user.name)
  end
  it "user を作成する" do
    valid_params = { name: "test", email: "test@example.com", uid: "testuid" }

    #データが作成されている事を確認
    expect{ post "/v1/users", params: { user: valid_params } }.to change{ User.count }.by(+1)
    # リクエスト成功を表す201が返ってきたか確認
    expect(response.status).to eq(201)
  end
  it 'user の編集を行う' do
    user = User.create(name: "test", email: "test@example.com", uid: "testuid")

    put "/v1/users/#{user.id}", params: { user: { name: 'new-test' } }
    json = JSON.parse(response.body)

    # リクエスト成功を表す200が返ってきたか確認
    expect(response.status).to eq(200)
    # データ（ユーザ名）が更新されている事を確認
    expect(json['name']).to eq('new-test')
  end
  # 以下のテストは cloudinary API に接続するため、少し処理が重いです
  it 'user のプロフィール画像が登録されてある場合、プロフィール画像の削除を行う' do
    user = User.create(name: "test", email: "test@example.com", uid: "testuid", profile_image: "cloudinary/test.jpg", file_name: "test.jpg")

    put "/v1/users/#{user.id}", params: { user: { profile_image: nil, file_name: nil } }
    json = JSON.parse(response.body)

    # リクエスト成功を表す200が返ってきたか確認
    expect(response.status).to eq(200)
    # プロフィール画像関連のデータが削除されている事を確認
    expect(json['profile_image']).to eq(nil)
    expect(json['file_name']).to eq(nil)
  end
  it 'user を削除する' do
    user = User.create(name: "test", email: "test@example.com", uid: "testuid")

    # データが削除されているか確認
    expect{ delete "/v1/users/#{user.id}" }.to change{ User.count }.by(-1)
    # リクエスト成功を表す200が返ってきたか確認
    expect(response.status).to eq(200)
  end
end
