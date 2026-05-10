require "test_helper"

class AuthenticationControllerTest < ActionDispatch::IntegrationTest
  # ─── POST /login ──────────────────────────────────────────────────────────

  test "login bem-sucedido retorna token e dados do usuario" do
    post "/login", params: { email: "alice@example.com", password: "password123" }, as: :json
    assert_response :ok
    json = JSON.parse(response.body)
    assert json.key?("token"), "Resposta deve conter 'token'"
    assert_equal "alice@example.com", json.dig("user", "email")
    assert_equal "Alice", json.dig("user", "name")
  end

  test "login com senha errada retorna 401" do
    post "/login", params: { email: "alice@example.com", password: "senha_errada" }, as: :json
    assert_response :unauthorized
    assert_includes JSON.parse(response.body)["error"], "Invalid"
  end

  test "login com email inexistente retorna 401" do
    post "/login", params: { email: "naoexiste@example.com", password: "qualquer" }, as: :json
    assert_response :unauthorized
  end

  # ─── POST /signup ─────────────────────────────────────────────────────────

  test "registro bem-sucedido cria usuario e retorna token" do
    assert_difference "User.count", 1 do
      post "/signup", params: {
        name: "Novo Usuario",
        email: "novo@example.com",
        password: "senha123",
        password_confirmation: "senha123"
      }, as: :json
    end
    assert_response :created
    json = JSON.parse(response.body)
    assert json.key?("token")
    assert_equal "novo@example.com", json.dig("user", "email")
  end

  test "registro com email duplicado retorna 422" do
    post "/signup", params: {
      name: "Copia Alice",
      email: "alice@example.com",
      password: "senha123"
    }, as: :json
    assert_response :unprocessable_entity
    assert JSON.parse(response.body).key?("errors")
  end

  test "registro sem nome retorna 422" do
    post "/signup", params: { email: "sem@nome.com", password: "senha123" }, as: :json
    assert_response :unprocessable_entity
  end

  # ─── DELETE /logout ───────────────────────────────────────────────────────

  test "logout autenticado retorna 200" do
    delete "/logout", headers: auth_headers_for(users(:alice))
    assert_response :ok
  end

  test "logout sem token retorna 401" do
    delete "/logout"
    assert_response :unauthorized
  end
end
