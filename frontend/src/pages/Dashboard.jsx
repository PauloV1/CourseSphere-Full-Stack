import { useContext } from 'react';
import { AuthContext } from '../contexts/AuthContext';

export function Dashboard() {
  const { user, logout } = useContext(AuthContext);

  return (
    <div style={{ padding: '40px', textAlign: 'center' }}>
      <h1>Bem-vindo, {user?.name}!</h1>
      <p>Você está logado com o e-mail: <strong>{user?.email}</strong></p>
      
      <button 
        onClick={logout}
        style={{ marginTop: '20px', backgroundColor: '#ffffff', maxWidth: '200px' }}
      >
        Sair da conta
      </button>
    </div>
  );
}