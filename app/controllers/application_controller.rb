class ApplicationController < ActionController::API

  rescue_from JWT::ExpiredSignature, with: :render_jwt_time_out
  rescue_from JWT::DecodeError, with: :render_jwt_error
  rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid
  rescue_from RailsParam::Param::InvalidParameterError, with: :render_params_invalid
  rescue_from AuthError, with: :render_jwt_auth_error
  rescue_from BadRequestError, with: :render_bad_request_error
  rescue_from DryValidationError, with: :render_dry_validation_request_error
  rescue_from ObjectError, with: :render_object_error
  rescue_from ActiveRecord::RecordNotFound, with: :render_object_not_found
  rescue_from ServerError, with: :render_server_error

  protected
    def render_jwt_time_out
      render json: ErrorHelper.error!(I18n.t("messages.authentication.timeout"), 401), status: 401
    end

    def render_jwt_error(error)
      render json: ErrorHelper.error!(error, 401), status: 401
    end

    def render_jwt_auth_error(error)
      render json: ErrorHelper.error!(I18n.t("messages.http._401"), 401), status: 401
    end

    def render_record_invalid(error)
      render json: ErrorHelper.error!(error, 400), status: 400
    end

    def render_params_invalid(error)
      render json: ErrorHelper.error!(error, 400), status: 400
    end

    def render_bad_request_error(error)
      render json: ErrorHelper.error!(error, 400), status: 400
    end

    def render_dry_validation_request_error(error)
      render json: JSON.parse(error.to_json), status: 400
    end

    def render_object_error(error)
      render json: ErrorHelper.error!(error, 404), status: 404
    end

    def render_object_not_found(error)
      render json: ErrorHelper.error!(error.message, 404), status: 404
    end

    def render_server_error
      render json: ErrorHelper.error!("server error", 500), status: 500
    end
end
