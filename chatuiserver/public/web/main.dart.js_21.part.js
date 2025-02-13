((a,b,c)=>{a[b]=a[b]||{}
a[b][c]=a[b][c]||[]
a[b][c].push({p:"main.dart.js_21",e:"beginPart"})})(self,"$__dart_deferred_initializers__","eventLog")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,B,H,C={
aUR(){return new C.oH(null)},
oH:function oH(d){this.a=d},
WE:function WE(d){var _=this
_.w=!0
_.x=d
_.c=_.a=null},
au6:function au6(d,e){this.a=d
this.b=e},
au7:function au7(d){this.a=d},
aua:function aua(d){this.a=d},
au8:function au8(d){this.a=d},
au9:function au9(){},
rT:function rT(d,e){this.c=d
this.a=e},
aeV(){var x=0,w=A.I(y.l),v,u=2,t,s,r,q,p,o,n,m
var $async$aeV=A.J(function(d,e){if(d===1){t=e
x=u}while(true)switch(x){case 0:u=4
s=A.cv($.lT()+"/user/get/orders",0,null)
r=window.localStorage.getItem("jwtToken")
o=y.w
x=7
return A.R(A.lP(s,A.a3(["Content-Type","application/json","Authorization","Bearer "+A.j(r)],o,o)),$async$aeV)
case 7:q=e
if(q.b===200){o=q
o=A.eE(B.T.eh(0,A.eP(A.eN(o.e).c.a.i(0,"charset")).c4(0,o.w),null))
v=o
x=1
break}else{o=A.bk("Failed to send message. Status code: "+q.b)
throw A.c(o)}u=2
x=6
break
case 4:u=3
m=t
p=A.a5(m)
o=A.bk("Failed to send message: "+A.j(p))
throw A.c(o)
x=6
break
case 3:x=2
break
case 6:case 1:return A.G(v,w)
case 2:return A.F(t,w)}})
return A.H($async$aeV,w)}},D,F,G,I,E
J=c[1]
A=c[0]
B=c[2]
H=c[18]
C=a.updateHolder(c[8],C)
D=c[30]
F=c[19]
G=c[31]
I=c[14]
E=c[24]
C.oH.prototype={
a9(){return new C.WE([])}}
C.WE.prototype={
ap(){this.aE()
this.xM()},
xM(){var x=0,w=A.I(y.v),v=1,u,t=this,s,r,q,p,o
var $async$xM=A.J(function(d,e){if(d===1){u=e
x=v}while(true)switch(x){case 0:v=3
x=6
return A.R(C.aeV(),$async$xM)
case 6:s=e
q=s
if((q==null?null:q.b)!=null)t.M(new C.au6(t,s))
v=1
x=5
break
case 3:v=2
o=u
r=A.a5(o)
t.M(new C.au7(t))
A.cq(r)
x=5
break
case 2:x=1
break
case 5:return A.G(null,w)
case 1:return A.F(u,w)}})
return A.H($async$xM,w)},
J(d){return F.lm(E.aB,new F.k0(new C.aua(this),null),!0)}}
C.rT.prototype={
J(d){var x=null,w=A.ak(B.d.ah(127.5),B.h.gl(0)>>>16&255,B.h.gl(0)>>>8&255,B.h.gl(0)&255),v=this.c,u=J.aF(v),t=u.i(v,"reference"),s=y.u
return A.au(new A.bo(new A.a1(0,0,0,15),A.ck(A.a([A.by(A.a([A.aC("Reference: "+A.j(t==null?"N/A":t),x,x,x,x,x,A.b2(x,x,B.h,x,x,x,x,x,x,x,x,16,x,x,B.A,x,x,!0,x,x,x,x,x,x,x,x),x,x),A.bg(x,5,x),A.aC(A.j(u.i(v,"createdAt")),x,x,x,x,x,A.b2(x,x,B.h,x,x,x,x,x,x,x,x,12,x,x,B.q,x,x,!0,x,x,x,x,x,x,x,x),x,x)],s),B.a5,x,B.t,B.o),A.by(A.a([A.aC("Status: "+A.j(u.i(v,"status")),x,x,x,x,x,A.b2(x,x,B.h,x,x,x,x,x,x,x,x,16,x,x,B.A,x,x,!0,x,x,x,x,x,x,x,x),x,x),A.bg(x,5,x),A.aC("Total: "+A.j(u.i(v,"total")),x,x,x,x,x,A.b2(x,x,B.h,x,x,x,x,x,x,x,x,14,x,x,B.q,x,x,!0,x,x,x,x,x,x,x,x),x,x)],s),B.dm,x,B.t,B.o)],s),B.p,B.aD,B.o),x),B.l,x,x,new A.b5(x,x,new A.cV(B.n,B.n,new A.b0(w,0.4,B.y,-1),B.n),x,x,x,B.z),x,x,new A.a1(0,0,0,20),x,1/0)}}
var z=a.updateTypes(["rT(@)"])
C.au6.prototype={
$0(){var x,w=this.b.b,v=J.aF(w)
v.i(w,"page")
v.i(w,"totalPages")
v.i(w,"totalCount")
v.i(w,"itemsPerPage")
x=this.a
x.x=v.i(w,"orders")
x.w=!1},
$S:0}
C.au7.prototype={
$0(){this.a.w=!1},
$S:0}
C.aua.prototype={
$2(d,e){var x=null,w=A.cg(x,A.au(new I.of("Orders",!0,new C.au8(d),x),B.l,E.aB,x,x,x,x,x,E.c7,x),x,x,0,0,0,x),v=y.u,u=A.a([A.ck(A.a([],v),B.p,B.t,B.o),D.SS],v),t=this.a
if(t.w)B.b.F(u,A.a([G.ea],v))
else if(J.hm(t.x))B.b.F(u,A.a([D.CW],v))
else{t=J.kK(t.x,new C.au9(),y.g)
B.b.F(u,A.Z(A.Z(t,!0,t.$ti.h("an.E")),!0,y.m))}return A.au(A.dw(B.ae,A.a([w,A.cg(0,H.tC(new A.bo(E.c7,A.by(u,B.p,x,B.t,B.o),x),x,B.a4),x,x,0,0,80,x)],v),B.C,B.ai),B.l,E.aB,x,x,e.d,x,x,x,e.b)},
$S:60}
C.au8.prototype={
$0(){A.dg(this.a,!0).ep(0)},
$S:0}
C.au9.prototype={
$1(d){return new C.rT(d,null)},
$S:z+0};(function inheritance(){var x=a.inherit,w=a.inheritMany
x(C.oH,A.T)
x(C.WE,A.a0)
w(A.fu,[C.au6,C.au7,C.au8])
x(C.aua,A.fU)
x(C.au9,A.ej)
x(C.rT,A.aL)})()
A.hh(b.typeUniverse,JSON.parse('{"oH":{"T":[],"h":[]},"WE":{"a0":["oH"]},"rT":{"aL":[],"h":[]}}'))
var y={u:A.U("n<h>"),g:A.U("rT"),l:A.U("n0"),w:A.U("e"),m:A.U("h"),v:A.U("~")};(function constants(){var x=a.makeConstList
D.IZ=new A.cG(61080,!0)
D.J7=new A.fY(D.IZ,64,B.h,null)
D.VZ=new A.p(!0,B.h,null,null,null,null,18,B.A,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.YV=new A.e_("No orders made yet",null,D.VZ,null,null,null,null,null,null,null)
D.Lf=A.a(x([D.J7,G.zw,D.YV]),y.u)
D.Gq=new A.kS(B.a4,B.bP,B.o,B.p,null,B.cA,null,0,D.Lf,null)
D.CW=new A.i8(B.Y,null,null,D.Gq,null)
D.SS=new A.di(null,50,null,null)})()};
((a,b)=>{a[b]=a.current
a.eventLog.push({p:"main.dart.js_21",e:"endPart",h:b})})($__dart_deferred_initializers__,"8V/4e3WAeTJSzQYyArp6ZrH83+U=");