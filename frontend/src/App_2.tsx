
import { BrowserRouter, Routes, Route } from 'react-router-dom'
import EstimatePage from './features/order/pages/EstimatePage'
import OrderTrackingPage from './features/order/pages/OrderTrackingPage'
import Dashboard from './features/admin/pages/Dashboard'
import LoginPage from './features/auth/pages/LoginPage'
import SignupPage from './features/auth/pages/SignupPage'

function App() {
  return (
    <BrowserRouter>
      <div className="min-h-screen bg-gray-50">
        <header className="bg-white shadow-sm p-4 flex justify-between">
          <h1 className="text-xl font-bold">🏠 SmartMove AI</h1>
          <nav className="flex gap-4 text-sm">
            <a href="/" className="hover:underline">견적</a>
            <a href="/tracking" className="hover:underline">실시간 기사</a>
            <a href="/login" className="hover:underline">로그인</a>
          </nav>
        </header>
        <Routes>
          <Route path="/" element={<EstimatePage />} />
          <Route path="/tracking" element={<OrderTrackingPage />} />
          <Route path="/admin" element={<Dashboard />} />
          <Route path="/login" element={<LoginPage />} />
          <Route path="/signup" element={<SignupPage />} />
        </Routes>
      </div>
    </BrowserRouter>
  )
}
export default App
