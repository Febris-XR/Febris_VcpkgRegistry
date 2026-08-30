# Febris vcpkg registry

A vcpkg git registry serving the native Febris SDK as a package. The port
installs the prebuilt bundle from the [Febris_SDK GitHub
Releases](https://github.com/TRget88/Febris_SDK/releases) -- the identical
artifact, pinned by SHA512 -- so `vcpkg install` and a manual download give you
byte-for-byte the same SDK.

| Port | What it installs |
|---|---|
| `febris-simulation-sdk` | `FebrisSimApi.h` (flat C ABI), `Febris.CppSimulationLibrary.dll` + import lib, Windows x64 |

## Using it

Add this registry to your project's `vcpkg-configuration.json`, next to your
existing default registry:

```json
{
  "registries": [
    {
      "kind": "git",
      "repository": "https://github.com/TRget88/Febris_VcpkgRegistry",
      "baseline": "<latest commit sha of this repository>",
      "packages": ["febris-simulation-sdk"]
    }
  ]
}
```

Get the baseline with:

```
git ls-remote https://github.com/TRget88/Febris_VcpkgRegistry HEAD
```

Then depend on it in your `vcpkg.json`:

```json
{
  "dependencies": ["febris-simulation-sdk"]
}
```

Supported triplet: `x64-windows` (the SDK is a prebuilt dynamic library; static
triplets and UWP are declared unsupported). After install, see the printed
usage text: the SDK has no CMake targets, you link the import library or bind
at runtime with `LoadLibrary`/`GetProcAddress` against the flat `extern "C"`
exports declared in `FebrisSimApi.h`.

## Guarantees

The bundle a port version installs was published by the Febris_SDK repository's
`release-cpp` workflow, which builds from the tagged source and refuses to
publish unless the cross-SDK conformance harness proves the DLL emits
byte-identical xAPI statement JSON to the C# SDK
([`Febris.Simulation.XApiSdk`](https://www.nuget.org/packages/Febris.Simulation.XApiSdk))
at the same version. The two SDKs are one product at every version number.

## Updating this registry

Maintainers: the registry content is generated, not hand-edited. The source of
truth lives in the Febris workshop (`release/vcpkg-registry/` plus
`release/export/cut-vcpkg-registry.sh`), which recomputes the port's git-tree
object hash and rewrites `versions/` deterministically. Hand-editing
`versions/*.json` risks a tree-hash mismatch that breaks every consumer's
install.

## License

The registry metadata in this repository is Apache-2.0, the same license as
the SDK it serves.
