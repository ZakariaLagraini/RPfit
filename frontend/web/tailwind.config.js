/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./src/**/*.{html,ts,js}", // Adjust this to match your project
  ],
  theme: {
    extend: {
      fontFamily: {
        heading: ['Bebas Neue', 'sans-serif'],
        body: ['Roboto', 'sans-serif'],
        title: ['Montserrat', 'sans-serif'],
      },
    },
  },
  plugins: [],
};
