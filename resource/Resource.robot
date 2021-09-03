*** Settings ***
Library  SeleniumLibrary
Library  String

*** Variables ***
${URL}                 https://qastoredesafio.lojaintegrada.com.br/
${BROWSER}             chrome
${HOME_TITLE}          QA Store Desafio
${CART_TITLE}          Carrinho - QA Store Desafio
${CEP_VALIDO}          88034-389
${CUPOM_FRETEGRATIS}   fretegratis
${CUPOM_INEXISTENTE}   99off
${CUPOM_30REAIS}       30reais
${DESCONTO_30REAIS}    30.00
${CUPOM_10OFF}         10off        

*** Keywords ***

### SETUP E TEARDOWN 

Abrir Navegador 
    Open Browser  about:blank  ${BROWSER}

Fechar navegador
    Close Browser

Acessar a página home do cliente
    Go to                           ${URL} 
    Wait Until Element is Visible   css=#listagemProdutos > ul > li:nth-child(1)
    Title Should Be                 ${HOME_TITLE}

### Adicionar produto qualquer ao carrinho

Acessar a página do primeiro produto disponível
    Click Element                    xpath=//*[@id="listagemProdutos"]/ul/li[1]/ul/li[1]/div/a
    Wait Until Element is Visible    css=#imagemProduto
    Page Should Contain Element      css=#imagemProduto

Adicionar produto ao carrinho
    Wait Until Element is Visible    xpath=/html/body/div[3]/div[2]/div/div[1]/div/div[1]/div[2]/div/div[2]/div[3]/a
    Click Link                       xpath=/html/body/div[3]/div[2]/div/div[1]/div/div[1]/div[2]/div/div[2]/div[3]/a

Redirecionar para a página de carrinho com o produto adicionado na lista de itens
    Wait Until Element is Visible    css=#corpo > div > div.secao-principal.row-fluid
    Title Should Be                  ${CART_TITLE}
    Page Should Not Contain Element  css=#corpo > div > div.secao-principal.row-fluid > div > h1

### Aplicar cupom fretegratis com cep informado

E informo CEP válido no campo correspondente
    Input Text    css=#calcularFrete  ${CEP_VALIDO}
    Click Button  css=#formCalcularFrete > div > div > div > button

Quando adiciono o cupom fretegratis
    Input Text    css=#usarCupom  ${CUPOM_FRETEGRATIS}
    Click Button  css=#corpo > div > div.secao-principal.row-fluid > div > div.caixa-sombreada > table > tbody > tr:nth-child(4) > td:nth-child(1) > form > div > div > div > button

Então o valor do frete do tipo PAC deve ser alterado para R$ 0,00
    Sleep  1 second
    Element Text Should Be          xpath=//*[@id="corpo"]/div/div[1]/div/div[2]/table/tbody/tr[3]/td[2]/div/ul/li[2]/label/span[1]  R$ 0,00
    
E é exibida mensagem de "Frete Grátis" no campo correspondente
    Wait Until Element is Visible   xpath=//*[@id="corpo"]/div/div[1]/div/div[2]/table/tbody/tr[4]/td[2]/div/strong
    Element Text Should Be          xpath=//*[@id="corpo"]/div/div[1]/div/div[2]/table/tbody/tr[4]/td[2]/div/strong  Frete Grátis

# Aplicar cupom 30reais em compras >= de R$ 80,00

Quando adiciono o cupom "30reais"
    Input Text    css=#usarCupom  ${CUPOM_30REAIS}
    Click Button  css=#corpo > div > div.secao-principal.row-fluid > div > div.caixa-sombreada > table > tbody > tr:nth-child(4) > td:nth-child(1) > form > div > div > div > button

Identificar valor subtotal
    Sleep  1 second
    ${VALOR_SUBTOTAL}    Get Text  css=#corpo > div > div.secao-principal.row-fluid > div > div.caixa-sombreada > table > tbody > tr:nth-child(2) > td:nth-child(2) > div > strong
    ${VALOR_SUBTOTAL}    Remove String  ${VALOR_SUBTOTAL.strip().replace(',','.')}  R$  
   # Convert To Number  ${VALOR_SUBTOTAL.strip().replace(',','.')}
    Set Global Variable  ${VALOR_SUBTOTAL}
    Log to Console       ${VALOR_SUBTOTAL}

Identificar valor total
    Wait Until Element is Visible  css=#corpo > div > div.secao-principal.row-fluid > div > div.caixa-sombreada > table > tbody > tr:nth-child(5) > td > div.total > strong
    ${VALOR_TOTAL}        Get Text  css=#corpo > div > div.secao-principal.row-fluid > div > div.caixa-sombreada > table > tbody > tr:nth-child(5) > td > div.total > strong
    ${VALOR_TOTAL}        Remove String  ${VALOR_TOTAL.strip().replace(',','.')}  R$
    Set Global Variable   ${VALOR_TOTAL}
    Log to Console        ${VALOR_TOTAL}

