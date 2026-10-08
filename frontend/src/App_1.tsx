
import { BrowserRouter, Routes, Route } from 'react-router-dom'
import EstimatePage from './features/order/pages/EstimatePage'
import Dashboard from './features/admin/pages/Dashboard'

function App() {
  return (
    <BrowserRouter>
      <div className="min-h-screen bg-gray-50">
        <header className="bg-white shadow-sm p-4">
          <h1 className="text-xl font-bold">🏠 SmartMove AI</h1>
        </header>
        <Routes>
          <Route path="/" element={<EstimatePage />} />
          <Route path="/admin" element={<Dashboard />} />
        </Routes>
      </div>
    </BrowserRouter>
  )
}
export default App
