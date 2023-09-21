<script>
  import { Canvas } from "@threlte/core";
  import HeroScene from "./HeroScene.svelte";

  let width;
  let height;

  let previous = 0;
  let current = 0;
  let next = 0;
  let images = ["/maldives.jpg"];
</script>

<div
  class="fixed top-0 left-0 w-screen h-screen overflow-hidden"
  bind:clientWidth={width}
  bind:clientHeight={height}
>
  <Canvas>
    <HeroScene {width} {height} current={images[current]} />
  </Canvas>
</div>
<div class="absolute top-0 left-0 w-screen h-screen">
  <div
    class="min-h-screen px-4 flex flex-col justify-center items-center gap-2"
  >
    <h1 class="font-cormorantGaramond text-7xl tracking-[2rem] text-white">
      Maldives
    </h1>
    <img src="/separator.svg" alt="separator" class="object-cover" />
    <p class="font-inter text-white">Enjoy the sunny side of life</p>
  </div>
</div>
