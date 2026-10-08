
import { useEffect, useRef, useState } from 'react'
import { useLocation } from 'react-router-dom'
import { api } from '../../../lib/api'

declare global {
  interface Window {
    TossPayments: any
  }
}

export default function PaymentPage() {
  const location = useLocation()
  const { amount, orderName, orderId } = location.state || { amount: 180000, orderName: 'LG 에어컨 이전설치', orderId: 1 }
  const widgetRef = useRef<any>(null)
  const [tossOrderId, setTossOrderId] = useState<string>('')

  useEffect(() => {
    // 1. 백엔드에서 tossOrderId 생성
    api.post('/payments/create', { orderId, amount, orderName })
      .then(res => {
        setTossOrderId(res.data.tossOrderId)
        initTossWidget(res.data.tossOrderId, amount, res.data.customerEmail)
      })
      .catch(() => {
        // 백엔드 없을 때 Mock
        const mockId = `SM_${Date.now()}`
        setTossOrderId(mockId)
        initTossWidget(mockId, amount, 'test@test.com')
      })
  }, [])

  const initTossWidget = async (orderId: string, amount: number, email: string) => {
    // Toss SDK 로드
    if (!window.TossPayments) {
      const script = document.createElement('script')
      script.src = 'https://js.tosspayments.com/v1/payment-widget'
      script.onload = () => renderWidget(orderId, amount, email)
      document.head.appendChild(script)
    } else {
      renderWidget(orderId, amount, email)
    }
  }

  const renderWidget = (orderId: string, amount: number, email: string) => {
    const clientKey = import.meta.env.VITE_TOSS_CLIENT_KEY || 'test_gck_docs_Ovk5rk1EwkEbP0W43n07xlzm'
    const tossPayments = window.TossPayments(clientKey)

    // 결제 위젯 렌더링
    tossPayments.widgets({ customerKey: email }).then((widgets: any) => {
      widgets.setAmount({ currency: 'KRW', value: amount })

      widgets.renderPaymentMethods({
        selector: '#payment-methods',
        variantKey: 'DEFAULT'
      })

      widgets.renderAgreement({
        selector: '#agreement',
        variantKey: 'AGREEMENT'
      })

      widgetRef.current = widgets
    })
  }

  const handlePay = async () => {
    try {
      await widgetRef.current?.requestPayment({
        orderId: tossOrderId,
        orderName,
        successUrl: `${window.location.origin}/payment/success`,
        failUrl: `${window.location.origin}/payment/fail`,
      })
    } catch (e) {
      console.error(e)
    }
  }

  return (
    <div className="max-w-xl mx-auto p-6">
      <div className="bg-white rounded-2xl shadow p-6">
        <h2 className="text-2xl font-bold mb-2">결제하기</h2>
        <p className="text-gray-500 mb-4">{orderName} - {amount.toLocaleString()}원</p>

        <div id="payment-methods" className="mb-4" />
        <div id="agreement" className="mb-6" />

        <button onClick={handlePay} className="w-full bg-[#0064FF] text-white py-4 rounded-xl font-bold text-lg">
          {amount.toLocaleString()}원 결제하기
        </button>

        <p className="text-xs text-gray-400 mt-4 text-center">테스트 카드: 4111-1111-1111-1111 / 유효기간 미래 / CVC 123</p>
      </div>
    </div>
  )
}
