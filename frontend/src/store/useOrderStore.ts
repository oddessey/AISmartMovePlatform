
import { create } from 'zustand'

interface OrderState {
  detected: any | null
  estimatedPrice: number | null
  setEstimate: (detected: any, price: number) => void
}

export const useOrderStore = create<OrderState>((set) => ({
  detected: null,
  estimatedPrice: null,
  setEstimate: (detected, price) => set({ detected, estimatedPrice: price }),
}))
