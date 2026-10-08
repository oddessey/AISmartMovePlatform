
import { useState, useEffect } from 'react'
import KakaoMap from '../../../components/map/KakaoMap'
import { api } from '../../../lib/api'

export default function OrderTrackingPage() {
  const [center] = useState({ lat: 37.5665, lng: 126.9780 }) // 서울시청
  const [engineers, setEngineers] = useState([])

  useEffect(() => {
    api.get('/engineers/nearby?lat=37.5665&lng=126.9780&radius=5km')
      .then(res => setEngineers(res.data))
      .catch(() => {
        // Mock 데이터 (백엔드 없을 때)
        setEngineers([
          { id: 1, lat: 37.568, lng: 126.98, name: '김기사', rating: 4.9, isAvailable: true },
          { id: 2, lat: 37.56, lng: 126.97, name: '박설치', rating: 4.8, isAvailable: true },
          { id: 3, lat: 37.57, lng: 126.985, name: '이명장', rating: 5.0, isAvailable: false },
        ] as any)
      })
  }, [])

  return (
    <div className="max-w-4xl mx-auto p-6">
      <h2 className="text-2xl font-bold mb-4">실시간 근처 기사</h2>
      <KakaoMap center={center} engineers={engineers} />
      <div className="mt-4 grid grid-cols-3 gap-3">
        {engineers.map((eng: any) => (
          <div key={eng.id} className="bg-white p-3 rounded-xl shadow text-sm">
            <b>{eng.name}</b> ⭐ {eng.rating}<br/>
            <span className={eng.isAvailable ? 'text-green-600' : 'text-red-500'}>
              {eng.isAvailable ? '배정 가능' : '작업 중'}
            </span>
          </div>
        ))}
      </div>
    </div>
  )
}
