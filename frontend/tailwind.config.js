/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{js,jsx}'],
  theme: {
    extend: {
      colors: {
        ink: '#202820',
        muted: '#7d837b',
        canvas: '#f8f6f2',
        line: '#eae8e2',
        forest: '#284b3b',
        moss: '#748b61',
        clay: '#bd7659',
        gold: '#bd9854',
      },
      fontFamily: { sans: ['DM Sans', 'sans-serif'], display: ['Manrope', 'sans-serif'] },
      boxShadow: { card: '0 8px 24px rgba(31, 41, 31, .045)' },
    },
  },
  plugins: [],
}
