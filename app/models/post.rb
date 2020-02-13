require 'net/http'
require 'json'

class Post < ApplicationRecord
  belongs_to :user

  class << self
    def face_detect (image)
      uri = URI('https://face-resemble.cognitiveservices.azure.com/face/v1.0/detect')
      uri.query = URI.encode_www_form({
        # Request parameters
        'returnFaceId' => 'true',
        'returnFaceLandmarks' => 'false',
        'returnFaceAttributes' => 'emotion',
        'recognitionModel' => 'recognition_01',
        'returnRecognitionModel' => 'false',
        'detectionModel' => 'detection_01'
      })

      request = Net::HTTP::Post.new(uri.request_uri)

      # Request headers
      request['Ocp-Apim-Subscription-Key'] = ENV['FACE_API_KEY']
      request['Content-Type']              = 'application/json'

      imageUri = image
      request.body = "{\"url\": \"" + imageUri + "\"}"

      response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
        http.request(request)
      end

      face = JSON.parse(response.body)

      if face.length == 0
        return nil
      end

      emotion = face[0]['faceAttributes']['emotion'].max { |x, y| x[1] <=> y[1] }

      return emotion[0]
    end
  end
end
