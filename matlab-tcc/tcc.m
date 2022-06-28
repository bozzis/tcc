% Feito por: Giovanni Bozzini - 161020721
% TCC
% Script executado no Matlab R2021a

function tcc ()

    function [m] = defineMes(x) % funcao para dar load em certo mes, com base no numero x recebido, retornando a planilha do mes
        switch x
            case 0 % se receber o mes '0', ele da load no oldDez, isso ta explicado na parte que utiliza isso
                m = load ('oldDez.txt');
                return
            case 1 % para os demais meses, cada numero representa o mes 1 ao 12
                m = load ('jan.txt');
                return
            case 2
                m = load ('fev.txt');
                return
            case 3
                m = load ('mar.txt');
                return
            case 4
                m = load ('abr.txt');
                return
            case 5
                m = load ('mai.txt');
                return
            case 6
                m = load ('jun.txt');
                return
            case 7
                m = load ('jul.txt');
                return
            case 8
                m = load ('ago.txt');
                return
            case 9
                m = load ('set.txt');
                return
            case 10
                m = load ('out.txt');
                return
            case 11
                m = load ('nov.txt');
                return
            case 12
                m = load ('dez.txt');
                return
            otherwise % se entrar algum numero que nao se encaixa: erro e encerra script
                error('Erro. \nInput tem que ser um numero inteiro entre 0 e 12.');
        end
    end

    function [r] = random(a,b,x) % funcao para gerar um numero aleatorio entre a e b, retornando r. x = quantos vezes eu quero gerar
        r = a + (b-a) .* rand(x,1);
        return
    end

    function S () %Função S, utilizada quando o dia anterior for seco.
        cima = 0; %Parte de cima da fração.
        baixo = 0; %Parte de baixo da fração.
        diafunc=dia; %trocando a variavel dia para uma diafunc a ser usada nessa funcao
        if diafunc == 1 %tratamento especial se o dia do mes for 1, pois o script compara os dias anteriores, e nesse caso temos que pegar o dia anterior na matriz de outro mes
            for c = size(mes,2):-1:1 %planilha "mes" inicializada usando a funcao que da load nos meses
                if (mesAnt(c) == 0) && (mes(diafunc,c) > 0) %esse calculo veio do modelo, lembrando que mesAnt eh um vetor com 'c' anos
                    cima=cima+1; %basicamente, se o dia anterior for seco e o atual chuvoso, incrementa 1 na parte de cima da fracao
                end
                if (mes(diafunc,c) == 0) %e se o dia atual for seco, incrementa 1 na parte de baixo da fracao
                    baixo=baixo+1;
                end
            end
            if baixo == 0 %raramente, a parte de baixo da fracao fica com valor zerado, nesse caso a gente define ela como 1 pois nao existe divisao por 0
                baixo = 1;
            end
            if (cima > baixo)
            cima = baixo;
            end
            return %sai da funcao, nao retorna nada, mas os valor modificados (azul claro no editor) podem ser vistos pelo "main"
        end
        
        %aqui entra apenas se diafunc for >= 2
        %mesmos calcculos de cima, mas nao utilizamos o mesAnt, pois os
        %dias anteriores ja estao disponiveis na planilha atual
        
        for c = size(mes,2):-1:1 %Analisaremos os 30 anos anteriores a 2022.
            if (mes(diafunc-1,c) == 0) && (mes(diafunc,c) > 0)% dia anterior seco, atual chuvoso
                cima=cima+1;
            end
            if (mes(diafunc,c) == 0) %Dia atual seco.
                baixo=baixo+1;
            end
        end
        if baixo == 0 %nao existe divisao por 0
            baixo = 1;
        end
        if (cima > baixo)
            cima = baixo;
        end
    end


    % a funcao C tem a mesma logica da funcao S, unica coisa que muda sao
    % os ifs para os dias anteriores, onde analisamos se o anterior eh
    % chuvoso em vez de seco, e se o dia atual eh chuvoso.
    
    
    function C () %Função C, utilizada quando o dia anterior for chuvoso. Mesma logica da funcao S.
        cima = 0; %Parte de cima da fração.
        baixo = 0; %Parte de baixo da fração.
        diafunc=dia;
        if diafunc == 1
            for c = size(mes,2):-1:1
                if (mesAnt(c) > 0) && (mes(diafunc,c) > 0)
                    cima=cima+1;
                end
                if (mes(diafunc,c) > 0)
                    baixo=baixo+1;
                end
            end
            if baixo == 0
                baixo = 1;
            end
            if (cima > baixo)
            cima = baixo;
            end
            return
        end
        
        %aqui entra apenas se diafunc for >= 2
        for c = size(mes,2):-1:1
            if (mes(diafunc-1,c) > 0) && (mes(diafunc,c) > 0)
                cima=cima+1;
            end
            if (mes(diafunc,c) > 0) %Dia atual chuvoso.
                baixo=baixo+1;
            end
        end
        if baixo == 0
            baixo = 1;
        end
        if (cima > baixo)
            cima = baixo;
        end
    end


    cima = 0; % inicializa cima e baixo com valores 0
    baixo = 0;


    resultadosP = zeros(31,12); %resultados das probabilidades
    resultadosP(:) = -1; %transformando todos os valores em -1, para saber quais dados sao validos, pois meses variam entre 28 e 31 dias

    resultadosBin = zeros(31,12); %resultados binarios se o o dia = seco (0) ou chuvoso (1)
    resultadosBin(:) = -1;%transformando todos os valores em -1, para saber quais dados sao validos, pois meses variam entre 28 e 31 dias
    
    atual = 1;%define o mes atual para janeiro (isso vai ser incrementado a cada fim de loop do while)
    
    
    while atual <= 12 %janeiro a dezembro
        %esse if define o mes anterior e o atual
        if atual == 1 %se o mes eh janeiro, temos que ajeitar a base para dezembro, pois o dia 1 de janeiro do ano mais antigo precisa de um dia anterior tambem
            mesAnt2 = defineMes(atual-1); %obtem um dado para o dia 31/12/xxxx (ano mais velho extra)
            mes = defineMes(atual); %Obtendo a base de dados para janeiro.
            mesAnt = defineMes(12); %da load no dez.txt
            mesAnt = mesAnt (end,:); % vetor de apenas uma linha: pega apenas o ultimo dia de cada mes
            mesAnt = mesAnt(1:end-1); % para esse caso especifico, deletamos o ultimo valor (mais recente)
            mesAnt = [mesAnt2 , mesAnt]; %#ok<*AGROW> % e logo em seguida adicionamos um valor anterior, no inicio do vetor
        else % meses fevereiro a dezembro:
            mes = defineMes(atual); % obtem a base de dados para o mes atual (funcao que da load)
            mesAnt = defineMes(atual-1); % da load no mes anterior tambem
            mesAnt = mesAnt (end,:); % pega os ultimos dias do mes (dias 29/fev sao excluidos na base, por dados insuficientes)
        end
        
        % bases foram ajustadas, podemos iniciar os calculos agora
        
        for dia = 1:size(mes,1) %Calculos para os dias de cada mes.
            if dia == 1 && atual == 1 %para simular o dia 1/jan/2022, tem um caso especifico
                if mesAnt(end) == 0 %como ja temos o dia anterior (31/12/2021) disponivel na base, apenas verificamos se o dia foi seco ou chuvoso
                    S(); %nesse caso o dia foi seco
                    resultadosP(dia,atual) = cima/baixo;
                else %caso contrario, dia anterior foi chuvoso
                    C();
                    resultadosP(dia,atual) = cima/baixo;
                end
                continue %continua para o proximo loop do for
            end
            
            if dia == 1 && atual > 1 %para os demais dias 1 dos outros meses, temos outro caso especifico
                mesAntigo = defineMes(atual-1); %definimos "mesAntigo" para pegar o tamanho dele
                aleatorio = random(0,1,1); %com base no modelo, geramos um aleatorio entre 0 e 1 para comparar com a probabilidade e definir se o dia foi seco ou chuvoso
                
                if resultadosP(size(mesAntigo,1),atual-1) < aleatorio %analisando o resultadosP (matriz com as probabilidades de chuva simuladas) para definir o resultadosB (matriz se o dia foi chuvoso ou seco)
                    resultadosBin(size(mesAntigo,1),atual-1) = 0; % esse calculo tem como base o modelo, onde se a probabilidade < numero aleatorio gerado, o dia = seco
                else
                    resultadosBin(size(mesAntigo,1),atual-1) = 1; % caso contrario, chuvoso
                end
                
                if resultadosBin(size(mesAntigo,1),atual-1) == 0 % se o dia anterior foi seco
                    S(); %usamos a funcao S
                    resultadosP(dia,atual) = cima/baixo;  % quando a funcao S termina e nos entrega os valor cima/baixo calculados, fazemos a divisao e salvamos na matriz resultadosP
                else % se o dia anterior foi chuvoso
                    C(); % funcao para o dia anterior chuvoso
                    resultadosP(dia,atual) = cima/baixo;  % salvamos os resultados na matriz resultadosP             
                end    
                continue %continua para o proximo loop
            end

            % para os dias >= 2 de qualquer mes
            aleatorio = random(0,1,1); %gera o numero aleatorio entre 0 e 1
            if resultadosP(dia-1,atual) < aleatorio %como o dia atual >=2, fica mais facil de fazer a comparacao, nao precisamos ver mes anterior
                resultadosBin(dia-1,atual) = 0;
            else
                resultadosBin(dia-1,atual) = 1;
            end

            
            
            if resultadosBin(dia-1,atual) == 0 % se o dia anterior foi seco
                S(); %usamos a funcao S
                resultadosP(dia,atual) = cima/baixo;  %resultados sao salvos
            else % caso contrario, funcao C
                C();
                resultadosP(dia,atual) = cima/baixo; %resultados sao salvos
            end


            
            
            
            
            if dia == 31 && atual == 12 % para o dia 31/12/2022, nao vai ter um proximo loop
                aleatorio = random(0,1,1); % gera numero aleatorio
                if resultadosP(dia,atual) < aleatorio %temos que calcular o resultadosBin agora, pois nao vai ter um proximo loop, usamos o resultadosP gerado no loop atual
                    resultadosBin(dia,atual) = 0; % se a probabilidade for menor que o aleatorio, dia considerado como seco
                else
                    resultadosBin(dia,atual) = 1;% caso contrario, dia considerado como chuvoso
                end
            end
        end
        atual = atual + 1; %incrementamos o mes atual, vai sair do while se atual > 12
    end
    
    dlmwrite('resultadosP.txt',resultadosP); %salvamos resultadosP e Bin
    dlmwrite('resultadosBin.txt',resultadosBin);
end





%FIM