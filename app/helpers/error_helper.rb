class ErrorHelper
  # error format Helper
  # @param messages [String] message of error
  # @param code [Integer] status of error and client response
  def self.error!(messages, code)
    { response: messages, status: code }
  end
end
