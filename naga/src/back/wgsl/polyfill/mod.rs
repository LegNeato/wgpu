use crate::{ScalarKind, TypeInner, VectorSize};

/// A polyfill the WGSL backend must emit at the end of the module.
///
/// The dispatch site at `Expression::Math` registers one of these in
/// [`super::Writer::required_polyfills`] when it emits a call into a
/// polyfill, and the loop in [`super::Writer::write`] emits each one
/// exactly once at module end.
#[derive(Debug, Copy, Clone, PartialEq, Eq, Hash)]
pub(super) enum RequiredPolyfill {
    /// Square-matrix `inverse()`. Static WGSL source per matrix size and
    /// scalar width.
    Inverse(InversePolyfill),
    /// One of `MathFunction::AddCarry`, `MathFunction::SubBorrow`, or
    /// `MathFunction::MulExtended`. The [`crate::PredeclaredType`] fully
    /// identifies which polyfill we need (operation + size + scalar).
    ExtendedArith(crate::PredeclaredType),
}

#[derive(Debug, Copy, Clone, PartialEq, Eq, Hash)]
pub struct InversePolyfill {
    pub fun_name: &'static str,
    pub source: &'static str,
}

impl InversePolyfill {
    pub fn find_overload(ty: &TypeInner) -> Option<InversePolyfill> {
        let &TypeInner::Matrix {
            columns,
            rows,
            scalar,
        } = ty
        else {
            return None;
        };

        if columns != rows || scalar.kind != ScalarKind::Float {
            return None;
        };

        Self::polyfill_overload(columns, scalar.width)
    }

    const fn polyfill_overload(
        dimension: VectorSize,
        width: crate::Bytes,
    ) -> Option<InversePolyfill> {
        const INVERSE_2X2_F32: &str = include_str!("inverse/inverse_2x2_f32.wgsl");
        const INVERSE_3X3_F32: &str = include_str!("inverse/inverse_3x3_f32.wgsl");
        const INVERSE_4X4_F32: &str = include_str!("inverse/inverse_4x4_f32.wgsl");
        const INVERSE_2X2_F16: &str = include_str!("inverse/inverse_2x2_f16.wgsl");
        const INVERSE_3X3_F16: &str = include_str!("inverse/inverse_3x3_f16.wgsl");
        const INVERSE_4X4_F16: &str = include_str!("inverse/inverse_4x4_f16.wgsl");

        match (dimension, width) {
            (VectorSize::Bi, 4) => Some(InversePolyfill {
                fun_name: "_naga_inverse_2x2_f32",
                source: INVERSE_2X2_F32,
            }),
            (VectorSize::Tri, 4) => Some(InversePolyfill {
                fun_name: "_naga_inverse_3x3_f32",
                source: INVERSE_3X3_F32,
            }),
            (VectorSize::Quad, 4) => Some(InversePolyfill {
                fun_name: "_naga_inverse_4x4_f32",
                source: INVERSE_4X4_F32,
            }),
            (VectorSize::Bi, 2) => Some(InversePolyfill {
                fun_name: "_naga_inverse_2x2_f16",
                source: INVERSE_2X2_F16,
            }),
            (VectorSize::Tri, 2) => Some(InversePolyfill {
                fun_name: "_naga_inverse_3x3_f16",
                source: INVERSE_3X3_F16,
            }),
            (VectorSize::Quad, 2) => Some(InversePolyfill {
                fun_name: "_naga_inverse_4x4_f16",
                source: INVERSE_4X4_F16,
            }),
            _ => None,
        }
    }
}
