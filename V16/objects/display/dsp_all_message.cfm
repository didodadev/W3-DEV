<cfif not isdefined("session.ep.userid")>
    <cf_get_lang_set_main>
    <cfsavecontent variable="session.error_text"><cf_get_lang_main no='126.session_error'></cfsavecontent>
    <cfoutput><a onClick="javascript://" class="tableyazi" href="#request.self#?fuseaction=home.login">#session.error_text#</a></cfoutput>
    <cfexit method="exittemplate">
</cfif>

<cfparam  name="attributes.employee_id" default="" />
<cfparam  name="attributes.group_id" default="" />
<cfparam  name="attributes.enc_key" default="" />
<cfparam  name="attributes.action_wo" default="" />
<cfparam  name="attributes.action_wo_event" default="" />
<cfparam  name="attributes.action_parameter" default="" />
<cfparam  name="attributes.action_id" default="" />

<cfset visitor = '{}' />

<cfset messages = createObject("Component","V16.objects.cfc.messages") />
<cfset message_group = createObject("Component","V16.objects.cfc.message_group") />
<cfset chatflow_visitors = createObject("Component","V16.objects.cfc.chatflow_visitors") />

<link rel="stylesheet" href="/css/assets/template/fileupload/dropzone.css" type="text/css">
<link rel="stylesheet" href="/css/assets/template/fileupload/fileupload-min.css" type="text/css">

