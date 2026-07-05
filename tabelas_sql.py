import pandas as pd
from pathlib import Path

# DEFININDO DIRETÓRIOS
base_dir = Path(__file__).resolve().parent
arquivo_base = base_dir / 'base_final.csv'
pasta_saida = base_dir / 'tabelas_csv'
pasta_saida.mkdir(exist_ok=True)

# IMPORTANDO E LIMPANDO A BASE ORIGINAL
df = pd.read_csv(arquivo_base, encoding='utf-8-sig')
df.columns = df.columns.str.strip()

for coluna in df.select_dtypes(include='object').columns:
    df[coluna] = df[coluna].str.strip()

df['Setor'] = df['Setor'].replace({'Usin.': 'Usinagem'})
df['Causa_Falha'] = df['Causa_Falha'].replace({
    'Falha elétrica': 'Falha Elétrica',
    'Falha mecânica': 'Falha Mecânica',
    'Erro operador': 'Erro Operador'
})

df['Data_Manutencao'] = pd.to_datetime(df['Data_Manutencao'], errors='raise').dt.strftime('%Y-%m-%d')
df['Custo_Manutencao'] = df['Custo_Manutencao'].astype(str).str.replace(',', '.', regex=False).astype(float).round(2)
df['Horas_Paradas_Decimal'] = df['Horas_Parada'].apply(lambda valor: round(int(valor.split(':')[0]) + int(valor.split(':')[1]) / 60, 2))
df['id_ordem'] = df['Numero_OS'].str.extract(r'(\d+)')[0].astype(int)
df['id_tecnico'] = df['ID_Tecnico'].str.extract(r'(\d+)')[0].astype(int)

# TABELA SETOR
ordem_setores = ['Montagem', 'Usinagem']
valores_setores = df['Setor'].drop_duplicates().tolist()
valores_setores = [valor for valor in ordem_setores if valor in valores_setores] + [valor for valor in valores_setores if valor not in ordem_setores]
setor = pd.DataFrame({
    'id_setor': range(1, len(valores_setores) + 1),
    'nome_setor': valores_setores
})
mapa_setor = setor.set_index('nome_setor')['id_setor']

# TABELA FABRICANTE_MAQUINA
ordem_fabricantes_maquina = ['Romi', 'Haas', 'Hidraupress', 'Newton', 'Trumpf', 'Haitian', 'Kuka', 'SEW-Eurodrive', 'Atlas Copco']
valores_fabricantes_maquina = df['Fabricante'].drop_duplicates().tolist()
valores_fabricantes_maquina = [valor for valor in ordem_fabricantes_maquina if valor in valores_fabricantes_maquina] + [valor for valor in valores_fabricantes_maquina if valor not in ordem_fabricantes_maquina]
fabricante_maquina = pd.DataFrame({
    'id_fabricante': range(1, len(valores_fabricantes_maquina) + 1),
    'nome_fabricante': valores_fabricantes_maquina
})
mapa_fabricante_maquina = fabricante_maquina.set_index('nome_fabricante')['id_fabricante']

# TABELA MAQUINA
# A Base_final relaciona uma mesma máquina aos dois setores.
# Para não perder nenhuma linha, cada combinação ID_Maquina + Setor vira um registro da tabela maquina.
maquina_aux = df[['ID_Maquina', 'Máquina', 'Fabricante', 'Setor']].drop_duplicates().sort_values(['ID_Maquina', 'Setor']).reset_index(drop=True)
maquina_aux['id_maquina'] = range(1, len(maquina_aux) + 1)
maquina_aux['modelo'] = maquina_aux['Máquina']
maquina_aux['fk_setor'] = maquina_aux['Setor'].map(mapa_setor)
maquina_aux['fk_fabricante'] = maquina_aux['Fabricante'].map(mapa_fabricante_maquina)
maquina = maquina_aux[['id_maquina', 'modelo', 'fk_setor', 'fk_fabricante']].copy()

# TABELA TIPO_MANUTENCAO
ordem_tipos = ['Preventiva', 'Preditiva', 'Corretiva']
valores_tipos = df['Tipo_Manutencao'].drop_duplicates().tolist()
valores_tipos = [valor for valor in ordem_tipos if valor in valores_tipos] + [valor for valor in valores_tipos if valor not in ordem_tipos]
tipo_manutencao = pd.DataFrame({
    'id_tipo_manutencao': range(1, len(valores_tipos) + 1),
    'tipo_manutencao': valores_tipos
})
mapa_tipo_manutencao = tipo_manutencao.set_index('tipo_manutencao')['id_tipo_manutencao']

