/**
 * Copyright (c) Tiny Technologies, Inc. All rights reserved.
 * Licensed under the LGPL or a commercial license.
 * For LGPL see License.txt in the project root for license information.
 * For commercial licenses see https://www.tiny.cloud/
 *
 * Version: 5.2.1 (2020-03-25)
 */
!function(f){"use strict";var e=function(t){function n(){return r}var r=t;return{get:n,set:function(t){r=t},clone:function(){return e(n())}}},t=tinymce.util.Tools.resolve("tinymce.PluginManager"),u=function(){return(u=Object.assign||function(t){for(var n,r=1,e=arguments.length;r<e;r++)for(var o in n=arguments[r])Object.prototype.hasOwnProperty.call(n,o)&&(t[o]=n[o]);return t}).apply(this,arguments)};function n(){}function a(t){return function(){return t}}function o(t){return t}function r(){return l}var i,c=a(!1),s=a(!0),l=(i={fold:function(t,n){return t()},is:c,isSome:c,isNone:s,getOr:g,getOrThunk:m,getOrDie:function(t){throw new Error(t||"error: getOrDie called on none.")},getOrNull:a(null),getOrUndefined:a(undefined),or:g,orThunk:m,map:r,each:n,bind:r,exists:c,forall:s,filter:r,equals:d,equals_:d,toArray:function(){return[]},toString:a("none()")},Object.freeze&&Object.freeze(i),i);function d(t){return t.isNone()}function m(t){return t()}function g(t){return t}function p(n){return function(t){return function(t){if(null===t)return"null";var n=typeof t;return"object"==n&&(Array.prototype.isPrototypeOf(t)||t.constructor&&"Array"===t.constructor.name)?"array":"object"==n&&(String.prototype.isPrototypeOf(t)||t.constructor&&"String"===t.constructor.name)?"string":n}(t)===n}}function h(t,n){return-1<function(t,n){return lt.call(t,n)}(t,n)}function v(t,n){for(var r=t.length,e=new Array(r),o=0;o<r;o++){var a=t[o];e[o]=n(a,o)}return e}function y(t,n){for(var r=0,e=t.length;r<e;r++){n(t[r],r)}}function b(t,n){for(var r=[],e=0,o=t.length;e<o;e++){var a=t[e];n(a,e)&&r.push(a)}return r}function k(t,n,r){return function(t,n){for(var r=t.length-1;0<=r;r--){n(t[r],r)}}(t,function(t){r=n(r,t)}),r}function O(t,n){for(var r=0,e=t.length;r<e;++r){if(!0!==n(t[r],r))return!1}return!0}function w(t){var n=[],r=[];return y(t,function(t){t.fold(function(t){n.push(t)},function(t){r.push(t)})}),{errors:n,values:r}}function C(t){return"inline-command"===t.type||"inline-format"===t.type}function E(t){return"block-command"===t.type||"block-format"===t.type}function x(t){return function(t,n){var r=st.call(t,0);return r.sort(n),r}(t,function(t,n){return t.start.length===n.start.length?0:t.start.length>n.start.length?-1:1})}function R(o){function a(t){return vt.error({message:t,pattern:o})}function t(t,n,r){if(o.format===undefined)return o.cmd!==undefined?it(o.cmd)?vt.value(r(o.cmd,o.value)):a(t+" pattern has non-string `cmd` parameter"):a(t+" pattern is missing both `format` and `cmd` parameters");var e=void 0;if(ft(o.format)){if(!O(o.format,it))return a(t+" pattern has non-string items in the `format` array");e=o.format}else{if(!it(o.format))return a(t+" pattern has non-string `format` parameter");e=[o.format]}return vt.value(n(e))}if(!ut(o))return a("Raw pattern is not an object");if(!it(o.start))return a("Raw pattern is missing `start` parameter");if(o.end===undefined)return o.replacement!==undefined?it(o.replacement)?0===o.start.length?a("Replacement pattern has empty `start` parameter"):vt.value({type:"inline-command",start:"",end:o.start,cmd:"mceInsertContent",value:o.replacement}):a("Replacement pattern has non-string `replacement` parameter"):0===o.start.length?a("Block pattern has empty `start` parameter"):t("Block",function(t){return{type:"block-format",start:o.start,format:t[0]}},function(t,n){return{type:"block-command",start:o.start,cmd:t,value:n}});if(!it(o.end))return a("Inline pattern has non-string `end` parameter");if(0===o.start.length&&0===o.end.length)return a("Inline pattern has empty `start` and `end` parameters");var r=o.start,e=o.end;return 0===e.length&&(e=r,r=""),t("Inline",function(t){return{type:"inline-format",start:r,end:e,format:t}},function(t,n){return{type:"inline-command",start:r,end:e,cmd:t,value:n}})}function T(t){return"block-command"===t.type?{start:t.start,cmd:t.cmd,value:t.value}:"block-format"===t.type?{start:t.start,format:t.format}:"inline-command"===t.type?"mceInsertContent"===t.cmd&&""===t.start?{start:t.end,replacement:t.value}:{start:t.start,end:t.end,cmd:t.cmd,value:t.value}:"inline-format"===t.type?{start:t.start,end:t.end,format:1===t.format.length?t.format[0]:t.format}:void 0}function N(t){return{inlinePatterns:b(t,C),blockPatterns:x(b(t,E))}}function P(){for(var t=[],n=0;n<arguments.length;n++)t[n]=arguments[n];var r=bt.console;r&&(r.error?r.error.apply(r,t):r.log.apply(r,t))}function S(t){var n=function(t,n){return gt(t,n)?at.from(t[n]):at.none()}(t,"textpattern_patterns").getOr(kt);if(!ft(n))return P("The setting textpattern_patterns should be an array"),{inlinePatterns:[],blockPatterns:[]};var r=w(v(n,R));return y(r.errors,function(t){return P(t.message,t.pattern)}),N(r.values)}function M(t){var n=t.getParam("forced_root_block","p");return!1===n?"":!0===n?"p":n}function A(t,n){return{container:t,offset:n}}function j(t){return t.nodeType===f.Node.TEXT_NODE}function B(t,n,r,e){void 0===e&&(e=!0);var o=n.startContainer.parentNode,a=n.endContainer.parentNode;n.deleteContents(),e&&!r(n.startContainer)&&(j(n.startContainer)&&0===n.startContainer.data.length&&t.remove(n.startContainer),j(n.endContainer)&&0===n.endContainer.data.length&&t.remove(n.endContainer),Rt(t,o,r),o!==a&&Rt(t,a,r))}function D(t,n){var r=n.get(t);return ft(r)&&function(t){return 0===t.length?at.none():at.some(t[0])}(r).exists(function(t){return gt(t,"block")})}function I(t){return 0===t.start.length}function _(t,n){var r=at.from(t.dom.getParent(n.startContainer,t.dom.isBlock));return""===M(t)?r.orThunk(function(){return at.some(t.getBody())}):r}function U(n){return function(t){return n===t?-1:0}}function q(t,n,r){if(j(t)&&0<=n)return at.some(A(t,n));var e=xt(Tt);return at.from(e.backwards(t,n,U(t),r)).map(function(t){return A(t.container,t.container.data.length)})}function L(t,n,r,e,o){var a=xt(t,function(n){return function(t){return n.isBlock(t)||h(["BR","IMG","HR","INPUT"],t.nodeName)||"false"===n.getContentEditable(t)}}(t));return at.from(a.backwards(n,r,e,o))}function V(t,n,r){if(j(n)&&(r<0||r>n.data.length))return[];for(var e=[r],o=n;o!==t&&o.parentNode;){for(var a=o.parentNode,i=0;i<a.childNodes.length;i++)if(a.childNodes[i]===o){e.push(i);break}o=a}return o===t?e.reverse():[]}function W(t,n,r,e,o){return{start:V(t,n,r),end:V(t,e,o)}}function z(t,n){var r=n.slice(),e=r.pop();return function(t,n,r){return y(t,function(t){r=n(r,t)}),r}(r,function(t,n){return t.bind(function(t){return at.from(t.childNodes[n])})},at.some(t)).bind(function(t){return j(t)&&0<=e&&t.data.length,at.some({node:t,offset:e})})}function F(n,r){return z(n,r.start).bind(function(t){var o=t.node,a=t.offset;return z(n,r.end).map(function(t){var n=t.node,r=t.offset,e=f.document.createRange();return e.setStart(o,a),e.setEnd(n,r),e})})}function G(e,o,n){(function(t,n,r){if(j(t)&&n>=t.length)return at.some(A(t,n));var e=xt(Tt);return at.from(e.forwards(t,n,U(t),r)).map(function(t){return A(t.container,0)})})(o,0,o).each(function(t){var r=t.container;Pt(r,n.start.length,o).each(function(t){var n=e.createRng();n.setStart(r,0),n.setEnd(t.container,t.offset),B(e,n,function(t){return t===o})})})}function H(t,n){var r=n.replace("\xa0"," ");return function(t,n){for(var r=0,e=t.length;r<e;r++){var o=t[r];if(n(o,r))return at.some(o)}return at.none()}(t,function(t){return 0===n.indexOf(t.start)||0===r.indexOf(t.start)})}function J(n,t){if(0!==t.length){var r=n.selection.getBookmark();y(t,function(t){return function(n,t){var r=n.dom,e=t.pattern,o=F(r.getRoot(),t.range).getOrDie("Unable to resolve path range");return _(n,o).each(function(t){"block-format"===e.type?D(e.format,n.formatter)&&n.undoManager.transact(function(){G(n.dom,t,e),n.formatter.apply(e.format)}):"block-command"===e.type&&n.undoManager.transact(function(){G(n.dom,t,e),n.execCommand(e.cmd,!1,e.value)})}),!0}(n,t)}),n.selection.moveToBookmark(r)}}function K(t,n){return t.create("span",{"data-mce-type":"bookmark",id:n})}function X(t,n){var r=t.createRng();return r.setStartAfter(n.start),r.setEndBefore(n.end),r}function Q(t,n,r){var e=F(t.getRoot(),r).getOrDie("Unable to resolve path range"),o=e.startContainer,a=e.endContainer,i=0===e.endOffset?a:a.splitText(e.endOffset),u=0===e.startOffset?o:o.splitText(e.startOffset);return{prefix:n,end:i.parentNode.insertBefore(K(t,n+"-end"),i),start:u.parentNode.insertBefore(K(t,n+"-start"),u)}}function Y(t,n,r){Rt(t,t.get(n.prefix+"-end"),r),Rt(t,t.get(n.prefix+"-start"),r)}function Z(a,i,u){var f=a.dom,c=f.getRoot(),s=u.pattern,l=u.position.container,d=u.position.offset;return Nt(l,d-u.pattern.end.length,i).bind(function(t){var r=W(c,t.container,t.offset,l,d);if(I(s))return at.some({matches:[{pattern:s,startRng:r,endRng:r}],position:t});var n=At(a,u.remainingPatterns,t.container,t.offset,i),e=n.getOr({matches:[],position:t}),o=e.position;return function(t,r,n,e,o,a){if(void 0===a&&(a=!1),0!==r.start.length||a)return q(n,e,o).bind(function(n){return Mt(t,r,o,n).bind(function(t){if(a){if(t.endContainer===n.container&&t.endOffset===n.offset)return at.none();if(0===n.offset&&t.endContainer.textContent.length===t.endOffset)return at.none()}return at.some(t)})});var i=t.createRng();return i.setStart(n,e),i.setEnd(n,e),at.some(i)}(f,s,o.container,o.offset,i,n.isNone()).map(function(t){var n=function(t,n){return W(t,n.startContainer,n.startOffset,n.endContainer,n.endOffset)}(c,t);return{matches:e.matches.concat([{pattern:s,startRng:n,endRng:r}]),position:A(t.startContainer,t.startOffset)}})})}function $(n,t,r){n.selection.setRng(r),"inline-format"===t.type?y(t.format,function(t){n.formatter.apply(t)}):n.execCommand(t.cmd,!1,t.value)}function tt(o,t){var a=function(t){var n=(new Date).getTime();return t+"_"+Math.floor(1e9*Math.random())+ ++St+String(n)}("mce_textpattern"),i=k(t,function(t,n){var r=Q(o,a+"_end"+t.length,n.endRng);return t.concat([u(u({},n),{endMarker:r})])},[]);return k(i,function(t,n){var r=i.length-t.length-1,e=I(n.pattern)?n.endMarker:Q(o,a+"_start"+r,n.startRng);return t.concat([u(u({},n),{startMarker:e})])},[])}function nt(r,e,o){var a=r.selection.getRng();return!1===a.collapsed?[]:_(r,a).bind(function(t){var n=a.startOffset-(o?1:0);return At(r,e,a.startContainer,n,t)}).fold(function(){return[]},function(t){return t.matches})}function rt(e,t){if(0!==t.length){var o=e.dom,n=e.selection.getBookmark(),r=tt(o,t);y(r,function(t){function n(t){return t===r}var r=o.getParent(t.startMarker.start,o.isBlock);I(t.pattern)?function(t,n,r,e){var o=X(t.dom,r);B(t.dom,o,e),$(t,n,o)}(e,t.pattern,t.endMarker,n):function(t,n,r,e,o){var a=t.dom,i=X(a,e),u=X(a,r);B(a,u,o),B(a,i,o);var f={prefix:r.prefix,start:r.end,end:e.start},c=X(a,f);$(t,n,c)}(e,t.pattern,t.startMarker,t.endMarker,n),Y(o,t.endMarker,n),Y(o,t.startMarker,n)}),e.selection.moveToBookmark(n)}}function et(t,n,r){for(var e=0;e<t.length;e++)if(r(t[e],n))return!0}var ot=function(r){function t(){return o}function n(t){return t(r)}var e=a(r),o={fold:function(t,n){return n(r)},is:function(t){return r===t},isSome:s,isNone:c,getOr:e,getOrThunk:e,getOrDie:e,getOrNull:e,getOrUndefined:e,or:t,orThunk:t,map:function(t){return ot(t(r))},each:function(t){t(r)},bind:n,exists:n,forall:n,filter:function(t){return t(r)?o:l},toArray:function(){return[r]},toString:function(){return"some("+r+")"},equals:function(t){return t.is(r)},equals_:function(t,n){return t.fold(c,function(t){return n(r,t)})}};return o},at={some:ot,none:r,from:function(t){return null===t||t===undefined?l:ot(t)}},it=p("string"),ut=p("object"),ft=p("array"),ct=p("function"),st=Array.prototype.slice,lt=Array.prototype.indexOf,dt=(ct(Array.from)&&Array.from,Object.keys),mt=Object.hasOwnProperty,gt=function(t,n){return mt.call(t,n)},pt=(function(i){if(!ft(i))throw new Error("cases must be an array");if(0===i.length)throw new Error("there must be at least one case");var u=[],r={};y(i,function(t,e){var n=dt(t);if(1!==n.length)throw new Error("one and only one name per case");var o=n[0],a=t[o];if(r[o]!==undefined)throw new Error("duplicate key detected:"+o);if("cata"===o)throw new Error("cannot have a case named cata (sorry)");if(!ft(a))throw new Error("case arguments must be an array");u.push(o),r[o]=function(){var t=arguments.length;if(t!==a.length)throw new Error("Wrong number of arguments to case "+o+". Expected "+a.length+" ("+a+"), got "+t);for(var r=new Array(t),n=0;n<r.length;n++)r[n]=arguments[n];return{fold:function(){if(arguments.length!==i.length)throw new Error("Wrong number of arguments to fold. Expected "+i.length+", got "+arguments.length);return arguments[e].apply(null,r)},match:function(t){var n=dt(t);if(u.length!==n.length)throw new Error("Wrong number of arguments to match. Expected: "+u.join(",")+"\nActual: "+n.join(","));if(!O(u,function(t){return h(n,t)}))throw new Error("Not all branches were specified when using match. Specified: "+n.join(", ")+"\nRequired: "+u.join(", "));return t[o].apply(null,r)},log:function(t){f.console.log(t,{constructors:u,constructor:o,params:r})}}}})}([{bothErrors:["error1","error2"]},{firstError:["error1","value2"]},{secondError:["value1","error2"]},{bothValues:["value1","value2"]}]),function(r){return{is:function(t){return r===t},isValue:s,isError:c,getOr:a(r),getOrThunk:a(r),getOrDie:a(r),or:function(t){return pt(r)},orThunk:function(t){return pt(r)},fold:function(t,n){return n(r)},map:function(t){return pt(t(r))},mapError:function(t){return pt(r)},each:function(t){t(r)},bind:function(t){return t(r)},exists:function(t){return t(r)},forall:function(t){return t(r)},toOption:function(){return at.some(r)}}}),ht=function(r){return{is:c,isValue:c,isError:s,getOr:o,getOrThunk:function(t){return t()},getOrDie:function(){return function(t){return function(){throw new Error(t)}}(String(r))()},or:function(t){return t},orThunk:function(t){return t()},fold:function(t,n){return t(r)},map:function(t){return ht(r)},mapError:function(t){return ht(t(r))},each:n,bind:function(t){return ht(r)},exists:c,forall:s,toOption:at.none}},vt={value:pt,error:ht,fromOption:function(t,n){return t.fold(function(){return ht(n)},pt)}},yt=function(e){return{setPatterns:function(t){var n=w(v(t,R));if(0<n.errors.length){var r=n.errors[0];throw new Error(r.message+":\n"+JSON.stringify(r.pattern,null,2))}e.set(N(n.values))},getPatterns:function(){return function f(){for(var t=0,n=0,r=arguments.length;n<r;n++)t+=arguments[n].length;var e=Array(t),o=0;for(n=0;n<r;n++)for(var a=arguments[n],i=0,u=a.length;i<u;i++,o++)e[o]=a[i];return e}(v(e.get().inlinePatterns,T),v(e.get().blockPatterns,T))}}},bt="undefined"!=typeof f.window?f.window:Function("return this;")(),kt=[{start:"*",end:"*",format:"italic"},{start:"**",end:"**",format:"bold"},{start:"#",format:"h1"},{start:"##",format:"h2"},{start:"###",format:"h3"},{start:"####",format:"h4"},{start:"#####",format:"h5"},{start:"######",format:"h6"},{start:"1. ",cmd:"InsertOrderedList"},{start:"* ",cmd:"InsertUnorderedList"},{start:"- ",cmd:"InsertUnorderedList"}],Ot=tinymce.util.Tools.resolve("tinymce.util.Delay"),wt=tinymce.util.Tools.resolve("tinymce.util.VK"),Ct=tinymce.util.Tools.resolve("tinymce.util.Tools"),Et=tinymce.util.Tools.resolve("tinymce.dom.DOMUtils"),xt=tinymce.util.Tools.resolve("tinymce.dom.TextSeeker"),Rt=function(t,n,r){if(n&&t.isEmpty(n)&&!r(n)){var e=n.parentNode;t.remove(n),Rt(t,e,r)}},Tt=Et.DOM,Nt=function(t,r,e){if(!j(t))return at.none();var n=t.textContent;if(0<=r&&r<=n.length)return at.some(A(t,r));var o=xt(Tt);return at.from(o.backwards(t,r,U(t),e)).bind(function(t){var n=t.container.data;return Nt(t.container,r+n.length,e)})},Pt=function(t,n,r){if(!j(t))return at.none();var e=t.textContent;if(n<=e.length)return at.some(A(t,n));var o=xt(Tt);return at.from(o.forwards(t,n,U(t),r)).bind(function(t){return Pt(t.container,n-e.length,r)})},St=0,Mt=function(e,o,a,t){var i=o.start;return L(e,t.container,t.offset,function(t,n,a){return function(t,n){var r=t.data.substring(0,n),e=r.lastIndexOf(a.charAt(a.length-1)),o=r.lastIndexOf(a);return-1!==o?o+a.length:-1!==e?e+1:-1}}(0,0,i),a).bind(function(r){if(r.offset>=i.length){var t=e.createRng();return t.setStart(r.container,r.offset-i.length),t.setEnd(r.container,r.offset),at.some(t)}var n=r.offset-i.length;return Nt(r.container,n,a).map(function(t){var n=e.createRng();return n.setStart(t.container,t.offset),n.setEnd(r.container,r.offset),n}).filter(function(t){return t.toString()===i}).orThunk(function(){return Mt(e,o,a,A(r.container,0))})})},At=function(c,s,l,d,m){var g=c.dom;return q(l,d,g.getRoot()).bind(function(t){var n=g.createRng();n.setStart(m,0),n.setEnd(l,d);for(var r,e,o=n.toString(),a=0;a<s.length;a++){var i=s[a];if(r=o,e=i.end,function(t,n,r){return""===n||!(t.length<n.length)&&t.substr(r,r+n.length)===n}(r,e,r.length-e.length)){var u=s.slice();u.splice(a,1);var f=Z(c,m,{pattern:i,remainingPatterns:u,position:t});if(f.isSome())return f}}return at.none()})},jt=function(r,t){if(!r.selection.isCollapsed())return!1;var e=nt(r,t.inlinePatterns,!1),o=function(e,t){var o=e.dom,n=e.selection.getRng();return _(e,n).filter(function(t){var n=M(e),r=""===n&&o.is(t,"body")||o.is(t,n);return null!==t&&r}).bind(function(n){var r=n.textContent;return H(t,r).map(function(t){return Ct.trim(r).length===t.start.length?[]:[{pattern:t,range:W(o.getRoot(),n,0,n,0)}]})}).getOr([])}(r,t.blockPatterns);return(0<o.length||0<e.length)&&(r.undoManager.add(),r.undoManager.extra(function(){r.execCommand("mceInsertNewLine")},function(){r.insertContent("\ufeff"),rt(r,e),J(r,o);var t=r.selection.getRng(),n=q(t.startContainer,t.startOffset,r.dom.getRoot());r.execCommand("mceInsertNewLine"),n.each(function(t){var n=t.container;"\ufeff"===n.data.charAt(t.offset-1)&&(n.deleteData(t.offset-1,1),Rt(r.dom,n.parentNode,function(t){return t===r.dom.getRoot()}))})}),!0)},Bt=function(t,n){var r=nt(t,n.inlinePatterns,!0);0<r.length&&t.undoManager.transact(function(){rt(t,r)})},Dt=function(t,n){return et(t,n,function(t,n){return t.charCodeAt(0)===n.charCode})},It=function(t,n){return et(t,n,function(t,n){return t===n.keyCode&&!1===wt.modifierPressed(n)})},_t=function(n,r){var e=[",",".",";",":","!","?"],o=[32];n.on("keydown",function(t){13!==t.keyCode||wt.modifierPressed(t)||jt(n,r.get())&&t.preventDefault()},!0),n.on("keyup",function(t){It(o,t)&&Bt(n,r.get())}),n.on("keypress",function(t){Dt(e,t)&&Ot.setEditorTimeout(n,function(){Bt(n,r.get())})})};!function Ut(){t.add("textpattern",function(t){var n=e(S(t.settings));return _t(t,n),yt(n)})}()}(window);