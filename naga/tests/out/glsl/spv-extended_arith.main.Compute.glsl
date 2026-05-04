#version 450 core
#extension GL_ARB_compute_shader : require
#extension GL_ARB_shader_storage_buffer_object : require
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

struct Output {
    uint sum;
    uint carry;
    uint diff;
    uint borrow;
    uint umul_low;
    uint umul_high;
    int smul_low;
    int smul_high;
    uvec2 vsum;
    uvec2 vcarry;
};
struct Input {
    uint a;
    uint b;
    uvec2 va;
    uvec2 vb;
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
    uvec2 result;
    uvec2 carry;
};

_add_carry_result_u32_ naga_addCarry(uint a, uint b) {
    uint carry;
    uint result = uaddCarry(a, b, carry);
    return _add_carry_result_u32_(result, carry);
}

_sub_borrow_result_u32_ naga_subBorrow(uint a, uint b) {
    uint borrow;
    uint result = usubBorrow(a, b, borrow);
    return _sub_borrow_result_u32_(result, borrow);
}

_mul_extended_result_u32_ naga_mulExtended(uint a, uint b) {
    uint high;
    uint low;
    umulExtended(a, b, high, low);
    return _mul_extended_result_u32_(low, high);
}

_mul_extended_result_i32_ naga_mulExtended(int a, int b) {
    int high;
    int low;
    imulExtended(a, b, high, low);
    return _mul_extended_result_i32_(low, high);
}

_add_carry_result_vec2_u32_ naga_addCarry(uvec2 a, uvec2 b) {
    uvec2 carry;
    uvec2 result = uaddCarry(a, b, carry);
    return _add_carry_result_vec2_u32_(result, carry);
}
layout(std430) buffer Output_block_0Compute { Output _group_0_binding_1_cs; };

layout(std430) buffer Input_block_1Compute { Input _group_0_binding_0_cs; };


void main_1() {
    uint c = 0u;
    uint d = 0u;
    uint umh = 0u;
    uint uml = 0u;
    int smh = 0;
    int sml = 0;
    uvec2 vc = uvec2(0u);
    uint _e10 = _group_0_binding_0_cs.a;
    uint _e12 = _group_0_binding_0_cs.b;
    _add_carry_result_u32_ _e13 = naga_addCarry(_e10, _e12);
    c = _e13.carry;
    _group_0_binding_1_cs.sum = _e13.result;
    uint _e17 = c;
    _group_0_binding_1_cs.carry = _e17;
    uint _e20 = _group_0_binding_0_cs.a;
    uint _e22 = _group_0_binding_0_cs.b;
    _sub_borrow_result_u32_ _e23 = naga_subBorrow(_e20, _e22);
    d = _e23.borrow;
    _group_0_binding_1_cs.diff = _e23.result;
    uint _e27 = d;
    _group_0_binding_1_cs.borrow = _e27;
    uint _e30 = _group_0_binding_0_cs.a;
    uint _e32 = _group_0_binding_0_cs.b;
    _mul_extended_result_u32_ _e33 = naga_mulExtended(_e30, _e32);
    uml = _e33.low;
    umh = _e33.high;
    uint _e36 = uml;
    _group_0_binding_1_cs.umul_low = _e36;
    uint _e38 = umh;
    _group_0_binding_1_cs.umul_high = _e38;
    int _e41 = _group_0_binding_0_cs.sa;
    int _e43 = _group_0_binding_0_cs.sb;
    _mul_extended_result_i32_ _e44 = naga_mulExtended(_e41, _e43);
    sml = _e44.low;
    smh = _e44.high;
    int _e47 = sml;
    _group_0_binding_1_cs.smul_low = _e47;
    int _e49 = smh;
    _group_0_binding_1_cs.smul_high = _e49;
    uvec2 _e52 = _group_0_binding_0_cs.va;
    uvec2 _e54 = _group_0_binding_0_cs.vb;
    _add_carry_result_vec2_u32_ _e55 = naga_addCarry(_e52, _e54);
    vc = _e55.carry;
    _group_0_binding_1_cs.vsum = _e55.result;
    uvec2 _e59 = vc;
    _group_0_binding_1_cs.vcarry = _e59;
    return;
}

void main() {
    main_1();
}

