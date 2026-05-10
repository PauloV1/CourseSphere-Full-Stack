import { useNavigate } from 'react-router-dom';

export function CourseCard({ course }) {
  const navigate = useNavigate();

  const formatDate = (dateString) => {
    return new Date(dateString).toLocaleDateString('pt-BR', {
      day: '2-digit', month: 'short', year: 'numeric'
    });
  };

  const getCourseStatus = () => {
    const now = new Date();
    const start = new Date(course.start_date);
    const end = new Date(course.end_date);
    if (now < start) return { label: 'Em breve', cls: 'badge-upcoming' };
    if (now > end) return { label: 'Encerrado', cls: 'badge-ended' };
    return { label: 'Em andamento', cls: 'badge-active' };
  };

  const status = getCourseStatus();

  return (
    <div className="course-card">
      <div className="course-card-header">
        <div className={`course-status-badge ${status.cls}`}>{status.label}</div>
        <h3>{course.name}</h3>
      </div>
      <p className="course-desc">
        {course.description ? 
          (course.description.length > 90 ? `${course.description.substring(0, 90)}...` : course.description) 
          : 'Nenhuma descrição fornecida.'}
      </p>
      
      <div className="course-dates">
        <div className="date-item">
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
          <div className="date-text">
            <span>Início</span>
            <strong>{formatDate(course.start_date)}</strong>
          </div>
        </div>
        <div className="date-divider"></div>
        <div className="date-item">
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
          <div className="date-text">
            <span>Término</span>
            <strong>{formatDate(course.end_date)}</strong>
          </div>
        </div>
      </div>

      <div className="course-card-footer">
        <button className="btn-primary-outline" onClick={() => navigate(`/courses/${course.id}`)}>
          Acessar Aulas <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg>
        </button>
      </div>
    </div>
  );
}