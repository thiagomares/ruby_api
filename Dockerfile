FROM ruby:3.2

# Dependências do sistema
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libmariadb-dev \
  nodejs

# Diretório de trabalho
WORKDIR /app

# Copiar arquivos do projeto
COPY Gemfile Gemfile.lock ./

# Instalar as gems
RUN bundle install

# Copiar o restante do código do projeto
COPY . .

# Expor a porta padrão do Rails
EXPOSE 3000

# Comando padrão
CMD ["rails", "server", "-b", "0.0.0.0"]
