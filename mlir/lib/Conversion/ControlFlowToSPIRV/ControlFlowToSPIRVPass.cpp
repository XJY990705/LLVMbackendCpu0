//===- ControlFlowToSPIRVPass.cpp - ControlFlow to SPIR-V Pass ------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file implements a pass to convert ControlFlow dialect to SPIR-V dialect.
//
//===----------------------------------------------------------------------===//

#include "mlir/Conversion/ControlFlowToSPIRV/ControlFlowToSPIRVPass.h"

#include "mlir/Conversion/ControlFlowToSPIRV/ControlFlowToSPIRV.h"
#include "mlir/Dialect/SPIRV/IR/SPIRVDialect.h"
#include "mlir/Dialect/SPIRV/Transforms/SPIRVConversion.h"

namespace mlir {
#define GEN_PASS_DEF_CONVERTCONTROLFLOWTOSPIRV
#include "mlir/Conversion/Passes.h.inc"
} // namespace mlir

using namespace mlir;

namespace {
/// A pass converting MLIR ControlFlow operations into the SPIR-V dialect.
class ConvertControlFlowToSPIRVPass
    : public impl::ConvertControlFlowToSPIRVBase<
          ConvertControlFlowToSPIRVPass> {
  void runOnOperation() override;
};
} // namespace

void ConvertControlFlowToSPIRVPass::runOnOperation() {
  MLIRContext *context = &getContext();
  Operation *op = getOperation();

  auto targetAttr = spirv::lookupTargetEnvOrDefault(op);
  std::unique_ptr<ConversionTarget> target =
      SPIRVConversionTarget::get(targetAttr);

  SPIRVConversionOptions options;
  options.emulateNon32BitScalarTypes = this->emulateNon32BitScalarTypes;
  SPIRVTypeConverter typeConverter(targetAttr, options);

  RewritePatternSet patterns(context);
  cf::populateControlFlowToSPIRVPatterns(typeConverter, patterns);

  if (failed(applyPartialConversion(op, *target, std::move(patterns))))
    return signalPassFailure();
}

std::unique_ptr<OperationPass<>> mlir::createConvertControlFlowToSPIRVPass() {
  return std::make_unique<ConvertControlFlowToSPIRVPass>();
}