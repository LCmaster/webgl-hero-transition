<script>
  import { tweened } from "svelte/motion";
  import { cubicInOut, quadInOut } from "svelte/easing";
  import { Canvas } from "@threlte/core";
  import { transitions } from "@threlte/extras";

  import { fade, fly } from "svelte/transition";

  import HeroScene from "./HeroScene.svelte";

  let width;
  let height;

  let destination = [
    {
      title: "Maldives",
      subtitle: "Enjoy the sunny side of life.",
      image: "/maldives.jpg",
    },
    {
      title: "Highlands",
      subtitle: "Discover Scotland, one step at a time.",
      image: "/highlands.jpg",
    },
    {
      title: "Sahara",
      subtitle: "Where life is a journey, not a destination!",
      image: "/sahara.jpg",
    },
    {
      title: "Dolomites",
      subtitle: "A paradise for those who love sport.",
      image: "/dolomites.jpg",
    },
  ];

  let current = 0;

  let direction = 1;
  const progress = tweened(direction, {
    duration: 1500,
    easing: quadInOut,
  });

  function next() {
    progress.set(direction * -1);
    current = (current + 1) % destination.length;
  }

  function previous() {
    progress.set(direction * -1);
    current =
      (current - 1 < 0 ? destination.length - 1 : current - 1) %
      destination.length;
  }

  transitions();
</script>

<div
  class="fixed top-0 left-0 w-screen h-screen"
  bind:clientWidth={width}
  bind:clientHeight={height}
>
  <Canvas>
    <HeroScene
      {width}
      {height}
      progress={$progress}
      current={destination[current].image}
      images={destination.map((dest) => dest.image)}
    />
  </Canvas>
</div>
<div class="absolute top-0 left-0 w-screen h-screen">
  <div class="container mx-auto h-full">
    <div class="h-full py-2 flex flex-col justify-between gap-2 text-center">
      <header class="flex justify-between items-center">
        <h1 class="font-inter font-medium text-lg text-white">Some Title</h1>
        <input
          type="text"
          placeholder="Search"
          class="px-4 py-2 rounded-full font-inter"
        />
      </header>
      {#each destination as dest, i}
        {#if current === i}
          <h1
            class="order-first absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-full font-cormorantGaramond font-light text-4xl md:text-6xl tracking-widest text-white uppercase"
            in:fly={{ y: -50, duration: 250, delay: 500, easing: cubicInOut }}
            out:fly={{ y: -50, duration: 250, delay: 250, easing: cubicInOut }}
          >
            {dest.title}
          </h1>
          <p
            class="order-last absolute top-1/2 left-1/2 -translate-x-1/2 translate-y-full font-inter text-white"
            in:fly={{ y: 50, duration: 250, delay: 500, easing: cubicInOut }}
            out:fly={{ y: 50, duration: 250, delay: 250, easing: cubicInOut }}
          >
            {dest.subtitle}
          </p>
        {/if}
      {/each}
      <footer class="flex justify-between">
        <button
          on:click={() => previous()}
          class="px-6 py-2 rounded-full font-inter text-white bg-white/10 hover:font-bold"
          >Prev</button
        ><button
          on:click={() => next()}
          class="px-6 py-2 rounded-full font-inter font-inter text-white bg-white/10 hover:font-bold"
          >Next</button
        >
      </footer>
    </div>
  </div>
</div>
