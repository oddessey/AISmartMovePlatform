
import { useState } from 'react'
import { api } from '../../../lib/api'
import { useNavigate } from 'react-router-dom'

export default function SignupPage() {
  const [form, setForm] = useState({ email: '', password: '', name: '', phone: '', role: 'CLIENT' })
  const nav = useNavigate()

  const handleSignup = async () => {
    try {
      await api.post('/auth/signup', form)
      alert('회원가입 성공! 로그인해주세요')
      nav('/login')
    } catch (e: any) {
      alert(e.response?.data?.message || '회원가입 실패')
    }
  }

  return (
    <div className="max-w-sm mx-auto p-6 mt-10 bg-white rounded-2xl shadow">
      <h2 className="text-2xl font-bold mb-6">회원가입</h2>
      <input className="w-full border p-3 rounded-xl mb-2" placeholder="이름" onChange={e=>setForm({...form, name: e.target.value})} />
      <input className="w-full border p-3 rounded-xl mb-2" placeholder="이메일" onChange={e=>setForm({...form, email: e.target.value})} />
      <input className="w-full border p-3 rounded-xl mb-2" type="password" placeholder="비밀번호 (8자 이상)" onChange={e=>setForm({...form, password: e.target.value})} />
      <input className="w-full border p-3 rounded-xl mb-3" placeholder="전화번호 010-****-****" onChange={e=>setForm({...form, phone: e.target.value})} />
      <select className="w-full border p-3 rounded-xl mb-4" value={form.role} onChange={e=>setForm({...form, role: e.target.value})}>
        <option value="CLIENT">고객으로 가입</option>
        <option value="ENGINEER">기사로 가입</option>
      </select>
      <button onClick={handleSignup} className="w-full bg-black text-white py-3 rounded-xl">가입하기</button>
    </div>
  )
}
