<!--- 
    Uğur Hamurpet: 17:08:2021
    Chatflow
--->

<cfif isDefined("attributes.data") and len(attributes.data) and IsDefined("attributes.enc_key") and len(attributes.enc_key)>

    <cfparam name="attributes.userkey" default="">
    <cfparam name="attributes.usertype" default="">
    <cfparam name="attributes.userid" default="">
    <cfparam name="attributes.name" default="">
    <cfparam name="attributes.surname" default="">
    <cfparam name="attributes.email" default="">

    <cfset user_domain = (( cgi.server_port eq 443 ) ? 'https://' : 'http://') & cgi.server_name >
    <cfset dateformat_style = 'dd/mm/yyyy' />
    <cfset validate_style = ( dateformat_style eq 'dd/mm/yyyy' ) ? 'eurodate' : 'date' />
    <cfset timeformat_style = 'HH:MM' />
    <cfset wssecure = cgi.https neq "on" ? "false" : "true" />
    <cfset data = deserializeJson(createObject("component", "WMO.functions").contentEncryptingandDecodingAES(isEncode:0,content:attributes.data,accountKey:'wrk'))>
    <cfset option = data.option />
    <cfset receiver_type = 0><!--- Alıcı her zaman çalışan olur --->

    <cfif attributes.usertype eq 'e'>
        <cfset sender_type = 0>
    <cfelseif attributes.usertype eq 'p'>
        <cfset sender_type = 1>
    <cfelseif attributes.usertype eq 'w'>
        <cfset sender_type = 2>
    <cfelseif attributes.usertype eq 'q'><!--- Oturum açmamış kullanıcı --->
        <cfset sender_type = 3>
    </cfif>

    <html xmlns="http://www.w3.org/1999/xhtml" lang="tr">
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
            <meta name="content-language" content="tr" />
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
            <meta name="mobile-web-app-capable" content="yes">

            <script type="text/javascript" src="/JS/assets/lib/jquery/jquery-min.js"></script>
            <script  type="text/javascript" src="/JS/AjaxControl/dist/build.js"></script><!--- AjaxControl --->
            <script type="text/javascript" src="/WEX/chatflow/view/asset/chatflow.js"></script>

            <script>
                function AjaxControlPostDataJson( url, data, calback ){
                    new AjaxControl.AjaxRequest().postDataJson(url + "&isAjax=1", data, calback) 
                }
            </script>

            <link rel="stylesheet" href="/css/assets/template/catalyst/catalyst.css" type="text/css">
            <link rel="stylesheet" href="/css/assets/template/message.css" type="text/css">
            <link rel="stylesheet" href="/css/assets/icons/simple-line/simple-line-icons.css" type="text/css">
            <link rel="stylesheet" href="/css/assets/icons/icon-Set/icon-Set.css" type="text/css">
            <link rel="stylesheet" href="/css/assets/icons/fontello/fontello.css" type="text/css">
            <link rel="stylesheet" href="/css/assets/template/svg/svg.css" type="text/css">

            <style>#messages-body{padding-top:0px!important;}</style>

        </head>
        <body>

            <cfif isDefined("attributes.chat") and attributes.chat eq 1>

                <cfset messages = createObject("component","WEX.chatflow.component.messages") />
                <cfset get_visitor = messages.get_visitor( enc_key: attributes.enc_key ) /><!--- Önceden yapılan mesajlaşma varsa getirir --->
                <cfset get_agent_user = messages.get_agent_user( employee_id: get_visitor.recordcount ? get_visitor.EMPLOYEE_ID : "", department_id: option.x_agent_list ) />

                <cfif get_agent_user.recordcount><!--- department_id değerlerine göre çevrimiçi kullanıcı var mı? --->

                    <cfif get_visitor.recordcount><!--- Visitor kaydı yoksa yeni oluşturur --->
                        <cfset attributes.userkey = get_visitor.VISITOR_KEY />
                        <cfset attributes.usertype = get_visitor.VISITOR_TYPE />
                        <cfset attributes.userid = get_visitor.VISITOR_ID />
                        <cfset attributes.name = get_visitor.VISITOR_NAME />
                        <cfset attributes.surname = get_visitor.VISITOR_SURNAME />
                        <cfset attributes.email = get_visitor.VISITOR_EMAIL />
                        <cfset sender_type = receiver_type = get_visitor.VISITOR_TYPE />
                    <cfelse>
                        <cfset messages.set_visitor(
                            employee_id: get_agent_user.EMPLOYEE_ID,
                            visitor_id: attributes.userid,
                            visitor_type: sender_type,
                            visitor_key: attributes.userkey,
                            visitor_name: attributes.name,
                            visitor_surname: attributes.surname,
                            visitor_email: attributes.email,
                            enc_key: attributes.enc_key
                        ) />
                    </cfif>

                    <cfset get_wrk_messages = messages.get_wrk_messages(enc_key : attributes.enc_key)>

                    <div class="col col-12 col-sm-12 col-xs-12 message-body" id="messages-body" style="height: calc(100% - (61px));">
                        <div id="user_info" class="col col-12">
                            <div class="col col-12 col-md-12 col-sm-12 col-xs-12 userrightinfo">
                                <div class="profileusersListLeft">
                                    <cfif len(get_agent_user.PHOTO) and DirectoryExists("<cfoutput>#upload_folder#hr/#get_agent_user.PHOTO#</cfoutput>")>
                                        <img src="<cfoutput>#upload_folder#hr/#get_agent_user.PHOTO#</cfoutput>" width="30" height="30" class="img-circle">
                                    <cfelse>
                                        <span style="width:30px;height:30px" class="avatextCt color-<cfoutput>#Left(get_agent_user.EMPLOYEE_NAME, 1)#</cfoutput>">
                                            <small style="top:-4px;width:30px;" class="avatext"><cfoutput>#Left(get_agent_user.EMPLOYEE_NAME, 1)##Left(get_agent_user.EMPLOYEE_SURNAME, 1)#</cfoutput></small>
                                        </span>
                                    </cfif>
                                </div>
                                <div class="profileusersListRight">
                                    <a href="javascript://"><span><cfoutput>#get_agent_user.EMPLOYEE_NAME# #get_agent_user.EMPLOYEE_SURNAME#</cfoutput></span></a>
                                </div>
                            </div>
                        </div>
                        <div id="all_messages" class="scrollbar scrltp all_messages col col-12" style="height: calc(100% - (155px));">
                            <cfif get_wrk_messages.recordcount>
                                <cfoutput query="get_wrk_messages">
                                    <cfif attributes.userid eq sender_id>
                                        <cfset sended_from = "me">
                                        <cfset pull = "pull-left">
                                        <cfset link_from ="link_me">
                                        <cfset img_download="download_me">
                                    <cfelse>
                                        <cfset sended_from = "you">
                                        <cfset pull = "pull-right">
                                        <cfset link_from = "link_you">
                                        <cfset img_download="download_you">
                                    </cfif>
                                    <cfif IS_DELETED neq 1>
                                        <div class="bubble_block" id="message_#WRK_MESSAGE_ID#">
                                            <div class="bubble_checkbox_panel"><cfif IS_DELETED neq 1><input type="checkbox" name="bubble_checkbox" value="#WRK_MESSAGE_ID#"></cfif></div>
                                            <div class="bubble wrap #sended_from#">
                                                <cfset imgList = ["png","jpeg","jpg","gif"]>
                                                <cfif MESSAGE_FILE eq 0 or not len( MESSAGE_FILE )>
                                                    <span>#message#</span>
                                                <cfelse>
                                                    <cfset imgSrcDownload = "messageFiles/" & MESSAGE_FILE_ENCRYPTED_FULL_NAME >
                                                    <cfif arrayContains( imgList, LCase( MESSAGE_FILE_EXTENTION ) )>
                                                        <cfset imgSrc = "documents/messageFiles/" & MESSAGE_FILE_ENCRYPTED_FULL_NAME>
                                                        <img src="#imgSrc#" width="280" height="auto">
                                                    <cfelse>
                                                        <cfif fileExists( "#download_folder#/css/assets/icons/catalyst-icon-svg/#UCase(MESSAGE_FILE_EXTENTION)#.svg")>
                                                            <cfset imgSrc = "css/assets/icons/catalyst-icon-svg/" & UCase(MESSAGE_FILE_EXTENTION) & ".svg">
                                                            <img src="#imgSrc#" width="40" height="auto"><span style="color:rgba(0,0,0,.5);font-weight:bold;margin:0 0 0 10px;">#MESSAGE_FILE_NAME#</span>
                                                        <cfelse>
                                                            <cfset imgSrc = "css/assets/icons/catalyst-icon-svg/UNKOWN.SVG">
                                                            <img src="#imgSrc#" width="40" height="auto"><span style="color:rgba(0,0,0,.5);font-weight:bold;margin:0 0 0 10px;">#MESSAGE_FILE_NAME#</span>
                                                        </cfif>
                                                    </cfif>
                                                    <cfif len(message)><div class="file_message">#message#</div></cfif>
                                                    <div class="#img_download# meYouTop30" title="#upload_folder##imgSrcDownload#">
                                                        <cf_get_server_file output_file="#imgSrcDownload#" output_server="1" output_type="6" image_link="1">
                                                    </div>
                                                </cfif>
                                                <div style="margin-top:12px;">#dateformat(send_date,dateformat_style)#-#timeformat(send_date,timeformat_style)#</div>
                                            </div>
                                        </div>
                                    </cfif>
                                </cfoutput>
                            </cfif>
                            <div id="new_message"></div>
                        </div>
                        <div class="col col-12 col-md-12" id="message_area">
                            <div id="send_message_panel" style="display:flex;align-items:flex-end;padding:0 20px;" class="col col-12">
                                <input type="hidden" name="enc_key" id="enc_key" value="<cfoutput>#attributes.enc_key#</cfoutput>">
                                <textarea  id="text_area"  class="embed-responsive-item" name="text" oninput="auto_grow(this)"></textarea>
                                <button class="pull-right send_btn" onClick="sender('')" disabled><i class="fa fa-paper-plane"></i></button>
                            </div>
                        </div>
                    </div>

                    <cfset encryptionKey ="dvayMin0XFT2PQp8PMinoA==" />
                    <cfset raw = attributes.userid&"/*/*/"&sender_type&"/*/*/"&receiver_type&"/*/*/"&DSN >
                    <cfset ws_secret = encrypt(raw,encryptionKey,"AES","hex") />

                    <cfwebsocket name="chatflow"
                        onMessage="chatflowmessageHandler"
                        onError="chatflowerrorHandler"
                        onOpen="chatflowopenHandler"
                        onClose="chatflowcloseHandler"
                        useCfAuth="true"
                        secure="#wssecure#"
                        subscribeTo="chat.#attributes.userkey#"
                    />

                    <script type="text/javascript">

                        window.messageFiles = [];
                        window.messagepageid = "<cfoutput>#get_agent_user.EMPLOYEE_ID#</cfoutput>";
                        window.messageGroupid = "";
                        window.messageGroupEmpid = [];
                        window.activeWindow = 0;
                        var imageList = ["png","jpg","jpeg","gif"], windowPanelId = "";

                        chatflowmessageHandler =  function(aEvent,aToken) {
                            if (aEvent.data && aEvent.data.SENDER_ID)
			                {
                                var newMessage = (aEvent.data.MESSAGE != "") ? aEvent.data.MESSAGE : "Dosya gönderdi";
                                if( document.getElementById("new_message") != undefined && window.messagepageid == aEvent.data.SENDER_ID ){

                                    var txt = document.getElementById("new_message");
                                    
                                    if( !aEvent.data.FILE.ISFILE ){
                                        txt.innerHTML += '<div class="bubble_block" id="message_'+ aEvent.data.MESSAGE_ID +'"><div title="<cfoutput>#dateformat(now(),dateformat_style)#-#timeformat(now(),timeformat_style)#</cfoutput>" class="bubble wrap you"><span>' + convert( aEvent.data.MESSAGE ) + '</span><div style="margin-top:10px;"><cfoutput>#dateformat(now(),dateformat_style)#-#timeformat(now(),timeformat_style)#</cfoutput></div></div></div>';
                                    }

                                    $.ajax({url: "/WEX/chatflow/component/messages.cfc?method=isalerted", type: "POST", data: { enc_key: aEvent.data.ENC_KEY }});

                                    goBottom('all_messages');

                                }
                            }
                        }
                        chatflowerrorHandler = function(error) { console.log( error ); }
                        chatflowopenHandler = function() {}
                        chatflowcloseHandler= function() {}

                        sendMessage = function( messageText = "", enc_key ) {
                
                            var message = messageText,
                                fileMessage = "",
                                messagetype = false,
                                receiverid = [];
                        
                            message = $.trim($("#text_area").val());
                        
                            receiverid = [window.messagepageid];
                            messagetype = false;
                            
                            if (message != "" || fileMessage != "" || window.messageFiles.length > 0) {
                        
                                function wssend(receiverid, messageContent, addMessage = true) {
                                    
                                    var channel = 'chat.'+receiverid;
                                    messageContent.addMessage = addMessage;
                                    var headers = {
                                        receiver_id: receiverid,
                                        token: "<cfoutput>#ws_secret#</cfoutput>",
                                        msgContent: messageContent
                                    }
                                    response = chatflow.publish(channel, messageContent.message, headers);
                                    
                                    if( response && addMessage ){
                        
                                        function setMyMessage( receiverid, callback ) {
                                            var data = new FormData();
                                            data.append('enc_key', enc_key);
                                            AjaxControlPostDataJson( "/WEX/chatflow/component/messages.cfc?method=get_last_messages", data, callback);	
                                        }
                        
                                        setMyMessage( receiverid, function ( resp ) {
                        
                                            if( resp.length ){

                                                var txt = document.getElementById("new_message");
                                                if( message != "" ) txt.innerHTML += '<div class="bubble_block" id="message_' + resp[0].WRK_MESSAGE_ID + '"><div title="<cfoutput>#dateformat(now(),dateformat_style)#-#timeformat(now(),timeformat_style)#</cfoutput>" class="bubble wrap me"><span>'+ convert( message ) +'</span><div style="margin-top:10px;"><cfoutput>#dateformat(now(),dateformat_style)#-#timeformat(now(),timeformat_style)#</cfoutput></div></div></div>';
                                                goBottom('all_messages');
                        
                                            }
                        
                                        });
                        
                                    }

                                }
                                
                                var totalMessage = [];
                                if( window.messageFiles.length ){
                                    window.messageFiles.forEach((el) => {
                                        totalMessage.push({
                                            message : fileMessage,
                                            messageStatus: { isDeleted: false, isForward: false },
                                            isFile : true,
                                            file : el,
                                            group: { group_id: '', groupUsers: window.messageGroupEmpid },
                                            enc_key: '<cfoutput>#attributes.enc_key#</cfoutput>'
                                        });
                                    });
                                }
                                if( message ) totalMessage.push({ message : message, messageStatus: { isDeleted: false, isForward: false }, isFile : false, group: { group_id: '', groupUsers: window.messageGroupEmpid }, enc_key: '<cfoutput>#attributes.enc_key#</cfoutput>' });
                        
                                receiverid.forEach((rec, index) => {
                                    totalMessage.forEach(ttm => {
                                        wssend(rec, ttm, true );
                                    });
                                });
                        
                                window.last_message = document.getElementById('text_area').value;
                                document.getElementById('text_area').value = '';
                        
                                window.messageFiles = [];
                                $("#messages-body").css({ "height" : "calc(100% - (60px))" });
                            }
                        }

                        $("#message_area").on("keyup keydown","#text_area",function(event){
                            sendButtonManagement();
                        });

                        $('.send_btn').click(function(){
                            $('#text_area').css("height","auto");
                        });

                        $("#text_area").keypress(function (e) {
                            if(e.which == 13) {     
                                $('#text_area').css("height","auto");
                            }
                        });
                    
                    </script>
                <cfelse>
                    Üzgünüz! Çevrimiçi kullanıcı yok. Lütfen daha sonra tekrar deneyin.
                </cfif>

            </cfif>

        </body>
    </html>

</cfif>