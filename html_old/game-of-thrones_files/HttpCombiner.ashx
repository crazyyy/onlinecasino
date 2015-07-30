
function Genie()
{this.data={currentGUID:"",unusedGUID:"",stepId:"",casinoId:"",clientTypeId:"",browserLang:"",clientLang:"",btag:"",browser:"",os:"",ipAddress:"",flashPlayerVersion:null,alert:null,playerLoginName:null,regType:null,userIdentifier:null,playerStepInfo:"",statsNamespace:"",async:true};this.currentPlayerStep=null;this.validGuid=false;this.guidCreated=function(guid){}}
Genie.prototype.createGuid=function()
{var guid=GetCookie("pcmGuid");if(guid==null||guid=="")
{if(this.data.currentGUID=="")
{var params="csid="+escape(this.data.casinoId);params+="&clientType="+escape(this.data.clientTypeId);$.ajax({type:"POST",url:"PcmGuid.ashx",data:params,genie:this,success:function(data)
{if(data!="Err")
{SetCookie("pcmGuid",data,months*60);this.genie.validGuid=true;this.genie.data.currentGUID=data;var movref=$("#system")[0];if(movref!=null&&movref.updateExternalData)
{movref.focus();movref.updateExternalData({"pcmGUID":data});}
$.jSignal.emit(this.genie.guidCreated,data);if(this.genie.currentPlayerStep!=null)
{this.genie.currentPlayerStep.resetGuids({guid:this.genie.data.currentGUID});this.genie.currentPlayerStep.send();}}}});}
else
{SetCookie("pcmGuid",this.data.currentGUID,months*60);this.validGuid=true;$.jSignal.emit(this.guidCreated,this.data.currentGUID);}}
else
{this.validGuid=true;this.data.unusedGUID=this.data.currentGUID;this.data.currentGUID=guid;$.jSignal.emit(this.guidCreated,this.data.currentGUID);}}
Genie.prototype.getCurrentGuid=function()
{return this.data.currentGUID;}
Genie.prototype.cloneData=function()
{var clonedData={}
for(var s in this.data)
{clonedData[s]=this.data[s];}
return clonedData;}
Genie.prototype.playerStep=function(data)
{var playerStep=new GeniePlayerStep({data:data,controller:this});if(this.currentPlayerStep==null)
{this.currentPlayerStep=playerStep;if(this.validGuid)
{this.currentPlayerStep.send();}}
else
{this.currentPlayerStep.queue(playerStep);}}
Genie.prototype.stepComplete=function()
{this.currentPlayerStep=this.currentPlayerStep.next();if(this.currentPlayerStep!=null)
{this.currentPlayerStep.send();}}
function GeniePlayerStep(data)
{this.data=data.data;this.controller=data.controller;this.nextStep=null;}
GeniePlayerStep.prototype.resetGuids=function(data)
{this.data.currentGUID=(data.guid!=null)?data.guid:"";this.data.unusedGUID=(data.unusedGuid!=null)?data.unusedGuid:"";if(this.nextStep!=null)
{this.nextStep.resetGuids(data);}}
GeniePlayerStep.prototype.send=function()
{var params="StepId="+escape(this.data.stepId);params+="&CasinoId="+escape(this.data.casinoId);params+="&ClientTypeId="+escape(this.data.clientTypeId);params+="&PCMGUID="+escape(this.data.currentGUID);if(this.unusedGUID!="")
{params+="&UnusedPCMGUID="+escape(this.data.unusedGUID);}
params+="&BrowserLang="+escape(this.data.browserLang);params+="&ClientLang="+escape(this.data.clientLang);params+="&BTag="+escape(this.data.btag);params+="&IPAddress="+escape(this.data.ipAddress);if(this.data.alert!=null&&this.data.alert!="")
{params+="&Alert="+escape(this.data.alert);}
if(this.data.customStepDescription!=null&&this.data.customStepDescription!="")
{params+="&CustomStepDescription="+escape(this.data.customStepDescription);}
if(this.data.playerLoginName!=null&&this.data.playerLoginName!="")
{params+="&PlayerLoginName="+escape(this.data.playerLoginName);}
if(this.data.regType!=null&&this.data.regType.toString()!="")
{params+="&RegType="+escape(this.data.regType);}
if(this.data.userIdentifier!=null&&this.data.userIdentifier!="")
{params+="&UserIdentifier="+escape(this.data.userIdentifier);}
if(this.data.stepRef!=null&&this.data.stepRef!="")
{params+="&StepRef="+escape(this.data.stepRef);}
if(this.data.playerStepInfo!=null&&this.data.playerStepInfo!="")
{params+="&PlayerStepInfo="+this.data.playerStepInfo;}
if(this.data.statsNamespace!=null&&this.data.statsNamespace!="")
{params+="&statsNamespace="+this.data.statsNamespace;}
$.ajax({type:"POST",url:"Genie.ashx",data:params,cache:false,async:this.data.async,playerStep:this,success:function(data)
{this.playerStep.controller.stepComplete();}});}
GeniePlayerStep.prototype.queue=function(step)
{if(this.nextStep==null)
{this.nextStep=step;}
else
{this.nextStep.queue(step);}}
GeniePlayerStep.prototype.next=function()
{return this.nextStep;}
function onAttemptedActivation()
{if(genieObj!=null)
{var genieData=genieObj.cloneData();genieData.stepId=pcmSteps.attemptActivation.id;genieData.playerStepInfo="<custom><browser>"+genieData.browser+"</browser><os>"+genieData.os+"</os><flashplayer>"+genieData.flashPlayerVersion+"</flashplayer><referer>"+XmlEncodeString(document.referrer)+"</referer></custom>";if(siteSettings.faxControlAllowed)
{if(siteSettings.faxControlRequired&&FAX_UpToDate||siteSettings.fsControlRequired)
{genieData.regType=storageProxy.getValue("ID4");;}}
genieObj.playerStep(genieData);}}
function onFailedActivation(alert)
{if(genieObj!=null)
{var genieData=genieObj.cloneData();genieData.alert=alert;genieData.customStepDescription=alert;genieData.stepId=pcmSteps.failedActivation.id;genieObj.playerStep(genieData);}}
function onSuccessfullFlashActivation(data)
{if(genieObj!=null)
{var genieData=genieObj.cloneData();genieData.stepId=pcmSteps.successfullActivation.id;if(data.regType=="")
{if(siteSettings.faxControlAllowed)
{if(siteSettings.faxControlRequired&&FAX_UpToDate||siteSettings.fsControlRequired)
{genieData.regType=axProxy.getValue("ID4");}}}
else
{genieData.regType=data.regType;}
genieObj.playerStep(genieData);}}
function onSuccessfullLogin(data)
{if(genieObj!=null)
{var genieData=genieObj.cloneData();genieData.stepId=pcmSteps.successfullLogin.id;genieData.regType=data.regType;genieData.playerLoginName=data.playerLoginName;genieData.userIdentifier=data.userIdentifier;genieData.playerStepInfo="<custom><browser>"+genieData.browser+"</browser><os>"+XmlEncodeString(genieData.os)+"</os><flashplayer>"+genieData.flashPlayerVersion+"</flashplayer><performanceRating>"+XmlEncodeString(data.performanceRating)+"</performanceRating><gameid>"+data.gameid+"</gameid><avgspeed>"+data.avgspeed+"</avgspeed><userid>"+data.userid+"</userid><referer>"+XmlEncodeString(document.referrer)+"</referer></custom>";genieObj.playerStep(genieData);}}
function onFailedLogin(data)
{if(genieObj!=null)
{var genieData=genieObj.cloneData();genieData.stepId=pcmSteps.failedLogin.id;genieData.regType=data.regType;genieData.playerLoginName=data.playerLoginName;genieData.alert=data.alert+" (XMAN error code = "+data.xmancode+" | Server error code = "+data.servercode+")";genieObj.playerStep(genieData);}}
function onUserAccountLocked(data)
{if(genieObj!=null)
{var genieData=genieObj.cloneData();genieData.stepId=pcmSteps.userAccountLocked.id;genieData.regType=data.regType;genieData.userIdentifier=data.userIdentifier;genieData.playerLoginName=data.playerLoginName;genieData.alert=data.alert+" (XMAN error code = "+data.xmancode+" | Server error code = "+data.servercode+")";genieObj.playerStep(genieData);genieData.stepRef=data.servercode;}}
function onLoginWithMigration(data)
{if(genieObj!=null)
{var genieData=genieObj.cloneData();genieData.stepId=pcmSteps.loginWithMigrate.id;genieData.regType=data.regType;genieData.playerLoginName=data.playerLoginName;genieObj.playerStep(genieData);}}
function onMigrationAccountLogin(data)
{if(genieObj!=null)
{var genieData=genieObj.cloneData();genieData.stepId=pcmSteps.loginAfterMigrate.id;genieData.regType=data.regType;genieData.playerLoginName=data.playerLoginName;genieObj.playerStep(genieData);}}
function onTokenLoginSuccess(data)
{if(genieObj!=null)
{var genieData=genieObj.cloneData();genieData.stepId=pcmSteps.successfulTokenLogin.id;genieData.regType=data.regType;genieData.playerLoginName=data.playerLoginName;genieData.userIdentifier=data.userIdentifier;genieData.stepRef=data.userIdentifier+"||"+data.authtype;genieObj.playerStep(genieData);}}
function onTokenLoginFailure(data)
{if(genieObj!=null)
{var genieData=genieObj.cloneData();genieData.stepId=pcmSteps.failedTokenLogin.id;genieData.regType=data.regType;genieData.playerLoginName=data.playerLoginName;genieData.userIdentifier=data.userIdentifier;genieData.alert=data.alert+" (XMAN error code = "+data.xmancode+" | Server error code = "+data.servercode+")";genieData.stepRef=data.userIdentifier+"||"+data.authtype+"||Casino||"+data.servercode;genieObj.playerStep(genieData);}}
function onGenericTokenLoginEvent(data)
{if(genieObj!=null)
{var genieData=genieObj.cloneData();genieData.stepId=data.stepId;genieData.regType=data.regType;genieData.playerLoginName=data.playerLoginName;genieData.stepRef=data.stepRef;genieObj.playerStep(genieData);}}
function onPopupBlocked(name,notified)
{if(genieObj!=null)
{var genieData=genieObj.cloneData();genieData.stepId=pcmSteps.popupBlocked.id;genieData.stepRef="Popup Blocked||"+id+"||"+genieData.browser+"||"+genieData.os+"||"+(notified?"1":"0");genieObj.playerStep(genieData);}}
function onPopupBlockedDialogClosed(showAgain)
{if(genieObj!=null)
{var genieData=genieObj.cloneData();genieData.stepId=pcmSteps.popupWarning.id;genieData.stepRef="Popup Blocked Dialog||"+(showAgain?"1":"0");genieObj.playerStep(genieData);}}
function onPopupAllowed(id)
{if(genieObj!=null)
{var genieData=genieObj.cloneData();genieData.stepId=pcmSteps.popupSuccess.id;genieData.stepRef="Popup Allowed||"+id+"||"+genieData.browser+"||"+genieData.os;genieObj.playerStep(genieData);}}
function onUserDisconnected(data)
{if(genieObj!=null)
{var genieData=genieObj.cloneData();genieData.stepId=pcmSteps.userDisconnected.id;genieData.regType=data.regType;genieData.playerLoginName=data.playerLoginName;genieObj.playerStep(genieData);}}
function onUserTimedOut(data)
{if(genieObj!=null)
{var genieData=genieObj.cloneData();genieData.stepId=pcmSteps.userTimedOut.id;genieData.regType=data.regType;genieData.playerLoginName=data.playerLoginName;genieObj.playerStep(genieData);}}
function onLobbyStep(data)
{var genieData=genieObj.cloneData();genieData.stepId=data.stepID;genieData.stepRef=data.stepRef;genieObj.playerStep(genieData);}
function onGameDownloaded(data)
{if((pcmSteps.gameDownloaded.allow=="1")&&(genieObj!=null))
{var genieData=genieObj.cloneData();genieData.stepId=pcmSteps.gameDownloaded.id;genieData.stepRef=data.gameId+"|"+((new Date()).getTime()-genieObj.downloadStartTime);genieObj.playerStep(genieData);}}
function onGameInitialized(data)
{if((pcmSteps.gameInitialized.allow=="1")&&(genieObj!=null))
{genieObj.downloadStartTime=(new Date()).getTime();var genieData=genieObj.cloneData();genieData.stepId=pcmSteps.gameInitialized.id;genieData.stepRef=data.gameId;genieObj.playerStep(genieData);}}
function onGenericGenieStep(data)
{if(genieObj!=null)
{var genieData=genieObj.cloneData();for(var key in data)
{genieData[key]=data[key];}
genieObj.playerStep(genieData);}}
function onBrowserClose(sync)
{if(genieObj!=null)
{var genieData=genieObj.cloneData();genieData.stepId=pcmSteps.browserClosed.id;genieData.async=sync;genieObj.playerStep(genieData);}}
function onCacheDetection(data)
{if(genieObj!=null)
{var genieData=genieObj.cloneData();genieData.stepId=pcmSteps.cacheDetection.id;genieData.playerStepInfo="<custom><browser>"+genieData.browser+"</browser><os>"+XmlEncodeString(genieData.os)+"</os><flashplayer>"+genieData.flashPlayerVersion+"</flashplayer><cache>"+data.toString().toLowerCase()+"</cache></custom>";genieObj.playerStep(genieData);}}
(function(e,t){var n,r,i=typeof t,o=e.location,a=e.document,s=a.documentElement,l=e.jQuery,u=e.$,c={},p=[],f="1.10.2",d=p.concat,h=p.push,g=p.slice,m=p.indexOf,y=c.toString,v=c.hasOwnProperty,b=f.trim,x=function(e,t){return new x.fn.init(e,t,r)},w=/[+-]?(?:\d*\.|)\d+(?:[eE][+-]?\d+|)/.source,T=/\S+/g,C=/^[\s\uFEFF\xA0]+|[\s\uFEFF\xA0]+$/g,N=/^(?:\s*(<[\w\W]+>)[^>]*|#([\w-]*))$/,k=/^<(\w+)\s*\/?>(?:<\/\1>|)$/,E=/^[\],:{}\s]*$/,S=/(?:^|:|,)(?:\s*\[)+/g,A=/\\(?:["\\\/bfnrt]|u[\da-fA-F]{4})/g,j=/"[^"\\\r\n]*"|true|false|null|-?(?:\d+\.|)\d+(?:[eE][+-]?\d+|)/g,D=/^-ms-/,L=/-([\da-z])/gi,H=function(e,t){return t.toUpperCase()},q=function(e){(a.addEventListener||"load"===e.type||"complete"===a.readyState)&&(_(),x.ready())},_=function(){a.addEventListener?(a.removeEventListener("DOMContentLoaded",q,!1),e.removeEventListener("load",q,!1)):(a.detachEvent("onreadystatechange",q),e.detachEvent("onload",q))};x.fn=x.prototype={jquery:f,constructor:x,init:function(e,n,r){var i,o;if(!e)return this;if("string"==typeof e){if(i="<"===e.charAt(0)&&">"===e.charAt(e.length-1)&&e.length>=3?[null,e,null]:N.exec(e),!i||!i[1]&&n)return!n||n.jquery?(n||r).find(e):this.constructor(n).find(e);if(i[1]){if(n=n instanceof x?n[0]:n,x.merge(this,x.parseHTML(i[1],n&&n.nodeType?n.ownerDocument||n:a,!0)),k.test(i[1])&&x.isPlainObject(n))for(i in n)x.isFunction(this[i])?this[i](n[i]):this.attr(i,n[i]);return this}if(o=a.getElementById(i[2]),o&&o.parentNode){if(o.id!==i[2])return r.find(e);this.length=1,this[0]=o}return this.context=a,this.selector=e,this}return e.nodeType?(this.context=this[0]=e,this.length=1,this):x.isFunction(e)?r.ready(e):(e.selector!==t&&(this.selector=e.selector,this.context=e.context),x.makeArray(e,this))},selector:"",length:0,toArray:function(){return g.call(this)},get:function(e){return null==e?this.toArray():0>e?this[this.length+e]:this[e]},pushStack:function(e){var t=x.merge(this.constructor(),e);return t.prevObject=this,t.context=this.context,t},each:function(e,t){return x.each(this,e,t)},ready:function(e){return x.ready.promise().done(e),this},slice:function(){return this.pushStack(g.apply(this,arguments))},first:function(){return this.eq(0)},last:function(){return this.eq(-1)},eq:function(e){var t=this.length,n=+e+(0>e?t:0);return this.pushStack(n>=0&&t>n?[this[n]]:[])},map:function(e){return this.pushStack(x.map(this,function(t,n){return e.call(t,n,t)}))},end:function(){return this.prevObject||this.constructor(null)},push:h,sort:[].sort,splice:[].splice},x.fn.init.prototype=x.fn,x.extend=x.fn.extend=function(){var e,n,r,i,o,a,s=arguments[0]||{},l=1,u=arguments.length,c=!1;for("boolean"==typeof s&&(c=s,s=arguments[1]||{},l=2),"object"==typeof s||x.isFunction(s)||(s={}),u===l&&(s=this,--l);u>l;l++)if(null!=(o=arguments[l]))for(i in o)e=s[i],r=o[i],s!==r&&(c&&r&&(x.isPlainObject(r)||(n=x.isArray(r)))?(n?(n=!1,a=e&&x.isArray(e)?e:[]):a=e&&x.isPlainObject(e)?e:{},s[i]=x.extend(c,a,r)):r!==t&&(s[i]=r));return s},x.extend({expando:"jQuery"+(f+Math.random()).replace(/\D/g,""),noConflict:function(t){return e.$===x&&(e.$=u),t&&e.jQuery===x&&(e.jQuery=l),x},isReady:!1,readyWait:1,holdReady:function(e){e?x.readyWait++:x.ready(!0)},ready:function(e){if(e===!0?!--x.readyWait:!x.isReady){if(!a.body)return setTimeout(x.ready);x.isReady=!0,e!==!0&&--x.readyWait>0||(n.resolveWith(a,[x]),x.fn.trigger&&x(a).trigger("ready").off("ready"))}},isFunction:function(e){return"function"===x.type(e)},isArray:Array.isArray||function(e){return"array"===x.type(e)},isWindow:function(e){return null!=e&&e==e.window},isNumeric:function(e){return!isNaN(parseFloat(e))&&isFinite(e)},type:function(e){return null==e?e+"":"object"==typeof e||"function"==typeof e?c[y.call(e)]||"object":typeof e},isPlainObject:function(e){var n;if(!e||"object"!==x.type(e)||e.nodeType||x.isWindow(e))return!1;try{if(e.constructor&&!v.call(e,"constructor")&&!v.call(e.constructor.prototype,"isPrototypeOf"))return!1}catch(r){return!1}if(x.support.ownLast)for(n in e)return v.call(e,n);for(n in e);return n===t||v.call(e,n)},isEmptyObject:function(e){var t;for(t in e)return!1;return!0},error:function(e){throw Error(e)},parseHTML:function(e,t,n){if(!e||"string"!=typeof e)return null;"boolean"==typeof t&&(n=t,t=!1),t=t||a;var r=k.exec(e),i=!n&&[];return r?[t.createElement(r[1])]:(r=x.buildFragment([e],t,i),i&&x(i).remove(),x.merge([],r.childNodes))},parseJSON:function(n){return e.JSON&&e.JSON.parse?e.JSON.parse(n):null===n?n:"string"==typeof n&&(n=x.trim(n),n&&E.test(n.replace(A,"@").replace(j,"]").replace(S,"")))?Function("return "+n)():(x.error("Invalid JSON: "+n),t)},parseXML:function(n){var r,i;if(!n||"string"!=typeof n)return null;try{e.DOMParser?(i=new DOMParser,r=i.parseFromString(n,"text/xml")):(r=new ActiveXObject("Microsoft.XMLDOM"),r.async="false",r.loadXML(n))}catch(o){r=t}return r&&r.documentElement&&!r.getElementsByTagName("parsererror").length||x.error("Invalid XML: "+n),r},noop:function(){},globalEval:function(t){t&&x.trim(t)&&(e.execScript||function(t){e.eval.call(e,t)})(t)},camelCase:function(e){return e.replace(D,"ms-").replace(L,H)},nodeName:function(e,t){return e.nodeName&&e.nodeName.toLowerCase()===t.toLowerCase()},each:function(e,t,n){var r,i=0,o=e.length,a=M(e);if(n){if(a){for(;o>i;i++)if(r=t.apply(e[i],n),r===!1)break}else for(i in e)if(r=t.apply(e[i],n),r===!1)break}else if(a){for(;o>i;i++)if(r=t.call(e[i],i,e[i]),r===!1)break}else for(i in e)if(r=t.call(e[i],i,e[i]),r===!1)break;return e},trim:b&&!b.call("\ufeff\u00a0")?function(e){return null==e?"":b.call(e)}:function(e){return null==e?"":(e+"").replace(C,"")},makeArray:function(e,t){var n=t||[];return null!=e&&(M(Object(e))?x.merge(n,"string"==typeof e?[e]:e):h.call(n,e)),n},inArray:function(e,t,n){var r;if(t){if(m)return m.call(t,e,n);for(r=t.length,n=n?0>n?Math.max(0,r+n):n:0;r>n;n++)if(n in t&&t[n]===e)return n}return-1},merge:function(e,n){var r=n.length,i=e.length,o=0;if("number"==typeof r)for(;r>o;o++)e[i++]=n[o];else while(n[o]!==t)e[i++]=n[o++];return e.length=i,e},grep:function(e,t,n){var r,i=[],o=0,a=e.length;for(n=!!n;a>o;o++)r=!!t(e[o],o),n!==r&&i.push(e[o]);return i},map:function(e,t,n){var r,i=0,o=e.length,a=M(e),s=[];if(a)for(;o>i;i++)r=t(e[i],i,n),null!=r&&(s[s.length]=r);else for(i in e)r=t(e[i],i,n),null!=r&&(s[s.length]=r);return d.apply([],s)},guid:1,proxy:function(e,n){var r,i,o;return"string"==typeof n&&(o=e[n],n=e,e=o),x.isFunction(e)?(r=g.call(arguments,2),i=function(){return e.apply(n||this,r.concat(g.call(arguments)))},i.guid=e.guid=e.guid||x.guid++,i):t},access:function(e,n,r,i,o,a,s){var l=0,u=e.length,c=null==r;if("object"===x.type(r)){o=!0;for(l in r)x.access(e,n,l,r[l],!0,a,s)}else if(i!==t&&(o=!0,x.isFunction(i)||(s=!0),c&&(s?(n.call(e,i),n=null):(c=n,n=function(e,t,n){return c.call(x(e),n)})),n))for(;u>l;l++)n(e[l],r,s?i:i.call(e[l],l,n(e[l],r)));return o?e:c?n.call(e):u?n(e[0],r):a},now:function(){return(new Date).getTime()},swap:function(e,t,n,r){var i,o,a={};for(o in t)a[o]=e.style[o],e.style[o]=t[o];i=n.apply(e,r||[]);for(o in t)e.style[o]=a[o];return i}}),x.ready.promise=function(t){if(!n)if(n=x.Deferred(),"complete"===a.readyState)setTimeout(x.ready);else if(a.addEventListener)a.addEventListener("DOMContentLoaded",q,!1),e.addEventListener("load",q,!1);else{a.attachEvent("onreadystatechange",q),e.attachEvent("onload",q);var r=!1;try{r=null==e.frameElement&&a.documentElement}catch(i){}r&&r.doScroll&&function o(){if(!x.isReady){try{r.doScroll("left")}catch(e){return setTimeout(o,50)}_(),x.ready()}}()}return n.promise(t)},x.each("Boolean Number String Function Array Date RegExp Object Error".split(" "),function(e,t){c["[object "+t+"]"]=t.toLowerCase()});function M(e){var t=e.length,n=x.type(e);return x.isWindow(e)?!1:1===e.nodeType&&t?!0:"array"===n||"function"!==n&&(0===t||"number"==typeof t&&t>0&&t-1 in e)}r=x(a),function(e,t){var n,r,i,o,a,s,l,u,c,p,f,d,h,g,m,y,v,b="sizzle"+-new Date,w=e.document,T=0,C=0,N=st(),k=st(),E=st(),S=!1,A=function(e,t){return e===t?(S=!0,0):0},j=typeof t,D=1<<31,L={}.hasOwnProperty,H=[],q=H.pop,_=H.push,M=H.push,O=H.slice,F=H.indexOf||function(e){var t=0,n=this.length;for(;n>t;t++)if(this[t]===e)return t;return-1},B="checked|selected|async|autofocus|autoplay|controls|defer|disabled|hidden|ismap|loop|multiple|open|readonly|required|scoped",P="[\\x20\\t\\r\\n\\f]",R="(?:\\\\.|[\\w-]|[^\\x00-\\xa0])+",W=R.replace("w","w#"),$="\\["+P+"*("+R+")"+P+"*(?:([*^$|!~]?=)"+P+"*(?:(['\"])((?:\\\\.|[^\\\\])*?)\\3|("+W+")|)|)"+P+"*\\]",I=":("+R+")(?:\\(((['\"])((?:\\\\.|[^\\\\])*?)\\3|((?:\\\\.|[^\\\\()[\\]]|"+$.replace(3,8)+")*)|.*)\\)|)",z=RegExp("^"+P+"+|((?:^|[^\\\\])(?:\\\\.)*)"+P+"+$","g"),X=RegExp("^"+P+"*,"+P+"*"),U=RegExp("^"+P+"*([>+~]|"+P+")"+P+"*"),V=RegExp(P+"*[+~]"),Y=RegExp("="+P+"*([^\\]'\"]*)"+P+"*\\]","g"),J=RegExp(I),G=RegExp("^"+W+"$"),Q={ID:RegExp("^#("+R+")"),CLASS:RegExp("^\\.("+R+")"),TAG:RegExp("^("+R.replace("w","w*")+")"),ATTR:RegExp("^"+$),PSEUDO:RegExp("^"+I),CHILD:RegExp("^:(only|first|last|nth|nth-last)-(child|of-type)(?:\\("+P+"*(even|odd|(([+-]|)(\\d*)n|)"+P+"*(?:([+-]|)"+P+"*(\\d+)|))"+P+"*\\)|)","i"),bool:RegExp("^(?:"+B+")$","i"),needsContext:RegExp("^"+P+"*[>+~]|:(even|odd|eq|gt|lt|nth|first|last)(?:\\("+P+"*((?:-\\d)?\\d*)"+P+"*\\)|)(?=[^-]|$)","i")},K=/^[^{]+\{\s*\[native \w/,Z=/^(?:#([\w-]+)|(\w+)|\.([\w-]+))$/,et=/^(?:input|select|textarea|button)$/i,tt=/^h\d$/i,nt=/'|\\/g,rt=RegExp("\\\\([\\da-f]{1,6}"+P+"?|("+P+")|.)","ig"),it=function(e,t,n){var r="0x"+t-65536;return r!==r||n?t:0>r?String.fromCharCode(r+65536):String.fromCharCode(55296|r>>10,56320|1023&r)};try{M.apply(H=O.call(w.childNodes),w.childNodes),H[w.childNodes.length].nodeType}catch(ot){M={apply:H.length?function(e,t){_.apply(e,O.call(t))}:function(e,t){var n=e.length,r=0;while(e[n++]=t[r++]);e.length=n-1}}}function at(e,t,n,i){var o,a,s,l,u,c,d,m,y,x;if((t?t.ownerDocument||t:w)!==f&&p(t),t=t||f,n=n||[],!e||"string"!=typeof e)return n;if(1!==(l=t.nodeType)&&9!==l)return[];if(h&&!i){if(o=Z.exec(e))if(s=o[1]){if(9===l){if(a=t.getElementById(s),!a||!a.parentNode)return n;if(a.id===s)return n.push(a),n}else if(t.ownerDocument&&(a=t.ownerDocument.getElementById(s))&&v(t,a)&&a.id===s)return n.push(a),n}else{if(o[2])return M.apply(n,t.getElementsByTagName(e)),n;if((s=o[3])&&r.getElementsByClassName&&t.getElementsByClassName)return M.apply(n,t.getElementsByClassName(s)),n}if(r.qsa&&(!g||!g.test(e))){if(m=d=b,y=t,x=9===l&&e,1===l&&"object"!==t.nodeName.toLowerCase()){c=mt(e),(d=t.getAttribute("id"))?m=d.replace(nt,"\\$&"):t.setAttribute("id",m),m="[id='"+m+"'] ",u=c.length;while(u--)c[u]=m+yt(c[u]);y=V.test(e)&&t.parentNode||t,x=c.join(",")}if(x)try{return M.apply(n,y.querySelectorAll(x)),n}catch(T){}finally{d||t.removeAttribute("id")}}}return kt(e.replace(z,"$1"),t,n,i)}function st(){var e=[];function t(n,r){return e.push(n+=" ")>o.cacheLength&&delete t[e.shift()],t[n]=r}return t}function lt(e){return e[b]=!0,e}function ut(e){var t=f.createElement("div");try{return!!e(t)}catch(n){return!1}finally{t.parentNode&&t.parentNode.removeChild(t),t=null}}function ct(e,t){var n=e.split("|"),r=e.length;while(r--)o.attrHandle[n[r]]=t}function pt(e,t){var n=t&&e,r=n&&1===e.nodeType&&1===t.nodeType&&(~t.sourceIndex||D)-(~e.sourceIndex||D);if(r)return r;if(n)while(n=n.nextSibling)if(n===t)return-1;return e?1:-1}function ft(e){return function(t){var n=t.nodeName.toLowerCase();return"input"===n&&t.type===e}}function dt(e){return function(t){var n=t.nodeName.toLowerCase();return("input"===n||"button"===n)&&t.type===e}}function ht(e){return lt(function(t){return t=+t,lt(function(n,r){var i,o=e([],n.length,t),a=o.length;while(a--)n[i=o[a]]&&(n[i]=!(r[i]=n[i]))})})}s=at.isXML=function(e){var t=e&&(e.ownerDocument||e).documentElement;return t?"HTML"!==t.nodeName:!1},r=at.support={},p=at.setDocument=function(e){var n=e?e.ownerDocument||e:w,i=n.defaultView;return n!==f&&9===n.nodeType&&n.documentElement?(f=n,d=n.documentElement,h=!s(n),i&&i.attachEvent&&i!==i.top&&i.attachEvent("onbeforeunload",function(){p()}),r.attributes=ut(function(e){return e.className="i",!e.getAttribute("className")}),r.getElementsByTagName=ut(function(e){return e.appendChild(n.createComment("")),!e.getElementsByTagName("*").length}),r.getElementsByClassName=ut(function(e){return e.innerHTML="<div class='a'></div><div class='a i'></div>",e.firstChild.className="i",2===e.getElementsByClassName("i").length}),r.getById=ut(function(e){return d.appendChild(e).id=b,!n.getElementsByName||!n.getElementsByName(b).length}),r.getById?(o.find.ID=function(e,t){if(typeof t.getElementById!==j&&h){var n=t.getElementById(e);return n&&n.parentNode?[n]:[]}},o.filter.ID=function(e){var t=e.replace(rt,it);return function(e){return e.getAttribute("id")===t}}):(delete o.find.ID,o.filter.ID=function(e){var t=e.replace(rt,it);return function(e){var n=typeof e.getAttributeNode!==j&&e.getAttributeNode("id");return n&&n.value===t}}),o.find.TAG=r.getElementsByTagName?function(e,n){return typeof n.getElementsByTagName!==j?n.getElementsByTagName(e):t}:function(e,t){var n,r=[],i=0,o=t.getElementsByTagName(e);if("*"===e){while(n=o[i++])1===n.nodeType&&r.push(n);return r}return o},o.find.CLASS=r.getElementsByClassName&&function(e,n){return typeof n.getElementsByClassName!==j&&h?n.getElementsByClassName(e):t},m=[],g=[],(r.qsa=K.test(n.querySelectorAll))&&(ut(function(e){e.innerHTML="<select><option selected=''></option></select>",e.querySelectorAll("[selected]").length||g.push("\\["+P+"*(?:value|"+B+")"),e.querySelectorAll(":checked").length||g.push(":checked")}),ut(function(e){var t=n.createElement("input");t.setAttribute("type","hidden"),e.appendChild(t).setAttribute("t",""),e.querySelectorAll("[t^='']").length&&g.push("[*^$]="+P+"*(?:''|\"\")"),e.querySelectorAll(":enabled").length||g.push(":enabled",":disabled"),e.querySelectorAll("*,:x"),g.push(",.*:")})),(r.matchesSelector=K.test(y=d.webkitMatchesSelector||d.mozMatchesSelector||d.oMatchesSelector||d.msMatchesSelector))&&ut(function(e){r.disconnectedMatch=y.call(e,"div"),y.call(e,"[s!='']:x"),m.push("!=",I)}),g=g.length&&RegExp(g.join("|")),m=m.length&&RegExp(m.join("|")),v=K.test(d.contains)||d.compareDocumentPosition?function(e,t){var n=9===e.nodeType?e.documentElement:e,r=t&&t.parentNode;return e===r||!(!r||1!==r.nodeType||!(n.contains?n.contains(r):e.compareDocumentPosition&&16&e.compareDocumentPosition(r)))}:function(e,t){if(t)while(t=t.parentNode)if(t===e)return!0;return!1},A=d.compareDocumentPosition?function(e,t){if(e===t)return S=!0,0;var i=t.compareDocumentPosition&&e.compareDocumentPosition&&e.compareDocumentPosition(t);return i?1&i||!r.sortDetached&&t.compareDocumentPosition(e)===i?e===n||v(w,e)?-1:t===n||v(w,t)?1:c?F.call(c,e)-F.call(c,t):0:4&i?-1:1:e.compareDocumentPosition?-1:1}:function(e,t){var r,i=0,o=e.parentNode,a=t.parentNode,s=[e],l=[t];if(e===t)return S=!0,0;if(!o||!a)return e===n?-1:t===n?1:o?-1:a?1:c?F.call(c,e)-F.call(c,t):0;if(o===a)return pt(e,t);r=e;while(r=r.parentNode)s.unshift(r);r=t;while(r=r.parentNode)l.unshift(r);while(s[i]===l[i])i++;return i?pt(s[i],l[i]):s[i]===w?-1:l[i]===w?1:0},n):f},at.matches=function(e,t){return at(e,null,null,t)},at.matchesSelector=function(e,t){if((e.ownerDocument||e)!==f&&p(e),t=t.replace(Y,"='$1']"),!(!r.matchesSelector||!h||m&&m.test(t)||g&&g.test(t)))try{var n=y.call(e,t);if(n||r.disconnectedMatch||e.document&&11!==e.document.nodeType)return n}catch(i){}return at(t,f,null,[e]).length>0},at.contains=function(e,t){return(e.ownerDocument||e)!==f&&p(e),v(e,t)},at.attr=function(e,n){(e.ownerDocument||e)!==f&&p(e);var i=o.attrHandle[n.toLowerCase()],a=i&&L.call(o.attrHandle,n.toLowerCase())?i(e,n,!h):t;return a===t?r.attributes||!h?e.getAttribute(n):(a=e.getAttributeNode(n))&&a.specified?a.value:null:a},at.error=function(e){throw Error("Syntax error, unrecognized expression: "+e)},at.uniqueSort=function(e){var t,n=[],i=0,o=0;if(S=!r.detectDuplicates,c=!r.sortStable&&e.slice(0),e.sort(A),S){while(t=e[o++])t===e[o]&&(i=n.push(o));while(i--)e.splice(n[i],1)}return e},a=at.getText=function(e){var t,n="",r=0,i=e.nodeType;if(i){if(1===i||9===i||11===i){if("string"==typeof e.textContent)return e.textContent;for(e=e.firstChild;e;e=e.nextSibling)n+=a(e)}else if(3===i||4===i)return e.nodeValue}else for(;t=e[r];r++)n+=a(t);return n},o=at.selectors={cacheLength:50,createPseudo:lt,match:Q,attrHandle:{},find:{},relative:{">":{dir:"parentNode",first:!0}," ":{dir:"parentNode"},"+":{dir:"previousSibling",first:!0},"~":{dir:"previousSibling"}},preFilter:{ATTR:function(e){return e[1]=e[1].replace(rt,it),e[3]=(e[4]||e[5]||"").replace(rt,it),"~="===e[2]&&(e[3]=" "+e[3]+" "),e.slice(0,4)},CHILD:function(e){return e[1]=e[1].toLowerCase(),"nth"===e[1].slice(0,3)?(e[3]||at.error(e[0]),e[4]=+(e[4]?e[5]+(e[6]||1):2*("even"===e[3]||"odd"===e[3])),e[5]=+(e[7]+e[8]||"odd"===e[3])):e[3]&&at.error(e[0]),e},PSEUDO:function(e){var n,r=!e[5]&&e[2];return Q.CHILD.test(e[0])?null:(e[3]&&e[4]!==t?e[2]=e[4]:r&&J.test(r)&&(n=mt(r,!0))&&(n=r.indexOf(")",r.length-n)-r.length)&&(e[0]=e[0].slice(0,n),e[2]=r.slice(0,n)),e.slice(0,3))}},filter:{TAG:function(e){var t=e.replace(rt,it).toLowerCase();return"*"===e?function(){return!0}:function(e){return e.nodeName&&e.nodeName.toLowerCase()===t}},CLASS:function(e){var t=N[e+" "];return t||(t=RegExp("(^|"+P+")"+e+"("+P+"|$)"))&&N(e,function(e){return t.test("string"==typeof e.className&&e.className||typeof e.getAttribute!==j&&e.getAttribute("class")||"")})},ATTR:function(e,t,n){return function(r){var i=at.attr(r,e);return null==i?"!="===t:t?(i+="","="===t?i===n:"!="===t?i!==n:"^="===t?n&&0===i.indexOf(n):"*="===t?n&&i.indexOf(n)>-1:"$="===t?n&&i.slice(-n.length)===n:"~="===t?(" "+i+" ").indexOf(n)>-1:"|="===t?i===n||i.slice(0,n.length+1)===n+"-":!1):!0}},CHILD:function(e,t,n,r,i){var o="nth"!==e.slice(0,3),a="last"!==e.slice(-4),s="of-type"===t;return 1===r&&0===i?function(e){return!!e.parentNode}:function(t,n,l){var u,c,p,f,d,h,g=o!==a?"nextSibling":"previousSibling",m=t.parentNode,y=s&&t.nodeName.toLowerCase(),v=!l&&!s;if(m){if(o){while(g){p=t;while(p=p[g])if(s?p.nodeName.toLowerCase()===y:1===p.nodeType)return!1;h=g="only"===e&&!h&&"nextSibling"}return!0}if(h=[a?m.firstChild:m.lastChild],a&&v){c=m[b]||(m[b]={}),u=c[e]||[],d=u[0]===T&&u[1],f=u[0]===T&&u[2],p=d&&m.childNodes[d];while(p=++d&&p&&p[g]||(f=d=0)||h.pop())if(1===p.nodeType&&++f&&p===t){c[e]=[T,d,f];break}}else if(v&&(u=(t[b]||(t[b]={}))[e])&&u[0]===T)f=u[1];else while(p=++d&&p&&p[g]||(f=d=0)||h.pop())if((s?p.nodeName.toLowerCase()===y:1===p.nodeType)&&++f&&(v&&((p[b]||(p[b]={}))[e]=[T,f]),p===t))break;return f-=i,f===r||0===f%r&&f/r>=0}}},PSEUDO:function(e,t){var n,r=o.pseudos[e]||o.setFilters[e.toLowerCase()]||at.error("unsupported pseudo: "+e);return r[b]?r(t):r.length>1?(n=[e,e,"",t],o.setFilters.hasOwnProperty(e.toLowerCase())?lt(function(e,n){var i,o=r(e,t),a=o.length;while(a--)i=F.call(e,o[a]),e[i]=!(n[i]=o[a])}):function(e){return r(e,0,n)}):r}},pseudos:{not:lt(function(e){var t=[],n=[],r=l(e.replace(z,"$1"));return r[b]?lt(function(e,t,n,i){var o,a=r(e,null,i,[]),s=e.length;while(s--)(o=a[s])&&(e[s]=!(t[s]=o))}):function(e,i,o){return t[0]=e,r(t,null,o,n),!n.pop()}}),has:lt(function(e){return function(t){return at(e,t).length>0}}),contains:lt(function(e){return function(t){return(t.textContent||t.innerText||a(t)).indexOf(e)>-1}}),lang:lt(function(e){return G.test(e||"")||at.error("unsupported lang: "+e),e=e.replace(rt,it).toLowerCase(),function(t){var n;do if(n=h?t.lang:t.getAttribute("xml:lang")||t.getAttribute("lang"))return n=n.toLowerCase(),n===e||0===n.indexOf(e+"-");while((t=t.parentNode)&&1===t.nodeType);return!1}}),target:function(t){var n=e.location&&e.location.hash;return n&&n.slice(1)===t.id},root:function(e){return e===d},focus:function(e){return e===f.activeElement&&(!f.hasFocus||f.hasFocus())&&!!(e.type||e.href||~e.tabIndex)},enabled:function(e){return e.disabled===!1},disabled:function(e){return e.disabled===!0},checked:function(e){var t=e.nodeName.toLowerCase();return"input"===t&&!!e.checked||"option"===t&&!!e.selected},selected:function(e){return e.parentNode&&e.parentNode.selectedIndex,e.selected===!0},empty:function(e){for(e=e.firstChild;e;e=e.nextSibling)if(e.nodeName>"@"||3===e.nodeType||4===e.nodeType)return!1;return!0},parent:function(e){return!o.pseudos.empty(e)},header:function(e){return tt.test(e.nodeName)},input:function(e){return et.test(e.nodeName)},button:function(e){var t=e.nodeName.toLowerCase();return"input"===t&&"button"===e.type||"button"===t},text:function(e){var t;return"input"===e.nodeName.toLowerCase()&&"text"===e.type&&(null==(t=e.getAttribute("type"))||t.toLowerCase()===e.type)},first:ht(function(){return[0]}),last:ht(function(e,t){return[t-1]}),eq:ht(function(e,t,n){return[0>n?n+t:n]}),even:ht(function(e,t){var n=0;for(;t>n;n+=2)e.push(n);return e}),odd:ht(function(e,t){var n=1;for(;t>n;n+=2)e.push(n);return e}),lt:ht(function(e,t,n){var r=0>n?n+t:n;for(;--r>=0;)e.push(r);return e}),gt:ht(function(e,t,n){var r=0>n?n+t:n;for(;t>++r;)e.push(r);return e})}},o.pseudos.nth=o.pseudos.eq;for(n in{radio:!0,checkbox:!0,file:!0,password:!0,image:!0})o.pseudos[n]=ft(n);for(n in{submit:!0,reset:!0})o.pseudos[n]=dt(n);function gt(){}gt.prototype=o.filters=o.pseudos,o.setFilters=new gt;function mt(e,t){var n,r,i,a,s,l,u,c=k[e+" "];if(c)return t?0:c.slice(0);s=e,l=[],u=o.preFilter;while(s){(!n||(r=X.exec(s)))&&(r&&(s=s.slice(r[0].length)||s),l.push(i=[])),n=!1,(r=U.exec(s))&&(n=r.shift(),i.push({value:n,type:r[0].replace(z," ")}),s=s.slice(n.length));for(a in o.filter)!(r=Q[a].exec(s))||u[a]&&!(r=u[a](r))||(n=r.shift(),i.push({value:n,type:a,matches:r}),s=s.slice(n.length));if(!n)break}return t?s.length:s?at.error(e):k(e,l).slice(0)}function yt(e){var t=0,n=e.length,r="";for(;n>t;t++)r+=e[t].value;return r}function vt(e,t,n){var r=t.dir,o=n&&"parentNode"===r,a=C++;return t.first?function(t,n,i){while(t=t[r])if(1===t.nodeType||o)return e(t,n,i)}:function(t,n,s){var l,u,c,p=T+" "+a;if(s){while(t=t[r])if((1===t.nodeType||o)&&e(t,n,s))return!0}else while(t=t[r])if(1===t.nodeType||o)if(c=t[b]||(t[b]={}),(u=c[r])&&u[0]===p){if((l=u[1])===!0||l===i)return l===!0}else if(u=c[r]=[p],u[1]=e(t,n,s)||i,u[1]===!0)return!0}}function bt(e){return e.length>1?function(t,n,r){var i=e.length;while(i--)if(!e[i](t,n,r))return!1;return!0}:e[0]}function xt(e,t,n,r,i){var o,a=[],s=0,l=e.length,u=null!=t;for(;l>s;s++)(o=e[s])&&(!n||n(o,r,i))&&(a.push(o),u&&t.push(s));return a}function wt(e,t,n,r,i,o){return r&&!r[b]&&(r=wt(r)),i&&!i[b]&&(i=wt(i,o)),lt(function(o,a,s,l){var u,c,p,f=[],d=[],h=a.length,g=o||Nt(t||"*",s.nodeType?[s]:s,[]),m=!e||!o&&t?g:xt(g,f,e,s,l),y=n?i||(o?e:h||r)?[]:a:m;if(n&&n(m,y,s,l),r){u=xt(y,d),r(u,[],s,l),c=u.length;while(c--)(p=u[c])&&(y[d[c]]=!(m[d[c]]=p))}if(o){if(i||e){if(i){u=[],c=y.length;while(c--)(p=y[c])&&u.push(m[c]=p);i(null,y=[],u,l)}c=y.length;while(c--)(p=y[c])&&(u=i?F.call(o,p):f[c])>-1&&(o[u]=!(a[u]=p))}}else y=xt(y===a?y.splice(h,y.length):y),i?i(null,a,y,l):M.apply(a,y)})}function Tt(e){var t,n,r,i=e.length,a=o.relative[e[0].type],s=a||o.relative[" "],l=a?1:0,c=vt(function(e){return e===t},s,!0),p=vt(function(e){return F.call(t,e)>-1},s,!0),f=[function(e,n,r){return!a&&(r||n!==u)||((t=n).nodeType?c(e,n,r):p(e,n,r))}];for(;i>l;l++)if(n=o.relative[e[l].type])f=[vt(bt(f),n)];else{if(n=o.filter[e[l].type].apply(null,e[l].matches),n[b]){for(r=++l;i>r;r++)if(o.relative[e[r].type])break;return wt(l>1&&bt(f),l>1&&yt(e.slice(0,l-1).concat({value:" "===e[l-2].type?"*":""})).replace(z,"$1"),n,r>l&&Tt(e.slice(l,r)),i>r&&Tt(e=e.slice(r)),i>r&&yt(e))}f.push(n)}return bt(f)}function Ct(e,t){var n=0,r=t.length>0,a=e.length>0,s=function(s,l,c,p,d){var h,g,m,y=[],v=0,b="0",x=s&&[],w=null!=d,C=u,N=s||a&&o.find.TAG("*",d&&l.parentNode||l),k=T+=null==C?1:Math.random()||.1;for(w&&(u=l!==f&&l,i=n);null!=(h=N[b]);b++){if(a&&h){g=0;while(m=e[g++])if(m(h,l,c)){p.push(h);break}w&&(T=k,i=++n)}r&&((h=!m&&h)&&v--,s&&x.push(h))}if(v+=b,r&&b!==v){g=0;while(m=t[g++])m(x,y,l,c);if(s){if(v>0)while(b--)x[b]||y[b]||(y[b]=q.call(p));y=xt(y)}M.apply(p,y),w&&!s&&y.length>0&&v+t.length>1&&at.uniqueSort(p)}return w&&(T=k,u=C),x};return r?lt(s):s}l=at.compile=function(e,t){var n,r=[],i=[],o=E[e+" "];if(!o){t||(t=mt(e)),n=t.length;while(n--)o=Tt(t[n]),o[b]?r.push(o):i.push(o);o=E(e,Ct(i,r))}return o};function Nt(e,t,n){var r=0,i=t.length;for(;i>r;r++)at(e,t[r],n);return n}function kt(e,t,n,i){var a,s,u,c,p,f=mt(e);if(!i&&1===f.length){if(s=f[0]=f[0].slice(0),s.length>2&&"ID"===(u=s[0]).type&&r.getById&&9===t.nodeType&&h&&o.relative[s[1].type]){if(t=(o.find.ID(u.matches[0].replace(rt,it),t)||[])[0],!t)return n;e=e.slice(s.shift().value.length)}a=Q.needsContext.test(e)?0:s.length;while(a--){if(u=s[a],o.relative[c=u.type])break;if((p=o.find[c])&&(i=p(u.matches[0].replace(rt,it),V.test(s[0].type)&&t.parentNode||t))){if(s.splice(a,1),e=i.length&&yt(s),!e)return M.apply(n,i),n;break}}}return l(e,f)(i,t,!h,n,V.test(e)),n}r.sortStable=b.split("").sort(A).join("")===b,r.detectDuplicates=S,p(),r.sortDetached=ut(function(e){return 1&e.compareDocumentPosition(f.createElement("div"))}),ut(function(e){return e.innerHTML="<a href='#'></a>","#"===e.firstChild.getAttribute("href")})||ct("type|href|height|width",function(e,n,r){return r?t:e.getAttribute(n,"type"===n.toLowerCase()?1:2)}),r.attributes&&ut(function(e){return e.innerHTML="<input/>",e.firstChild.setAttribute("value",""),""===e.firstChild.getAttribute("value")})||ct("value",function(e,n,r){return r||"input"!==e.nodeName.toLowerCase()?t:e.defaultValue}),ut(function(e){return null==e.getAttribute("disabled")})||ct(B,function(e,n,r){var i;return r?t:(i=e.getAttributeNode(n))&&i.specified?i.value:e[n]===!0?n.toLowerCase():null}),x.find=at,x.expr=at.selectors,x.expr[":"]=x.expr.pseudos,x.unique=at.uniqueSort,x.text=at.getText,x.isXMLDoc=at.isXML,x.contains=at.contains}(e);var O={};function F(e){var t=O[e]={};return x.each(e.match(T)||[],function(e,n){t[n]=!0}),t}x.Callbacks=function(e){e="string"==typeof e?O[e]||F(e):x.extend({},e);var n,r,i,o,a,s,l=[],u=!e.once&&[],c=function(t){for(r=e.memory&&t,i=!0,a=s||0,s=0,o=l.length,n=!0;l&&o>a;a++)if(l[a].apply(t[0],t[1])===!1&&e.stopOnFalse){r=!1;break}n=!1,l&&(u?u.length&&c(u.shift()):r?l=[]:p.disable())},p={add:function(){if(l){var t=l.length;(function i(t){x.each(t,function(t,n){var r=x.type(n);"function"===r?e.unique&&p.has(n)||l.push(n):n&&n.length&&"string"!==r&&i(n)})})(arguments),n?o=l.length:r&&(s=t,c(r))}return this},remove:function(){return l&&x.each(arguments,function(e,t){var r;while((r=x.inArray(t,l,r))>-1)l.splice(r,1),n&&(o>=r&&o--,a>=r&&a--)}),this},has:function(e){return e?x.inArray(e,l)>-1:!(!l||!l.length)},empty:function(){return l=[],o=0,this},disable:function(){return l=u=r=t,this},disabled:function(){return!l},lock:function(){return u=t,r||p.disable(),this},locked:function(){return!u},fireWith:function(e,t){return!l||i&&!u||(t=t||[],t=[e,t.slice?t.slice():t],n?u.push(t):c(t)),this},fire:function(){return p.fireWith(this,arguments),this},fired:function(){return!!i}};return p},x.extend({Deferred:function(e){var t=[["resolve","done",x.Callbacks("once memory"),"resolved"],["reject","fail",x.Callbacks("once memory"),"rejected"],["notify","progress",x.Callbacks("memory")]],n="pending",r={state:function(){return n},always:function(){return i.done(arguments).fail(arguments),this},then:function(){var e=arguments;return x.Deferred(function(n){x.each(t,function(t,o){var a=o[0],s=x.isFunction(e[t])&&e[t];i[o[1]](function(){var e=s&&s.apply(this,arguments);e&&x.isFunction(e.promise)?e.promise().done(n.resolve).fail(n.reject).progress(n.notify):n[a+"With"](this===r?n.promise():this,s?[e]:arguments)})}),e=null}).promise()},promise:function(e){return null!=e?x.extend(e,r):r}},i={};return r.pipe=r.then,x.each(t,function(e,o){var a=o[2],s=o[3];r[o[1]]=a.add,s&&a.add(function(){n=s},t[1^e][2].disable,t[2][2].lock),i[o[0]]=function(){return i[o[0]+"With"](this===i?r:this,arguments),this},i[o[0]+"With"]=a.fireWith}),r.promise(i),e&&e.call(i,i),i},when:function(e){var t=0,n=g.call(arguments),r=n.length,i=1!==r||e&&x.isFunction(e.promise)?r:0,o=1===i?e:x.Deferred(),a=function(e,t,n){return function(r){t[e]=this,n[e]=arguments.length>1?g.call(arguments):r,n===s?o.notifyWith(t,n):--i||o.resolveWith(t,n)}},s,l,u;if(r>1)for(s=Array(r),l=Array(r),u=Array(r);r>t;t++)n[t]&&x.isFunction(n[t].promise)?n[t].promise().done(a(t,u,n)).fail(o.reject).progress(a(t,l,s)):--i;return i||o.resolveWith(u,n),o.promise()}}),x.support=function(t){var n,r,o,s,l,u,c,p,f,d=a.createElement("div");if(d.setAttribute("className","t"),d.innerHTML="  <link/><table></table><a href='/a'>a</a><input type='checkbox'/>",n=d.getElementsByTagName("*")||[],r=d.getElementsByTagName("a")[0],!r||!r.style||!n.length)return t;s=a.createElement("select"),u=s.appendChild(a.createElement("option")),o=d.getElementsByTagName("input")[0],r.style.cssText="top:1px;float:left;opacity:.5",t.getSetAttribute="t"!==d.className,t.leadingWhitespace=3===d.firstChild.nodeType,t.tbody=!d.getElementsByTagName("tbody").length,t.htmlSerialize=!!d.getElementsByTagName("link").length,t.style=/top/.test(r.getAttribute("style")),t.hrefNormalized="/a"===r.getAttribute("href"),t.opacity=/^0.5/.test(r.style.opacity),t.cssFloat=!!r.style.cssFloat,t.checkOn=!!o.value,t.optSelected=u.selected,t.enctype=!!a.createElement("form").enctype,t.html5Clone="<:nav></:nav>"!==a.createElement("nav").cloneNode(!0).outerHTML,t.inlineBlockNeedsLayout=!1,t.shrinkWrapBlocks=!1,t.pixelPosition=!1,t.deleteExpando=!0,t.noCloneEvent=!0,t.reliableMarginRight=!0,t.boxSizingReliable=!0,o.checked=!0,t.noCloneChecked=o.cloneNode(!0).checked,s.disabled=!0,t.optDisabled=!u.disabled;try{delete d.test}catch(h){t.deleteExpando=!1}o=a.createElement("input"),o.setAttribute("value",""),t.input=""===o.getAttribute("value"),o.value="t",o.setAttribute("type","radio"),t.radioValue="t"===o.value,o.setAttribute("checked","t"),o.setAttribute("name","t"),l=a.createDocumentFragment(),l.appendChild(o),t.appendChecked=o.checked,t.checkClone=l.cloneNode(!0).cloneNode(!0).lastChild.checked,d.attachEvent&&(d.attachEvent("onclick",function(){t.noCloneEvent=!1}),d.cloneNode(!0).click());for(f in{submit:!0,change:!0,focusin:!0})d.setAttribute(c="on"+f,"t"),t[f+"Bubbles"]=c in e||d.attributes[c].expando===!1;d.style.backgroundClip="content-box",d.cloneNode(!0).style.backgroundClip="",t.clearCloneStyle="content-box"===d.style.backgroundClip;for(f in x(t))break;return t.ownLast="0"!==f,x(function(){var n,r,o,s="padding:0;margin:0;border:0;display:block;box-sizing:content-box;-moz-box-sizing:content-box;-webkit-box-sizing:content-box;",l=a.getElementsByTagName("body")[0];l&&(n=a.createElement("div"),n.style.cssText="border:0;width:0;height:0;position:absolute;top:0;left:-9999px;margin-top:1px",l.appendChild(n).appendChild(d),d.innerHTML="<table><tr><td></td><td>t</td></tr></table>",o=d.getElementsByTagName("td"),o[0].style.cssText="padding:0;margin:0;border:0;display:none",p=0===o[0].offsetHeight,o[0].style.display="",o[1].style.display="none",t.reliableHiddenOffsets=p&&0===o[0].offsetHeight,d.innerHTML="",d.style.cssText="box-sizing:border-box;-moz-box-sizing:border-box;-webkit-box-sizing:border-box;padding:1px;border:1px;display:block;width:4px;margin-top:1%;position:absolute;top:1%;",x.swap(l,null!=l.style.zoom?{zoom:1}:{},function(){t.boxSizing=4===d.offsetWidth}),e.getComputedStyle&&(t.pixelPosition="1%"!==(e.getComputedStyle(d,null)||{}).top,t.boxSizingReliable="4px"===(e.getComputedStyle(d,null)||{width:"4px"}).width,r=d.appendChild(a.createElement("div")),r.style.cssText=d.style.cssText=s,r.style.marginRight=r.style.width="0",d.style.width="1px",t.reliableMarginRight=!parseFloat((e.getComputedStyle(r,null)||{}).marginRight)),typeof d.style.zoom!==i&&(d.innerHTML="",d.style.cssText=s+"width:1px;padding:1px;display:inline;zoom:1",t.inlineBlockNeedsLayout=3===d.offsetWidth,d.style.display="block",d.innerHTML="<div></div>",d.firstChild.style.width="5px",t.shrinkWrapBlocks=3!==d.offsetWidth,t.inlineBlockNeedsLayout&&(l.style.zoom=1)),l.removeChild(n),n=d=o=r=null)}),n=s=l=u=r=o=null,t}({});var B=/(?:\{[\s\S]*\}|\[[\s\S]*\])$/,P=/([A-Z])/g;function R(e,n,r,i){if(x.acceptData(e)){var o,a,s=x.expando,l=e.nodeType,u=l?x.cache:e,c=l?e[s]:e[s]&&s;if(c&&u[c]&&(i||u[c].data)||r!==t||"string"!=typeof n)return c||(c=l?e[s]=p.pop()||x.guid++:s),u[c]||(u[c]=l?{}:{toJSON:x.noop}),("object"==typeof n||"function"==typeof n)&&(i?u[c]=x.extend(u[c],n):u[c].data=x.extend(u[c].data,n)),a=u[c],i||(a.data||(a.data={}),a=a.data),r!==t&&(a[x.camelCase(n)]=r),"string"==typeof n?(o=a[n],null==o&&(o=a[x.camelCase(n)])):o=a,o}}function W(e,t,n){if(x.acceptData(e)){var r,i,o=e.nodeType,a=o?x.cache:e,s=o?e[x.expando]:x.expando;if(a[s]){if(t&&(r=n?a[s]:a[s].data)){x.isArray(t)?t=t.concat(x.map(t,x.camelCase)):t in r?t=[t]:(t=x.camelCase(t),t=t in r?[t]:t.split(" ")),i=t.length;while(i--)delete r[t[i]];if(n?!I(r):!x.isEmptyObject(r))return}(n||(delete a[s].data,I(a[s])))&&(o?x.cleanData([e],!0):x.support.deleteExpando||a!=a.window?delete a[s]:a[s]=null)}}}x.extend({cache:{},noData:{applet:!0,embed:!0,object:"clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"},hasData:function(e){return e=e.nodeType?x.cache[e[x.expando]]:e[x.expando],!!e&&!I(e)},data:function(e,t,n){return R(e,t,n)},removeData:function(e,t){return W(e,t)},_data:function(e,t,n){return R(e,t,n,!0)},_removeData:function(e,t){return W(e,t,!0)},acceptData:function(e){if(e.nodeType&&1!==e.nodeType&&9!==e.nodeType)return!1;var t=e.nodeName&&x.noData[e.nodeName.toLowerCase()];return!t||t!==!0&&e.getAttribute("classid")===t}}),x.fn.extend({data:function(e,n){var r,i,o=null,a=0,s=this[0];if(e===t){if(this.length&&(o=x.data(s),1===s.nodeType&&!x._data(s,"parsedAttrs"))){for(r=s.attributes;r.length>a;a++)i=r[a].name,0===i.indexOf("data-")&&(i=x.camelCase(i.slice(5)),$(s,i,o[i]));x._data(s,"parsedAttrs",!0)}return o}return"object"==typeof e?this.each(function(){x.data(this,e)}):arguments.length>1?this.each(function(){x.data(this,e,n)}):s?$(s,e,x.data(s,e)):null},removeData:function(e){return this.each(function(){x.removeData(this,e)})}});function $(e,n,r){if(r===t&&1===e.nodeType){var i="data-"+n.replace(P,"-$1").toLowerCase();if(r=e.getAttribute(i),"string"==typeof r){try{r="true"===r?!0:"false"===r?!1:"null"===r?null:+r+""===r?+r:B.test(r)?x.parseJSON(r):r}catch(o){}x.data(e,n,r)}else r=t}return r}function I(e){var t;for(t in e)if(("data"!==t||!x.isEmptyObject(e[t]))&&"toJSON"!==t)return!1;return!0}x.extend({queue:function(e,n,r){var i;return e?(n=(n||"fx")+"queue",i=x._data(e,n),r&&(!i||x.isArray(r)?i=x._data(e,n,x.makeArray(r)):i.push(r)),i||[]):t},dequeue:function(e,t){t=t||"fx";var n=x.queue(e,t),r=n.length,i=n.shift(),o=x._queueHooks(e,t),a=function(){x.dequeue(e,t)};"inprogress"===i&&(i=n.shift(),r--),i&&("fx"===t&&n.unshift("inprogress"),delete o.stop,i.call(e,a,o)),!r&&o&&o.empty.fire()},_queueHooks:function(e,t){var n=t+"queueHooks";return x._data(e,n)||x._data(e,n,{empty:x.Callbacks("once memory").add(function(){x._removeData(e,t+"queue"),x._removeData(e,n)})})}}),x.fn.extend({queue:function(e,n){var r=2;return"string"!=typeof e&&(n=e,e="fx",r--),r>arguments.length?x.queue(this[0],e):n===t?this:this.each(function(){var t=x.queue(this,e,n);x._queueHooks(this,e),"fx"===e&&"inprogress"!==t[0]&&x.dequeue(this,e)})},dequeue:function(e){return this.each(function(){x.dequeue(this,e)})},delay:function(e,t){return e=x.fx?x.fx.speeds[e]||e:e,t=t||"fx",this.queue(t,function(t,n){var r=setTimeout(t,e);n.stop=function(){clearTimeout(r)}})},clearQueue:function(e){return this.queue(e||"fx",[])},promise:function(e,n){var r,i=1,o=x.Deferred(),a=this,s=this.length,l=function(){--i||o.resolveWith(a,[a])};"string"!=typeof e&&(n=e,e=t),e=e||"fx";while(s--)r=x._data(a[s],e+"queueHooks"),r&&r.empty&&(i++,r.empty.add(l));return l(),o.promise(n)}});var z,X,U=/[\t\r\n\f]/g,V=/\r/g,Y=/^(?:input|select|textarea|button|object)$/i,J=/^(?:a|area)$/i,G=/^(?:checked|selected)$/i,Q=x.support.getSetAttribute,K=x.support.input;x.fn.extend({attr:function(e,t){return x.access(this,x.attr,e,t,arguments.length>1)},removeAttr:function(e){return this.each(function(){x.removeAttr(this,e)})},prop:function(e,t){return x.access(this,x.prop,e,t,arguments.length>1)},removeProp:function(e){return e=x.propFix[e]||e,this.each(function(){try{this[e]=t,delete this[e]}catch(n){}})},addClass:function(e){var t,n,r,i,o,a=0,s=this.length,l="string"==typeof e&&e;if(x.isFunction(e))return this.each(function(t){x(this).addClass(e.call(this,t,this.className))});if(l)for(t=(e||"").match(T)||[];s>a;a++)if(n=this[a],r=1===n.nodeType&&(n.className?(" "+n.className+" ").replace(U," "):" ")){o=0;while(i=t[o++])0>r.indexOf(" "+i+" ")&&(r+=i+" ");n.className=x.trim(r)}return this},removeClass:function(e){var t,n,r,i,o,a=0,s=this.length,l=0===arguments.length||"string"==typeof e&&e;if(x.isFunction(e))return this.each(function(t){x(this).removeClass(e.call(this,t,this.className))});if(l)for(t=(e||"").match(T)||[];s>a;a++)if(n=this[a],r=1===n.nodeType&&(n.className?(" "+n.className+" ").replace(U," "):"")){o=0;while(i=t[o++])while(r.indexOf(" "+i+" ")>=0)r=r.replace(" "+i+" "," ");n.className=e?x.trim(r):""}return this},toggleClass:function(e,t){var n=typeof e;return"boolean"==typeof t&&"string"===n?t?this.addClass(e):this.removeClass(e):x.isFunction(e)?this.each(function(n){x(this).toggleClass(e.call(this,n,this.className,t),t)}):this.each(function(){if("string"===n){var t,r=0,o=x(this),a=e.match(T)||[];while(t=a[r++])o.hasClass(t)?o.removeClass(t):o.addClass(t)}else(n===i||"boolean"===n)&&(this.className&&x._data(this,"__className__",this.className),this.className=this.className||e===!1?"":x._data(this,"__className__")||"")})},hasClass:function(e){var t=" "+e+" ",n=0,r=this.length;for(;r>n;n++)if(1===this[n].nodeType&&(" "+this[n].className+" ").replace(U," ").indexOf(t)>=0)return!0;return!1},val:function(e){var n,r,i,o=this[0];{if(arguments.length)return i=x.isFunction(e),this.each(function(n){var o;1===this.nodeType&&(o=i?e.call(this,n,x(this).val()):e,null==o?o="":"number"==typeof o?o+="":x.isArray(o)&&(o=x.map(o,function(e){return null==e?"":e+""})),r=x.valHooks[this.type]||x.valHooks[this.nodeName.toLowerCase()],r&&"set"in r&&r.set(this,o,"value")!==t||(this.value=o))});if(o)return r=x.valHooks[o.type]||x.valHooks[o.nodeName.toLowerCase()],r&&"get"in r&&(n=r.get(o,"value"))!==t?n:(n=o.value,"string"==typeof n?n.replace(V,""):null==n?"":n)}}}),x.extend({valHooks:{option:{get:function(e){var t=x.find.attr(e,"value");return null!=t?t:e.text}},select:{get:function(e){var t,n,r=e.options,i=e.selectedIndex,o="select-one"===e.type||0>i,a=o?null:[],s=o?i+1:r.length,l=0>i?s:o?i:0;for(;s>l;l++)if(n=r[l],!(!n.selected&&l!==i||(x.support.optDisabled?n.disabled:null!==n.getAttribute("disabled"))||n.parentNode.disabled&&x.nodeName(n.parentNode,"optgroup"))){if(t=x(n).val(),o)return t;a.push(t)}return a},set:function(e,t){var n,r,i=e.options,o=x.makeArray(t),a=i.length;while(a--)r=i[a],(r.selected=x.inArray(x(r).val(),o)>=0)&&(n=!0);return n||(e.selectedIndex=-1),o}}},attr:function(e,n,r){var o,a,s=e.nodeType;if(e&&3!==s&&8!==s&&2!==s)return typeof e.getAttribute===i?x.prop(e,n,r):(1===s&&x.isXMLDoc(e)||(n=n.toLowerCase(),o=x.attrHooks[n]||(x.expr.match.bool.test(n)?X:z)),r===t?o&&"get"in o&&null!==(a=o.get(e,n))?a:(a=x.find.attr(e,n),null==a?t:a):null!==r?o&&"set"in o&&(a=o.set(e,r,n))!==t?a:(e.setAttribute(n,r+""),r):(x.removeAttr(e,n),t))},removeAttr:function(e,t){var n,r,i=0,o=t&&t.match(T);if(o&&1===e.nodeType)while(n=o[i++])r=x.propFix[n]||n,x.expr.match.bool.test(n)?K&&Q||!G.test(n)?e[r]=!1:e[x.camelCase("default-"+n)]=e[r]=!1:x.attr(e,n,""),e.removeAttribute(Q?n:r)},attrHooks:{type:{set:function(e,t){if(!x.support.radioValue&&"radio"===t&&x.nodeName(e,"input")){var n=e.value;return e.setAttribute("type",t),n&&(e.value=n),t}}}},propFix:{"for":"htmlFor","class":"className"},prop:function(e,n,r){var i,o,a,s=e.nodeType;if(e&&3!==s&&8!==s&&2!==s)return a=1!==s||!x.isXMLDoc(e),a&&(n=x.propFix[n]||n,o=x.propHooks[n]),r!==t?o&&"set"in o&&(i=o.set(e,r,n))!==t?i:e[n]=r:o&&"get"in o&&null!==(i=o.get(e,n))?i:e[n]},propHooks:{tabIndex:{get:function(e){var t=x.find.attr(e,"tabindex");return t?parseInt(t,10):Y.test(e.nodeName)||J.test(e.nodeName)&&e.href?0:-1}}}}),X={set:function(e,t,n){return t===!1?x.removeAttr(e,n):K&&Q||!G.test(n)?e.setAttribute(!Q&&x.propFix[n]||n,n):e[x.camelCase("default-"+n)]=e[n]=!0,n}},x.each(x.expr.match.bool.source.match(/\w+/g),function(e,n){var r=x.expr.attrHandle[n]||x.find.attr;x.expr.attrHandle[n]=K&&Q||!G.test(n)?function(e,n,i){var o=x.expr.attrHandle[n],a=i?t:(x.expr.attrHandle[n]=t)!=r(e,n,i)?n.toLowerCase():null;return x.expr.attrHandle[n]=o,a}:function(e,n,r){return r?t:e[x.camelCase("default-"+n)]?n.toLowerCase():null}}),K&&Q||(x.attrHooks.value={set:function(e,n,r){return x.nodeName(e,"input")?(e.defaultValue=n,t):z&&z.set(e,n,r)}}),Q||(z={set:function(e,n,r){var i=e.getAttributeNode(r);return i||e.setAttributeNode(i=e.ownerDocument.createAttribute(r)),i.value=n+="","value"===r||n===e.getAttribute(r)?n:t}},x.expr.attrHandle.id=x.expr.attrHandle.name=x.expr.attrHandle.coords=function(e,n,r){var i;return r?t:(i=e.getAttributeNode(n))&&""!==i.value?i.value:null},x.valHooks.button={get:function(e,n){var r=e.getAttributeNode(n);return r&&r.specified?r.value:t},set:z.set},x.attrHooks.contenteditable={set:function(e,t,n){z.set(e,""===t?!1:t,n)}},x.each(["width","height"],function(e,n){x.attrHooks[n]={set:function(e,r){return""===r?(e.setAttribute(n,"auto"),r):t}}})),x.support.hrefNormalized||x.each(["href","src"],function(e,t){x.propHooks[t]={get:function(e){return e.getAttribute(t,4)}}}),x.support.style||(x.attrHooks.style={get:function(e){return e.style.cssText||t},set:function(e,t){return e.style.cssText=t+""}}),x.support.optSelected||(x.propHooks.selected={get:function(e){var t=e.parentNode;return t&&(t.selectedIndex,t.parentNode&&t.parentNode.selectedIndex),null}}),x.each(["tabIndex","readOnly","maxLength","cellSpacing","cellPadding","rowSpan","colSpan","useMap","frameBorder","contentEditable"],function(){x.propFix[this.toLowerCase()]=this}),x.support.enctype||(x.propFix.enctype="encoding"),x.each(["radio","checkbox"],function(){x.valHooks[this]={set:function(e,n){return x.isArray(n)?e.checked=x.inArray(x(e).val(),n)>=0:t}},x.support.checkOn||(x.valHooks[this].get=function(e){return null===e.getAttribute("value")?"on":e.value})});var Z=/^(?:input|select|textarea)$/i,et=/^key/,tt=/^(?:mouse|contextmenu)|click/,nt=/^(?:focusinfocus|focusoutblur)$/,rt=/^([^.]*)(?:\.(.+)|)$/;function it(){return!0}function ot(){return!1}function at(){try{return a.activeElement}catch(e){}}x.event={global:{},add:function(e,n,r,o,a){var s,l,u,c,p,f,d,h,g,m,y,v=x._data(e);if(v){r.handler&&(c=r,r=c.handler,a=c.selector),r.guid||(r.guid=x.guid++),(l=v.events)||(l=v.events={}),(f=v.handle)||(f=v.handle=function(e){return typeof x===i||e&&x.event.triggered===e.type?t:x.event.dispatch.apply(f.elem,arguments)},f.elem=e),n=(n||"").match(T)||[""],u=n.length;while(u--)s=rt.exec(n[u])||[],g=y=s[1],m=(s[2]||"").split(".").sort(),g&&(p=x.event.special[g]||{},g=(a?p.delegateType:p.bindType)||g,p=x.event.special[g]||{},d=x.extend({type:g,origType:y,data:o,handler:r,guid:r.guid,selector:a,needsContext:a&&x.expr.match.needsContext.test(a),namespace:m.join(".")},c),(h=l[g])||(h=l[g]=[],h.delegateCount=0,p.setup&&p.setup.call(e,o,m,f)!==!1||(e.addEventListener?e.addEventListener(g,f,!1):e.attachEvent&&e.attachEvent("on"+g,f))),p.add&&(p.add.call(e,d),d.handler.guid||(d.handler.guid=r.guid)),a?h.splice(h.delegateCount++,0,d):h.push(d),x.event.global[g]=!0);e=null}},remove:function(e,t,n,r,i){var o,a,s,l,u,c,p,f,d,h,g,m=x.hasData(e)&&x._data(e);if(m&&(c=m.events)){t=(t||"").match(T)||[""],u=t.length;while(u--)if(s=rt.exec(t[u])||[],d=g=s[1],h=(s[2]||"").split(".").sort(),d){p=x.event.special[d]||{},d=(r?p.delegateType:p.bindType)||d,f=c[d]||[],s=s[2]&&RegExp("(^|\\.)"+h.join("\\.(?:.*\\.|)")+"(\\.|$)"),l=o=f.length;while(o--)a=f[o],!i&&g!==a.origType||n&&n.guid!==a.guid||s&&!s.test(a.namespace)||r&&r!==a.selector&&("**"!==r||!a.selector)||(f.splice(o,1),a.selector&&f.delegateCount--,p.remove&&p.remove.call(e,a));l&&!f.length&&(p.teardown&&p.teardown.call(e,h,m.handle)!==!1||x.removeEvent(e,d,m.handle),delete c[d])}else for(d in c)x.event.remove(e,d+t[u],n,r,!0);x.isEmptyObject(c)&&(delete m.handle,x._removeData(e,"events"))}},trigger:function(n,r,i,o){var s,l,u,c,p,f,d,h=[i||a],g=v.call(n,"type")?n.type:n,m=v.call(n,"namespace")?n.namespace.split("."):[];if(u=f=i=i||a,3!==i.nodeType&&8!==i.nodeType&&!nt.test(g+x.event.triggered)&&(g.indexOf(".")>=0&&(m=g.split("."),g=m.shift(),m.sort()),l=0>g.indexOf(":")&&"on"+g,n=n[x.expando]?n:new x.Event(g,"object"==typeof n&&n),n.isTrigger=o?2:3,n.namespace=m.join("."),n.namespace_re=n.namespace?RegExp("(^|\\.)"+m.join("\\.(?:.*\\.|)")+"(\\.|$)"):null,n.result=t,n.target||(n.target=i),r=null==r?[n]:x.makeArray(r,[n]),p=x.event.special[g]||{},o||!p.trigger||p.trigger.apply(i,r)!==!1)){if(!o&&!p.noBubble&&!x.isWindow(i)){for(c=p.delegateType||g,nt.test(c+g)||(u=u.parentNode);u;u=u.parentNode)h.push(u),f=u;f===(i.ownerDocument||a)&&h.push(f.defaultView||f.parentWindow||e)}d=0;while((u=h[d++])&&!n.isPropagationStopped())n.type=d>1?c:p.bindType||g,s=(x._data(u,"events")||{})[n.type]&&x._data(u,"handle"),s&&s.apply(u,r),s=l&&u[l],s&&x.acceptData(u)&&s.apply&&s.apply(u,r)===!1&&n.preventDefault();if(n.type=g,!o&&!n.isDefaultPrevented()&&(!p._default||p._default.apply(h.pop(),r)===!1)&&x.acceptData(i)&&l&&i[g]&&!x.isWindow(i)){f=i[l],f&&(i[l]=null),x.event.triggered=g;try{i[g]()}catch(y){}x.event.triggered=t,f&&(i[l]=f)}return n.result}},dispatch:function(e){e=x.event.fix(e);var n,r,i,o,a,s=[],l=g.call(arguments),u=(x._data(this,"events")||{})[e.type]||[],c=x.event.special[e.type]||{};if(l[0]=e,e.delegateTarget=this,!c.preDispatch||c.preDispatch.call(this,e)!==!1){s=x.event.handlers.call(this,e,u),n=0;while((o=s[n++])&&!e.isPropagationStopped()){e.currentTarget=o.elem,a=0;while((i=o.handlers[a++])&&!e.isImmediatePropagationStopped())(!e.namespace_re||e.namespace_re.test(i.namespace))&&(e.handleObj=i,e.data=i.data,r=((x.event.special[i.origType]||{}).handle||i.handler).apply(o.elem,l),r!==t&&(e.result=r)===!1&&(e.preventDefault(),e.stopPropagation()))}return c.postDispatch&&c.postDispatch.call(this,e),e.result}},handlers:function(e,n){var r,i,o,a,s=[],l=n.delegateCount,u=e.target;if(l&&u.nodeType&&(!e.button||"click"!==e.type))for(;u!=this;u=u.parentNode||this)if(1===u.nodeType&&(u.disabled!==!0||"click"!==e.type)){for(o=[],a=0;l>a;a++)i=n[a],r=i.selector+" ",o[r]===t&&(o[r]=i.needsContext?x(r,this).index(u)>=0:x.find(r,this,null,[u]).length),o[r]&&o.push(i);o.length&&s.push({elem:u,handlers:o})}return n.length>l&&s.push({elem:this,handlers:n.slice(l)}),s},fix:function(e){if(e[x.expando])return e;var t,n,r,i=e.type,o=e,s=this.fixHooks[i];s||(this.fixHooks[i]=s=tt.test(i)?this.mouseHooks:et.test(i)?this.keyHooks:{}),r=s.props?this.props.concat(s.props):this.props,e=new x.Event(o),t=r.length;while(t--)n=r[t],e[n]=o[n];return e.target||(e.target=o.srcElement||a),3===e.target.nodeType&&(e.target=e.target.parentNode),e.metaKey=!!e.metaKey,s.filter?s.filter(e,o):e},props:"altKey bubbles cancelable ctrlKey currentTarget eventPhase metaKey relatedTarget shiftKey target timeStamp view which".split(" "),fixHooks:{},keyHooks:{props:"char charCode key keyCode".split(" "),filter:function(e,t){return null==e.which&&(e.which=null!=t.charCode?t.charCode:t.keyCode),e}},mouseHooks:{props:"button buttons clientX clientY fromElement offsetX offsetY pageX pageY screenX screenY toElement".split(" "),filter:function(e,n){var r,i,o,s=n.button,l=n.fromElement;return null==e.pageX&&null!=n.clientX&&(i=e.target.ownerDocument||a,o=i.documentElement,r=i.body,e.pageX=n.clientX+(o&&o.scrollLeft||r&&r.scrollLeft||0)-(o&&o.clientLeft||r&&r.clientLeft||0),e.pageY=n.clientY+(o&&o.scrollTop||r&&r.scrollTop||0)-(o&&o.clientTop||r&&r.clientTop||0)),!e.relatedTarget&&l&&(e.relatedTarget=l===e.target?n.toElement:l),e.which||s===t||(e.which=1&s?1:2&s?3:4&s?2:0),e}},special:{load:{noBubble:!0},focus:{trigger:function(){if(this!==at()&&this.focus)try{return this.focus(),!1}catch(e){}},delegateType:"focusin"},blur:{trigger:function(){return this===at()&&this.blur?(this.blur(),!1):t},delegateType:"focusout"},click:{trigger:function(){return x.nodeName(this,"input")&&"checkbox"===this.type&&this.click?(this.click(),!1):t},_default:function(e){return x.nodeName(e.target,"a")}},beforeunload:{postDispatch:function(e){e.result!==t&&(e.originalEvent.returnValue=e.result)}}},simulate:function(e,t,n,r){var i=x.extend(new x.Event,n,{type:e,isSimulated:!0,originalEvent:{}});r?x.event.trigger(i,null,t):x.event.dispatch.call(t,i),i.isDefaultPrevented()&&n.preventDefault()}},x.removeEvent=a.removeEventListener?function(e,t,n){e.removeEventListener&&e.removeEventListener(t,n,!1)}:function(e,t,n){var r="on"+t;e.detachEvent&&(typeof e[r]===i&&(e[r]=null),e.detachEvent(r,n))},x.Event=function(e,n){return this instanceof x.Event?(e&&e.type?(this.originalEvent=e,this.type=e.type,this.isDefaultPrevented=e.defaultPrevented||e.returnValue===!1||e.getPreventDefault&&e.getPreventDefault()?it:ot):this.type=e,n&&x.extend(this,n),this.timeStamp=e&&e.timeStamp||x.now(),this[x.expando]=!0,t):new x.Event(e,n)},x.Event.prototype={isDefaultPrevented:ot,isPropagationStopped:ot,isImmediatePropagationStopped:ot,preventDefault:function(){var e=this.originalEvent;this.isDefaultPrevented=it,e&&(e.preventDefault?e.preventDefault():e.returnValue=!1)},stopPropagation:function(){var e=this.originalEvent;this.isPropagationStopped=it,e&&(e.stopPropagation&&e.stopPropagation(),e.cancelBubble=!0)},stopImmediatePropagation:function(){this.isImmediatePropagationStopped=it,this.stopPropagation()}},x.each({mouseenter:"mouseover",mouseleave:"mouseout"},function(e,t){x.event.special[e]={delegateType:t,bindType:t,handle:function(e){var n,r=this,i=e.relatedTarget,o=e.handleObj;return(!i||i!==r&&!x.contains(r,i))&&(e.type=o.origType,n=o.handler.apply(this,arguments),e.type=t),n}}}),x.support.submitBubbles||(x.event.special.submit={setup:function(){return x.nodeName(this,"form")?!1:(x.event.add(this,"click._submit keypress._submit",function(e){var n=e.target,r=x.nodeName(n,"input")||x.nodeName(n,"button")?n.form:t;r&&!x._data(r,"submitBubbles")&&(x.event.add(r,"submit._submit",function(e){e._submit_bubble=!0}),x._data(r,"submitBubbles",!0))}),t)},postDispatch:function(e){e._submit_bubble&&(delete e._submit_bubble,this.parentNode&&!e.isTrigger&&x.event.simulate("submit",this.parentNode,e,!0))},teardown:function(){return x.nodeName(this,"form")?!1:(x.event.remove(this,"._submit"),t)}}),x.support.changeBubbles||(x.event.special.change={setup:function(){return Z.test(this.nodeName)?(("checkbox"===this.type||"radio"===this.type)&&(x.event.add(this,"propertychange._change",function(e){"checked"===e.originalEvent.propertyName&&(this._just_changed=!0)}),x.event.add(this,"click._change",function(e){this._just_changed&&!e.isTrigger&&(this._just_changed=!1),x.event.simulate("change",this,e,!0)})),!1):(x.event.add(this,"beforeactivate._change",function(e){var t=e.target;Z.test(t.nodeName)&&!x._data(t,"changeBubbles")&&(x.event.add(t,"change._change",function(e){!this.parentNode||e.isSimulated||e.isTrigger||x.event.simulate("change",this.parentNode,e,!0)}),x._data(t,"changeBubbles",!0))}),t)},handle:function(e){var n=e.target;return this!==n||e.isSimulated||e.isTrigger||"radio"!==n.type&&"checkbox"!==n.type?e.handleObj.handler.apply(this,arguments):t},teardown:function(){return x.event.remove(this,"._change"),!Z.test(this.nodeName)}}),x.support.focusinBubbles||x.each({focus:"focusin",blur:"focusout"},function(e,t){var n=0,r=function(e){x.event.simulate(t,e.target,x.event.fix(e),!0)};x.event.special[t]={setup:function(){0===n++&&a.addEventListener(e,r,!0)},teardown:function(){0===--n&&a.removeEventListener(e,r,!0)}}}),x.fn.extend({on:function(e,n,r,i,o){var a,s;if("object"==typeof e){"string"!=typeof n&&(r=r||n,n=t);for(a in e)this.on(a,n,r,e[a],o);return this}if(null==r&&null==i?(i=n,r=n=t):null==i&&("string"==typeof n?(i=r,r=t):(i=r,r=n,n=t)),i===!1)i=ot;else if(!i)return this;return 1===o&&(s=i,i=function(e){return x().off(e),s.apply(this,arguments)},i.guid=s.guid||(s.guid=x.guid++)),this.each(function(){x.event.add(this,e,i,r,n)})},one:function(e,t,n,r){return this.on(e,t,n,r,1)},off:function(e,n,r){var i,o;if(e&&e.preventDefault&&e.handleObj)return i=e.handleObj,x(e.delegateTarget).off(i.namespace?i.origType+"."+i.namespace:i.origType,i.selector,i.handler),this;if("object"==typeof e){for(o in e)this.off(o,n,e[o]);return this}return(n===!1||"function"==typeof n)&&(r=n,n=t),r===!1&&(r=ot),this.each(function(){x.event.remove(this,e,r,n)})},trigger:function(e,t){return this.each(function(){x.event.trigger(e,t,this)})},triggerHandler:function(e,n){var r=this[0];return r?x.event.trigger(e,n,r,!0):t}});var st=/^.[^:#\[\.,]*$/,lt=/^(?:parents|prev(?:Until|All))/,ut=x.expr.match.needsContext,ct={children:!0,contents:!0,next:!0,prev:!0};x.fn.extend({find:function(e){var t,n=[],r=this,i=r.length;if("string"!=typeof e)return this.pushStack(x(e).filter(function(){for(t=0;i>t;t++)if(x.contains(r[t],this))return!0}));for(t=0;i>t;t++)x.find(e,r[t],n);return n=this.pushStack(i>1?x.unique(n):n),n.selector=this.selector?this.selector+" "+e:e,n},has:function(e){var t,n=x(e,this),r=n.length;return this.filter(function(){for(t=0;r>t;t++)if(x.contains(this,n[t]))return!0})},not:function(e){return this.pushStack(ft(this,e||[],!0))},filter:function(e){return this.pushStack(ft(this,e||[],!1))},is:function(e){return!!ft(this,"string"==typeof e&&ut.test(e)?x(e):e||[],!1).length},closest:function(e,t){var n,r=0,i=this.length,o=[],a=ut.test(e)||"string"!=typeof e?x(e,t||this.context):0;for(;i>r;r++)for(n=this[r];n&&n!==t;n=n.parentNode)if(11>n.nodeType&&(a?a.index(n)>-1:1===n.nodeType&&x.find.matchesSelector(n,e))){n=o.push(n);break}return this.pushStack(o.length>1?x.unique(o):o)},index:function(e){return e?"string"==typeof e?x.inArray(this[0],x(e)):x.inArray(e.jquery?e[0]:e,this):this[0]&&this[0].parentNode?this.first().prevAll().length:-1},add:function(e,t){var n="string"==typeof e?x(e,t):x.makeArray(e&&e.nodeType?[e]:e),r=x.merge(this.get(),n);return this.pushStack(x.unique(r))},addBack:function(e){return this.add(null==e?this.prevObject:this.prevObject.filter(e))}});function pt(e,t){do e=e[t];while(e&&1!==e.nodeType);return e}x.each({parent:function(e){var t=e.parentNode;return t&&11!==t.nodeType?t:null},parents:function(e){return x.dir(e,"parentNode")},parentsUntil:function(e,t,n){return x.dir(e,"parentNode",n)},next:function(e){return pt(e,"nextSibling")},prev:function(e){return pt(e,"previousSibling")},nextAll:function(e){return x.dir(e,"nextSibling")},prevAll:function(e){return x.dir(e,"previousSibling")},nextUntil:function(e,t,n){return x.dir(e,"nextSibling",n)},prevUntil:function(e,t,n){return x.dir(e,"previousSibling",n)},siblings:function(e){return x.sibling((e.parentNode||{}).firstChild,e)},children:function(e){return x.sibling(e.firstChild)},contents:function(e){return x.nodeName(e,"iframe")?e.contentDocument||e.contentWindow.document:x.merge([],e.childNodes)}},function(e,t){x.fn[e]=function(n,r){var i=x.map(this,t,n);return"Until"!==e.slice(-5)&&(r=n),r&&"string"==typeof r&&(i=x.filter(r,i)),this.length>1&&(ct[e]||(i=x.unique(i)),lt.test(e)&&(i=i.reverse())),this.pushStack(i)}}),x.extend({filter:function(e,t,n){var r=t[0];return n&&(e=":not("+e+")"),1===t.length&&1===r.nodeType?x.find.matchesSelector(r,e)?[r]:[]:x.find.matches(e,x.grep(t,function(e){return 1===e.nodeType}))},dir:function(e,n,r){var i=[],o=e[n];while(o&&9!==o.nodeType&&(r===t||1!==o.nodeType||!x(o).is(r)))1===o.nodeType&&i.push(o),o=o[n];return i},sibling:function(e,t){var n=[];for(;e;e=e.nextSibling)1===e.nodeType&&e!==t&&n.push(e);return n}});function ft(e,t,n){if(x.isFunction(t))return x.grep(e,function(e,r){return!!t.call(e,r,e)!==n});if(t.nodeType)return x.grep(e,function(e){return e===t!==n});if("string"==typeof t){if(st.test(t))return x.filter(t,e,n);t=x.filter(t,e)}return x.grep(e,function(e){return x.inArray(e,t)>=0!==n})}function dt(e){var t=ht.split("|"),n=e.createDocumentFragment();if(n.createElement)while(t.length)n.createElement(t.pop());return n}var ht="abbr|article|aside|audio|bdi|canvas|data|datalist|details|figcaption|figure|footer|header|hgroup|mark|meter|nav|output|progress|section|summary|time|video",gt=/ jQuery\d+="(?:null|\d+)"/g,mt=RegExp("<(?:"+ht+")[\\s/>]","i"),yt=/^\s+/,vt=/<(?!area|br|col|embed|hr|img|input|link|meta|param)(([\w:]+)[^>]*)\/>/gi,bt=/<([\w:]+)/,xt=/<tbody/i,wt=/<|&#?\w+;/,Tt=/<(?:script|style|link)/i,Ct=/^(?:checkbox|radio)$/i,Nt=/checked\s*(?:[^=]|=\s*.checked.)/i,kt=/^$|\/(?:java|ecma)script/i,Et=/^true\/(.*)/,St=/^\s*<!(?:\[CDATA\[|--)|(?:\]\]|--)>\s*$/g,At={option:[1,"<select multiple='multiple'>","</select>"],legend:[1,"<fieldset>","</fieldset>"],area:[1,"<map>","</map>"],param:[1,"<object>","</object>"],thead:[1,"<table>","</table>"],tr:[2,"<table><tbody>","</tbody></table>"],col:[2,"<table><tbody></tbody><colgroup>","</colgroup></table>"],td:[3,"<table><tbody><tr>","</tr></tbody></table>"],_default:x.support.htmlSerialize?[0,"",""]:[1,"X<div>","</div>"]},jt=dt(a),Dt=jt.appendChild(a.createElement("div"));At.optgroup=At.option,At.tbody=At.tfoot=At.colgroup=At.caption=At.thead,At.th=At.td,x.fn.extend({text:function(e){return x.access(this,function(e){return e===t?x.text(this):this.empty().append((this[0]&&this[0].ownerDocument||a).createTextNode(e))},null,e,arguments.length)},append:function(){return this.domManip(arguments,function(e){if(1===this.nodeType||11===this.nodeType||9===this.nodeType){var t=Lt(this,e);t.appendChild(e)}})},prepend:function(){return this.domManip(arguments,function(e){if(1===this.nodeType||11===this.nodeType||9===this.nodeType){var t=Lt(this,e);t.insertBefore(e,t.firstChild)}})},before:function(){return this.domManip(arguments,function(e){this.parentNode&&this.parentNode.insertBefore(e,this)})},after:function(){return this.domManip(arguments,function(e){this.parentNode&&this.parentNode.insertBefore(e,this.nextSibling)})},remove:function(e,t){var n,r=e?x.filter(e,this):this,i=0;for(;null!=(n=r[i]);i++)t||1!==n.nodeType||x.cleanData(Ft(n)),n.parentNode&&(t&&x.contains(n.ownerDocument,n)&&_t(Ft(n,"script")),n.parentNode.removeChild(n));return this},empty:function(){var e,t=0;for(;null!=(e=this[t]);t++){1===e.nodeType&&x.cleanData(Ft(e,!1));while(e.firstChild)e.removeChild(e.firstChild);e.options&&x.nodeName(e,"select")&&(e.options.length=0)}return this},clone:function(e,t){return e=null==e?!1:e,t=null==t?e:t,this.map(function(){return x.clone(this,e,t)})},html:function(e){return x.access(this,function(e){var n=this[0]||{},r=0,i=this.length;if(e===t)return 1===n.nodeType?n.innerHTML.replace(gt,""):t;if(!("string"!=typeof e||Tt.test(e)||!x.support.htmlSerialize&&mt.test(e)||!x.support.leadingWhitespace&&yt.test(e)||At[(bt.exec(e)||["",""])[1].toLowerCase()])){e=e.replace(vt,"<$1></$2>");try{for(;i>r;r++)n=this[r]||{},1===n.nodeType&&(x.cleanData(Ft(n,!1)),n.innerHTML=e);n=0}catch(o){}}n&&this.empty().append(e)},null,e,arguments.length)},replaceWith:function(){var e=x.map(this,function(e){return[e.nextSibling,e.parentNode]}),t=0;return this.domManip(arguments,function(n){var r=e[t++],i=e[t++];i&&(r&&r.parentNode!==i&&(r=this.nextSibling),x(this).remove(),i.insertBefore(n,r))},!0),t?this:this.remove()},detach:function(e){return this.remove(e,!0)},domManip:function(e,t,n){e=d.apply([],e);var r,i,o,a,s,l,u=0,c=this.length,p=this,f=c-1,h=e[0],g=x.isFunction(h);if(g||!(1>=c||"string"!=typeof h||x.support.checkClone)&&Nt.test(h))return this.each(function(r){var i=p.eq(r);g&&(e[0]=h.call(this,r,i.html())),i.domManip(e,t,n)});if(c&&(l=x.buildFragment(e,this[0].ownerDocument,!1,!n&&this),r=l.firstChild,1===l.childNodes.length&&(l=r),r)){for(a=x.map(Ft(l,"script"),Ht),o=a.length;c>u;u++)i=l,u!==f&&(i=x.clone(i,!0,!0),o&&x.merge(a,Ft(i,"script"))),t.call(this[u],i,u);if(o)for(s=a[a.length-1].ownerDocument,x.map(a,qt),u=0;o>u;u++)i=a[u],kt.test(i.type||"")&&!x._data(i,"globalEval")&&x.contains(s,i)&&(i.src?x._evalUrl(i.src):x.globalEval((i.text||i.textContent||i.innerHTML||"").replace(St,"")));l=r=null}return this}});function Lt(e,t){return x.nodeName(e,"table")&&x.nodeName(1===t.nodeType?t:t.firstChild,"tr")?e.getElementsByTagName("tbody")[0]||e.appendChild(e.ownerDocument.createElement("tbody")):e}function Ht(e){return e.type=(null!==x.find.attr(e,"type"))+"/"+e.type,e}function qt(e){var t=Et.exec(e.type);return t?e.type=t[1]:e.removeAttribute("type"),e}function _t(e,t){var n,r=0;for(;null!=(n=e[r]);r++)x._data(n,"globalEval",!t||x._data(t[r],"globalEval"))}function Mt(e,t){if(1===t.nodeType&&x.hasData(e)){var n,r,i,o=x._data(e),a=x._data(t,o),s=o.events;if(s){delete a.handle,a.events={};for(n in s)for(r=0,i=s[n].length;i>r;r++)x.event.add(t,n,s[n][r])}a.data&&(a.data=x.extend({},a.data))}}function Ot(e,t){var n,r,i;if(1===t.nodeType){if(n=t.nodeName.toLowerCase(),!x.support.noCloneEvent&&t[x.expando]){i=x._data(t);for(r in i.events)x.removeEvent(t,r,i.handle);t.removeAttribute(x.expando)}"script"===n&&t.text!==e.text?(Ht(t).text=e.text,qt(t)):"object"===n?(t.parentNode&&(t.outerHTML=e.outerHTML),x.support.html5Clone&&e.innerHTML&&!x.trim(t.innerHTML)&&(t.innerHTML=e.innerHTML)):"input"===n&&Ct.test(e.type)?(t.defaultChecked=t.checked=e.checked,t.value!==e.value&&(t.value=e.value)):"option"===n?t.defaultSelected=t.selected=e.defaultSelected:("input"===n||"textarea"===n)&&(t.defaultValue=e.defaultValue)}}x.each({appendTo:"append",prependTo:"prepend",insertBefore:"before",insertAfter:"after",replaceAll:"replaceWith"},function(e,t){x.fn[e]=function(e){var n,r=0,i=[],o=x(e),a=o.length-1;for(;a>=r;r++)n=r===a?this:this.clone(!0),x(o[r])[t](n),h.apply(i,n.get());return this.pushStack(i)}});function Ft(e,n){var r,o,a=0,s=typeof e.getElementsByTagName!==i?e.getElementsByTagName(n||"*"):typeof e.querySelectorAll!==i?e.querySelectorAll(n||"*"):t;if(!s)for(s=[],r=e.childNodes||e;null!=(o=r[a]);a++)!n||x.nodeName(o,n)?s.push(o):x.merge(s,Ft(o,n));return n===t||n&&x.nodeName(e,n)?x.merge([e],s):s}function Bt(e){Ct.test(e.type)&&(e.defaultChecked=e.checked)}x.extend({clone:function(e,t,n){var r,i,o,a,s,l=x.contains(e.ownerDocument,e);if(x.support.html5Clone||x.isXMLDoc(e)||!mt.test("<"+e.nodeName+">")?o=e.cloneNode(!0):(Dt.innerHTML=e.outerHTML,Dt.removeChild(o=Dt.firstChild)),!(x.support.noCloneEvent&&x.support.noCloneChecked||1!==e.nodeType&&11!==e.nodeType||x.isXMLDoc(e)))for(r=Ft(o),s=Ft(e),a=0;null!=(i=s[a]);++a)r[a]&&Ot(i,r[a]);if(t)if(n)for(s=s||Ft(e),r=r||Ft(o),a=0;null!=(i=s[a]);a++)Mt(i,r[a]);else Mt(e,o);return r=Ft(o,"script"),r.length>0&&_t(r,!l&&Ft(e,"script")),r=s=i=null,o},buildFragment:function(e,t,n,r){var i,o,a,s,l,u,c,p=e.length,f=dt(t),d=[],h=0;for(;p>h;h++)if(o=e[h],o||0===o)if("object"===x.type(o))x.merge(d,o.nodeType?[o]:o);else if(wt.test(o)){s=s||f.appendChild(t.createElement("div")),l=(bt.exec(o)||["",""])[1].toLowerCase(),c=At[l]||At._default,s.innerHTML=c[1]+o.replace(vt,"<$1></$2>")+c[2],i=c[0];while(i--)s=s.lastChild;if(!x.support.leadingWhitespace&&yt.test(o)&&d.push(t.createTextNode(yt.exec(o)[0])),!x.support.tbody){o="table"!==l||xt.test(o)?"<table>"!==c[1]||xt.test(o)?0:s:s.firstChild,i=o&&o.childNodes.length;while(i--)x.nodeName(u=o.childNodes[i],"tbody")&&!u.childNodes.length&&o.removeChild(u)}x.merge(d,s.childNodes),s.textContent="";while(s.firstChild)s.removeChild(s.firstChild);s=f.lastChild}else d.push(t.createTextNode(o));s&&f.removeChild(s),x.support.appendChecked||x.grep(Ft(d,"input"),Bt),h=0;while(o=d[h++])if((!r||-1===x.inArray(o,r))&&(a=x.contains(o.ownerDocument,o),s=Ft(f.appendChild(o),"script"),a&&_t(s),n)){i=0;while(o=s[i++])kt.test(o.type||"")&&n.push(o)}return s=null,f},cleanData:function(e,t){var n,r,o,a,s=0,l=x.expando,u=x.cache,c=x.support.deleteExpando,f=x.event.special;for(;null!=(n=e[s]);s++)if((t||x.acceptData(n))&&(o=n[l],a=o&&u[o])){if(a.events)for(r in a.events)f[r]?x.event.remove(n,r):x.removeEvent(n,r,a.handle);u[o]&&(delete u[o],c?delete n[l]:typeof n.removeAttribute!==i?n.removeAttribute(l):n[l]=null,p.push(o))}},_evalUrl:function(e){return x.ajax({url:e,type:"GET",dataType:"script",async:!1,global:!1,"throws":!0})}}),x.fn.extend({wrapAll:function(e){if(x.isFunction(e))return this.each(function(t){x(this).wrapAll(e.call(this,t))});if(this[0]){var t=x(e,this[0].ownerDocument).eq(0).clone(!0);this[0].parentNode&&t.insertBefore(this[0]),t.map(function(){var e=this;while(e.firstChild&&1===e.firstChild.nodeType)e=e.firstChild;return e}).append(this)}return this},wrapInner:function(e){return x.isFunction(e)?this.each(function(t){x(this).wrapInner(e.call(this,t))}):this.each(function(){var t=x(this),n=t.contents();n.length?n.wrapAll(e):t.append(e)})},wrap:function(e){var t=x.isFunction(e);return this.each(function(n){x(this).wrapAll(t?e.call(this,n):e)})},unwrap:function(){return this.parent().each(function(){x.nodeName(this,"body")||x(this).replaceWith(this.childNodes)}).end()}});var Pt,Rt,Wt,$t=/alpha\([^)]*\)/i,It=/opacity\s*=\s*([^)]*)/,zt=/^(top|right|bottom|left)$/,Xt=/^(none|table(?!-c[ea]).+)/,Ut=/^margin/,Vt=RegExp("^("+w+")(.*)$","i"),Yt=RegExp("^("+w+")(?!px)[a-z%]+$","i"),Jt=RegExp("^([+-])=("+w+")","i"),Gt={BODY:"block"},Qt={position:"absolute",visibility:"hidden",display:"block"},Kt={letterSpacing:0,fontWeight:400},Zt=["Top","Right","Bottom","Left"],en=["Webkit","O","Moz","ms"];function tn(e,t){if(t in e)return t;var n=t.charAt(0).toUpperCase()+t.slice(1),r=t,i=en.length;while(i--)if(t=en[i]+n,t in e)return t;return r}function nn(e,t){return e=t||e,"none"===x.css(e,"display")||!x.contains(e.ownerDocument,e)}function rn(e,t){var n,r,i,o=[],a=0,s=e.length;for(;s>a;a++)r=e[a],r.style&&(o[a]=x._data(r,"olddisplay"),n=r.style.display,t?(o[a]||"none"!==n||(r.style.display=""),""===r.style.display&&nn(r)&&(o[a]=x._data(r,"olddisplay",ln(r.nodeName)))):o[a]||(i=nn(r),(n&&"none"!==n||!i)&&x._data(r,"olddisplay",i?n:x.css(r,"display"))));for(a=0;s>a;a++)r=e[a],r.style&&(t&&"none"!==r.style.display&&""!==r.style.display||(r.style.display=t?o[a]||"":"none"));return e}x.fn.extend({css:function(e,n){return x.access(this,function(e,n,r){var i,o,a={},s=0;if(x.isArray(n)){for(o=Rt(e),i=n.length;i>s;s++)a[n[s]]=x.css(e,n[s],!1,o);return a}return r!==t?x.style(e,n,r):x.css(e,n)},e,n,arguments.length>1)},show:function(){return rn(this,!0)},hide:function(){return rn(this)},toggle:function(e){return"boolean"==typeof e?e?this.show():this.hide():this.each(function(){nn(this)?x(this).show():x(this).hide()})}}),x.extend({cssHooks:{opacity:{get:function(e,t){if(t){var n=Wt(e,"opacity");return""===n?"1":n}}}},cssNumber:{columnCount:!0,fillOpacity:!0,fontWeight:!0,lineHeight:!0,opacity:!0,order:!0,orphans:!0,widows:!0,zIndex:!0,zoom:!0},cssProps:{"float":x.support.cssFloat?"cssFloat":"styleFloat"},style:function(e,n,r,i){if(e&&3!==e.nodeType&&8!==e.nodeType&&e.style){var o,a,s,l=x.camelCase(n),u=e.style;if(n=x.cssProps[l]||(x.cssProps[l]=tn(u,l)),s=x.cssHooks[n]||x.cssHooks[l],r===t)return s&&"get"in s&&(o=s.get(e,!1,i))!==t?o:u[n];if(a=typeof r,"string"===a&&(o=Jt.exec(r))&&(r=(o[1]+1)*o[2]+parseFloat(x.css(e,n)),a="number"),!(null==r||"number"===a&&isNaN(r)||("number"!==a||x.cssNumber[l]||(r+="px"),x.support.clearCloneStyle||""!==r||0!==n.indexOf("background")||(u[n]="inherit"),s&&"set"in s&&(r=s.set(e,r,i))===t)))try{u[n]=r}catch(c){}}},css:function(e,n,r,i){var o,a,s,l=x.camelCase(n);return n=x.cssProps[l]||(x.cssProps[l]=tn(e.style,l)),s=x.cssHooks[n]||x.cssHooks[l],s&&"get"in s&&(a=s.get(e,!0,r)),a===t&&(a=Wt(e,n,i)),"normal"===a&&n in Kt&&(a=Kt[n]),""===r||r?(o=parseFloat(a),r===!0||x.isNumeric(o)?o||0:a):a}}),e.getComputedStyle?(Rt=function(t){return e.getComputedStyle(t,null)},Wt=function(e,n,r){var i,o,a,s=r||Rt(e),l=s?s.getPropertyValue(n)||s[n]:t,u=e.style;return s&&(""!==l||x.contains(e.ownerDocument,e)||(l=x.style(e,n)),Yt.test(l)&&Ut.test(n)&&(i=u.width,o=u.minWidth,a=u.maxWidth,u.minWidth=u.maxWidth=u.width=l,l=s.width,u.width=i,u.minWidth=o,u.maxWidth=a)),l}):a.documentElement.currentStyle&&(Rt=function(e){return e.currentStyle},Wt=function(e,n,r){var i,o,a,s=r||Rt(e),l=s?s[n]:t,u=e.style;return null==l&&u&&u[n]&&(l=u[n]),Yt.test(l)&&!zt.test(n)&&(i=u.left,o=e.runtimeStyle,a=o&&o.left,a&&(o.left=e.currentStyle.left),u.left="fontSize"===n?"1em":l,l=u.pixelLeft+"px",u.left=i,a&&(o.left=a)),""===l?"auto":l});function on(e,t,n){var r=Vt.exec(t);return r?Math.max(0,r[1]-(n||0))+(r[2]||"px"):t}function an(e,t,n,r,i){var o=n===(r?"border":"content")?4:"width"===t?1:0,a=0;for(;4>o;o+=2)"margin"===n&&(a+=x.css(e,n+Zt[o],!0,i)),r?("content"===n&&(a-=x.css(e,"padding"+Zt[o],!0,i)),"margin"!==n&&(a-=x.css(e,"border"+Zt[o]+"Width",!0,i))):(a+=x.css(e,"padding"+Zt[o],!0,i),"padding"!==n&&(a+=x.css(e,"border"+Zt[o]+"Width",!0,i)));return a}function sn(e,t,n){var r=!0,i="width"===t?e.offsetWidth:e.offsetHeight,o=Rt(e),a=x.support.boxSizing&&"border-box"===x.css(e,"boxSizing",!1,o);if(0>=i||null==i){if(i=Wt(e,t,o),(0>i||null==i)&&(i=e.style[t]),Yt.test(i))return i;r=a&&(x.support.boxSizingReliable||i===e.style[t]),i=parseFloat(i)||0}return i+an(e,t,n||(a?"border":"content"),r,o)+"px"}function ln(e){var t=a,n=Gt[e];return n||(n=un(e,t),"none"!==n&&n||(Pt=(Pt||x("<iframe frameborder='0' width='0' height='0'/>").css("cssText","display:block !important")).appendTo(t.documentElement),t=(Pt[0].contentWindow||Pt[0].contentDocument).document,t.write("<!doctype html><html><body>"),t.close(),n=un(e,t),Pt.detach()),Gt[e]=n),n}function un(e,t){var n=x(t.createElement(e)).appendTo(t.body),r=x.css(n[0],"display");return n.remove(),r}x.each(["height","width"],function(e,n){x.cssHooks[n]={get:function(e,r,i){return r?0===e.offsetWidth&&Xt.test(x.css(e,"display"))?x.swap(e,Qt,function(){return sn(e,n,i)}):sn(e,n,i):t},set:function(e,t,r){var i=r&&Rt(e);return on(e,t,r?an(e,n,r,x.support.boxSizing&&"border-box"===x.css(e,"boxSizing",!1,i),i):0)}}}),x.support.opacity||(x.cssHooks.opacity={get:function(e,t){return It.test((t&&e.currentStyle?e.currentStyle.filter:e.style.filter)||"")?.01*parseFloat(RegExp.$1)+"":t?"1":""},set:function(e,t){var n=e.style,r=e.currentStyle,i=x.isNumeric(t)?"alpha(opacity="+100*t+")":"",o=r&&r.filter||n.filter||"";n.zoom=1,(t>=1||""===t)&&""===x.trim(o.replace($t,""))&&n.removeAttribute&&(n.removeAttribute("filter"),""===t||r&&!r.filter)||(n.filter=$t.test(o)?o.replace($t,i):o+" "+i)}}),x(function(){x.support.reliableMarginRight||(x.cssHooks.marginRight={get:function(e,n){return n?x.swap(e,{display:"inline-block"},Wt,[e,"marginRight"]):t}}),!x.support.pixelPosition&&x.fn.position&&x.each(["top","left"],function(e,n){x.cssHooks[n]={get:function(e,r){return r?(r=Wt(e,n),Yt.test(r)?x(e).position()[n]+"px":r):t}}})}),x.expr&&x.expr.filters&&(x.expr.filters.hidden=function(e){return 0>=e.offsetWidth&&0>=e.offsetHeight||!x.support.reliableHiddenOffsets&&"none"===(e.style&&e.style.display||x.css(e,"display"))},x.expr.filters.visible=function(e){return!x.expr.filters.hidden(e)}),x.each({margin:"",padding:"",border:"Width"},function(e,t){x.cssHooks[e+t]={expand:function(n){var r=0,i={},o="string"==typeof n?n.split(" "):[n];for(;4>r;r++)i[e+Zt[r]+t]=o[r]||o[r-2]||o[0];return i}},Ut.test(e)||(x.cssHooks[e+t].set=on)});var cn=/%20/g,pn=/\[\]$/,fn=/\r?\n/g,dn=/^(?:submit|button|image|reset|file)$/i,hn=/^(?:input|select|textarea|keygen)/i;x.fn.extend({serialize:function(){return x.param(this.serializeArray())},serializeArray:function(){return this.map(function(){var e=x.prop(this,"elements");return e?x.makeArray(e):this}).filter(function(){var e=this.type;return this.name&&!x(this).is(":disabled")&&hn.test(this.nodeName)&&!dn.test(e)&&(this.checked||!Ct.test(e))}).map(function(e,t){var n=x(this).val();return null==n?null:x.isArray(n)?x.map(n,function(e){return{name:t.name,value:e.replace(fn,"\r\n")}}):{name:t.name,value:n.replace(fn,"\r\n")}}).get()}}),x.param=function(e,n){var r,i=[],o=function(e,t){t=x.isFunction(t)?t():null==t?"":t,i[i.length]=encodeURIComponent(e)+"="+encodeURIComponent(t)};if(n===t&&(n=x.ajaxSettings&&x.ajaxSettings.traditional),x.isArray(e)||e.jquery&&!x.isPlainObject(e))x.each(e,function(){o(this.name,this.value)});else for(r in e)gn(r,e[r],n,o);return i.join("&").replace(cn,"+")};function gn(e,t,n,r){var i;if(x.isArray(t))x.each(t,function(t,i){n||pn.test(e)?r(e,i):gn(e+"["+("object"==typeof i?t:"")+"]",i,n,r)});else if(n||"object"!==x.type(t))r(e,t);else for(i in t)gn(e+"["+i+"]",t[i],n,r)}x.each("blur focus focusin focusout load resize scroll unload click dblclick mousedown mouseup mousemove mouseover mouseout mouseenter mouseleave change select submit keydown keypress keyup error contextmenu".split(" "),function(e,t){x.fn[t]=function(e,n){return arguments.length>0?this.on(t,null,e,n):this.trigger(t)}}),x.fn.extend({hover:function(e,t){return this.mouseenter(e).mouseleave(t||e)},bind:function(e,t,n){return this.on(e,null,t,n)},unbind:function(e,t){return this.off(e,null,t)},delegate:function(e,t,n,r){return this.on(t,e,n,r)},undelegate:function(e,t,n){return 1===arguments.length?this.off(e,"**"):this.off(t,e||"**",n)}});var mn,yn,vn=x.now(),bn=/\?/,xn=/#.*$/,wn=/([?&])_=[^&]*/,Tn=/^(.*?):[ \t]*([^\r\n]*)\r?$/gm,Cn=/^(?:about|app|app-storage|.+-extension|file|res|widget):$/,Nn=/^(?:GET|HEAD)$/,kn=/^\/\//,En=/^([\w.+-]+:)(?:\/\/([^\/?#:]*)(?::(\d+)|)|)/,Sn=x.fn.load,An={},jn={},Dn="*/".concat("*");try{yn=o.href}catch(Ln){yn=a.createElement("a"),yn.href="",yn=yn.href}mn=En.exec(yn.toLowerCase())||[];function Hn(e){return function(t,n){"string"!=typeof t&&(n=t,t="*");var r,i=0,o=t.toLowerCase().match(T)||[];if(x.isFunction(n))while(r=o[i++])"+"===r[0]?(r=r.slice(1)||"*",(e[r]=e[r]||[]).unshift(n)):(e[r]=e[r]||[]).push(n)}}function qn(e,n,r,i){var o={},a=e===jn;function s(l){var u;return o[l]=!0,x.each(e[l]||[],function(e,l){var c=l(n,r,i);return"string"!=typeof c||a||o[c]?a?!(u=c):t:(n.dataTypes.unshift(c),s(c),!1)}),u}return s(n.dataTypes[0])||!o["*"]&&s("*")}function _n(e,n){var r,i,o=x.ajaxSettings.flatOptions||{};for(i in n)n[i]!==t&&((o[i]?e:r||(r={}))[i]=n[i]);return r&&x.extend(!0,e,r),e}x.fn.load=function(e,n,r){if("string"!=typeof e&&Sn)return Sn.apply(this,arguments);var i,o,a,s=this,l=e.indexOf(" ");return l>=0&&(i=e.slice(l,e.length),e=e.slice(0,l)),x.isFunction(n)?(r=n,n=t):n&&"object"==typeof n&&(a="POST"),s.length>0&&x.ajax({url:e,type:a,dataType:"html",data:n}).done(function(e){o=arguments,s.html(i?x("<div>").append(x.parseHTML(e)).find(i):e)}).complete(r&&function(e,t){s.each(r,o||[e.responseText,t,e])}),this},x.each(["ajaxStart","ajaxStop","ajaxComplete","ajaxError","ajaxSuccess","ajaxSend"],function(e,t){x.fn[t]=function(e){return this.on(t,e)}}),x.extend({active:0,lastModified:{},etag:{},ajaxSettings:{url:yn,type:"GET",isLocal:Cn.test(mn[1]),global:!0,processData:!0,async:!0,contentType:"application/x-www-form-urlencoded; charset=UTF-8",accepts:{"*":Dn,text:"text/plain",html:"text/html",xml:"application/xml, text/xml",json:"application/json, text/javascript"},contents:{xml:/xml/,html:/html/,json:/json/},responseFields:{xml:"responseXML",text:"responseText",json:"responseJSON"},converters:{"* text":String,"text html":!0,"text json":x.parseJSON,"text xml":x.parseXML},flatOptions:{url:!0,context:!0}},ajaxSetup:function(e,t){return t?_n(_n(e,x.ajaxSettings),t):_n(x.ajaxSettings,e)},ajaxPrefilter:Hn(An),ajaxTransport:Hn(jn),ajax:function(e,n){"object"==typeof e&&(n=e,e=t),n=n||{};var r,i,o,a,s,l,u,c,p=x.ajaxSetup({},n),f=p.context||p,d=p.context&&(f.nodeType||f.jquery)?x(f):x.event,h=x.Deferred(),g=x.Callbacks("once memory"),m=p.statusCode||{},y={},v={},b=0,w="canceled",C={readyState:0,getResponseHeader:function(e){var t;if(2===b){if(!c){c={};while(t=Tn.exec(a))c[t[1].toLowerCase()]=t[2]}t=c[e.toLowerCase()]}return null==t?null:t},getAllResponseHeaders:function(){return 2===b?a:null},setRequestHeader:function(e,t){var n=e.toLowerCase();return b||(e=v[n]=v[n]||e,y[e]=t),this},overrideMimeType:function(e){return b||(p.mimeType=e),this},statusCode:function(e){var t;if(e)if(2>b)for(t in e)m[t]=[m[t],e[t]];else C.always(e[C.status]);return this},abort:function(e){var t=e||w;return u&&u.abort(t),k(0,t),this}};if(h.promise(C).complete=g.add,C.success=C.done,C.error=C.fail,p.url=((e||p.url||yn)+"").replace(xn,"").replace(kn,mn[1]+"//"),p.type=n.method||n.type||p.method||p.type,p.dataTypes=x.trim(p.dataType||"*").toLowerCase().match(T)||[""],null==p.crossDomain&&(r=En.exec(p.url.toLowerCase()),p.crossDomain=!(!r||r[1]===mn[1]&&r[2]===mn[2]&&(r[3]||("http:"===r[1]?"80":"443"))===(mn[3]||("http:"===mn[1]?"80":"443")))),p.data&&p.processData&&"string"!=typeof p.data&&(p.data=x.param(p.data,p.traditional)),qn(An,p,n,C),2===b)return C;l=p.global,l&&0===x.active++&&x.event.trigger("ajaxStart"),p.type=p.type.toUpperCase(),p.hasContent=!Nn.test(p.type),o=p.url,p.hasContent||(p.data&&(o=p.url+=(bn.test(o)?"&":"?")+p.data,delete p.data),p.cache===!1&&(p.url=wn.test(o)?o.replace(wn,"$1_="+vn++):o+(bn.test(o)?"&":"?")+"_="+vn++)),p.ifModified&&(x.lastModified[o]&&C.setRequestHeader("If-Modified-Since",x.lastModified[o]),x.etag[o]&&C.setRequestHeader("If-None-Match",x.etag[o])),(p.data&&p.hasContent&&p.contentType!==!1||n.contentType)&&C.setRequestHeader("Content-Type",p.contentType),C.setRequestHeader("Accept",p.dataTypes[0]&&p.accepts[p.dataTypes[0]]?p.accepts[p.dataTypes[0]]+("*"!==p.dataTypes[0]?", "+Dn+"; q=0.01":""):p.accepts["*"]);for(i in p.headers)C.setRequestHeader(i,p.headers[i]);if(p.beforeSend&&(p.beforeSend.call(f,C,p)===!1||2===b))return C.abort();w="abort";for(i in{success:1,error:1,complete:1})C[i](p[i]);if(u=qn(jn,p,n,C)){C.readyState=1,l&&d.trigger("ajaxSend",[C,p]),p.async&&p.timeout>0&&(s=setTimeout(function(){C.abort("timeout")},p.timeout));try{b=1,u.send(y,k)}catch(N){if(!(2>b))throw N;k(-1,N)}}else k(-1,"No Transport");function k(e,n,r,i){var c,y,v,w,T,N=n;2!==b&&(b=2,s&&clearTimeout(s),u=t,a=i||"",C.readyState=e>0?4:0,c=e>=200&&300>e||304===e,r&&(w=Mn(p,C,r)),w=On(p,w,C,c),c?(p.ifModified&&(T=C.getResponseHeader("Last-Modified"),T&&(x.lastModified[o]=T),T=C.getResponseHeader("etag"),T&&(x.etag[o]=T)),204===e||"HEAD"===p.type?N="nocontent":304===e?N="notmodified":(N=w.state,y=w.data,v=w.error,c=!v)):(v=N,(e||!N)&&(N="error",0>e&&(e=0))),C.status=e,C.statusText=(n||N)+"",c?h.resolveWith(f,[y,N,C]):h.rejectWith(f,[C,N,v]),C.statusCode(m),m=t,l&&d.trigger(c?"ajaxSuccess":"ajaxError",[C,p,c?y:v]),g.fireWith(f,[C,N]),l&&(d.trigger("ajaxComplete",[C,p]),--x.active||x.event.trigger("ajaxStop")))}return C},getJSON:function(e,t,n){return x.get(e,t,n,"json")},getScript:function(e,n){return x.get(e,t,n,"script")}}),x.each(["get","post"],function(e,n){x[n]=function(e,r,i,o){return x.isFunction(r)&&(o=o||i,i=r,r=t),x.ajax({url:e,type:n,dataType:o,data:r,success:i})}});function Mn(e,n,r){var i,o,a,s,l=e.contents,u=e.dataTypes;while("*"===u[0])u.shift(),o===t&&(o=e.mimeType||n.getResponseHeader("Content-Type"));if(o)for(s in l)if(l[s]&&l[s].test(o)){u.unshift(s);break}if(u[0]in r)a=u[0];else{for(s in r){if(!u[0]||e.converters[s+" "+u[0]]){a=s;break}i||(i=s)}a=a||i}return a?(a!==u[0]&&u.unshift(a),r[a]):t}function On(e,t,n,r){var i,o,a,s,l,u={},c=e.dataTypes.slice();if(c[1])for(a in e.converters)u[a.toLowerCase()]=e.converters[a];o=c.shift();while(o)if(e.responseFields[o]&&(n[e.responseFields[o]]=t),!l&&r&&e.dataFilter&&(t=e.dataFilter(t,e.dataType)),l=o,o=c.shift())if("*"===o)o=l;else if("*"!==l&&l!==o){if(a=u[l+" "+o]||u["* "+o],!a)for(i in u)if(s=i.split(" "),s[1]===o&&(a=u[l+" "+s[0]]||u["* "+s[0]])){a===!0?a=u[i]:u[i]!==!0&&(o=s[0],c.unshift(s[1]));break}if(a!==!0)if(a&&e["throws"])t=a(t);else try{t=a(t)}catch(p){return{state:"parsererror",error:a?p:"No conversion from "+l+" to "+o}}}return{state:"success",data:t}}x.ajaxSetup({accepts:{script:"text/javascript, application/javascript, application/ecmascript, application/x-ecmascript"},contents:{script:/(?:java|ecma)script/},converters:{"text script":function(e){return x.globalEval(e),e}}}),x.ajaxPrefilter("script",function(e){e.cache===t&&(e.cache=!1),e.crossDomain&&(e.type="GET",e.global=!1)}),x.ajaxTransport("script",function(e){if(e.crossDomain){var n,r=a.head||x("head")[0]||a.documentElement;return{send:function(t,i){n=a.createElement("script"),n.async=!0,e.scriptCharset&&(n.charset=e.scriptCharset),n.src=e.url,n.onload=n.onreadystatechange=function(e,t){(t||!n.readyState||/loaded|complete/.test(n.readyState))&&(n.onload=n.onreadystatechange=null,n.parentNode&&n.parentNode.removeChild(n),n=null,t||i(200,"success"))},r.insertBefore(n,r.firstChild)},abort:function(){n&&n.onload(t,!0)}}}});var Fn=[],Bn=/(=)\?(?=&|$)|\?\?/;x.ajaxSetup({jsonp:"callback",jsonpCallback:function(){var e=Fn.pop()||x.expando+"_"+vn++;return this[e]=!0,e}}),x.ajaxPrefilter("json jsonp",function(n,r,i){var o,a,s,l=n.jsonp!==!1&&(Bn.test(n.url)?"url":"string"==typeof n.data&&!(n.contentType||"").indexOf("application/x-www-form-urlencoded")&&Bn.test(n.data)&&"data");return l||"jsonp"===n.dataTypes[0]?(o=n.jsonpCallback=x.isFunction(n.jsonpCallback)?n.jsonpCallback():n.jsonpCallback,l?n[l]=n[l].replace(Bn,"$1"+o):n.jsonp!==!1&&(n.url+=(bn.test(n.url)?"&":"?")+n.jsonp+"="+o),n.converters["script json"]=function(){return s||x.error(o+" was not called"),s[0]},n.dataTypes[0]="json",a=e[o],e[o]=function(){s=arguments},i.always(function(){e[o]=a,n[o]&&(n.jsonpCallback=r.jsonpCallback,Fn.push(o)),s&&x.isFunction(a)&&a(s[0]),s=a=t}),"script"):t});var Pn,Rn,Wn=0,$n=e.ActiveXObject&&function(){var e;for(e in Pn)Pn[e](t,!0)};function In(){try{return new e.XMLHttpRequest}catch(t){}}function zn(){try{return new e.ActiveXObject("Microsoft.XMLHTTP")}catch(t){}}x.ajaxSettings.xhr=e.ActiveXObject?function(){return!this.isLocal&&In()||zn()}:In,Rn=x.ajaxSettings.xhr(),x.support.cors=!!Rn&&"withCredentials"in Rn,Rn=x.support.ajax=!!Rn,Rn&&x.ajaxTransport(function(n){if(!n.crossDomain||x.support.cors){var r;return{send:function(i,o){var a,s,l=n.xhr();if(n.username?l.open(n.type,n.url,n.async,n.username,n.password):l.open(n.type,n.url,n.async),n.xhrFields)for(s in n.xhrFields)l[s]=n.xhrFields[s];n.mimeType&&l.overrideMimeType&&l.overrideMimeType(n.mimeType),n.crossDomain||i["X-Requested-With"]||(i["X-Requested-With"]="XMLHttpRequest");try{for(s in i)l.setRequestHeader(s,i[s])}catch(u){}l.send(n.hasContent&&n.data||null),r=function(e,i){var s,u,c,p;try{if(r&&(i||4===l.readyState))if(r=t,a&&(l.onreadystatechange=x.noop,$n&&delete Pn[a]),i)4!==l.readyState&&l.abort();else{p={},s=l.status,u=l.getAllResponseHeaders(),"string"==typeof l.responseText&&(p.text=l.responseText);try{c=l.statusText}catch(f){c=""}s||!n.isLocal||n.crossDomain?1223===s&&(s=204):s=p.text?200:404}}catch(d){i||o(-1,d)}p&&o(s,c,p,u)},n.async?4===l.readyState?setTimeout(r):(a=++Wn,$n&&(Pn||(Pn={},x(e).unload($n)),Pn[a]=r),l.onreadystatechange=r):r()},abort:function(){r&&r(t,!0)}}}});var Xn,Un,Vn=/^(?:toggle|show|hide)$/,Yn=RegExp("^(?:([+-])=|)("+w+")([a-z%]*)$","i"),Jn=/queueHooks$/,Gn=[nr],Qn={"*":[function(e,t){var n=this.createTween(e,t),r=n.cur(),i=Yn.exec(t),o=i&&i[3]||(x.cssNumber[e]?"":"px"),a=(x.cssNumber[e]||"px"!==o&&+r)&&Yn.exec(x.css(n.elem,e)),s=1,l=20;if(a&&a[3]!==o){o=o||a[3],i=i||[],a=+r||1;do s=s||".5",a/=s,x.style(n.elem,e,a+o);while(s!==(s=n.cur()/r)&&1!==s&&--l)}return i&&(a=n.start=+a||+r||0,n.unit=o,n.end=i[1]?a+(i[1]+1)*i[2]:+i[2]),n}]};function Kn(){return setTimeout(function(){Xn=t}),Xn=x.now()}function Zn(e,t,n){var r,i=(Qn[t]||[]).concat(Qn["*"]),o=0,a=i.length;for(;a>o;o++)if(r=i[o].call(n,t,e))return r}function er(e,t,n){var r,i,o=0,a=Gn.length,s=x.Deferred().always(function(){delete l.elem}),l=function(){if(i)return!1;var t=Xn||Kn(),n=Math.max(0,u.startTime+u.duration-t),r=n/u.duration||0,o=1-r,a=0,l=u.tweens.length;for(;l>a;a++)u.tweens[a].run(o);return s.notifyWith(e,[u,o,n]),1>o&&l?n:(s.resolveWith(e,[u]),!1)},u=s.promise({elem:e,props:x.extend({},t),opts:x.extend(!0,{specialEasing:{}},n),originalProperties:t,originalOptions:n,startTime:Xn||Kn(),duration:n.duration,tweens:[],createTween:function(t,n){var r=x.Tween(e,u.opts,t,n,u.opts.specialEasing[t]||u.opts.easing);return u.tweens.push(r),r},stop:function(t){var n=0,r=t?u.tweens.length:0;if(i)return this;for(i=!0;r>n;n++)u.tweens[n].run(1);return t?s.resolveWith(e,[u,t]):s.rejectWith(e,[u,t]),this}}),c=u.props;for(tr(c,u.opts.specialEasing);a>o;o++)if(r=Gn[o].call(u,e,c,u.opts))return r;return x.map(c,Zn,u),x.isFunction(u.opts.start)&&u.opts.start.call(e,u),x.fx.timer(x.extend(l,{elem:e,anim:u,queue:u.opts.queue})),u.progress(u.opts.progress).done(u.opts.done,u.opts.complete).fail(u.opts.fail).always(u.opts.always)}function tr(e,t){var n,r,i,o,a;for(n in e)if(r=x.camelCase(n),i=t[r],o=e[n],x.isArray(o)&&(i=o[1],o=e[n]=o[0]),n!==r&&(e[r]=o,delete e[n]),a=x.cssHooks[r],a&&"expand"in a){o=a.expand(o),delete e[r];for(n in o)n in e||(e[n]=o[n],t[n]=i)}else t[r]=i}x.Animation=x.extend(er,{tweener:function(e,t){x.isFunction(e)?(t=e,e=["*"]):e=e.split(" ");var n,r=0,i=e.length;for(;i>r;r++)n=e[r],Qn[n]=Qn[n]||[],Qn[n].unshift(t)},prefilter:function(e,t){t?Gn.unshift(e):Gn.push(e)}});function nr(e,t,n){var r,i,o,a,s,l,u=this,c={},p=e.style,f=e.nodeType&&nn(e),d=x._data(e,"fxshow");n.queue||(s=x._queueHooks(e,"fx"),null==s.unqueued&&(s.unqueued=0,l=s.empty.fire,s.empty.fire=function(){s.unqueued||l()}),s.unqueued++,u.always(function(){u.always(function(){s.unqueued--,x.queue(e,"fx").length||s.empty.fire()})})),1===e.nodeType&&("height"in t||"width"in t)&&(n.overflow=[p.overflow,p.overflowX,p.overflowY],"inline"===x.css(e,"display")&&"none"===x.css(e,"float")&&(x.support.inlineBlockNeedsLayout&&"inline"!==ln(e.nodeName)?p.zoom=1:p.display="inline-block")),n.overflow&&(p.overflow="hidden",x.support.shrinkWrapBlocks||u.always(function(){p.overflow=n.overflow[0],p.overflowX=n.overflow[1],p.overflowY=n.overflow[2]}));for(r in t)if(i=t[r],Vn.exec(i)){if(delete t[r],o=o||"toggle"===i,i===(f?"hide":"show"))continue;c[r]=d&&d[r]||x.style(e,r)}if(!x.isEmptyObject(c)){d?"hidden"in d&&(f=d.hidden):d=x._data(e,"fxshow",{}),o&&(d.hidden=!f),f?x(e).show():u.done(function(){x(e).hide()}),u.done(function(){var t;x._removeData(e,"fxshow");for(t in c)x.style(e,t,c[t])});for(r in c)a=Zn(f?d[r]:0,r,u),r in d||(d[r]=a.start,f&&(a.end=a.start,a.start="width"===r||"height"===r?1:0))}}function rr(e,t,n,r,i){return new rr.prototype.init(e,t,n,r,i)}x.Tween=rr,rr.prototype={constructor:rr,init:function(e,t,n,r,i,o){this.elem=e,this.prop=n,this.easing=i||"swing",this.options=t,this.start=this.now=this.cur(),this.end=r,this.unit=o||(x.cssNumber[n]?"":"px")},cur:function(){var e=rr.propHooks[this.prop];return e&&e.get?e.get(this):rr.propHooks._default.get(this)},run:function(e){var t,n=rr.propHooks[this.prop];return this.pos=t=this.options.duration?x.easing[this.easing](e,this.options.duration*e,0,1,this.options.duration):e,this.now=(this.end-this.start)*t+this.start,this.options.step&&this.options.step.call(this.elem,this.now,this),n&&n.set?n.set(this):rr.propHooks._default.set(this),this}},rr.prototype.init.prototype=rr.prototype,rr.propHooks={_default:{get:function(e){var t;return null==e.elem[e.prop]||e.elem.style&&null!=e.elem.style[e.prop]?(t=x.css(e.elem,e.prop,""),t&&"auto"!==t?t:0):e.elem[e.prop]},set:function(e){x.fx.step[e.prop]?x.fx.step[e.prop](e):e.elem.style&&(null!=e.elem.style[x.cssProps[e.prop]]||x.cssHooks[e.prop])?x.style(e.elem,e.prop,e.now+e.unit):e.elem[e.prop]=e.now}}},rr.propHooks.scrollTop=rr.propHooks.scrollLeft={set:function(e){e.elem.nodeType&&e.elem.parentNode&&(e.elem[e.prop]=e.now)}},x.each(["toggle","show","hide"],function(e,t){var n=x.fn[t];x.fn[t]=function(e,r,i){return null==e||"boolean"==typeof e?n.apply(this,arguments):this.animate(ir(t,!0),e,r,i)}}),x.fn.extend({fadeTo:function(e,t,n,r){return this.filter(nn).css("opacity",0).show().end().animate({opacity:t},e,n,r)},animate:function(e,t,n,r){var i=x.isEmptyObject(e),o=x.speed(t,n,r),a=function(){var t=er(this,x.extend({},e),o);(i||x._data(this,"finish"))&&t.stop(!0)};return a.finish=a,i||o.queue===!1?this.each(a):this.queue(o.queue,a)},stop:function(e,n,r){var i=function(e){var t=e.stop;delete e.stop,t(r)};return"string"!=typeof e&&(r=n,n=e,e=t),n&&e!==!1&&this.queue(e||"fx",[]),this.each(function(){var t=!0,n=null!=e&&e+"queueHooks",o=x.timers,a=x._data(this);if(n)a[n]&&a[n].stop&&i(a[n]);else for(n in a)a[n]&&a[n].stop&&Jn.test(n)&&i(a[n]);for(n=o.length;n--;)o[n].elem!==this||null!=e&&o[n].queue!==e||(o[n].anim.stop(r),t=!1,o.splice(n,1));(t||!r)&&x.dequeue(this,e)})},finish:function(e){return e!==!1&&(e=e||"fx"),this.each(function(){var t,n=x._data(this),r=n[e+"queue"],i=n[e+"queueHooks"],o=x.timers,a=r?r.length:0;for(n.finish=!0,x.queue(this,e,[]),i&&i.stop&&i.stop.call(this,!0),t=o.length;t--;)o[t].elem===this&&o[t].queue===e&&(o[t].anim.stop(!0),o.splice(t,1));for(t=0;a>t;t++)r[t]&&r[t].finish&&r[t].finish.call(this);delete n.finish})}});function ir(e,t){var n,r={height:e},i=0;for(t=t?1:0;4>i;i+=2-t)n=Zt[i],r["margin"+n]=r["padding"+n]=e;return t&&(r.opacity=r.width=e),r}x.each({slideDown:ir("show"),slideUp:ir("hide"),slideToggle:ir("toggle"),fadeIn:{opacity:"show"},fadeOut:{opacity:"hide"},fadeToggle:{opacity:"toggle"}},function(e,t){x.fn[e]=function(e,n,r){return this.animate(t,e,n,r)}}),x.speed=function(e,t,n){var r=e&&"object"==typeof e?x.extend({},e):{complete:n||!n&&t||x.isFunction(e)&&e,duration:e,easing:n&&t||t&&!x.isFunction(t)&&t};return r.duration=x.fx.off?0:"number"==typeof r.duration?r.duration:r.duration in x.fx.speeds?x.fx.speeds[r.duration]:x.fx.speeds._default,(null==r.queue||r.queue===!0)&&(r.queue="fx"),r.old=r.complete,r.complete=function(){x.isFunction(r.old)&&r.old.call(this),r.queue&&x.dequeue(this,r.queue)},r},x.easing={linear:function(e){return e},swing:function(e){return.5-Math.cos(e*Math.PI)/2}},x.timers=[],x.fx=rr.prototype.init,x.fx.tick=function(){var e,n=x.timers,r=0;for(Xn=x.now();n.length>r;r++)e=n[r],e()||n[r]!==e||n.splice(r--,1);n.length||x.fx.stop(),Xn=t},x.fx.timer=function(e){e()&&x.timers.push(e)&&x.fx.start()},x.fx.interval=13,x.fx.start=function(){Un||(Un=setInterval(x.fx.tick,x.fx.interval))},x.fx.stop=function(){clearInterval(Un),Un=null},x.fx.speeds={slow:600,fast:200,_default:400},x.fx.step={},x.expr&&x.expr.filters&&(x.expr.filters.animated=function(e){return x.grep(x.timers,function(t){return e===t.elem}).length}),x.fn.offset=function(e){if(arguments.length)return e===t?this:this.each(function(t){x.offset.setOffset(this,e,t)});var n,r,o={top:0,left:0},a=this[0],s=a&&a.ownerDocument;if(s)return n=s.documentElement,x.contains(n,a)?(typeof a.getBoundingClientRect!==i&&(o=a.getBoundingClientRect()),r=or(s),{top:o.top+(r.pageYOffset||n.scrollTop)-(n.clientTop||0),left:o.left+(r.pageXOffset||n.scrollLeft)-(n.clientLeft||0)}):o},x.offset={setOffset:function(e,t,n){var r=x.css(e,"position");"static"===r&&(e.style.position="relative");var i=x(e),o=i.offset(),a=x.css(e,"top"),s=x.css(e,"left"),l=("absolute"===r||"fixed"===r)&&x.inArray("auto",[a,s])>-1,u={},c={},p,f;l?(c=i.position(),p=c.top,f=c.left):(p=parseFloat(a)||0,f=parseFloat(s)||0),x.isFunction(t)&&(t=t.call(e,n,o)),null!=t.top&&(u.top=t.top-o.top+p),null!=t.left&&(u.left=t.left-o.left+f),"using"in t?t.using.call(e,u):i.css(u)}},x.fn.extend({position:function(){if(this[0]){var e,t,n={top:0,left:0},r=this[0];return"fixed"===x.css(r,"position")?t=r.getBoundingClientRect():(e=this.offsetParent(),t=this.offset(),x.nodeName(e[0],"html")||(n=e.offset()),n.top+=x.css(e[0],"borderTopWidth",!0),n.left+=x.css(e[0],"borderLeftWidth",!0)),{top:t.top-n.top-x.css(r,"marginTop",!0),left:t.left-n.left-x.css(r,"marginLeft",!0)}}},offsetParent:function(){return this.map(function(){var e=this.offsetParent||s;while(e&&!x.nodeName(e,"html")&&"static"===x.css(e,"position"))e=e.offsetParent;return e||s})}}),x.each({scrollLeft:"pageXOffset",scrollTop:"pageYOffset"},function(e,n){var r=/Y/.test(n);x.fn[e]=function(i){return x.access(this,function(e,i,o){var a=or(e);return o===t?a?n in a?a[n]:a.document.documentElement[i]:e[i]:(a?a.scrollTo(r?x(a).scrollLeft():o,r?o:x(a).scrollTop()):e[i]=o,t)},e,i,arguments.length,null)}});function or(e){return x.isWindow(e)?e:9===e.nodeType?e.defaultView||e.parentWindow:!1}x.each({Height:"height",Width:"width"},function(e,n){x.each({padding:"inner"+e,content:n,"":"outer"+e},function(r,i){x.fn[i]=function(i,o){var a=arguments.length&&(r||"boolean"!=typeof i),s=r||(i===!0||o===!0?"margin":"border");return x.access(this,function(n,r,i){var o;return x.isWindow(n)?n.document.documentElement["client"+e]:9===n.nodeType?(o=n.documentElement,Math.max(n.body["scroll"+e],o["scroll"+e],n.body["offset"+e],o["offset"+e],o["client"+e])):i===t?x.css(n,r,s):x.style(n,r,i,s)},n,a?i:t,a,null)}})}),x.fn.size=function(){return this.length},x.fn.andSelf=x.fn.addBack,"object"==typeof module&&module&&"object"==typeof module.exports?module.exports=x:(e.jQuery=e.$=x,"function"==typeof define&&define.amd&&define("jquery",[],function(){return x}))})(window);function SiteLauncher(settings)
{this.sites={};this.settings=settings;this.blockedNames={};this.blockedNamesArray=[];this.siteOpened=function(id){}
this.siteClosed=function(id){}
this.siteBlocked=function(id){}
this.blockedSiteOpened=function(id){}
var blockedPopupString=GetCookie("blockedPopups");if(blockedPopupString!=null&&blockedPopupString!="")
{this.blockedNamesArray=blockedPopupString.split(',');for(var i=0;i<this.blockedNamesArray.length;i++)
{this.blockedNames[this.blockedNamesArray[i]]=this.blockedNamesArray[i];}}}
SiteLauncher.prototype.open=function(data)
{var site=this.sites[data.windowName];if(this.sites[data.windowName]==null)
{site=new ExternalSite(this.settings);this.sites[data.windowName]=site;this.addSiteListeners(site);site.open(data);}
else
{if(!site.focus())
{site.open(data);}}}
SiteLauncher.prototype.onSiteOpened=function(id)
{$.jSignal.emit(this.siteOpened,id);if(this.blockedNames[id]==id)
{var len=this.blockedNamesArray.length;for(var i=0;i<len;i++)
{if(this.blockedNamesArray[i]==id)
{this.blockedNamesArray.splice(i,1);break;}}
delete this.blockedNames[id];SetCookie("blockedPopups",this.blockedNamesArray.toString(),months*60);$.jSignal.emit(this.blockedSiteOpened,id);}}
SiteLauncher.prototype.onSiteClosed=function(id)
{this.removeSiteReference(id);$.jSignal.emit(this.siteClosed,id);}
SiteLauncher.prototype.onSiteBlocked=function(id)
{this.removeSiteReference(id);$.jSignal.emit(this.siteBlocked,id);if(this.blockedNames[id]==null)
{this.blockedNamesArray.push(id);this.blockedNames[id]=id;SetCookie("blockedPopups",this.blockedNamesArray.toString(),months*60);}}
SiteLauncher.prototype.addSiteListeners=function(site)
{$.jSignal.connect(site,site.opened,this,this.onSiteOpened);$.jSignal.connect(site,site.closed,this,this.onSiteClosed);$.jSignal.connect(site,site.blocked,this,this.onSiteBlocked);}
SiteLauncher.prototype.removeSiteListeners=function(site)
{$.jSignal.disconnect(site,site.opened,this,this.onSiteOpened);$.jSignal.disconnect(site,site.closed,this,this.onSiteClosed);$.jSignal.disconnect(site,site.blocked,this,this.onSiteBlocked);}
SiteLauncher.prototype.removeSiteReference=function(id)
{site=this.sites[id];this.sites[id]=null;delete this.sites[id];this.removeSiteListeners(site);}
SiteLauncher.prototype.closeAll=function()
{for(var s in this.sites)
{this.close(s);}}
SiteLauncher.prototype.close=function(id)
{if(this.sites)
{var site=this.sites[id];site.close();}}
function ExternalSite(settings)
{this.window=null;this.id="";this.timer=null;this.settings=settings;this.data=null;this.openCheckCount=-1;this.popupData=null;this.opened=function(id){}
this.closed=function(id){}
this.blocked=function(id){}}
ExternalSite.prototype.init=function(data)
{var dataList={};if(data.list)
{var listLen=data.list.length;for(var i=0;i<listLen;i++)
{dataList[data.list[i].name]=(data.list[i].value=="null")?"":data.list[i].value;}};if(data.addQueryString)
{var tempQS=(data.safeQueryString)?this.settings.safeQueryString:this.settings.queryString;if(tempQS!="")
{data.url=data.url+((data.url.indexOf("?")==-1)?"?":"&")+tempQS;}}
var urlData=data.url.split("?");if(urlData.length>0&&!data.doPost)
{data.url=urlData[0];if(urlData[1]!=undefined)
{var items=urlData[1].split("&");var len=items.length;for(var i=0;i<len;i++)
{var item=items[i].split("=");if(dataList[item[0].toLowerCase()]==undefined||dataList[item[0].toLowerCase()]==""||dataList[item[0].toLowerCase()]==null)
{dataList[item[0]]=item[1];}}}}
$("#externalsiteLaunchForm").attr("method",data.doPost?"post":"get").attr("action",data.url).empty();for(var s in dataList)
{var value=(dataList[s]=="null")?"":dataList[s];value=(!data.doPost)?encodeString(value):value;$("#externalsiteLaunchForm").append("<input type=\"hidden\" name=\""+s+"\" value=\""+value+"\">");}}
ExternalSite.prototype.open=function(data)
{if(this.openCheckCount==-1)
{this.id=data.windowName;if(this.timer!=null)
{$.jSignal.disconnect(this.timer,this.timer.tick,this,this.doOpenCheck);$.jSignal.disconnect(this.timer,this.timer.tick,this,this.doCloseCheck);this.timer.dispose();this.timer=null;}
if(data.newWindow)
{if(!this.focus())
{this.popupData=data;this.name=this.id+(((1+Math.random())*0x10000)|0).toString(16).substring(1);this.window=createWindow("",this.name,data.winParams);this.openCheckCount=0;this.timer=new Timer();$.jSignal.connect(this.timer,this.timer.tick,this,this.doOpenCheck);this.timer.start(250,5);}}
else
{this.init(data);$("#externalsiteLaunchForm").attr("target",(this.settings.killFramesetOnRelocate=="1"&&!data.doPost)?"_top":"_self");$("#externalsiteLaunchForm").submit();}}}
ExternalSite.prototype.close=function()
{if(this.window!=null)
{this.window.close();}}
ExternalSite.prototype.doOpenCheck=function()
{if(!this.window)
{this.openCheckCount++;}
else
{var isValidDocument=(typeof this.window.document.getElementById!="undefined");if(this.window.innerWidth==0||!isValidDocument)
{this.openCheckCount++;}
else if(isValidDocument)
{this.stopOpenCheck();this.doPopupSubmit();}}
if(this.openCheckCount==5)
{this.stopOpenCheck();$.jSignal.emit(this.blocked,this.id);}}
ExternalSite.prototype.stopOpenCheck=function()
{this.openCheckCount=-1;$.jSignal.disconnect(this.timer,this.timer.tick,this,this.doOpenCheck);this.timer.dispose();this.timer=null;}
ExternalSite.prototype.doPopupSubmit=function()
{this.init(this.popupData);$("#externalsiteLaunchForm").attr("target",this.name);$("#externalsiteLaunchForm").submit();$.jSignal.emit(this.opened,this.id);this.timer=new Timer();$.jSignal.connect(this.timer,this.timer.tick,this,this.doCloseCheck);this.timer.start(100);}
ExternalSite.prototype.doCloseCheck=function()
{if(this.window.closed||this.window.closed==undefined)
{$.jSignal.disconnect(this.timer,this.timer.tick,this,this.doCloseCheck);this.timer.dispose();this.timer=null;$.jSignal.emit(this.closed,this.id);}}
ExternalSite.prototype.focus=function()
{if(this.window)
{if(this.window.closed||this.window.closed==undefined||this.window.focus==undefined)
{this.window=null;return false;}
this.window.focus();return true;}
return false;}
function createWindow(url,name,params)
{var winX=(document.all)?window.screenLeft:window.screenX;var winY=(document.all)?window.screenTop:window.screenY;var winW,winH;var w,h;var wLeft=0;var wTop=0;var paramArr=params.split(",");for(var n=0;n<paramArr.length;n++)
{var tempArr=paramArr[n].split("=");if(tempArr[0].toLowerCase()=="width")
{w=parseInt(tempArr[1]);}
else if(tempArr[0].toLowerCase()=="height")
{h=parseInt(tempArr[1]);}}
if(parseInt(navigator.appVersion)>3)
{if(navigator.appName=="Netscape")
{winW=window.innerWidth;winH=window.innerHeight;}
if(navigator.appName.indexOf("Microsoft")!=-1)
{winW=document.body.offsetWidth;winH=document.body.offsetHeight;}}
wLeft=((winW-w)/2)+winX;if(winH>h)
{wTop=((winH-h)/2)+winY;}
params+=',left='+wLeft+',top='+wTop;var win=window.open(url,name,params);if(win)
{var isChrome18Higher=false;if($.browser.name=='chrome')
{var chromeVersionStr=$.browser.version.toString();var chromeVersionNum=parseInt(chromeVersionStr.substr(0,chromeVersionStr.indexOf('.')+1));if(chromeVersionNum>=18)
{isChrome18Higher=true;}}
if(isChrome18Higher)
{setTimeout(function(){win.moveTo(wLeft,wTop)},100);}
else
{if(winH>h)
{win.moveTo(wLeft,wTop);}}}
return win;}
jQuery.fn.jSignalSignals=function(aObj,aSignal)
{this.signal=aSignal;this.obj=aObj;this.slots=new Array();this.addSlot=function(aObj,aSlot)
{var slot=null;if(jQuery.jSignal.isSignal(aObj)){slot=jQuery.jSignal.getSignal(aSlot);}
else{slot=new jQuery.fn.jSignalSignals(aObj,aSlot);jQuery.jSignal.addSignal(slot);}
this.slots.push(slot);}
this.removeSlot=function(aObj,aSlot)
{if(jQuery.jSignal.isSignal(aSlot)){var slot=jQuery.jSignal.getSignal(aSlot);for(var i=0;i<this.slots.length;i++){if(this.slots[i]==slot){jQuery.jSignal.removeSignal(slot);this.slots.splice(i,1)
if(this.slots.length==0)
this.clean();return true;}}}
else
return false;}
this.clean=function()
{jQuery.jSignal.removeSignal(this);this.signal=null;this.obj=null;this.slots=new Array();}}
jQuery.fn.jSignal=function(){this.mSignals=new Array();this.connect=function(aObj1,aSignal,aObj2,aSlot)
{if(!this.isSignal(aSignal))
this.addSignal(new jQuery.fn.jSignalSignals(aObj1,aSignal));this.getSignal(aSignal).addSlot(aObj2,aSlot);}
this.disconnect=function(aObj1,aSignal,aObj2,aSlot)
{this.getSignal(aSignal).removeSlot(aObj2,aSlot);}
this.addSignal=function(oSignal)
{this.mSignals.push(oSignal);}
this.removeSignal=function(oSignal)
{for(var i=0;i<this.mSignals.length;i++){if(this.mSignals[i]==oSignal)
this.mSignals.splice(i,1);}}
this.isSignal=function(aSignal)
{for(var a in this.mSignals){if(this.mSignals[a].signal==aSignal)
return true;}
return false;}
this.getSignal=function(aSignal)
{for(var a in this.mSignals){if(this.mSignals[a].signal==aSignal)
return this.mSignals[a];}
return null;}
this.emit=function(aSignal)
{for(var i in this.mSignals){if(this.mSignals[i].signal==aSignal){var oSignal=this.mSignals[i];var aStr='';if(arguments.length>1){for(var a=1;a<arguments.length;a++)
aStr+=', arguments['+a+']';}
var sStr='';sStr+='(oSignal.signal).call(oSignal.obj';sStr+=aStr;sStr+=');';sStr+='for(var y in oSignal.slots) {';sStr+='this.emit(oSignal.slots[y].signal'+aStr+');';sStr+='}';eval(sStr);}}}}
jQuery.jSignal=new jQuery.fn.jSignal();(function($){$.browserTest=function(a,z){var u='unknown',x='X',m=function(r,h){for(var i=0;i<h.length;i=i+1){r=r.replace(h[i][0],h[i][1]);}return r;},c=function(i,a,b,c){var r={name:m((a.exec(i)||[u,u])[1],b)};r[r.name]=true;r.version=(c.exec(i)||[x,x,x,x])[3];if(r.name.match(/safari/)&&r.version>400){r.version='2.0';}if(r.name==='presto'){r.version=($.browser.version>9.27)?'futhark':'linear_b';}r.versionNumber=parseFloat(r.version,10)||0;r.versionX=(r.version!==x)?(r.version+'').substr(0,1):x;r.className=r.name+r.versionX;return r;};a=(a.match(/Opera|Navigator|Minefield|KHTML|Chrome/)?m(a,[[/(Firefox|MSIE|KHTML,\slike\sGecko|Konqueror)/,''],['Chrome Safari','Chrome'],['KHTML','Konqueror'],['Minefield','Firefox'],['Navigator','Netscape']]):a).toLowerCase();$.browser=$.extend((!z)?$.browser:{},c(a,/(camino|chrome|firefox|netscape|konqueror|lynx|msie|opera|safari)/,[],/(camino|chrome|firefox|netscape|netscape6|opera|version|konqueror|lynx|msie|safari)(\/|\s)([a-z0-9\.\+]*?)(\;|dev|rel|\s|$)/));$.layout=c(a,/(gecko|konqueror|msie|opera|webkit)/,[['konqueror','khtml'],['msie','trident'],['opera','presto']],/(applewebkit|rv|konqueror|msie)(\:|\/|\s)([a-z0-9\.]*?)(\;|\)|\s)/);$.os={name:(/(win|mac|linux|sunos|solaris|iphone)/.exec(navigator.platform.toLowerCase())||[u])[0].replace('sunos','solaris')};if(!z){$('html').addClass([$.os.name,$.browser.name,$.browser.className,$.layout.name,$.layout.className].join(' '));}};$.browserTest(navigator.userAgent);})(jQuery);(function(t,e,i){function o(i,o,n){var r=e.createElement(i);return o&&(r.id=Z+o),n&&(r.style.cssText=n),t(r)}function n(){return i.innerHeight?i.innerHeight:t(i).height()}function r(t){var e=k.length,i=(A+t)%e;return 0>i?e+i:i}function h(t,e){return Math.round((/%/.test(t)?("x"===e?E.width():n())/100:1)*parseInt(t,10))}function l(t,e){return t.photo||t.photoRegex.test(e)}function s(t,e){return t.retinaUrl&&i.devicePixelRatio>1?e.replace(t.photoRegex,t.retinaSuffix):e}function a(t){"contains"in g[0]&&!g[0].contains(t.target)&&(t.stopPropagation(),g.focus())}function d(){var e,i=t.data(z,Y);null==i?(B=t.extend({},X),console&&console.log&&console.log("Error: cboxElement missing settings object")):B=t.extend({},i);for(e in B)t.isFunction(B[e])&&"on"!==e.slice(0,2)&&(B[e]=B[e].call(z));B.rel=B.rel||z.rel||t(z).data("rel")||"nofollow",B.href=B.href||t(z).attr("href"),B.title=B.title||z.title,"string"==typeof B.href&&(B.href=t.trim(B.href))}function c(i,o){t(e).trigger(i),le.trigger(i),t.isFunction(o)&&o.call(z)}function u(i){q||(z=i,d(),k=t(z),A=0,"nofollow"!==B.rel&&(k=t("."+te).filter(function(){var e,i=t.data(this,Y);return i&&(e=t(this).data("rel")||i.rel||this.rel),e===B.rel}),A=k.index(z),-1===A&&(k=k.add(z),A=k.length-1)),w.css({opacity:parseFloat(B.opacity),cursor:B.overlayClose?"pointer":"auto",visibility:"visible"}).show(),J&&g.add(w).removeClass(J),B.className&&g.add(w).addClass(B.className),J=B.className,B.closeButton?K.html(B.close).appendTo(y):K.appendTo("<div/>"),U||(U=$=!0,g.css({visibility:"hidden",display:"block"}),H=o(se,"LoadedContent","width:0; height:0; overflow:hidden"),y.css({width:"",height:""}).append(H),O=x.height()+C.height()+y.outerHeight(!0)-y.height(),_=b.width()+T.width()+y.outerWidth(!0)-y.width(),D=H.outerHeight(!0),N=H.outerWidth(!0),B.w=h(B.initialWidth,"x"),B.h=h(B.initialHeight,"y"),H.css({width:"",height:B.h}),Q.position(),c(ee,B.onOpen),P.add(L).hide(),g.focus(),B.trapFocus&&e.addEventListener&&(e.addEventListener("focus",a,!0),le.one(re,function(){e.removeEventListener("focus",a,!0)})),B.returnFocus&&le.one(re,function(){t(z).focus()})),m())}function f(){!g&&e.body&&(V=!1,E=t(i),g=o(se).attr({id:Y,"class":t.support.opacity===!1?Z+"IE":"",role:"dialog",tabindex:"-1"}).hide(),w=o(se,"Overlay").hide(),F=t([o(se,"LoadingOverlay")[0],o(se,"LoadingGraphic")[0]]),v=o(se,"Wrapper"),y=o(se,"Content").append(L=o(se,"Title"),S=o(se,"Current"),I=t('<button type="button"/>').attr({id:Z+"Previous"}),R=t('<button type="button"/>').attr({id:Z+"Next"}),M=o("button","Slideshow"),F),K=t('<button type="button"/>').attr({id:Z+"Close"}),v.append(o(se).append(o(se,"TopLeft"),x=o(se,"TopCenter"),o(se,"TopRight")),o(se,!1,"clear:left").append(b=o(se,"MiddleLeft"),y,T=o(se,"MiddleRight")),o(se,!1,"clear:left").append(o(se,"BottomLeft"),C=o(se,"BottomCenter"),o(se,"BottomRight"))).find("div div").css({"float":"left"}),W=o(se,!1,"position:absolute; width:9999px; visibility:hidden; display:none"),P=R.add(I).add(S).add(M),t(e.body).append(w,g.append(v,W)))}function p(){function i(t){t.which>1||t.shiftKey||t.altKey||t.metaKey||t.ctrlKey||(t.preventDefault(),u(this))}return g?(V||(V=!0,R.click(function(){Q.next()}),I.click(function(){Q.prev()}),K.click(function(){Q.close()}),w.click(function(){B.overlayClose&&Q.close()}),t(e).bind("keydown."+Z,function(t){var e=t.keyCode;U&&B.escKey&&27===e&&(t.preventDefault(),Q.close()),U&&B.arrowKey&&k[1]&&!t.altKey&&(37===e?(t.preventDefault(),I.click()):39===e&&(t.preventDefault(),R.click()))}),t.isFunction(t.fn.on)?t(e).on("click."+Z,"."+te,i):t("."+te).live("click."+Z,i)),!0):!1}function m(){var n,r,a,u=Q.prep,f=++ae;$=!0,j=!1,z=k[A],d(),c(he),c(ie,B.onLoad),B.h=B.height?h(B.height,"y")-D-O:B.innerHeight&&h(B.innerHeight,"y"),B.w=B.width?h(B.width,"x")-N-_:B.innerWidth&&h(B.innerWidth,"x"),B.mw=B.w,B.mh=B.h,B.maxWidth&&(B.mw=h(B.maxWidth,"x")-N-_,B.mw=B.w&&B.w<B.mw?B.w:B.mw),B.maxHeight&&(B.mh=h(B.maxHeight,"y")-D-O,B.mh=B.h&&B.h<B.mh?B.h:B.mh),n=B.href,G=setTimeout(function(){F.show()},100),B.inline?(a=o(se).hide().insertBefore(t(n)[0]),le.one(he,function(){a.replaceWith(H.children())}),u(t(n))):B.iframe?u(" "):B.html?u(B.html):l(B,n)?(n=s(B,n),j=e.createElement("img"),t(j).addClass(Z+"Photo").bind("error",function(){B.title=!1,u(o(se,"Error").html(B.imgError))}).one("load",function(){var e;f===ae&&(j.alt=t(z).attr("alt")||t(z).attr("data-alt")||"",B.retinaImage&&i.devicePixelRatio>1&&(j.height=j.height/i.devicePixelRatio,j.width=j.width/i.devicePixelRatio),B.scalePhotos&&(r=function(){j.height-=j.height*e,j.width-=j.width*e},B.mw&&j.width>B.mw&&(e=(j.width-B.mw)/j.width,r()),B.mh&&j.height>B.mh&&(e=(j.height-B.mh)/j.height,r())),B.h&&(j.style.marginTop=Math.max(B.mh-j.height,0)/2+"px"),k[1]&&(B.loop||k[A+1])&&(j.style.cursor="pointer",j.onclick=function(){Q.next()}),j.style.width=j.width+"px",j.style.height=j.height+"px",setTimeout(function(){u(j)},1))}),setTimeout(function(){j.src=n},1)):n&&W.load(n,B.data,function(e,i){f===ae&&u("error"===i?o(se,"Error").html(B.xhrError):t(this).contents())})}var w,g,v,y,x,b,T,C,k,E,H,W,F,L,S,M,R,I,K,P,B,O,_,D,N,z,A,j,U,$,q,G,Q,J,V,X={transition:"elastic",speed:300,fadeOut:300,width:!1,initialWidth:"600",innerWidth:!1,maxWidth:!1,height:!1,initialHeight:"450",innerHeight:!1,maxHeight:!1,scalePhotos:!0,scrolling:!0,inline:!1,html:!1,iframe:!1,fastIframe:!0,photo:!1,href:!1,title:!1,rel:!1,opacity:.9,preloading:!0,className:!1,retinaImage:!1,retinaUrl:!1,retinaSuffix:"@2x.$1",current:"image {current} of {total}",previous:"previous",next:"next",close:"close",xhrError:"This content failed to load.",imgError:"This image failed to load.",open:!1,returnFocus:!0,trapFocus:!0,reposition:!0,loop:!0,slideshow:!1,slideshowAuto:!0,slideshowSpeed:2500,slideshowStart:"start slideshow",slideshowStop:"stop slideshow",photoRegex:/\.(gif|png|jp(e|g|eg)|bmp|ico|webp)((#|\?).*)?$/i,onOpen:!1,onLoad:!1,onComplete:!1,onCleanup:!1,onClosed:!1,overlayClose:!0,escKey:!0,arrowKey:!0,top:!1,bottom:!1,left:!1,right:!1,fixed:!1,data:void 0,closeButton:!0},Y="colorbox",Z="cbox",te=Z+"Element",ee=Z+"_open",ie=Z+"_load",oe=Z+"_complete",ne=Z+"_cleanup",re=Z+"_closed",he=Z+"_purge",le=t("<a/>"),se="div",ae=0,de={},ce=function(){function t(){clearTimeout(h)}function e(){(B.loop||k[A+1])&&(t(),h=setTimeout(Q.next,B.slideshowSpeed))}function i(){M.html(B.slideshowStop).unbind(s).one(s,o),le.bind(oe,e).bind(ie,t),g.removeClass(l+"off").addClass(l+"on")}function o(){t(),le.unbind(oe,e).unbind(ie,t),M.html(B.slideshowStart).unbind(s).one(s,function(){Q.next(),i()}),g.removeClass(l+"on").addClass(l+"off")}function n(){r=!1,M.hide(),t(),le.unbind(oe,e).unbind(ie,t),g.removeClass(l+"off "+l+"on")}var r,h,l=Z+"Slideshow_",s="click."+Z;return function(){r?B.slideshow||(le.unbind(ne,n),n()):B.slideshow&&k[1]&&(r=!0,le.one(ne,n),B.slideshowAuto?i():o(),M.show())}}();t.colorbox||(t(f),Q=t.fn[Y]=t[Y]=function(e,i){var o=this;if(e=e||{},f(),p()){if(t.isFunction(o))o=t("<a/>"),e.open=!0;else if(!o[0])return o;i&&(e.onComplete=i),o.each(function(){t.data(this,Y,t.extend({},t.data(this,Y)||X,e))}).addClass(te),(t.isFunction(e.open)&&e.open.call(o)||e.open)&&u(o[0])}return o},Q.position=function(e,i){function o(){x[0].style.width=C[0].style.width=y[0].style.width=parseInt(g[0].style.width,10)-_+"px",y[0].style.height=b[0].style.height=T[0].style.height=parseInt(g[0].style.height,10)-O+"px"}var r,l,s,a=0,d=0,c=g.offset();if(E.unbind("resize."+Z),g.css({top:-9e4,left:-9e4}),l=E.scrollTop(),s=E.scrollLeft(),B.fixed?(c.top-=l,c.left-=s,g.css({position:"fixed"})):(a=l,d=s,g.css({position:"absolute"})),d+=B.right!==!1?Math.max(E.width()-B.w-N-_-h(B.right,"x"),0):B.left!==!1?h(B.left,"x"):Math.round(Math.max(E.width()-B.w-N-_,0)/2),a+=B.bottom!==!1?Math.max(n()-B.h-D-O-h(B.bottom,"y"),0):B.top!==!1?h(B.top,"y"):Math.round(Math.max(n()-B.h-D-O,0)/2),g.css({top:c.top,left:c.left,visibility:"visible"}),v[0].style.width=v[0].style.height="9999px",r={width:B.w+N+_,height:B.h+D+O,top:a,left:d},e){var u=0;t.each(r,function(t){return r[t]!==de[t]?(u=e,void 0):void 0}),e=u}de=r,e||g.css(r),g.dequeue().animate(r,{duration:e||0,complete:function(){o(),$=!1,v[0].style.width=B.w+N+_+"px",v[0].style.height=B.h+D+O+"px",B.reposition&&setTimeout(function(){E.bind("resize."+Z,Q.position)},1),i&&i()},step:o})},Q.resize=function(t){var e;U&&(t=t||{},t.width&&(B.w=h(t.width,"x")-N-_),t.innerWidth&&(B.w=h(t.innerWidth,"x")),H.css({width:B.w}),t.height&&(B.h=h(t.height,"y")-D-O),t.innerHeight&&(B.h=h(t.innerHeight,"y")),t.innerHeight||t.height||(e=H.scrollTop(),H.css({height:"auto"}),B.h=H.height()),H.css({height:B.h}),e&&H.scrollTop(e),Q.position("none"===B.transition?0:B.speed))},Q.prep=function(i){function n(){return B.w=B.w||H.width(),B.w=B.mw&&B.mw<B.w?B.mw:B.w,B.w}function h(){return B.h=B.h||H.height(),B.h=B.mh&&B.mh<B.h?B.mh:B.h,B.h}if(U){var a,d="none"===B.transition?0:B.speed;H.empty().remove(),H=o(se,"LoadedContent").append(i),H.hide().appendTo(W.show()).css({width:n(),overflow:B.scrolling?"auto":"hidden"}).css({height:h()}).prependTo(y),W.hide(),t(j).css({"float":"none"}),a=function(){function i(){t.support.opacity===!1&&g[0].style.removeAttribute("filter")}var n,h,a=k.length,u="frameBorder",f="allowTransparency";U&&(h=function(){clearTimeout(G),F.hide(),c(oe,B.onComplete)},L.html(B.title).add(H).show(),a>1?("string"==typeof B.current&&S.html(B.current.replace("{current}",A+1).replace("{total}",a)).show(),R[B.loop||a-1>A?"show":"hide"]().html(B.next),I[B.loop||A?"show":"hide"]().html(B.previous),ce(),B.preloading&&t.each([r(-1),r(1)],function(){var i,o,n=k[this],r=t.data(n,Y);r&&r.href?(i=r.href,t.isFunction(i)&&(i=i.call(n))):i=t(n).attr("href"),i&&l(r,i)&&(i=s(r,i),o=e.createElement("img"),o.src=i)})):P.hide(),B.iframe?(n=o("iframe")[0],u in n&&(n[u]=0),f in n&&(n[f]="true"),B.scrolling||(n.scrolling="no"),t(n).attr({src:B.href,name:(new Date).getTime(),"class":Z+"Iframe",allowFullScreen:!0,webkitAllowFullScreen:!0,mozallowfullscreen:!0}).one("load",h).appendTo(H),le.one(he,function(){n.src="//about:blank"}),B.fastIframe&&t(n).trigger("load")):h(),"fade"===B.transition?g.fadeTo(d,1,i):i())},"fade"===B.transition?g.fadeTo(d,0,function(){Q.position(0,a)}):Q.position(d,a)}},Q.next=function(){!$&&k[1]&&(B.loop||k[A+1])&&(A=r(1),u(k[A]))},Q.prev=function(){!$&&k[1]&&(B.loop||A)&&(A=r(-1),u(k[A]))},Q.close=function(){U&&!q&&(q=!0,U=!1,c(ne,B.onCleanup),E.unbind("."+Z),w.fadeTo(B.fadeOut||0,0),g.stop().fadeTo(B.fadeOut||0,0,function(){g.add(w).css({opacity:1,cursor:"auto"}).hide(),c(he),H.empty().remove(),setTimeout(function(){q=!1,c(re,B.onClosed)},1)}))},Q.remove=function(){g&&(g.stop(),t.colorbox.close(),g.stop().remove(),w.remove(),q=!1,g=null,t("."+te).removeData(Y).removeClass(te),t(e).unbind("click."+Z))},Q.element=function(){return t(z)},Q.settings=X)})(jQuery,document,window);var extraPagePostIds=new Array();var popupWindows=new Object();var rubySystemReady=false;var gameID=null;var ret_url=null;var ret_url_encoded=null;var isRedirecting=false;var fcInterval=null;var axProxy=null;var fsProxy=null;var fsProxyOld=null;var storageProxy=null;var siteLaunch=null;var closingSite=false;var resolutionLocked=false;var flashStorageDump=null;var blockedPopupData=null;var showBlockedPopupWarning=true;var javaScriptRoot=this;var genieObj=null;var metricObj=null;var doSetRes=null;var maxWidth=0;var maxHeight=0;var packetId=null;var casinoClosing=false;var flashPlayerVersionString="";var intervalId=null;var previousHash=null;var gameError=false;function clearExtraPagePostVars()
{for(var i=0;i<extraPagePostIds.length;i++)
{$("#_"+extraPagePostIds[i]).remove();}
extraPagePostIds=new Array();}
function externalSiteClosed(id)
{var movref=$("#system")[0];movref.focus();if(movref.popupClosed)
{movref.popupClosed(id);}}
function closePopup(id)
{siteLaunch.close(id);}
function rubyLoaderDoneLoading()
{var loaderRef=$("#system")[0];loaderRef.focus();loaderRef.aspReady();}
function encodeObject(data)
{for(var s in data)
{data[s]=encodeString(data[s]);}
return data;}
function launchPage(args)
{blockedPopupData=null;siteLaunch.open(args);}
function addToPagePostForm(id,value)
{$("#pagePost").append('<input id="_'+id+'" type="hidden" name="'+id+'" value="'+value+'" />');extraPagePostIds.push(id);}
function hashChangeInterval()
{return window.setInterval(function(){if(window.location.hash!=previousHash){previousHash=window.location.hash;if(previousHash=="#MigrationError")
{migrationError();}}},100);}
var JITMigration=false;function migrationError()
{window.location.hash="#RetryMigration";$("#jitContentFrame").css({display:'none'});$('#jitContentFrame').css({"top":"0","left":""+$(window).width(),"opacity":"0","width":"0","height":"0","visibility":"hidden"});$('#jitContentFrame').remove();JITMigration=false;if(intervalId!=null)
{window.clearInterval(intervalId);}
var movref=$("#system")[0];if(movref!=null&&movref.jitMigrationError)
{movref.focus();movref.jitMigrationError();}
setTitle(casinoTitle);}
function launchJITBrandMigration(postValues,url)
{JITMigration=true;var value="";previousHash=window.location.hash;intervalId=hashChangeInterval();var width=$(window).width();$('body').append('<iframe id="jitContentFrame" name="jitContentFrame"  src="" style="border:0px; padding:0px; margin:0px; z-index:4; position:absolute; overflow:hidden; top:0px; left: '+width+'px; height:0px; width:0px; opacity:0;display:block"></iframe>');$('body').append('<form id="jitMigrationForm" action="" method="post" style="margin:0px;"></form>');$("#jitContentFrame").css({display:'block'});$("#jitMigrationForm").attr({action:url,target:"jitContentFrame"});for(var i=0;i<postValues.length;i++)
{value=(postValues[i].value=="null")?"":postValues[i].value;$("#jitMigrationForm").append('<input id="'+postValues[i].name+'" type="hidden" name="'+postValues[i].name+'" value="'+value+'" />');}
var loc=window.location.href;var index=loc.indexOf('#');var clientURL="";if(index>0)
{clientURL=loc.substring(0,index);}
else
{clientURL=loc;}
$("#jitMigrationForm").append('<input id="ClientURL"  type="hidden" name="ClientURL"  value="'+clientURL+'" />');$("#jitContentFrame").load(function()
{$('#jitMigrationForm').remove();});$("#jitMigrationForm")[0].submit();CentredJITMigrationFrame(400,600);}
function CentredJITMigrationFrame(width,height)
{currentheight=height;currentwidth=width;$('#jitContentFrame').css({"width":currentwidth,"height":currentheight,"top":getFrameCentredTOP(height),"left":getFrameCentredLEFT(width),opacity:0,"overflow":"hidden"});$('#jitContentFrame').animate({opacity:1},100,"linear",setJITMigrationListener);}
function getFrameCentredTOP(height){return $(window).height()/2-(parseInt(height)/2);}
function getFrameCentredLEFT(width){return $(window).width()/2-(parseInt(width)/2);}
var theResizeTimer=0;function setJITMigrationListener()
{if(JITMigration)
{clearInterval(theResizeTimer);switch($.browser.name)
{case'msie':case'ie':positionAndResizeFrame(true);break;default:theResizeTimer=setInterval('positionAndResizeFrame();',50);break;}}}
function positionAndResizeFrame(isIE)
{if(JITMigration)
{clearInterval(theResizeTimer);if(!isIE){$("#jitContentFrame").css({"opacity":"0"});}
$('#jitContentFrame').css({"top":getFrameCentredTOP(currentheight),"left":getFrameCentredLEFT(currentwidth)});if(!isIE)
{$("#jitContentFrame").css({"opacity":"1"});}}}
function doUnload()
{clearInterval(fcInterval);if(!closingSite)
{closingSite=true;closeWindow(true);}}
function closeWindow(dontClose)
{closingSite=true;siteLaunch.closeAll();if(dontClose)
{onErrorPageDisplay();}
else
{window.open('','_self','');window.close();}}
function gameNotAvailable()
{closingSite=true;gameError=true;siteLaunch.closeAll();onErrorPageDisplay();}
function placeFaxControl(doRedirect)
{GenerateFlashAXObjectTag("Loader","FAX");onInstalledCheck();isRedirecting=doRedirect;}
function onInstalledCheck()
{FAX_Init();if(FAX_UpToDate&&$("#Loader")[0]!=null)
{clearInterval(fcInterval);axProxy.setControl($("#Loader")[0]);if(isRedirecting)
{$("#contentFrame")[0].contentWindow.redirect();}}}
function onRubySystemReady()
{rubySystemReady=true;if(siteSettings.mpfMode)
{if(mgsCommsLoaded)
{mgsComms.setLocalConnectionId(mgsLcid);}}}
function getUserSetting(data,noEncode)
{data.hascreds="1";if(siteSettings.faxControlAllowed)
{if(siteSettings.faxControlRequired&&FAX_UpToDate||siteSettings.fsControlRequired)
{if(siteSettings.fsControlRequired)
{if(flashStorageDump==null)
{flashStorageDump=storageProxy.getStorageDump();}
data.sUserName=flashStorageDump.getLogUName;data.sReCall=flashStorageDump.getRecall;data.PPUserName=flashStorageDump.getPPUserName;data.PPKey=flashStorageDump.getPPKey;data.UPE=flashStorageDump.getUPE;data.SingleSignOn=flashStorageDump.getSingleSignOn;data.GGUserName=flashStorageDump.getGGUserName;data.GGRecall=flashStorageDump.getGGRecall;data.hascreds=flashStorageDump.getShowSignInDialog;data.GGPracticeOnly=flashStorageDump.getGGPracticeOnly;data.ID4=flashStorageDump.getID4;if(data.sReCall==1)
{data.sID3=flashStorageDump.getID3;}
if(data.GGRecall==1)
{data.GGPassword=flashStorageDump.getGGPassword;}
data.logindialogtype=fsProxy.getGlobalSettingString("logindialogtype");data.lastauthtype=fsProxy.getGlobalSettingString("lastauthtype");data.logindialogtype=fsProxy.getGlobalSettingString("logindialogtype");data.lastauthtype=fsProxy.getGlobalSettingString("lastauthtype");flashStorageDump=null;}
else
{data.sUserName=storageProxy.getValue("LogUName");data.sReCall=storageProxy.getValue("Recall");data.PPUserName=storageProxy.getValue("PPUserName");data.PPKey=storageProxy.getValue("PPKey");data.UPE=storageProxy.getValue("UPE");data.SingleSignOn=storageProxy.getValue("SingleSignOn");data.GGUserName=storageProxy.getValue("GGUserName");data.GGRecall=storageProxy.getValue("GGRecall");data.hascreds=storageProxy.getValue("ShowSignInDialog");data.GGPracticeOnly=storageProxy.getValue("GGPracticeOnly");data.ID4=storageProxy.getValue("ID4");if(data.sReCall==1)
{data.sID3=storageProxy.getValue("ID3");}
if(data.GGRecall==1)
{data.GGPassword=storageProxy.getValue("GGPassword");}}}}
if(!noEncode)
{return encodeObject(data);}
else
{return data;}}
function saveExternalSettings(data)
{if(siteSettings.faxControlAllowed)
{if(siteSettings.faxControlRequired&&FAX_UpToDate||siteSettings.fsControlRequired)
{storageProxy.saveValues(data);}}}
function getUserData(key)
{if(siteSettings.faxControlAllowed)
{if(siteSettings.fsControlRequired)
{return fsProxy.getGlobalSettingString(key);}}
return"";}
function setUserData(key,value)
{if(siteSettings.faxControlAllowed)
{if(siteSettings.fsControlRequired)
{fsProxy.setGlobalSettingString(key,value);}}}
function redirect()
{if(siteSettings.trackingEnabled)
{onAttemptedActivation();}
$("#pagePost")[0].submit();}
function startCasino()
{$("#initialDisplay").css({display:'none'});promptForShortcut();if(siteSettings.faxControlAllowed)
{if(siteSettings.fsControlRequired)
{fsProxy.setValue("MigrationStatus","1");}
storageProxy.setValue("Cookie",bTagSettings.bTag);storageProxy.setValue("Cookie2",bTagSettings.bTag2);storageProxy.setValue("Cookie3",bTagSettings.bTag3);storageProxy.setValue("Cookie4",bTagSettings.bTag4);storageProxy.setValue("Cookie5",bTagSettings.bTag5);}
if(siteSettings.trackingEnabled)
{onAttemptedActivation();onGameInitialized({gameId:gameID});};$("#initialDisplay").css({display:'none'});var loaderMC=startupSettings.systemSwf;var flashvars={};flashvars.widescreen=startupSettings.widescreen;flashvars.allowResolutionLocking=siteSettings.allowResolutionLocking;flashvars.t3game=startupSettings.t3Game;flashvars.defaultFrame=startupSettings.defaultFrame;if(siteSettings.sgiMode)
{if(siteSettings.system.toLowerCase()=="aurora")
{loaderMC=sgiSettings.preloaderSWF_AS3;flashvars.preloaderXML=sgiSettings.preloaderXML;flashvars.sPath=urlSettings.applicationPath+"/";flashvars.topbarSWF=sgiSettings.topbarSWF;flashvars.swfurl="";flashvars.topBarURL=sgiSettings.topbarXML;flashvars.quality=sgiSettings.swfQuality;flashvars.showGameLogo=sgiSettings.showGameLogo;if(sgiSettings.gamesMenuUrl)
{flashvars.topBarXMLFragmentURL1=sgiSettings.gamesMenuUrl;}
flashvars.gameDataParams=playMode=sgiSettings.playMode;flashvars.skip=sgiSettings.skip;flashvars.channel=sgiSettings.skip;flashvars.loggedIn=sgiSettings.token!="";flashvars.gameID=sgiSettings.gameId;flashvars.orbistoken=sgiSettings.token;flashvars.lang=sgiSettings.gameTranslationLang;flashvars.doDefaultFrameAdjustment=sgiSettings.doDefaultFrameAdjustment;}
else
{loaderMC=sgiSettings.preloaderSWF_AS2;flashvars.preloaderXML=sgiSettings.preloaderXML;flashvars.sPath=urlSettings.applicationPath+"/";flashvars.topbarSWF=sgiSettings.topbarSWF;flashvars.swfurl="";flashvars.gameName="RubyLoader";flashvars.topBarURL=sgiSettings.topbarXML;flashvars.quality=sgiSettings.swfQuality;flashvars.showGameLogo=sgiSettings.showGameLogo;if(sgiSettings.gamesMenuUrl)
{flashvars.topBarXMLFragmentURL1=sgiSettings.gamesMenuUrl;}
flashvars.gameDataParams=playMode=sgiSettings.playMode;flashvars.skip=sgiSettings.skip;flashvars.channel=sgiSettings.skip;flashvars.loggedIn=sgiSettings.token!="";flashvars.gameID=sgiSettings.gameId;flashvars.orbistoken=sgiSettings.token;flashvars.lang=sgiSettings.gameTranslationLang;flashvars.initWidth=sgiSettings.initWidth;flashvars.initHeight=sgiSettings.initHeight;flashvars.mgsuser=sgiSettings.mgsUser;};};var params={};params.bgcolor='#000000';if(siteSettings.useRMM||siteSettings.allowBlockedPopupWarning||siteSettings.allowBrandMigration)
{params.wmode='opaque';}
else
{params.wmode=siteSettings.defaultWmode;}
params.align='middle';params.menu='false';params.allowFullScreen='false';params.allowScriptAccess='sameDomain';params.swliveconnect='true';var attributes=new Object();attributes.id='system';attributes.name='system';swfobject.embedSWF(loaderMC,"systemContent","100%","100%",siteSettings.requiredFlashVersion,null,flashvars,params,attributes);};function getWindowSize()
{return $(window).width()+";"+$(window).height();}
var casinoTitle="";function setGameSetting(doRes,gameW,gameH,gameID,title){if(maxWidth!=gameW&&maxHeight!=gameH){doSetRes=(doRes.toLowerCase()=="true");maxWidth=gameW;maxHeight=gameH;setTimeout("onSetGameSetting()",20);}
if(gameID!=undefined){SetCookie("game",gameID);}
casinoTitle=title;setTitle(title);}
function onSetGameSetting(){if(siteSettings.allowResolutionLocking){if(doSetRes){$('#system').attr({width:'100%',height:'100%'});$('#system').css({marginLeft:'0px',marginTop:'0px'});}
setFlashResolution();}}
function setTitle(title)
{if(title!=""&&title!=undefined)
{document.title=title;}
else
{document.title=siteSettings.casinoName;}}
function disableClosePageAlert()
{hasClosePageAlert=false;}
function getExternalSettings()
{var movref=$("#system")[0];if(movref)
{if(!movref.JStoSWFCommsTest)
{flashPlayerUpdateRequired();return;}}
$.ajax({type:"POST",url:"CacheDetection.ashx",cache:false,async:true,success:function(data)
{if(siteSettings.trackingEnabled)
{onCacheDetection(data);}}});if(siteSettings.allowResolutionLocking)
{setFlashResolution();}
var data=new Object();data.isSGI=siteSettings.sgiMode;data.isMgsTopBar=siteSettings.isMgsTopBar;data.isMgsDecoupled=siteSettings.isMgsDecoupled;data.sessionID=startupSettings.xmanSessionId;data.sessionNumber=startupSettings.xmanSessionNumber;data.sessionToken=startupSettings.xmanSessionToken;data.sessionUserId=startupSettings.extSessionUserid;data.authType=startupSettings.extAuthType;data.debug=siteSettings.debug?"true":"false";data.debugType=startupSettings.debuggerType;data.debugLevels=startupSettings.debugLevelsFile;data.baseURL=urlSettings.baseUrlPath;data.basePath=urlSettings.basePath;data.sEXT1=startupSettings.extUsername;data.sEXT2=startupSettings.extPassword;data.gameType=startupSettings.gameType;data.gameID=startupSettings.gameId;data.extGameID=startupSettings.extGameId;data.cid=startupSettings.cid;data.mid=startupSettings.mid;data.frameType=startupSettings.frameType;data.csvAddButtons=startupSettings.addButtons;data.csvRemoveButtons=startupSettings.removeButtons;data.loginType=startupSettings.loginType;data.serverID=siteSettings.serverId;data.demoServerID=siteSettings.demoServerId;data.return_url=startupSettings.extReturnUrl;data.brandConfig=startupSettings.configFile;data.displayConfig=startupSettings.displayConfigFile;data.preloaderURL=startupSettings.preloaderFile;data.preloaderType=startupSettings.preloaderType;data.platformID=siteSettings.clientType;data.enableBonusBubble=siteSettings.enableBonusBubble;data.bonusBubbleType=siteSettings.bonusBubbleType;data.BTAG=bTagSettings.bTag;data.BTAG2=bTagSettings.bTag2;data.BTAG3=bTagSettings.bTag3;data.BTAG4=bTagSettings.bTag4;data.BTAG5=bTagSettings.bTag5;data.safeExtReturnURL=urlSettings.casinoSafeUrl;data.fullExtReturnURL=urlSettings.casinoFullUrl;data.nUserType=startupSettings.userType;data.AuthToken=startupSettings.authToken;data.casinoMute=startupSettings.muteSound;data.launchInFunMode=startupSettings.launchInFunMode;data.mpTourID=startupSettings.mpTournamentID;data.mpServiceID=startupSettings.mpServiceID;data.extGamelist=startupSettings.extGamelist;data.casinoLanguage=siteSettings.language;data.autoLogin=startupSettings.autoLogin;data.ipAddress=startupSettings.userIp;data.hGames=startupSettings.hGames;data.theme=siteSettings.theme;data.variant=siteSettings.variant;data.regMarket=siteSettings.regMarket;data.ul=siteSettings.language;data.applicationPath=urlSettings.applicationPath+"/";data.isQuickRedirect=startupSettings.isQuickRedirect;data.participationCode=startupSettings.participationCode;data.incompleteGamesShowing=startupSettings.incompleteGamesShowing;data.externalReturn=startupSettings.externalReturn;data.reverseProxy=siteSettings.reverseProxy;data.topbarReflectionRulesURL=siteSettings.topbarReflectionURL;data.mpfRequired=siteSettings.mpfRequired;data.MenuConfigXML=startupSettings.MenuConfigXML;data.MenuArtFile=startupSettings.MenuArtFile;data.BrandingOverlayName=startupSettings.BrandingOverlayName;data.FrameLibName=startupSettings.FrameLibName;data.PlayForRealfile=startupSettings.PlayForRealfile;data.DiagCompFile=startupSettings.DiagCompFile;data.UCSfile=startupSettings.UCSfile;data.flyoutxml=startupSettings.flyoutxml;data.displayconfigxml=startupSettings.displayconfigxml;data.extmig=startupSettings.extMigration;data.autoShowLogin=startupSettings.autoShowLogin;data.openAppAfterLogin=startupSettings.openAppAfterLogin;data.NotifierId=startupSettings.NotifierId;data.customheadervalue=startupSettings.customheadervalue;data.widescreen=startupSettings.widescreen;data.t3game=startupSettings.T3Game;data.defaultFrame=startupSettings.defaultFrame;data.browserVersion=$.browser.name+"_"+$.browser.version.match(/\d+\.\d+/);data.preloaderText=startupSettings.preloaderText;data.enablePerformanceRating=startupSettings.enablePerformanceRating;data.numberOfIterations=startupSettings.numberOfIterations;data.hidevalueadds=startupSettings.hideValueAdds;data.showvalueadds=startupSettings.showValueAdds;if(siteSettings.sgiMode){data.doDefaultFrameAdjustment=sgiSettings.doDefaultFrameAdjustment;}
if(siteSettings.trackingEnabled)
{data.pcmGUID=genieObj.getCurrentGuid();}
data.ID1="";data.ID2="";data.ID4="0";if(siteSettings.faxControlAllowed)
{if(siteSettings.faxControlRequired&&FAX_UpToDate||siteSettings.fsControlRequired)
{if(siteSettings.fsControlRequired)
{flashStorageDump=storageProxy.getStorageDump();data.ID1=flashStorageDump.getID1;data.ID2=flashStorageDump.getID2;data.ID4=flashStorageDump.getID3;}
else
{data.ID1=storageProxy.getValue("ID1");data.ID2=storageProxy.getValue("ID2");data.ID4=storageProxy.getValue("ID4");}
data.sUserName="";data.sID3="";data.sReCall="0";data.PPUserName="";data.PPKey="";data.UPE="";data.GGUserName="";data.GGPassword="";data.GGRecall="";data.hascreds="1";data.GGPracticeOnly="";data.SingleSignOn="0";}}
else
{data.ID4="2";}
data=getUserSetting(data,true);return encodeObject(data);}
function onMissingSystemFile(filename)
{clearExtraPagePostVars();$("#pagePost").attr({action:"Error.aspx",target:"contentFrame"});addToPagePostForm("fileName",filename);addErrorPostParameters();swfobject.removeSWF("system");$("#contentFrame").load(function()
{$("#pageContent").css({display:'block'});});$("#contentFrame").css({width:'100%',height:'100%'});$("#pagePost")[0].submit();}
function addErrorPostParameters()
{addToPagePostForm("returnUrl",urlSettings.casinoErrorReturnUrl);addToPagePostForm("returnTarget","_parent");addToPagePostForm("casinoName",siteSettings.casinoName);addToPagePostForm("browserType",$.browser.name);addToPagePostForm("browserVersion",$.browser.versionX);addToPagePostForm("platform",$.os.name);addToPagePostForm("downloadURL",startupSettings.standaloneDownloadUrl);addToPagePostForm("ul",siteSettings.language);addToPagePostForm("theme",siteSettings.theme);addToPagePostForm("variant",siteSettings.variant);addToPagePostForm("regMarket",siteSettings.regMarket);addToPagePostForm("system",siteSettings.system);addToPagePostForm("protocolPrefix",startupSettings.protocolPrefix);}
function promptForShortcut()
{if(siteSettings.faxControlAllowed&&siteSettings.faxControlRequired&&FAX_UpToDate)
{if(siteSettings.enableDefaultShortcut)
{axProxy.setValue("szDialogueText",aspStrings.SHORCUT_TEXT);axProxy.setValue("szDialogueTitle",aspStrings.SHORCUT_TITLE);axProxy.setValue("szURL",startupSettings.defaultShortcutURL);axProxy.createShortcut(0);};axProxy.doMigrationIfRequired();};};function setFlashResolution()
{if($('#system')[0]!=null)
{if(doSetRes){if($(window).width()>=maxWidth&&$(window).height()>=maxHeight){resolutionLocked=true;}
else if($('#system').width()<=maxWidth||$(window).height()<=maxHeight){resolutionLocked=false;}}
else if($(window).width()>maxWidth&&$(window).height()>maxHeight){if($('#system').width()!=maxWidth){$('#system').attr({width:maxWidth+'px',height:maxHeight+'px'});}
$('#system').css({marginLeft:(($(window).width()-maxWidth)/2)+'px',marginTop:(($(window).height()-maxHeight)/2)+'px'});resolutionLocked=true;}
else if($('#system').width()>=maxWidth){resolutionLocked=false;$('#system').attr({width:'100%',height:'100%'});$('#system').css({marginLeft:'0px',marginTop:'0px'});}}}
function sessionRefresh(){$.ajax({type:"GET",url:"sessionrefresh.ashx",cache:false});}
function guidCreated(guid)
{if($("#pagePost").attr("action").toLowerCase()=="error.aspx"&&$("#pageContent").css("display")=="block")
{setErrorPageGuid(guid);}}
function setErrorPageGuid(guid)
{if($("#contentFrame")[0].contentWindow.setGuid)
{$("#contentFrame")[0].contentWindow.setGuid(pcmSettings.paramName,guid);}}
function setResizeEvents()
{if(siteSettings.allowResolutionLocking&&(!siteSettings.useRMM)&&(!siteSettings.useOpenId)){$(window).resize(function(){setFlashResolution();resizeBankSlider();setJITMigrationListener();});}
else if(siteSettings.allowResolutionLocking&&siteSettings.useRMM&&(!siteSettings.useOpenId)){$(window).resize(function(){setFlashResolution();resizeBankSlider();resizeRMM();setJITMigrationListener();});}
else if(siteSettings.allowResolutionLocking&&siteSettings.useRMM&&siteSettings.useOpenId){$(window).resize(function(){setOpenIDResizeListener();setFlashResolution();resizeBankSlider();resizeRMM();setJITMigrationListener();});}
else if((!siteSettings.allowResolutionLocking)&&siteSettings.useRMM&&siteSettings.useOpenId){$(window).resize(function(){setOpenIDResizeListener();resizeBankSlider();resizeRMM();setJITMigrationListener();});}
else if((!siteSettings.allowResolutionLocking)&&(!siteSettings.useRMM)&&siteSettings.useOpenId){$(window).resize(function(){setOpenIDResizeListener();resizeBankSlider();setJITMigrationListener();});}}
$(document).ready(function()
{if(!siteSettings.isMgsDecoupled)
{siteReady();}});function siteReady()
{gameID=startupSettings.gameId;SetCookie("game",gameID);doSetRes=((startupSettings.widescreen.toLowerCase()=="true")||(startupSettings.t3Game.toLowerCase()=="true"))
maxWidth=siteSettings.maxWidth;maxHeight=siteSettings.maxHeight;var sessionRefreshInterval;sessionRefreshInterval=setInterval("sessionRefresh();",1000*60*15);if(siteSettings.sgiMode)
{ret_url=sgiSettings.returnUrl;ret_url_encoded=sgiSettings.returnUrlEncoded;}
setResizeEvents();var siteLaunchSettings=new Object();siteLaunchSettings.pleaseWaitText=aspStrings.PLEASE_WAIT_TEXT;siteLaunchSettings.queryString=urlSettings.queryString;siteLaunchSettings.safeQueryString=urlSettings.safeQueryString;siteLaunchSettings.killFramesetOnRelocate=startupSettings.killFramesetOnRelocate;siteLaunch=new SiteLauncher(siteLaunchSettings);$.jSignal.connect(siteLaunch,siteLaunch.siteClosed,javaScriptRoot,javaScriptRoot.externalSiteClosed);$.jSignal.connect(siteLaunch,siteLaunch.siteBlocked,javaScriptRoot,javaScriptRoot.popupBlocked);$.jSignal.connect(siteLaunch,siteLaunch.blockedSiteOpened,javaScriptRoot,javaScriptRoot.blockedPopupOpened);if(siteSettings.faxControlAllowed)
{storageProxy=new StorageProxy();if(siteSettings.faxControlRequired)
{axProxy=new AXProxy();axProxy.setRegistryName(siteSettings.regCasinoName);axProxy.setOldRegistryName(siteSettings.oldRegCasinoName);storageProxy.useActiveXControl(true);storageProxy.setActiveXControl(axProxy);}
if(siteSettings.fsControlRequired)
{fsProxy=new FSProxy();fsProxy.setRegistryName(siteSettings.regCasinoName);fsProxy.setOldRegistryName(siteSettings.oldRegCasinoName);fsProxy.setResetShortCut(siteSettings.resetShortCut);fsProxy.setMigrationStatus(siteSettings.migrationStatus);storageProxy.useFlashControl(true);storageProxy.setFlashControl(fsProxy);}}
if(siteSettings.faxControlAllowed&&siteSettings.faxControlRequired)
{FAX_Init();};var version=getFullFlashPlayerVersion();if(version==null)
{version=swfobject.getFlashPlayerVersion();}
flashPlayerVersionString=version["major"]+'.'+version["minor"]+'.'+version["release"];if(version["build"]!=null)
{flashPlayerVersionString+=('.'+version["build"]);}
var isRedirecting=false;$("#initialDisplay").css({display:'none'});var unsupportedBrowser=false;var browserName=$.browser.name;var osName=$.os.name;switch($.browser.name)
{case'msie':case'ie':{var ieversion=$.browser.version;if(ieversion==7)
{doExtCall=true;}
$.browser.name='ie';browserName=$.browser.name;if(ieversion<10)
{unsupportedBrowser=($.browser.versionX<6)||($.os.name!='win');}
break;};case'firefox':{unsupportedBrowser=($.os.name!='win')&&siteSettings.faxControlRequired&&!siteSettings.fsControlRequired;break;};case'opera':{if(opera)
{unsupportedBrowser=(opera.version()<9)||siteSettings.faxControlRequired&&!siteSettings.fsControlRequired;$.browser.version=opera.version();}
else
{unsupportedBrowser=($.browser.versionX<9)||siteSettings.faxControlRequired&&!siteSettings.fsControlRequired;}
break;};case'safari':{doExtCall=true;unsupportedBrowser=($.browser.versionX<2)||siteSettings.faxControlRequired&&!siteSettings.fsControlRequired;break;};case'chrome':{doExtCall=true;break;}
default:{doExtCall=true;browserName="";osName="";unsupportedBrowser=siteSettings.faxControlRequired&&!siteSettings.fsControlRequired;break;};};if(siteSettings.trackingEnabled)
{genieObj=new Genie();genieObj.data.currentGUID=pcmSettings.pcmGuid;genieObj.data.casinoId=siteSettings.serverId;genieObj.data.clientTypeId=siteSettings.clientType;genieObj.data.browserLang=startupSettings.browserLang;genieObj.data.clientLang=siteSettings.language;genieObj.data.btag=bTagSettings.bTag;genieObj.data.browser=$.browser.name+' browser '+$.browser.version+' ('+$.layout.name+' layout engine '+$.layout.version+')';genieObj.data.os=$.os.name;genieObj.data.ipAddress=startupSettings.userIp;if(version["major"]>0)
{genieObj.data.flashPlayerVersion=flashPlayerVersionString;};$.jSignal.connect(genieObj,genieObj.guidCreated,javaScriptRoot,javaScriptRoot.guidCreated);genieObj.createGuid();};if(siteSettings.statsServiceEnabled)
{metricObj=new StatsMetric();if((siteSettings.serverId=="")||(siteSettings.serverId==null))
{metricObj.data.serverId="unknown";}
else
{metricObj.data.serverId=siteSettings.serverId;}}
if(unsupportedBrowser)
{isRedirecting=true;$("#pagePost").attr({action:"Error.aspx",target:"contentFrame"});clearExtraPagePostVars();addToPagePostForm("errorType","unsupportedBrowser");addErrorPostParameters();$("#contentFrame").load(function()
{$("#pageContent").css({display:'block',height:'100%'});if(siteSettings.trackingEnabled)
{if(genieObj.data.currentGUID!="")
{setErrorPageGuid(genieObj.data.currentGUID);}
onFailedActivation('Browser is not supported.');}});$("#contentFrame").css({width:'100%',height:'100%'});redirect();}
if(!useCookies&&!isRedirecting)
{isRedirecting=true;$("#pagePost").attr({action:"Error.aspx",target:"contentFrame"});clearExtraPagePostVars();addToPagePostForm("errorType","noCookies");addErrorPostParameters();$("#contentFrame").load(function()
{$("#pageContent").css({display:'block',height:'100%'});if(siteSettings.trackingEnabled)
{if(genieObj.data.currentGUID!="")
{setErrorPageGuid(genieObj.data.currentGUID);}
onFailedActivation('Browser does not support the use of cookies, or cookies are disabled. Cookie support is required');}});$("#contentFrame").css({width:'100%',height:'100%'});redirect();}
if(siteSettings.allowBlockedPopupWarning&&!isRedirecting)
{$.ajax({type:"POST",url:"Strings.ashx",data:"id=BLOCKED_POPUP"+((osName!="")?("_"+osName.toUpperCase()):"")+((browserName!="")?("_"+browserName.toUpperCase()):""),cache:false,context:this,success:function(data)
{$("#blockedPopupPromptInstructions").html(data);}});}
if(siteSettings.faxControlAllowed&&!isRedirecting)
{if(siteSettings.faxControlRequired&&!FAX_UpToDate&&!siteSettings.fsControlRequired)
{isRedirecting=true;clearExtraPagePostVars();$("#pagePost").attr({action:"Error.aspx",target:"contentFrame"});addToPagePostForm("errorType","fraud");addErrorPostParameters();$("#contentFrame").load(function()
{$("#pageContent").css({display:'block',height:'100%'});if(siteSettings.trackingEnabled)
{if(genieObj.data.currentGUID!="")
{setErrorPageGuid(genieObj.data.currentGUID);}
if(FAX_Installed)
{onFailedActivation('Current ActiveX component needs to be upgraded.');}
else
{onFailedActivation('No ActiveX component installed.');}}
fcInterval=setInterval('onInstalledCheck();',250);placeFaxControl(true);});$("#contentFrame").css({width:'100%',height:'100%'});redirect();}}
if(!isRedirecting)
{$("html").css("overflow","hidden");var versionRequired=siteSettings.flashOCXContentVersion+"."+siteSettings.flashOCXMajorRevision+"."+siteSettings.flashOCXMinorRevision;if(swfobject.hasFlashPlayerVersion(versionRequired))
{if(siteSettings.faxControlAllowed)
{if(siteSettings.faxControlRequired&&FAX_UpToDate)
{placeFaxControl();}
if(siteSettings.fsControlRequired)
{placeFSControl("vault",vaultSettings.domain,"fsContent");}
else
{startCasino();}}
else
{startCasino();}}
else
{isRedirecting=true;$("#pagePost").attr({action:"FlashError.aspx",target:"contentFrame"});clearExtraPagePostVars();addToPagePostForm("errorType","flash");addToPagePostForm("flashOCXVersion",siteSettings.requiredFlashVersion);addToPagePostForm("flashPlayerDownloadURL",siteSettings.flashPlayerDownloadUrl);addErrorPostParameters();if(version["major"]>0)
{addToPagePostForm("type","upgrade");}
$("#contentFrame").load(function()
{$("#pageContent").css({display:'block',height:'100%'});if(siteSettings.trackingEnabled)
{if(genieObj.data.currentGUID!="")
{setErrorPageGuid(genieObj.data.currentGUID);}
if(version["major"]>0)
{onFailedActivation('The version of the Adobe Flash player needs an upgrade.');}
else
{onFailedActivation('Need to install the Adobe Flash Player.');}}});$("#contentFrame").css({width:'100%',height:'100%',overflow:'auto',float:'left'});$("#contentFrame").css('min-width','800px');$("#contentFrame").css('min-height','600px');redirect();}}}
function placeFSControl(id,domain,divId)
{var flashvars={};var params={menu:"false",scale:"noScale",allowFullscreen:"true",allowScriptAccess:"always",swliveconnect:'true',bgcolor:"#000000"};var attributes={id:id};var path=startupSettings.protocolPrefix+domain+"/vault/vault.swf";swfobject.embedSWF(path,divId,"1","1","10.0.0",null,flashvars,params,attributes);if($.browser.name=="firefox"&&$.browser.version>24)
{loadVaultTimer=window.setTimeout(firefoxflashPlayerBlocked,3000);}}
function Vault_Ready()
{if($.browser.name=="firefox"&&$.browser.version>24)
{if($.colorbox!=null){$.colorbox.close();}
if(loadVaultTimer!=null){clearTimeout(loadVaultTimer);}}
var szPolicy="";try
{var vault=new MGS_Vault(swfobject.getObjectById((fsProxyOld==null)?"vault":"vaultOld"),siteSettings.regCasinoName,siteSettings.gamingGroupName,szPolicy);if(fsProxyOld==null)
{fsProxy.setControl(vault);if(siteSettings.faxControlRequired&&FAX_UpToDate)
{promptForShortcut();storageProxy.doMigration();}
if(fsProxy.canWeCopy()&&(vaultSettings.oldDomain!=""))
{fsProxyOld=new FSProxy();fsProxyOld.setRegistryName(siteSettings.regCasinoName);placeFSControl("vaultOld",vaultSettings.oldDomain,"fsContentOld");return;}}
else
{fsProxyOld.setControl(vault);fsProxy.doCopy(fsProxyOld);}
var doPrompt=(!(siteSettings.faxControlRequired&&FAX_UpToDate)&&fsProxy.canWePromptForShortcut()&&siteSettings.enableDefaultShortcut&&$.os.name=='win');(doPrompt)?promptForNewShortcut():startCasino();}
catch(e)
{flashPlayerUpdateRequired();}}
function promptForNewShortcut()
{setTimeout("doShortCutDisplay()",300);}
function doShortCutDisplay()
{$.colorbox({inline:true,href:"#shortcutPrompt",transition:"fade",opacity:0.5,speed:200,overlayClose:false,maxWidth:"510px",onClosed:function(){onShortCutClose();}});$('#eulaLink')[0].href=siteSettings.eulaUrl;$("#shortcutNo").click(function()
{$.colorbox.close();});$("#shortcutYes").click(function()
{$("#shotcutForm")[0].submit();$.colorbox.close();});}
function onShortCutClose()
{setTimeout("startCasino()",100);}
function onErrorPageDisplay()
{setTimeout("showErrorPage()",500);}
function showErrorPage()
{if(!browserUnloadEvent)
{isRedirecting=true;$("#pagePost").attr({action:"Error.aspx",target:"contentFrame"});clearExtraPagePostVars();if(gameError)
{addToPagePostForm("errorType","gameNotAvailable");}
else
{addToPagePostForm("errorType","failedWindowClose");}
addErrorPostParameters();$("#contentFrame").load(function()
{$("#pageContent").css({display:'block',height:'100%'});if(siteSettings.trackingEnabled)
{if(genieObj.data.currentGUID!="")
{setErrorPageGuid(genieObj.data.currentGUID);}
onFailedActivation('The player will be required to manually close the page');}});$("#contentFrame").css({width:'100%',height:'100%'});redirect();}}
function popupBlocked(id)
{if(siteSettings.allowBlockedPopupWarning)
{if(showBlockedPopupWarning)
{$.colorbox({inline:true,href:"#blockedPopupPrompt",transition:"fade",opacity:0.7,speed:200,overlayClose:false,maxWidth:"500px",onClosed:function()
{onPopupBlockedDialogClosed(showBlockedPopupWarning);}});$("#dontShowCheck").click(function()
{showBlockedPopupWarning=$("#dontShowCheck").attr("checked")==false;});$("#blockedPopupOk").click(function()
{$.colorbox.close();});}
if(siteSettings.trackingEnabled)
{onPopupBlocked(id,showBlockedPopupWarning);}}}
function blockedPopupOpened(id)
{if(siteSettings.trackingEnabled&&siteSettings.allowBlockedPopupWarning)
{onPopupAllowed(id);}}
function launchExternalSite(args,exornot)
{var argsObj=new Object();parseGenArgsToObject(args.toString(),"~^~",argsObj,exornot);siteLaunch.open(argsObj);}
function getGameWideScreen()
{return $("#system")[0].getGameWideScreen();}
function setAVM1lcid(lcid)
{this._avm1lcid=lcid;}
function getAVM1lcid()
{return this._avm1lcid;}
function setFullOSVersion(osVersionString)
{if(genieObj!=null)
{genieObj.data.os=osVersionString;}}
function getFullFlashPlayerVersion()
{if(typeof window.ActiveXObject!="undefined")
{try
{var a=new ActiveXObject("ShockwaveFlash.ShockwaveFlash");if(a)
{var d=a.GetVariable("$version");if(d)
{d=d.split(" ")[1].split(",");return{"major":parseInt(d[0],10),"minor":parseInt(d[1],10),"release":parseInt(d[2],10),"build":parseInt(d[3],10)};}}}
catch(e)
{return null;}}
return null;}
function flashPlayerUpdateRequired()
{var appVersionRegex=/.*windows nt (\d+.?\d*).*/g;var appVersionArr=appVersionRegex.exec(navigator.appVersion.toLowerCase());if(appVersionArr!=null)
{var windowsVersion=(appVersionArr[1]!=null)?parseFloat(appVersionArr[1]):null;var windowsUpdate=(windowsVersion!=null)&&(!isNaN(windowsVersion))&&(windowsVersion>=6.2)&&(navigator.appName.toLowerCase().indexOf("microsoft internet explorer")>=0);}
clearExtraPagePostVars();$("#pagePost").attr({action:"Error.aspx",target:"contentFrame"});if(windowsUpdate)
{addToPagePostForm("errorType","windowsUpdateRequired");}
else
{addToPagePostForm("errorType","flashPlayerUpdateRequired");}
addErrorPostParameters();swfobject.removeSWF("system");$("#contentFrame").load(function()
{$("#pageContent").css({display:'block',height:'100%'});if(siteSettings.trackingEnabled)
{if(genieObj.data.currentGUID!="")
{setErrorPageGuid(genieObj.data.currentGUID);}
var customStepFailureString="Flash Player Update Required";if(windowsUpdate)
{customStepFailureString="Windows Update Required";}
customStepFailureString+=(" - "+flashPlayerVersionString);onFailedActivation(customStepFailureString);}});$("#contentFrame").css({width:'100%',height:'100%'});$("#pagePost")[0].submit();}
function firefoxflashPlayerBlocked()
{$.colorbox({inline:true,href:"#blockedFlashPlugin",transition:"fade",opacity:0.7,speed:200,overlayClose:false,maxWidth:"500px",onOpen:function()
{$("#colorbox").fadeTo(0,0);},onClosed:function()
{onPopupBlockedDialogClosed(showBlockedPopupWarning);}});$("#blockedPluginOk").click(function()
{$.colorbox.close();});}
function setPageCloseAlertText(alertText,finalText)
{this.alertText=alertText;this.finalText=finalText;}
function sendXmanPacket(data)
{this.packetId=data.packetid;$.ajax({type:"POST",url:data.url,data:data.payload,cache:false,async:false,reference:this,success:function(data)
{this.reference.onXmanResponse(data);}});}
function onXmanResponse(payload)
{var movref=$("#system")[0];movref.focus();if(movref.onJSPacketReturn)
{var data={packetid:this.packetId,payload:payload};movref.onJSPacketReturn(data);}}
var extsid="";function setExtSid(sessionId)
{extsid=sessionId;}
function closeSession()
{var data='<Pkt><Id mid="1" cid="10001" sid="'+siteSettings.serverId.toString()+'" verb="Logout" sessionid="'+extsid.toString()+'" clientLang="en"/><Request/></Pkt>';var url=startupSettings.targetUrl;if($.browser.msie&&window.XDomainRequest){var xdr=new XDomainRequest();xdr.timeout=1000;xdr.open("POST",url,true);xdr.send(data);}
else if(($.browser.msie&&parseInt($.browser.version,10)===7))
{var sysFlashMovie=$('#system')[0];sysFlashMovie.focus();sysFlashMovie.attemptLogoutCloseGame(false);}
else{var xmlhttp=new XMLHttpRequest();xmlhttp.open("POST",url,true);xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");xmlhttp.setRequestHeader("Content-length",data.length.toString());xmlhttp.send(data);}}
function onCasinoClosing()
{if(!casinoClosing)
{casinoClosing=true;if(siteSettings.statsServiceEnabled)
{onBrowserCloseMetric(false);}
if(siteSettings.trackingEnabled)
{onBrowserClose(false);}}}
function loadjscssfile(filename,filetype)
{if(filetype=="js")
{var fileReference=document.createElement('script');fileReference.setAttribute("type","text/javascript");fileReference.setAttribute("src",filename);}
else if(filetype=="css")
{var fileReference=document.createElement("link");fileReference.setAttribute("rel","stylesheet");fileReference.setAttribute("type","text/css");fileReference.setAttribute("href",filename);}
if(typeof fileReference!="undefined")
document.getElementsByTagName("head")[0].appendChild(fileReference);}
Function.prototype.extend=function(Child,Parent)
{var F=function(){};F.prototype=Parent.prototype;Child.prototype=new F();Child.prototype.constructor=Child;Child.prototype.uber=Parent.prototype;}
function openWindow(url,name,params)
{var winX=(document.all)?window.screenLeft:window.screenX;var winY=(document.all)?window.screenTop:window.screenY;var winW,winH;var w,h;var wLeft=0;var wTop=0;var paramArr=params.split(",");for(var n=0;n<paramArr.length;n++)
{var tempArr=paramArr[n].split("=");if(tempArr[0].toLowerCase()=="width")
{w=parseInt(tempArr[1]);}
else if(tempArr[0].toLowerCase()=="height")
{h=parseInt(tempArr[1]);}}
if(parseInt(navigator.appVersion)>3)
{if(navigator.appName=="Netscape")
{winW=window.innerWidth;winH=window.innerHeight;}
if(navigator.appName.indexOf("Microsoft")!=-1)
{winW=document.body.offsetWidth;winH=document.body.offsetHeight;}}
wLeft=((winW-w)/2)+winX;wTop=((winH-h)/2)+winY;params+=',left='+wLeft+',top='+wTop;var win=window.open(url,name,params);if(win)
{var isChrome18Higher=false;if($.browser.name=='chrome')
{var chromeVersionStr=$.browser.version.toString();var chromeVersionNum=parseInt(chromeVersionStr.substr(0,chromeVersionStr.indexOf('.')+1));if(chromeVersionNum>=18)
{isChrome18Higher=true;}}
if(isChrome18Higher)
{setTimeout(function(){win.moveTo(wLeft,wTop)},100);}
else
{win.moveTo(wLeft,wTop);}}
return win;}
var seconds=1000,minutes=60*1000,hours=60*60*1000,days=24*60*60*1000,weeks=7*24*60*60*1000,months=30*24*60*60*1000;var useCookies=true;function cookieCheck()
{DeleteCookie("CookieTest");SetCookie("CookieTest","CookieTest",months*6);var tmp=GetCookie("CookieTest");var cookiesEnabled=tmp=="CookieTest";if(cookiesEnabled)
{return true;}
return false;}
useCookies=cookieCheck();function getCookieVal(offset)
{var endstr=document.cookie.indexOf(";",offset);if(endstr==-1)
{endstr=document.cookie.length;}
return unescape(document.cookie.substring(offset,endstr));}
function GetCookie(name)
{if(useCookies)
{var arg=name+"=";var alen=arg.length;var clen=document.cookie.length;var i=0;while(i<clen)
{var j=i+alen;if(document.cookie.substring(i,j)==arg)
return getCookieVal(j);i=document.cookie.indexOf(" ",i)+1;if(i==0)break;}
return null;}
else
{getWebStorage(name);}}
function SetCookie(name,value,expires,path,domain,secure)
{if(useCookies)
{var theDate=new Date();theDate.setTime(theDate.getTime()+expires);document.cookie=name+"="+escape(value)+
((expires==null)?"":("; expires="+theDate.toGMTString()))+
((path==null)?"":("; path="+path))+
((domain==null)?"":("; domain="+domain))+
((secure==true)?"; secure":"");}
else
{setWebStorage(name,value,expires,path,domain,secure);}}
function DeleteCookie(name)
{if(useCookies)
{var exp=new Date();exp.setTime(exp.getTime()-1);var cval=GetCookie(name);document.cookie=name+"="+cval+"; expires="+exp.toGMTString();}
else
{deleteWebStorage(name);}}
function getWebStorage(name)
{return localStorage.getItem(name);}
function setWebStorage(name,value,expires,path,domain,secure)
{var theDate=new Date();theDate.setTime(theDate.getTime()+expires);localStorage.setItem(name,escape(value));}
function deleteWebStorage(name)
{localStorage.removeItem(name);}
function encodeString(text)
{var encodeText=encodeURIComponent(text);encodeText=encodeText.replace(/'/g,"%27");encodeText=encodeText.replace(/~/g,"%7E");encodeText=encodeText.replace("(","%28");encodeText=encodeText.replace(")","%29");return encodeText;}
function XmlEncodeString(text)
{var encodeText=text.replace(/&/g,"&amp;");encodeText=encodeText.replace(/\//g,"%2F");encodeText=encodeText.replace(/\?/g,"%3F");encodeText=encodeText.replace(/=/g,"%3D");encodeText=encodeText.replace(/&/g,"%26");encodeText=encodeText.replace(/@/g,"%40");return encodeText;}
function Timer()
{this.repeatCount=0;this.intervalSize=1000;this.counter=0;this.interval=null;this.counting=false;this.tick=function(id){}
this.completed=function(id){}
this.stopped=function(id){}
var self=this;this.start=function(intervalSize,repeatCount,eventOnStart)
{this.stop('__noEvent');this.reset();this.intervalSize=intervalSize;this.repeatCount=repeatCount;this.interval=setInterval(timerEvent,this.intervalSize);this.counting=true;if(eventOnStart)
{timerEvent();}}
function timerEvent()
{$.jSignal.emit(self.tick);self.counter++;if(self.counter==self.repeatCount)
{$.jSignal.emit(self.completed);self.stop("__noEvent");self.reset();}}
this.stop=function()
{clearInterval(this.interval);this.interval=null;this.counting=false;if(arguments[0]!="__noEvent")
{$.jSignal.emit(this.stopped);}}
this.reset=function()
{this.counter=0;}
this.dispose=function()
{this.stop('__noEvent');delete this.interval;this.counter=null;delete this.counter;this.intervalSize=null;delete this.intervalSize;this.repeatCount=null;delete this.repeatCount;this.counting=null;delete this.counting;}}
function DataStore(id)
{this._id=(id==null)?"{no_id}":id;this._data={};}
DataStore.prototype.setData=function(key,data)
{this._data[key]=data;}
DataStore.prototype.getData=function(key,defaultValue)
{var data=(defaultValue!=null)?defaultValue:"";if(this.doesKeyExist(key))
{data=this._data[key];}
else if(defaultValue==null)
{alert("Key ["+key+"] could not be found in data object ["+this._id+"]");}
return data;}
DataStore.prototype.deleteData=function(key)
{delete this._data[key];}
DataStore.prototype.doesKeyExist=function(key)
{return this._data[key]!=null;}
var ArgList=new Array(10);function cleanArg(arg)
{var tempArg="";tempArg+=arg;var nStart=0;while(' '==tempArg.charAt(nStart))
nStart++;var nEnd=tempArg.length-1;while(nEnd>0&&' '==tempArg.charAt(nEnd))
nEnd--;tempArg=tempArg.substring(nStart,nEnd+1);return(tempArg);}
function parseArgs(args)
{for(i=0;i<10;i++)
ArgList[i]=null;var tempString="";tempString+=args;if(tempString.indexOf('~^~')!=-1)
{delimiterToken='~^~';}else
{delimiterToken=',';}
if(0!=tempString.length)
tempString+=delimiterToken;var delimeter=tempString.indexOf(delimiterToken);var numArgs=0;while(delimeter!=-1)
{var argLength=tempString.length;ArgList[numArgs]=cleanArg(tempString.substring(0,delimeter));tempString=tempString.substring(delimeter+delimiterToken.length,argLength);numArgs++;delimeter=tempString.indexOf(delimiterToken);}
return(numArgs);}
function parseGenArgsToObject(args,delimiter,returnObj,exornot)
{if(delimiter==null)
{if(delimiter.indexOf('~^~')!=-1)
{delimiter='~^~';}
else
{delimiter=',';}}
if(returnObj==null)
{var returnObj=new Object();}
var argsArr=args.split(delimiter);for(i=0;i<argsArr.length;i++)
{var currentArgArr=argsArr[i].split("==");if(currentArgArr[1]!=undefined)
{if(currentArgArr[1].indexOf(exornot?":^:":"::")!=-1)
{var objArrayData=currentArgArr[1].split(exornot?"|^|":"|");var objArray=new Array();for(a=0;a<objArrayData.length;a++)
{var arrayObj=new Object();var arrayObjData=objArrayData[a].split(exornot?":^:":"::");arrayObj.name=arrayObjData[0];arrayObj.value=arrayObjData[1];objArray.push(arrayObj);}
returnObj[currentArgArr[0]]=objArray;}
else if(currentArgArr[1]=='true')
{returnObj[currentArgArr[0]]=true;}
else if(currentArgArr[1]=='false')
{returnObj[currentArgArr[0]]=false;}
else
{returnObj[currentArgArr[0]]=currentArgArr[1];}}}
return returnObj;}
var SYSTEM_WIDTH=1024;var SYSTEM_HEIGHT=768;var RMM_TOAST_DISPLAYTIME=1000;var RMM_CENTERED_DISPLAYTIME=800;var RMM_ENABLED=true;var RMM_OFFSET_RIGHT=5;var RMM_OFFSET_BOTTOM=92;var RMM_PLACED_RIGHT="righthandtoast";var RMM_PLACED_CENTRE="centered";var rmmPlacement="";var currentRMMwidth=0;var currentRMMheight=0;var initCenteredRMMwidth=1024;var initCenteredRMMheight=768;var rmmResizeTimer=0;var rmmShowing=0;var initRMMwidth=0;var initRMMheight=0;var rmmAnimating=0;var isOverlay=0;function initRMM(args)
{SYSTEM_WIDTH=args.stageWidth;SYSTEM_HEIGHT=args.stageHeight;RMM_OFFSET_RIGHT=args.offsetRight;RMM_OFFSET_BOTTOM=args.offsetBottom;RMM_TOAST_DISPLAYTIME=args.toastDisplayTime;RMM_CENTERED_DISPLAYTIME=args.centeredDisplayTime;rmmShowing=0;rmmAnimating=0;}
function resizeRMM()
{if(rmmAnimating==0&&rmmShowing==1)
{$("html").css("overflow","hidden");RMMsetResizeListener();}}
function createRMMiframe()
{rmmAnimating=1;var width=$(window).width();$("html").css("overflow","hidden");$('body').append('<iframe id="RMM" name="RMM" frameBorder="0" scrolling="no" src="javascript:false" allowtransparency="true" style="border:0px; padding:0px; margin:0px; z-index:4; position:absolute; overflow:hidden; top:0px; left: '+width+'px; height:0px; width:0px; opacity:0;"></iframe>');}
function focusRMMessage()
{if($('#RMM').length==1)
{$('#RMM')[0].focus();}}
function closeRMMessage()
{rmmAnimating=0;rmmShowing=0;isOverlay=0;var width=$(window).width();$('#RMM').css({"width":0,"height":0});$('#RMM').remove();$("#system")[0].rmmClosed();}
function addToRmmPostForm(id,value)
{$("#rmmPost").append('<input id="'+id+'" type="hidden" name="'+id+'" value="'+value+'" />');}
function loadRMMTemplate(connectionId,sid,loginName,messageIdentifier,userLang,clientType,mutesound,userType)
{createRMMiframe();if($('#rmmPost').length>0)
{$('#rmmPost').remove();}
$('body').append('<form id="rmmPost" action="" method="post" style="margin:0px;"></form>');$("#rmmPost").attr({action:rmmSettings.templateUrl,target:"RMM"});addToRmmPostForm("f_connectionId",""+connectionId);addToRmmPostForm("ServerID",""+sid);addToRmmPostForm("LoginName",loginName);addToRmmPostForm("ul",userLang);addToRmmPostForm("RMMGuid",""+messageIdentifier);addToRmmPostForm("clientTypeId",clientType);addToRmmPostForm("mute",mutesound);addToRmmPostForm("userType",userType);$("#RMM").load(function()
{$("#system")[0].onIframeLoad();$('#rmmPost').remove();});$("#rmmPost")[0].submit();}
function getDimensions()
{if(siteSettings.system.toLowerCase()=="aurora")
{var container=$("#system")[0].getGameWideScreen();SYSTEM_WIDTH=container.width;SYSTEM_HEIGHT=container.height;}
else
{SYSTEM_WIDTH=1024;SYSTEM_HEIGHT=768;FRAME_DIFFERENCE=0;}
var widthOfMovie=SYSTEM_WIDTH;var heightOfMovie=SYSTEM_HEIGHT;var windowWidth=$(window).width();var windowHeight=$(window).height();var ratio=(windowHeight/windowWidth);var ratio2=SYSTEM_HEIGHT/SYSTEM_WIDTH
var scale=1;var spaceBelow=0;var spaceToRight=0;if(resolutionLocked)
{scale=1;var extraWidth=(windowWidth-widthOfMovie);spaceToRight=Math.ceil(extraWidth/2);var extraHeight=windowHeight-heightOfMovie;spaceBelow=Math.ceil(extraHeight/2);}
else
{if(ratio<ratio2)
{scale=windowHeight/heightOfMovie;}
if(ratio>ratio2)
{scale=windowWidth/widthOfMovie;}
widthOfMovie=widthOfMovie*scale;var extraWspace=windowWidth-widthOfMovie;spaceToRight=Math.ceil(extraWspace/2);heightOfMovie=heightOfMovie*scale;var extraHspace=windowHeight-heightOfMovie;spaceBelow=Math.ceil(extraHspace/2);}
return{ratio:ratio,scale:scale,widthOfMovie:widthOfMovie,heightOfMovie:heightOfMovie,spaceToRight:spaceToRight+scale*RMM_OFFSET_RIGHT,spaceBelow:spaceBelow+scale*RMM_OFFSET_BOTTOM};}
function RMMToastFromRight(width,height)
{initRMMwidth=parseInt(width)
initRMMheight=parseInt(height)
var dimensions=getDimensions();currentRMMheight=parseInt(height);currentRMMwidth=parseInt(width);rmmShowing=1;$('#RMM').css({"width":currentRMMwidth,"height":currentRMMheight,"top":getToastFromRightTOP(height,dimensions),"left":$(window).width()+"","overflow":"hidden"});$('#RMM').animate({opacity:1,left:getToastFromRightLEFT(width,dimensions)},RMM_TOAST_DISPLAYTIME,"linear",RMMsetResizeListener);rmmPlacement=RMM_PLACED_RIGHT;return RMM_TOAST_DISPLAYTIME;}
function RMMCentredFanfair(width,height,isRMMOverlay)
{isOverlay=isRMMOverlay;rmmShowing=1;if(isOverlay==0)
{currentRMMheight=height;currentRMMwidth=width;$('#RMM').css({"width":currentRMMwidth,"height":currentRMMheight,"top":getCentredFanfairTOP(height),"left":getCentredFanfairLEFT(width),opacity:0,"overflow":"hidden"});$('#RMM').animate({opacity:1},RMM_CENTERED_DISPLAYTIME,"linear",RMMsetResizeListener);}
else
{rmmAnimating=0;}
rmmPlacement=RMM_PLACED_CENTRE;return RMM_CENTERED_DISPLAYTIME;}
function getCentredFanfairTOP(height){return $(window).height()/2-(parseInt(height)/2);}
function getCentredFanfairLEFT(width){return $(window).width()/2-(parseInt(width)/2);}
function getToastFromRightTOP(height,dimensions)
{return $(window).height()-(dimensions.spaceBelow+parseInt(height));}
function getToastFromRightLEFT(width,dimensions)
{return $(window).width()-(dimensions.spaceToRight+parseInt($('#RMM').width()));}
function RMMsetResizeListener(){rmmAnimating=0;if(rmmShowing==1)
{clearInterval(rmmResizeTimer);switch($.browser.name)
{case'msie':case'ie':RMMpositionAndResize(true);break;default:rmmResizeTimer=setInterval('RMMpositionAndResize();',50);break;}}}
function RMMpositionAndResize(isIE)
{clearInterval(rmmResizeTimer);if(!isIE){$("#RMM").css({"opacity":"0"});}
switch(rmmPlacement)
{case RMM_PLACED_CENTRE:{if(isOverlay==0)
{$('#RMM').css({"width":currentRMMwidth,"height":currentRMMheight,"top":getCentredFanfairTOP(currentRMMheight),"left":getCentredFanfairLEFT(currentRMMwidth)});}
break;}
case RMM_PLACED_RIGHT:{var dimensions=getDimensions();$('#RMM').css({"width":currentRMMwidth,"height":currentRMMheight,"top":getToastFromRightTOP(currentRMMheight,dimensions),"left":getToastFromRightLEFT(currentRMMwidth,dimensions)});break;}}
if(!isIE){$("#RMM").css({"opacity":"1"});}}
function StorageProxy()
{this._axControl=null;this._flashControl=null;this._useAxControl=false;this._useFlashControl=false;}
StorageProxy.prototype.setActiveXControl=function(control)
{if(control!=null)
{this._axControl=control;}}
StorageProxy.prototype.setFlashControl=function(control)
{if(control!=null)
{this._flashControl=control;}}
StorageProxy.prototype.useActiveXControl=function(value)
{this._useAxControl=value;}
StorageProxy.prototype.useFlashControl=function(value)
{this._useFlashControl=value;}
StorageProxy.prototype.setValue=function(key,value,registryName)
{if(this._useFlashControl)
{this._flashControl.setValue(key,value,registryName);}
if(this._useAxControl)
{this._axControl.setValue(key,value,registryName);}}
StorageProxy.prototype.saveValues=function(data)
{var keys=new Object();keys.nUserType='ID4';keys.cln='LogUName';keys.cpw='ID3';keys.crecall='Recall';keys.ggln='GGUserName';keys.ggpw='GGPassword';keys.ggrecall='GGRecall';keys.hascreds='ShowSignInDialog';keys.pponly='GGPracticeOnly';keys.ppln='PPUserName';keys.pppw='PPKey';keys.UPE='UPE';keys.SSO='SingleSignOn';keys.sID1='ID1';if(this._useAxControl)
{for(var s in data)
{this._axControl.setValue(keys[s],(data[s]=='null')?'':data[s]);}}
if(this._useFlashControl)
{this._flashControl.setStorageFromWebObject(data);}}
StorageProxy.prototype.getValue=function(key,registryName)
{if(this._useFlashControl)
{return this._flashControl.getValue(key,registryName);}
if(this._useAxControl)
{return this._axControl.getValue(key,registryName);}
return"";}
StorageProxy.prototype.doMigration=function()
{if(this._useFlashControl&&this._useAxControl)
{if(this._flashControl.getValue("MigrationStatus")!=1)
{var keys={};keys.cln={key:"LogUName",defaultValue:""};keys.crecall={key:"Recall",defaultValue:0};keys.sID1={key:"ID1",defaultValue:""};keys.cpw={key:"ID3",defaultValue:""};keys.nUserType={key:"ID4",defaultValue:2};keys.hascreds={key:"ShowSignInDialog",defaultValue:0};keys.ppln={key:"PPUserName",defaultValue:""};keys.pppw={key:"PPKey",defaultValue:""};keys.pponly={key:"GGPracticeOnly",defaultValue:0};keys.UPE={key:"UPE",defaultValue:0};keys.SSO={key:"SingleSignOn",defaultValue:0};keys.ggln={key:"GGUserName",defaultValue:""};keys.ggpw={key:"GGPassword",defaultValue:""};keys.ggrecall={key:"GGRecall",defaultValue:0};var data={};for(var s in keys)
{data[s]=keys[s]['defaultValue'];data[s]=this._axControl.getValue(keys[s]['key']);}
data.MigrationStatus="1";this._flashControl.setStorageFromWebObject(data);}}}
StorageProxy.prototype.getStorageDump=function()
{if(this._useFlashControl)
{return this._flashControl.getStorageDump();}
return null;}
function FSProxy()
{this._control=null;this._registryName="_no_regName_";this._oldRegistryName="";this._migrationCompleted=false;this._migrationStatus="1";this._resetShortCut=false;}
FSProxy.prototype.setControl=function(control)
{if(control!=null)
{this._control=control;this._control.setSzCasino(this._registryName);}}
FSProxy.prototype.setRegistryName=function(name)
{if(name!=null)
{this._registryName=name;if(this._control!=null)
{this._control.setSzCasino(name);}}}
FSProxy.prototype.getRegistryName=function()
{return this._registryName;}
FSProxy.prototype.setGamingGroupName=function(name)
{if(name!=null)
{this._control.setGamingGroup(name);}}
FSProxy.prototype.setOldRegistryName=function(name)
{this._oldRegistryName=(name!=null)?name:this._oldRegistryName;}
FSProxy.prototype.getOldRegistryName=function()
{return this._oldRegistryName;}
FSProxy.prototype.setResetShortCut=function(value)
{this._resetShortCut=(value!=null)?(value=="1"):false;}
FSProxy.prototype.setMigrationStatus=function(value)
{this._migrationStatus=(value!=null)?value:"1";}
FSProxy.prototype.setStorageFromWebObject=function(data)
{this._control.setStorageFromWebObject(data);}
FSProxy.prototype.setValue=function(key,value)
{if(this._control!=null)
{this._control["set"+key](value);}}
FSProxy.prototype.getValue=function(key)
{var value="";if(this._control!=null)
{value=this._control["get"+key]();}
return value;}
FSProxy.prototype.canWeCopy=function()
{var check1=(this.getValue("LogUName")=="");var check2=(this.getValue("PPUserName")=="");var check3=(this.getValue("GGUserName")=="");return(this.getValue("MigrationStatus")=="0")&&check1&&check2&&check3;}
FSProxy.prototype.canWePromptForShortcut=function()
{var registryName=(this._oldRegistryName!=null&&this._oldRegistryName!="")?this._oldRegistryName:this._registryName;var canPrompt=true;var migrateStatus=1;if(this._resetShortCut)
{migrateStatus=this._migrationStatus;}
if(registryName!=this._registryName)
{this._control.setSzCasino(registryName);canPrompt=(this._resetShortCut)?(this._control["getMigrationStatus"]()!=migrateStatus):(this._control["getMigrationStatus"]()=="0");this._control["setMigrationStatus"]("1");this._control.setSzCasino(this._registryName);}
else
{canPrompt=(this._resetShortCut)?(this._control["getMigrationStatus"]()!=migrateStatus):(this._control["getMigrationStatus"]()=="0");}
this._control["setMigrationStatus"](migrateStatus);return canPrompt;}
FSProxy.prototype.doCopy=function(fromProxy)
{var keys={};keys.cln={key:"LogUName",defaultValue:""};keys.crecall={key:"Recall",defaultValue:0};keys.sID1={key:"ID1",defaultValue:""};keys.cpw={key:"ID3",defaultValue:""};keys.nUserType={key:"ID4",defaultValue:2};keys.hascreds={key:"ShowSignInDialog",defaultValue:0};keys.ppln={key:"PPUserName",defaultValue:""};keys.pppw={key:"PPKey",defaultValue:""};keys.pponly={key:"GGPracticeOnly",defaultValue:0};keys.UPE={key:"UPE",defaultValue:0};keys.SSO={key:"SingleSignOn",defaultValue:0};keys.ggln={key:"GGUserName",defaultValue:""};keys.ggpw={key:"GGPassword",defaultValue:""};keys.ggrecall={key:"GGRecall",defaultValue:0};var data={};var dump=fromProxy.getStorageDump();for(var s in keys)
{data[s]=keys[s]['defaultValue'];data[s]=dump['get'+keys[s]['key']];}
this.setStorageFromWebObject(data);}
FSProxy.prototype.getStorageDump=function()
{if(this._control!=null)
{return this._control.getStorageDump();}
return null;}
FSProxy.prototype.setGlobalSettingString=function(key,value){if(this._control!=null){this._control.setGlobalSettingString(this._registryName,key,value);}}
FSProxy.prototype.getGlobalSettingString=function(key){var value="";if(this._control!=null){value=this._control.getGlobalSettingString(this._registryName,key);}
return value;}
function AXProxy()
{this._control=null;this._registryName="_no_regName_";this._oldRegistryName="";this._migrationCompleted=false;}
AXProxy.prototype.setControl=function(control)
{if(control!=null)
{this._control=control;this._control.szCasino=this._registryName;}}
AXProxy.prototype.setRegistryName=function(name)
{if(name!=null)
{this._registryName=name;if(this._control!=null)
{this._control.szCasino=name;}}}
AXProxy.prototype.getRegistryName=function()
{return this._registryName;}
AXProxy.prototype.setGamingGroupName=function(name)
{if(name!=null)
{this._control.GamingGroup=name;}}
AXProxy.prototype.setOldRegistryName=function(name)
{this._oldRegistryName=(name!=null)?name:this._oldRegistryName;}
AXProxy.prototype.getOldRegistryName=function()
{return this._oldRegistryName;}
AXProxy.prototype.setValue=function(key,value,registryName)
{registryName=(registryName!=null)?registryName:this._registryName;if(this._control!=null)
{this._control.szCasino=registryName;this._control[key]=value;}
this.revertToDefaultRegistryName();}
AXProxy.prototype.getValue=function(key,registryName)
{registryName=(registryName!=null)?registryName:this._registryName;var value="";if(this._control!=null)
{this._control.szCasino=registryName;value=this._control[key];}
this.revertToDefaultRegistryName();return value;}
AXProxy.prototype.createShortcut=function(type)
{var registryName=(this._oldRegistryName!="")?this._oldRegistryName:this._registryName;this._control.szCasino=registryName;type=(type==null)?0:type;this._control.AddLink(type);this.revertToDefaultRegistryName();}
AXProxy.prototype.doMigrationIfRequired=function()
{if(this.canWeDoMigration())
{this.doMigration();}
this._migrationCompleted=true;}
AXProxy.prototype.canWeDoMigration=function()
{var migrate=false;if(this._oldRegistryName!=""&&!this._migrationCompleted)
{if(this.isOldLevelGuestOrReal())
{if(this.isOnlyOldSSO())
{migrate=true;}
else if(this.isNewUpeLessThanOldUpe())
{migrate=true;}
else if(this.getValue("ID4")=="2")
{migrate=true;}}}
return migrate;}
AXProxy.prototype.isOldLevelGuestOrReal=function()
{var oldLevel=this.getValue("ID4",this._oldRegistryName);return(oldLevel<2);}
AXProxy.prototype.isOnlyOldSSO=function()
{var oldSSO=this.getValue("SingleSignOn",this._oldRegistryName);var newSSO=this.getValue("SingleSignOn");return(oldSSO==1&&newSSO==0);}
AXProxy.prototype.isNewUpeLessThanOldUpe=function()
{var oldUPE=this.getValue("UPE",this._oldRegistryName);var newUPE=this.getValue("UPE");return(newUPE<oldUPE);}
AXProxy.prototype.doMigration=function()
{if(!this._migrationCompleted)
{var keys={};keys.LogUName={key:"LogUName",defaultValue:""};keys.ReCall={key:"Recall",defaultValue:0};keys.ID1={key:"ID1",defaultValue:""};keys.ID3={key:"ID3",defaultValue:""};keys.ID4={key:"ID4",defaultValue:2};keys.ShowSignInDialog={key:"ShowSignInDialog",defaultValue:0};keys.PPUserName={key:"PPUserName",defaultValue:""};keys.PPKey={key:"PPKey",defaultValue:""};keys.UPE={key:"UPE",defaultValue:0};keys.SingleSignOn={key:"SingleSignOn",defaultValue:0};for(var s in keys)
{var value=this.getValue(keys[s]['key'],this._oldRegistryName);this.setValue(keys[s]['key'],value)
this.setValue(keys[s]['key'],keys[s]['defaultValue'],this._oldRegistryName)}}
this.revertToDefaultRegistryName();this._migrationCompleted=true;}
AXProxy.prototype.revertToDefaultRegistryName=function()
{if(this._control!=null)
{this._control.szCasino=this._registryName;}}
var swfobject=function(){var D="undefined",r="object",S="Shockwave Flash",W="ShockwaveFlash.ShockwaveFlash",q="application/x-shockwave-flash",R="SWFObjectExprInst",x="onreadystatechange",O=window,j=document,t=navigator,T=false,U=[h],o=[],N=[],I=[],l,Q,E,B,J=false,a=false,n,G,m=true,M=function(){var aa=typeof j.getElementById!=D&&typeof j.getElementsByTagName!=D&&typeof j.createElement!=D,ah=t.userAgent.toLowerCase(),Y=t.platform.toLowerCase(),ae=Y?/win/.test(Y):/win/.test(ah),ac=Y?/mac/.test(Y):/mac/.test(ah),af=/webkit/.test(ah)?parseFloat(ah.replace(/^.*webkit\/(\d+(\.\d+)?).*$/,"$1")):false,X=!+"\v1",ag=[0,0,0],ab=null;if(typeof t.plugins!=D&&typeof t.plugins[S]==r){ab=t.plugins[S].description;if(ab&&!(typeof t.mimeTypes!=D&&t.mimeTypes[q]&&!t.mimeTypes[q].enabledPlugin)){T=true;X=false;ab=ab.replace(/^.*\s+(\S+\s+\S+$)/,"$1");ag[0]=parseInt(ab.replace(/^(.*)\..*$/,"$1"),10);ag[1]=parseInt(ab.replace(/^.*\.(.*)\s.*$/,"$1"),10);ag[2]=/[a-zA-Z]/.test(ab)?parseInt(ab.replace(/^.*[a-zA-Z]+(.*)$/,"$1"),10):0}}else{if(typeof O.ActiveXObject!=D){try{var ad=new ActiveXObject(W);if(ad){ab=ad.GetVariable("$version");if(ab){X=true;ab=ab.split(" ")[1].split(",");ag=[parseInt(ab[0],10),parseInt(ab[1],10),parseInt(ab[2],10)]}}}catch(Z){}}}return{w3:aa,pv:ag,wk:af,ie:X,win:ae,mac:ac}}(),k=function(){if(!M.w3){return}if((typeof j.readyState!=D&&j.readyState=="complete")||(typeof j.readyState==D&&(j.getElementsByTagName("body")[0]||j.body))){f()}if(!J){if(typeof j.addEventListener!=D){j.addEventListener("DOMContentLoaded",f,false)}if(M.ie&&M.win){j.attachEvent(x,function(){if(j.readyState=="complete"){j.detachEvent(x,arguments.callee);f()}});if(O==top){(function(){if(J){return}try{j.documentElement.doScroll("left")}catch(X){setTimeout(arguments.callee,0);return}f()})()}}if(M.wk){(function(){if(J){return}if(!/loaded|complete/.test(j.readyState)){setTimeout(arguments.callee,0);return}f()})()}s(f)}}();function f(){if(J){return}try{var Z=j.getElementsByTagName("body")[0].appendChild(C("span"));Z.parentNode.removeChild(Z)}catch(aa){return}J=true;var X=U.length;for(var Y=0;Y<X;Y++){U[Y]()}}function K(X){if(J){X()}else{U[U.length]=X}}function s(Y){if(typeof O.addEventListener!=D){O.addEventListener("load",Y,false)}else{if(typeof j.addEventListener!=D){j.addEventListener("load",Y,false)}else{if(typeof O.attachEvent!=D){i(O,"onload",Y)}else{if(typeof O.onload=="function"){var X=O.onload;O.onload=function(){X();Y()}}else{O.onload=Y}}}}}function h(){if(T){V()}else{H()}}function V(){var X=j.getElementsByTagName("body")[0];var aa=C(r);aa.setAttribute("type",q);var Z=X.appendChild(aa);if(Z){var Y=0;(function(){if(typeof Z.GetVariable!=D){var ab=Z.GetVariable("$version");if(ab){ab=ab.split(" ")[1].split(",");M.pv=[parseInt(ab[0],10),parseInt(ab[1],10),parseInt(ab[2],10)]}}else{if(Y<10){Y++;setTimeout(arguments.callee,10);return}}X.removeChild(aa);Z=null;H()})()}else{H()}}function H(){var ag=o.length;if(ag>0){for(var af=0;af<ag;af++){var Y=o[af].id;var ab=o[af].callbackFn;var aa={success:false,id:Y};if(M.pv[0]>0){var ae=c(Y);if(ae){if(F(o[af].swfVersion)&&!(M.wk&&M.wk<312)){w(Y,true);if(ab){aa.success=true;aa.ref=z(Y);ab(aa)}}else{if(o[af].expressInstall&&A()){var ai={};ai.data=o[af].expressInstall;ai.width=ae.getAttribute("width")||"0";ai.height=ae.getAttribute("height")||"0";if(ae.getAttribute("class")){ai.styleclass=ae.getAttribute("class")}if(ae.getAttribute("align")){ai.align=ae.getAttribute("align")}var ah={};var X=ae.getElementsByTagName("param");var ac=X.length;for(var ad=0;ad<ac;ad++){if(X[ad].getAttribute("name").toLowerCase()!="movie"){ah[X[ad].getAttribute("name")]=X[ad].getAttribute("value")}}P(ai,ah,Y,ab)}else{p(ae);if(ab){ab(aa)}}}}}else{w(Y,true);if(ab){var Z=z(Y);if(Z&&typeof Z.SetVariable!=D){aa.success=true;aa.ref=Z}ab(aa)}}}}}function z(aa){var X=null;var Y=c(aa);if(Y&&Y.nodeName=="OBJECT"){if(typeof Y.SetVariable!=D){X=Y}else{var Z=Y.getElementsByTagName(r)[0];if(Z){X=Z}}}return X}function A(){return!a&&F("6.0.65")&&(M.win||M.mac)&&!(M.wk&&M.wk<312)}function P(aa,ab,X,Z){a=true;E=Z||null;B={success:false,id:X};var ae=c(X);if(ae){if(ae.nodeName=="OBJECT"){l=g(ae);Q=null}else{l=ae;Q=X}aa.id=R;if(typeof aa.width==D||(!/%$/.test(aa.width)&&parseInt(aa.width,10)<310)){aa.width="310"}if(typeof aa.height==D||(!/%$/.test(aa.height)&&parseInt(aa.height,10)<137)){aa.height="137"}j.title=j.title.slice(0,47)+" - Flash Player Installation";var ad=M.ie&&M.win?"ActiveX":"PlugIn",ac="MMredirectURL="+O.location.toString().replace(/&/g,"%26")+"&MMplayerType="+ad+"&MMdoctitle="+j.title;if(typeof ab.flashvars!=D){ab.flashvars+="&"+ac}else{ab.flashvars=ac}if(M.ie&&M.win&&ae.readyState!=4){var Y=C("div");X+="SWFObjectNew";Y.setAttribute("id",X);ae.parentNode.insertBefore(Y,ae);ae.style.display="none";(function(){if(ae.readyState==4){ae.parentNode.removeChild(ae)}else{setTimeout(arguments.callee,10)}})()}u(aa,ab,X)}}function p(Y){if(M.ie&&M.win&&Y.readyState!=4){var X=C("div");Y.parentNode.insertBefore(X,Y);X.parentNode.replaceChild(g(Y),X);Y.style.display="none";(function(){if(Y.readyState==4){Y.parentNode.removeChild(Y)}else{setTimeout(arguments.callee,10)}})()}else{Y.parentNode.replaceChild(g(Y),Y)}}function g(ab){var aa=C("div");if(M.win&&M.ie){aa.innerHTML=ab.innerHTML}else{var Y=ab.getElementsByTagName(r)[0];if(Y){var ad=Y.childNodes;if(ad){var X=ad.length;for(var Z=0;Z<X;Z++){if(!(ad[Z].nodeType==1&&ad[Z].nodeName=="PARAM")&&!(ad[Z].nodeType==8)){aa.appendChild(ad[Z].cloneNode(true))}}}}}return aa}function u(ai,ag,Y){var X,aa=c(Y);if(M.wk&&M.wk<312){return X}if(aa){if(typeof ai.id==D){ai.id=Y}if(M.ie&&M.win){var ah="";for(var ae in ai){if(ai[ae]!=Object.prototype[ae]){if(ae.toLowerCase()=="data"){ag.movie=ai[ae]}else{if(ae.toLowerCase()=="styleclass"){ah+=' class="'+ai[ae]+'"'}else{if(ae.toLowerCase()!="classid"){ah+=" "+ae+'="'+ai[ae]+'"'}}}}}var af="";for(var ad in ag){if(ag[ad]!=Object.prototype[ad]){af+='<param name="'+ad+'" value="'+ag[ad]+'" />'}}aa.outerHTML='<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"'+ah+">"+af+"</object>";N[N.length]=ai.id;X=c(ai.id)}else{var Z=C(r);Z.setAttribute("type",q);for(var ac in ai){if(ai[ac]!=Object.prototype[ac]){if(ac.toLowerCase()=="styleclass"){Z.setAttribute("class",ai[ac])}else{if(ac.toLowerCase()!="classid"){Z.setAttribute(ac,ai[ac])}}}}for(var ab in ag){if(ag[ab]!=Object.prototype[ab]&&ab.toLowerCase()!="movie"){e(Z,ab,ag[ab])}}aa.parentNode.replaceChild(Z,aa);X=Z}}return X}function e(Z,X,Y){var aa=C("param");aa.setAttribute("name",X);aa.setAttribute("value",Y);Z.appendChild(aa)}function y(Y){var X=c(Y);if(X&&X.nodeName=="OBJECT"){if(M.ie&&M.win){X.style.display="none";(function(){if(X.readyState==4){b(Y)}else{setTimeout(arguments.callee,10)}})()}else{X.parentNode.removeChild(X)}}}function b(Z){var Y=c(Z);if(Y){for(var X in Y){if(typeof Y[X]=="function"){Y[X]=null}}Y.parentNode.removeChild(Y)}}function c(Z){var X=null;try{X=j.getElementById(Z)}catch(Y){}return X}function C(X){return j.createElement(X)}function i(Z,X,Y){Z.attachEvent(X,Y);I[I.length]=[Z,X,Y]}function F(Z){var Y=M.pv,X=Z.split(".");X[0]=parseInt(X[0],10);X[1]=parseInt(X[1],10)||0;X[2]=parseInt(X[2],10)||0;return(Y[0]>X[0]||(Y[0]==X[0]&&Y[1]>X[1])||(Y[0]==X[0]&&Y[1]==X[1]&&Y[2]>=X[2]))?true:false}function v(ac,Y,ad,ab){if(M.ie&&M.mac){return}var aa=j.getElementsByTagName("head")[0];if(!aa){return}var X=(ad&&typeof ad=="string")?ad:"screen";if(ab){n=null;G=null}if(!n||G!=X){var Z=C("style");Z.setAttribute("type","text/css");Z.setAttribute("media",X);n=aa.appendChild(Z);if(M.ie&&M.win&&typeof j.styleSheets!=D&&j.styleSheets.length>0){n=j.styleSheets[j.styleSheets.length-1]}G=X}if(M.ie&&M.win){if(n&&typeof n.addRule==r){n.addRule(ac,Y)}}else{if(n&&typeof j.createTextNode!=D){n.appendChild(j.createTextNode(ac+" {"+Y+"}"))}}}function w(Z,X){if(!m){return}var Y=X?"visible":"hidden";if(J&&c(Z)){c(Z).style.visibility=Y}else{v("#"+Z,"visibility:"+Y)}}function L(Y){var Z=/[\\\"<>\.;]/;var X=Z.exec(Y)!=null;return X&&typeof encodeURIComponent!=D?encodeURIComponent(Y):Y}var d=function(){if(M.ie&&M.win){window.attachEvent("onunload",function(){var ac=I.length;for(var ab=0;ab<ac;ab++){I[ab][0].detachEvent(I[ab][1],I[ab][2])}var Z=N.length;for(var aa=0;aa<Z;aa++){y(N[aa])}for(var Y in M){M[Y]=null}M=null;for(var X in swfobject){swfobject[X]=null}swfobject=null})}}();return{registerObject:function(ab,X,aa,Z){if(M.w3&&ab&&X){var Y={};Y.id=ab;Y.swfVersion=X;Y.expressInstall=aa;Y.callbackFn=Z;o[o.length]=Y;w(ab,false)}else{if(Z){Z({success:false,id:ab})}}},getObjectById:function(X){if(M.w3){return z(X)}},embedSWF:function(ab,ah,ae,ag,Y,aa,Z,ad,af,ac){var X={success:false,id:ah};if(M.w3&&!(M.wk&&M.wk<312)&&ab&&ah&&ae&&ag&&Y){w(ah,false);K(function(){ae+="";ag+="";var aj={};if(af&&typeof af===r){for(var al in af){aj[al]=af[al]}}aj.data=ab;aj.width=ae;aj.height=ag;var am={};if(ad&&typeof ad===r){for(var ak in ad){am[ak]=ad[ak]}}if(Z&&typeof Z===r){for(var ai in Z){if(typeof am.flashvars!=D){am.flashvars+="&"+ai+"="+Z[ai]}else{am.flashvars=ai+"="+Z[ai]}}}if(F(Y)){var an=u(aj,am,ah);if(aj.id==ah){w(ah,true)}X.success=true;X.ref=an}else{if(aa&&A()){aj.data=aa;P(aj,am,ah,ac);return}else{w(ah,true)}}if(ac){ac(X)}})}else{if(ac){ac(X)}}},switchOffAutoHideShow:function(){m=false},ua:M,getFlashPlayerVersion:function(){return{major:M.pv[0],minor:M.pv[1],release:M.pv[2]}},hasFlashPlayerVersion:F,createSWF:function(Z,Y,X){if(M.w3){return u(Z,Y,X)}else{return undefined}},showExpressInstall:function(Z,aa,X,Y){if(M.w3&&A()){P(Z,aa,X,Y)}},removeSWF:function(X){if(M.w3){y(X)}},createCSS:function(aa,Z,Y,X){if(M.w3){v(aa,Z,Y,X)}},addDomLoadEvent:K,addLoadEvent:s,getQueryParamValue:function(aa){var Z=j.location.search||j.location.hash;if(Z){if(/\?/.test(Z)){Z=Z.split("?")[1]}if(aa==null){return L(Z)}var Y=Z.split("&");for(var X=0;X<Y.length;X++){if(Y[X].substring(0,Y[X].indexOf("="))==aa){return L(Y[X].substring((Y[X].indexOf("=")+1)))}}}return""},expressInstallCallback:function(){if(a){var X=c(R);if(X&&l){X.parentNode.replaceChild(l,X);if(Q){w(Q,true);if(M.ie&&M.win){l.style.display="block"}}if(E){E(B)}}a=false}}}}();var OpenIdOpen=false;function createOpenIDiframe()
{if($('#OPENID').length>0)
{closeOpenIDlogin();}
OpenIdOpen=true;var width=$(window).width();$('body').append('<iframe id="OPENID" name="OPENID" scrolling="no" src="javascript:false" style="border:0px; padding:0px; margin:0px; z-index:4; position:absolute; overflow:hidden; top:0px; left: '+width+'px; height:0px; width:0px; opacity:0"></iframe>');}
function focusOpenIDLogin()
{if($('#OPENID').length==1)
{$('#OPENID')[0].focus();}}
function closeOpenIDlogin()
{OpenIdOpen=false;$('#OPENID').css({"top":"0","left":""+$(window).width(),"opacity":"0","width":"0","height":"0","visibility":"hidden"});$('#OPENID').remove();var elem=document.getElementById('OPENID');elem.parentNode.removeChild(elem);}
function addToOpenIDPostForm(id,value)
{$("#openIDpost").append('<input id="'+id+'" type="hidden" name="'+id+'" value="'+value+'" />');}
function loadOpenIdLogin(connectionId,recieveConnectionId,postValues,url)
{createOpenIDiframe();if($('#openIDpost').length>0)
{$('#openIDpost').remove();}
$('body').append('<form id="openIDpost" action="" method="post" style="margin:0px;"></form>');$("#openIDpost").attr({action:url,target:"OPENID"});for(var i=0;i<postValues.length;i++)
{value=(postValues[i].value=="null")?"":postValues[i].value;addToOpenIDPostForm(postValues[i].name,""+value);}
addToOpenIDPostForm("connectionId",""+connectionId);addToOpenIDPostForm("recieveConnectionId",""+recieveConnectionId);$("#contentFrame").css({width:'100%',height:'100%'});$("#OPENID").load(function()
{$('#openIDpost').remove();});$("#openIDpost")[0].submit();CentredOpenID(843,626);}
function CentredOpenID(width,height)
{currentheight=height;currentwidth=width;$('#OPENID').css({"width":currentwidth,"height":currentheight,"top":getCentredTOP(height),"left":getCentredLEFT(width),opacity:0,"overflow":"hidden"});$('#OPENID').animate({opacity:1},100,"linear",setOpenIDResizeListener);}
function getCentredTOP(height){return $(window).height()/2-(parseInt(height)/2);}
function getCentredLEFT(width){return $(window).width()/2-(parseInt(width)/2);}
var resizeTimer=0;function setOpenIDResizeListener()
{if(OpenIdOpen)
{clearInterval(resizeTimer);switch($.browser.name)
{case'msie':case'ie':positionAndResize(true);break;default:resizeTimer=setInterval('positionAndResize();',50);break;}}}
function positionAndResize(isIE)
{if(OpenIdOpen)
{clearInterval(resizeTimer);if(!isIE){$("#OPENID").css({"opacity":"0"});}
$('#OPENID').css({"top":getCentredTOP(currentheight),"left":getCentredLEFT(currentwidth)});if(!isIE){$("#OPENID").css({"opacity":"1"});}}}
function StatsMetric()
{this.data={statsNamespace:"",metricType:"count",value:"1",serverId:"",async:true};this.currentStatInfo=null;}
StatsMetric.prototype.cloneData=function()
{var clonedData={}
for(var s in this.data)
{clonedData[s]=this.data[s];}
return clonedData;}
StatsMetric.prototype.statInfo=function(data)
{var statInfo=new MetricInfo({data:data,controller:this});if(this.currentStatInfo==null)
{this.currentStatInfo=statInfo;this.currentStatInfo.send();}
else
{this.currentStatInfo.queue(statInfo);}}
StatsMetric.prototype.infoSent=function()
{this.currentStatInfo=this.currentStatInfo.next();if(this.currentStatInfo!=null)
{this.currentStatInfo.send();}}
function MetricInfo(data)
{this.data=data.data;this.controller=data.controller;this.nextInfo=null;}
MetricInfo.prototype.send=function()
{var params="statsNamespace="+escape(this.data.statsNamespace);if(this.count!="")
{params+="&value="+escape(this.data.value);}
params+="&metricType="+escape(this.data.metricType);$.ajax({type:"POST",url:"Metric.ashx",data:params,cache:false,async:this.data.async,statInfo:this,success:function(data)
{this.statInfo.controller.infoSent();}});}
MetricInfo.prototype.queue=function(info)
{if(this.nextInfo==null)
{this.nextInfo=info;}
else
{this.nextInfo.queue(info);}}
MetricInfo.prototype.next=function()
{return this.nextInfo;}
function onGenericMetricInfo(data)
{if(metricObj!=null)
{var metricData=metricObj.cloneData();for(var key in data)
{metricData[key]=data[key];}
metricObj.statInfo(metricData);}}
function onBrowserCloseMetric(sync)
{if(metricObj!=null)
{var metricData=metricObj.cloneData();var statsnamespace=statNames.browserClosed.statsNamespace;if(metricData.serverId=="")
statsnamespace+=".unknown";else
statsnamespace+="."+metricData.serverId;metricData.statsNamespace=statsnamespace;metricData.async=sync;metricObj.statInfo(metricData);}}
function onAverageSpeed(speed)
{if(metricObj!=null)
{var metricData=metricObj.cloneData();var statsnamespace=statNames.avgSpeed.statsNamespace;statsnamespace+="."+speed;var gid=""+startupSettings.gameId;if(gid=="")
{gid="unknown";}
statsnamespace+="."+gid;metricData.statsNamespace=statsnamespace;metricObj.statInfo(metricData);}}
var animatingBanking=0;var BANK_OFFSET_RIGHT=30;var BANK_OFFSET_BOTTOM=30;var currentBankwidth=0;var currentBankheight=0;var bankResizeTimer=0;var bankShowing=0;var initBankWidth=1185;var initBankHeight=660;var bankingloggedIn=false;var internalToken="";var tokenTimer=0;var LaunchToken="";var bankingClient=null;function startTokenReset()
{internalToken=startupSettings.internalToken;tokenTimer=setInterval('keepTokenAlive();',startupSettings.intervalLimit);}
function loadBankingUI(url,data)
{var width=$(window).width();if($('#bank').length==0)
{var bankContainer='<div id="bank" class="contentcontainer" name="bSlider" ng-controller="Banking.DefaultCtrl" style="overflow-y: auto;z-index:6; position:absolute;top:0px; left: '+width+'px; height:0px; width:0px; opacity:0; background-color:white"><link ng-repeat="cssPath in vm.cssList" ng-href="{{cssPath}}" rel="stylesheet" /> <div ng-include="tpl.commonTemplateUrl"></div>  <div class="header" ng-include="tpl.headerUrl"></div> <div ng-class="{loader: loader.busy}" class="loadingcontainer"> <h3 ng-show="loader.busy" class="infobox loader"><i class="fa fa-refresh fa-spin"></i><p translate>{{loader.message}}</p></h3></div> <div ng-hide="loader.busy" class="banking" ng-view></div> <div class="footer" ng-include="tpl.footerUrl"></div> </div>';$('body').append(bankContainer);$('body').append('<div id="backHidder" class="contentcontainer" name="bhidder" style="overflow-y: auto;z-index:6; position:absolute;top:0px; left: '+width+'px; height:0px; width:0px; opacity:0; background-color:black"></div>');loadjscssfile(url,"js");}
setTitle(casinoTitle);getLaunchData(data);setResizeEvents();}
function setUpBanking(serverID,username,password,sessionToken,lang,sourceUrl)
{var settings=new Banking.Models.SettingModel();settings.parseByUrl(sourceUrl);Banking.External.Swf.httpBackend.swfInitalize({swfUrl:settings.bankingSwfHttpUrl});bankingClient=new Banking.Client(serverID,settings);var extn=Banking.External;extn.subscribe(new extn.EventModel(extn.EventType.onBalanceChanged,onBankingBalanceChange));extn.subscribe(new extn.EventModel(extn.EventType.onExitBanking,onReturnToLobby));extn.subscribe(new extn.EventModel(extn.EventType.onDepositAmountRangeChange,onQuickDepositValueChange));extn.subscribe(new extn.EventModel(extn.EventType.onLogIn,function(){bankingloggedIn=true;}));extn.subscribe(new extn.EventModel(extn.EventType.onLogOff,function(){bankingloggedIn=false;}));extn.subscribe(new extn.EventModel(extn.EventType.onSessionIdleTimeOut,onReturnToLobby));var player=createPlayerModel(serverID,username,password,sessionToken,lang);bankingClient.login(player);setTitle(casinoTitle);}
function createPlayerModel(serverID,username,password,sessionToken,lang)
{var tokenSignature=LaunchToken;var bankingSessionId="";var player=new Banking.Models.PlayerModel(serverID,username,password,lang,bankingSessionId,sessionToken,tokenSignature);return player;}
function reloginToBanking(serverID,username,password,sessionToken,lang)
{var player=createPlayerModel(serverID,username,password,sessionToken,lang);bankingClient.relogin(player);setTitle(casinoTitle);}
function removeBanking()
{if($('#bank').length!=0)
{$('#bank').remove()}}
function onReturnToLobby(data) 
{ 
   $("#system")[0].closeBankingSlider(); }
function onBankingBalanceChange(data)
{$("#system")[0].bankingBalanceChange();}
function onQuickDepositValueChange(data)
{var amountRanges=data;$("#system")[0].quickdepositValueChanges(amountRanges);}
function slideBanking(direction,quickdepositValue,duration,balance)
{if(animatingBanking==1)
{return;}
animatingBanking=1
var startleft=0;var endleft=0;var bankDimensions=getBankingDimensions();if(direction.toLowerCase()=="close")
{bankShowing=0;startleft=endleft;endleft=getBankStartPosition(bankDimensions);$('#bank').animate({opacity:1,left:endleft+"px"},duration,"easeOutSine",bankingAnimationHiddenDone);}
else
{if(bankingloggedIn==false)
{$("#system")[0].resetBanking();}
if(quickdepositValue>0)
{Banking.External.fnPreSelectDepositAmount(quickdepositValue);}
Banking.External.fnRefreshBalance();bankShowing=1;setResizeEvents();currentBankheight=parseInt(initBankHeight*bankDimensions.scale);currentBankwidth=parseInt(initBankWidth*bankDimensions.scale);startleft=getBankStartPosition(bankDimensions);bankTop=getBankFromRightTOP(currentBankheight,bankDimensions);endleft=getBankFromRightLEFT(currentBankwidth,bankDimensions);setBankHidder(bankDimensions);$('#bank').css({"width":currentBankwidth,"height":currentBankheight,"top":bankTop,"left":startleft,opacity:"1"});$('#bank').animate({opacity:1,left:endleft+"px"},duration,"easeOutSine",bankAnimationDone);}}
function setBankHidder(dimensions)
{var bhiderXpos=dimensions.widthOfMovie+dimensions.SpacetoRightNoOffSet;$('#backHidder').css({"width":dimensions.SpacetoRightNoOffSet,"height":(currentBankheight+20),"top":(getBankFromRightTOP(currentBankheight,dimensions)-10),"left":bhiderXpos,"opacity":1});}
function getBankFromRightTOP(height,dimensions)
{return $(window).height()-(dimensions.spaceBelow+parseInt(height));}
function getBankFromRightLEFT(width,dimensions)
{return $(window).width()-(dimensions.spaceToRight+parseInt(width));}
function getBankStartPosition(dimensions)
{return(dimensions.widthOfMovie+dimensions.SpacetoRightNoOffSet+(dimensions.scale*BANK_OFFSET_RIGHT))}
function getBankingDimensions()
{var container=$("#system")[0].getGameWideScreen();var widthOfMovie=container.width;var heightOfMovie=container.height;var windowWidth=$(window).width();var windowHeight=$(window).height();var ratio=(windowHeight/windowWidth);var ratio2=heightOfMovie/widthOfMovie
var scale=1;var spaceBelow=0;var spaceToRight=0;if(resolutionLocked)
{scale=1;var extraWidth=(windowWidth-widthOfMovie);spaceToRight=Math.ceil(extraWidth/2);var extraHeight=windowHeight-heightOfMovie;spaceBelow=Math.ceil(extraHeight/2);}
else
{if(ratio<ratio2)
{scale=windowHeight/heightOfMovie;}
if(ratio>ratio2)
{scale=windowWidth/widthOfMovie;}
widthOfMovie=widthOfMovie*scale;var extraWspace=windowWidth-widthOfMovie;spaceToRight=Math.ceil(extraWspace/2);heightOfMovie=heightOfMovie*scale;var extraHspace=windowHeight-heightOfMovie;spaceBelow=Math.ceil(extraHspace/2);}
return{ratio:ratio,scale:scale,widthOfMovie:widthOfMovie,heightOfMovie:heightOfMovie,spaceToRight:(spaceToRight+(scale*BANK_OFFSET_RIGHT)),spaceBelow:(spaceBelow+(scale*BANK_OFFSET_BOTTOM)),SpacetoRightNoOffSet:spaceToRight};}
function resizeBankSlider()
{if(animatingBanking==0&&bankShowing==1)
{$("html").css("overflow","hidden");auroraBankSetResizeListener();}}
function bankAnimationDone()
{animatingBanking=0;auroraBankSetResizeListener();}
function bankingAnimationHiddenDone()
{animatingBanking=0;$('#bank').css({"width":0,"height":0,"opacity":"0"});$('#backHidder').css({"width":0,"height":0,"opacity":"0"});}
function auroraBankSetResizeListener()
{if(bankShowing==1)
{clearInterval(bankResizeTimer);switch($.browser.name)
{case'msie':case'ie':BankPositionAndResize(true);break;default:bankResizeTimer=setInterval('BankPositionAndResize();',50);break;}}}
function BankPositionAndResize(isIE)
{clearInterval(bankResizeTimer);if(!isIE){$("#bank").css({"opacity":"0"});}
var bankDimensions=getBankingDimensions();currentBankheight=parseInt(initBankHeight*bankDimensions.scale);currentBankwidth=parseInt(initBankWidth*bankDimensions.scale);setBankHidder(bankDimensions);$('#bank').css({"width":currentBankwidth,"height":currentBankheight,"top":getBankFromRightTOP(currentBankheight,bankDimensions),"left":getBankFromRightLEFT(currentBankwidth,bankDimensions)});if(!isIE){$("#bank").css({"opacity":"1"});}}
function keepTokenAlive()
{$.ajax({type:"POST",url:"Tokens.ashx",data:{"launch":0,"guid":internalToken},cache:false,context:this,success:function(data)
{if(data!="Err"){internalToken=data;}
else
{clearInterval(tokenTimer);}}});}
function getLaunchData(info){$.ajax({type:"POST",url:"Tokens.ashx",data:{"launch":1,"guid":internalToken,"info":info},cache:false,context:this,success:function(data){if(data!="Err"){LaunchToken=data;}}});}
if(!this.JSON){this.JSON={};}
(function(){function f(n){return n<10?'0'+n:n;}
if(typeof Date.prototype.toJSON!=='function'){Date.prototype.toJSON=function(key){return isFinite(this.valueOf())?this.getUTCFullYear()+'-'+
f(this.getUTCMonth()+1)+'-'+
f(this.getUTCDate())+'T'+
f(this.getUTCHours())+':'+
f(this.getUTCMinutes())+':'+
f(this.getUTCSeconds())+'Z':null;};String.prototype.toJSON=Number.prototype.toJSON=Boolean.prototype.toJSON=function(key){return this.valueOf();};}
var cx=/[\u0000\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,escapable=/[\\\"\x00-\x1f\x7f-\x9f\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,gap,indent,meta={'\b':'\\b','\t':'\\t','\n':'\\n','\f':'\\f','\r':'\\r','"':'\\"','\\':'\\\\'},rep;function quote(string){escapable.lastIndex=0;return escapable.test(string)?'"'+string.replace(escapable,function(a){var c=meta[a];return typeof c==='string'?c:'\\u'+('0000'+a.charCodeAt(0).toString(16)).slice(-4);})+'"':'"'+string+'"';}
function str(key,holder){var i,k,v,length,mind=gap,partial,value=holder[key];if(value&&typeof value==='object'&&typeof value.toJSON==='function'){value=value.toJSON(key);}
if(typeof rep==='function'){value=rep.call(holder,key,value);}
switch(typeof value){case'string':return quote(value);case'number':return isFinite(value)?String(value):'null';case'boolean':case'null':return String(value);case'object':if(!value){return'null';}
gap+=indent;partial=[];if(Object.prototype.toString.apply(value)==='[object Array]'){length=value.length;for(i=0;i<length;i+=1){partial[i]=str(i,value)||'null';}
v=partial.length===0?'[]':gap?'[\n'+gap+
partial.join(',\n'+gap)+'\n'+
mind+']':'['+partial.join(',')+']';gap=mind;return v;}
if(rep&&typeof rep==='object'){length=rep.length;for(i=0;i<length;i+=1){k=rep[i];if(typeof k==='string'){v=str(k,value);if(v){partial.push(quote(k)+(gap?': ':':')+v);}}}}else{for(k in value){if(Object.hasOwnProperty.call(value,k)){v=str(k,value);if(v){partial.push(quote(k)+(gap?': ':':')+v);}}}}
v=partial.length===0?'{}':gap?'{\n'+gap+partial.join(',\n'+gap)+'\n'+
mind+'}':'{'+partial.join(',')+'}';gap=mind;return v;}}
if(typeof JSON.stringify!=='function'){JSON.stringify=function(value,replacer,space){var i;gap='';indent='';if(typeof space==='number'){for(i=0;i<space;i+=1){indent+=' ';}}else if(typeof space==='string'){indent=space;}
rep=replacer;if(replacer&&typeof replacer!=='function'&&(typeof replacer!=='object'||typeof replacer.length!=='number')){throw new Error('JSON.stringify');}
return str('',{'':value});};}
if(typeof JSON.parse!=='function'){JSON.parse=function(text,reviver){var j;function walk(holder,key){var k,v,value=holder[key];if(value&&typeof value==='object'){for(k in value){if(Object.hasOwnProperty.call(value,k)){v=walk(value,k);if(v!==undefined){value[k]=v;}else{delete value[k];}}}}
return reviver.call(holder,key,value);}
text=String(text);cx.lastIndex=0;if(cx.test(text)){text=text.replace(cx,function(a){return'\\u'+
('0000'+a.charCodeAt(0).toString(16)).slice(-4);});}
if(/^[\],:{}\s]*$/.test(text.replace(/\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g,'@').replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g,']').replace(/(?:^|:|,)(?:\s*\[)+/g,''))){j=eval('('+text+')');return typeof reviver==='function'?walk({'':j},''):j;}
throw new SyntaxError('JSON.parse');};}}());var easyXDMSocket;$(document).ready(function()
{try
{easyXDMSocket=new easyXDM.Socket({swf:"easyxdm/easyxdm.swf",onMessage:function(message,origin)
{try
{if(message=="[balance]")
{$("#system")[0].getMainBalance();}
else if(message=="[close]")
{$("#system")[0].externalExit();}
else
{var value=JSON.parse(message);if(value["action"].toUpperCase()=="CONTINUE_GAME_LOAD")
{siteReady();}
else
{$("#system")[0].onDecoupledDataReceived(value);}}}catch(error){};}});}catch(error){};setLoader();if(siteSettings.isMgsDecoupled)
{sendDecoupledData({action:"PAUSE_GAME_LOAD",data:null});}});function setLoader(width,height){try{var obj=new Object();obj.action="SETLOADER";var jsonString=JSON.stringify(obj);easyXDMSocket.postMessage(jsonString);}catch(error){};}
function setExternalError(){try{var obj=new Object();obj.action="SETERROR";var jsonString=JSON.stringify(obj);easyXDMSocket.postMessage(jsonString);}catch(error){};}
function setExternalInit(width,height){try{var obj=new Object();obj.action="SETINIT";obj.width=width;obj.height=height;var jsonString=JSON.stringify(obj);easyXDMSocket.postMessage(jsonString);}catch(error){};}
function setExternalGameName(arg){try{var obj=new Object();obj.action="SETGAMENAME";obj.data=arg;var jsonString=JSON.stringify(obj);easyXDMSocket.postMessage(jsonString);}catch(error){};}
function setAAMSCode(arg){try{var obj=new Object();obj.action="SETAMMSCODE";obj.data=arg;var jsonString=JSON.stringify(obj);easyXDMSocket.postMessage(jsonString);}catch(error){};}
function setExternalSessionTimer(arg){try{var obj=new Object();obj.action="SETSESSIONTIMER";obj.data=arg;var jsonString=JSON.stringify(obj);easyXDMSocket.postMessage(jsonString);}catch(error){};}
function setExternalBalance(arg){try{var obj=new Object();obj.action="SETBALANCE";obj.data=arg;var jsonString=JSON.stringify(obj);easyXDMSocket.postMessage(jsonString);}catch(error){};}
function setExternalClose(){try{var obj=new Object();obj.action="SETCLOSE";var jsonString=JSON.stringify(obj);easyXDMSocket.postMessage(jsonString);}catch(error){};}
function removeBeforeUnload(){disableBeforeUnload=true;}
function sendDecoupledData(data)
{try
{easyXDMSocket.postMessage(JSON.stringify(data));}
catch(error)
{}}
(function(N,d,p,K,k,H){var b=this;var n=Math.floor(Math.random()*10000);var q=Function.prototype;var Q=/^((http.?:)\/\/([^:\/\s]+)(:\d+)*)/;var R=/[\-\w]+\/\.\.\//;var F=/([^:])\/\//g;var I="";var o={};var M=N.easyXDM;var U="easyXDM_";var E;var y=false;var i;var h;function C(X,Z){var Y=typeof X[Z];return Y=="function"||(!!(Y=="object"&&X[Z]))||Y=="unknown"}function u(X,Y){return!!(typeof(X[Y])=="object"&&X[Y])}function r(X){return Object.prototype.toString.call(X)==="[object Array]"}function c(){var Z="Shockwave Flash",ad="application/x-shockwave-flash";if(!t(navigator.plugins)&&typeof navigator.plugins[Z]=="object"){var ab=navigator.plugins[Z].description;if(ab&&!t(navigator.mimeTypes)&&navigator.mimeTypes[ad]&&navigator.mimeTypes[ad].enabledPlugin){i=ab.match(/\d+/g)}}if(!i){var Y;try{Y=new ActiveXObject("ShockwaveFlash.ShockwaveFlash");i=Array.prototype.slice.call(Y.GetVariable("$version").match(/(\d+),(\d+),(\d+),(\d+)/),1);Y=null}catch(ac){}}if(!i){return false}var X=parseInt(i[0],10),aa=parseInt(i[1],10);h=X>9&&aa>0;return true}var v,x;if(C(N,"addEventListener")){v=function(Z,X,Y){Z.addEventListener(X,Y,false)};x=function(Z,X,Y){Z.removeEventListener(X,Y,false)}}else{if(C(N,"attachEvent")){v=function(X,Z,Y){X.attachEvent("on"+Z,Y)};x=function(X,Z,Y){X.detachEvent("on"+Z,Y)}}else{throw new Error("Browser not supported")}}var W=false,J=[],L;if("readyState"in d){L=d.readyState;W=L=="complete"||(~navigator.userAgent.indexOf("AppleWebKit/")&&(L=="loaded"||L=="interactive"))}else{W=!!d.body}function s(){if(W){return}W=true;for(var X=0;X<J.length;X++){J[X]()}J.length=0}if(!W){if(C(N,"addEventListener")){v(d,"DOMContentLoaded",s)}else{v(d,"readystatechange",function(){if(d.readyState=="complete"){s()}});if(d.documentElement.doScroll&&N===top){var g=function(){if(W){return}try{d.documentElement.doScroll("left")}catch(X){K(g,1);return}s()};g()}}v(N,"load",s)}function G(Y,X){if(W){Y.call(X);return}J.push(function(){Y.call(X)})}function m(){var Z=parent;if(I!==""){for(var X=0,Y=I.split(".");X<Y.length;X++){Z=Z[Y[X]]}}return Z.easyXDM}function e(X){N.easyXDM=M;I=X;if(I){U="easyXDM_"+I.replace(".","_")+"_"}return o}function z(X){return X.match(Q)[3]}function f(X){return X.match(Q)[4]||""}function j(Z){var X=Z.toLowerCase().match(Q);var aa=X[2],ab=X[3],Y=X[4]||"";if((aa=="http:"&&Y==":80")||(aa=="https:"&&Y==":443")){Y=""}return aa+"//"+ab+Y}function B(X){X=X.replace(F,"$1/");if(!X.match(/^(http||https):\/\//)){var Y=(X.substring(0,1)==="/")?"":p.pathname;if(Y.substring(Y.length-1)!=="/"){Y=Y.substring(0,Y.lastIndexOf("/")+1)}X=p.protocol+"//"+p.host+Y+X}while(R.test(X)){X=X.replace(R,"")}return X}function P(X,aa){var ac="",Z=X.indexOf("#");if(Z!==-1){ac=X.substring(Z);X=X.substring(0,Z)}var ab=[];for(var Y in aa){if(aa.hasOwnProperty(Y)){ab.push(Y+"="+H(aa[Y]))}}return X+(y?"#":(X.indexOf("?")==-1?"?":"&"))+ab.join("&")+ac}var S=(function(X){X=X.substring(1).split("&");var Z={},aa,Y=X.length;while(Y--){aa=X[Y].split("=");Z[aa[0]]=k(aa[1])}return Z}(/xdm_e=/.test(p.search)?p.search:p.hash));function t(X){return typeof X==="undefined"}var O=function(){var Y={};var Z={a:[1,2,3]},X='{"a":[1,2,3]}';if(typeof JSON!="undefined"&&typeof JSON.stringify==="function"&&JSON.stringify(Z).replace((/\s/g),"")===X){return JSON}if(Object.toJSON){if(Object.toJSON(Z).replace((/\s/g),"")===X){Y.stringify=Object.toJSON}}if(typeof String.prototype.evalJSON==="function"){Z=X.evalJSON();if(Z.a&&Z.a.length===3&&Z.a[2]===3){Y.parse=function(aa){return aa.evalJSON()}}}if(Y.stringify&&Y.parse){O=function(){return Y};return Y}return null};function T(X,Y,Z){var ab;for(var aa in Y){if(Y.hasOwnProperty(aa)){if(aa in X){ab=Y[aa];if(typeof ab==="object"){T(X[aa],ab,Z)}else{if(!Z){X[aa]=Y[aa]}}}else{X[aa]=Y[aa]}}}return X}function a(){var Y=d.body.appendChild(d.createElement("form")),X=Y.appendChild(d.createElement("input"));X.name=U+"TEST"+n;E=X!==Y.elements[X.name];d.body.removeChild(Y)}function A(Y){if(t(E)){a()}var ac;if(E){ac=d.createElement('<iframe name="'+Y.props.name+'"/>')}else{ac=d.createElement("IFRAME");ac.name=Y.props.name}ac.id=ac.name=Y.props.name;delete Y.props.name;if(typeof Y.container=="string"){Y.container=d.getElementById(Y.container)}if(!Y.container){T(ac.style,{position:"absolute",top:"-2000px",left:"0px"});Y.container=d.body}var ab=Y.props.src;Y.props.src="javascript:false";T(ac,Y.props);ac.border=ac.frameBorder=0;ac.allowTransparency=true;Y.container.appendChild(ac);if(Y.onLoad){v(ac,"load",Y.onLoad)}if(Y.usePost){var aa=Y.container.appendChild(d.createElement("form")),X;aa.target=ac.name;aa.action=ab;aa.method="POST";if(typeof(Y.usePost)==="object"){for(var Z in Y.usePost){if(Y.usePost.hasOwnProperty(Z)){if(E){X=d.createElement('<input name="'+Z+'"/>')}else{X=d.createElement("INPUT");X.name=Z}X.value=Y.usePost[Z];aa.appendChild(X)}}}aa.submit();aa.parentNode.removeChild(aa)}else{ac.src=ab}Y.props.src=ab;return ac}function V(aa,Z){if(typeof aa=="string"){aa=[aa]}var Y,X=aa.length;while(X--){Y=aa[X];Y=new RegExp(Y.substr(0,1)=="^"?Y:("^"+Y.replace(/(\*)/g,".$1").replace(/\?/g,".")+"$"));if(Y.test(Z)){return true}}return false}function l(Z){var ae=Z.protocol,Y;Z.isHost=Z.isHost||t(S.xdm_p);y=Z.hash||false;if(!Z.props){Z.props={}}if(!Z.isHost){Z.channel=S.xdm_c.replace(/["'<>\\]/g,"");Z.secret=S.xdm_s;Z.remote=S.xdm_e.replace(/["'<>\\]/g,"");ae=S.xdm_p;if(Z.acl&&!V(Z.acl,Z.remote)){throw new Error("Access denied for "+Z.remote)}}else{Z.remote=B(Z.remote);Z.channel=Z.channel||"default"+n++;Z.secret=Math.random().toString(16).substring(2);if(t(ae)){if(j(p.href)==j(Z.remote)){ae="4"}else{if(C(N,"postMessage")||C(d,"postMessage")){ae="1"}else{if(Z.swf&&C(N,"ActiveXObject")&&c()){ae="6"}else{if(navigator.product==="Gecko"&&"frameElement"in N&&navigator.userAgent.indexOf("WebKit")==-1){ae="5"}else{if(Z.remoteHelper){ae="2"}else{ae="0"}}}}}}}Z.protocol=ae;switch(ae){case"0":T(Z,{interval:100,delay:2000,useResize:true,useParent:false,usePolling:false},true);if(Z.isHost){if(!Z.local){var ac=p.protocol+"//"+p.host,X=d.body.getElementsByTagName("img"),ad;var aa=X.length;while(aa--){ad=X[aa];if(ad.src.substring(0,ac.length)===ac){Z.local=ad.src;break}}if(!Z.local){Z.local=N}}var ab={xdm_c:Z.channel,xdm_p:0};if(Z.local===N){Z.usePolling=true;Z.useParent=true;Z.local=p.protocol+"//"+p.host+p.pathname+p.search;ab.xdm_e=Z.local;ab.xdm_pa=1}else{ab.xdm_e=B(Z.local)}if(Z.container){Z.useResize=false;ab.xdm_po=1}Z.remote=P(Z.remote,ab)}else{T(Z,{channel:S.xdm_c,remote:S.xdm_e,useParent:!t(S.xdm_pa),usePolling:!t(S.xdm_po),useResize:Z.useParent?false:Z.useResize})}Y=[new o.stack.HashTransport(Z),new o.stack.ReliableBehavior({}),new o.stack.QueueBehavior({encode:true,maxLength:4000-Z.remote.length}),new o.stack.VerifyBehavior({initiate:Z.isHost})];break;case"1":Y=[new o.stack.PostMessageTransport(Z)];break;case"2":Z.remoteHelper=B(Z.remoteHelper);Y=[new o.stack.NameTransport(Z),new o.stack.QueueBehavior(),new o.stack.VerifyBehavior({initiate:Z.isHost})];break;case"3":Y=[new o.stack.NixTransport(Z)];break;case"4":Y=[new o.stack.SameOriginTransport(Z)];break;case"5":Y=[new o.stack.FrameElementTransport(Z)];break;case"6":if(!i){c()}Y=[new o.stack.FlashTransport(Z)];break}Y.push(new o.stack.QueueBehavior({lazy:Z.lazy,remove:true}));return Y}function D(aa){var ab,Z={incoming:function(ad,ac){this.up.incoming(ad,ac)},outgoing:function(ac,ad){this.down.outgoing(ac,ad)},callback:function(ac){this.up.callback(ac)},init:function(){this.down.init()},destroy:function(){this.down.destroy()}};for(var Y=0,X=aa.length;Y<X;Y++){ab=aa[Y];T(ab,Z,true);if(Y!==0){ab.down=aa[Y-1]}if(Y!==X-1){ab.up=aa[Y+1]}}return ab}function w(X){X.up.down=X.down;X.down.up=X.up;X.up=X.down=null}T(o,{version:"2.4.17.1",query:S,stack:{},apply:T,getJSONObject:O,whenReady:G,noConflict:e});o.DomHelper={on:v,un:x,requiresJSON:function(X){if(!u(N,"JSON")){d.write('<script type="text/javascript" src="'+X+'"><\/script>')}}};(function(){var X={};o.Fn={set:function(Y,Z){X[Y]=Z},get:function(Z,Y){var aa=X[Z];if(Y){delete X[Z]}return aa}}}());o.Socket=function(Y){var X=D(l(Y).concat([{incoming:function(ab,aa){Y.onMessage(ab,aa)},callback:function(aa){if(Y.onReady){Y.onReady(aa)}}}])),Z=j(Y.remote);this.origin=j(Y.remote);this.destroy=function(){X.destroy()};this.postMessage=function(aa){X.outgoing(aa,Z)};X.init()};o.Rpc=function(Z,Y){if(Y.local){for(var ab in Y.local){if(Y.local.hasOwnProperty(ab)){var aa=Y.local[ab];if(typeof aa==="function"){Y.local[ab]={method:aa}}}}}var X=D(l(Z).concat([new o.stack.RpcBehavior(this,Y),{callback:function(ac){if(Z.onReady){Z.onReady(ac)}}}]));this.origin=j(Z.remote);this.destroy=function(){X.destroy()};X.init()};o.stack.SameOriginTransport=function(Y){var Z,ab,aa,X;return(Z={outgoing:function(ad,ae,ac){aa(ad);if(ac){ac()}},destroy:function(){if(ab){ab.parentNode.removeChild(ab);ab=null}},onDOMReady:function(){X=j(Y.remote);if(Y.isHost){T(Y.props,{src:P(Y.remote,{xdm_e:p.protocol+"//"+p.host+p.pathname,xdm_c:Y.channel,xdm_p:4}),name:U+Y.channel+"_provider"});ab=A(Y);o.Fn.set(Y.channel,function(ac){aa=ac;K(function(){Z.up.callback(true)},0);return function(ad){Z.up.incoming(ad,X)}})}else{aa=m().Fn.get(Y.channel,true)(function(ac){Z.up.incoming(ac,X)});K(function(){Z.up.callback(true)},0)}},init:function(){G(Z.onDOMReady,Z)}})};o.stack.FlashTransport=function(aa){var ac,X,ab,ad,Y,ae;function af(ah,ag){K(function(){ac.up.incoming(ah,ad)},0)}function Z(ah){var ag=aa.swf+"?host="+aa.isHost;var aj="easyXDM_swf_"+Math.floor(Math.random()*10000);o.Fn.set("flash_loaded"+ah.replace(/[\-.]/g,"_"),function(){o.stack.FlashTransport[ah].swf=Y=ae.firstChild;var ak=o.stack.FlashTransport[ah].queue;for(var al=0;al<ak.length;al++){ak[al]()}ak.length=0});if(aa.swfContainer){ae=(typeof aa.swfContainer=="string")?d.getElementById(aa.swfContainer):aa.swfContainer}else{ae=d.createElement("div");T(ae.style,h&&aa.swfNoThrottle?{height:"20px",width:"20px",position:"fixed",right:0,top:0}:{height:"1px",width:"1px",position:"absolute",overflow:"hidden",right:0,top:0});d.body.appendChild(ae)}var ai="callback=flash_loaded"+ah.replace(/[\-.]/g,"_")+"&proto="+b.location.protocol+"&domain="+z(b.location.href)+"&port="+f(b.location.href)+"&ns="+I;ae.innerHTML="<object height='20' width='20' type='application/x-shockwave-flash' id='"+aj+"' data='"+ag+"'><param name='allowScriptAccess' value='always'></param><param name='wmode' value='transparent'><param name='movie' value='"+ag+"'></param><param name='flashvars' value='"+ai+"'></param><embed type='application/x-shockwave-flash' FlashVars='"+ai+"' allowScriptAccess='always' wmode='transparent' src='"+ag+"' height='1' width='1'></embed></object>"}return(ac={outgoing:function(ah,ai,ag){Y.postMessage(aa.channel,ah.toString());if(ag){ag()}},destroy:function(){try{Y.destroyChannel(aa.channel)}catch(ag){}Y=null;if(X){X.parentNode.removeChild(X);X=null}},onDOMReady:function(){ad=aa.remote;o.Fn.set("flash_"+aa.channel+"_init",function(){K(function(){ac.up.callback(true)})});o.Fn.set("flash_"+aa.channel+"_onMessage",af);aa.swf=B(aa.swf);var ah=z(aa.swf);var ag=function(){o.stack.FlashTransport[ah].init=true;Y=o.stack.FlashTransport[ah].swf;Y.createChannel(aa.channel,aa.secret,j(aa.remote),aa.isHost);if(aa.isHost){if(h&&aa.swfNoThrottle){T(aa.props,{position:"fixed",right:0,top:0,height:"20px",width:"20px"})}T(aa.props,{src:P(aa.remote,{xdm_e:j(p.href),xdm_c:aa.channel,xdm_p:6,xdm_s:aa.secret}),name:U+aa.channel+"_provider"});X=A(aa)}};if(o.stack.FlashTransport[ah]&&o.stack.FlashTransport[ah].init){ag()}else{if(!o.stack.FlashTransport[ah]){o.stack.FlashTransport[ah]={queue:[ag]};Z(ah)}else{o.stack.FlashTransport[ah].queue.push(ag)}}},init:function(){G(ac.onDOMReady,ac)}})};o.stack.PostMessageTransport=function(aa){var ac,ad,Y,Z;function X(ae){if(ae.origin){return j(ae.origin)}if(ae.uri){return j(ae.uri)}if(ae.domain){return p.protocol+"//"+ae.domain}throw"Unable to retrieve the origin of the event"}function ab(af){var ae=X(af);if(ae==Z&&af.data.substring(0,aa.channel.length+1)==aa.channel+" "){ac.up.incoming(af.data.substring(aa.channel.length+1),ae)}}return(ac={outgoing:function(af,ag,ae){Y.postMessage(aa.channel+" "+af,ag||Z);if(ae){ae()}},destroy:function(){x(N,"message",ab);if(ad){Y=null;ad.parentNode.removeChild(ad);ad=null}},onDOMReady:function(){Z=j(aa.remote);if(aa.isHost){var ae=function(af){if(af.data==aa.channel+"-ready"){Y=("postMessage"in ad.contentWindow)?ad.contentWindow:ad.contentWindow.document;x(N,"message",ae);v(N,"message",ab);K(function(){ac.up.callback(true)},0)}};v(N,"message",ae);T(aa.props,{src:P(aa.remote,{xdm_e:j(p.href),xdm_c:aa.channel,xdm_p:1}),name:U+aa.channel+"_provider"});ad=A(aa)}else{v(N,"message",ab);Y=("postMessage"in N.parent)?N.parent:N.parent.document;Y.postMessage(aa.channel+"-ready",Z);K(function(){ac.up.callback(true)},0)}},init:function(){G(ac.onDOMReady,ac)}})};o.stack.FrameElementTransport=function(Y){var Z,ab,aa,X;return(Z={outgoing:function(ad,ae,ac){aa.call(this,ad);if(ac){ac()}},destroy:function(){if(ab){ab.parentNode.removeChild(ab);ab=null}},onDOMReady:function(){X=j(Y.remote);if(Y.isHost){T(Y.props,{src:P(Y.remote,{xdm_e:j(p.href),xdm_c:Y.channel,xdm_p:5}),name:U+Y.channel+"_provider"});ab=A(Y);ab.fn=function(ac){delete ab.fn;aa=ac;K(function(){Z.up.callback(true)},0);return function(ad){Z.up.incoming(ad,X)}}}else{if(d.referrer&&j(d.referrer)!=S.xdm_e){N.top.location=S.xdm_e}aa=N.frameElement.fn(function(ac){Z.up.incoming(ac,X)});Z.up.callback(true)}},init:function(){G(Z.onDOMReady,Z)}})};o.stack.NameTransport=function(ab){var ac;var ae,ai,aa,ag,ah,Y,X;function af(al){var ak=ab.remoteHelper+(ae?"#_3":"#_2")+ab.channel;ai.contentWindow.sendMessage(al,ak)}function ad(){if(ae){if(++ag===2||!ae){ac.up.callback(true)}}else{af("ready");ac.up.callback(true)}}function aj(ak){ac.up.incoming(ak,Y)}function Z(){if(ah){K(function(){ah(true)},0)}}return(ac={outgoing:function(al,am,ak){ah=ak;af(al)},destroy:function(){ai.parentNode.removeChild(ai);ai=null;if(ae){aa.parentNode.removeChild(aa);aa=null}},onDOMReady:function(){ae=ab.isHost;ag=0;Y=j(ab.remote);ab.local=B(ab.local);if(ae){o.Fn.set(ab.channel,function(al){if(ae&&al==="ready"){o.Fn.set(ab.channel,aj);ad()}});X=P(ab.remote,{xdm_e:ab.local,xdm_c:ab.channel,xdm_p:2});T(ab.props,{src:X+"#"+ab.channel,name:U+ab.channel+"_provider"});aa=A(ab)}else{ab.remoteHelper=ab.remote;o.Fn.set(ab.channel,aj)}var ak=function(){var al=ai||this;x(al,"load",ak);o.Fn.set(ab.channel+"_load",Z);(function am(){if(typeof al.contentWindow.sendMessage=="function"){ad()}else{K(am,50)}}())};ai=A({props:{src:ab.local+"#_4"+ab.channel},onLoad:ak})},init:function(){G(ac.onDOMReady,ac)}})};o.stack.HashTransport=function(Z){var ac;var ah=this,af,aa,X,ad,am,ab,al;var ag,Y;function ak(ao){if(!al){return}var an=Z.remote+"#"+(am++)+"_"+ao;((af||!ag)?al.contentWindow:al).location=an}function ae(an){ad=an;ac.up.incoming(ad.substring(ad.indexOf("_")+1),Y)}function aj(){if(!ab){return}var an=ab.location.href,ap="",ao=an.indexOf("#");if(ao!=-1){ap=an.substring(ao)}if(ap&&ap!=ad){ae(ap)}}function ai(){aa=setInterval(aj,X)}return(ac={outgoing:function(an,ao){ak(an)},destroy:function(){N.clearInterval(aa);if(af||!ag){al.parentNode.removeChild(al)}al=null},onDOMReady:function(){af=Z.isHost;X=Z.interval;ad="#"+Z.channel;am=0;ag=Z.useParent;Y=j(Z.remote);if(af){T(Z.props,{src:Z.remote,name:U+Z.channel+"_provider"});if(ag){Z.onLoad=function(){ab=N;ai();ac.up.callback(true)}}else{var ap=0,an=Z.delay/50;(function ao(){if(++ap>an){throw new Error("Unable to reference listenerwindow")}try{ab=al.contentWindow.frames[U+Z.channel+"_consumer"]}catch(aq){}if(ab){ai();ac.up.callback(true)}else{K(ao,50)}}())}al=A(Z)}else{ab=N;ai();if(ag){al=parent;ac.up.callback(true)}else{T(Z,{props:{src:Z.remote+"#"+Z.channel+new Date(),name:U+Z.channel+"_consumer"},onLoad:function(){ac.up.callback(true)}});al=A(Z)}}},init:function(){G(ac.onDOMReady,ac)}})};o.stack.ReliableBehavior=function(Y){var aa,ac;var ab=0,X=0,Z="";return(aa={incoming:function(af,ad){var ae=af.indexOf("_"),ag=af.substring(0,ae).split(",");af=af.substring(ae+1);if(ag[0]==ab){Z="";if(ac){ac(true);ac=null}}if(af.length>0){aa.down.outgoing(ag[1]+","+ab+"_"+Z,ad);if(X!=ag[1]){X=ag[1];aa.up.incoming(af,ad)}}},outgoing:function(af,ad,ae){Z=af;ac=ae;aa.down.outgoing(X+","+(++ab)+"_"+af,ad)}})};o.stack.QueueBehavior=function(Z){var ac,ad=[],ag=true,aa="",af,X=0,Y=false,ab=false;function ae(){if(Z.remove&&ad.length===0){w(ac);return}if(ag||ad.length===0||af){return}ag=true;var ah=ad.shift();ac.down.outgoing(ah.data,ah.origin,function(ai){ag=false;if(ah.callback){K(function(){ah.callback(ai)},0)}ae()})}return(ac={init:function(){if(t(Z)){Z={}}if(Z.maxLength){X=Z.maxLength;ab=true}if(Z.lazy){Y=true}else{ac.down.init()}},callback:function(ai){ag=false;var ah=ac.up;ae();ah.callback(ai)},incoming:function(ak,ai){if(ab){var aj=ak.indexOf("_"),ah=parseInt(ak.substring(0,aj),10);aa+=ak.substring(aj+1);if(ah===0){if(Z.encode){aa=k(aa)}ac.up.incoming(aa,ai);aa=""}}else{ac.up.incoming(ak,ai)}},outgoing:function(al,ai,ak){if(Z.encode){al=H(al)}var ah=[],aj;if(ab){while(al.length!==0){aj=al.substring(0,X);al=al.substring(aj.length);ah.push(aj)}while((aj=ah.shift())){ad.push({data:ah.length+"_"+aj,origin:ai,callback:ah.length===0?ak:null})}}else{ad.push({data:al,origin:ai,callback:ak})}if(Y){ac.down.init()}else{ae()}},destroy:function(){af=true;ac.down.destroy()}})};o.stack.VerifyBehavior=function(ab){var ac,aa,Y,Z=false;function X(){aa=Math.random().toString(16).substring(2);ac.down.outgoing(aa)}return(ac={incoming:function(af,ad){var ae=af.indexOf("_");if(ae===-1){if(af===aa){ac.up.callback(true)}else{if(!Y){Y=af;if(!ab.initiate){X()}ac.down.outgoing(af)}}}else{if(af.substring(0,ae)===Y){ac.up.incoming(af.substring(ae+1),ad)}}},outgoing:function(af,ad,ae){ac.down.outgoing(aa+"_"+af,ad,ae)},callback:function(ad){if(ab.initiate){X()}}})};o.stack.RpcBehavior=function(ad,Y){var aa,af=Y.serializer||O();var ae=0,ac={};function X(ag){ag.jsonrpc="2.0";aa.down.outgoing(af.stringify(ag))}function ab(ag,ai){var ah=Array.prototype.slice;return function(){var aj=arguments.length,al,ak={method:ai};if(aj>0&&typeof arguments[aj-1]==="function"){if(aj>1&&typeof arguments[aj-2]==="function"){al={success:arguments[aj-2],error:arguments[aj-1]};ak.params=ah.call(arguments,0,aj-2)}else{al={success:arguments[aj-1]};ak.params=ah.call(arguments,0,aj-1)}ac[""+(++ae)]=al;ak.id=ae}else{ak.params=ah.call(arguments,0)}if(ag.namedParams&&ak.params.length===1){ak.params=ak.params[0]}X(ak)}}function Z(an,am,ai,al){if(!ai){if(am){X({id:am,error:{code:-32601,message:"Procedure not found."}})}return}var ak,ah;if(am){ak=function(ao){ak=q;X({id:am,result:ao})};ah=function(ao,ap){ah=q;var aq={id:am,error:{code:-32099,message:ao}};if(ap){aq.error.data=ap}X(aq)}}else{ak=ah=q}if(!r(al)){al=[al]}try{var ag=ai.method.apply(ai.scope,al.concat([ak,ah]));if(!t(ag)){ak(ag)}}catch(aj){ah(aj.message)}}return(aa={incoming:function(ah,ag){var ai=af.parse(ah);if(ai.method){if(Y.handle){Y.handle(ai,X)}else{Z(ai.method,ai.id,Y.local[ai.method],ai.params)}}else{var aj=ac[ai.id];if(ai.error){if(aj.error){aj.error(ai.error)}}else{if(aj.success){aj.success(ai.result)}}delete ac[ai.id]}},init:function(){if(Y.remote){for(var ag in Y.remote){if(Y.remote.hasOwnProperty(ag)){ad[ag]=ab(Y.remote[ag],ag)}}}aa.down.init()},destroy:function(){for(var ag in Y.remote){if(Y.remote.hasOwnProperty(ag)&&ad.hasOwnProperty(ag)){delete ad[ag]}}aa.down.destroy()}})};b.easyXDM=o})(window,document,location,window.setTimeout,decodeURIComponent,encodeURIComponent);function loadMyPromo(content){if(document.getElementById("frmDiv")==null){div=document.createElement("div");div.setAttribute("id","frmDiv");document.body.appendChild(div);}
document.getElementById("frmDiv").innerHTML=content;}
function checkElem(name){if(document.getElementById(name)==null){return false;}
else{return true;}}
function log(message){if(typeof console=="object"){console.log(message);}}
var promoSocket;function sendPromoFavouritesDetails(arg){if(promoSocket){var obj=new Object();obj.action="[PROMO.FAVOURITES]";obj.items=arg;promoSocket.postMessage(JSON.stringify(obj));}}
var maxWidth=1024;var maxHeight=768;function setLobbySetting(lobbyW,lobbyH){maxWidth=lobbyW;maxHeight=lobbyH;if($(window).width()>maxWidth&&$(window).height()>maxHeight&&!siteSettings.isMgsTopBar&&!siteSettings.isMgsDecoupled)
{if($('#system').width()!=maxWidth)
{$('#system').attr({width:maxWidth+'px',height:maxHeight+'px'});}
$('#system').css({marginLeft:(($(window).width()-maxWidth)/2)+'px',marginTop:(($(window).height()-maxHeight)/2)+'px'});}
else
{$('#system').attr({width:'100%',height:'100%'});$('#system').css({marginLeft:'0px',marginTop:'0px'});}}
jQuery.easing['jswing']=jQuery.easing['swing'];jQuery.extend(jQuery.easing,{def:'easeOutQuad',swing:function(x,t,b,c,d){return jQuery.easing[jQuery.easing.def](x,t,b,c,d);},easeInQuad:function(x,t,b,c,d){return c*(t/=d)*t+b;},easeOutQuad:function(x,t,b,c,d){return-c*(t/=d)*(t-2)+b;},easeInOutQuad:function(x,t,b,c,d){if((t/=d/2)<1)return c/2*t*t+b;return-c/2*((--t)*(t-2)-1)+b;},easeInCubic:function(x,t,b,c,d){return c*(t/=d)*t*t+b;},easeOutCubic:function(x,t,b,c,d){return c*((t=t/d-1)*t*t+1)+b;},easeInOutCubic:function(x,t,b,c,d){if((t/=d/2)<1)return c/2*t*t*t+b;return c/2*((t-=2)*t*t+2)+b;},easeInQuart:function(x,t,b,c,d){return c*(t/=d)*t*t*t+b;},easeOutQuart:function(x,t,b,c,d){return-c*((t=t/d-1)*t*t*t-1)+b;},easeInOutQuart:function(x,t,b,c,d){if((t/=d/2)<1)return c/2*t*t*t*t+b;return-c/2*((t-=2)*t*t*t-2)+b;},easeInQuint:function(x,t,b,c,d){return c*(t/=d)*t*t*t*t+b;},easeOutQuint:function(x,t,b,c,d){return c*((t=t/d-1)*t*t*t*t+1)+b;},easeInOutQuint:function(x,t,b,c,d){if((t/=d/2)<1)return c/2*t*t*t*t*t+b;return c/2*((t-=2)*t*t*t*t+2)+b;},easeInSine:function(x,t,b,c,d){return-c*Math.cos(t/d*(Math.PI/2))+c+b;},easeOutSine:function(x,t,b,c,d){return c*Math.sin(t/d*(Math.PI/2))+b;},easeInOutSine:function(x,t,b,c,d){return-c/2*(Math.cos(Math.PI*t/d)-1)+b;},easeInExpo:function(x,t,b,c,d){return(t==0)?b:c*Math.pow(2,10*(t/d-1))+b;},easeOutExpo:function(x,t,b,c,d){return(t==d)?b+c:c*(-Math.pow(2,-10*t/d)+1)+b;},easeInOutExpo:function(x,t,b,c,d){if(t==0)return b;if(t==d)return b+c;if((t/=d/2)<1)return c/2*Math.pow(2,10*(t-1))+b;return c/2*(-Math.pow(2,-10*--t)+2)+b;},easeInCirc:function(x,t,b,c,d){return-c*(Math.sqrt(1-(t/=d)*t)-1)+b;},easeOutCirc:function(x,t,b,c,d){return c*Math.sqrt(1-(t=t/d-1)*t)+b;},easeInOutCirc:function(x,t,b,c,d){if((t/=d/2)<1)return-c/2*(Math.sqrt(1-t*t)-1)+b;return c/2*(Math.sqrt(1-(t-=2)*t)+1)+b;},easeInElastic:function(x,t,b,c,d){var s=1.70158;var p=0;var a=c;if(t==0)return b;if((t/=d)==1)return b+c;if(!p)p=d*.3;if(a<Math.abs(c)){a=c;var s=p/4;}
else var s=p/(2*Math.PI)*Math.asin(c/a);return-(a*Math.pow(2,10*(t-=1))*Math.sin((t*d-s)*(2*Math.PI)/p))+b;},easeOutElastic:function(x,t,b,c,d){var s=1.70158;var p=0;var a=c;if(t==0)return b;if((t/=d)==1)return b+c;if(!p)p=d*.3;if(a<Math.abs(c)){a=c;var s=p/4;}
else var s=p/(2*Math.PI)*Math.asin(c/a);return a*Math.pow(2,-10*t)*Math.sin((t*d-s)*(2*Math.PI)/p)+c+b;},easeInOutElastic:function(x,t,b,c,d){var s=1.70158;var p=0;var a=c;if(t==0)return b;if((t/=d/2)==2)return b+c;if(!p)p=d*(.3*1.5);if(a<Math.abs(c)){a=c;var s=p/4;}
else var s=p/(2*Math.PI)*Math.asin(c/a);if(t<1)return-.5*(a*Math.pow(2,10*(t-=1))*Math.sin((t*d-s)*(2*Math.PI)/p))+b;return a*Math.pow(2,-10*(t-=1))*Math.sin((t*d-s)*(2*Math.PI)/p)*.5+c+b;},easeInBack:function(x,t,b,c,d,s){if(s==undefined)s=1.70158;return c*(t/=d)*t*((s+1)*t-s)+b;},easeOutBack:function(x,t,b,c,d,s){if(s==undefined)s=1.70158;return c*((t=t/d-1)*t*((s+1)*t+s)+1)+b;},easeInOutBack:function(x,t,b,c,d,s){if(s==undefined)s=1.70158;if((t/=d/2)<1)return c/2*(t*t*(((s*=(1.525))+1)*t-s))+b;return c/2*((t-=2)*t*(((s*=(1.525))+1)*t+s)+2)+b;},easeInBounce:function(x,t,b,c,d){return c-jQuery.easing.easeOutBounce(x,d-t,0,c,d)+b;},easeOutBounce:function(x,t,b,c,d){if((t/=d)<(1/2.75)){return c*(7.5625*t*t)+b;}else if(t<(2/2.75)){return c*(7.5625*(t-=(1.5/2.75))*t+.75)+b;}else if(t<(2.5/2.75)){return c*(7.5625*(t-=(2.25/2.75))*t+.9375)+b;}else{return c*(7.5625*(t-=(2.625/2.75))*t+.984375)+b;}},easeInOutBounce:function(x,t,b,c,d){if(t<d/2)return jQuery.easing.easeInBounce(x,t*2,0,c,d)*.5+b;return jQuery.easing.easeOutBounce(x,t*2-d,0,c,d)*.5+c*.5+b;}});