<cfif len(attributes.employee_id) or len(attributes.group_id) or len(attributes.enc_key)>
    <cfset get_wrk_messages = messages.get_wrk_messages(employee_id : attributes.employee_id, group_id: attributes.group_id, enc_key: attributes.enc_key)>
    <cfset get_wrk_ep_apps = messages.GET_WRK_EP_APPS( notuser: attributes.employee_id )>
    
    <cfset messages.isalerted(employee_id : attributes.employee_id, group_id: attributes.group_id, enc_key: attributes.enc_key)>

    <cfset messageCounter = messages.message_counter()>
    <cfset totalMessageCount = ( messageCounter.recordcount ) ? messageCounter.COUNT : 0>

    <div style="display:none;" class="ui-cfmodal" id="upload_modal">
        <div class="boxRow">
            <div class="portBox portBottom">
                <div class="portHeadLight">
                    <div class="portHeadLightTitle">
                        <span>
                            <a></a>
                        </span>
                    </div>
                    <div class="portHeadLightMenu">
                        <ul>
                            <li><a href="javascript://" class="catalystClose">×</a></li>
                        </ul>
                    </div>
                </div>
                <div class="portBoxBodyStandart">
                    <div style="width:100%" id="chatflow">
                        <form method="post" method="post" name="messageFileForm" enctype="multipart/form-data">
                            <div class="archive_form">
                                <div class="archive_form_step">
                                    <div class="ui-form-list ui-form-block" style="justify-content:center;">
                                        <div class="form-group">
                                            <div id="fileUpload" class="fileUpload">
                                                <div class="fileupload-body">
                                                    <input type="hidden" name="foldername" id="foldername" value="<cfoutput>#createUUID()#</cfoutput>">
                                                    <input type="hidden" name="message_Del" id="message_Del" value="<cf_get_lang dictionary_id='57463.Sil'>">
									                <input type="hidden" name="message_Cancel" id="message_Cancel" value="<cf_get_lang dictionary_id='58506.İptal'>">
                                                    <div class="dropzone dz-clickable dropzonescroll" id="file-dropzone">
                                                        <div class="dz-default dz-message">
                                                            <i><cf_get_lang dictionary_id='61360.Sürükle ve Bırak'></i>
                                                            <a href="javascript://"><span class="catalyst-pin"></span>Max : 200 MB</a>
                                                        </div>
                                                    </div>  
                                                </div>
                                            </div>
                                        </div>									
                                    </div>
                                </div>
                                <div class="ui-form-list ui-form-block">
                                    <div class="form-group col col-10 col-xs-8 pdn-l-0">
                                        <input type="text" name="fileMessage" id="fileMessage" style="border-radius:3px;" placeholder="Açıklama ekleyebilirsiniz.">
                                    </div>
                                    <div class="form-group col col-2 col-xs-4 pdn-r-0">
                                        <button type="submit" id="messageFileUploadButton" class="ui-btn ui-btn-update" disabled><cf_get_lang dictionary_id='58743.Gönder'></button>
                                    </div>
                                </div>    
                            </div>
                        </form>
                    </div> 
                </div>
            </div>
        </div>        
    </div>
    <div style="display:none; min-width:25%;" class="ui-cfmodal" id="forward_modal">
        <div class="boxRow">
            <div class="portBox portBottom">
                <div class="portHeadLight">
                    <div class="portHeadLightTitle">
                        <span>
                            <a><cf_get_lang dictionary_id='51096.İlet'></a>
                        </span>
                    </div>
                    <div class="portHeadLightMenu">
                        <ul>
                            <li><a href="javascript://" class="catalystClose">×</a></li>
                        </ul>
                    </div>
                </div>
                <div class="portBoxBodyStandart">
                    <div style="width:100%">
                        <form method="post" method="post" name="messageForwardForm">
                            <div class="archive_form">
                                <div class="archive_form_step">
                                    <div class="ui-form-list ui-form-block" style="justify-content:center;">
                                        <div class="col col-12 pdn-l-0 pdn-r-0"><div class="ui-card"><div class="ui-card-item" style="padding:5px 15px;"><h4><cf_get_lang dictionary_id='62333.En fazla 10 kişi seçebilirsiniz'>!</h4></div></div></div>
                                        <div class="col col-12 col-md-12 col-sm-12 col-xs-12 message_user_list" style="height:calc(100% - (50px)) !important;"> <!--- Son Mesajlar --->
                                            <div class="col col-12 rightButtonsDiv">
                                                <input type="text" class="main-input main-name" name="keyword" placeholder="<cf_get_lang dictionary_id='29831.Kişi'> <cf_get_lang dictionary_id='57565.Ara'>">
                                            </div>
                                            <div class="col col-12 scrollbar" style="height:300px !important;overflow-y:scroll;padding:0;">
                                                <ul class="lightList agendaDayTime- text-left forwardList">
                                                    <cfoutput query="get_wrk_ep_apps">
                                                        <li data-id="#EMPLOYEE_ID#">
                                                            <div class="ContentRow col col-12 col-md-12 col-sm-12 col-xs-12">
                                                                <a href="javascript://">
                                                                    <div>
                                                                        <cfif len(PHOTO) and DirectoryExists("#upload_folder#hr/#photo#")>
                                                                            <img src="#upload_folder#hr/#photo#" width="40" height="40" class="img-circle userIcon" style="float:left">
                                                                        <cfelse>
                                                                            <span class="avatextCt color-#Left(EMPLOYEE_NAME, 1)# userIcon">
                                                                                <small class="avatext">#Left(EMPLOYEE_NAME, 1)##Left(EMPLOYEE_SURNAME, 1)#</small>
                                                                            </span>
                                                                        </cfif>
                                                                        <span class="acceptance"></span>
                                                                        <div class="UpRow" style="padding-top:15px; margin-left:10%;">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</div>
                                                                    </div>
                                                                </a>
                                                                <input type="checkbox" name="multimessage" value="#EMPLOYEE_ID#" style="display:none">
                                                            </div> 
                                                        </li>
                                                    </cfoutput>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="ui-form-list ui-form-block">
                                    <div class="form-group col col-10 col-xs-8 forward_panel" id="forwardPerson"></div>
                                    <div class="form-group col col-2 col-xs-4 pdn-r-0">
                                        <button type="submit" id="messageForwardButton" class="ui-btn ui-btn-update" disabled><cf_get_lang dictionary_id='58743.Gönder'></button>
                                    </div>
                                </div>    
                            </div>
                        </form>
                    </div> 
                </div>
            </div>
        </div>        
    </div>

    <div class="col col-12 col-sm-12 col-xs-12 message-body" id="messages-body" style="height: calc(100% - (61px));">
        <div id="user_info" class="col col-12">
            <cfif len( attributes.employee_id )>
                <div class="col col-6 col-md-8 col-sm-8 col-xs-7 userrightinfo">
                    <cfquery name="GET_PHOTO" datasource="#dsn#">
                        SELECT E.PHOTO, ED.SEX, E.EMPLOYEE_NAME, E.EMPLOYEE_SURNAME FROM EMPLOYEES AS E LEFT JOIN EMPLOYEES_DETAIL AS ED ON E.EMPLOYEE_ID = ED.EMPLOYEE_ID WHERE E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.employee_id#">
                    </cfquery>
                    <div class="profileusersListLeft">
                        <cfif len(GET_PHOTO.PHOTO) and DirectoryExists("<cfoutput>#upload_folder#hr/#GET_PHOTO.PHOTO#</cfoutput>")>
                            <img src="<cfoutput>#upload_folder#hr/#GET_PHOTO.PHOTO#</cfoutput>" width="30" height="30" class="img-circle">
                        <cfelse>
                            <span style="width:30px;height:30px" class="avatextCt color-<cfoutput>#Left(GET_PHOTO.EMPLOYEE_NAME, 1)#</cfoutput>">
                                <small style="top:-4px;width:30px;" class="avatext"><cfoutput>#Left(GET_PHOTO.EMPLOYEE_NAME, 1)##Left(GET_PHOTO.EMPLOYEE_SURNAME, 1)#</cfoutput></small>
                            </span>
                        </cfif>
                    </div>
                    <div class="profileusersListRight">
                        <a href="javascript://" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_emp_det&emp_id=<cfoutput>#attributes.employee_id#</cfoutput>');">
                            <span><cfoutput>#get_emp_info(attributes.employee_id,0,0)#</cfoutput></span>
                        </a>
                    </div>
                </div>
                <div class="col col-6 col-md-4 col-sm-4 col-xs-5 topButtonsDiv" style="float:right;">
                    <ul>
                        <li class="dropdown"><a href="javascript://" id="mbl_online_users" title="<cf_get_lang dictionary_id='32415.Online Kullanıcılar'>"><i class="catalyst-bubble"></i></a></li>
                        <li class="dropdown"><i class="catalyst-trash" onclick="if(confirm('<cf_get_lang dictionary_id='51395.Mesajı Silmek İstediğinize Emin misiniz ?'>')) removeAllMessage(<cfoutput>#session.ep.userid#,#attributes.employee_id#</cfoutput>)"></i></li>
                    </ul>  
                </div> 
            <cfelseif len( attributes.group_id )>
                
                <cfset getMessageGroup = message_group.getMessageGroup( wr_id: attributes.group_id ) />
                
                <div class="col col-6 col-md-8 col-sm-8 col-xs-7 userrightinfo">
                    <div class="profileusersListLeft">
                        <span style="width:30px;height:30px" class="avatextCt color-<cfoutput>#Left(getMessageGroup.WG_NAME, 1)#</cfoutput>">
                            <small style="top:-4px;width:30px;" class="avatext"><cfoutput>#Left(getMessageGroup.WG_NAME, 1)#</cfoutput></small>
                        </span>
                    </div>
                    <div class="profileusersListRight">
                        <span><cfoutput>#getMessageGroup.WG_NAME#</cfoutput></span>
                    </div>
                </div>
                <div class="col col-6 col-md-4 col-sm-4 col-xs-5 topButtonsDiv" style="float:right;">
                    <ul>
                        <li class="dropdown"><a href="javascript://" id="mbl_online_users" title="<cf_get_lang dictionary_id='32415.Online Kullanıcılar'>"><i class="catalyst-bubble"></i></a></li>
                    </ul>  
                </div>
            
            <cfelseif len( attributes.enc_key )>
                
                <cfset get_visitor = chatflow_visitors.get_visitor( enc_key: attributes.enc_key )>

                <cfset visitor = "{ enc_key: '#attributes.enc_key#', visitor_key: '#get_visitor.VISITOR_KEY#' }" />

                <div class="col col-6 col-md-8 col-sm-8 col-xs-7 userrightinfo">
                    <div class="profileusersListLeft">
                        <span style="width:30px;height:30px" class="avatextCt color-<cfoutput>#Left(get_visitor.VISITOR_NAME, 1)#</cfoutput>">
                            <small style="top:-4px;width:30px;" class="avatext"><cfoutput>#Left(get_visitor.VISITOR_NAME, 1)##Left(get_visitor.VISITOR_SURNAME, 1)#</cfoutput></small>
                        </span>
                    </div>
                    <div class="profileusersListRight">
                        <span><cfoutput>#get_visitor.VISITOR_NAME# #get_visitor.VISITOR_SURNAME#</cfoutput></span>
                    </div>
                </div>
                <div class="col col-6 col-md-4 col-sm-4 col-xs-5 topButtonsDiv" style="float:right;">
                    <ul>
                        <li class="dropdown"><a href="javascript://" id="mbl_online_users" title="<cf_get_lang dictionary_id='32415.Online Kullanıcılar'>"><i class="catalyst-bubble"></i></a></li>
                    </ul>  
                </div>

            </cfif>
        </div>
        <div id="all_messages" class="scrollbar scrltp all_messages col col-12" style="height: calc(100% - (155px));">                   
            <cfoutput query="get_wrk_messages">
                <cfif session.ep.userid eq sender_id>
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
                        <div class="bubble wrap #sended_from#" title="<cfif len(ACTION_PAGE) and len(ACTION_ID)>#application.functions.getLang(51944)#</cfif>">
                            <div class="message_option meYouTop5 message_option_#sended_from#">
                                <ul>
                                    <li>
                                        <a href="javascript://"><i class="fa fa-ellipsis-h"></i></a>
                                        <ul>
                                            <li>
                                                <a href="javascript://" onclick="forwardMessage(#WRK_MESSAGE_ID#)"><i class="fa fa-location-arrow"></i><cf_get_lang dictionary_id='51096.İlet'></a>
                                            </li>
                                            <li>
                                                <a href="javascript://" onclick="removeMessage(#WRK_MESSAGE_ID#)"><i class="fa fa-trash"></i><cf_get_lang dictionary_id='57463.Sil'></a>
                                            </li>
                                        </ul>
                                    </li>
                                    <cfif len(FUSEACTION)> <!--- süreçlerden gelen bir mesaj ise linke yönlendirmek için --->
                                        <li>
                                            <div class="#link_from#">
                                                <i class="fa fa-cube" onclick="openTab(3,'action=#FUSEACTION##(len(ACTION_ID) and ACTION_ID neq 0) ? '&action_id=' & ACTION_ID : '&parent_id=' & WARNING_PARENT_ID#')"></i>
                                            </div>
                                        </li>
                                    </cfif>
                                </ul>
                            </div>
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
                            <cfif IS_DELIVERED eq 1>
                                <div class="forwardIcon_#sended_from# #MESSAGE_FILE eq 1 ? 'meYouTop60' : 'meYouTop30'#">
                                    <i class="fa fa-share"></i>
                                </div>
                            </cfif>
                            <div style="margin-top:12px;">#dateformat(send_date,dateformat_style)#-#timeformat(send_date,timeformat_style)#</div>
                        </div>
                    </div>
                </cfif>
            </cfoutput>
            <div id="new_message"></div>                                        
        </div>
        <div class="col col-12 col-md-12" id="message_area">
            <div id="send_message_panel" style="display:flex;align-items:flex-end;padding:0 20px;" class="col col-12">
                <ul class="send_icon">
                    <li id="open_img">
                        <label><i class="fa fa-image"></i></label>
                    </li>
                    <li id="open_fld">
                        <label><i class="fa fa-folder-open"></i></label>
                    </li>
                    <li>
                        <label title="Coming Soon"><i class="fa fa-camera"></i></label>
                    </li>
                    <li>
                        <label title="Coming Soon"><i class="fa fa-microphone"></i></label>
                    </li>
                </ul>
                <textarea placeholder="Bir mesaj yazın" id="text_area"  class="embed-responsive-item" name="text" oninput="auto_grow(this)"> </textarea>
                <button class="pull-right send_btn" onClick="sender( false, false, '', '<cfoutput>#len( attributes.group_id ) ? attributes.group_id : ''#</cfoutput>', <cfoutput>#visitor#</cfoutput> )" disabled><i class="fa fa-paper-plane"></i></button>
            </div>
            <div id="forward_message_panel" style="display:none;align-items:flex-end;padding:0 20px;" class="col col-12">
                <div class="col col-2 col-xs-4 pdn-l-0"><button class="forward_cancel_btn" onClick="forwardCancel()"><i class="fa fa-close"></i></button></div>
                <div class="col col-8 col-xs-4 forward_panel" id="forwardChosen"></div>
                <div class="col col-2 col-xs-4"><button class="pull-right forward_btn" onClick="forward()" disabled><i class="fa fa-paper-plane"></i></button></div>
            </div>
        </div>
    </div>

    <script type="text/javascript" src="/JS/fileupload/dropzone_message.js"></script>
    <script>
        
        function auto_grow(element) {
            element.style.height = "auto";
            element.style.height = (element.scrollHeight)+"px";
        }

        function sender( isForward = false, isDeleted = false, messageText = "", group_id = "", visitor = "" ) {
            sendMessage( isForward, isDeleted, messageText, group_id, visitor );
        }

        /* forward process */

        let forwardMessages = [];

        function forwardMessage(message_id) {
            $(".bubble_block").addClass("active_bubble_block");
            $("#send_message_panel").hide();
            $(".bubble_checkbox_panel, #forward_message_panel").show();
        }

        function forwardCancel() {
            $(".bubble_block").removeClass("active_bubble_block");
            $("#send_message_panel").show();
            $(".bubble_checkbox_panel, #forward_message_panel").hide();
            $("input[name = bubble_checkbox]").each(function(){ $(this).prop("checked",false) });
            $('#forward_modal').hide();
            forwardMessages = [];
        }

        function removeMessage(message_id) {
            if(confirm("<cf_get_lang dictionary_id='51395.Mesajı Silmek İstediğinize Emin misiniz ?'>")){
                let data = new FormData();
                data.append('message_id', message_id);
                AjaxControlPostDataJson( "V16/objects/cfc/messages.cfc?method=isdeleted", data, function(response) {
                    if( response.status ){
                        $("#message_"+ message_id).remove();
                    }else alert('Error!');
                });
            }
        }

        $("#all_messages").delegate('.active_bubble_block', 'click', function() {

            if( $(this).find("input[type=checkbox]").is(":checked") ){
                $(this).find("input[type=checkbox]").prop("checked", false);
                const forwardMessageindex = forwardMessages.indexOf( $(this).val() );
                if (forwardMessageindex > -1) forwardMessages.splice(forwardMessageindex, 1);
            }else if( forwardMessages.length < 5 ){
                $(this).find("input[type=checkbox]").prop("checked", true);
                forwardMessages.push( $(this).val() );
            }else alert("<cf_get_lang dictionary_id='62334.En fazla 5 mesaj seçebilirsiniz'>");

            if( forwardMessages.length > 0 ){
                $("#forwardChosen").html("<span>" + forwardMessages.length + " <cf_get_lang dictionary_id='62203.Mesaj seçildi'></span>");
                $(".forward_btn").prop("disabled", false).css('background-color','#89ba73');
            }else{
                $("#forwardChosen").html("<span><cf_get_lang dictionary_id='62334.En fazla 5 mesaj seçebilirsiniz'></span>");
                $(".forward_btn").prop("disabled", true).css('background-color','#b3d0a6');
            }

        });

        $("ul.forwardList li").click(function() {
            $(this).find("input[type=checkbox]").prop("checked", $(this).find("input[type=checkbox]").is(":checked") ? false : true );
            var forwardPersonCount = $("form[name = messageForwardForm] input[name = multimessage]:checked").length;
            if( forwardPersonCount <= 10 ){
                $(this).find('.userIcon').toggle();
                $(this).find('.acceptance').toggle();
                if( forwardPersonCount > 0 ){
                    $("#messageForwardButton").prop("disabled",false);
                    $("#forwardPerson").html("<span>" + forwardMessages.length + " <cf_get_lang dictionary_id='57543.Mesaj'> " + forwardPersonCount + " <cf_get_lang dictionary_id='62206.Kişiye gönderilecek'></span>");
                }else{
                    $("#messageForwardButton").prop("disabled",true);
                    $("#forwardPerson").html("");
                }
            }else{
                alert("<cf_get_lang dictionary_id='62333.En fazla 10 kişi seçebilirsiniz'>!");
                $(this).find("input[type=checkbox]").prop("checked", $(this).find("input[type=checkbox]").is(":checked") ? false : true );
            }
        });

        function forward() {
            $('#forward_modal').show();
        }

        $("form[name = messageForwardForm]").submit(function() {
            
            const message_id = [];

            $("input[name = bubble_checkbox]:checked").each(function(){ message_id.push( $(this).val() ) });

            let data = new FormData();
            data.append('message_id', message_id.join(','));
            AjaxControlPostDataJson( "V16/objects/cfc/messages.cfc?method=getMessageById", data, function(response) {
                if (response.length) {
                    window.multi_message_show = true;
                    response.forEach(msg => {

                        if ( msg.MESSAGE_FILE == 1 ) {//Dosya iletildiyse
                            
                            window.messageFiles.push({
                                fileName: msg.MESSAGE_FILE_NAME,
                                encryptedName: msg.MESSAGE_FILE_ENCRYPTED_NAME,
                                fullfileName: msg.MESSAGE_FILE_FULL_NAME,
                                fullEncryptedName: msg.MESSAGE_FILE_ENCRYPTED_FULL_NAME,
                                ext: msg.MESSAGE_FILE_EXTENTION,
                                fileSize: msg.MESSAGE_FILE_SIZE,
                                mimeType: msg.MESSAGE_FILE_MIME_TYPE
                            });

                            sender( true );

                        } else sender( true, false, msg.MESSAGE );

                    });
                }

                forwardCancel();

            });
            
            return false;
        });

        /* forward process */

        $("form[name = messageFileForm]").submit(function(){
            sender( false, false, '', <cfoutput>#len( attributes.group_id ) ? attributes.group_id : "''"#</cfoutput>, <cfoutput>#visitor#</cfoutput> );
            return false;
        });

        function sendButtonManagement(){

            var messageText = $.trim($("#text_area").val()),
                fileMessage = $.trim($("#fileMessage").val());

            if( messageText != "" || fileMessage != '' || window.messageFiles.length > 0 ){

                $(".send_btn, #messageFileUploadButton").attr('disabled',false);
                $(".send_btn").css('background-color','#89ba73');
                
                if( messageText != "" || fileMessage != "" ){
                    $("#text_area, #fileMessage").keypress(function (e) {
                        
                        if(e.which == 13 && !e.shiftKey) {     
                            sender( false, false, '', <cfoutput>#len( attributes.group_id ) ? attributes.group_id : "''"#</cfoutput>, <cfoutput>#visitor#</cfoutput> );
                            e.preventDefault();
                            return false;
                        }
                    });
                } 

                if( window.messageFiles.length > 0 ) $("#messages-body").css({ "height" : "calc(100% - (110px))" });
                else $("#messages-body").css({ "height" : "calc(100% - (60px))" });

            }else{
                
                $(".send_btn, #messageFileUploadButton").attr('disabled',true); 
                $(".send_btn").css('background-color','#b3d0a6');

            }

        }
        
        $('#open_img').click(function(){
            $('#upload_modal').show();
            $('#upload_modal .portHeadLightTitle span a').text("İmaj Ekle");
        });
        $('#open_fld').click(function(){
            $('#upload_modal').show();
            $('#upload_modal .portHeadLightTitle span a').text("Belge Ekle");
        });
        $('.catalystClose').click(function(){
            $('#upload_modal, #forward_modal, #room_modal').hide();
        });

        $('.send_btn').click(function(){
            $('#text_area').css("height","auto");
        });

        $("#text_area").keypress(function (e) {
            if(e.which == 13) {     
                $('#text_area').css("height","auto");
            }
        });

        $("#message_area").on("keyup keydown","#text_area",function(event){
            sendButtonManagement();
        });

        $("form[name = messageFileForm]").on("keyup keydown","#fileMessage",function(event){
            sendButtonManagement();
        });

        $(function(){
            $("#all_messages div.bubble").each(function(){
                var message = $(this).find("span").text();
                $(this).find("span").html(convert(message));
            });

            $('#all_messages').delegate(".bubble .message_option > ul > li > a", "click", function(){
                $('.bubble .message_option > ul > li > ul').stop().fadeOut();
                $(this).parent().find("> ul").stop().fadeToggle();
            });
            setTimeout(() => { goBottom('all_messages'); }, 1);
        });

        <cfoutput>setWarningCounts( #totalMessageCount#, window.warningCounter.warningCounter, 'ChatFlow' );</cfoutput>

    </script>

</cfif>