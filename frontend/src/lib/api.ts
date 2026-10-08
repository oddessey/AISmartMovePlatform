
import axios from 'axios'

export const api = axios.create({
  baseURL: '/api/v1',
  timeout: 30000,
})

export const aiApi = axios.create({
  baseURL: 'http://localhost:8000/api/v1',
  timeout: 30000,
})
