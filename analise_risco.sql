CREATE DATABASE ANALISE_RISCO;
use analise_risco;


select * from dados_mutuarios;
alter table dados_mutuarios change person_id id_solicitante varchar(16);
alter table dados_mutuarios change person_age idade int;
alter table dados_mutuarios change person_income salario int;
alter table dados_mutuarios change person_home_ownership situacao_imovel varchar(8);
alter table dados_mutuarios change person_emp_length tempo_trabalho double;

select * from emprestimos;
alter table emprestimos change loan_id id_solicitacao_emprestimo varchar(16);
alter table emprestimos change loan_intent motivo varchar(32);
alter table emprestimos change loan_grade pontuacao varchar(1);
alter table emprestimos change loan_amnt valor_total_solicitado int;
alter table emprestimos change loan_int_rate taxa_juros double;
alter table emprestimos change loan_status possibilidade_inadimplencia int;
alter table emprestimos change loan_percent_income renda_percentual double;

select * from historicos_banco;
alter table historicos_banco change cb_id id_historico_banco varchar(16);
alter table historicos_banco change cb_person_default_on_file inadimplencia_anteior varchar(1);
alter table historicos_banco change cb_person_cred_hist_length tempo_primeira_solicitacao int;

select * from ids;
alter table ids change person_id id_solicitante varchar(16);
alter table ids change loan_id id_solicitacao_emprestimo varchar(16);
alter table ids change cb_id id_historico_banco varchar(16);


set sql_safe_updates = 0;
update dados_mutuarios SET situacao_imovel = 'Aluguel' where situacao_imovel = 'Rent';
update dados_mutuarios SET situacao_imovel = 'Propria' where situacao_imovel = 'Own';
update dados_mutuarios SET situacao_imovel = 'Hipoteca' where situacao_imovel = 'Mortgage';
update dados_mutuarios SET situacao_imovel = 'Outros' where situacao_imovel = 'Other';

update emprestimos SET motivo = 'Pessoal ' where motivo = 'Personal';
update emprestimos SET motivo = 'Educativo ' where motivo = 'Education';
update emprestimos SET motivo = 'Medico ' where motivo = 'Medical';
update emprestimos SET motivo = 'Empreendimento ' where motivo = 'Venture';
update emprestimos SET motivo = 'Melhora_lar' where motivo = 'Homeimprovement';
update emprestimos SET motivo = 'Pagamento_debitos' where motivo = 'Debtconsolidation';

update historicos_banco SET inadimplencia_anteior = 'S' where inadimplencia_anteior = 'Y';

select * from ids a
inner join dados_mutuarios b on a.id_solicitante = b.id_solicitante
inner join emprestimos c on c.id_solicitacao_emprestimo = a.id_solicitacao_emprestimo
inner join historicos_banco d on d.id_historico_banco = a.id_historico_banco;
