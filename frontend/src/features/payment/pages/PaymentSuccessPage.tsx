
import { useEffect, useState } from 'react'
import { useSearchParams, useNavigate } from 'react-router-dom'
import { api } from '../../../lib/api'

export default function PaymentSuccessPage() {
  const [searchParams] = useSearchParams()
  const nav = useNavigate()
  const [status, setStatus] = useState('처리중...')

  useEffect(() => {
    const paymentKey = searchParams.get('paymentKey')
    const orderId = searchParams.get('orderId')
    const amount = searchParams.get('amount')

    if (!paymentKey || !orderId || !amount) {
      setStatus('잘못된 접근')
      return
    }

    // 백엔드로 승인 요청
    api.post('/payments/confirm', {
      paymentKey,
      orderId,
      amount: parseInt(amount)
    })
    .then(res => {
      setStatus(`결제 성공! ${res.data.totalAmount.toLocaleString()}원`)
      setTimeout(() => nav('/'), 2000)
    })
    .catch((e) => {
      setStatus('결제 승인 실패: ' + (e.response?.data?.message || e.message))
    })
  }, [])

  return (
    <div className="max-w-sm mx-auto p-10 text-center">
      <h2 className="text-2xl font-bold mb-4">💳 결제 처리</h2>
      <p className="text-lg">{status}</p>
    </div>
  )
}
