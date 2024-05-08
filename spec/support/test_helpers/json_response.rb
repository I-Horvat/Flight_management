module TestHelpers
  module JsonResponse
    def json_body
      JSON.parse(response.body)
    end

    def api_headers
      {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'HTTP_X_API_SERIALIZER_ROOT': 1
      }
    end
  end
end
