# CourseSphere Full Stack

Desafio Técnico — Desenvolvedor(a) Full Stack (Rails + React)

Aplicação web de **gestão de cursos e aulas**, com backend em API REST (Ruby on Rails) e frontend em React (Vite). Permite que usuários se registrem, criem cursos, adicionem aulas e gerenciem tudo com permissões baseadas no criador de cada conteúdo.

---

## Estrutura do Projeto

```text
CourseSphere-Full-Stack/
├── backend/                 # API Rails (modo API)
│   ├── app/                 # Lógica de negócio e Controladores
│   │   ├── controllers/     # Endpoints da API
│   │   └── models/          # Regras e integrações com o banco
│   ├── config/              # Configurações e Rotas (routes.rb)
│   ├── db/                  # Migrations e Seed de dados
│   └── test/                # Suíte de testes automatizados (Minitest)
├── frontend/                # App React com Vite
│   └── src/
│       ├── components/      # Componentes de interface reutilizáveis
│       ├── contexts/        # Gerenciador de estado global (AuthContext)
│       ├── pages/           # Telas da aplicação (Dashboard, Login, etc)
│       ├── routes/          # Definição de rotas (React Router)
│       └── services/        # Configuração de chamadas HTTP (Axios)
└── docker-compose.yml       # Orquestração dos containers
```

---

## Funcionalidades

- Registro e login de usuários com autenticação via **JWT**
- Rotas protegidas — apenas usuários autenticados acessam cursos e aulas
- **CRUD completo** de Cursos e Aulas
- Apenas o **criador do curso** pode editá-lo ou excluí-lo
- **Busca por nome** de curso e **Paginação** no Dashboard
- **Filtro por status** de aula (Todas / Publicadas / Rascunhos) na página de detalhes
- Consumo da **API externa RandomUser** para exibir um instrutor convidado com foto e email em cada curso

---

## Rodando com Docker

```bash
# Clonar o repositório
git clone https://github.com/PauloV1/CourseSphere-Full-Stack.git
cd CourseSphere-Full-Stack

# Subir todos os serviços (banco, backend e frontend)
docker compose up --build
```

Aguarde o banco inicializar. O entrypoint do backend executa automaticamente `db:prepare` (cria, migra e executa os seeds).

| Serviço  | URL                      |
|----------|--------------------------|
| Frontend | http://localhost:5173    |
| Backend  | http://localhost:3000    |

---

## Usuários de Teste

Criados automaticamente pelo seed (`rails db:seed`):

| Nome                     | E-mail                    | Senha       | Papel           |
|--------------------------|---------------------------|-------------|-----------------|
| Instrutor Tech           | tech@coursesphere.com     | password123 | Colaborador     |
| Instrutor Design         | design@coursesphere.com   | password123 | Colaborador     |

---

## Autenticação

A API usa **JWT (JSON Web Token)**.

1. Faça `POST /login` com `{ email, password }` → recebe `{ token, user }`
2. Envie o token em todas as requisições protegidas no header:
   ```
   Authorization: Bearer <seu_token>
   ```

---

## Principais Endpoints da API

| Método | Rota                          | Descrição                        | Protegida |
|--------|-------------------------------|----------------------------------|-----------|
| POST   | /signup                       | Criar usuário                    | ❌        |
| POST   | /login                        | Login                            | ❌        |
| DELETE | /logout                       | Logout                           | ✅        |
| GET    | /me                           | Dados do usuário logado          | ✅        |
| GET    | /courses                      | Listar cursos                    | ✅        |
| POST   | /courses                      | Criar curso                      | ✅        |
| GET    | /courses/:id                  | Detalhes do curso                | ✅        |
| PUT    | /courses/:id                  | Editar curso (somente criador)   | ✅        |
| DELETE | /courses/:id                  | Excluir curso (somente criador)  | ✅        |
| GET    | /courses/:id/lessons          | Listar aulas do curso            | ✅        |
| POST   | /courses/:id/lessons          | Criar aula                       | ✅        |
| PUT    | /lessons/:id                  | Editar aula                      | ✅        |
| DELETE | /lessons/:id                  | Excluir aula                     | ✅        |

---

## Testes Automatizados

O projeto conta com uma suíte de testes automatizados completa para o backend utilizando o **Minitest** (padrão do Rails). Foram implementados:
- **Testes de Modelo (`models/`)**: Validação de campos obrigatórios, datas e relacionamentos.
- **Testes de Controlador (`controllers/`)**: Testes de integração garantindo que as rotas CRUD funcionem, respostas JSON estejam corretas, e que as regras de autorização (apenas criador modifica) e autenticação JWT (rotas protegidas retornam 401/403) sejam respeitadas.

Para rodar os testes:

```bash
docker compose exec backend rails test
```

---

## Stack Técnica

| Camada   | Tecnologia                          |
|----------|-------------------------------------|
| Backend  | Ruby on Rails 8 (API mode)          |
| Banco    | PostgreSQL                          |
| Auth     | JWT (JSON Web Token)                |
| Frontend | React 19 + Vite                     |
| Estilo   | CSS puro (dark theme customizado)   |
| API ext. | [RandomUser API](https://randomuser.me/) |
| Docker   | Docker Compose (backend + db + frontend) |

---

## Variáveis de Ambiente

### Backend

| Variável         | Descrição                        | Padrão no Docker                          |
|------------------|----------------------------------|-------------------------------------------|
| `DATABASE_URL`   | URL de conexão com o PostgreSQL  | `postgres://postgres:password@db:5432/...`|
| `RAILS_ENV`      | Ambiente Rails                   | `development`                             |
| `SECRET_KEY_BASE`| Chave secreta Rails              | (alterar em produção)                     |

### Frontend

| Variável         | Descrição                        | Padrão                                    |
|------------------|----------------------------------|-------------------------------------------|
| `VITE_API_URL`   | URL base da API do Backend       | `http://localhost:3000`                   |

---

## Regras de Negócio

- `name` do curso: obrigatório, mínimo 3 caracteres
- `end_date` do curso: deve ser igual ou posterior ao `start_date`
- `title` da aula: obrigatório, mínimo 3 caracteres
- `status` da aula: apenas `draft` ou `published`
- `video_url` da aula: opcional, mas deve parecer uma URL válida se informada
- Apenas o **criador do curso** pode editar, excluir o curso ou manipular suas aulas
