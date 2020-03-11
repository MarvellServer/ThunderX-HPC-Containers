Build and ran GPU version of SPECFEM3D on TX2+2GPU system.

Nvidia maintains a page on Specfem3d which has steps to build and run the code for GPU. The page also provides a a comparison of performance of Specfem3d across Broadwell, 1GPU, 2GPU, and 4 GPU.
https://www.nvidia.com/es-la/data-center/gpu-accelerated-applications/specfem3d-globe/

Important points are to use the following version when building for the GPU:
https://geodynamics.org/cig/software/specfem3d_globe/SPECFEM3D_GLOBE_V7.0.0.tar.gz

The example used is a modified version of the “global_s362ani_shakemovie” example that is distributed with SPECFEM3D Globe.
For this example, use Par_file, and STATIONS and CMTSOLUTION files provided at Nvidia site:
https://images.nvidia.com/content/tesla/specfem3d-globe/parfiles.tar

Nvidia reports the performance of SPECFEM3D as Iterations/hour. Which seems to be inverse of the time elapsed in execution of xspecfem3D. Time elapsed on xmeshfem3d is not reported.
