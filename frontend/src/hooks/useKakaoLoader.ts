
import { useEffect, useState } from 'react'

const KAKAO_SDK_URL = `//dapi.kakao.com/v2/maps/sdk.js?appkey=${import.meta.env.VITE_KAKAO_MAP_KEY}&libraries=services,clusterer&autoload=false`

export function useKakaoLoader() {
  const [loaded, setLoaded] = useState(false)

  useEffect(() => {
    if (window.kakao && window.kakao.maps) {
      setLoaded(true)
      return
    }
    const script = document.createElement('script')
    script.src = KAKAO_SDK_URL
    script.async = true
    script.onload = () => {
      window.kakao.maps.load(() => {
        setLoaded(true)
      })
    }
    document.head.appendChild(script)
  }, [])

  return loaded
}

declare global {
  interface Window {
    kakao: any
  }
}
