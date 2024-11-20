class AuthenticationController < ApplicationController
  # Adicionando o recurso para autenticação de login
  def login
    usuario = Usuario.find_by(email: params[:email])

    if usuario && usuario.authenticate(params[:password])
      token = generate_jwt(usuario) # Gerando um token JWT (JSON Web Token)
      render json: { message: "Login bem-sucedido", token: token }, status: :ok
    else
      render json: { message: "Credenciais inválidas" }, status: :unauthorized
    end
  end

  private

  # Função para gerar o token JWT
  def generate_jwt(usuario)
    JWT.encode({ usuario_id: usuario.id, exp: 24.hours.from_now.to_i }, Rails.application.secret_key_base)
  end
end
