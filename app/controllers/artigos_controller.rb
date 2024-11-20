class ArtigosController < ApplicationController


  def index
    cache_key = 'artigos#index'

    # Busca no cache; se não encontrar, consulta o banco e armazena no cache.
    artigos_json = Rails.cache.fetch(cache_key, expires_in: 10.minutes) do
      @artigos = Artigo.all
      @artigos.map do |artigo|
        {
          titulo: artigo.titulo,
          texto: artigo.body
        }
      end
    end

    # Renderiza o JSON (já cacheado ou gerado)
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

  def clear_index_cache
    Rails.cache.delete('artigos#index')
  end
end
