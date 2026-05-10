import { useState, useContext } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { AuthContext } from '../contexts/AuthContext';

export function Register() {
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    password: '',
    password_confirmation: ''
  });
  const [errors, setErrors] = useState([]);
  
  const { register } = useContext(AuthContext);
  const navigate = useNavigate();

  function handleChange(e) {
    const { name, value } = e.target;
    setFormData(prev => ({ ...prev, [name]: value }));
  }

  async function handleSubmit(e) {
    e.preventDefault();
    setErrors([]);

    if (formData.password !== formData.password_confirmation) {
      setErrors(['As senhas não coincidem.']);
      return;
    }

    try {
      await register(
        formData.name, 
        formData.email, 
        formData.password, 
        formData.password_confirmation
      );
      navigate('/dashboard');
    } catch (err) {
      const backendErrors = err.response?.data?.errors;
      setErrors(backendErrors || ['Erro ao criar conta.']);
    }
  }

  return (
    <div className="auth-container">
      <div className="auth-card">
        <h2>Criar conta</h2>
        <p className="subtitle">Comece sua jornada hoje mesmo</p>

        {errors.length > 0 && (
          <div className="error-box">
            {errors.map((err, i) => (
              <p key={i} className="error-message">• {err}</p>
            ))}
          </div>
        )}

        <form onSubmit={handleSubmit}>
          <div className="form-group">
            <label>Nome Completo</label>
            <input 
              name="name"
              type="text" 
              required 
              value={formData.name}
              onChange={handleChange}
            />
          </div>

          <div className="form-group">
            <label>E-mail</label>
            <input 
              name="email"
              type="email" 
              required 
              value={formData.email}
              onChange={handleChange}
            />
          </div>

          <div className="form-group">
            <label>Senha</label>
            <input 
              name="password"
              type="password" 
              required 
              value={formData.password}
              onChange={handleChange}
            />
          </div>

          <div className="form-group">
            <label>Confirmar Senha</label>
            <input 
              name="password_confirmation"
              type="password" 
              required 
              value={formData.password_confirmation}
              onChange={handleChange}
            />
          </div>

          <button type="submit">Registrar</button>
        </form>

        <p className="auth-footer">
          Já tem conta? <Link to="/login">Entrar agora</Link>
        </p>
      </div>
    </div>
  );
}