const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
      colors: {
        primary: {
          DEFAULT: 'rgb(var(--primary-color-default) / <alpha-value>)',
          50: 'rgb(var(--primary-color-50) / <alpha-value>)',
          100: 'rgb(var(--primary-color-100) / <alpha-value>)',
          200: 'rgb(var(--primary-color-200) / <alpha-value>)',
          300: 'rgb(var(--primary-color-300) / <alpha-value>)',
          400: 'rgb(var(--primary-color-400) / <alpha-value>)',
          500: 'rgb(var(--primary-color-500) / <alpha-value>)',
          600: 'rgb(var(--primary-color-600) / <alpha-value>)',
          700: 'rgb(var(--primary-color-700) / <alpha-value>)',
          800: 'rgb(var(--primary-color-800) / <alpha-value>)',
          900: 'rgb(var(--primary-color-900) / <alpha-value>)',
        },
        content: {
          1: 'rgb(var(--content-color-1) / <alpha-value>)',
          2: 'rgb(var(--content-color-2) / <alpha-value>)',
          alt1: 'rgb(var(--content-color-alt1) / <alpha-value>)',
          alt2: 'rgb(var(--content-color-alt2) / <alpha-value>)',
        }
      }
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
  ]
}
