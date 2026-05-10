class Lesson < ApplicationRecord
  belongs_to :course

  # Validações obrigatórias
  validates :title, presence: true, length: { minimum: 3 }
  validates :status, presence: true, inclusion: { in: %w[draft published] }
  
  # Validação de formato de URL apenas se o campo não estiver vazio
  validates :video_url, format: { with: URI::DEFAULT_PARSER.make_regexp, message: "deve ser uma URL válida" }, allow_blank: true
end