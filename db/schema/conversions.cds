entity![T006]{
    key![MANDT]      : String(3)    @title : 'MANDT';
    key![MSEHI]      : String(3)    @title : 'MSEHI';
       ![KZEX3]      : String(1)    @title : 'KZEX3';
       ![KZEX6]      : String(1)    @title : 'KZEX6';
       ![ANDEC]      : Integer      @title : 'ANDEC';
       ![KZKEH]      : String(1)    @title : 'KZKEH';
       ![KZWOB]      : String(1)    @title : 'KZWOB';
       ![KZ1EH]      : String(1)    @title : 'KZ1EH';
       ![KZ2EH]      : String(1)    @title : 'KZ2EH';
       ![DIMID]      : String(6)    @title : 'DIMID';
       ![ZAEHL]      : Integer      @title : 'ZAEHL';
       ![NENNR]      : Integer      @title : 'NENNR';
       ![EXP10]      : Integer      @title : 'EXP10';
       ![ADDKO]      : Decimal(9, 6)@title : 'ADDKO';
       ![EXPON]      : Integer      @title : 'EXPON';
       ![DECAN]      : Integer      @title : 'DECAN';
       ![ISOCODE]    : String(3)    @title : 'ISOCODE';
       ![PRIMARY]    : String(1)    @title : 'PRIMARY';
       ![TEMP_VALUE] : Double       @title : 'TEMP_VALUE';
       ![TEMP_UNIT]  : String(3)    @title : 'TEMP_UNIT';
       ![FAMUNIT]    : String(3)    @title : 'FAMUNIT';
       ![PRESS_VAL]  : Double       @title : 'PRESS_VAL';
       ![PRESS_UNIT] : String(3)    @title : 'PRESS_UNIT';
}

entity![T006A]{
    key![MANDT] : String(3) @title : 'MANDT';
    key![SPRAS] : String(1) @title : 'SPRAS';
    key![MSEHI] : String(3) @title : 'MSEHI';
       ![KZEX3] : String(3) @title : 'KZEX3';
       ![KZEX6] : String(6) @title : 'KZEX6';
       ![MSEHT] : String(10)@title : 'MSEHT';
       ![MSEHL] : String(30)@title : 'MSEHL';
}

entity![TCURC]{
    key![MANDT]    : String(3)@title : 'MANDT';
    key![WAERS]    : String(5)@title : 'WAERS';
       ![ISOCD]    : String(3)@title : 'ISOCD';
       ![ALTWR]    : String(3)@title : 'ALTWR';
       ![GDATU]    : String(8)@title : 'GDATU';
       ![XPRIMARY] : String(1)@title : 'XPRIMARY';
}

entity![TCURF]{
    key![MANDT] : String(3)    @title : 'MANDT';
    key![KURST] : String(4)    @title : 'KURST';
    key![FCURR] : String(5)    @title : 'FCURR';
    key![TCURR] : String(5)    @title : 'TCURR';
    key![GDATU] : String(8)    @title : 'GDATU';
       ![FFACT] : Decimal(9, 0)@title : 'FFACT';
       ![TFACT] : Decimal(9, 0)@title : 'TFACT';
       ![ABWCT] : String(4)    @title : 'ABWCT';
       ![ABWGA] : String(8)    @title : 'ABWGA';
}

entity![TCURN]{
    key![MANDT]    : String(3)@title : 'MANDT';
    key![FCURR]    : String(5)@title : 'FCURR';
    key![TCURR]    : String(5)@title : 'TCURR';
    key![GDATU]    : String(8)@title : 'GDATU';
       ![NOTATION] : String(1)@title : 'NOTATION';
}

entity![TCURR]{
    key![MANDT] : String(3)    @title : 'MANDT';
    key![KURST] : String(4)    @title : 'KURST';
    key![FCURR] : String(5)    @title : 'FCURR';
    key![TCURR] : String(5)    @title : 'TCURR';
    key![GDATU] : String(8)    @title : 'GDATU';
       ![UKURS] : Decimal(9, 5)@title : 'UKURS';
       ![FFACT] : Decimal(9, 0)@title : 'FFACT';
       ![TFACT] : Decimal(9, 0)@title : 'TFACT';
}

entity![TCURT]{
    key![MANDT] : String(3) @title : 'MANDT';
    key![SPRAS] : String(1) @title : 'SPRAS';
    key![WAERS] : String(5) @title : 'WAERS';
       ![LTEXT] : String(40)@title : 'LTEXT';
       ![KTEXT] : String(15)@title : 'KTEXT';
}

entity![TCURV]{
    key![MANDT] : String(3)@title : 'MANDT';
    key![KURST] : String(4)@title : 'KURST';
       ![XINVR] : String(1)@title : 'XINVR';
       ![BWAER] : String(5)@title : 'BWAER';
       ![XBWRL] : String(1)@title : 'XBWRL';
       ![GKUZU] : String(4)@title : 'GKUZU';
       ![BKUZU] : String(4)@title : 'BKUZU';
       ![XFIXD] : String(1)@title : 'XFIXD';
       ![XEURO] : String(1)@title : 'XEURO';
}

entity![TCURW]{
    key![MANDT] : String(3) @title : 'MANDT';
    key![SPRAS] : String(1) @title : 'SPRAS';
    key![KURST] : String(4) @title : 'KURST';
       ![CURVW] : String(40)@title : 'CURVW';
}

entity![TCURX]{
    key![CURRKEY] : String(5)@title : 'CURRKEY';
       ![CURRDEC] : Integer  @title : 'CURRDEC';
}
