import { Routes, Route, Navigate } from 'react-router-dom';
import { useContext } from 'react';
import { AuthContext } from '../contexts/AuthContext';

import { Login } from '../pages/Login';
import { Register } from '../pages/Register';
import { Dashboard } from '../pages/Dashboard';

export default function AppRoutes() {
  const { signed, loading } = useContext(AuthContext);

  // Enquanto verifica o token no localStorage, não mostra nada (ou um spinner)
  if (loading) {
    return (
      <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '100vh' }}>
        <h1>Carregando...</h1>
      </div>
    );
  }

  return (
    <Routes>
      {/* Rotas Públicas: Só acessa quem NÃO está logado */}
      <Route path="/login" element={!signed ? <Login /> : <Navigate to="/dashboard" />} />
      <Route path="/register" element={!signed ? <Register /> : <Navigate to="/dashboard" />} />

      {/* Rotas Privadas: Só acessa quem ESTÁ logado */}
      <Route path="/dashboard" element={signed ? <Dashboard /> : <Navigate to="/login" />} />

      {/* Rota Padrão: Se o cara digitar qualquer coisa, manda pro login ou dashboard */}
      <Route path="*" element={<Navigate to={signed ? "/dashboard" : "/login"} />} />
    </Routes>
  );
}