CREATE DATABASE So_Doces;
USE So_Doces;

-- ====================================================================
-- ESTRUTURA DAS TABELAS (DDL)
-- ====================================================================

CREATE TABLE Cargos (
    ID_Cargo INT AUTO_INCREMENT PRIMARY KEY,
    Nome_Cargo VARCHAR(50) NOT NULL
);

CREATE TABLE Clientes (
    ID_Cliente INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    CPF VARCHAR(11) UNIQUE,
    Telefone VARCHAR(20)
);

CREATE TABLE Formas_Pagamento (
    ID_Forma_Pagto INT AUTO_INCREMENT PRIMARY KEY,
    Descricao VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Produtos (
    ID_Produto INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(150) NOT NULL,
    Codigo_Barras VARCHAR(50) UNIQUE,
    Preco_Venda DECIMAL(10, 2) NOT NULL,
    Categoria VARCHAR(50)
);

CREATE TABLE Funcionarios (
    ID_Funcionario INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Login VARCHAR(50) NOT NULL UNIQUE,
    Senha VARCHAR(255) NOT NULL,
    ID_Cargo INT NOT NULL,
    CONSTRAINT FK_Funcionarios_Cargos 
    	FOREIGN KEY (ID_Cargo) 
    	REFERENCES Cargos(ID_Cargo)
);

CREATE TABLE Lotes (
    ID_Lote INT AUTO_INCREMENT PRIMARY KEY,
    ID_Produto INT NOT NULL,
    Codigo_Lote VARCHAR(50) NOT NULL,
    Data_Validade DATE NOT NULL,
    Quantidade_Inicial INT NOT NULL,
    Quantidade_Atual INT NOT NULL,
    CONSTRAINT FK_Lotes_Produtos 
    	FOREIGN KEY (ID_Produto) 
    	REFERENCES Produtos(ID_Produto)
);

CREATE TABLE Vendas (
    ID_Venda INT AUTO_INCREMENT PRIMARY KEY,
    Data_Hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Valor_Total DECIMAL(10, 2) NOT NULL,
    ID_Funcionario INT NOT NULL,
    ID_Forma_Pagto INT NOT NULL,
    ID_Cliente INT NULL,
    CONSTRAINT FK_Vendas_Funcionarios 
    	FOREIGN KEY (ID_Funcionario) 
    	REFERENCES Funcionarios(ID_Funcionario),
    CONSTRAINT FK_Vendas_Formas_Pagamento 
    	FOREIGN KEY (ID_Forma_Pagto) 
    	REFERENCES Formas_Pagamento(ID_Forma_Pagto),
    CONSTRAINT FK_Vendas_Clientes 
    	FOREIGN KEY (ID_Cliente) 
    	REFERENCES Clientes(ID_Cliente)
);

CREATE TABLE Itens_Venda (
    ID_Item INT AUTO_INCREMENT PRIMARY KEY,
    ID_Venda INT NOT NULL,
    ID_Lote INT NOT NULL,
    Quantidade INT NOT NULL,
    Preco_Praticado DECIMAL(10, 2) NOT NULL,
    CONSTRAINT FK_Itens_Venda_Vendas 
    	FOREIGN KEY (ID_Venda) 
    	REFERENCES Vendas(ID_Venda) 
    	ON DELETE CASCADE,
    CONSTRAINT FK_Itens_Venda_Lotes 
    	FOREIGN KEY (ID_Lote) 
    	REFERENCES Lotes(ID_Lote)
);

CREATE TABLE Perdas_Estoque (
    ID_Perda INT AUTO_INCREMENT PRIMARY KEY,
    ID_Lote INT NOT NULL,
    ID_Funcionario INT NOT NULL,
    Quantidade INT NOT NULL,
    Motivo VARCHAR(50) NOT NULL,
    Data_Hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT FK_Perdas_Estoque_Lotes 
    	FOREIGN KEY (ID_Lote) 
    	REFERENCES Lotes(ID_Lote),
    CONSTRAINT FK_Perdas_Estoque_Funcionarios 
    	FOREIGN KEY (ID_Funcionario) 
    	REFERENCES Funcionarios(ID_Funcionario)    
);

-- --------------------------------------------------------------------
-- POPULAÇÃO DO BANCO DE DADOS (DML)
-- --------------------------------------------------------------------

-- [CORREÇÃO] Inserindo tabelas base indispensáveis para as chaves estrangeiras
INSERT INTO Cargos (ID_Cargo, Nome_Cargo) VALUES 
(1, 'Gerente'),
(2, 'Operador de Caixa');

INSERT INTO Formas_Pagamento (ID_Forma_Pagto, Descricao) VALUES 
(1, 'Dinheiro'),
(2, 'Débito'),
(3, 'Crédito'),
(4, 'Pix');

-- ====================================================================
-- 1. CADASTRO DE PRODUTOS E ENTRADA DE LOTES (Validade: 01/08/2026)
-- ====================================================================

INSERT INTO Produtos (ID_Produto, Nome, Codigo_Barras, Preco_Venda, Categoria) VALUES
(1, 'Alfajor', '7891000111012', 4.00, 'Bomboniere'),
(2, 'Trufa', '7891000111029', 3.00, 'Bomboniere'),
(3, 'Bolo de pote', '7891000111036', 10.00, 'Confeitaria'),
(4, 'Torta de morango', '7891000111043', 40.00, 'Confeitaria');

INSERT INTO Lotes (ID_Lote, ID_Produto, Codigo_Lote, Data_Validade, Quantidade_Inicial, Quantidade_Atual) VALUES
(1, 1, 'LOTE-ALF-01', '2026-08-01', 100, 100),
(2, 2, 'LOTE-TRF-01', '2026-08-01', 400, 400),
(3, 3, 'LOTE-BLP-01', '2026-08-01', 50, 50),
(4, 4, 'LOTE-TTM-01', '2026-08-01', 40, 40);


-- ====================================================================
-- 2. CADASTRO DA EQUIPE (A Gerente e os Operadores de Caixa)
-- ====================================================================

INSERT INTO Funcionarios (ID_Funcionario, Nome, Login, Senha, ID_Cargo) VALUES
(1, 'Sofia Barros', 'sofia.gerente', 'hash_senha_sofia123', 1),
(2, 'Neymar Silva', 'ney.caixa', 'hash_senha_ney10', 2),
(3, 'Erling Haaland', 'haaland.caixa', 'hash_senha_cometa', 2),
(4, 'Cristiano Ronaldo', 'cr7.caixa', 'hash_senha_siuuu', 2);


-- ====================================================================
-- 3. CADASTRO DE 27 CLIENTES ALEATÓRIOS (Para o fluxo de vendas)
-- ====================================================================

INSERT INTO Clientes (ID_Cliente, Nome, CPF, Telefone) VALUES
(1, 'Lucas Silva', '12345678901', '11999991111'), (2, 'Maria Santos', '23456789012', '11999992222'), (3, 'João Oliveira', '34567890123', '11999993333'),
(4, 'Ana Costa', '45678901234', '11999994444'), (5, 'Pedro Souza', '56789012345', '11999995555'), (6, 'Carla Diaz', '67890123456', '11999996666'), (7, 'Bruno Lima', '78901234567', '11999997777'),
(8, 'Julia Melo', '89012345678', '11999998888'), (9, 'Diego Rocha', '90123456789', '11999999999'), (10, 'Mariana Alves', '01234567890', '11988881111'), (11, 'Rafael Cruz', '11234567890', '11988882222'), (12, 'Beatriz Reis', '22345678901', '11988883333'), (13, 'Felipe Moura', '33456789012', '11988884444'), (14, 'Amanda Borges', '44567890123', '11988885555'), (15, 'Rodrigo Faro', '55678901234', '11988886666'), (16, 'Camila Pitanga', '66789012345', '11988887777'), (17, 'Gustavo Lima', '77890123456', '11988888888'),
(18, 'Larissa Manoela', '88901234567', '11988889999'), (19, 'Thiago Lacerda', '99012345678', '11977771111'), (20, 'Vanessa Camargo', '00123456789', '11977772222'), (21, 'Mateus Solano', '11023456789', '11977773333'), (22, 'Aline Moraes', '22034567890', '11977774444'), (23, 'Gabriel Barbosa', '33045678901', '11977775555'), (24, 'Priscila Alcantara', '44056789012', '11977776666'), (25, 'Ricardo Tozzi', '55067890123', '11977777777'), (26, 'Isabela Garcia', '66078901234', '11977778888'), (27, 'Daniel Oliveira', '77089012345', '11977779999');


-- ====================================================================
-- 4. HISTÓRICO DE VENDAS E SEUS ITENS
-- ====================================================================

-- Cenário A: 3 clientes compram 5 trufas cada
INSERT INTO Vendas (ID_Venda, Valor_Total, ID_Funcionario, ID_Forma_Pagto, ID_Cliente) VALUES
(1, 15.00, 2, 4, 1),
(2, 15.00, 3, 4, 2),
(3, 15.00, 4, 3, 3);

INSERT INTO Itens_Venda (ID_Venda, ID_Lote, Quantidade, Preco_Praticado) VALUES
(1, 2, 5, 3.00),
(2, 2, 5, 3.00),
(3, 2, 5, 3.00);

-- Cenário B: 4 clientes compram 2 trufas e 3 alfajores cada
INSERT INTO Vendas (ID_Venda, Valor_Total, ID_Funcionario, ID_Forma_Pagto, ID_Cliente) VALUES
(4, 18.00, 2, 4, 4),
(5, 18.00, 3, 4, 5),
(6, 18.00, 4, 3, 6),
(7, 18.00, 2, 3, 7);

INSERT INTO Itens_Venda (ID_Venda, ID_Lote, Quantidade, Preco_Praticado) VALUES
(4, 2, 2, 3.00), (4, 1, 3, 4.00),
(5, 2, 2, 3.00), (5, 1, 3, 4.00),
(6, 2, 2, 3.00), (6, 1, 3, 4.00),
(7, 2, 2, 3.00), (7, 1, 3, 4.00);

-- Cenário C: 10 clientes compram 1 torta de morango e 4 trufas cada
INSERT INTO Vendas (ID_Venda, Valor_Total, ID_Funcionario, ID_Forma_Pagto, ID_Cliente) VALUES
(8, 52.00, 3, 4, 8),   (9, 52.00, 4, 4, 9),   (10, 52.00, 2, 4, 10), (11, 52.00, 3, 4, 11), (12, 52.00, 4, 4, 12),
(13, 52.00, 2, 3, 13), (14, 52.00, 3, 3, 14), (15, 52.00, 4, 3, 15), (16, 52.00, 2, 3, 16), (17, 52.00, 3, 3, 17);

INSERT INTO Itens_Venda (ID_Venda, ID_Lote, Quantidade, Preco_Praticado) VALUES
(8, 4, 1, 40.00),  (8, 2, 4, 3.00),
(9, 4, 1, 40.00),  (9, 2, 4, 3.00),
(10, 4, 1, 40.00), (10, 2, 4, 3.00),
(11, 4, 1, 40.00), (11, 2, 4, 3.00),
(12, 4, 1, 40.00), (12, 2, 4, 3.00),
(13, 4, 1, 40.00), (13, 2, 4, 3.00),
(14, 4, 1, 40.00), (14, 2, 4, 3.00),
(15, 4, 1, 40.00), (15, 2, 4, 3.00),
(16, 4, 1, 40.00), (16, 2, 4, 3.00),
(17, 4, 1, 40.00), (17, 2, 4, 3.00);

-- Cenário D: 10 clientes compram 2 bolos de pote cada
INSERT INTO Vendas (ID_Venda, Valor_Total, ID_Funcionario, ID_Forma_Pagto, ID_Cliente) VALUES
(18, 20.00, 4, 4, 18), (19, 20.00, 2, 4, 19), (20, 20.00, 3, 4, 20), (21, 20.00, 4, 4, 21), (22, 20.00, 2, 4, 22),
(23, 20.00, 3, 3, 23), (24, 20.00, 4, 3, 24), (25, 20.00, 2, 3, 25), (26, 20.00, 3, 3, 26), (27, 20.00, 4, 3, 27);

INSERT INTO Itens_Venda (ID_Venda, ID_Lote, Quantidade, Preco_Praticado) VALUES
(18, 3, 2, 10.00), (19, 3, 2, 10.00), (20, 3, 2, 10.00), (21, 3, 2, 10.00), (22, 3, 2, 10.00),
(23, 3, 2, 10.00), (24, 3, 2, 10.00), (25, 3, 2, 10.00), (26, 3, 2, 10.00), (27, 3, 2, 10.00);


-- ====================================================================
-- 5. REGISTRO DE QUEBRAS E AVARIAS (Registrado pela Gerente Sofia - ID 1)
-- ====================================================================

INSERT INTO Perdas_Estoque (ID_Lote, ID_Funcionario, Quantidade, Motivo) VALUES
(2, 1, 9, 'Avaria'),
(1, 1, 4, 'Avaria');



#################### Inicio das SPs

#Store Procedure Nº1

DELIMITER //

CREATE PROCEDURE sp_RegistrarPerdaEstoque(
    IN p_ID_Lote INT,
    IN p_ID_Funcionario INT,
    IN p_Quantidade INT,
    IN p_Motivo VARCHAR(50)
)
BEGIN
    DECLARE v_qtd_atual INT;

    -- Verifica a quantidade atual disponível no lote
    SELECT Quantidade_Atual INTO v_qtd_atual
    FROM Lotes WHERE ID_Lote = p_ID_Lote;

    IF v_qtd_atual >= p_Quantidade THEN
        -- 1. Registra o histórico da perda
        INSERT INTO Perdas_Estoque (ID_Lote, ID_Funcionario, Quantidade, Motivo)
        VALUES (p_ID_Lote, p_ID_Funcionario, p_Quantidade, p_Motivo);

        -- 2. Deduz a quantidade do estoque atual
        UPDATE Lotes
        SET Quantidade_Atual = Quantidade_Atual - p_Quantidade
        WHERE ID_Lote = p_ID_Lote;
        
        -- Confirmação de sucesso
        SELECT 'Perda registrada e estoque atualizado com sucesso!' AS Resultado;
    ELSE
        -- Retorna uma mensagem de aviso caso não tenha estoque
        SELECT 'Erro: A quantidade informada é maior que o estoque atual do lote.' AS Resultado;
    END IF;
END //

DELIMITER ;

#Store Procedure Nº2


DELIMITER //

CREATE PROCEDURE sp_AdicionarItemVenda(
    IN p_ID_Venda INT,
    IN p_ID_Lote INT,
    IN p_Quantidade INT,
    IN p_Preco_Praticado DECIMAL(10,2)
)
BEGIN
    DECLARE v_qtd_atual INT;
    DECLARE v_subtotal DECIMAL(10,2);

    SELECT Quantidade_Atual INTO v_qtd_atual
    FROM Lotes WHERE ID_Lote = p_ID_Lote;

    IF v_qtd_atual >= p_Quantidade THEN
        INSERT INTO Itens_Venda (ID_Venda, ID_Lote, Quantidade, Preco_Praticado)
        VALUES (p_ID_Venda, p_ID_Lote, p_Quantidade, p_Preco_Praticado);

        UPDATE Lotes
        SET Quantidade_Atual = Quantidade_Atual - p_Quantidade
        WHERE ID_Lote = p_ID_Lote;

        SET v_subtotal = p_Quantidade * p_Preco_Praticado;
        
        UPDATE Vendas
        SET Valor_Total = Valor_Total + v_subtotal
        WHERE ID_Venda = p_ID_Venda;
        
        SELECT 'Item adicionado e venda atualizada com sucesso!' AS Resultado;
    ELSE
        SELECT 'Erro: Estoque insuficiente para realizar a venda deste lote.' AS Resultado;
    END IF;
END //

DELIMITER ;



















;