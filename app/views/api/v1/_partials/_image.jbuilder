json.thumb "#{ENV["UPLOADER_SERVER_BASE_URL"]}#{image&.picture.url(:thumb)}"
json.medium  "#{ENV["UPLOADER_SERVER_BASE_URL"]}#{image&.picture.url(:medium)}"
json.original  "#{ENV["UPLOADER_SERVER_BASE_URL"]}#{image&.picture.url(:original)}"
