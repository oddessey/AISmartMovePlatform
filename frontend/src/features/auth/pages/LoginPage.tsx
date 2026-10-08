
import { useState } from 'react'
import { api } from '../../../lib/api'
import { useNavigate } from 'react-router-dom'

export default function LoginPage() {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const nav = useNavigate()

  const handleLogin = async () => {
    try {
      const { data } = await api.post('/auth/login', { email, password })
      localStorage.setItem('accessToken', data.accessToken)
      localStorage.setItem('refreshToken', data.refreshToken)
      alert('로그인 성공')
      nav('/')
    } catch (e) {
      alert('로그인 실패')
    }
  }

  const handleKakaoLogin = () => {
    window.location.href = 'http://localhost:8080/oauth2/authorization/kakao'
  }

  return (
    <div className="max-w-sm mx-auto p-6 mt-10 bg-white rounded-2xl shadow">
      <h2 className="text-2xl font-bold mb-6">SmartMove 로그인</h2>
      <input className="w-full border p-3 rounded-xl mb-3" placeholder="이메일" value={email} onChange={e=>setEmail(e.target.value)} />
      <input className="w-full border p-3 rounded-xl mb-4" type="password" placeholder="비밀번호" value={password} onChange={e=>setPassword(e.target.value)} />
      <button onClick={handleLogin} className="w-full bg-black text-white py-3 rounded-xl mb-3">로그인</button>
      <button onClick={handleKakaoLogin} className="w-full bg-[#FEE500] text-black py-3 rounded-xl font-bold">💬 카카오로 시작하기</button>
      <p className="text-center text-sm text-gray-500 mt-4">계정이 없나요? <a href="/signup" className="underline">회원가입</a></p>
    </div>
  )
}
