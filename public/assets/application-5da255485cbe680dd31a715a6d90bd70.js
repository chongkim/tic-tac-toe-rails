!function(){}.call(this),function($){for(var supportedCSS,styles=document.getElementsByTagName("head")[0].style,toCheck="transformProperty WebkitTransform OTransform msTransform MozTransform".split(" "),a=0;a<toCheck.length;a++)void 0!==styles[toCheck[a]]&&(supportedCSS=toCheck[a]);var IE=eval('"v"==""');jQuery.fn.extend({rotate:function(t){if(0!==this.length&&"undefined"!=typeof t){"number"==typeof t&&(t={angle:t});for(var e=[],i=0,a=this.length;a>i;i++){var n=this.get(i);if(n.Wilq32&&n.Wilq32.PhotoEffect)n.Wilq32.PhotoEffect._handleRotation(t);else{var r=$.extend(!0,{},t),o=new Wilq32.PhotoEffect(n,r)._rootObj;e.push($(o))}}return e}},getRotateAngle:function(){for(var t=[],e=0,i=this.length;i>e;e++){var a=this.get(e);a.Wilq32&&a.Wilq32.PhotoEffect&&(t[e]=a.Wilq32.PhotoEffect._angle)}return t},stopRotate:function(){for(var t=0,e=this.length;e>t;t++){var i=this.get(t);i.Wilq32&&i.Wilq32.PhotoEffect&&clearTimeout(i.Wilq32.PhotoEffect._timer)}}}),Wilq32=window.Wilq32||{},Wilq32.PhotoEffect=function(){return supportedCSS?function(t,e){t.Wilq32={PhotoEffect:this},this._img=this._rootObj=this._eventObj=t,this._handleRotation(e)}:function(t,e){if(this._img=t,this._rootObj=document.createElement("span"),this._rootObj.style.display="inline-block",this._rootObj.Wilq32={PhotoEffect:this},t.parentNode.insertBefore(this._rootObj,t),t.complete)this._Loader(e);else{var i=this;jQuery(this._img).bind("load",function(){i._Loader(e)})}}}(),Wilq32.PhotoEffect.prototype={_setupParameters:function(t){this._parameters=this._parameters||{},"number"!=typeof this._angle&&(this._angle=0),"number"==typeof t.angle&&(this._angle=t.angle),this._parameters.animateTo="number"==typeof t.animateTo?t.animateTo:this._angle,this._parameters.step=t.step||this._parameters.step||null,this._parameters.easing=t.easing||this._parameters.easing||function(t,e,i,a,n){return-a*((e=e/n-1)*e*e*e-1)+i},this._parameters.duration=t.duration||this._parameters.duration||1e3,this._parameters.callback=t.callback||this._parameters.callback||function(){},t.bind&&t.bind!=this._parameters.bind&&this._BindEvents(t.bind)},_handleRotation:function(t){this._setupParameters(t),this._angle==this._parameters.animateTo?this._rotate(this._angle):this._animateStart()},_BindEvents:function(t){if(t&&this._eventObj){if(this._parameters.bind){var e=this._parameters.bind;for(var i in e)e.hasOwnProperty(i)&&jQuery(this._eventObj).unbind(i,e[i])}this._parameters.bind=t;for(var i in t)t.hasOwnProperty(i)&&jQuery(this._eventObj).bind(i,t[i])}},_Loader:function(){return IE?function(t){var e=this._img.width,i=this._img.height;this._img.parentNode.removeChild(this._img),this._vimage=this.createVMLNode("image"),this._vimage.src=this._img.src,this._vimage.style.height=i+"px",this._vimage.style.width=e+"px",this._vimage.style.position="absolute",this._vimage.style.top="0px",this._vimage.style.left="0px",this._container=this.createVMLNode("group"),this._container.style.width=e,this._container.style.height=i,this._container.style.position="absolute",this._container.setAttribute("coordsize",e-1+","+(i-1)),this._container.appendChild(this._vimage),this._rootObj.appendChild(this._container),this._rootObj.style.position="relative",this._rootObj.style.width=e+"px",this._rootObj.style.height=i+"px",this._rootObj.setAttribute("id",this._img.getAttribute("id")),this._rootObj.className=this._img.className,this._eventObj=this._rootObj,this._handleRotation(t)}:function(t){this._rootObj.setAttribute("id",this._img.getAttribute("id")),this._rootObj.className=this._img.className,this._width=this._img.width,this._height=this._img.height,this._widthHalf=this._width/2,this._heightHalf=this._height/2;var e=Math.sqrt(this._height*this._height+this._width*this._width);this._widthAdd=e-this._width,this._heightAdd=e-this._height,this._widthAddHalf=this._widthAdd/2,this._heightAddHalf=this._heightAdd/2,this._img.parentNode.removeChild(this._img),this._aspectW=(parseInt(this._img.style.width,10)||this._width)/this._img.width,this._aspectH=(parseInt(this._img.style.height,10)||this._height)/this._img.height,this._canvas=document.createElement("canvas"),this._canvas.setAttribute("width",this._width),this._canvas.style.position="relative",this._canvas.style.left=-this._widthAddHalf+"px",this._canvas.style.top=-this._heightAddHalf+"px",this._canvas.Wilq32=this._rootObj.Wilq32,this._rootObj.appendChild(this._canvas),this._rootObj.style.width=this._width+"px",this._rootObj.style.height=this._height+"px",this._eventObj=this._canvas,this._cnv=this._canvas.getContext("2d"),this._handleRotation(t)}}(),_animateStart:function(){this._timer&&clearTimeout(this._timer),this._animateStartTime=+new Date,this._animateStartAngle=this._angle,this._animate()},_animate:function(){var t=+new Date,e=t-this._animateStartTime>this._parameters.duration;if(e&&!this._parameters.animatedGif)clearTimeout(this._timer);else{if(this._canvas||this._vimage||this._img){var i=this._parameters.easing(0,t-this._animateStartTime,this._animateStartAngle,this._parameters.animateTo-this._animateStartAngle,this._parameters.duration);this._rotate(~~(10*i)/10)}this._parameters.step&&this._parameters.step(this._angle);var a=this;this._timer=setTimeout(function(){a._animate.call(a)},10)}this._parameters.callback&&e&&(this._angle=this._parameters.animateTo,this._rotate(this._angle),this._parameters.callback.call(this._rootObj))},_rotate:function(){var t=Math.PI/180;return IE?function(t){this._angle=t,this._container.style.rotation=t%360+"deg"}:supportedCSS?function(t){this._angle=t,this._img.style[supportedCSS]="rotate("+t%360+"deg)"}:function(e){this._angle=e,e=e%360*t,this._canvas.width=this._width+this._widthAdd,this._canvas.height=this._height+this._heightAdd,this._cnv.translate(this._widthAddHalf,this._heightAddHalf),this._cnv.translate(this._widthHalf,this._heightHalf),this._cnv.rotate(e),this._cnv.translate(-this._widthHalf,-this._heightHalf),this._cnv.scale(this._aspectW,this._aspectH),this._cnv.drawImage(this._img,0,0)}}()},IE&&(Wilq32.PhotoEffect.prototype.createVMLNode=function(){document.createStyleSheet().addRule(".rvml","behavior:url(#default#VML)");try{return!document.namespaces.rvml&&document.namespaces.add("rvml","urn:schemas-microsoft-com:vml"),function(t){return document.createElement("<rvml:"+t+' class="rvml">')}}catch(t){return function(t){return document.createElement("<"+t+' xmlns="urn:schemas-microsoft.com:vml" class="rvml">')}}}())}(jQuery),function(){var t,e,i,a,n,r,o,s,l,h,u,c,m,d,_=[].indexOf||function(t){for(var e=0,i=this.length;i>e;e++)if(e in this&&this[e]===t)return e;return-1};o=4e4,s=3e3,c=!1,t=!1,n=function(){return $("#boat").attr("src","/assets/boat-flip.png"),$("#boat").animate({left:"100%"},o,a)},a=function(){return $("#boat").attr("src","/assets/boat.png"),$("#boat").animate({left:"-300px"},o,n)},e=function(){return $("#boat").rotate({animateTo:10,duration:s,callback:i})},i=function(){return $("#boat").rotate({animateTo:-10,duration:s,callback:e})},r=function(){return $("#loading img").rotate({angle:0,animateTo:360,duration:4e3,easing:function(t,e,i,a,n){return i+e/n*a},callback:function(){return r}})},$(function(){return $("#ttt").html($("#set_first_player").html()),t&&(a(),e()),$.ajaxSetup({beforeSend:function(){return c=!0,setTimeout(function(){return c?($("#loading").show(),r()):void 0},500)},complete:function(){return c=!1,$("#loading").hide()}}),$("#options").buttonset()}),m="undefined"!=typeof exports&&null!==exports?exports:this,u=null,d=null,h=3,m.game_end=!1,m.current_player_symbol=null,m.init_position=function(t,e){var i,a;return null==t&&(t="- - -- - -- - -"),null==e&&(e="x"),i={board:function(){var e,i,n;for(n=[],e=0,i=t.length;i>e;e++)a=t[e],_.call("xo-",a)>=0&&n.push(a);return n}(),turn:e}},m.position=init_position(),m.win_lines=function(){var t,e,i,a,n,r,o;for(t=function(){o=[];for(var t=0,e=h*h-1;e>=0?e>=t:t>=e;e>=0?t++:t--)o.push(t);return o}.apply(this),a=[],i=n=0;2>=n;i=++n)a.push(function(){var a,n,r;for(r=[],a=0,n=t.length;n>a;a++)e=t[a],Math.floor(e/h)===i&&r.push(e);return r}());for(i=r=0;2>=r;i=++r)a.push(function(){var a,n,r;for(r=[],a=0,n=t.length;n>a;a++)e=t[a],e%h===i&&r.push(e);return r}());return a.push(function(){var t,e,a,n;for(n=[],i=t=0,e=h*h-1,a=h+1;a>0?e>=t:t>=e;i=t+=a)n.push(i);return n}()),a.push(function(){var t,e,a,n,r;for(r=[],i=t=e=h-1,a=h*h-h,n=h-1;n>0?a>=t:t>=a;i=t+=n)r.push(i);return r}()),a},m.is_win=function(t){var e,i,a,n;for(n=win_lines(),i=0,a=n.length;a>i;i++)if(e=n[i],is_win_line(e,t))return!0;return!1},m.is_win_line=function(t,e){var i,a,n;for(a=0,n=t.length;n>a;a++)if(i=t[a],m.position.board[i]!==e)return!1;return!0},m.count_blanks=function(){var t,e,i,a,n;for(e=0,n=m.position.board,i=0,a=n.length;a>i;i++)t=n[i],"-"===t&&(e+=1);return e},m.clear_board=function(){var t,e,i,a;for(a=[],t=e=0,i=h*h-1;i>=0?i>=e:e>=i;t=i>=0?++e:--e)a.push($("#t-"+t).html(""));return a},m.play_again=function(){return m.position=init_position(),clear_board(),$("#ttt").html($("#set_first_player").html()),m.game_end=!1},m.ask_play_again=function(t){return playing_computer()?$("#play_again_dialog").dialog({autoOpen:!0,resizable:!1,modal:!0,buttons:{Yes:function(){return play_again(),$(this).dialog("close")},No:function(){return $("#message").html($("#message").html()+"<button onclick='javascript:play_again()'>Play again</button>"),$(this).dialog("close")}}}):$("#play_again_dialog").dialog({autoOpen:!0,resizable:!1,title:t,modal:!0,buttons:{Ok:function(){return $(this).dialog("close")}}})},m.end_game=function(){return m.game_end=!0,setTimeout(ask_play_again,500)},m.playing_computer=function(){return"Computer"===u||"Computer"===d},m.set_winner=function(t){var e;return t?($("#message").html(""+t+" Wins"),e=""+t+" Wins.",playing_computer()&&(e+="Do you want to play again?"),$("#play_again_dialog").html(e)):($("#message").html("Game is a draw"),e="Draw.",playing_computer()&&(e+="Do you want to play again?"),$("#play_again_dialog").html(e))},m.check_for_win=function(){return is_win("x")?(set_winner(u),end_game()):is_win("o")?(set_winner(d),end_game()):0===count_blanks()?(set_winner(null),end_game()):void 0},m.set_players=function(t,e,i){return u=t,d=e,$("#ttt").html($("#board_display").html()),$("#message").html("Welcome to Tic Tac Toe"),m.current_player_symbol=i,"Computer"===u&&computer_move(),$("#first_player").addClass("turn"),"x"!==m.current_player_symbol?check_for_move():void 0},m.make_mark=function(t){return"-"===t?"":'<img src="/assets/'+("x"===t?"oars":"lifepreserver")+'.png">'},m.put_mark=function(t,e){var i;return i=$("#t-"+t).html(),i!==make_mark(e)?$("#t-"+t).html(make_mark(e)):void 0},m.get_mark=function(t){return $("#t-"+t).html()},l=function(){return $("#message").html("")},m.other_turn=function(t){return"x"===t?"o":"x"},m.put_turn=function(){return"x"===position.turn?($("#first_player").addClass("turn"),$("#second_player").removeClass("turn")):($("#first_player").removeClass("turn"),$("#second_player").addClass("turn"))},m.make_move=function(t,e){return m.game_end?!1:e!==m.position.turn?!1:(l(),"-"===m.position.board[t]?(put_mark(t,m.position.turn),m.position.board[t]=m.position.turn,m.position.turn=other_turn(m.position.turn),put_turn(),!0):($("#message").html("Please click on an empty square"),!1))},m.computer_move=function(){return m.game_end?void 0:(m.position.speed=$('input[name="speed"]:checked').attr("id"),$.get("/ttt/move",m.position,function(t){return make_move(t,other_turn(current_player_symbol))}))},m.opponent_move=function(){return m.game_end?void 0:$.get("/games/"+m.game_id+"/opponent_move",m.position,check_for_move)},m.set_position=function(t){var e,i;if(null!==t){for(m.position=t,e=i=0;8>=i;e=++i)put_mark(e,m.position.board[e]);return put_turn(),check_for_win()}},m.get_position=function(){return $.get("/games/"+m.game_id+"/get_position",set_position)},m.check_for_move=function(){return m.game_end?void 0:(get_position(),position.turn!==current_player_symbol?setTimeout(check_for_move,3e3):void 0)},m.send_move=function(t,e){return m.game_end?void 0:make_move(t,e)?("Computer"===d?computer_move():opponent_move(),check_for_win()):void 0}}.call(this),function(){}.call(this),function(t,e){t.rails!==e&&t.error("jquery-ujs has already been loaded!");var i;t.rails=i={linkClickSelector:"a[data-confirm], a[data-method], a[data-remote], a[data-disable-with]",buttonClickSelector:"button[data-remote]",inputChangeSelector:"select[data-remote], input[data-remote], textarea[data-remote]",formSubmitSelector:"form",formInputClickSelector:"form input[type=submit], form input[type=image], form button[type=submit], form button:not([type])",disableSelector:"input[data-disable-with], button[data-disable-with], textarea[data-disable-with]",enableSelector:"input[data-disable-with]:disabled, button[data-disable-with]:disabled, textarea[data-disable-with]:disabled",requiredInputSelector:"input[name][required]:not([disabled]),textarea[name][required]:not([disabled])",fileInputSelector:"input[type=file]",linkDisableSelector:"a[data-disable-with]",CSRFProtection:function(e){var i=t('meta[name="csrf-token"]').attr("content");i&&e.setRequestHeader("X-CSRF-Token",i)},fire:function(e,i,a){var n=t.Event(i);return e.trigger(n,a),n.result!==!1},confirm:function(t){return confirm(t)},ajax:function(e){return t.ajax(e)},href:function(t){return t.attr("href")},handleRemote:function(a){var n,r,o,s,l,h,u,c;if(i.fire(a,"ajax:before")){if(s=a.data("cross-domain"),l=s===e?null:s,h=a.data("with-credentials")||null,u=a.data("type")||t.ajaxSettings&&t.ajaxSettings.dataType,a.is("form")){n=a.attr("method"),r=a.attr("action"),o=a.serializeArray();var m=a.data("ujs:submit-button");m&&(o.push(m),a.data("ujs:submit-button",null))}else a.is(i.inputChangeSelector)?(n=a.data("method"),r=a.data("url"),o=a.serialize(),a.data("params")&&(o=o+"&"+a.data("params"))):a.is(i.buttonClickSelector)?(n=a.data("method")||"get",r=a.data("url"),o=a.serialize(),a.data("params")&&(o=o+"&"+a.data("params"))):(n=a.data("method"),r=i.href(a),o=a.data("params")||null);c={type:n||"GET",data:o,dataType:u,beforeSend:function(t,n){return n.dataType===e&&t.setRequestHeader("accept","*/*;q=0.5, "+n.accepts.script),i.fire(a,"ajax:beforeSend",[t,n])},success:function(t,e,i){a.trigger("ajax:success",[t,e,i])},complete:function(t,e){a.trigger("ajax:complete",[t,e])},error:function(t,e,i){a.trigger("ajax:error",[t,e,i])},crossDomain:l},h&&(c.xhrFields={withCredentials:h}),r&&(c.url=r);var d=i.ajax(c);return a.trigger("ajax:send",d),d}return!1},handleMethod:function(a){var n=i.href(a),r=a.data("method"),o=a.attr("target"),s=t("meta[name=csrf-token]").attr("content"),l=t("meta[name=csrf-param]").attr("content"),h=t('<form method="post" action="'+n+'"></form>'),u='<input name="_method" value="'+r+'" type="hidden" />';l!==e&&s!==e&&(u+='<input name="'+l+'" value="'+s+'" type="hidden" />'),o&&h.attr("target",o),h.hide().append(u).appendTo("body"),h.submit()},disableFormElements:function(e){e.find(i.disableSelector).each(function(){var e=t(this),i=e.is("button")?"html":"val";e.data("ujs:enable-with",e[i]()),e[i](e.data("disable-with")),e.prop("disabled",!0)})},enableFormElements:function(e){e.find(i.enableSelector).each(function(){var e=t(this),i=e.is("button")?"html":"val";e.data("ujs:enable-with")&&e[i](e.data("ujs:enable-with")),e.prop("disabled",!1)})},allowAction:function(t){var e,a=t.data("confirm"),n=!1;return a?(i.fire(t,"confirm")&&(n=i.confirm(a),e=i.fire(t,"confirm:complete",[n])),n&&e):!0},blankInputs:function(e,i,a){var n,r,o=t(),s=i||"input,textarea",l=e.find(s);return l.each(function(){if(n=t(this),r=n.is("input[type=checkbox],input[type=radio]")?n.is(":checked"):n.val(),!r==!a){if(n.is("input[type=radio]")&&l.filter('input[type=radio]:checked[name="'+n.attr("name")+'"]').length)return!0;o=o.add(n)}}),o.length?o:!1},nonBlankInputs:function(t,e){return i.blankInputs(t,e,!0)},stopEverything:function(e){return t(e.target).trigger("ujs:everythingStopped"),e.stopImmediatePropagation(),!1},disableElement:function(t){t.data("ujs:enable-with",t.html()),t.html(t.data("disable-with")),t.bind("click.railsDisable",function(t){return i.stopEverything(t)})},enableElement:function(t){t.data("ujs:enable-with")!==e&&(t.html(t.data("ujs:enable-with")),t.removeData("ujs:enable-with")),t.unbind("click.railsDisable")}},i.fire(t(document),"rails:attachBindings")&&(t.ajaxPrefilter(function(t,e,a){t.crossDomain||i.CSRFProtection(a)}),t(document).delegate(i.linkDisableSelector,"ajax:complete",function(){i.enableElement(t(this))}),t(document).delegate(i.linkClickSelector,"click.rails",function(a){var n=t(this),r=n.data("method"),o=n.data("params");if(!i.allowAction(n))return i.stopEverything(a);if(n.is(i.linkDisableSelector)&&i.disableElement(n),n.data("remote")!==e){if(!(!a.metaKey&&!a.ctrlKey||r&&"GET"!==r||o))return!0;var s=i.handleRemote(n);return s===!1?i.enableElement(n):s.error(function(){i.enableElement(n)}),!1}return n.data("method")?(i.handleMethod(n),!1):void 0}),t(document).delegate(i.buttonClickSelector,"click.rails",function(e){var a=t(this);return i.allowAction(a)?(i.handleRemote(a),!1):i.stopEverything(e)}),t(document).delegate(i.inputChangeSelector,"change.rails",function(e){var a=t(this);return i.allowAction(a)?(i.handleRemote(a),!1):i.stopEverything(e)}),t(document).delegate(i.formSubmitSelector,"submit.rails",function(a){var n=t(this),r=n.data("remote")!==e,o=i.blankInputs(n,i.requiredInputSelector),s=i.nonBlankInputs(n,i.fileInputSelector);if(!i.allowAction(n))return i.stopEverything(a);if(o&&n.attr("novalidate")==e&&i.fire(n,"ajax:aborted:required",[o]))return i.stopEverything(a);if(r){if(s){setTimeout(function(){i.disableFormElements(n)},13);var l=i.fire(n,"ajax:aborted:file",[s]);return l||setTimeout(function(){i.enableFormElements(n)},13),l}return i.handleRemote(n),!1}setTimeout(function(){i.disableFormElements(n)},13)}),t(document).delegate(i.formInputClickSelector,"click.rails",function(e){var a=t(this);if(!i.allowAction(a))return i.stopEverything(e);var n=a.attr("name"),r=n?{name:n,value:a.val()}:null;a.closest("form").data("ujs:submit-button",r)}),t(document).delegate(i.formSubmitSelector,"ajax:beforeSend.rails",function(e){this==e.target&&i.disableFormElements(t(this))}),t(document).delegate(i.formSubmitSelector,"ajax:complete.rails",function(e){this==e.target&&i.enableFormElements(t(this))}),t(function(){var e=t("meta[name=csrf-token]").attr("content"),i=t("meta[name=csrf-param]").attr("content");t('form input[name="'+i+'"]').val(e)}))}(jQuery);