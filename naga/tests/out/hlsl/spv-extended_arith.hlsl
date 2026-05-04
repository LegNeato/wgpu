struct Output {
    uint sum;
    uint carry;
    uint diff;
    uint borrow;
    uint umul_low;
    uint umul_high;
    int smul_low;
    int smul_high;
    uint2 vsum;
    uint2 vcarry;
};

struct Input {
    uint a;
    uint b;
    uint2 va;
    uint2 vb;
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
    uint2 result;
    uint2 carry;
};

_add_carry_result_u32_ naga_addCarry(uint a, uint b) {
    _add_carry_result_u32_ ret = (_add_carry_result_u32_)0;
    uint carry;
    ret.result = uaddCarry(a, b, carry);
    ret.carry = carry;
    return ret;
}

_sub_borrow_result_u32_ naga_subBorrow(uint a, uint b) {
    _sub_borrow_result_u32_ ret = (_sub_borrow_result_u32_)0;
    uint borrow;
    ret.result = usubBorrow(a, b, borrow);
    ret.borrow = borrow;
    return ret;
}

_mul_extended_result_u32_ naga_mulExtended(uint a, uint b) {
    _mul_extended_result_u32_ ret = (_mul_extended_result_u32_)0;
    uint high;
    uint low;
    umul(a, b, high, low);
    ret.low = low;
    ret.high = high;
    return ret;
}

_mul_extended_result_i32_ naga_mulExtended(int a, int b) {
    _mul_extended_result_i32_ ret = (_mul_extended_result_i32_)0;
    int high;
    int low;
    imul(a, b, high, low);
    ret.low = low;
    ret.high = high;
    return ret;
}

_add_carry_result_vec2_u32_ naga_addCarry(uint2 a, uint2 b) {
    _add_carry_result_vec2_u32_ ret = (_add_carry_result_vec2_u32_)0;
    uint2 carry;
    ret.result = uaddCarry(a, b, carry);
    ret.carry = carry;
    return ret;
}

RWByteAddressBuffer outp : register(u1);
RWByteAddressBuffer inp : register(u0);

void main_1()
{
    uint c = (uint)0;
    uint d = (uint)0;
    uint umh = (uint)0;
    uint uml = (uint)0;
    int smh = (int)0;
    int sml = (int)0;
    uint2 vc = (uint2)0;

    uint _e10 = asuint(inp.Load(0));
    uint _e12 = asuint(inp.Load(4));
    _add_carry_result_u32_ _e13 = naga_addCarry(_e10, _e12);
    c = _e13.carry;
    outp.Store(0, asuint(_e13.result));
    uint _e17 = c;
    outp.Store(4, asuint(_e17));
    uint _e20 = asuint(inp.Load(0));
    uint _e22 = asuint(inp.Load(4));
    _sub_borrow_result_u32_ _e23 = naga_subBorrow(_e20, _e22);
    d = _e23.borrow;
    outp.Store(8, asuint(_e23.result));
    uint _e27 = d;
    outp.Store(12, asuint(_e27));
    uint _e30 = asuint(inp.Load(0));
    uint _e32 = asuint(inp.Load(4));
    _mul_extended_result_u32_ _e33 = naga_mulExtended(_e30, _e32);
    uml = _e33.low;
    umh = _e33.high;
    uint _e36 = uml;
    outp.Store(16, asuint(_e36));
    uint _e38 = umh;
    outp.Store(20, asuint(_e38));
    int _e41 = asint(inp.Load(24));
    int _e43 = asint(inp.Load(28));
    _mul_extended_result_i32_ _e44 = naga_mulExtended(_e41, _e43);
    sml = _e44.low;
    smh = _e44.high;
    int _e47 = sml;
    outp.Store(24, asuint(_e47));
    int _e49 = smh;
    outp.Store(28, asuint(_e49));
    uint2 _e52 = asuint(inp.Load2(8));
    uint2 _e54 = asuint(inp.Load2(16));
    _add_carry_result_vec2_u32_ _e55 = naga_addCarry(_e52, _e54);
    vc = _e55.carry;
    outp.Store2(32, asuint(_e55.result));
    uint2 _e59 = vc;
    outp.Store2(40, asuint(_e59));
    return;
}

[numthreads(1, 1, 1)]
void main()
{
    main_1();
}
