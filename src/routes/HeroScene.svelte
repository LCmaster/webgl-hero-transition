<script lang="ts">
  import type * as THREE from "three";
  import { T } from "@threlte/core";

  export let width: number;
  export let height: number;

  const cameraDistance = 600;

  let camera: THREE.PerspectiveCamera;

  function computeFov() {
    return 2 * Math.atan(height / 2 / cameraDistance) * (180 / Math.PI);
  }

  async function loadShader() {
    return await Promise.all([fetch("/vertex.glsl"), fetch("/fragment.glsl")])
      .then((res) => Promise.all(res.map((file) => file.text())))
      .then((res) => ({ vertex: res[0], fragment: res[1] }));
  }
</script>

<svelte:window on:resize={() => (camera.fov = computeFov())} />

<T.PerspectiveCamera
  bind:ref={camera}
  makeDefault
  fov={computeFov()}
  near={100}
  far={1100}
  position={[0, 0, cameraDistance]}
  on:create={() => {
    camera.lookAt(0, 0, 0);
  }}
/>
{#await loadShader() then shader}
  <T.Mesh position={[0, 0, 0]}>
    <T.PlaneGeometry args={[width, height, 10, 10]} />
    <T.ShaderMaterial
      wireframe
      vertexShader={shader?.vertex}
      fragmentShader={shader?.fragment}
    />
  </T.Mesh>
{/await}
