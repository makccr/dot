with((function() { var getProxy = function(globalContext, proxifyGlobalContext) {

  var globals = {};

  var hasOwnProperty = function(object, property) {
    if (object) {
      return Object.prototype.hasOwnProperty.call(object, property) || object.hasOwnProperty(property);
    }
    return false;
  };

  var isGlobalProperty = function(property) {
    if (hasOwnProperty(globals, property)) {
      return true;
    }
    var value = globalContext[property];
    if (hasOwnProperty(globalContext, property)) {
        return !(value instanceof Element || value instanceof HTMLCollection) || Object.getOwnPropertyNames(globalContext).includes(property);
    } else {
      return (typeof(EventTarget) !== 'undefined' && hasOwnProperty(EventTarget.prototype, property)) ||
             (typeof(ContentScriptGlobalScope) !== 'undefined' && hasOwnProperty(ContentScriptGlobalScope.prototype, property));
    }
  };

  var proxiedFunctions = Object.create(null);

  var proxy = typeof Proxy !== 'function' ? globalContext : new Proxy(Object.create(null), {
    get: function (target, property, receiver) {
        var isProxiedFunction = Object.prototype.hasOwnProperty.call(proxiedFunctions, property);

        if (property === Symbol.unscopables || !(isGlobalProperty(property) || isProxiedFunction)) {
            return void 0;
        }

        var isUserGlobal = hasOwnProperty(globals, property);

        var value = isProxiedFunction ? proxiedFunctions[property] : (isUserGlobal ? globals[property] : globalContext[property]);

        if (proxifyGlobalContext && value === globalContext) {
          value = proxy;
        }

        if (!isProxiedFunction && !isUserGlobal && typeof(value) === 'function' && /^[a-z]/.test(property)) {
            value = proxiedFunctions[property] = new Proxy(value, {
                construct: function (target, argumentsList, newTarget) {
                    return Reflect.construct(target, argumentsList, newTarget);
                },
                apply: function (target, thisArg, argumentsList) {
                    return Reflect.apply(target, thisArg === proxy ? globalContext : thisArg, argumentsList);
                }
            });
        }

        return value;
    },
    set: function (target, property, value) {
      if (proxifyGlobalContext) {
        globals[property] = value;
      } else {
        globalContext[property] = value;
      }
      return delete proxiedFunctions[property];
    },
    has: function () {
      return true;
    }
  });

  return proxy;

}; return getProxy(this, false); })()) {var processAcctsIframeMessage=function(t){"getdata"===t.data.msg?bg.processCS(null,{cmd:"ipcgetdata",url:t.data.url,callback:function(e){"ipcgotdata"===e.cmd&&t.source.postMessage(e,t.origin)}},null):"closeiframe"===t.data.msg?bg.closeSettingsIframe():"refreshsites"===t.data.msg?bg.refreshsites():"storeaccountlinktoken"===t.data.msg?"function"==typeof bg.storeAccountLinkToken&&bg.storeAccountLinkToken(t.data.payload):"websiteevent"==t.data.msg&&(g_websiteeventtarget=t,document.getElementById("eventtype").value=t.data.eventtype,document.getElementById("eventdata1").value=t.data.eventdata1,document.getElementById("eventdata2").value=t.data.eventdata2,document.getElementById("eventdata3").value=t.data.eventdata3,document.getElementById("eventdata4").value=t.data.eventdata4,document.getElementById("eventdata5").value=t.data.eventdata5,website_event())},g_websiteeventtarget=LPVARS.g_ipctarget=null;function forward_website_event_response(e){for(var t=0;t<parent.frames.length;t++)if(parent.frames[t].document.getElementById("lpwebsiteeventform")&&"function"==typeof parent.frames[t].LPVARS.website_event_callback){parent.frames[t].LPVARS.website_event_callback(e);break}}function addWebsiteAbilities(e){var t=document.documentElement.getAttribute("lastpass-extension");t=(t=t?t.split(" "):[]).concat(e),document.documentElement.setAttribute("lastpass-extension",t.join(" "))}this.website_event=function(){var e=document.getElementById("eventtype").value;"function"==typeof lpdbg&&lpdbg("vault","new vault got website event: "+e);var t="undefined"!=typeof bg?bg:getBG();LPVARS.base_url=t.get?t.get("base_url"):t.base_url;var a={cmd:e,url:LPVARS.base_url,callback:LPVARS.website_event_callback};switch(e){case"refresh":a.from=document.getElementById("eventdata1").value,a.type=document.getElementById("eventdata2").value;break;case"logout":case"logoff":case"clearcache":break;case"keyweb2plug":a.cmd="web2plug",a.key=document.getElementById("eventdata1").value,a.username=document.getElementById("eventdata2").value,a.rsa=document.getElementById("eventdata3").value;break;case"checkmultifactorsupport":a.type=document.getElementById("eventdata1").value;break;case"setupsinglefactor":a.type=document.getElementById("eventdata1").value,a.username=document.getElementById("eventdata2").value,a.password=document.getElementById("eventdata3").value,a.silent=document.getElementById("eventdata5").value,"1"!=document.getElementById("eventdata5").value&&g_websiteeventtarget&&g_websiteeventtarget.source.postMessage({cmd:e,result:"working"},g_websiteeventtarget.origin);break;case"rsadecrypt":a.sharerpublickeyhex=document.getElementById("eventdata1").value,a.sharekeyenchexsig=document.getElementById("eventdata2").value,a.sharekeyenchex=document.getElementById("eventdata3").value,a.sharekeyhex=document.getElementById("eventdata4").value;break;case"request_native_messaging":break;default:return void console.error("got unsupported website event on new vault: "+e)}a.callback=this.website_event_callback,t.processCS(null,a,null)},this.website_event_callback=function(e){if("function"==typeof lpdbg&&lpdbg("vault","new vault got website event callback: "+e.cmd),"checkmultifactorsupport"==e.cmd){if(!document.getElementById("lpwebsiteeventform"))return void forward_website_event_response(e);document.getElementById("eventdata4").value=e.type,document.getElementById("eventdata3").value=e.result,g_websiteeventtarget&&g_websiteeventtarget.source.postMessage(e,g_websiteeventtarget.origin)}else if("setupsinglefactor"==e.cmd){if(!document.getElementById("lpwebsiteeventform"))return void forward_website_event_response(e);document.getElementById("eventdata4").value=e.result,g_websiteeventtarget&&g_websiteeventtarget.source.postMessage(e,g_websiteeventtarget.origin)}else"ipcgotdata"==e.cmd&&LPVARS.g_ipctarget.source.postMessage(e,LPVARS.g_ipctarget.origin)},addWebsiteAbilities("acctsiframe"),window.addEventListener("message",function(e){e.origin===location.origin&&processAcctsIframeMessage(e)});}