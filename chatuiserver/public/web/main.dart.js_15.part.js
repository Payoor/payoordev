((a,b,c)=>{a[b]=a[b]||{}
a[b][c]=a[b][c]||[]
a[b][c].push({p:"main.dart.js_15",e:"beginPart"})})(self,"$__dart_deferred_initializers__","eventLog")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,H,G,I,K,B={
aRD(){return new B.nR(null)},
nR:function nR(d){this.a=d},
FR:function FR(d,e,f){var _=this
_.y=_.x=_.w=_.r=_.f=_.e=_.d=$
_.z=0
_.Q=d
_.ch=_.ay=_.ax=_.at=_.as=""
_.cy=_.CW=!1
_.db=null
_.bz$=e
_.aJ$=f
_.c=_.a=null},
aoi:function aoi(d,e){this.a=d
this.b=e},
aoh:function aoh(d){this.a=d},
aog:function aog(d){this.a=d},
ao_:function ao_(d){this.a=d},
ao0:function ao0(d,e){this.a=d
this.b=e},
ao1:function ao1(d){this.a=d},
ao2:function ao2(d,e){this.a=d
this.b=e},
ao3:function ao3(d){this.a=d},
ao4:function ao4(d,e){this.a=d
this.b=e},
ao5:function ao5(d,e){this.a=d
this.b=e},
ao6:function ao6(d,e){this.a=d
this.b=e},
ao7:function ao7(d){this.a=d},
anX:function anX(d){this.a=d},
anY:function anY(d){this.a=d},
anZ:function anZ(d){this.a=d},
anV:function anV(d){this.a=d},
anW:function anW(d){this.a=d},
aob:function aob(d,e){this.a=d
this.b=e},
aoa:function aoa(d,e){this.a=d
this.b=e},
ao9:function ao9(d){this.a=d},
ao8:function ao8(d){this.a=d},
aoe:function aoe(d){this.a=d},
aoc:function aoc(d,e){this.a=d
this.b=e},
aod:function aod(d){this.a=d},
aof:function aof(d,e){this.a=d
this.b=e},
Jq:function Jq(){},
o7:function o7(d,e){this.a=d
this.b=e},
Ak:function Ak(d,e,f,g,h,i,j,k,l){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.r=h
_.w=i
_.y=j
_.z=k
_.a=l},
Gm:function Gm(){var _=this
_.e=_.d=$
_.f=null
_.w=_.r=!1
_.c=_.a=null},
aqF:function aqF(d){this.a=d},
aqG:function aqG(d){this.a=d},
aqB:function aqB(d,e){this.a=d
this.b=e},
aqD:function aqD(d,e){this.a=d
this.b=e},
aqC:function aqC(d){this.a=d},
aqE:function aqE(d){this.a=d},
KP(d){return B.aRw(d)},
aRw(d){var w=0,v=A.I(x.i),u,t=2,s,r,q,p,o,n,m,l
var $async$KP=A.J(function(e,f){if(e===1){s=f
w=t}while(true)switch(w){case 0:t=4
p=A.cA($.lW()+"/auth/email/otp",0,null)
o=x.N
n=A.a3(["Content-Type","application/json"],o,o)
w=7
return A.R(A.qp(p,C.Z.nY(A.a3(["email",d],o,x.T),null),n),$async$KP)
case 7:r=f
if(r.b===200){p=r
p=A.f1(C.Z.eD(0,A.f6(A.f5(p.e).c.a.i(0,"charset")).c8(0,p.w),null))
u=p
w=1
break}else{p=A.bp("Failed to get OTP: "+r.b)
throw A.c(p)}t=2
w=6
break
case 4:t=3
l=s
q=A.a9(l)
p=A.bp("Failed to get OTP: "+A.j(q))
throw A.c(p)
w=6
break
case 3:w=2
break
case 6:case 1:return A.G(u,v)
case 2:return A.F(s,v)}})
return A.H($async$KP,v)},
a2Y(d,e){return B.aRA(d,e)},
aRA(d,e){var w=0,v=A.I(x.i),u,t=2,s,r,q,p,o,n,m,l
var $async$a2Y=A.J(function(f,g){if(f===1){s=g
w=t}while(true)switch(w){case 0:t=4
p=A.cA($.lW()+"/auth/email/verify",0,null)
o=x.N
n=A.a3(["Content-Type","application/json"],o,o)
w=7
return A.R(A.qp(p,C.Z.nY(A.a3(["otp",e,"email",d],o,o),null),n),$async$a2Y)
case 7:r=g
if(r.b===200){p=r
p=A.f1(C.Z.eD(0,A.f6(A.f5(p.e).c.a.i(0,"charset")).c8(0,p.w),null))
u=p
w=1
break}else{p=A.bp("Failed to verify OTP: "+r.b)
throw A.c(p)}t=2
w=6
break
case 4:t=3
l=s
q=A.a9(l)
p=A.bp("Failed to verify OTP: "+A.j(q))
throw A.c(p)
w=6
break
case 3:w=2
break
case 6:case 1:return A.G(u,v)
case 2:return A.F(s,v)}})
return A.H($async$a2Y,v)},
a2W(d,e,f,g,h){return B.aRy(d,e,f,g,h)},
aRy(d,e,f,g,h){var w=0,v=A.I(x.i),u,t=2,s,r,q,p,o,n,m,l
var $async$a2W=A.J(function(i,j){if(i===1){s=j
w=t}while(true)switch(w){case 0:t=4
p=A.cA($.lW()+"/auth/signup",0,null)
o=x.N
n=A.a3(["Content-Type","application/json"],o,o)
w=7
return A.R(A.qp(p,C.Z.nY(A.a3(["name",f,"email",d,"otp",g,"phone",h,"location",e,"shoppingList","leave as empty"],o,o),null),n),$async$a2W)
case 7:r=j
if(r.b===200){p=r
p=A.f1(C.Z.eD(0,A.f6(A.f5(p.e).c.a.i(0,"charset")).c8(0,p.w),null))
u=p
w=1
break}else{p=A.bp("Failed to sign up: "+r.b)
throw A.c(p)}t=2
w=6
break
case 4:t=3
l=s
q=A.a9(l)
p=A.bp("Failed to sign up: "+A.j(q))
throw A.c(p)
w=6
break
case 3:w=2
break
case 6:case 1:return A.G(u,v)
case 2:return A.F(s,v)}})
return A.H($async$a2W,v)},
aRC(d){switch(d.a){case 0:return"Tell us your name so we can personalize your shopping experience"
case 1:return"What's your email address? We'll send you an otp as well as important updates here"
case 2:return y.b
case 3:return"Add your Nigerian phone number for order updates and delivery notifications"
case 4:return"Where would you like your groceries delivered? Enter your delivery address"
case 5:return"What items do you typically look for when grocery shopping? List them below"}}},D,L,M,N,O,F,E,P,Q
J=c[1]
A=c[0]
C=c[2]
H=c[19]
G=c[14]
I=c[29]
K=c[17]
B=a.updateHolder(c[4],B)
D=c[27]
L=c[12]
M=c[11]
N=c[18]
O=c[28]
F=c[16]
E=c[25]
P=c[21]
Q=c[20]
B.nR.prototype={
a8(){return new B.FR(A.t(x.q,x.v),null,null)}}
B.FR.prototype={
uv(){var w=this
switch(w.z){case 0:return w.at.length!==0&&w.Q.i(0,0)===!0
case 1:return w.ax.length!==0&&w.Q.i(0,1)===!0
case 2:return w.as.length!==0&&w.Q.i(0,2)===!0
case 3:return w.ay.length!==0&&w.Q.i(0,3)===!0
case 4:return w.ch.length!==0&&w.Q.i(0,4)===!0
default:return!1}},
Cx(d){this.P(new B.aoi(this,d))},
ap(){var w,v,u,t=this,s=null
t.aE()
t.r=new F.nd(E.f8,$.aC())
t.f=G.aIB(0)
w=A.ra(!0,s,!0,!0,s,s,!1)
t.w!==$&&A.bI()
t.w=w
w=A.c5(s,C.br,s,s,t)
t.d=w
v=x.t
u=v.h("aY<aI.T>")
t.e=new A.aY(w,new A.az(0,1,v),u)
w=A.c5(s,A.c1(0,0,0,500,0),s,s,t)
t.x=w
t.y=new A.aY(A.dp(E.cN,w,s),new A.az(1,0,v),u)
t.f.S(0,t.gab7())},
ab8(){var w=this.f
w===$&&A.b()
w=w.f
if(w.length!==0)x.g.a(C.b.gaH(w)).gvT(0)},
bp(){var w,v=this
v.dn()
if(v.z===5){w=v.c
w.toString
if(A.bH(w,!1,x.k).a.length!==0){w=v.r
w===$&&A.b()
w.a.toString}}},
Oy(d){switch(d){case 0:return D.ng
case 1:return D.GM
case 2:return D.nf
case 3:return D.nh
case 4:return D.GN
case 5:return D.fS
default:return D.ng}},
a99(d){switch(d){case 0:return"Enter your email address..."
case 1:return"Enter the 6-digit OTP..."
case 2:return"Enter your full name..."
case 3:return"Enter your Nigerian phone number..."
case 4:return"Enter your delivery address..."
case 5:return"List your typical grocery items..."
default:return""}},
a9u(d){switch(d){case 0:return"Step 1"
case 1:return"Verification"
case 2:return"Step 2"
case 3:return"Step 3"
case 4:return"Step 4"
case 5:return"Final Step"
default:return""}},
aaI(d){var w
switch(this.z){case 4:w=this.c
w.toString
A.bH(w,!1,x.y).rK(d)
break}},
nl(d){return this.acj(d)},
acj(d){var w=0,v=A.I(x.H),u,t=2,s,r=[],q=this,p,o,n,m,l,k,j,i,h,g
var $async$nl=A.J(function(e,f){if(e===1){s=f
w=t}while(true)switch(w){case 0:q.P(new B.ao_(q))
t=3
case 6:switch(q.z){case 0:w=8
break
case 1:w=9
break
case 2:w=10
break
case 3:w=11
break
case 4:w=12
break
default:w=7
break}break
case 8:t=14
q.P(new B.ao0(q,d))
k=q.r
k===$&&A.b()
k.hD(0,E.d9)
w=17
return A.R(B.KP(d),$async$nl)
case 17:if(q.uv())q.AY()
t=3
w=16
break
case 14:t=13
h=s
q.P(new B.ao1(q))
q.Cx("That didn't work. Please try entering your email again.")
r=[1]
w=4
break
w=16
break
case 13:w=3
break
case 16:w=7
break
case 9:t=19
q.P(new B.ao2(q,d))
k=q.r
k===$&&A.b()
k.hD(0,E.d9)
w=22
return A.R(B.a2Y(q.at,d),$async$nl)
case 22:p=f
o=J.a6(p.b,"userExists")
w=q.uv()&&!o?23:25
break
case 23:q.AY()
w=24
break
case 25:k=q.c
k.toString
n=A.bH(k,!1,x.S)
m=J.a6(p.b,"id")
k=n
k.a=m
k.ac()
w=26
return A.R(L.KO(m),$async$nl)
case 26:p=f
k=x.X
w=p.a?27:29
break
case 27:l=J.a6(p.b,"token")
i=n
i.b=l
i.ac()
window.localStorage.setItem("jwtToken",l)
n.ux()
i=q.x
i===$&&A.b()
w=30
return A.R(i.bQ(0),$async$nl)
case 30:i=q.c
i.toString
A.dh(i,!1).jS("/authchat",null,k)
w=28
break
case 29:i=q.c
i.toString
A.dh(i,!1).jS("/",null,k)
case 28:case 24:t=3
w=21
break
case 19:t=18
g=s
q.P(new B.ao3(q))
q.Cx("Incorrect OTP. Please try entering it again.")
k=q.r
k===$&&A.b()
k.hD(0,E.d9)
r=[1]
w=4
break
w=21
break
case 18:w=3
break
case 21:w=7
break
case 10:q.P(new B.ao4(q,d))
k=q.r
k===$&&A.b()
k.hD(0,E.d9)
if(q.uv())q.AY()
w=7
break
case 11:q.P(new B.ao5(q,d))
k=q.r
k===$&&A.b()
k.hD(0,E.d9)
if(q.uv())q.AY()
w=7
break
case 12:q.P(new B.ao6(q,d))
k=q.r
k===$&&A.b()
k.hD(0,E.d9)
q.tw()
w=7
break
case 7:r.push(5)
w=4
break
case 3:r=[2]
case 4:t=2
q.P(new B.ao7(q))
w=r.pop()
break
case 5:case 1:return A.G(u,v)
case 2:return A.F(s,v)}})
return A.H($async$nl,v)},
xY(){var w=0,v=A.I(x.H),u=1,t,s=[],r=this,q,p
var $async$xY=A.J(function(d,e){if(d===1){t=e
w=u}while(true)switch(w){case 0:r.P(new B.anX(r))
u=3
w=6
return A.R(B.KP(r.at),$async$xY)
case 6:s.push(5)
w=4
break
case 3:u=2
p=t
r.P(new B.anY(r))
s.push(5)
w=4
break
case 2:s=[1]
case 4:u=1
r.P(new B.anZ(r))
w=s.pop()
break
case 5:return A.G(null,v)
case 1:return A.F(t,v)}})
return A.H($async$xY,v)},
tw(){var w=0,v=A.I(x.H),u=1,t,s=[],r=this,q,p,o,n,m,l,k,j,i
var $async$tw=A.J(function(d,e){if(d===1){t=e
w=u}while(true)switch(w){case 0:j=x.N
A.a3(["name",r.as,"email",r.at,"otp",r.ax,"phone",r.ay,"location",r.ch],j,j)
u=3
j=r.as
n=r.at
m=r.ax
l=r.ay
w=6
return A.R(B.a2W(n,r.ch,j,m,l),$async$tw)
case 6:q=e
l=r.c
l.toString
p=A.bH(l,!1,x.S)
l=p
l.a=J.a6(J.a6(q.b,"user"),"id")
l.ac()
l=p
l.e=J.a6(q.b,"user")
l.ac()
w=q.a?7:8
break
case 7:j=r.x
j===$&&A.b()
w=9
return A.R(j.bQ(0),$async$tw)
case 9:j=r.c
j.toString
A.dh(j,!1).jS("/welcome",null,x.X)
case 8:s.push(5)
w=4
break
case 3:u=2
i=t
o=A.a9(i)
A.lT(o)
r.P(new B.anV(r))
r.Cx("Network error during signup. Please check your connection and try again.")
s.push(5)
w=4
break
case 2:s=[1]
case 4:u=1
r.P(new B.anW(r))
w=s.pop()
break
case 5:return A.G(null,v)
case 1:return A.F(t,v)}})
return A.H($async$tw,v)},
Ic(){var w=this.d
w===$&&A.b()
w.bQ(0)},
Ia(){var w=this.d
w===$&&A.b()
w.di(0)},
AY(){var w,v=this
if(v.z<4&&v.uv()){w=v.f
w===$&&A.b()
w.Ga(v.z+1,C.cM,A.c1(0,0,0,500,0))}},
asG(){var w,v=this.z
if(v>0){w=this.f
w===$&&A.b()
w.Ga(v-1,C.cM,A.c1(0,0,0,500,0))}},
akw(d){var w,v,u,t,s=this,r=null,q=new B.aob(s,d),p=x.p,o=A.a([],p),n=d>0
if(n)o.push(A.c7(r,A.dY(O.jH,C.e,15),C.A,!1,r,r,r,r,r,r,r,r,r,r,r,r,r,s.gasF(),r,r,r,r,r,r))
if(n)o.push(A.bh(r,r,10))
o.push(A.aB(s.a9u(d),r,r,r,r,r,A.b3(r,r,C.e,r,r,r,r,r,r,r,r,18,r,r,C.am,r,r,!0,r,r,r,r,r,r,r,r),r,r))
o=A.c9(o,C.p,C.r,C.n)
n=A.bh(r,16,r)
w=s.db
v=s.cy
u=new B.aoa(s,d).$0()
if(s.db!=null)t=d===0||d===1
else t=!1
o=A.a([o,n,new K.lB(u,A.b3(r,r,t?A.ah(204,C.aD.gl(0)>>>16&255,C.aD.gl(0)>>>8&255,C.aD.gl(0)&255):A.ah(204,C.e.gl(0)>>>16&255,C.e.gl(0)>>>8&255,C.e.gl(0)&255),r,r,r,r,r,r,r,r,16,r,r,r,r,r,!0,r,r,r,r,r,r,r,r),A.c1(0,0,0,1500,0),!0,C.bF,r,r,r,new A.d0(""+d+"_"+A.j(w)+"_"+v,x.O))],p)
n=s.z
if(!(n===0&&s.CW&&d===0))n=n===1&&s.CW&&d===1
else n=!0
if(n)C.b.F(o,A.a([A.bh(r,16,r),new A.bb(new A.a1(4,0,0,0),new N.uJ(r),r)],p))
if(s.Q.i(0,d)===!0&&J.bZ(q.$0())!==0){n=A.bh(r,24,r)
w=A.b9(12)
C.b.F(o,A.a([n,A.ar(r,A.bu(A.a([A.aB("Visitor:",r,r,r,r,r,A.b3(r,r,A.ah(153,C.e.gl(0)>>>16&255,C.e.gl(0)>>>8&255,C.e.gl(0)&255),r,r,r,r,r,r,r,r,14,r,r,r,r,r,!0,r,r,r,r,r,r,r,r),r,r),A.bh(r,8,r),A.aB(q.$0(),r,r,r,r,r,A.b3(r,r,C.e,r,r,r,r,r,r,r,r,16,r,r,C.B,r,r,!0,r,r,r,r,r,r,r,r),r,r)],p),C.a0,r,C.r,C.aR),C.l,r,r,new A.b1(r,r,r,w,r,r,C.z),r,r,r,r,new A.a1(0,17,0,17),r,r,r)],p))}if(d===1){q=s.CW
p=q?r:s.gPh()
n=q?r:s.gPh()
w=A.b9(50)
v=F.iU(A.ah(C.d.ah(255*(q?0.5:1)),C.e.gl(0)>>>16&255,C.e.gl(0)>>>8&255,C.e.gl(0)&255),1)
u=A.b9(4)
o.push(new A.bb(new A.a1(0,16,0,16),F.aDz(A.BC(!1,w,!0,A.ar(r,A.dM(A.aB("Resend OTP",r,r,r,r,r,A.b3(r,r,A.ah(C.d.ah(255*(s.CW?0.5:1)),C.e.gl(0)>>>16&255,C.e.gl(0)>>>8&255,C.e.gl(0)&255),r,r,r,r,r,r,r,r,14,r,r,C.B,r,r,!0,r,0.5,r,r,r,r,r,r),r,r),r,r),C.l,r,r,new A.b1(C.C,r,v,u,r,r,C.z),r,r,r,r,new A.a1(12,12,12,12),r,r,120),r,!0,r,r,r,r,r,r,r,r,r,n,r,r,r,r),p,r),r))}if(d===4)o.push(new M.uH(new B.ao8(s),new B.ao9(s),r))
return Q.tK(A.bu(o,C.a0,r,C.r,C.aR),r,C.a5)},
I(d){var w,v,u,t=this,s=null,r=x.w,q=A.bq(d,s,r).w,p=t.y
p===$&&A.b()
r=A.bq(d,s,r).w
w=A.b9(12)
v=A.b9(12)
u=t.f
u===$&&A.b()
r=A.ch(s,A.ar(s,G.aGh(v,G.aIE(u,new B.aod(t),6,new B.aoe(t),new G.wh(s),C.a5)),C.l,s,s,new A.b1(s,s,s,w,s,s,C.z),s,r.a.b*0.5,s,s,s,s,s,s),s,s,20,20,40,s)
w=t.e
w===$&&A.b()
u=t.r
u===$&&A.b()
v=t.w
v===$&&A.b()
return P.lo(C.u,new A.fe(p,!1,A.dr(C.ae,A.a([r,A.m0(w,new B.aof(t,q.f.d),A.ar(s,new B.Ak(t.gaaH(),t.gIb(),t.gI9(),t.ga51(),t.Oy(t.z),t.a99(t.z),u,v,s),C.l,s,s,s,s,s,s,s,new A.a1(20,20,20,20),s,s,s))],x.p),C.D,C.zE),s),!1)},
m(){var w=this,v=w.r
v===$&&A.b()
v.R$=$.aC()
v.y2$=0
v=w.d
v===$&&A.b()
v.m()
v=w.f
v===$&&A.b()
v.m()
v=w.x
v===$&&A.b()
v.m()
w.a44()}}
B.Jq.prototype={
bg(){this.cz()
this.cj()
this.eg()},
m(){var w=this,v=w.aJ$
if(v!=null)v.H(0,w.ge_())
w.aJ$=null
w.aC()}}
B.o7.prototype={
G(){return"CustomInputType."+this.b}}
B.Ak.prototype={
a8(){return new B.Gm()},
XF(d){return this.c.$1(d)},
J8(){return this.d.$0()},
J7(){return this.e.$0()},
arV(d,e){return this.f.$1(e)}}
B.Gm.prototype={
ap(){var w,v,u=this
u.aE()
w=u.a
v=w.y
u.e!==$&&A.bI()
u.e=v
w=w.z
u.d!==$&&A.bI()
u.d=w
w.S(0,new B.aqF(u))
v.S(0,new B.aqG(u))
u.pp()},
pp(){var w=0,v=A.I(x.H),u=this,t
var $async$pp=A.J(function(d,e){if(d===1)return A.F(e,v)
while(true)switch(w){case 0:t=B
w=2
return A.R(F.A5("text/plain"),$async$pp)
case 2:u.P(new t.aqB(u,e))
return A.G(null,v)}})
return A.H($async$pp,v)},
yp(){var w=0,v=A.I(x.H),u=this,t,s,r,q,p,o,n,m,l
var $async$yp=A.J(function(d,e){if(d===1)return A.F(e,v)
while(true)switch(w){case 0:w=2
return A.R(F.A5("text/plain"),$async$yp)
case 2:l=e
if((l==null?null:l.a)!=null){t=u.e
t===$&&A.b()
s=t.a
r=s.b
q=r.c
p=s.a
s=q>=0
o=s?q:p.length
r=s?r.d:p.length
n=l.a
m=C.c.kP(p,o,r,n)
t.hD(0,new A.cq(m,F.kn(C.m,s?q+n.length:m.length),C.aT))
u.FQ(m)
u.a.XF(m)}return A.G(null,v)}})
return A.H($async$yp,v)},
FQ(d){this.P(new B.aqD(this,d))},
Mb(){var w,v,u=this
if(u.r){w=u.a
w.toString
v=u.e
v===$&&A.b()
w.arV(0,C.c.ci(v.a.a))
v=u.d
v===$&&A.b()
v.fM()
u.P(new B.aqC(u))}},
a9c(){switch(this.a.r.a){case 1:return E.Ui
case 2:return E.Ug
case 3:return E.Uh
case 0:return E.Uj
case 4:return E.Uk
case 5:return C.dQ}},
I(a1){var w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this,d=null,a0=e.e
a0===$&&A.b()
w=e.d
w===$&&A.b()
v=e.a.r
u=v===D.fS
t=u?d:1
s=u?3:1
if(u)v=500
else if(v===D.nf)v=50
else v=v===D.nh?14:d
u=e.a9c()
r=A.b3(d,d,C.e,d,d,d,d,d,d,d,d,16,d,d,d,d,d,!0,d,d,d,d,d,d,d,d)
q=e.a.r===D.fS
p=q?20:30
q=q?200:56
o=A.b9(12)
n=A.b9(12)
m=A.b9(12)
l=A.b9(12)
k=C.d.ah(127.5)
j=A.ah(k,C.aD.gl(0)>>>16&255,C.aD.gl(0)>>>8&255,C.aD.gl(0)&255)
i=A.b9(12)
h=e.a.w
g=A.b3(d,d,C.e,d,d,d,d,d,d,d,d,d,d,d,d,d,d,!0,d,d,d,d,d,d,d,d)
f=e.f
if(f==null){e.a.toString
f=d}h=F.Nt(d,new F.da(4,o,C.o),new A.ab(0,1/0,0,q),new A.a1(16,p,16,p),d,d,"",d,!0,new F.da(4,n,C.o),d,new F.da(4,l,new A.b0(j,1,C.y,-1)),d,d,f,E.bp,!0,d,d,d,d,new F.da(4,m,new A.b0(E.bp,2,C.y,-1)),new F.da(4,i,new A.b0(C.aD,2,C.y,-1)),d,d,d,d,d,d,g,h,d,d,d,d,d,d,d,d,d,!0,d,d,d,d,d,d,d,d,d,d,d,d,d)
q=e.w?96:56
p=e.a.r===D.fS
o=p?12:8
a0=A.a([F.alb(a0,d,h.alq(new A.a1(16,o,q,p?12:8)),!0,!0,d,w,u,v,t,s,d,new B.aqE(e),e.ga6d(),r,d,d)],x.p)
if(e.w){w=A.ah(k,C.u.gl(0)>>>16&255,C.u.gl(0)>>>8&255,C.u.gl(0)&255)
a0.push(A.ch(d,A.c7(d,A.ar(d,A.dY(D.IM,C.e,15),C.l,d,d,new A.b1(w,d,d,d,d,d,C.c2),d,34,d,d,d,d,d,34),C.A,!1,d,d,d,d,d,d,d,d,d,d,d,d,d,e.gafj(),d,d,d,d,d,d),d,d,d,50,7,d))}w=A.c1(0,0,0,200,0)
v=e.r
u=v?1:0.5
t=v?e.ga52():d
v=v?C.u:A.ah(k,C.u.gl(0)>>>16&255,C.u.gl(0)>>>8&255,C.u.gl(0)&255)
a0.push(A.ch(d,H.m1(A.c7(d,A.ar(d,A.dY(I.o1,C.e,15),C.l,d,d,new A.b1(v,d,d,d,d,d,C.c2),d,34,d,d,d,d,d,34),C.A,!1,d,d,d,d,d,d,d,d,d,d,d,d,d,t,d,d,d,d,d,d),C.a3,w,u),d,d,d,8,7,d))
return A.dr(C.ae,a0,C.D,C.af)},
m(){this.a.toString
this.aC()}}
var z=a.updateTypes(["~()","af<~>()","~(e)","af<~>(e)"])
B.aoi.prototype={
$0(){var w=this.a
w.cy=!0
w.db=this.b
A.ij(A.c1(0,0,0,100,0),new B.aoh(w),x.P)},
$S:0}
B.aoh.prototype={
$0(){var w=this.a
if(w.c!=null)w.P(new B.aog(w))},
$S:9}
B.aog.prototype={
$0(){this.a.cy=!1},
$S:0}
B.ao_.prototype={
$0(){this.a.CW=!0},
$S:0}
B.ao0.prototype={
$0(){var w=this.a
w.at=this.b
w.Q.n(0,0,!0)},
$S:0}
B.ao1.prototype={
$0(){var w=this.a
w.at=""
w.Q.n(0,0,!1)},
$S:0}
B.ao2.prototype={
$0(){var w=this.a
w.ax=this.b
w.Q.n(0,1,!0)},
$S:0}
B.ao3.prototype={
$0(){var w=this.a
w.ax=""
w.Q.n(0,1,!1)},
$S:0}
B.ao4.prototype={
$0(){var w=this.a
w.as=this.b
w.Q.n(0,2,!0)},
$S:0}
B.ao5.prototype={
$0(){var w=this.a
w.ay=this.b
w.Q.n(0,3,!0)},
$S:0}
B.ao6.prototype={
$0(){var w=this.a
w.ch=this.b
w.Q.n(0,4,!0)},
$S:0}
B.ao7.prototype={
$0(){this.a.CW=!1},
$S:0}
B.anX.prototype={
$0(){this.a.CW=!0},
$S:0}
B.anY.prototype={
$0(){},
$S:0}
B.anZ.prototype={
$0(){this.a.CW=!1},
$S:0}
B.anV.prototype={
$0(){},
$S:0}
B.anW.prototype={
$0(){this.a.CW=!1},
$S:0}
B.aob.prototype={
$0(){var w=this
switch(w.b){case 0:return w.a.at
case 1:return w.a.ax
case 2:return w.a.as
case 3:return w.a.ay
case 4:return w.a.ch
default:return""}},
$S:41}
B.aoa.prototype={
$0(){var w,v,u=this.a
if(u.cy)return""
w=u.db
if(w!=null){v=this.b
v=v===0||v===1}else v=!1
if(v){w.toString
return w}w=this.b
return w===1?y.b:B.aRC(u.Oy(w))},
$S:41}
B.ao9.prototype={
$1(d){var w=this.a,v=w.r
v===$&&A.b()
v.scF(0,d)
w=w.w
w===$&&A.b()
w.fM()},
$S:67}
B.ao8.prototype={
$1(d){var w,v,u=d.i(0,"address")
u.toString
w=this.a
v=w.r
v===$&&A.b()
v.scF(0,u)
u=w.c
u.toString
u=A.bH(u,!1,x.y)
u.a=[]
u.ac()
w=w.w
w===$&&A.b()
w.fM()},
$S:150}
B.aoe.prototype={
$1(d){var w=this.a
w.P(new B.aoc(w,d))},
$S:20}
B.aoc.prototype={
$0(){this.a.z=this.b},
$S:0}
B.aod.prototype={
$2(d,e){var w=null
return A.ar(w,this.a.akw(e),C.l,w,w,w,w,w,w,w,new A.a1(16,16,16,16),w,w,w)},
$S:499}
B.aof.prototype={
$2(d,e){var w,v=null,u=this.a.e
u===$&&A.b()
w=u.a
w=u.b.ag(0,w.gl(w))
e.toString
return A.ch(this.b*w,e,v,v,0,0,v,v)},
$S:121}
B.aqF.prototype={
$0(){var w=this.a,v=w.d
v===$&&A.b()
if(v.gbM()){v=w.e
v===$&&A.b()
w.FQ(v.a.a)
w.pp()
w.a.J8()}else w.a.J7()},
$S:0}
B.aqG.prototype={
$0(){var w=this.a,v=w.e
v===$&&A.b()
w.FQ(v.a.a)
w=w.a
w.toString
w.XF(v.a.a)},
$S:0}
B.aqB.prototype={
$0(){var w=this.b
if(w==null)w=null
else w=w.a.length!==0
this.a.w=w===!0},
$S:0}
B.aqD.prototype={
$0(){var w,v,u,t,s,r=this,q=null,p="Name must be at least 2 characters",o="Name must be less than 50 characters",n="Location cannot be empty",m="Location must be at least 3 characters",l="Text cannot be empty",k=r.a
k.f=null
w=q
switch(k.a.r.a){case 1:v=A.bQ("^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\\.[a-zA-Z]+",!0,!1)
w=C.c.ci(r.b)
u=k.f=!v.b.test(w)?"Please enter a valid email address":q
w=u
break
case 2:t=A.bQ("^\\d{6}$",!0,!1)
w=C.c.ci(r.b)
u=k.f=!t.b.test(w)?"Please enter a valid 6-digit OTP":q
w=u
break
case 3:s=A.bQ("^([0]|[\\+]234)[789][01]\\d{8}$",!0,!1)
w=C.c.ci(r.b)
u=k.f=!s.b.test(w)?"Please enter a valid Nigerian phone number":q
w=u
break
case 0:u=C.c.ci(r.b).length
if(u<2){k.f=p
w=p}else if(u>50){k.f=o
w=o}break
case 4:u=C.c.ci(r.b).length
if(u===0){k.f=n
w=n}else if(u<3){k.f=m
w=m}break
case 5:if(C.c.ci(r.b).length===0){k.f=l
w=l}break}k.r=w==null&&C.c.ci(r.b).length!==0},
$S:0}
B.aqC.prototype={
$0(){this.a.f=null},
$S:0}
B.aqE.prototype={
$1(d){return this.a.Mb()},
$S:32};(function aliases(){var w=B.Jq.prototype
w.a44=w.m})();(function installTearOffs(){var w=a._instance_0u,v=a._instance_1u
var u
w(u=B.FR.prototype,"gab7","ab8",0)
v(u,"gaaH","aaI",2)
v(u,"ga51","nl",3)
w(u,"gPh","xY",1)
w(u,"gIb","Ic",0)
w(u,"gI9","Ia",0)
w(u,"gasF","asG",0)
w(u=B.Gm.prototype,"ga6d","pp",1)
w(u,"gafj","yp",1)
w(u,"ga52","Mb",0)})();(function inheritance(){var w=a.mixinHard,v=a.inheritMany,u=a.inherit
v(A.T,[B.nR,B.Ak])
v(A.Z,[B.Jq,B.Gm])
u(B.FR,B.Jq)
v(A.fb,[B.aoi,B.aoh,B.aog,B.ao_,B.ao0,B.ao1,B.ao2,B.ao3,B.ao4,B.ao5,B.ao6,B.ao7,B.anX,B.anY,B.anZ,B.anV,B.anW,B.aob,B.aoa,B.aoc,B.aqF,B.aqG,B.aqB,B.aqD,B.aqC])
v(A.e0,[B.ao9,B.ao8,B.aoe,B.aqE])
v(A.fy,[B.aod,B.aof])
u(B.o7,A.np)
w(B.Jq,A.dJ)})()
A.ft(b.typeUniverse,JSON.parse('{"nR":{"T":[],"h":[]},"FR":{"Z":["nR"]},"Ak":{"T":[],"h":[]},"Gm":{"Z":["Ak"]}}'))
var y={b:"We just sent you an otp pls send it back to confirm your email. Please check your spam if it doesn't appear in your inbox"}
var x=(function rtii(){var w=A.U
return{S:w("ei"),y:w("il"),p:w("n<h>"),w:w("fE"),P:w("b4"),k:w("k5"),i:w("lr"),N:w("e"),t:w("az<Q>"),O:w("d0<e>"),g:w("nu"),v:w("O"),q:w("m"),X:w("D?"),T:w("e?"),H:w("~")}})();(function constants(){D.nf=new B.o7(0,"name")
D.ng=new B.o7(1,"email")
D.GM=new B.o7(2,"otp")
D.nh=new B.o7(3,"phoneNumber")
D.GN=new B.o7(4,"location")
D.fS=new B.o7(5,"multiline")
D.IM=new A.cH(57746,!1)})()};
((a,b)=>{a[b]=a.current
a.eventLog.push({p:"main.dart.js_15",e:"endPart",h:b})})($__dart_deferred_initializers__,"8RzhCEsbFSFA4zpW07NVy3LHlMo=");