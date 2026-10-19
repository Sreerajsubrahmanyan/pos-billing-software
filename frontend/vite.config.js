import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
  plugins: [react(), tailwindcss()],
  build: {
    chunkSizeWarningLimit: 600,
    rollupOptions: {
      output: { manualChunks: { charts: ['recharts'] } },
    },
  },
  server: {
    host: '0.0.0.0',
    proxy: { '/api': process.env.VITE_API_PROXY || 'http://localhost:3000' },
  },
})
