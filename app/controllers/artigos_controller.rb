class ArtigosController < ApplicationController
  cache_action :index, expires_in: 5.minutes

  def index
    @artigos = Artigo.all
    artigos_json = @artigos.map do |artigo|
      {
        titulo: artigo.titulo,
        texto: artigo.body
      }
    end
    render json: artigos_json
  end

  def testa_valores
    if 1 == 1
      render json: { titulo: "olá, mundo" }
    end
  end

  def show
    begin
      @artigo = Artigo.find(params[:id])
      cookies[:ultimo_artigo] = {value: @artigo.titulo, expires: 30.minutes.from_now}
      render json: {titulo: @artigo.titulo, texto: @artigo.body}
    rescue ActiveRecord::RecordNotFound
      render json: {msg: 'Artigo Não encontrado'}
    end
  end

  def novo_artigo
    @artigo = Artigo.new
  end

  def create
    @artigo = Artigo.new(artigo_params)

    if @artigo.save
      redirect_to @artigo
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    begin
      @artigo = Artigo.find(params[:id])
      @artigo.destroy
      render json: {msg: 'Artigo Removido com sucesso'}
    rescue ActiveRecord::RecordNotFound
      render json: {msg: 'Artigo não encontrado'}
    end
  end
  private
  def artigo_params
    params.require(:artigo).permit(:titulo, :body, :metadata)
  end
end