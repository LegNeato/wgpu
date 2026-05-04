// language: metal2.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Output {
    uint sum;
    uint carry;
    uint diff;
    uint borrow;
    uint umul_low;
    uint umul_high;
    int smul_low;
    int smul_high;
    metal::uint2 vsum;
    metal::uint2 vcarry;
};
struct Input {
    uint a;
    uint b;
    metal::uint2 va;
    metal::uint2 vb;
    int sa;
    int sb;
};
struct _add_carry_result_u32_ {
    uint result;
    uint carry;
};
struct _sub_borrow_result_u32_ {
    uint result;
    uint borrow;
};
struct _mul_extended_result_u32_ {
    uint low;
    uint high;
};
struct _mul_extended_result_i32_ {
    int low;
    int high;
};
struct _add_carry_result_vec2_u32_ {
    metal::uint2 result;
    metal::uint2 carry;
};

_add_carry_result_u32_ naga_addCarry(uint a, uint b) {
    uint result = a + b;
    uint carry = uint(result < a);
    return _add_carry_result_u32_{ result, carry };
}

_sub_borrow_result_u32_ naga_subBorrow(uint a, uint b) {
    uint result = a - b;
    uint borrow = uint(a < b);
    return _sub_borrow_result_u32_{ result, borrow };
}

_mul_extended_result_u32_ naga_mulExtended(uint a, uint b) {
    return _mul_extended_result_u32_{ a * b, metal::mulhi(a, b) };
}

_mul_extended_result_i32_ naga_mulExtended(int a, int b) {
    return _mul_extended_result_i32_{ a * b, metal::mulhi(a, b) };
}

_add_carry_result_vec2_u32_ naga_addCarry(metal::uint2 a, metal::uint2 b) {
    metal::uint2 result = a + b;
    metal::uint2 carry = metal::uint2(result < a);
    return _add_carry_result_vec2_u32_{ result, carry };
}

void main_1(
    device Output& outp,
    device Input const& inp
) {
    uint c = {};
    uint d = {};
    uint umh = {};
    uint uml = {};
    int smh = {};
    int sml = {};
    metal::uint2 vc = {};
    uint _e10 = inp.a;
    uint _e12 = inp.b;
    _add_carry_result_u32_ _e13 = naga_addCarry(_e10, _e12);
    c = _e13.carry;
    outp.sum = _e13.result;
    uint _e17 = c;
    outp.carry = _e17;
    uint _e20 = inp.a;
    uint _e22 = inp.b;
    _sub_borrow_result_u32_ _e23 = naga_subBorrow(_e20, _e22);
    d = _e23.borrow;
    outp.diff = _e23.result;
    uint _e27 = d;
    outp.borrow = _e27;
    uint _e30 = inp.a;
    uint _e32 = inp.b;
    _mul_extended_result_u32_ _e33 = naga_mulExtended(_e30, _e32);
    uml = _e33.low;
    umh = _e33.high;
    uint _e36 = uml;
    outp.umul_low = _e36;
    uint _e38 = umh;
    outp.umul_high = _e38;
    int _e41 = inp.sa;
    int _e43 = inp.sb;
    _mul_extended_result_i32_ _e44 = naga_mulExtended(_e41, _e43);
    sml = _e44.low;
    smh = _e44.high;
    int _e47 = sml;
    outp.smul_low = _e47;
    int _e49 = smh;
    outp.smul_high = _e49;
    metal::uint2 _e52 = inp.va;
    metal::uint2 _e54 = inp.vb;
    _add_carry_result_vec2_u32_ _e55 = naga_addCarry(_e52, _e54);
    vc = _e55.carry;
    outp.vsum = _e55.result;
    metal::uint2 _e59 = vc;
    outp.vcarry = _e59;
    return;
}

kernel void main_(
  device Output& outp [[user(fake0)]]
, device Input const& inp [[user(fake0)]]
) {
    main_1(outp, inp);
}
