/** @type {import('tailwindcss').Config}*/
const config = {
  content: ["./src/**/*.{html,js,svelte,ts}"],

  theme: {
    extend: {
      fontFamily: {
        inter: ["Inter", "sans-serif"],
        cormorantGaramond: ["Cormorant Garamond", "serif"],
      },
    },
  },

  plugins: [],
};

module.exports = config;