# TABELA CAUSA_FALHA
ordem_causas = ['Falha Elétrica', 'Lubrificação', 'Falha Mecânica', 'Erro Operador', 'Desgaste']
valores_causas = df['Causa_Falha'].drop_duplicates().tolist()
valores_causas = [valor for valor in ordem_causas if valor in valores_causas] + [valor for valor in valores_causas if valor not in ordem_causas]
causa_falha = pd.DataFrame({
    'id_causa_falha': range(1, len(valores_causas) + 1),
    'causa_falha': valores_causas
})
mapa_causa_falha = causa_falha.set_index('causa_falha')['id_causa_falha']

# BASE AUXILIAR COM AS CHAVES ESTRANGEIRAS DAS MÁQUINAS
df_relacionado = df.merge(maquina_aux[['ID_Maquina', 'Setor', 'id_maquina']], on=['ID_Maquina', 'Setor'], how='left')

# TABELA MANUTENCAO
manutencao = pd.DataFrame({
    'id_manutencao': df_relacionado['ID_Registro'].astype(int),
    'fk_maquina': df_relacionado['id_maquina'].astype(int),
    'fk_tipo_manutencao': df_relacionado['Tipo_Manutencao'].map(mapa_tipo_manutencao).astype(int),
    'data_manutencao': df_relacionado['Data_Manutencao'],
    'custo_manutencao': df_relacionado['Custo_Manutencao'],
    'fk_causa_falha': df_relacionado['Causa_Falha'].map(mapa_causa_falha).astype(int),
    'horas_paradas': df_relacionado['Horas_Paradas_Decimal']
})

# TABELA STATUS_ORDEM
ordem_status = ['Aberta', 'Concluída', 'Em andamento']
valores_status = df['Status_OS'].drop_duplicates().tolist()
valores_status = [valor for valor in ordem_status if valor in valores_status] + [valor for valor in valores_status if valor not in ordem_status]
status_ordem = pd.DataFrame({
    'id_status': range(1, len(valores_status) + 1),
    'status_ordem': valores_status
})
mapa_status_ordem = status_ordem.set_index('status_ordem')['id_status']

# TABELA ORDEM_SERVICO
ordem_servico = pd.DataFrame({
    'id_ordem': df['id_ordem'],
    'fk_manutencao': df['ID_Registro'].astype(int),
    'data_abertura': df['Data_Manutencao'],
    'fk_status': df['Status_OS'].map(mapa_status_ordem).astype(int),
    'observacao': ''
})

# TABELA FABRICANTE_PECA
ordem_fabricantes_peca = ['Bosch', 'Siemens', 'WEG', 'Schneider', 'Fanuc']
valores_fabricantes_peca = df['Fabricante_Peca'].drop_duplicates().tolist()
valores_fabricantes_peca = [valor for valor in ordem_fabricantes_peca if valor in valores_fabricantes_peca] + [valor for valor in valores_fabricantes_peca if valor not in ordem_fabricantes_peca]
fabricante_peca = pd.DataFrame({
    'id_fabricante': range(1, len(valores_fabricantes_peca) + 1),
    'nome_fabricante': valores_fabricantes_peca
})
mapa_fabricante_peca = fabricante_peca.set_index('nome_fabricante')['id_fabricante']

# TABELA PECA
# A mesma peça aparece com fabricantes diferentes na Base_final.
# Por isso, cada combinação Peca_Utilizada + Fabricante_Peca recebe um id_peca próprio.
ordem_pecas = ['Bomba', 'Filtro', 'Sensor', 'Rolamento', 'Correia', 'CLP', 'Motor', 'Válvula']
peca_aux = df[['Peca_Utilizada', 'Fabricante_Peca']].drop_duplicates().copy()
peca_aux['ordem_peca'] = peca_aux['Peca_Utilizada'].map({valor: indice for indice, valor in enumerate(ordem_pecas, start=1)})
peca_aux['fk_fabricante'] = peca_aux['Fabricante_Peca'].map(mapa_fabricante_peca)
peca_aux = peca_aux.sort_values(['ordem_peca', 'fk_fabricante']).reset_index(drop=True)
peca_aux['id_peca'] = range(1, len(peca_aux) + 1)
peca_aux['nome_peca'] = peca_aux['Peca_Utilizada']
peca = peca_aux[['id_peca', 'nome_peca', 'fk_fabricante']].copy()

