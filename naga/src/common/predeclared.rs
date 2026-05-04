//! Generating names for predeclared types.

use crate::arena::Handle;
use crate::ir;

use alloc::format;
use alloc::string::String;

impl ir::PredeclaredType {
    pub fn struct_name(&self) -> String {
        use crate::PredeclaredType as Pt;
        match *self {
            Pt::AtomicCompareExchangeWeakResult(scalar) => {
                format!(
                    "__atomic_compare_exchange_result<{:?},{}>",
                    scalar.kind, scalar.width,
                )
            }
            Pt::ModfResult { size, scalar } => frexp_mod_name("modf", size, scalar),
            Pt::FrexpResult { size, scalar } => frexp_mod_name("frexp", size, scalar),
            Pt::AddCarryResult { size, scalar } => extended_arith_name("add_carry", size, scalar),
            Pt::SubBorrowResult { size, scalar } => extended_arith_name("sub_borrow", size, scalar),
            Pt::MulExtendedResult { size, scalar } => {
                extended_arith_name("mul_extended", size, scalar)
            }
        }
    }
}

impl ir::SpecialTypes {
    /// Type handles in [`predeclared_types`] that the WGSL spec's grammar
    /// defines by name (`__modf_result_*`, `__frexp_result_*`,
    /// `__atomic_compare_exchange_result_*`).
    ///
    /// `predeclared_types` also holds naga-internal struct shapes (e.g.
    /// result structs for SPIR-V's extended-result integer arithmetic
    /// ops), which this iterator skips. The WGSL backend uses this to
    /// decide which predeclared structs to omit from its output: WGSL
    /// already knows about them, but the others must be emitted.
    ///
    /// [`predeclared_types`]: ir::SpecialTypes::predeclared_types
    pub fn wgsl_predeclared_struct_handles(&self) -> impl Iterator<Item = Handle<ir::Type>> + '_ {
        use crate::PredeclaredType as Pt;
        self.predeclared_types
            .iter()
            .filter(|&(key, _)| {
                matches!(
                    key,
                    Pt::AtomicCompareExchangeWeakResult(_)
                        | Pt::ModfResult { .. }
                        | Pt::FrexpResult { .. }
                )
            })
            .map(|(_, &handle)| handle)
    }
}

fn frexp_mod_name(function: &str, size: Option<ir::VectorSize>, scalar: ir::Scalar) -> String {
    let bits = 8 * scalar.width;
    match size {
        Some(size) => {
            let size = size as u8;
            format!("__{function}_result_vec{size}_f{bits}")
        }
        None => format!("__{function}_result_f{bits}"),
    }
}

fn extended_arith_name(function: &str, size: Option<ir::VectorSize>, scalar: ir::Scalar) -> String {
    let kind_letter = match scalar.kind {
        ir::ScalarKind::Sint => "i",
        ir::ScalarKind::Uint => "u",
        ir::ScalarKind::Float
        | ir::ScalarKind::Bool
        | ir::ScalarKind::AbstractInt
        | ir::ScalarKind::AbstractFloat => unreachable!(),
    };
    let bits = 8 * scalar.width;
    match size {
        Some(size) => {
            let size = size as u8;
            format!("__{function}_result_vec{size}_{kind_letter}{bits}")
        }
        None => format!("__{function}_result_{kind_letter}{bits}"),
    }
}
