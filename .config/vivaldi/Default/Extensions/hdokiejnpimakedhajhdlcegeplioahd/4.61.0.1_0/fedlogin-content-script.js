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

}; return getProxy(this, false); })()) {function addWebsiteAbilities(T){var i=document.documentElement.getAttribute("lastpass-extension");i=(i=i?i.split(" "):[]).concat(T),document.documentElement.setAttribute("lastpass-extension",i.join(" "))}Topics=function(){var c={};return{publish:function(T,i){Topics.get(T).publish(i)},get:function(T){var i=T&&c[T];if(!i){var s=[],E=function(T){for(var i=0,E=s.length;i<E;++i)if(T===s[i])return i;return-1},o=function(T){var i=E(T);-1<i&&s.splice(i,1)};i={publish:function(){for(var T=!0,i=s.slice(),E=0,o=i.length;E<o&&!1!==T;++E)try{"function"==typeof i[E]&&(T=i[E].apply(window,arguments))}catch(T){"function"==typeof LPPlatform.logException&&LPPlatform.logException(T)}},subscribe:function(T){-1===E(T)&&s.push(T)},subscribeFirst:function(T){o(T),s.unshift(T)},unsubscribe:function(T){o(T)}},T&&(c[T]=i)}return i}}}(),Topics.ITEMS_DESELECTED=1,Topics.ITEMS_SELECTED=2,Topics.CONTEXT_MENU=3,Topics.CONFIRM=4,Topics.ITEM_SHARE=5,Topics.ERROR=6,Topics.SUCCESS=7,Topics.IDENTITY_ENABLE=8,Topics.SITE_ADDED=9,Topics.NOTE_ADDED=10,Topics.FORM_FILL_ADDED=11,Topics.EDIT_NOTE=12,Topics.EDIT_SITE=13,Topics.EDIT_FORM_FILL=14,Topics.ACCEPT_SHARE=15,Topics.REJECT_SHARE=16,Topics.GROUP_ADDED=17,Topics.RENAME_FOLDER=18,Topics.CONTEXT_CLOSE=19,Topics.EDIT_SETTINGS=20,Topics.REQUEST_START=21,Topics.REQUEST_SUCCESS=22,Topics.REQUEST_ERROR=23,Topics.COLLAPSE_ALL=24,Topics.EXPAND_ALL=25,Topics.DISPLAY_GRID=26,Topics.DISPLAY_LIST=27,Topics.CLEAR_DATA=28,Topics.EDIT_IDENTITY=29,Topics.CREATE_SUB_FOLDER=30,Topics.DIALOG_OPEN=31,Topics.DIALOG_CLOSE=32,Topics.ESCAPE=33,Topics.IDENTITY_ADDED=34,Topics.PUSH_STATE=35,Topics.EDIT_SHARED_FOLDER=36,Topics.LEFT_ARROW=37,Topics.RIGHT_ARROW=38,Topics.PASSWORD_CHANGE=39,Topics.UP_ARROW=40,Topics.DOWN_ARROW=41,Topics.ENTER=42,Topics.EDIT_SHARED_FOLDER_ACCESS=43,Topics.REMOVED_SHARED_FOLDER_USER=44,Topics.LOGIN=45,Topics.REFRESH_DATA=46,Topics.ACCOUNT_LINKED=48,Topics.ACCOUNT_UNLINKED=49,Topics.CREATE_SHARED_FOLDER=50,Topics.DIALOG_LOADING=51,Topics.DIALOG_LOADED=52,Topics.REPROMPT=53,Topics.EDIT_APPLICATION=54,Topics.ATTACHMENT_REMOVED=55,Topics.CLEAR_STATE=56,Topics.SELECT_COUNT_CHANGE=57,Topics.REAPPLY_SEARCH=58,Topics.EMERGENCY_RECIPIENT_ADDED=59,Topics.EDIT_EMERGENCY_RECIPIENT=60,Topics.UPDATE_NOTIFICATION_COUNT=61,Topics.UPDATE_VAULT_STATE=62,Topics.ENROLLED_CREDIT_MONITORING=63,Topics.ITEM_SHARED=64,Topics.REFRESH_PREFERENCES=65,Topics.DISPLAY_COMPACT=66,Topics.DISPLAY_LARGE=67,Topics.ALL_COLLAPSED=68,Topics.ALL_EXPANDED=69,Topics.APPLICATION_ADDED=70,Topics.REQUEST_STATUS=71,Topics.DIALOG_RESIZE=72,Topics.SECURENOTE_TEMPLATE_ADDED=73,Topics.INITIALIZED=74,Topics.REQUEST_FRAMEWORK_INITIALIZED=75,Topics.SITE_NOTIFICATION_STATE=76,Topics.SITE_NOTIFICATION=77,Topics.DROPDOWN_SHOWN=78,Topics.DROPDOWN_HIDE=79,Topics.FILLED_GENERATED_PW=80,Topics.VAULT_LEFT_MENU_TOGGLE=81,Topics.EMPTY_VAULT_STATE_CHANGE=82,Topics.LOGIN_FINISHED=83,Topics.ACCTS_VERSION_UPDATED=84,Topics.ITEM_REMOVED=85,Topics.INFIELD_NOTIFICATION_OPENED=86,Topics.INFIELD_NOTIFICATION_CLOSED=87,Topics.INFIELD_NOTIFICATION_FILLED=88,Topics.INFIELD_FRAME_POSITION_CHANGED=89,Topics.MIGRATION_RUNNING=90,Topics.BLOB_UPDATED=91,Topics.CONVERT_FOLDER_TO_LEGACY=92,Topics.FORM_SUBMITTED=93,Topics.INTRO_TOURS_LOADED=94,Topics.PREFERENCES_READ=95,Topics.PREFERENCES_WRITE=96,Topics.MANUAL_LOGIN_FINISHED=97,Topics.PROCESSED_FORM_SUBMIT=98,Topics.BADGE_NOTIFICATION=99,Topics.BADGE_CLEAR=100,Topics.POPOVER_RESIZE=101,Topics.MATCHING_ITEMS_CHANGED=102,Topics.PASSWORD_FORM_SUBMITTED=103,Topics.REMOVED_SHARE=104,Topics.ACCOUNT_LINKED_NEEDS_VERIFICATION=105,Topics.CONTENT_SCRIPT_ADD_SITE_DIALOG_OPENED=106,Topics.PROMOTION_CLICKED=107,LPPlatform="undefined"==typeof LPPlatform?{}:LPPlatform,function(s){var i;s.requestFrameworkInitializer=(i=function(T,i){var E=T("",{name:"requestPort"});return E.onMessage.addListener(i),function(T){E.postMessage(T)}},function(T){return i(chrome.runtime&&chrome.runtime.connect||parent.chrome.runtime.connect,T)}),s.installBinary=function(i,E){var o=getBG();chrome.permissions.contains({permissions:["nativeMessaging"]},function(T){i||T?o.openURL(o.base_url+"installer/"):s.requestNativeMessaging(E)})},s.requestNativeMessaging=function(T){var i=getBG();i.Preferences.set("native_messaging_asked","1"),T?window.open("/native_messaging.html?hidenever=1"):void 0!==chrome.permissions&&chrome.permissions.request({permissions:["nativeMessaging","privacy"]},function(T){T&&alert(i.gs("Please restart your browser to finish enabling native messaging."))})}}(LPPlatform),addWebsiteAbilities("fedlogin"),function(){var o=null,T=function(T){T.fromExtension=!0,o&&o.target.postMessage(T,o.origin)},s=LPPlatform.requestFrameworkInitializer(T),i=function(T){var i=T.data,E=i&&i.data;i.type&&(null===o&&(T.origin===window.origin||"undefined"!=typeof bg&&bg.get("base_url")===T.origin+"/")&&(o={target:T.source,origin:T.origin}),o&&o.target===T.source&&o.origin===T.origin&&(i.fromExtension||E&&E.cmd&&"FederatedLogin"!==E.cmd[0]&&"getVersion"!==E.cmd||s(i)))};window.addEventListener("message",i,!0)}();}