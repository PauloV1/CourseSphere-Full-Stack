# db/seeds.rb

puts "--- Iniciando o Seed ---"

# 1. Limpeza do banco de dados (Ordem inversa das dependências)
puts "Limpando dados antigos..."
Lesson.destroy_all
Course.destroy_all
User.destroy_all

# 2. Criação de Usuários
puts "Criando usuários de teste..."
admin = User.create!(
  name: "Administrador do Sistema",
  email: "admin@coursesphere.com",
  password: "password123"
)

instrutor_tech = User.create!(
  name: "Instrutor Tech",
  email: "tech@coursesphere.com",
  password: "password123"
)

instrutor_design = User.create!(
  name: "Instrutor Design",
  email: "design@coursesphere.com",
  password: "password123"
)

# 3. Criação de Cursos
puts "Criando cursos..."
curso_node = Course.create!(
  name: "Node.js: Do Zero ao Microserviço",
  description: "Aprenda a construir arquiteturas escaláveis com Node.js, Express e Docker. Um guia completo para o desenvolvimento backend moderno.",
  start_date: Date.today - 10.days,
  end_date: Date.today + 50.days,
  creator: admin
)

curso_ui = Course.create!(
  name: "Fundamentos de UI/UX Design",
  description: "Domine o Figma e entenda os princípios da experiência do usuário para criar interfaces bonitas e funcionais.",
  start_date: Date.today + 5.days,
  end_date: Date.today + 35.days,
  creator: instrutor_design
)

curso_python = Course.create!(
  name: "Python para Data Science",
  description: "Explore o mundo da análise de dados utilizando Pandas, NumPy e ferramentas de Machine Learning com Python.",
  start_date: Date.today,
  end_date: Date.today + 90.days,
  creator: instrutor_tech
)

curso_marketing = Course.create!(
  name: "Marketing Digital Estratégico",
  description: "Aprenda a criar campanhas de conversão que geram resultados consistentes utilizando tráfego pago e orgânico.",
  start_date: Date.today + 15.days,
  end_date: Date.today + 45.days,
  creator: admin
)

# 4. Criação de Aulas (Lessons)
puts "Criando aulas..."

# Aulas Curso Node
curso_node.lessons.create!([
  { title: "Introdução à Arquitetura Backend", status: "published", video_url: "https://www.youtube.com/watch?v=ENrzD9HAZK4" },
  { title: "Configurando o Ambiente Local", status: "published", video_url: "https://www.youtube.com/watch?v=pKd0Rpw7O48" },
  { title: "Criando a primeira API Rest", status: "published", video_url: "https://www.youtube.com/watch?v=pU9Q6oiQNd0" },
  { title: "Tratamento de Erros Avançado", status: "draft" }
])

# Aulas Curso UI/UX
curso_ui.lessons.create!([
  { title: "Os 10 Princípios da Heurística de Nielsen", status: "published", video_url: "https://www.youtube.com/watch?v=FjI1k4B7aIQ" },
  { title: "Tipografia e Cores: O Guia Definitivo", status: "published", video_url: "https://www.youtube.com/watch?v=9gTw2EDkaDQ" },
  { title: "Desenhando seu primeiro Wireframe no Figma", status: "draft" }
])

# Aulas Curso Python
curso_python.lessons.create!([
  { title: "Configurando o Jupyter Notebook", status: "published", video_url: "https://www.youtube.com/watch?v=HW29067qVWk" },
  { title: "Lendo Dados de CSV com Pandas", status: "published", video_url: "https://www.youtube.com/watch?v=vmEHCJofslg" },
  { title: "Limpando e Tratando Valores Nulos", status: "published" },
  { title: "Criando Gráficos com Matplotlib", status: "draft" }
])

# Aulas Curso Marketing
curso_marketing.lessons.create!([
  { title: "Como definir o seu Público-Alvo", status: "published" },
  { title: "Tráfego Orgânico vs Pago", status: "draft" }
])

puts "--- Seed Finalizado com Sucesso! ---"
puts "Usuário(s) de teste criados:"
puts "1. admin@coursesphere.com / password123"
puts "2. tech@coursesphere.com / password123"
puts "3. design@coursesphere.com / password123"