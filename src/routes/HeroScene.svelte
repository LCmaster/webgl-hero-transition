<script lang="ts">
  import * as THREE from "three";
  import { T } from "@threlte/core";
  import { useTexture } from "@threlte/extras";

  import { createTransition } from "@threlte/extras";
  import { cubicInOut, quadInOut, quadOut } from "svelte/easing";

  export let width: number;
  export let height: number;

  export let current: string;
  export let images: Array<string> = [];

  export let progress: number;

  let cameraDistance = 600;
  let camera: THREE.PerspectiveCamera;

  let material: THREE.ShaderMaterial;

  function computeFov() {
    return 2 * Math.atan(height / 2 / cameraDistance) * (180 / Math.PI);
  }

  async function loadShader() {
    return await Promise.all([fetch("/vertex.glsl"), fetch("/fragment.glsl")])
      .then((res) => Promise.all(res.map((file) => file.text())))
      .then((res) => ({ vertex: res[0], fragment: res[1] }));
  }

  function map(
    value: number,
    inMin: number,
    inMax: number,
    outMin: number,
    outMax: number
  ): number {
    if (value <= inMin) return outMin;
    if (value >= inMax) return outMax;

    return ((value - inMin) * (outMax - outMin)) / (inMax - inMin) + outMin;
  }

  let introHasEnded = false;

  const fade = createTransition<THREE.Material>((ref, { direction }) => {
    ref.transparent = true;
    return {
      tick(t) {
        if (direction === "in")
          ref.uniforms.u_opacity.value = map(t, 0.25, 0.75, 0, 1);
        if (direction === "out")
          ref.uniforms.u_opacity.value = map(t, 0.0, 0.5, 0, 1);
        if (introHasEnded) {
          const angle = direction === "in" ? t : 1 - t;
          material.uniforms.u_zoom.value = map(angle, 0.0, 1.0, 1.25, 1.0);

          material.uniforms.u_innerAngle.value = map(angle, 0, 0.5, 0, 1);
          material.uniforms.u_middleAngle.value = map(angle, 0.25, 0.75, 0, 1);
          material.uniforms.u_outterAngle.value = map(angle, 0.5, 1, 0, 1);
        }
      },
      easing: quadInOut,
      duration: 1500,
    };
  });

  function getScaleFactor(
    image: { width: number; height: number },
    container: { width: number; height: number }
  ) {
    var imageRatio = image.width / image.height;
    var containerRatio = container.width / container.height;

    return imageRatio > containerRatio
      ? container.height / image.height
      : container.width / image.width;
  }
</script>

<svelte:window
  on:resize={() => {
    camera.fov = computeFov();
    if (material) {
      material.uniforms.u_screenAspectRatio.value = width / height;
      material.uniforms.u_screenResolution.value = new THREE.Vector2(
        width,
        height
      );
    }
  }}
/>

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
{#each images as image, i}
  {#await useTexture(image) then texture}
    {#await loadShader() then shader}
      {#if current === image}
        {@const scaleFactor = getScaleFactor(
          { width: texture.image.width, height: texture.image.height },
          { width, height }
        )}
        <T.Mesh position={[0, 0, 0]}>
          <T.PlaneGeometry
            args={[
              texture.image.width * scaleFactor,
              texture.image.height * scaleFactor,
              1,
              1,
            ]}
          />
          <T.ShaderMaterial
            bind:ref={material}
            transparent
            uniforms={{
              u_imageAspectRatio: {
                value: texture.image.width / texture.image.height,
              },
              u_screenAspectRatio: { value: width / height },
              u_screenResolution: { value: new THREE.Vector2(width, height) },
              u_imageResolution: {
                value: new THREE.Vector2(
                  texture.image.width,
                  texture.image.height
                ),
              },
              u_zoom: { value: 1.0 },
              u_opacity: { value: 1.0 },
              u_innerAngle: { value: 0.0 },
              u_middleAngle: { value: 0.0 },
              u_outterAngle: { value: 0.0 },
              colorMap: { value: texture },
            }}
            vertexShader={shader.vertex}
            fragmentShader={shader.fragment}
            in={fade}
            out={fade}
            on:introend={() => (introHasEnded = true)}
          />
        </T.Mesh>
      {/if}
    {/await}
  {/await}
{/each}
