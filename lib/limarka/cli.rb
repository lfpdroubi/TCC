require "thor"
require 'pdf_forms'
require 'yaml'
require 'colorize'
require 'open3'

module Limarka

  class Cli < Thor
    default_command :exec

    PDF = "configuracao.pdf"

    def tipo_do_trabalho
      tipo="Monografia"
      if File.exist?(PDF) then
        @pdftk = PdfForms.new 'pdftk'
        pdf = PdfForms::Pdf.new PDF, @pdftk, utf8_fields: true
        tipo = pdf.field('tipo_do_trabalho').value
        if tipo == "Dissertação" then tipo = "Dissertacao" end
      end
      puts "Tipo do trabalho: #{tipo}".green
      tipo
    end

    def target()
      "xxx-#{self.tipo_do_trabalho}.tex"
    end 


    PREAMBULO="templates/preambulo.tex"
    desc "preambulo", "Cria arquivo do preambulo"
    def preambulo
      system "pandoc -f markdown --data-dir=. --template=preambulo templates/configuracao.yaml -o #{PREAMBULO}"
      puts "#{PREAMBULO} criado".green
    end

    PRETEXTUAL = "templates/pretextual.tex"

    desc "pretextual", "Gera conteúdo do pré-textual"
    def pretextual
      pretextual = ""

      necessita_de_arquivo_de_texto = ["errata"]
      ["folha_de_rosto", "errata", "folha_de_aprovacao", "dedicatoria", "agradecimentos", 
      "epigrafe", "resumo", "abstract", "lista_ilustracoes", "lista_tabelas", 
      "lista_siglas", "lista_simbolos", "sumario"].each_with_index do |secao,indice|
        template = "pretextual#{indice+1}-#{secao}"
        arquivo_de_entrada = if necessita_de_arquivo_de_texto.include?(secao) then "#{secao}.md" else "" end
        Open3.popen3("pandoc -f markdown --data-dir=. --template=#{template} -t latex templates/configuracao.yaml #{arquivo_de_entrada}") {|stdin, stdout, stderr, wait_thr|
          pretextual = pretextual + stdout.read
          exit_status = wait_thr.value # Process::Status object returned.
          if(exit_status!=0) then puts ("Erro: " + stderr.read).red end
        }
      end

      File.open(PRETEXTUAL, 'w') { |file| file.write(pretextual) }
      puts "#{PRETEXTUAL} criado".green
    end

    desc "exec", "Executa o sistema para geração do documento latex"
    def exec
      invoke :preambulo
      invoke :pretextual
      invoke :postextual
      invoke :textual
      invoke :compile
    end


    POSTEXTUAL = "templates/postextual.tex"
    desc "postextual","Gera conteúdo do pós-textual"
    def postextual
      # Referências (obrigatório)
      # Glossário (opcional)
      # Apêndice (opcional)
      # Anexo (opcional)
      # Índice (opcional)

      postextual = ""

      necessita_de_arquivo_de_texto = ["referencias", "apendices","anexos"]
      ["referencias", "glossario", "apendices", "anexos", "indice"].each_with_index do |secao,indice|
        template = "postextual#{indice+1}-#{secao}"
        arquivo_de_entrada = if necessita_de_arquivo_de_texto.include?(secao) then "#{secao}.md" else "" end
        Open3.popen3("pandoc -f markdown --data-dir=. --template=#{template} --chapter -t latex templates/configuracao.yaml #{arquivo_de_entrada}") {|stdin, stdout, stderr, wait_thr|
          postextual = postextual + stdout.read
          exit_status = wait_thr.value # Process::Status object returned.
          if(exit_status!=0) then puts ("Erro: " + stderr.read).red end
        }
      end

      File.open(POSTEXTUAL, 'w') { |file| file.write(postextual) }
      puts "#{POSTEXTUAL} criado".green
    end


    def valida_yaml
      metadados = IO.read("templates/configuracao-tecnica.yaml") # Valida o arquivo de metadados
      puts ("configuracao-tecnica.yaml: " + YAML.load(metadados).to_s).green
      metadados = IO.read("templates/configuracao.yaml") # Valida o arquivo de metadados
      puts ("configuracao.yaml: " + YAML.load(metadados).to_s).green
    end


    desc "textual", "Gera xxx-trabalho-academico.tex a partir do arquivo markdown e metadados."
    def textual
      valida_yaml
      #system "pandoc --smart --standalone --wrap=none --data-dir=. -f markdown -t latex trabalho-academico.md metadados/matedados.yaml -o xxx-trabalho-academico.tex"
    # --template=templates/default.latex 
    # --filter=pandoc-citeproc 
    # --template=abntex2-trabalho-academico
      system "pandoc -f markdown -s --normalize --chapter --include-in-header=#{PREAMBULO} --include-before-body=#{PRETEXTUAL}  --include-after-body=#{POSTEXTUAL} templates/configuracao-tecnica.yaml templates/configuracao.yaml trabalho-academico.md -o #{target()}"
    end


    method_option :entrada, :default => "configuracao.pdf", :aliases => "-i", :banner => "FILE"
    method_option :saida, :default => "templates/configuracao.yaml", :aliases => "-o", :banner => "FILE"
    desc "pdfconf", "Ler configuração de arquivo pdf"
    def pdfconf
      
      @pdftk = PdfForms.new 'pdftk'
      pdf = PdfForms::Pdf.new options[:entrada], @pdftk, utf8_fields: true
      h = {} # hash

      # Campos do PDF
      pdf.fields.each do |f|
        value = f.value
        if value == "Off" then value = false end
        if value == "" then value = nil end
        h[f.name] = value
      end

      # Substitui ',' e ';' por '.'
      ['palavras_chave', 'palabras_clave', 'keywords', 'mots_cles'].each do |p|
        if(h[p])
          h[p] = h[p].gsub(/[;,]/, '.')   
        end
      end

      h['monografia'] = h["tipo_do_trabalho"] == "Monografia"
      h["ficha_catalografica"] = h["ficha_catalografica"] == "Incluir ficha-catalografica.pdf da pasta imagens"


      # siglas e simbolos
      ['siglas','simbolos'].each do |sigla_ou_simbolo|
        if (h[sigla_ou_simbolo]) then
          sa = [] # sa: s-array
          h[sigla_ou_simbolo].each_line do |linha|
            s,d = linha.split(":")
            sa << { 's' => s.strip, 'd' => d ? d.strip : ""}
          end
          h[sigla_ou_simbolo] = sa
        end
      end
      

      # shows
      h["errata"] = pdf.field("errata").value == "Utilizar Errata"
      h["folha_de_aprovacao_gerar"] =   pdf.field("folha_de_aprovacao").value == "Gerar folha de aprovação"
      h["folha_de_aprovacao_incluir"] = pdf.field("folha_de_aprovacao").value == "Utilizar folha de aprovação escaneada"
      h["lista_ilustracoes"] = pdf.field("lista_ilustracoes").value == "Gerar lista de ilustrações"
      h["lista_tabelas"] = pdf.field("lista_tabelas").value == "Gerar lista de tabelas"


      # pós-textual
      h['referencias-manual'] = false

      # Escreve na saída
      s = StringIO.new
      s << h.to_yaml
      s << "---\n\n"
      
      if (options['saida'] == '-')
        puts s.string
      else
        File.open(t.name, 'w') { |f| f.write s.string}
        puts "Arquivo criado: #{options['saida']}".green
      end
    end

    desc "compile", "Compila arquivo tex em PDF"
    def compile
      system "latexmk --xelatex #{target()}"
    end


  end
end


