Validação da nova feature de cupom de desconto no carrinho

Este repositório possui casos de teste em procedural e BDD, além dos arquivos necessários para automação dos testes com Robot Framework.

Como rodar?

Instalar o python (caso ainda não tenha)
https://www.python.org/downloads/

Instalar o Robot Framework
  pip install robotframework

Instalar as Librarys String e SeleniumLibrary
  pip install --upgrade robotframework-seleniumlibrary string

Instalar o webdriver do chrome
  pip install chromedriver

Clonar o repositório
  git clone https://github.com/nicolleaf/teste-li.git

Com tudo instalado, para rodar os testes no console da IDE ou Terminal 
  robot -d ./results tests\TestDiscountCupon.robot
  
  
