<script setup>
    import { computed } from 'vue';
    import * as icons from "lucide-vue-next";

    const props = defineProps({
        name: {
            type: String,
            required: true
        },
        strokeWidth: Number,
    })

    const icon = computed(() => icons[props.name]);
</script>

<template>
  <component
    :is="icon"
    :stroke-width="strokeWidth"
  />
</template>