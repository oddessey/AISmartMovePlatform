
import { useEffect, useRef } from 'react'
import { useKakaoLoader } from '../../hooks/useKakaoLoader'

interface EngineerMarker {
  id: number
  lat: number
  lng: number
  name: string
  rating: number
  isAvailable: boolean
}

interface Props {
  center: { lat: number; lng: number }
  engineers?: EngineerMarker[]
  onMarkerClick?: (id: number) => void
}

export default function KakaoMap({ center, engineers = [], onMarkerClick }: Props) {
  const mapRef = useRef<HTMLDivElement>(null)
  const loaded = useKakaoLoader()
  const mapInstance = useRef<any>(null)

  useEffect(() => {
    if (!loaded || !mapRef.current) return

    const { kakao } = window
    const options = {
      center: new kakao.maps.LatLng(center.lat, center.lng),
      level: 5,
    }
    const map = new kakao.maps.Map(mapRef.current, options)
    mapInstance.current = map

    // 내 위치 마커
    const myPos = new kakao.maps.Marker({
      position: new kakao.maps.LatLng(center.lat, center.lng),
      map,
    })
    const myInfowindow = new kakao.maps.InfoWindow({
      content: '<div style="padding:5px;font-size:12px;">📍 내 위치</div>',
    })
    myInfowindow.open(map, myPos)

    // 기사 마커들
    engineers.forEach((eng) => {
      const markerPos = new kakao.maps.LatLng(eng.lat, eng.lng)
      const marker = new kakao.maps.Marker({
        position: markerPos,
        map,
        image: new kakao.maps.MarkerImage(
          'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png',
          new kakao.maps.Size(24, 35)
        ),
      })

      const content = `
        <div style="padding:8px;min-width:150px;">
          <b>🔧 ${eng.name}</b> <span style="color:${eng.isAvailable ? 'green' : 'red'}">● ${eng.isAvailable ? '가용' : '작업중'}</span><br/>
          ⭐ ${eng.rating} / 5.0<br/>
          <button style="margin-top:4px;background:black;color:white;padding:2px 8px;border-radius:6px;font-size:12px;">배정하기</button>
        </div>
      `
      const infowindow = new kakao.maps.InfoWindow({ content })

      kakao.maps.event.addListener(marker, 'click', () => {
        infowindow.open(map, marker)
        onMarkerClick?.(eng.id)
      })
    })

    // 반경 원
    new kakao.maps.Circle({
      center: new kakao.maps.LatLng(center.lat, center.lng),
      radius: 3000,
      strokeWeight: 2,
      strokeColor: '#000',
      strokeOpacity: 0.2,
      fillColor: '#000',
      fillOpacity: 0.05,
      map,
    })

  }, [loaded, center, engineers])

  if (!loaded) return <div className="h-[400px] flex items-center justify-center bg-gray-100 rounded-xl">🗺️ 카카오맵 로딩중...</div>

  return <div ref={mapRef} className="w-full h-[500px] rounded-2xl shadow" />
}
