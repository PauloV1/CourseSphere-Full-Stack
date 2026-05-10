import { createContext, useState, useEffect } from 'react';
import api from '../services/api';

export const AuthContext = createContext({});

export function AuthProvider({ children }) {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  // Verifica se já existe um token ao carregar a aplicação
  useEffect(() => {
    async function loadStorageData() {
      const storageToken = localStorage.getItem('token');
      
      if (storageToken) {
        try {
          const response = await api.get('/me');
          setUser(response.data.user);
        } catch (error) {
          localStorage.removeItem('token');
        }
      }
      setLoading(false);
    }
    loadStorageData();
  }, []);

  async function login(email, password) {
    const response = await api.post('/login', { email, password });
    const { token, user: userData } = response.data;

    localStorage.setItem('token', token);
    setUser(userData);
  }

  async function register(name, email, password, password_confirmation) {
    const response = await api.post('/signup', { 
      name, email, password, password_confirmation 
    });
    const { token, user: userData } = response.data;

    localStorage.setItem('token', token);
    setUser(userData);
  }

  function logout() {
    localStorage.removeItem('token');
    setUser(null);
  }

  return (
    <AuthContext.Provider value={{ 
      signed: !!user, 
      user, 
      login, 
      register, 
      logout, 
      loading 
    }}>
      {children}
    </AuthContext.Provider>
  );
}