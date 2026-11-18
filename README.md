# Fight Club — Eleições

Site estático para publicar no GitHub + Render.

## Estrutura de arquivos

Mantenha esta estrutura no repositório:

```text
fight-club-eleicoes/
├── index.html
├── README.md
├── fight_club_supabase_setup.sql
└── assets/
    ├── machado.png
    ├── mont.png
    ├── cass.png
    ├── gloe.png
    ├── 25.png
    └── 83.png
```

O arquivo HTML entregue como `fight_club_eleicoes_atualizado.html` deve ser renomeado para **`index.html`** antes de publicar.

Os nomes dos arquivos precisam ser exatamente iguais, inclusive letras minúsculas, porque o Render hospeda em ambiente Linux e diferencia maiúsculas de minúsculas.

## Imagens exibidas na urna

- `assets/machado.png`: foto do candidato Machado, ao digitar 25.
- `assets/mont.png`: foto do vice Mont, ao digitar 25.
- `assets/25.png`: logo da Chapa 25, ao digitar 25.
- `assets/cass.png`: foto do candidato Cass, ao digitar 83.
- `assets/gloe.png`: foto do vice Gloe, ao digitar 83.
- `assets/83.png`: logo da Chapa 83, ao digitar 83.

Use imagens PNG. Se uma imagem não for encontrada, o restante da urna continua funcionando, mas aquela foto não aparece.

## Publicar no Render

1. Crie um repositório no GitHub e envie os arquivos mantendo a estrutura acima.
2. No Render, escolha **New → Static Site** e conecte o repositório.
3. Build Command: deixe vazio.
4. Publish Directory: `.` (raiz do repositório).
5. Clique em Deploy.

## Fight Pesquisa — banco de dados

O HTML continua em modo demonstração local até receber as credenciais do Supabase.

1. Crie um projeto no Supabase.
2. Ative **Authentication → Providers → Anonymous Sign-Ins**.
3. Abra o SQL Editor e execute `fight_club_supabase_setup.sql`.
4. Em Project Settings → API, copie a Project URL e a chave pública/anon (publishable/anon key).
5. No `index.html`, encontre:
   - `const SUPABASE_URL = "COLE_A_URL_DO_SEU_PROJETO";`
   - `const SUPABASE_ANON_KEY = "COLE_A_CHAVE_ANON_PUBLICA";`
6. Substitua os textos pelas credenciais do seu projeto e envie o HTML atualizado ao GitHub.

**Nunca coloque a `service_role` key no HTML ou no GitHub.** Somente a chave pública/anon deve estar no frontend.

## Limitação importante da pesquisa

A autenticação anônima do Supabase limita uma resposta por usuário autenticado, mas não prova que cada usuário é uma pessoa única: alguém pode criar outra sessão/conta anônima. Para uma eleição com regra rígida de um voto por integrante, use cadastro individual (por exemplo, convites/códigos de uso único validados por uma função de servidor) antes de abrir a votação.

A urna da primeira aba é apenas simulação e não grava voto oficial. O painel administrativo/apuração oficial ainda não está implementado.
