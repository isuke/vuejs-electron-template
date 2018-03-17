<template lang="pug">
.top
  img(src='@assets/logo.png')
  h1 \{{ msg }}
  router-link(:to="{ name: 'bye'}") Bye!
</template>

<script lang="coffee">
export default
  data: ->
    msg: 'Welcome to Your Vue.js App'
</script>

{{#if_eq altCss "scss"}}
<style lang="scss" scoped>
.top {
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  margin-top: 60px;

  h1, h2 {
    font-weight: normal;;
  }

  ul {
    list-style-type: none;
    padding: 0;
  }

  li {
    display: inline-block;
    margin: 0 10px;
  }

  a {
    color: #42b983;
  }
}
</style>
{{/if_eq}}
{{#if_eq altCss "stylus"}}
<style lang="stylus" scoped>
.top
  -webkit-font-smoothing: antialiased
  -moz-osx-font-smoothing: grayscale
  text-align: center
  margin-top: 60px

  h1, h2
    font-weight: normal

  ul
    list-style-type: none
    padding: 0

  li
    display: inline-block
    margin: 0 10px

  a
    color: #42b983
</style>
{{/if_eq}}
