((a,b,c)=>{a[b]=a[b]||{}
a[b][c]=a[b][c]||[]
a[b][c].push({p:"main.dart.js_21",e:"beginPart"})})(self,"$__dart_deferred_initializers__","eventLog")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,B,D={
aVh(){return new D.oL(null)},
oL:function oL(d){this.a=d},
WT:function WT(d,e){var _=this
_.w=!0
_.x=d
_.y=e
_.c=_.a=null},
aul:function aul(d){this.a=d},
auj:function auj(d,e){this.a=d
this.b=e},
auk:function auk(d){this.a=d},
auo:function auo(d){this.a=d},
aum:function aum(d){this.a=d},
aun:function aun(){},
oM:function oM(d,e){this.c=d
this.a=e},
WU:function WU(){this.d=!1
this.c=this.a=null},
aut:function aut(d){this.a=d},
aup:function aup(d){this.a=d},
aur:function aur(d){this.a=d},
auq:function auq(d){this.a=d},
aus:function aus(d,e){this.a=d
this.b=e},
Az:function Az(d,e){this.c=d
this.a=e},
af9(){var x=0,w=A.K(y.W),v,u=2,t,s,r,q,p,o,n,m
var $async$af9=A.L(function(d,e){if(d===1){t=e
x=u}while(true)switch(x){case 0:u=4
s=A.cz($.lW()+"/user/get/orders",0,null)
r=window.localStorage.getItem("jwtToken")
o=y.N
x=7
return A.R(A.nE(s,A.a3(["Content-Type","application/json","Authorization","Bearer "+A.j(r)],o,o)),$async$af9)
case 7:q=e
if(q.b===200){o=q
o=A.f1(B.Z.eD(0,A.f6(A.f5(o.e).c.a.i(0,"charset")).c8(0,o.w),null))
v=o
x=1
break}else{o=A.bp("Failed to send message. Status code: "+q.b)
throw A.c(o)}u=2
x=6
break
case 4:u=3
m=t
p=A.a9(m)
o=A.bp("Failed to send message: "+A.j(p))
throw A.c(o)
x=6
break
case 3:x=2
break
case 6:case 1:return A.I(v,w)
case 2:return A.H(t,w)}})
return A.J($async$af9,w)}},C,H,I,G,E,K,F,L
J=c[1]
A=c[0]
B=c[2]
D=a.updateHolder(c[8],D)
C=c[31]
H=c[12]
I=c[27]
G=c[20]
E=c[32]
K=c[14]
F=c[25]
L=c[19]
D.oL.prototype={
a8(){return new D.WT([],new A.bB(null,y.J))}}
D.WT.prototype={
ap(){this.aE()
this.xR()},
Gr(){return A.e_(new D.aul(this),y.B)},
xR(){var x=0,w=A.K(y.H),v=1,u,t=this,s,r,q,p,o
var $async$xR=A.L(function(d,e){if(d===1){u=e
x=v}while(true)switch(x){case 0:v=3
x=6
return A.R(D.af9(),$async$xR)
case 6:s=e
q=s
if((q==null?null:q.b)!=null)t.P(new D.auj(t,s))
v=1
x=5
break
case 3:v=2
o=u
r=A.a9(o)
t.P(new D.auk(t))
A.jG(r)
x=5
break
case 2:x=1
break
case 5:return A.I(null,w)
case 1:return A.H(u,w)}})
return A.J($async$xR,w)},
I(d){return G.ln(F.aB,new G.k2(new D.auo(this),null),!0)}}
D.oM.prototype={
a8(){return new D.WU()}}
D.WU.prototype={
tn(d){if(d==null)return"0.00"
return J.aRe(J.aQH(d,100),2)},
a8K(d){var x,w
try{x=d.split("T")[0]
return x}catch(w){return d}},
OK(d){switch(d==null?null:d.toLowerCase()){case"pending":return C.G2
case"processing":return B.j1
case"completed":return E.FT
case"cancelled":return B.j_
default:return B.cL}},
I(d){var x,w,v,u=this,t=null,s="status",r="delivery_date",q=A.b9(8),p=A.a([new A.cq(1,B.bf,A.ah(B.d.ah(25.5),B.hw.gl(0)>>>16&255,B.hw.gl(0)>>>8&255,B.hw.gl(0)&255),I.hA,4)],y.V),o=A.b9(8),n=A.aB("Order #"+B.c.bJ(J.dL(J.a6(u.a.c,"_id")),J.dL(J.a6(u.a.c,"_id")).length-6),t,t,t,t,t,C.ie,t,t),m=u.OK(J.a6(u.a.c,s))
m=A.ah(51,m.gl(0)>>>16&255,m.gl(0)>>>8&255,m.gl(0)&255)
x=A.b9(12)
w=J.a6(u.a.c,s)
if(w==null)w="N/A"
v=y.p
x=A.c8(A.a([n,C.SK,A.av(t,A.aB(w,t,t,t,t,t,A.b3(t,t,u.OK(J.a6(u.a.c,s)),t,t,t,t,t,t,t,t,12,t,t,B.A,t,t,!0,t,t,t,t,t,t,t,t),t,t),B.l,t,t,new A.b2(m,t,t,x,t,t,B.z),t,t,t,t,B.nz,t,t,t)],v),B.p,B.r,B.n)
m=J.a6(u.a.c,"createdAt")
n=m==null?"N/A":m
n=A.fc(A.bu(A.a([x,C.kY,A.aB(n,t,t,t,t,t,A.b3(t,t,B.cK,t,t,t,t,t,t,t,t,14,t,t,t,t,t,!0,t,t,t,t,t,t,t,t),t,t)],v),B.a0,t,B.r,B.n),1)
n=A.a([new A.bb(B.cp,A.c8(A.a([n,A.e2(u.d?C.IO:C.IP,B.cK,t)],v),B.p,B.ao,B.n),t)],v)
if(u.d){m=A.a([C.YJ,C.kZ],v)
x=y.g.a(J.a6(u.a.c,"items"))
if(x==null)x=[]
B.b.F(m,J.ho(x,new D.aur(u),y.l))
m.push(E.f5)
m.push(C.YY)
m.push(C.kZ)
m.push(A.c8(A.a([C.YK,A.aB("$"+u.tn(J.a6(u.a.c,"cart_total")),t,t,t,t,t,t,t,t)],v),B.p,B.ao,B.n))
m.push(C.kY)
m.push(A.c8(A.a([C.YI,A.aB("$"+u.tn(J.a6(u.a.c,"delivery_fee")),t,t,t,t,t,t,t,t)],v),B.p,B.ao,B.n))
m.push(C.kY)
m.push(A.c8(A.a([C.YX,A.aB("$"+u.tn(J.a6(u.a.c,"service_charge")),t,t,t,t,t,t,t,t)],v),B.p,B.ao,B.n))
m.push(C.H9)
m.push(A.c8(A.a([C.YP,A.aB("$"+u.tn(J.a6(u.a.c,"total")),t,t,t,t,t,B.fa,t,t)],v),B.p,B.ao,B.n))
x=J.a6(u.a.c,s)
if(J.d(x==null?t:J.aRc(x),"pending"))B.b.F(m,A.a([E.f5,A.bh(A.My(C.YH,new D.aus(u,d),A.aHc(t,t,E.Go,t,t,t,t,t,t,B.e,t,t,C.HQ,t,new A.d6(A.b9(8),B.o),t,t,t,t)),t,1/0)],v))
if(J.a6(u.a.c,r)!=null)B.b.F(m,A.a([E.f5,C.YM,C.kZ,A.aB("Delivery Date: "+u.a8K(J.a6(u.a.c,r)),t,t,t,t,t,C.A2,t,t)],v))
B.b.F(n,A.a([C.H8,new A.bb(B.cp,A.bu(m,B.a0,t,B.r,B.n),t)],v))}return A.dr(B.ae,A.a([A.av(t,A.oF(B.ab,t,A.BC(!1,o,!0,A.bu(n,B.a0,t,B.r,B.n),t,!0,t,t,t,t,t,t,t,t,t,new D.aut(u),t,t,t,t),B.l,B.C,0,t,t,t,t,t,B.d_),B.l,t,t,new A.b2(B.e,t,t,q,p,t,B.z),t,t,t,F.ju,t,t,t,t)],v),B.D,B.af)}}
D.Az.prototype={
I(d){var x,w,v,u,t,s,r,q=null
A.an(d)
x=G.aGK(d)
w=G.aKo(d)
v=this.c
u=v==null?x.b:v
if(u==null){v=w.b
v.toString
u=v}t=x.c
if(t==null){v=w.c
v.toString
t=v}s=x.d
if(s==null){v=w.d
v.toString
s=v}r=x.e
if(r==null){v=w.e
v.toString
r=v}return A.bh(A.dM(A.av(q,q,B.l,q,q,new A.b2(q,q,new A.cW(B.o,B.o,G.aSX(d,q,t),B.o),q,q,q,B.z),q,t,q,new A.dw(s,0,r,0),q,q,q,q),q,q),u,q)}}
var z=a.updateTypes(["oM(@)"])
D.aul.prototype={
$3(d,e,f){var x,w=null
if(e.a!=null){x=A.bq(d,w,y.w).w
return A.ck(0,H.aJD(H.aFW(e.a),this.a.y,x.a.b*0.7,15),w,w,0,0,w,w)}return B.i4},
$C:"$3",
$R:3,
$S:187}
D.auj.prototype={
$0(){var x,w=this.b.b,v=J.aG(w)
v.i(w,"page")
v.i(w,"totalPages")
v.i(w,"totalCount")
v.i(w,"itemsPerPage")
x=this.a
x.x=v.i(w,"orders")
x.w=!1},
$S:0}
D.auk.prototype={
$0(){this.a.w=!1},
$S:0}
D.auo.prototype={
$2(d,e){var x,w=null,v=A.ck(w,A.av(w,new K.ok("Orders",!0,new D.aum(d),w),B.l,F.aB,w,w,w,w,w,w,F.c7,w,w,w),w,w,0,0,0,w),u=y.p,t=A.a([A.c8(A.a([],u),B.p,B.r,B.n),C.SR],u),s=this.a
if(s.w)B.b.F(t,A.a([E.eb],u))
else if(J.hn(s.x))B.b.F(t,A.a([C.D_],u))
else{x=J.ho(s.x,new D.aun(),y.i)
B.b.F(t,A.Y(A.Y(x,!0,x.$ti.h("am.E")),!0,y.l))}return A.av(w,A.dr(B.ae,A.a([v,A.ck(0,L.tK(new A.bb(F.c7,A.bu(t,B.p,w,B.r,B.n),w),w,B.a5),w,w,0,0,80,w),s.Gr()],u),B.D,B.af),B.l,F.aB,w,w,w,e.d,w,w,w,w,w,e.b)},
$S:58}
D.aum.prototype={
$0(){A.dh(this.a,!0).eq(0)},
$S:0}
D.aun.prototype={
$1(d){return new D.oM(d,null)},
$S:z+0}
D.aut.prototype={
$0(){var x=this.a
x.P(new D.aup(x))},
$S:0}
D.aup.prototype={
$0(){var x=this.a
x.d=!x.d},
$S:0}
D.aur.prototype={
$1(d){var x=null,w=J.aG(d),v=w.i(d,"product_name"),u=y.p
v=A.a([A.aB(v==null?"N/A":v,x,x,x,x,x,C.Wy,x,x)],u)
w=y.Y.a(w.i(d,"product_units"))
if(w==null)w=x
else{w=J.aBP(w)
w=w.fl(w,new D.auq(this.a),y.l)}B.b.F(v,w==null?A.a([],u):w)
return new A.bb(C.HN,A.bu(v,B.a0,x,B.r,B.n),x)},
$S:505}
D.auq.prototype={
$1(d){var x=null,w=d.b,v=J.aG(w)
return new A.bb(C.HY,A.aB(A.j(d.a)+": "+A.j(v.i(w,"quantity"))+"x $"+this.a.tn(v.i(w,"price")),x,x,x,x,x,C.A2,x,x),x)},
$S:506}
D.aus.prototype={
$0(){var x=A.bI(this.b,!1,y.B)
x.a=J.a6(this.a.a.c,"_id")
x.ac()},
$S:0};(function inheritance(){var x=a.inheritMany,w=a.inherit
x(A.T,[D.oL,D.oM])
x(A.Z,[D.WT,D.WU])
x(A.ek,[D.aul,D.aun,D.aur,D.auq])
x(A.fw,[D.auj,D.auk,D.aum,D.aut,D.aup,D.aus])
w(D.auo,A.fY)
w(D.Az,A.aN)})()
A.fT(b.typeUniverse,JSON.parse('{"oL":{"T":[],"h":[]},"WT":{"Z":["oL"]},"oM":{"T":[],"h":[]},"WU":{"Z":["oM"]},"Az":{"aN":[],"h":[]}}'))
var y=(function rtii(){var x=A.V
return{B:x("iT"),V:x("n<cq>"),p:x("n<h>"),J:x("bB<pr>"),w:x("fC"),i:x("oM"),W:x("lq"),N:x("e"),l:x("h"),g:x("y<@>?"),Y:x("aw<@,@>?"),H:x("~")}})();(function constants(){var x=a.makeConstList
C.J1=new A.cO(61080,!0)
C.J9=new A.hB(C.J1,64,B.h,null)
C.VW=new A.p(!0,B.h,null,null,null,null,18,B.A,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
C.Z_=new A.db("No orders made yet",null,C.VW,null,null,null,null,null,null,null)
C.Lg=A.a(x([C.J9,E.f5,C.Z_]),y.p)
C.Gp=new A.kS(B.a5,B.bP,B.n,B.p,null,B.cB,null,0,C.Lg,null)
C.D_=new A.ia(B.X,null,null,C.Gp,null)
C.G2=new A.A(1,0.9372549019607843,0.4235294117647059,0,B.f)
C.H8=new D.Az(1,null)
C.H9=new D.Az(null,null)
C.HN=new A.a1(0,0,0,8)
C.HQ=new A.a1(0,19,0,19)
C.HY=new A.a1(16,0,0,0)
C.IO=new A.cO(57925,!1)
C.IP=new A.cO(57926,!1)
C.SK=new A.d7(8,null,null,null)
C.kY=new A.d7(null,4,null,null)
C.SR=new A.d7(null,50,null,null)
C.kZ=new A.d7(null,8,null,null)
C.Wy=new A.p(!0,null,null,null,null,null,null,B.A,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
C.ie=new A.p(!0,null,null,null,null,null,16,B.am,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
C.A2=new A.p(!0,null,null,null,null,null,14,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
C.Wz=new A.p(!0,null,null,null,null,null,16,B.A,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
C.YH=new A.db("Complete Order",null,C.Wz,null,null,null,null,null,null,null)
C.YI=new A.db("Delivery Fee",null,null,null,null,null,null,null,null,null)
C.YJ=new A.db("Order Items",null,C.ie,null,null,null,null,null,null,null)
C.YK=new A.db("Subtotal",null,null,null,null,null,null,null,null,null)
C.YM=new A.db("Delivery Information",null,C.ie,null,null,null,null,null,null,null)
C.YP=new A.db("Total",null,B.fa,null,null,null,null,null,null,null)
C.YX=new A.db("Service Charge",null,null,null,null,null,null,null,null,null)
C.YY=new A.db("Order Summary",null,C.ie,null,null,null,null,null,null,null)})()};
((a,b)=>{a[b]=a.current
a.eventLog.push({p:"main.dart.js_21",e:"endPart",h:b})})($__dart_deferred_initializers__,"ifVYBqV1InC+rKgIJAT/UBCCKYw=");