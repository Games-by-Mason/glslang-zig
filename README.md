# Glslang Zig

Glslang ported to the Zig build system.

Contributions or bug reports are welcome if behavior differs from official build system.

## Usage

See [shader_compiler](https://github.com/Games-by-Mason/shader_compiler) for example usage.

## Version

See [build.zig.zon](build.zig.zon) for current version info. Dependencies will be updated to point at the next glslang release when it's available ([this commit](https://github.com/KhronosGroup/glslang/commit/5939e32b87487fa9c72ab336ebfcc5ae26d9ab6d) is necessary for a good debug build experience.)

## Known Differences

* The official build process has a web target for the `glslang` artifact, but this project does not. Contributions are welcome.
* The official build process symlinks `glslang` to `glslangValidator`. This build outputs `glslangValidator` instead of `glslang` and does not provide a symlink because the library artifact is already named `glslang`.
* The tests are not built.
* Compiler flags for exceptions, rtti, etc are not configurable (see [build.zig](build.zig) for current values.)

## How To Change the Glslang Version

The version of glslang is set in [build.zig.zon](build.zig.zon).

Glslang depends on SPIRV-Headers, and SPIRV-Tools. When changing the glslang version you may need to update these dependencies, to find out if this is necessary check your glslang's `known-good.json`.

Glslang and SPIRV-Tools' official build processes generate headers at compile time. These are cached in the `generated` directory, and can be regenerated via the official build processes.
