include_directories(
  ${CMAKE_SOURCE_DIR}/lib/Target/WebAssembly
  ${CMAKE_BINARY_DIR}/lib/Target/WebAssembly
  )

set(LLVM_LINK_COMPONENTS
  CodeGen
  Core
  MC
  MIRParser
  WebAssemblyCodeGen
  WebAssemblyDesc
  WebAssemblyInfo
  )

add_llvm_target_unittest(WebAssemblyTests
  WebAssemblyExceptionInfoTest.cpp
  )

set_property(TARGET WebAssemblyTests PROPERTY FOLDER "Tests/UnitTests/TargetTests")
