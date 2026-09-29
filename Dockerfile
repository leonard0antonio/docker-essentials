# 1. FROM: Define a imagem base. Deve ser a primeira instrução do arquivo (exceto por ARG).
# Usamos o Alpine Linux por ser extremamente enxuto (cerca de 5MB) e seguro.
FROM alpine:3.18

# 2. LABEL: Adiciona metadados à imagem (autor, versão, descrição).
# Excelente prática para organização, auditoria e filtros em repositórios de imagens.
LABEL maintainer="Leonardo Antonio" \
      version="1.0" \
      description="Referência profissional das principais instruções de um Dockerfile."

# 3. ENV: Define variáveis de ambiente que estarão disponíveis durante o build e na execução do container.
# Facilita a manutenção, permitindo alterar caminhos e configurações em um só lugar.
ENV APP_HOME=/app \
    APP_ENV=production

# 4. WORKDIR: Define o diretório de trabalho padrão para as instruções RUN, CMD, ENTRYPOINT, COPY e ADD.
# Se o diretório não existir, o Docker o criará automaticamente.
WORKDIR $APP_HOME

# 5. RUN: Executa comandos no shell durante o processo de build da imagem.
# Geralmente usado para instalar pacotes. Encadeamos comandos com '&&' para criar apenas uma camada (layer) na imagem, otimizando o tamanho final.
RUN apk update && \
    apk add --no-cache curl python3 && \
    echo "Dependências instaladas com sucesso!" > setup_log.txt

# 6. COPY: Copia arquivos ou diretórios da sua máquina host para dentro do container.
# É a instrução recomendada no lugar do ADD para cópias simples, pois seu comportamento é mais transparente.
# (Para testar o build depois, crie um arquivo requirements.txt vazio na mesma pasta).
COPY requirements.txt ./

# 7. ADD: Semelhante ao COPY, mas possui superpoderes: extrai arquivos .tar automaticamente e pode baixar arquivos de URLs.
# A documentação oficial recomenda usar o COPY sempre que possível, reservando o ADD apenas quando precisar desses recursos extras.
ADD https://raw.githubusercontent.com/moby/moby/master/README.md ./readme_docker.md

# 8. VOLUME: Cria um ponto de montagem, sinalizando que os dados neste diretório devem persistir.
# Os dados salvos aqui sobrevivem ao ciclo de vida do container (ideal para bancos de dados ou logs).
VOLUME ["/app/data"]

# 9. EXPOSE: Informa ao Docker que o container escuta na porta especificada em tempo de execução.
# Importante: O EXPOSE funciona apenas como uma documentação. Ele não publica a porta no host automaticamente (isso é feito com a flag -p no docker run).
EXPOSE 8080

# 10. ENTRYPOINT: Configura o container para rodar como um executável.
# O comando definido aqui é a base do container e não é facilmente sobrescrito ao rodar um `docker run`.
ENTRYPOINT ["python3"]

# 11. CMD: Fornece os argumentos padrão para o ENTRYPOINT, ou o comando principal se não houver ENTRYPOINT.
# Diferente do ENTRYPOINT, o CMD é facilmente sobrescrito se você passar argumentos no final do comando `docker run`.
# Neste exemplo, estamos iniciando um servidor web simples nativo do Python na porta 8080.
CMD ["-m", "http.server", "8080"]