<script setup>
  import {computed, ref, watch} from "vue";

  const devMode = import.meta.env.DEV

  const tData = ref({
    sText : 'Press To Interact',
    sKey : 'E',
    tColors: {
      background: 'rgba(0, 0, 0, 0.7)',
      secondaryBackground: 'rgba(31, 29, 29, 0.9)',
      key: 'rgb(255,255,255)',
      text: 'rgb(255,255,255)',
      border: 'rgba(51, 51, 51, 1)',
      holding: 'rgba(0, 174, 255, 1)',
    },
    bHolding: false,
    bShow: false,
  })

  const tHoldingState = ref({
    bIsHolding: false,
    fProgress: 0.0,
    iDuration: 0,
  })


  function updateColors(tColors) {
    if (!tColors) return

    tData.value.tColors.background = tColors.background || tData.value.tColors.background
    tData.value.tColors.secondaryBackground = tColors.secondaryBackground || tData.value.tColors.secondaryBackground
    tData.value.tColors.key = tColors.key || tData.value.tColors.key
    tData.value.tColors.text = tColors.text || tData.value.tColors.text
    tData.value.tColors.border = tColors.border || tData.value.tColors.border
    tData.value.tColors.holding = tColors.holding || tData.value.tColors.holding

  }


  window.addEventListener('message', (event) => {
    const { type, data } = event.data

    if (type === 'DSInteract:ShowInteract') {
      tData.value.bShow = true
      tData.value.sText = data.sText || tData.value.sText
      tData.value.sKey = data.sKey || tData.value.sKey
      tData.value.bHolding = data.bHolding || tData.value.bHolding
      updateColors(data.tColors)
    }

    if (type === 'DSInteract:UpdateInteract') {
      tData.value.sText = data.sText || tData.value.sText
      tData.value.sKey = data.sKey || tData.value.sKey
      tData.value.bHolding = data.bHolding || tData.value.bHolding
      tData.value.bShow = data.bShow || tData.value.bShow
      updateColors(data.tColors)
    }

    if (type === 'DSInteract:StartHolding') {
      tHoldingState.value.bIsHolding = true
      tHoldingState.value.fProgress = 0
      tHoldingState.value.iDuration = data.iDuration || 2000
    }

    if (type === 'DSInteract:UpdateHolding') {
      tHoldingState.value.fProgress = data.fProgress || 0
    }

    if (type === 'DSInteract:CompleteHolding') {
      tHoldingState.value.bIsHolding = false
      tHoldingState.value.fProgress = 1

      setTimeout(() => {
        tHoldingState.value.fProgress = 0
      }, 200)
    }

    if (type === 'DSInteract:CancelHolding') {
      tHoldingState.value.bIsHolding = false
      tHoldingState.value.fProgress = 0
    }


  })

</script>



<template>
  <div class="relative h-screen w-full overflow-hidden bg-none">
    <img alt="background-gta" v-if="devMode" src="/img/bg.png" class="absolute object-cover inset-0 w-full h-full">

      <div v-if="tData.bShow" class="flex absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 bg-none">
        <div class="flex items-center overflow-hidden h-[3em] w-fit rounded-[0.313em] p-[0.5em] gap-[0.5em]"
             :style="{backgroundColor: tData.tColors.background}"
        >

          <div
              class="flex items-center justify-center h-[2em] w-[2em] border-[0.063em] border-[--border-color] rounded-[0.313em] relative overflow-hidden "
              :style="{backgroundColor: tData.tColors.secondaryBackground, borderColor: tData.tColors.border}"
          >

            <div v-if="tData.bHolding && tHoldingState.bIsHolding"
                 class="absolute bottom-0 left-0 right-0 transition-all duration-50 rounded-b-[0.313em]"
                 :style="{
                   backgroundColor: tData.tColors.holding,
                   height: `${tHoldingState.fProgress * 100}%`
                 }"
            />

            <div  class="relative z-10" :style="{color: tData.tColors.key}">{{tData.sKey}}</div>
          </div>

          <div class="text-[1em]" :style="{color: tData.tColors.text}">{{tData.sText}}</div>

        </div>
      </div>


  </div>
</template>