Conferir se o valor total corresponde ao valor subtotal menos o valor do desconto de R$ 30,00
    ${SUBTOTAL_COM_DESCONTO_30REAIS}  Evaluate  ${VALOR_SUBTOTAL}-${DESCONTO_30REAIS}
    Log to Console                    ${SUBTOTAL_COM_DESCONTO_30REAIS}
    Should Be Equal As Numbers        ${SUBTOTAL_COM_DESCONTO_30REAIS}  ${VALOR_TOTAL}

E é exibido valor de desconto 30reais no campo correspondente
    Element Text Should Be  css=#cupom_desconto  R$ 30,00

# Aplicar cupom 30reais em compras < de R$ 80,00

Acessar a página do segundo produto disponível
    Click Element                    xpath=//*[@id="listagemProdutos"]/ul/li[1]/ul/li[2]/div/a
    Wait Until Element is Visible    css=#imagemProduto
    Page Should Contain Element      css=#imagemProduto 

Então nenhum desconto é aplicado ao carrinho
    Identificar valor total
    Identificar valor subtotal
    Should Be Equal As Numbers  ${VALOR_SUBTOTAL}  ${VALOR_TOTAL}

E é exibida mensagem "Valor mínimo para uso deste cupom não atingido"
    Wait Until Element is Visible    css=#corpo > div > div.alert.alert-danger.alert-geral
    Element Should Contain           css=#corpo > div > div.alert.alert-danger.alert-geral  Valor mínimo para uso deste cupom não atingido.

Selecionar opção de frete PAC
    Sleep  1 second
    Select Radio Button  formaEnvio  2

Identificar valor do frete PAC
    Selecionar opção de frete PAC
    ${valor_frete_pac}  

Quando adiciono o cupom "10off"
    Input Text    css=#usarCupom  ${CUPOM_10OFF}
    Click Button  xpath=//*[@id="corpo"]/div/div[1]/div/div[2]/table/tbody/tr[4]/td[1]/form/div/div/div/button
    
Quando adiciono o cupom "10off" - caso 2
    Input Text    css=#usarCupom  ${CUPOM_10OFF}
    Click Button  xpath=//*[@id="corpo"]/div/div[1]/div/div[2]/table/tbody/tr[5]/td[1]/form/div/div/div/button
    
Conferir se o valor total corresponde ao valor subtotal menos o valor do desconto de 10%
    ${SUBTOTAL_COM_DESCONTO_10%}  Evaluate  ${VALOR_SUBTOTAL}*0.9
    Log to Console                    ${SUBTOTAL_COM_DESCONTO_10%}
    Should Be Equal As Numbers        ${SUBTOTAL_COM_DESCONTO_10%}  ${VALOR_TOTAL}

E é exibido valor de desconto 10off no campo correspondente
    Element Text Should Be  css=#cupom_desconto  10 %

Quando adiciono o cupom 99off
    Input Text    css=#usarCupom  ${CUPOM_INEXISTENTE}
    Click Button  css=#corpo > div > div.secao-principal.row-fluid > div > div.caixa-sombreada > table > tbody > tr:nth-child(4) > td:nth-child(1) > form > div > div > div > button

Então é exibida mensagem de "cupom não encontrado"
    Wait Until Element is Visible    css=#corpo > div > div.alert.alert-danger.alert-geral
    Element Should Contain           css=#corpo > div > div.alert.alert-danger.alert-geral  Cupom não encontrado.

E altero a quantidade do produto no carrinho para 3
    Input Text  css=#corpo > div > div.secao-principal.row-fluid > div > div.caixa-sombreada > table > tbody > tr:nth-child(1) > td.clearfix > form > div > input  3  clear=true
    Click Button  css=#corpo > div > div.secao-principal.row-fluid > div > div.caixa-sombreada > table > tbody > tr:nth-child(1) > td.clearfix > form > div > button
    Sleep  1 second
    Element Attribute Value Should Be  css=#corpo > div > div.secao-principal.row-fluid > div > div.caixa-sombreada > table > tbody > tr:nth-child(1) > td.clearfix > form > div > input  value  3

E removo o segundo produto da lista
    Sleep  1 second
    Click Element  css=#corpo > div > div.secao-principal.row-fluid > div > div.caixa-sombreada > table > tbody > tr:nth-child(2) > td:nth-child(6) > div > a

