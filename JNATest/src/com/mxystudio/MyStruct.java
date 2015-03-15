package com.mxystudio;
import java.util.Arrays;
import java.util.List;

import com.sun.jna.Pointer;
import com.sun.jna.Structure;

public class MyStruct extends Structure implements Structure.ByReference {
    public int a;
    public int b;

    public MyStruct() {
    }

    public MyStruct(Pointer p) {
        super(p);
        read();
    }
    
    @Override 
    protected List getFieldOrder() {
        return Arrays.asList(new String[] { "a","b" });
    }
}
