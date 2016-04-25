\d .tst

xml:enlist[`]!enlist[::]
xml.safeString:{
  if[not count x;:()];
  $[10h = type x;
    x;
    0h <= type x;
    // To ensure type conversion isn't an issue, we prepend and drop a dummy string
    1 _ @[x;where not 10h = type each x:enlist[" "],x;string];
    string x
    ]
  }
xml.attrib:{
  k:xml.safeString key x;
  v:"\"",'(xml.entitySub xml.safeString value x),'"\"";
  " " sv k,'"=",'v
  }

xml.node:{[name;attrib;body];
  startNode:"<",(name:xml.safeString[name]),{$[count x;" ",x;""]}[xml.attrib[attrib]],$[count body;">";"/>"];
  $[count body;
    ` sv (startNode;xml.bodySub xml.safeString body;"</",name,">");
    startNode
    ]
  }

xml.entitySub:{ssr/[x;"<>&'\"";("&lt;";"&gt;";"&amp;";"&apos;";"&quot;")]}

xml.bodySub:{
  splitCDATA:{(0,raze[flip 0 3 + x ss/: ("<![[]CDATA[[]";"]]>")]) cut x};
  raze @[s;i where not (i:til[count s:splitCDATA x]) mod 2;xml.entitySub]
  }

xml.cdata:{[data]"<![CDATA[",xml.safeString[data],"]]>"}