# TABELA ESPECIALIDADE_TECNICO
ordem_especialidades = ['Eletricista', 'Mecânico', 'Automação']
valores_especialidades = df['Especialidade_y'].drop_duplicates().tolist()
valores_especialidades = [valor for valor in ordem_especialidades if valor in valores_especialidades] + [valor for valor in valores_especialidades if valor not in ordem_especialidades]
especialidade_tecnico = pd.DataFrame({
    'id_especialidade': range(1, len(valores_especialidades) + 1),
    'nome_especialidade': valores_especialidades
})
mapa_especialidade = especialidade_tecnico.set_index('nome_especialidade')['id_especialidade']

# TABELA TECNICO
tecnico_aux = df[['id_tecnico', 'Nome_Tecnico', 'Especialidade_y']].drop_duplicates().sort_values('id_tecnico').reset_index(drop=True)
nomes_separados = tecnico_aux['Nome_Tecnico'].str.split(' ', n=1, expand=True)
tecnico = pd.DataFrame({
    'id_tecnico': tecnico_aux['id_tecnico'],
    'nome_tecnico': nomes_separados[0],
    'sobrenome_tecnico': nomes_separados[1],
    'fk_especialidade': tecnico_aux['Especialidade_y'].map(mapa_especialidade).astype(int)
})

# TABELA ORDEM_PECA
ordem_peca_aux = df.merge(peca_aux[['Peca_Utilizada', 'Fabricante_Peca', 'id_peca']], on=['Peca_Utilizada', 'Fabricante_Peca'], how='left')
ordem_peca = pd.DataFrame({
    'id_ordem_peca': range(1, len(ordem_peca_aux) + 1),
    'fk_ordem': ordem_peca_aux['id_ordem'],
    'fk_peca': ordem_peca_aux['id_peca'].astype(int),
    'quantidade': ordem_peca_aux['Quantidade_Pecas'].astype(int)
})

# TABELA ORDEM_TECNICO
ordem_tecnico = pd.DataFrame({
    'id_ordem_tecnico': range(1, len(df) + 1),
    'fk_ordem': df['id_ordem'],
    'fk_tecnico': df['id_tecnico']
})

# VALIDANDO AS REGRAS DO SQL
assert manutencao['id_manutencao'].is_unique
assert ordem_servico['id_ordem'].is_unique
assert ordem_servico['fk_manutencao'].is_unique
assert peca['id_peca'].is_unique
assert tecnico['id_tecnico'].is_unique
assert not ordem_peca.duplicated(['fk_ordem', 'fk_peca']).any()
assert not ordem_tecnico.duplicated(['fk_ordem', 'fk_tecnico']).any()
assert (manutencao['custo_manutencao'] >= 0).all()
assert (manutencao['horas_paradas'] >= 0).all()
assert (ordem_peca['quantidade'] > 0).all()
assert manutencao['fk_maquina'].isin(maquina['id_maquina']).all()
assert manutencao['fk_tipo_manutencao'].isin(tipo_manutencao['id_tipo_manutencao']).all()
assert manutencao['fk_causa_falha'].isin(causa_falha['id_causa_falha']).all()
assert ordem_servico['fk_manutencao'].isin(manutencao['id_manutencao']).all()
assert ordem_servico['fk_status'].isin(status_ordem['id_status']).all()
assert ordem_peca['fk_ordem'].isin(ordem_servico['id_ordem']).all()
assert ordem_peca['fk_peca'].isin(peca['id_peca']).all()
assert ordem_tecnico['fk_ordem'].isin(ordem_servico['id_ordem']).all()
assert ordem_tecnico['fk_tecnico'].isin(tecnico['id_tecnico']).all()

# EXPORTANDO AS TABELAS EM CSV
tabelas = {
    'setor.csv': setor,
    'fabricante_maquina.csv': fabricante_maquina,
    'maquina.csv': maquina,
    'tipo_manutencao.csv': tipo_manutencao,
    'causa_falha.csv': causa_falha,
    'manutencao.csv': manutencao,
    'status_ordem.csv': status_ordem,
    'ordem_servico.csv': ordem_servico,
    'fabricante_peca.csv': fabricante_peca,
    'peca.csv': peca,
    'especialidade_tecnico.csv': especialidade_tecnico,
    'tecnico.csv': tecnico,
    'ordem_peca.csv': ordem_peca,
    'ordem_tecnico.csv': ordem_tecnico
}

for nome_arquivo, tabela in tabelas.items():
    tabela.to_csv(pasta_saida / nome_arquivo, index=False, encoding='utf-8-sig', float_format='%.2f')
    print(f'{nome_arquivo}: {len(tabela)} linhas')

print(f'\nArquivos salvos em: {pasta_saida}')
