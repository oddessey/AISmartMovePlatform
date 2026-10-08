
import { useSearchParams } from 'react-router-dom'

export default function PaymentFailPage() {
  const [params] = useSearchParams()
  return (
    <div className="max-w-sm mx-auto p-10 text-center">
      <h2 className="text-2xl font-bold text-red-600 mb-4">결제 실패</h2>
      <p>사유: {params.get('message') || '알 수 없는 오류'}</p>
      <a href="/payment" className="mt-6 inline-block bg-black text-white px-6 py-3 rounded-xl">다시 시도</a>
    </div>
  )
}
