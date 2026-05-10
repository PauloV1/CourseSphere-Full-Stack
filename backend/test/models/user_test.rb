require "test_helper"

class UserTest < ActiveSupport::TestCase
  # ─── Validações ───────────────────────────────────────────────────────────

  test "valido com atributos corretos" do
    user = User.new(name: "Joao", email: "joao@example.com", password: "senha123")
    assert user.valid?, "Esperava valido, mas erros: #{user.errors.full_messages}"
  end

  test "invalido sem nome" do
    user = User.new(email: "teste@example.com", password: "senha123")
    assert_not user.valid?
    assert_includes user.errors[:name], "can't be blank"
  end

  test "invalido sem email" do
    user = User.new(name: "Maria", password: "senha123")
    assert_not user.valid?
    assert_includes user.errors[:email], "can't be blank"
  end

  test "invalido com email malformado" do
    user = User.new(name: "Maria", email: "nao-e-email", password: "senha123")
    assert_not user.valid?
    assert user.errors[:email].any?
  end

  test "invalido com email duplicado" do
    # alice ja existe nos fixtures
    user = User.new(name: "Copia", email: "alice@example.com", password: "senha123")
    assert_not user.valid?
    assert_includes user.errors[:email], "has already been taken"
  end

  test "invalido com senha curta (menos de 6 chars)" do
    user = User.new(name: "Carlos", email: "carlos@example.com", password: "123")
    assert_not user.valid?
    assert user.errors[:password].any?
  end

  # ─── Autenticação ─────────────────────────────────────────────────────────

  test "autentica com senha correta" do
    user = users(:alice)
    assert user.authenticate("password123")
  end

  test "nao autentica com senha errada" do
    user = users(:alice)
    assert_not user.authenticate("senha_errada")
  end

  # ─── Associações ─────────────────────────────────────────────────────────

  test "tem muitos cursos criados" do
    assert_includes users(:alice).created_courses, courses(:rails_course)
  end

  test "destroy apaga cursos em cascata" do
    user = User.create!(name: "Temp", email: "temp@example.com", password: "senha123")
    Course.create!(name: "Temp Course", start_date: Date.today, end_date: Date.today + 1, creator: user)
    assert_difference "Course.count", -1 do
      user.destroy
    end
  end
end
