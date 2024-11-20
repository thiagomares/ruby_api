class SessionsController < ApplicationController
  def create
    usuario = Usuario.find_by(email: params[:email])

    if usuario&.authenticate(params[:senha])  # Supondo que você tenha o método `authenticate` para verificar a senha
      token = encode_token(usuario.id)  # Gera o token JWT
      render json: { token: token }, status: :ok
    else
      render json: { error: "Credenciais inválidas" }, status: :unauthorized
    end
  end

  private

  def encode_token(user_id)
    payload = { user_id: user_id }
    JWT.encode(payload, Rails.application.secret_key_base, "HS256")  # Gera o token JWT com a chave secreta
  end
end
