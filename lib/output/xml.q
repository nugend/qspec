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
  v:"\"",'(xml.safeString value x),'"\"";
  " " sv k,'"=",'v
  }

xml.node:{[name;attrib;body];
  startNode:"<",(name:xml.safeString[name]),{$[count x;" ",x;""]}[xml.attrib[attrib]],$[count body;">";"/>"];
  $[count body;
    ` sv (startNode;xml.safeString body;"</",name,">");
    startNode
    ]
  }

xml.cdata:{[data]"<![CDATA[",xml.safeString[data],"]]>"}

