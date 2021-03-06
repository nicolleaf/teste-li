*** Settings ***
Resource        ../resource/Resource.robot
Test Setup      Abrir Navegador 
Test Teardown   Fechar navegador

*** Keywords ***

Dado que estou na página de carrinho que contém 1 produto de qualquer valor
    Acessar a página home do cliente
    Acessar a página do primeiro produto disponível
    Adicionar produto ao carrinho
    Redirecionar para a página de carrinho com o produto adicionado na lista de itens

Dado que estou na página de carrinho que contém 1 produto de valor < R$ 80,00
    Acessar a página home do cliente
    Acessar a página do segundo produto disponível
    Adicionar produto ao carrinho
    Redirecionar para a página de carrinho com o produto adicionado na lista de itens

Então é exibida mensagem de "Frete Grátis" no campo correspondente
    E é exibida mensagem de "Frete Grátis" no campo correspondente

Dado que estou na página de carrinho que contém 1 produto de valor >= R$ 80,00
    Dado que estou na página de carrinho que contém 1 produto de qualquer valor

Então deve ser subtraido o valor de R$ 30,00 do valor subtotal do carrinho
    Identificar valor subtotal
    Identificar valor total
    Conferir se o valor total corresponde ao valor subtotal menos o valor do desconto de R$ 30,00
    
Então é aplicado desconto de 10% no valor subtotal do carrinho
    Identificar valor subtotal
    Identificar valor total
    Conferir se o valor total corresponde ao valor subtotal menos o valor do desconto de 10 %

E Seleciono opção de frete PAC
    Selecionar opção de frete PAC
    Identificar valor do frete PAC

E adiciono mais um produto ao carrinho 
    Acessar a página home do cliente
    Acessar a página do segundo produto disponível
    Adicionar produto ao carrinho


*** Test Case ***

Aplicar cupom fretegratis com cep informado
    Dado que estou na página de carrinho que contém 1 produto de qualquer valor
    E informo CEP válido no campo correspondente
    Quando adiciono o cupom fretegratis
    Então o valor do frete do tipo PAC deve ser alterado para R$ 0,00
    E é exibida mensagem de "Frete Grátis" no campo correspondente 

Aplicar cupom fretegratis sem antes informar cep
    Dado que estou na página de carrinho que contém 1 produto de qualquer valor
    Quando adiciono o cupom fretegratis
    Então é exibida mensagem de "Frete Grátis" no campo correspondente

Aplicar cupom 30reais em compras >= de R$ 80,00
    Dado que estou na página de carrinho que contém 1 produto de valor >= R$ 80,00
    Quando adiciono o cupom "30reais"
    Então deve ser subtraido o valor de R$ 30,00 do valor subtotal do carrinho
    E é exibido valor de desconto 30reais no campo correspondente

# Esse teste falha propositalmente ao descomentar pois a regra não existe no site
# Aplicar cupom 30reais em compras < de R$ 80,00
#     Dado que estou na página de carrinho que contém 1 produto de valor < R$ 80,00
#     Quando adiciono o cupom "30reais"
#     Então nenhum desconto é aplicado ao carrinho
#     E é exibida mensagem "Valor mínimo para uso deste cupom não atingido"

Aplicar cupom 10off informando cep - não aplicável ao frete
    Dado que estou na página de carrinho que contém 1 produto de qualquer valor
    Quando adiciono o cupom "10off"
    Então é aplicado desconto de 10% no valor subtotal do carrinho
    E é exibido valor de desconto 10off no campo correspondente

Aplicar cupom 10off e alterar qtd de produtos no carrinho
    Dado que estou na página de carrinho que contém 1 produto de qualquer valor
    E altero a quantidade do produto no carrinho para 3
    Quando adiciono o cupom "10off" 
    Então é aplicado desconto de 10% no valor subtotal do carrinho 
    E é exibido valor de desconto 10off no campo correspondente

Aplicar cupom 10off com 2 produtos no carrinho e remover 1 produto 
    Dado que estou na página de carrinho que contém 1 produto de qualquer valor
    E adiciono mais um produto ao carrinho 
    Quando adiciono o cupom "10off" - caso 2
    E removo o segundo produto da lista
    Então é aplicado desconto de 10% no valor subtotal do carrinho 
    E é exibido valor de desconto 10off no campo correspondente

Cupom inexistente
    Dado que estou na página de carrinho que contém 1 produto de qualquer valor
    Quando adiciono o cupom 99off
    Então é exibida mensagem de "cupom não encontrado"