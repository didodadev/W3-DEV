<cfif 
    IsDefined("attributes.x_agent_list") and len(attributes.x_agent_list)
    and IsDefined("attributes.x_chat_days") and len(attributes.x_chat_days)
    and IsDefined("attributes.x_chat_start_time") and len(attributes.x_chat_start_time)
    and IsDefined("attributes.x_chat_finish_time") and len(attributes.x_chat_finish_time)>
    <cfset data = user = structNew() />
    <cfif isDefined("session_base")>
        <cfset user = {
            userkey: session_base.userkey,
            usertype: listFirst(session_base.userkey, '-'),
            userid: session_base.userid,
            name: session_base.name,
            surname: session_base.surname,
            username: session_base.username,
            email: session_base.email
        } />
    <cfelse>
        <cfset noSessionUserId = createUUID() />
        <cfset user = {
            userkey: 'q-#noSessionUserId#',
            usertype: 'q',
            userid: noSessionUserId,
            name: "",
            surname: "",
            username: "",
            email: ""
        } />
    </cfif>

    <cfset data = {
        option: {
            x_agent_list: attributes.x_agent_list,
            x_chat_days: attributes.x_chat_days,
            x_chat_start_time: attributes.x_chat_start_time,
            x_chat_finish_time: attributes.x_chat_finish_time
        }
    } />

    <cfset encData = contentEncryptingandDecodingAES(isEncode:1,content:replace(serializeJson(data),'//',''),accountKey:'wrk') />
    <cfset chatflow_url = "#application.systemParam.systemParam().employee_domain#wex.cfm/chatflow/?data=#encData#&chat=1" />
    <cfset enc_key = createUUID() />

    <cfsavecontent  variable="chatflow_content">   
        <div id="chatflow" style="width:100%;">
            <div id="chatflow-start">
                <form name="chatflow-form" id="chatflow-form" action="<cfoutput>#chatflow_url#</cfoutput>" method="post">
                    <cfoutput>
                        <input type="hidden" name="userkey" id="userkey" value="#user.userkey#">
                        <input type="hidden" name="usertype" id="usertype" value="#user.usertype#">
                        <input type="hidden" name="userid" id="userid" value="#user.userid#">
                        <input type="hidden" name="enc_key" id="enc_key" value="#enc_key#">
                        <div class="row">
                            <div class="col-md-12">                              
                                <div class="form-group">
                                    <label><cf_get_lang dictionary_id='57631.Ad'></label>
                                    <input type="text" name="name" id="name" class="form-control" value="#user.name#" required="" oninput="setCustomValidity('')" oninvalid="this.setCustomValidity('<cf_get_lang dictionary_id='64670.Lütfen tüm alanları doldurunuz!'>')">
                                </div>
                                <div class="form-group">
                                    <label><cf_get_lang dictionary_id='58726.Soyad'></label>
                                    <input type="text" name="surname" id="surname" class="form-control" required="" oninput="setCustomValidity('')" oninvalid="this.setCustomValidity('<cf_get_lang dictionary_id='64670.Lütfen tüm alanları doldurunuz!'>')">
                                </div>
                                <div class="form-group">
                                    <label>E-mail</label>
                                    <input type="email" name="email" id="email" class="form-control" required="" oninput="setCustomValidity('')" oninvalid="this.setCustomValidity('<cf_get_lang dictionary_id='29707.Lütfen e-mail adresinizi giriniz'>')">
                                </div>
                                <input type="submit" class="btn btn-primary btn-block" value="<cf_get_lang dictionary_id='65004.Start Conversation'>">
                            </div>                            
                        </div>
                    </cfoutput>
                </form>
            </div>
            <iframe name="chatflowFrame" id="chatflowFrame" height="300" style = "width:100%;" scrolling="no" frameborder="0" src=""></iframe>
            <div id="chatflow-finish" style="display:none;">
                <div class="row">
                    <div class="col-md-12">
                        <div class="form-group">
                            <a href="javascript://" style="color:#fff;" class="btn btn-danger btn-block" onclick = "finishChatflow()"><cf_get_lang dictionary_id='65005.End Conversation'></a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </cfsavecontent>
    <cfif isDefined("attributes.chatflow_design") and attributes.chatflow_design neq 0>
        <style>
            .chatflow-box.chatflow-right-center {
                position: fixed;
                right: 0px;
                top: 35%;
                z-index: 999;
            }

            ul.chat-flow-items {
                padding: 0;
                margin: 0;
            }

            ul.chat-flow-items li {width: 36px;height: 36px;background: #1d8bcb;padding: 16px;margin-bottom: 5px;display: flex;flex-direction: column;flex-wrap: nowrap;align-content: center;justify-content: center;align-items: center;cursor: pointer;}

            ul.chat-flow-items li i {
                color: white;
                font-size: 20px;
            }

            li.chat-flow-item.cfi-chat {
                background: #f37021;
            }

            li.chat-flow-item.cfi-phone {}

            li.chat-flow-item.cfi-wp {
                background: #2cb742;
            }

            li.chat-flow-item.cfi-wp i {
                font-weight: bold;
                font-size: 22px;
            }

            li.chat-flow-item.cfi-note {
                background: #ffc107;
            }
            
            .cfi-dropdown-content.dropdown-menu {
                margin-top: -30px !important;
                left:unset !important;
                right: -275px;
                width: 340px;
                min-height: 380px;
                float: right;
                padding: 0;
                background: #ffffff;
            }
            i#cflw-chat-box {
                width: 50px;
                height: 50px;
                background: #f37021;
                padding: 16px;
                display: flex;
                flex-direction: column;
                flex-wrap: nowrap;
                align-content: center;
                justify-content: center;
                align-items: center;
                margin: -13px -15px -15px -21px;
                font-size: 25px;
            }

            .card-header.cflw-chat-box-title {justify-content: flex-start;background: #e4e4e4;}

            .card-header.cflw-chat-box-title span {display: block;margin-left: 29px;font-size: 22px;line-height: 25px;color: #173a60;}
            .cfi-dropdown-content.dropdown-menu.show iframe {
                margin: -20px 0px 15px -20px;
                width: 338px !important;
            }

            .cfi-dropdown-content.dropdown-menu .card .card-body {
                padding-bottom: 0 !important;
            }
        </style>
        <div class="chatflow-box <cfoutput>#attributes.chatflow_design#</cfoutput>">
           <ul class="chat-flow-items">
                <li class="chat-flow-item cfi-chat">
                    <i class="fas fa-comments" id="dropdown_cfi-chat" data-toggle="dropdown" title="ChatFlow"></i>
                    <div class="cfi-dropdown-content dropdown-menu" aria-labelledby="dropdown_cfi-chat">
                        <div class="card">
                            <div class="card-header cflw-chat-box-title">
                                <i class="fas fa-comments" id="cflw-chat-box"></i> <span>ChatFlow</span>
                            </div>
                            <div class="card-body"> 
                                <cfoutput>
                                    #chatflow_content#
                                </cfoutput> 
                            </div>
                        </div>                        
                    </div>
                </li>
                <li class="chat-flow-item cfi-phone">
                    <a href="tel:908504412323"><i class="fas fa-phone-alt" href="tel:908504412323" title="<cf_get_lang dictionary_id='62263.Çağrı'>"></i></a>
                </li>
                <li class="chat-flow-item cfi-wp">
                    <a href="https://api.whatsapp.com/send/?phone=905531073722&text&app_absent=0" target="_blank"><i class="fab fa-whatsapp" title="WhatsApp"></i></a>
                </li>
                <li class="chat-flow-item cfi-note">
                    <cfoutput>
                        <cfsavecontent  variable="title"><cf_get_lang dictionary_id='58143.İletişim'> <cf_get_lang dictionary_id='30976.Formu'>
                        </cfsavecontent>
                        <a href="javascript://" onclick="openBoxDraggable('widgetloader?widget_load=SupportNoteForm&isbox=1&style=maxi&title=#title#')"><i class="fas fa-pencil-alt" id="dropdown_cfi-note" title="<cf_get_lang dictionary_id='58143.İletişim'>" data-toggle="dropdown"></i></a>
                    </cfoutput>
                </li>
            </ul>
        
        </div>
    <cfelse>
        <cfoutput>
            #chatflow_content#
        </cfoutput>
    </cfif>
    <script>

        var chatflowStart = document.getElementById('chatflow-start');
        var chatflowFinish = document.getElementById('chatflow-finish');
        var chatflowFrame = document.getElementById('chatflowFrame');        
        chatflowFrame.style.display = 'none';
        function setCookie( cookieName, cookieValue, exday ) {
            const d = new Date();
            d.setTime(d.getTime() + (exday*24*60*60*1000));
            let expires = "expires="+ d.toUTCString();
            document.cookie = cookieName + "=" + cookieValue + ";" + expires + "; path=/";
        }

        function getCookie( cookieName ) {
            let name = cookieName + "=";
            let ca = document.cookie.split(';');
            for(let i = 0; i < ca.length; i++) {
                let c = ca[i];
                while (c.charAt(0) == ' ') c = c.substring(1);
                if (c.indexOf(name) == 0) return c.substring(name.length, c.length);
            }
            return "";
        }

        function removeCookie( cookieName ) {
            document.cookie = cookieName + "=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
        }

        function setChatflowFrame( url ) {
            if(chatflowFrame !== null){
                if(chatflowFrame.src) chatflowFrame.src = url; // Explorer eski surum
                else if(chatflowFrame.contentWindow !== null && chatflowFrame.contentWindow.location !== null) chatflowFrame.contentWindow.location = url; //Chrome
                else chatflowFrame.setAttribute('src', url); // Explorer yeni surum
                
                chatflowStart.style.display = 'none';
                chatflowFrame.style.display = 'inline';
                chatflowFinish.style.display = 'inline';
            }
        }

        function finishChatflow() {
            if( confirm("<cf_get_lang dictionary_id='31761.Devam etmek istediğinize emin misiniz'>?") ){
                var data = new FormData();
                data.append('cfc', '/V16/objects/cfc/chatflow_visitors');
                data.append('method', 'finish_chatflow');
                data.append('form_data', JSON.stringify({enc_key: getCookie('chatflow_enc_key')}));
                AjaxControlPostDataJson('/datagate',data,function(response) {
                    if( response.STATUS ){
                        removeCookie( "chatflow_enc_key" );
                        document.location.reload();     
                    }
                });
            }
        }
        //Daha önce başlatılmış ve henüz sonlandırılmamış konuşmayı yükler.
        if( getCookie('chatflow_enc_key') != '' ){
            var chatflow_url = "<cfoutput>#chatflow_url#</cfoutput>";
            setChatflowFrame( chatflow_url + '&enc_key=' + getCookie('chatflow_enc_key') );
        }

        $("#chatflow-form").submit(function () {
            var userInformation = $(this).serializeArray();
            var formAction = $(this).attr('action');

            if( userInformation.length > 0 ){
                userInformation.forEach(el => {
                    if( el.name == 'enc_key' ) setCookie( 'chatflow_' + el.name,  el.value, 1 );
                    formAction += ('&' + el.name + "=" + el.value);
                });

                setChatflowFrame( formAction );

            }
            return false;
        });

    </script>

<cfelse>
    <cf_get_lang dictionary_id='65006.Chatflow parametre ayarları yapılandırılmamış!'>
</cfif>