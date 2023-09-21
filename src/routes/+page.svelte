<script>
  import { Canvas } from "@threlte/core";
  import HeroScene from "./HeroScene.svelte";

  let width;
  let height;
</script>

<div
  class="fixed top-0 left-0 w-screen h-screen overflow-hidden"
  bind:clientWidth={width}
  bind:clientHeight={height}
>
  <Canvas>
    <HeroScene {width} {height} />
  </Canvas>
</div>
<div class="absolute top-0 left-0 w-screen h-screen">
  <h1>Welcome to SvelteKit</h1>
  <p>
    Visit <a href="https://kit.svelte.dev">kit.svelte.dev</a> to read the documentation
  </p>

  <p>
    Lorem ipsum dolor sit amet consectetur, adipisicing elit. Quis amet
    laudantium mollitia odit, doloremque reprehenderit nihil voluptas! Unde
    ducimus asperiores dolorum ab ratione, similique commodi est ipsa incidunt,
    accusantium alias.
  </p>
  <p>
    Lorem ipsum dolor sit amet consectetur, adipisicing elit. Quis amet
    laudantium mollitia odit, doloremque reprehenderit nihil voluptas! Unde
    ducimus asperiores dolorum ab ratione, similique commodi est ipsa incidunt,
    accusantium alias.
  </p>
  <p>
    Lorem ipsum dolor sit amet consectetur, adipisicing elit. Quis amet
    laudantium mollitia odit, doloremque reprehenderit nihil voluptas! Unde
    ducimus asperiores dolorum ab ratione, similique commodi est ipsa incidunt,
    accusantium alias.
  </p>
  <p>
    Lorem ipsum dolor sit amet consectetur, adipisicing elit. Quis amet
    laudantium mollitia odit, doloremque reprehenderit nihil voluptas! Unde
    ducimus asperiores dolorum ab ratione, similique commodi est ipsa incidunt,
    accusantium alias.
  </p>
  <p>
    Lorem ipsum dolor sit amet consectetur, adipisicing elit. Quis amet
    laudantium mollitia odit, doloremque reprehenderit nihil voluptas! Unde
    ducimus asperiores dolorum ab ratione, similique commodi est ipsa incidunt,
    accusantium alias.
  </p>
  <p>
    Lorem ipsum dolor sit amet consectetur, adipisicing elit. Quis amet
    laudantium mollitia odit, doloremque reprehenderit nihil voluptas! Unde
    ducimus asperiores dolorum ab ratione, similique commodi est ipsa incidunt,
    accusantium alias.
  </p>
  <p>
    Lorem ipsum dolor sit amet consectetur, adipisicing elit. Quis amet
    laudantium mollitia odit, doloremque reprehenderit nihil voluptas! Unde
    ducimus asperiores dolorum ab ratione, similique commodi est ipsa incidunt,
    accusantium alias.
  </p>
  <p>
    Lorem ipsum dolor sit amet consectetur, adipisicing elit. Quis amet
    laudantium mollitia odit, doloremque reprehenderit nihil voluptas! Unde
    ducimus asperiores dolorum ab ratione, similique commodi est ipsa incidunt,
    accusantium alias.
  </p>
  <p>
    Lorem ipsum dolor sit amet consectetur, adipisicing elit. Quis amet
    laudantium mollitia odit, doloremque reprehenderit nihil voluptas! Unde
    ducimus asperiores dolorum ab ratione, similique commodi est ipsa incidunt,
    accusantium alias.
  </p>
</div>
