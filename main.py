from fastapi import FastAPI
import pandas as pd


app = FastAPI()

one_hot_enc = pd.read_pickle('one_hot_encoder.pkl')
modelo = pd.read_pickle('modelo_treinado.pkl')
scaler = pd.read_pickle('scaler.pkl')

@app.get("/")
def hello_root():
    return {"Root": "Você está na raiz da API"}

@app.get('/modelo/v1={idade}&v2={salario}&v3={situacao_imovel}&v4={tempo_trabalho}&v5={motivo}&v6={pontuacao}&v7={valor_total_solicitado}&v8={taxa_juros}&v9={renda_percentual}&v10={inadimplencia_anteior}&v11={tempo_primeira_solicitacao}')
def previsao_modelo(idade, salario, situacao_imovel, tempo_trabalho, 
                    motivo, pontuacao, valor_total_solicitado,
                    taxa_juros, renda_percentual, inadimplencia_anteior, tempo_primeira_solicitacao):
    
    dados = {
        'idade': [float(idade)],
        'salario': [float(salario)],
        'situacao_imovel': [situacao_imovel],
        'tempo_trabalho': [float(tempo_trabalho)],
        'motivo': [motivo],
        'pontuacao': [pontuacao],
        'valor_total_solicitado': [float(valor_total_solicitado)],
        'taxa_juros': [float(taxa_juros)],
        'renda_percentual': [float(renda_percentual)],
        'inadimplencia_anteior': [float(inadimplencia_anteior)],
        'tempo_primeira_solicitacao': [float(tempo_primeira_solicitacao)]
    }

    dados = pd.DataFrame(dados)

    dados = one_hot_enc.transform(dados)
    dados_transformados = pd.DataFrame(dados, columns=one_hot_enc.get_feature_names_out())

    dados_transformados = scaler.transform(dados_transformados)
    dados_transformados = pd.DataFrame(dados_transformados, columns = one_hot_enc.get_feature_names_out())
    return {'result': modelo.predict(dados_transformados)[0],
            'probability_0': modelo.predict_proba(dados_transformados).tolist()[0][0],
            'probability_1': modelo.predict_proba(dados_transformados).tolist()[0][1]}