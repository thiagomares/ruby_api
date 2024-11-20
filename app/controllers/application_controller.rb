class ApplicationController < ActionController::API
  # Verifica o usuário autenticado com base no token JWT
  def current_user
    @current_user ||= begin
      token = request.headers["Authorization"]&.split(" ")&.last  # Obtém o token do cabeçalho Authorization
      decoded = AuthenticationService.decode(token)  # Decodifica o token
      Usuario.find_by(id: decoded&.[]("user_id"))  # Retorna o usuário com o ID decodificado
    end
  end

  # Verifica se o usuário está autenticado, se não, retorna erro
  def authenticate_user!
    if current_user.nil?
      render json: { error: "Não autorizado - Token inválido ou ausente" }, status: :unauthorized
    end
  end
end
