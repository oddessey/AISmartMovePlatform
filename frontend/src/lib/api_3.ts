
import axios from 'axios'

export const api = axios.create({
  baseURL: '/api/v1',
  timeout: 30000,
})

// JWT 자동 첨부
api.interceptors.request.use((config) => {
  const token = localStorage.getItem('accessToken')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

// 401이면 로그인 페이지로
api.interceptors.response.use(
  (res) => res,
  (err) => {
    if (err.response?.status === 401) {
      localStorage.removeItem('accessToken')
      window.location.href = '/login'
    }
    return Promise.reject(err)
  }
)

export const aiApi = axios.create({
  baseURL: 'http://localhost:8000/api/v1',
  timeout: 30000,
})
