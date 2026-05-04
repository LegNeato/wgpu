struct Output {
    sum: u32,
    carry: u32,
    diff: u32,
    borrow: u32,
    umul_low: u32,
    umul_high: u32,
    smul_low: i32,
    smul_high: i32,
    vsum: vec2<u32>,
    vcarry: vec2<u32>,
}

struct Input {
    a: u32,
    b: u32,
    va: vec2<u32>,
    vb: vec2<u32>,
    sa: i32,
    sb: i32,
}

struct _add_carry_result_u32_ {
    result: u32,
    carry: u32,
}

struct _sub_borrow_result_u32_ {
    result: u32,
    borrow: u32,
}

struct _mul_extended_result_u32_ {
    low: u32,
    high: u32,
}

struct _mul_extended_result_i32_ {
    low: i32,
    high: i32,
}

struct _add_carry_result_vec2_u32_ {
    result: vec2<u32>,
    carry: vec2<u32>,
}

@group(0) @binding(1) 
var<storage, read_write> outp: Output;
@group(0) @binding(0) 
var<storage, read_write> inp: Input;

fn main_1() {
    var c: u32;
    var d: u32;
    var umh: u32;
    var uml: u32;
    var smh: i32;
    var sml: i32;
    var vc: vec2<u32>;

    let _e10 = inp.a;
    let _e12 = inp.b;
    let _e13 = _naga_addCarry_u32(_e10, _e12);
    c = _e13.carry;
    outp.sum = _e13.result;
    let _e17 = c;
    outp.carry = _e17;
    let _e20 = inp.a;
    let _e22 = inp.b;
    let _e23 = _naga_subBorrow_u32(_e20, _e22);
    d = _e23.borrow;
    outp.diff = _e23.result;
    let _e27 = d;
    outp.borrow = _e27;
    let _e30 = inp.a;
    let _e32 = inp.b;
    let _e33 = _naga_mulExtended_u32(_e30, _e32);
    uml = _e33.low;
    umh = _e33.high;
    let _e36 = uml;
    outp.umul_low = _e36;
    let _e38 = umh;
    outp.umul_high = _e38;
    let _e41 = inp.sa;
    let _e43 = inp.sb;
    let _e44 = _naga_mulExtended_i32(_e41, _e43);
    sml = _e44.low;
    smh = _e44.high;
    let _e47 = sml;
    outp.smul_low = _e47;
    let _e49 = smh;
    outp.smul_high = _e49;
    let _e52 = inp.va;
    let _e54 = inp.vb;
    let _e55 = _naga_addCarry_vec2_u32(_e52, _e54);
    vc = _e55.carry;
    outp.vsum = _e55.result;
    let _e59 = vc;
    outp.vcarry = _e59;
    return;
}

@compute @workgroup_size(1, 1, 1) 
fn main() {
    main_1();
}

fn _naga_addCarry_u32(a: u32, b: u32) -> _add_carry_result_u32_ {
    let result = a + b;
    let carry = u32(result < a);
    return _add_carry_result_u32_(result, carry);
}

fn _naga_subBorrow_u32(a: u32, b: u32) -> _sub_borrow_result_u32_ {
    let result = a - b;
    let borrow = u32(a < b);
    return _sub_borrow_result_u32_(result, borrow);
}

fn _naga_mulExtended_u32(a: u32, b: u32) -> _mul_extended_result_u32_ {
    let mask = u32(0xFFFFu);
    let aL = a & mask;
    let aH = a >> u32(16u);
    let bL = b & mask;
    let bH = b >> u32(16u);
    let ll = aL * bL;
    let mid = aL * bH + aH * bL;
    let c = ((ll >> u32(16u)) + (mid & mask)) >> u32(16u);
    let high = aH * bH + (mid >> u32(16u)) + c;
    let low = a * b;
    return _mul_extended_result_u32_(low, high);
}

fn _naga_mulExtended_i32(a: i32, b: i32) -> _mul_extended_result_i32_ {
    let au = bitcast<u32>(a);
    let bu = bitcast<u32>(b);
    let mask = u32(0xFFFFu);
    let aL = au & mask;
    let aH = au >> u32(16u);
    let bL = bu & mask;
    let bH = bu >> u32(16u);
    let ll = aL * bL;
    let mid = aL * bH + aH * bL;
    let c = ((ll >> u32(16u)) + (mid & mask)) >> u32(16u);
    var high_u = aH * bH + (mid >> u32(16u)) + c;
    high_u = high_u - select(0u, au, b < i32(0));
    high_u = high_u - select(0u, bu, a < i32(0));
    let high = bitcast<i32>(high_u);
    let low = a * b;
    return _mul_extended_result_i32_(low, high);
}

fn _naga_addCarry_vec2_u32(a: vec2<u32>, b: vec2<u32>) -> _add_carry_result_vec2_u32_ {
    let result = a + b;
    let carry = vec2<u32>(result < a);
    return _add_carry_result_vec2_u32_(result, carry);
}
