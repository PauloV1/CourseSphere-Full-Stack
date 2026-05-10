require "test_helper"

class CoursesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @alice = users(:alice)
    @bob   = users(:bob)
    @course = courses(:rails_course) # criado por alice
  end

  # ─── GET /courses (index) ─────────────────────────────────────────────────

  test "lista cursos para usuario autenticado" do
    get "/courses", headers: auth_headers_for(@alice)
    assert_response :ok
    assert_instance_of Array, JSON.parse(response.body)
  end

  test "retorna 401 sem autenticacao" do
    get "/courses"
    assert_response :unauthorized
  end

  # ─── GET /courses/:id (show) ──────────────────────────────────────────────

  test "exibe detalhes de um curso existente" do
    get "/courses/#{@course.id}", headers: auth_headers_for(@alice)
    assert_response :ok
    json = JSON.parse(response.body)
    assert_equal @course.name, json["name"]
  end

  test "retorna 404 para curso inexistente" do
    get "/courses/999999", headers: auth_headers_for(@alice)
    assert_response :not_found
  end

  # ─── POST /courses (create) ───────────────────────────────────────────────

  test "cria curso valido e retorna 201" do
    params = { course: {
      name: "Novo Curso de Teste",
      description: "Descricao",
      start_date: Date.today,
      end_date: Date.today + 30
    } }
    assert_difference "Course.count", 1 do
      post "/courses", params: params, headers: auth_headers_for(@alice), as: :json
    end
    assert_response :created
    json = JSON.parse(response.body)
    assert_equal "Novo Curso de Teste", json["name"]
  end

  test "nao cria curso sem nome e retorna 422" do
    params = { course: { name: "", start_date: Date.today, end_date: Date.today + 1 } }
    assert_no_difference "Course.count" do
      post "/courses", params: params, headers: auth_headers_for(@alice), as: :json
    end
    assert_response :unprocessable_entity
    assert JSON.parse(response.body).key?("errors")
  end

  test "nao cria curso com end_date anterior a start_date" do
    params = { course: {
      name: "Curso Invalido",
      start_date: Date.today,
      end_date: Date.today - 1
    } }
    assert_no_difference "Course.count" do
      post "/courses", params: params, headers: auth_headers_for(@alice), as: :json
    end
    assert_response :unprocessable_entity
  end

  # ─── PUT /courses/:id (update) ────────────────────────────────────────────

  test "criador atualiza proprio curso com sucesso" do
    patch "/courses/#{@course.id}",
      params: { course: { name: "Rails Atualizado" } },
      headers: auth_headers_for(@alice),
      as: :json
    assert_response :ok
    assert_equal "Rails Atualizado", JSON.parse(response.body)["name"]
  end

  test "nao-criador nao pode atualizar curso (403)" do
    patch "/courses/#{@course.id}",
      params: { course: { name: "Tentativa do Bob" } },
      headers: auth_headers_for(@bob),
      as: :json
    assert_response :forbidden
  end

  test "update com dados invalidos retorna 422" do
    patch "/courses/#{@course.id}",
      params: { course: { name: "AB" } }, # menos de 3 chars
      headers: auth_headers_for(@alice),
      as: :json
    assert_response :unprocessable_entity
  end

  # ─── DELETE /courses/:id (destroy) ───────────────────────────────────────

  test "criador pode excluir proprio curso" do
    course_to_delete = Course.create!(
      name: "Para Deletar",
      start_date: Date.today,
      end_date: Date.today + 1,
      creator: @alice
    )
    assert_difference "Course.count", -1 do
      delete "/courses/#{course_to_delete.id}", headers: auth_headers_for(@alice)
    end
    assert_response :no_content
  end

  test "nao-criador nao pode excluir curso (403)" do
    assert_no_difference "Course.count" do
      delete "/courses/#{@course.id}", headers: auth_headers_for(@bob)
    end
    assert_response :forbidden
  end

  test "retorna 401 ao tentar excluir sem autenticacao" do
    delete "/courses/#{@course.id}"
    assert_response :unauthorized
  end
end
