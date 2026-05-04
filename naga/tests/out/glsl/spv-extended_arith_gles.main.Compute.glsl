#version 310 es

precision highp float;
precision highp int;

layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

struct Out {
    uint sum;
    uint carry;
    uint diff;
    uint borrow;
    int smul_low;
    int smul_high;
};
struct In {
    uint a;
    uint b;
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
struct _mul_extended_result_i32_ {
    int low;
    int high;
};

_add_carry_result_u32_ naga_addCarry(uint a, uint b) {
    uint result = a + b;
    uint carry = uint(result < a);
    return _add_carry_result_u32_(result, carry);
}

_sub_borrow_result_u32_ naga_subBorrow(uint a, uint b) {
    uint result = a - b;
    uint borrow = uint(a < b);
    return _sub_borrow_result_u32_(result, borrow);
}

_mul_extended_result_i32_ naga_mulExtended(int a, int b) {
    uint au = uint(a);
    uint bu = uint(b);
    uint mask = uint(0xFFFFu);
    uint aL = au & mask;
    uint aH = au >> 16u;
    uint bL = bu & mask;
    uint bH = bu >> 16u;
    uint ll = aL * bL;
    uint mid = aL * bH + aH * bL;
    uint c = ((ll >> 16u) + (mid & mask)) >> 16u;
    uint high_u = aH * bH + (mid >> 16u) + c;
    high_u -= au & uint(b >> 31);
    high_u -= bu & uint(a >> 31);
    return _mul_extended_result_i32_(a * b, int(high_u));
}
layout(std430) buffer Out_block_0Compute { Out _group_0_binding_1_cs; };

layout(std430) buffer In_block_1Compute { In _group_0_binding_0_cs; };


void main_1() {
    uint c = 0u;
    uint d = 0u;
    int smh = 0;
    int sml = 0;
    uint _e7 = _group_0_binding_0_cs.a;
    uint _e9 = _group_0_binding_0_cs.b;
    _add_carry_result_u32_ _e10 = naga_addCarry(_e7, _e9);
    c = _e10.carry;
    _group_0_binding_1_cs.sum = _e10.result;
    uint _e14 = c;
    _group_0_binding_1_cs.carry = _e14;
    uint _e17 = _group_0_binding_0_cs.a;
    uint _e19 = _group_0_binding_0_cs.b;
    _sub_borrow_result_u32_ _e20 = naga_subBorrow(_e17, _e19);
    d = _e20.borrow;
    _group_0_binding_1_cs.diff = _e20.result;
    uint _e24 = d;
    _group_0_binding_1_cs.borrow = _e24;
    int _e27 = _group_0_binding_0_cs.sa;
    int _e29 = _group_0_binding_0_cs.sb;
    _mul_extended_result_i32_ _e30 = naga_mulExtended(_e27, _e29);
    sml = _e30.low;
    smh = _e30.high;
    int _e33 = sml;
    _group_0_binding_1_cs.smul_low = _e33;
    int _e35 = smh;
    _group_0_binding_1_cs.smul_high = _e35;
    return;
}

void main() {
    main_1();
}

