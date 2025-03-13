module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim,rb}'
  ],
  safelist: [
    { pattern: /^text-(xs|sm|base|lg|xl|2xl|3xl|4xl|5xl|6xl|7xl|8xl|9xl)$/ },
  ],
  theme: {
    extend: {
      colors: {
        positive: "oklch(var(--positive) / <alpha-value>)",
        negative: "oklch(var(--negative) / <alpha-value>)",
      },
      keyframes: {
        'slide-in-out': {
          '0%': { transform: 'translateY(100%)', opacity: '0' },
          '10%': { transform: 'translateY(0)', opacity: '1' },
          '90%': { transform: 'translateY(0)', opacity: '1' },
          '100%': { transform: 'translateY(100%)', opacity: '0' },
        },
      },
      animation: {
        'slide-in-out': 'slide-in-out 3s ease-in-out forwards',
      },
    },
  },
  plugins: []
}
