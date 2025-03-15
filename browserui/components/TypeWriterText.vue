<template>
  <div class="typewritertext">
    <span v-for="(character, index) in renderedText" :key="index" class="character fade-element">
      <template v-if="character === ' '">&nbsp;</template>
      <template v-else>{{ character }}</template>
    </span>
  </div>
</template>

<script>
export default {
  props: {
    text: {
      type: String,
      required: true,
    },
    typingDelay: {
      type: Number,
      default: 30,
    },
  },
  data() {
    return {
      renderedText: [],
    };
  },
  methods: {
    renderText() {
      // Split the string into an array using split("")
      const textArray = this.text.split("");

      // Initialize renderedText array
      this.renderedText = new Array(textArray.length).fill("");

      let current = 0;

      const typeNextCharacter = () => {
        if (current < textArray.length) {
          // Create a new array to ensure reactivity
          const updatedText = [...this.renderedText];
          updatedText[current] = textArray[current];
          this.renderedText = updatedText;

          current++;

          // Schedule the next character
          setTimeout(typeNextCharacter, this.typingDelay);
        }
      };

      // Start the typing process
      typeNextCharacter();
    },
  },
  mounted() {
    this.renderText();
  },
};
</script>

<style scoped lang="scss">
.typewritertext {
  display: inline-block;
  font-size: 3rem;
  color: $white;

  transition: all .5s ease;
}

.character {
  display: inline-block;
}
</style>
