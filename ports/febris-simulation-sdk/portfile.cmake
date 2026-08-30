# febris-simulation-sdk: installs the PREBUILT bundle from the Febris_SDK
# GitHub Release for v${VERSION} -- the same artifact the Releases page serves,
# checksum-chained twice: the release carries SHA256SUMS, and this portfile
# pins the SHA512 of the identical zip. The bundle is produced by the repo's
# release-cpp workflow only after the cross-SDK conformance harness proves the
# DLL emits byte-identical statement JSON to the C# SDK at the same version.
#
# The DLL exposes a flat extern "C" ABI (FebrisSimApi.h) passing only ints,
# C strings and caller-owned buffers, so the release binary is safe to load
# from debug consumer builds; the debug tree deliberately receives the same
# release binaries.

vcpkg_check_linkage(ONLY_DYNAMIC_LIBRARY)

vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/TRget88/Febris_SDK/releases/download/v${VERSION}/febris-simulation-sdk-cpp-v${VERSION}-win-x64.zip"
    FILENAME "febris-simulation-sdk-cpp-v${VERSION}-win-x64.zip"
    SHA512 56936c46f5d8dff6e66201d3f8deffdaa4f6480791163bc52a1f8e15a39b8e2ccb392dd63f3234197845d8a467aae6c5214339c188799eddb948c0ecb0b2e5ff
)

vcpkg_extract_source_archive(SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
)

file(INSTALL "${SOURCE_PATH}/FebrisSimApi.h"
     DESTINATION "${CURRENT_PACKAGES_DIR}/include")
file(INSTALL "${SOURCE_PATH}/Febris.CppSimulationLibrary.lib"
     DESTINATION "${CURRENT_PACKAGES_DIR}/lib")
file(INSTALL "${SOURCE_PATH}/Febris.CppSimulationLibrary.dll"
     DESTINATION "${CURRENT_PACKAGES_DIR}/bin")
file(INSTALL "${SOURCE_PATH}/Febris.CppSimulationLibrary.lib"
     DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib")
file(INSTALL "${SOURCE_PATH}/Febris.CppSimulationLibrary.dll"
     DESTINATION "${CURRENT_PACKAGES_DIR}/debug/bin")

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage"
     DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE" "${SOURCE_PATH}/NOTICE")
