
import { useState } from 'react'
import { api } from '../../../lib/api'
import { useOrderStore } from '../../../store/useOrderStore'

export default function EstimatePage() {
  const [files, setFiles] = useState<FileList | null>(null)
  const [loading, setLoading] = useState(false)
  const { detected, estimatedPrice, setEstimate } = useOrderStore()

  const handleEstimate = async () => {
    if (!files) return
    setLoading(true)
    const formData = new FormData()
    Array.from(files).forEach(f => formData.append('images', f))
    formData.append('from_address', '서울 강남구')
    formData.append('to_address', '서울 송파구')

    try {
      const { data } = await api.post('/orders/estimate', formData, {
        headers: { 'Content-Type': 'multipart/form-data' }
      })
      setEstimate(data.detected, data.ai_estimated_price)
    } catch (e) {
      alert('견적 실패: AI 서버 연결을 확인하세요')
      console.error(e)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="max-w-2xl mx-auto p-6">
      <div className="bg-white rounded-2xl shadow p-6">
        <h2 className="text-2xl font-bold mb-2">AI 간편 견적</h2>
        <p className="text-gray-500 mb-4">가전 사진 2~3장을 올리면 AI가 모델을 인식해 즉시 견적을 드려요</p>

        <input type="file" multiple accept="image/*" onChange={e => setFiles(e.target.files)}
               className="w-full border p-3 rounded-lg mb-4" />

        <button onClick={handleEstimate} disabled={loading || !files}
                className="w-full bg-black text-white py-3 rounded-xl font-semibold disabled:bg-gray-300">
          {loading ? 'AI 분석중...' : 'AI 견적 받기 🤖'}
        </button>

        {detected && (
          <div className="mt-6 p-4 bg-gray-50 rounded-xl">
            <h3 className="font-bold">AI 인식 결과 (confidence: {detected.confidence})</h3>
            <p>브랜드: {detected.brand} / 모델: {detected.model} / 타입: {detected.type}</p>
            <p className="text-xl font-bold mt-2">예상 견적: {estimatedPrice?.toLocaleString()}원</p>
          </div>
        )}
      </div>
    </div>
  )
}
