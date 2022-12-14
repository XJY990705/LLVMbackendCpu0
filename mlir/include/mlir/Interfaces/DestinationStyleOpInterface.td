//===- DestinationStyleOpInterface.td ----------------------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DESTINATIONSTYLEOPINTERFACE
#define MLIR_DESTINATIONSTYLEOPINTERFACE

include "mlir/IR/OpBase.td"

def DestinationStyleOpInterface : OpInterface<"DestinationStyleOpInterface"> {
  let description = [{
    Ops that are in destination style have designated output operands, which act
    as initial tensor values for the results of the operation or the output
    buffers to which the results of the op will be written.

    Output operands must be tensors or memrefs. Input operands can have any
    type. All non-output operands are inputs.

    It is assumed that the output operands of the op are the operands at
    position [start, end). The positions are defined by getOutputsPositionRange
    method. All non-output operands are "inputs" of the DPS op.

    If the op has "tensor semantics", then the input operands are either scalars
    or tensors. The output operands are tensors and every tensor output is tied
    to a corresponding tensor OpResult in a 1-to-1 fashion. The i-th output
    tensor is tied to the i-th OpResult. The op may not have any additional
    OpResults. Output operands and their tied OpResults have the same type.

    If the op has "buffer semantics", then the input operands are either memrefs
    or other non-tensor types, e.g. scalar types. Furthermore, the output
    operands are memrefs and the op has no results.

    Destination-passing style abstraction makes certain transformations easier.
    For example, tiling implementation can extract/insert slices from/into the
    destination of an op and use the resulting shaped value as an iter_arg in
    the surrounding loop structure. As another example, bufferization does not
    have to allocate new buffers for destinations (in case of in-place
    bufferization) and can directly reuse the existing destination buffer.

    Example of a destination style op: `%r = tensor.insert_slice %t into %d`,
    where `%t` is the single input and `%d` is the single output. `%d` is tied
    to `%r`.

    Example of an op that is not in destination style: `%r = tensor.pad %t`.
    This op is not in destination style because `%r` and `%t` have different
    shape.

    Each op that wants to implement DestinationStyleOpInterface needs to define
    the getOutputsPositionRange() method.
  }];

  let cppNamespace = "::mlir";

  let methods = [
    // This method has to be defined for every DPS op.
    InterfaceMethod<
      /*desc=*/"Return start and end indices of the output operands range.",
      /*retTy=*/"std::pair<int64_t, int64_t>",
      /*methodName=*/"getOutputsPositionRange",
      /*args=*/(ins),
      /*methodBody=*/"",
      /*defaultImplementation=*/""
    >,
    //===------------------------------------------------------------------===//
    // Operands handling.
    //===------------------------------------------------------------------===//
    // The operand list is assumed to start with the input operands and end
    // with the output operands. Therefore, all methods to access the inputs
    // and outputs can be expressed if the number of output operands is know.
    InterfaceMethod<
      /*desc=*/"Return the number of outputs.",
      /*retTy=*/"int64_t",
      /*methodName=*/"getNumOutputs",
      /*args=*/(ins),
      /*methodBody=*/"",
      /*defaultImplementation=*/[{
        auto [start, end] = $_op.getOutputsPositionRange();
        return end - start;
      }]
    >,
    InterfaceMethod<
      /*desc=*/"Return the output operands.",
      /*retTy=*/"OpOperandVector",
      /*methodName=*/"getOutputOperands",
      /*args=*/(ins),
      /*methodBody=*/"",
      /*defaultImplementation=*/[{
        auto [start, end] = $_op.getOutputsPositionRange();

        OpOperandVector result;
        result.reserve(end - start);
        for (int i = start; i < end; ++i)
          result.push_back(&$_op->getOpOperand(i));
        return result;
      }]
    >,
    InterfaceMethod<
      /*desc=*/"Return the `i`-th output operand.",
      /*retTy=*/"OpOperand *",
      /*methodName=*/"getOutputOperand",
      /*args=*/(ins "int64_t":$i),
      /*methodBody=*/"",
      /*defaultImplementation=*/[{
        assert(i >= 0 && i < $_op.getNumOutputs());
        auto [start, end] = $_op.getOutputsPositionRange();
        return &$_op->getOpOperand(start + i);
      }]
    >,
    InterfaceMethod<
      /*desc=*/"Set the `i`-th output operand.",
      /*retTy=*/"void",
      /*methodName=*/"setOutputOperand",
      /*args=*/(ins "int64_t":$i, "Value":$value),
      /*methodBody=*/"",
      /*defaultImplementation=*/[{
        assert(i >= 0 && i < $_op.getNumOutputs());
        auto [start, end] = $_op.getOutputsPositionRange();
        $_op->setOperand(start + i, value);
      }]
    >,
    InterfaceMethod<
      /*desc=*/"Return the number of inputs.",
      /*retTy=*/"int64_t",
      /*methodName=*/"getNumInputs",
      /*args=*/(ins),
      /*methodBody=*/"",
      /*defaultImplementation=*/[{
        return $_op.getNumOperands() - $_op.getNumOutputs();
      }]
    >,
    InterfaceMethod<
      /*desc=*/"Return the input operands.",
      /*retTy=*/"OpOperandVector",
      /*methodName=*/"getInputOperands",
      /*args=*/(ins),
      /*methodBody=*/"",
      /*defaultImplementation=*/[{
        auto [start, end] = $_op.getOutputsPositionRange();
        int64_t numOutputs = end - start;
        int64_t numOperands = $_op.getNumOperands();

        OpOperandVector result;
        result.reserve(numOperands - numOutputs);
        for (int i = 0; i < start; ++i)
          result.push_back(&$_op->getOpOperand(i));
        for (int i = end; i < numOperands; ++i)
          result.push_back(&$_op->getOpOperand(end + i));

        return result;
      }]
    >,
    InterfaceMethod<
      /*desc=*/[{ Return the `i`-th input operand.  }],
      /*retTy=*/"OpOperand *",
      /*methodName=*/"getInputOperand",
      /*args=*/(ins "int64_t":$i),
      /*methodBody=*/"",
      /*defaultImplementation=*/[{
        assert(i >= 0 && i < getNumInputs());
        auto [start, end] = $_op.getOutputsPositionRange();
        return &$_op->getOpOperand(i < start ? i : i + end - start) ;
      }]
    >,
    //===------------------------------------------------------------------===//
    // Input and Output arguments handling.
    //===------------------------------------------------------------------===//
    InterfaceMethod<
      /*desc=*/"Return true if `opOperand` is an input.",
      /*retTy=*/"bool",
      /*methodName=*/"isInput",
      /*args=*/(ins "OpOperand *":$opOperand),
      /*methodBody=*/"",
      /*defaultImplementation=*/[{
        auto [start, end] = $_op.getOutputsPositionRange();
        auto operandNumber = opOperand->getOperandNumber();
        return operandNumber < start || operandNumber >= end;
      }]
    >,
    InterfaceMethod<
      /*desc=*/"Return true if `opOperand` is an output.",
      /*retTy=*/"bool",
      /*methodName=*/"isOutput",
      /*args=*/(ins "OpOperand *":$opOperand),
      /*methodBody=*/"",
      /*defaultImplementation=*/[{
        auto [start, end] = $_op.getOutputsPositionRange();
        auto operandNumber = opOperand->getOperandNumber();
        return operandNumber >= start && operandNumber < end;
      }]
    >,
    InterfaceMethod<
      /*desc=*/"Return true if the `opOperand` is a scalar value.",
      /*retTy=*/"bool",
      /*methodName=*/"isScalar",
      /*args=*/(ins "OpOperand *":$opOperand),
      /*methodBody=*/"",
      /*defaultImplementation=*/[{
        assert(opOperand->getOwner() == $_op.getOperation());
        return !opOperand->get().getType().template isa<ShapedType>();
      }]
    >,
    InterfaceMethod<
      /*desc=*/"Return the OpResult that is tied to the given OpOperand.",
      /*retTy=*/"OpResult",
      /*methodName=*/"getTiedOpResult",
      /*args=*/(ins "OpOperand *":$opOperand),
      /*methodBody=*/"",
      /*defaultImplementation=*/[{
        assert(opOperand->getOwner() == $_op.getOperation());

        auto [start, end] = $_op.getOutputsPositionRange();
        int64_t resultIndex = opOperand->getOperandNumber() - start;
        assert(resultIndex >= 0 &&
               resultIndex < $_op->getNumResults() );
        return $_op->getResult(resultIndex);
      }]
    >,
    InterfaceMethod<
      /*desc=*/"Return the OpOperand that is tied to the given OpResult.",
      /*retTy=*/"OpOperand *",
      /*methodName=*/"getTiedOpOperand",
      /*args=*/(ins "OpResult":$opResult),
      /*methodBody=*/"",
      /*defaultImplementation=*/[{
        assert(opResult.getDefiningOp() == $_op.getOperation());
        return $_op.getOutputOperand(opResult.getResultNumber());
      }]
    >,
    //===------------------------------------------------------------------===//
    // Other interface methods.
    //===------------------------------------------------------------------===//
    InterfaceMethod<
      /*desc=*/"Return whether the op has only MemRef input and outputs.",
      /*retTy=*/"bool",
      /*methodName=*/"hasBufferSemantics",
      /*args=*/(ins),
      /*methodBody=*/"",
      /*defaultImplementation=*/[{
        return $_op->getNumResults() == 0 &&
          llvm::all_of($_op->getOpOperands(),
            [&](OpOperand &opOperand) {
              return isScalar(&opOperand) ||
                     opOperand.get().getType().template isa<MemRefType>();
            });
      }]
    >,
    InterfaceMethod<
      /*desc=*/"Return whether the op has only RankedTensor input and outputs.",
      /*retTy=*/"bool",
      /*methodName=*/"hasTensorSemantics",
      /*args=*/(ins),
      /*methodBody=*/"",
      /*defaultImplementation=*/[{
        return llvm::all_of($_op->getOpOperands(),
          [&](OpOperand &opOperand) {
            return isScalar(&opOperand) ||
                   opOperand.get().getType().template isa<RankedTensorType>();
          });
      }]
    >,
    //===------------------------------------------------------------------===//
    // Other static interface methods.
    //===------------------------------------------------------------------===//
    InterfaceMethod<
      /*desc=*/[{
        Clone the current operation with the given location and operands. This
        is used to abstract away the optional underlying region creation. This
        does not change the balance between input, output_buffer and
        init_tensors operands.
      }],
      /*retTy=*/"Operation *",
      /*methodName=*/"clone",
      (ins "OpBuilder &":$b, "Location":$loc, "TypeRange":$resultTypes,
           "ValueRange":$operands),
      [{
        BlockAndValueMapping bvm;
        OperationState state(
          loc, ConcreteOp::getOperationName(), operands, resultTypes,
          $_op->getAttrs());
        for (Region &r : $_op->getRegions())
          r.cloneInto(state.addRegion(), bvm);
        return b.create(state);
      }]
    >,
    InterfaceMethod<
      /*desc=*/[{
        Clone the current operation with the given location, operands
        and BlockAndValueMapping but leave the regions empty. This is
        used to abstract away the optional underlying region creation.
        This does not change the balance between input, output_buffer
        and init_tensors operands.
      }],
      /*retTy=*/"Operation *",
      /*methodName=*/"cloneWithoutRegions",
      (ins "OpBuilder &":$b, "Location":$loc, "TypeRange":$resultTypes,
           "ValueRange":$operands),
      [{
        OperationState state(
          loc, ConcreteOp::getOperationName(), operands, resultTypes,
          $_op->getAttrs());
        for (size_t cnt = 0, e = $_op->getNumRegions(); cnt < e; ++cnt)
          state.addRegion();
        return b.create(state);
      }]
    >
  ];

  let verify = [{ return detail::verifyDestinationStyleOpInterface($_op); }];
  let verifyWithRegions = 1;
}


#endif // MLIR_DESTINATIONSTYLEOPINTERFACE
