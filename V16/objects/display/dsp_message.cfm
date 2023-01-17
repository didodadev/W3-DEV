<cfparam  name="attributes.employee_id" default="" />
<cfparam  name="attributes.group_id" default="" />
<cfparam  name="attributes.enc_key" default="" />
<cfparam  name="attributes.action_wo" default="" />
<cfparam  name="attributes.action_wo_event" default="" />
<cfparam  name="attributes.action_parameter" default="" />
<cfparam  name="attributes.action_id" default="" />

<cfset startrow = 1 >
<cfset attributes.maxrows ="#session.ep.maxrows#">
<cfset upload_folder = application.systemParam.systemParam().upload_folder>
<cfset server_machine_list = application.systemParam.systemParam().fusebox.server_machine_list>
<cfset messageMode = "" /> <!--- emp, group --->

<cfset get_messages = createObject("Component","V16.objects.cfc.messages") />
<cfset message_group = createObject("Component","V16.objects.cfc.message_group") />
<cfset chatflow_visitors = createObject("Component","V16.objects.cfc.chatflow_visitors") />

<cfset GET_WRK_EP_APPS = get_messages.GET_WRK_EP_APPS()>
<cfset GET_EMPLOYEES = get_messages.GET_EMPLOYEES()>
<cfset GET_ONLINE_USER = get_messages.ONLINE_USER_INTRANET()>
<cfset USER_DATA = deserializeJSON(GET_EMPLOYEES)>
<cfset ONLINE_USER_DATA = deserializeJSON(GET_ONLINE_USER)>

<cfif len(attributes.action_wo) and len(attributes.action_wo_event) and len(attributes.action_parameter) and len(attributes.action_id)>
    <cfset getMessageGroup = message_group.getMessageGroup(
        wr_action_wo: attributes.action_wo,
        wr_action_wo_event: attributes.action_wo_event,
        wr_action_parameter: attributes.action_parameter,
        wr_action_id: attributes.action_id,
        wg_new: true
    ) />
    <cfset attributes.group_id = getMessageGroup.recordcount ? getMessageGroup.WG_ID : "" />
    <cfset messageMode = 'group' />
<cfelse>
    <cfset getMessageGroup.recordcount = 0 />
    <cfset messageMode = 'emp' />
</cfif>

<div class="container scrollbar" id="mainborder" style="height:100%;">
    <div style="height:100%;">
        <div class="person-list col col-4 col-md-5 col-sm-5 col-xs-12">
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12 person-list-header">
                <div class="person-list-header-font topButtonsDiv">
                    <!--- <i class="fa fa-remove" id="CloseConnect"></i> --->
                    <h4><cfoutput>#getLang("objects","176","Hızlı Mesajlar")#</cfoutput></h4>
                    <ul>
                        <li class="dropdown topIcon"><i title="<cfoutput>#getLang("objects","176","Hızlı Mesajlar")#</cfoutput>" class="catalyst-bubble" onclick="getWindow(2, this)"></i></li>
                        <li class="dropdown topIcon"><i title="<cf_get_lang dictionary_id='32716.Gruplar'>" class="catalyst-bubbles" onclick="getWindow(4, this)"></i></li>
                        <li class="dropdown topIcon"><i title="<cfoutput>#getLang("member","24","Çevrimiçi")# #getLang("main","1580","Kullanıcılar")#</cfoutput>" class="fa fa-smile-o" onclick="getWindow(1, this)"></i></li>
                        <li class="dropdown topIcon"><i title="<cfoutput>#getLang("main","1580","Kullanıcılar")#</cfoutput>" class="catalyst-user" onclick="getWindow(3, this)"></i></li>
                        <li class="dropdown topIcon"><i title="<cfoutput>#getLang("","Ziyaretçiler",62149)#</cfoutput>" class="catalyst-users" onclick="getWindow(5, this)"></i></li>
                    </ul>
                </div>
            </div>
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12 message_user_list" id="LastMsgList" style="height:calc(100% - (50px)) !important;<cfif attributes.subtab neq 2>display:none;</cfif>"> <!--- Son Mesajlar --->
                <div class="col col-11 rightButtonsDiv">
                    <input type="text" class="main-input main-name" name="keyword" placeholder="<cf_get_lang dictionary_id='29831.Kişi'> <cf_get_lang dictionary_id='57998.Yada'> <cf_get_lang dictionary_id='57543.Mesaj'> <cf_get_lang dictionary_id='57565.Ara'>">
                </div>
                <div class="col col-1 rightButtonsDiv">
                    <ul>
                        <li><i style="color:#41ad49" onclick="multi_message_display();" class="catalyst-note" title="<cfoutput>#getLang("objects","186","Toplu Mesaj")#</cfoutput>"></i></li>
                    </ul>
                </div>
                <div class="col col-12 scrollbar" style="height:calc(100% - (50px)) !important;overflow:scroll;padding:0;">
                    <ul class="lightList agendaDayTime- text-left">
                        <cfset i = 0 >
                        <cfoutput query="get_wrk_ep_apps">
                            <cfquery name = "count_message" datasource = "#DSN#" >
                                SELECT COUNT(WRK_MESSAGE_ID) AS M_COUNT FROM WRK_MESSAGE WHERE RECEIVER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND SENDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#EMPLOYEE_ID#"> AND IS_ALERTED IS NULL
                            </cfquery>
                            <li data-id="#EMPLOYEE_ID#">
                                <div class="ContentRow col col-12 col-md-12 col-sm-12 col-xs-12">
                                    <a href="javascript://" onclick="get_all_messages(#EMPLOYEE_ID#);<cfif count_message.M_COUNT gte 1>countm(#i#);</cfif>">
                                        <div>
                                        <cfif len(PHOTO) and DirectoryExists("#upload_folder#hr/#photo#")>
                                            <img src="#upload_folder#hr/#photo#" width="40" height="40" class="img-circle" style="float:left">
                                        <cfelse>
                                            <span class="avatextCt color-#Left(EMPLOYEE_NAME, 1)#">
                                                <small class="avatext">#Left(EMPLOYEE_NAME, 1)##Left(EMPLOYEE_SURNAME, 1)#</small>
                                            </span>
                                        </cfif>
                                        <span class="UpRow">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</span>
                                        <span class="RightUpRow">#dateformat(SENDDATE,dateformat_style)# - #timeformat(SENDDATE,timeformat_style)#</span><br>                                                               
                                        <span class="DownRow">#left(LASTMESSAGE,40)#<cfif len(LASTMESSAGE) gt 40 >... </cfif></span>
                                        </div>
                                    </a>
                                    <input title="+ #EMPLOYEE_NAME# #EMPLOYEE_SURNAME#" class="pull-right checkbox" style="display:none" type="checkbox" name="multimessage" value="#EMPLOYEE_ID#" >
                                    <cfif #count_message.m_count#>
                                        <span id="countm_badge#i#" class="countm_badge badge">#count_message.m_count#</span>
                                    </cfif>
                                </div> 
                            </li>
                            <cfset i = i+1>
                        </cfoutput>
                    </ul>
                </div>
            </div>
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12 message_user_list" id="groupMsgList" style="height:calc(100% - (50px)) !important;<cfif attributes.subtab neq 3>display:none;</cfif>"> <!--- Gruplar --->
                <div class="col col-12 rightButtonsDiv">
                    <input type="text" class="main-input main-name" name="searchOnGroup" placeholder="<cf_get_lang dictionary_id='62264.Grup Ara'>">
                </div>
                <div class="col col-12 scrollbar" style="height:calc(100% - (50px)) !important;overflow:scroll;padding:0;">
                    <ul class="lightList agendaDayTime- text-left">
                        <cfset i = 0 >
                        <cfset getAllMessageGroup = message_group.getMessageGroup() />
                        <cfif getAllMessageGroup.recordcount>
                            <cfoutput query="getAllMessageGroup">
                                <cfquery name = "count_message" datasource = "#DSN#">
                                    SELECT COUNT(WM.WRK_MESSAGE_ID) AS M_COUNT FROM WRK_MESSAGE AS WM LEFT JOIN WRK_MESSAGE_GROUP_EMP_MSG AS WGEM ON WM.WRK_MESSAGE_ID = WGEM.WRK_MESSAGE_ID WHERE WGEM.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND WGEM.WG_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#WG_ID#"> AND WGEM.IS_ALERTED <> 1
                                </cfquery>
                                <li data-id="#WG_ID#">
                                    <div class="ContentRow col col-12 col-md-12 col-sm-12 col-xs-12">
                                        <a href="javascript://" onclick="get_all_messages('', #WG_ID#);<cfif count_message.M_COUNT gte 1>countm(#i#);</cfif>">
                                            <div>
                                                <span class="avatextCt color-#Left(WG_NAME, 1)#">
                                                    <small class="avatext">#Left(WG_NAME, 1)#</small>
                                                </span>
                                                <span class="UpRow">#WG_NAME#</span>
                                                <span class="RightUpRow">#dateformat(SENDDATE,dateformat_style)# - #timeformat(SENDDATE,timeformat_style)#</span><br>
                                                <span class="DownRow">#left(LASTMESSAGE,40)#<cfif len(LASTMESSAGE) gt 40 >... </cfif></span>
                                            </div>
                                        </a>
                                        <input title="+ #WG_NAME#" class="pull-right checkbox" style="display:none" type="checkbox" name="groupmessage" value="#WG_ID#" >
                                        <cfif #count_message.m_count#>
                                            <span id="countm_badge#i#" class="countm_badge badge">#count_message.m_count#</span>
                                        </cfif>
                                    </div> 
                                </li>
                                <cfset i = i+1>
                            </cfoutput>
                        </cfif>
                    </ul>
                </div>
            </div>
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12 message_user_list" id="onlineUserList" style="height:calc(100% - (50px)) !important;<cfif attributes.subtab neq 1>display:none;</cfif>"> <!--- Online Kullanıcılar --->
                <div class="col col-12 rightButtonsDiv">
                    <input type="text" class="main-input main-name" name="searchOnUser" placeholder="<cf_get_lang dictionary_id='29831.Kişi'> <cf_get_lang dictionary_id='57565.Ara'>">
                </div>
                <div class="col col-12 scrollbar" style="height:calc(100% - (50px)) !important;overflow:auto;padding:0;">
                    <ul class="OnlineuserListLeft agendaDayTime- text-left">
                        <cfloop from="1" to="#structCount(ONLINE_USER_DATA.DATA)#" index="i">
                            <li data-id="<cfoutput>#ONLINE_USER_DATA["DATA"][i]["USERID"]#</cfoutput>">
                                <div class="ContentRow col col-12 col-md-12 col-sm-12 col-xs-12">
                                    <div class="usersListLeft">
                                        <cfif len(ONLINE_USER_DATA["DATA"][i]["PHOTO"]) and FileExists("#upload_folder#hr\#ONLINE_USER_DATA["DATA"][i]["PHOTO"]#")>
                                            <img src="<cfoutput>#server_machine_list#/documents/hr/#ONLINE_USER_DATA["DATA"][i]["PHOTO"]#</cfoutput>" width="40" height="40" class="img-circle" style="float:left">
                                        <cfelse>
                                            <span class="avatextCt color-<cfoutput>#Left(ONLINE_USER_DATA["DATA"][i]['KULLANICI'], 1)#</cfoutput>">
                                                <small class="avatext"><cfoutput>#Left(ONLINE_USER_DATA["DATA"][i]['KULLANICI'], 1)##Left(ONLINE_USER_DATA["DATA"][i]['SURNAME'], 1)#</cfoutput></small>
                                            </span>
                                        </cfif>
                                    </div>
                                    <div class="usersListRight">
                                        <span class="UpRow"><cfoutput>#ONLINE_USER_DATA["DATA"][i]["KULLANICI"]#</cfoutput></span>
                                        <span class="RightUpRow"><i class="fa fa-comment fa-lg" title="<cf_get_lang dictionary_id='29696.Mesaj Gönder'>" onclick="get_all_messages(<cfoutput>#ONLINE_USER_DATA["DATA"][i]["USERID"]#</cfoutput>);"></i></span>
                                        <br>                                                               
                                        <span class="DownRowOnline">
                                            <cfoutput>#ONLINE_USER_DATA["DATA"][i]["POSITION_NAME"]#</cfoutput>
                                        </span>
                                        <br>
                                        <cfloop from="1" to="#arrayLen(ONLINE_USER_DATA["DATA"][i]["FUSEACTION"])#" index="j">
                                            <div class="user-login-group">
                                                <span class="DownRowOnline">
                                                    <cfif ONLINE_USER_DATA["DATA"][i]["FUSEACTION"][j]["ACTION_PAGE"] contains 'Android'>
                                                        <i class="fa fa-android" style="color:#4CAF50"></i> 
                                                    <cfelseif ONLINE_USER_DATA["DATA"][i]["FUSEACTION"][j]["ACTION_PAGE"] contains 'iphone' or ONLINE_USER_DATA["DATA"][i]["FUSEACTION"][j]["ACTION_PAGE"] contains 'Safari'>
                                                        <i class="fa fa-apple" style="color:#607D8B"></i> 
                                                    <cfelse>
                                                        <i class="fa fa-desktop" style="color:#03A9F4"></i> 
                                                    </cfif>
                                                    <cfoutput>
                                                        <cfif session.ep.admin> #ONLINE_USER_DATA["DATA"][i]["FUSEACTION"][j]["USER_IP"]# - </cfif> #timeFormat(date_add('h',session.ep.time_zone,ONLINE_USER_DATA["DATA"][i]["FUSEACTION"][j]["ACTION_DATE"]),timeformat_style)#-#dateFormat(ONLINE_USER_DATA["DATA"][i]["FUSEACTION"][j]["ACTION_DATE"],dateformat_style)#
                                                    </cfoutput>
                                                </span>
                                                <cfif session.ep.admin>
                                                <br>
                                                <span class="DownRowOnline">
                                                    <i class="fa fa-cube" style="color:#555555"></i>
                                                    <cfoutput>#listFirst(ONLINE_USER_DATA["DATA"][i]["FUSEACTION"][j]["ACTION_PAGE"],"&")#</cfoutput>
                                                    <cfif get_module_power_user(7) and not listfindnocase(denied_pages,'home.act_ban')>
                                                        <div class="pull-right">
                                                            <a href="javascript://" onclick="kickPerson('<cfoutput>#ONLINE_USER_DATA["DATA"][i]["USERID"]#</cfoutput>','<cfoutput>#ONLINE_USER_DATA["DATA"][i]["USER_TYPE"]#</cfoutput>','<cfoutput>#ONLINE_USER_DATA["DATA"][i]["FUSEACTION"][j]["SESSIONID"]#</cfoutput>',this)"><i class="fa fa-trash" style="color:#9E9E9E" title="<cfoutput>#getLang('objects',531)#</cfoutput>"></i></a>
                                                        </div>
                                                    </cfif>
                                                </span>
                                                </cfif>
                                                <br>
                                            </div>
                                        </cfloop>
                                    </div>
                                </div>
                            </li>
                        </cfloop>          
                    </ul>          
                </div>
            </div>
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12 message_user_list" id="userListLeft" style="height:calc(100% - (45px)) !important;display:none;"> <!--- Tüm Kullanıcılar --->
                <div class="col col-12 rightButtonsDiv">
                    <input type="text" class="main-input main-name" name="searchEmp" placeholder="<cf_get_lang dictionary_id='29831.Kişi'> <cf_get_lang dictionary_id='57565.Ara'>">
                </div>
                <div class="col col-12 scrollbar scrltp" style="height:calc(100% - (50px)) !important;overflow:auto;padding:0;">
                        <cfform>
                            <cfinput type="hidden" name="startrow" value="#arrayLen(USER_DATA.DATA)#">
                            <cfinput type="hidden" name="maxrows" value="#session.ep.maxrows#">
                        </cfform>
                    <ul class="userListLeft agendaDayTime- text-left">
                        <cfloop from="1" to="#arrayLen(USER_DATA.DATA)#" index="i">
                            <li data-id="<cfoutput>#USER_DATA.DATA[i]["EMPLOYEE_ID"]#</cfoutput>">
                                <div class="ContentRow col col-12 col-md-12 col-sm-12 col-xs-12">
                                    <cfif len(USER_DATA.DATA[i]["PHOTO"]) and DirectoryExists("#upload_folder#hr/#USER_DATA.DATA[i]["PHOTO"]#")>
                                        <img src="<cfoutput>#upload_folder#hr/#USER_DATA.DATA[i]["PHOTO"]#</cfoutput>" width="40" height="40" class="img-circle" style="float:left">
                                    <cfelse>
                                        <span class="avatextCt color-<cfoutput>#Left(USER_DATA.DATA[i]['EMPLOYEE_NAME'], 1)#</cfoutput>">
                                            <small class="avatext"><cfoutput>#Left(USER_DATA.DATA[i]['EMPLOYEE_NAME'], 1)##Left(USER_DATA.DATA[i]['EMPLOYEE_SURNAME'], 1)#</cfoutput></small>
                                        </span>
                                    </cfif>
                                    <span class="UpRow"><cfoutput>#USER_DATA.DATA[i]["EMPLOYEE_NAME"]# #USER_DATA.DATA[i]["EMPLOYEE_SURNAME"]#</cfoutput></span>
                                    <span class="RightUpRow"><i class="fa fa-comment fa-lg" title="<cf_get_lang dictionary_id='29696.Mesaj Gönder'>" onclick="get_all_messages(<cfoutput>#USER_DATA.DATA[i]["EMPLOYEE_ID"]#</cfoutput>);"></i></span>
                                    <br>                                                               
                                    <span class="DownRow">
                                        <cfoutput>#USER_DATA.DATA[i]["POSITION_NAME"]#</cfoutput>
                                    </span>
                                </div>
                            </li>
                        </cfloop>          
                    </ul>          
                </div>
            </div>
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12 message_user_list" id="visitorMsgList" style="height:calc(100% - (50px)) !important;<cfif attributes.subtab neq 4>display:none;</cfif>"> <!--- Ziyaretçi Mesajları --->
                <div class="col col-12 rightButtonsDiv">
                    <input type="text" class="main-input main-name" name="keyword" placeholder="<cf_get_lang dictionary_id='29831.Kişi'> <cf_get_lang dictionary_id='57998.Yada'> <cf_get_lang dictionary_id='57543.Mesaj'> <cf_get_lang dictionary_id='57565.Ara'>">
                </div>
                <div class="col col-12 scrollbar" style="height:calc(100% - (50px)) !important;overflow:scroll;padding:0;">
                    <ul class="lightList agendaDayTime- text-left">
                        
                        <cfset get_visitors_message = chatflow_visitors.get_visitors_message()>
                        
                        <cfif get_visitors_message.recordcount>
                            <cfoutput query="get_visitors_message">
                                <cfquery name = "count_message" datasource = "#DSN#">
                                    SELECT COUNT(WRK_MESSAGE_ID) AS M_COUNT FROM WRK_MESSAGE WHERE RECEIVER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND ENC_KEY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#ENC_KEY#"> AND IS_ALERTED IS NULL
                                </cfquery>
                                <li data-id="#ENC_KEY#">
                                    <div class="ContentRow col col-12 col-md-12 col-sm-12 col-xs-12">
                                        <a href="javascript://" onclick="get_all_messages('','','#ENC_KEY#');<cfif count_message.M_COUNT gte 1>countm(#currentrow#);</cfif>">
                                            <div>
                                            <span class="avatextCt color-#Left(VISITOR_NAME, 1)#">
                                                <small class="avatext">#Left(VISITOR_NAME, 1)##Left(VISITOR_SURNAME, 1)#</small>
                                            </span>
                                            <span class="UpRow">#VISITOR_NAME# #VISITOR_SURNAME#</span>
                                            <span class="RightUpRow">#dateformat(SENDDATE,dateformat_style)# - #timeformat(SENDDATE,timeformat_style)#</span><br>                                                               
                                            <span class="DownRow">#left(LASTMESSAGE,40)#<cfif len(LASTMESSAGE) gt 40 >... </cfif></span>
                                            </div>
                                        </a>
                                        <input title="+ #VISITOR_NAME# #VISITOR_SURNAME#" class="pull-right checkbox" style="display:none" type="checkbox" name="visitormessage" value="#ENC_KEY#" >
                                        <cfif #count_message.m_count#>
                                            <span id="countm_badge#currentrow#" class="countm_badge badge">#count_message.m_count#</span>
                                        </cfif>
                                    </div> 
                                </li>
                            </cfoutput>
                        </cfif>
                    </ul>
                </div>
            </div>
        </div>
        <div class="col col-8 col-md-7 col-sm-7 col-xs-12 scrollbar" id="get_all_right_message">
            <cfif messageMode eq 'group' and getMessageGroup.recordcount eq 0>
                <cfset getUserGroup = message_group.getUserGroup( wr_action_wo: attributes.action_wo, wr_action_id: attributes.action_id ) />
                <div style="min-width:40%;margin-left:0px;" class="ui-cfmodal" id="room_modal">
                    <div class="boxRow">
                        <div class="portBox portBottom">
                            <div class="portHeadLight">
                                <div class="portHeadLightTitle">
                                    <span>
                                        <a><cf_get_lang dictionary_id='62253.Chatflow odası oluştur'></a>
                                    </span>
                                </div>
                                <div class="portHeadLightMenu">
                                    <ul>
                                        <li><a href="javascript://" class="catalystClose">×</a></li>
                                    </ul>
                                </div>
                            </div>
                            <div class="portBoxBodyStandart">
                                <cfset last_box_id = 1/>
                                <div style="width:100%;">
                                    <cfform method="post" name="roomForm">
                                        <cfinput type="hidden" name="wg_action_wo" id="wg_action_wo" value="#attributes.action_wo#">
                                        <cfinput type="hidden" name="wg_action_wo_event" id="wg_action_wo_event" value="#attributes.action_wo_event#">
                                        <cfinput type="hidden" name="wg_action_parameter" id="wg_action_parameter" value="#attributes.action_parameter#">
                                        <cfinput type="hidden" name="wg_action_id" id="wg_action_id" value="#attributes.action_id#">
                                        <div class="col col-12">
                                            <cf_box_elements vertical="1">
                                                <div class="form-group">
                                                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Odaya isim ver *</label>
                                                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12 pdn-r-0">
                                                        <input type="text" name="wg_name" id="wg_name" required>
                                                    </div>
                                                </div>
                                                <div class="col col-12 col-md-12 col-sm-12 col-xs-12 message_user_list" style="height:calc(100% - (50px)) !important;"> <!--- Son Mesajlar --->
                                                    <!--- <div class="col col-12 rightButtonsDiv">
                                                        <input type="text" class="main-input main-name" name="keyword" placeholder="<cf_get_lang dictionary_id='29831.Kişi'> <cf_get_lang dictionary_id='57565.Ara'>">
                                                    </div> --->
                                                    <div class="col col-12 scrollbar" style="height:300px !important;overflow-y:scroll;padding:0;">
                                                        <ul class="lightList agendaDayTime- text-left userGroupList">
                                                            <cfif getUserGroup.recordcount>
                                                                <cfoutput query="getUserGroup">
                                                                    <li data-id="#EMPLOYEE_ID#">
                                                                        <div class="ContentRow col col-12 col-md-12 col-sm-12 col-xs-12">
                                                                            <a href="javascript://">
                                                                                <div>
                                                                                    <cfif len(PHOTO) and DirectoryExists("#upload_folder#hr/#PHOTO#")>
                                                                                        <img src="#upload_folder#hr/#PHOTO#" width="40" height="40" class="img-circle userIcon" style="float:left">
                                                                                    <cfelse>
                                                                                        <span class="avatextCt color-#Left(EMPLOYEE_NAME, 1)# userIcon">
                                                                                            <small class="avatext">#Left(EMPLOYEE_NAME, 1)##Left(EMPLOYEE_SURNAME, 1)#</small>
                                                                                        </span>
                                                                                    </cfif>
                                                                                    <span class="acceptance"></span>
                                                                                    <div class="UpRow" style="padding-top:15px; margin-left:10%;">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</div>
                                                                                </div>
                                                                            </a>
                                                                            <input type="checkbox" name="group_user" value="#EMPLOYEE_ID#" style="display:none">
                                                                        </div> 
                                                                    </li>
                                                                </cfoutput>
                                                            </cfif>
                                                        </ul>
                                                    </div>
                                                </div>
                                            </cf_box_elements>
                                            <div class="col col-12">
                                                <div class="form-group col col-10 col-xs-8 forward_panel" id="userGroupPerson">
                                                    <span><cf_get_lang dictionary_id='62262.Listeden en az bir kişi seçmelisiniz'>!</span>
                                                </div>
                                                <div class="form-group col col-2 col-xs-4 pdn-r-0">
                                                    <button type="submit" id="userGroupButton" class="ui-btn ui-btn-update" disabled><cf_get_lang dictionary_id='62283.Oda Ekle'></button>
                                                </div>
                                            </div>
                                        </div>
                                    </cfform>
                                </div>
                            </div>
                        </div>
                    </div>        
                </div>
            <cfelseif not len( attributes.employee_id ) and not len( attributes.group_id ) and not len( attributes.enc_key )>
                <div class="col col-12 col-sm-12 col-xs-12 message-body" id="messages-body">
                    <div class="col col-12 col-sm-12 col-xs-12 message-body" id="messages-body">
                        <div class="text_messages scrollbar col col-12">
                            <h3><cf_get_lang dictionary_id="31457.Konuşma başlatmak için bir kişi ya da grup seçin"></h3>
                        </div>
                    </div>
                </div>
            </cfif>
        </div>
    </div>
</div>

<script type="text/javascript" src="/JS/fileupload/dropzone.min.js"></script>
<script type="text/javascript" src="/JS/assets/message/messages.js"></script>
<script>
   
    if($(window).width() < 680) $(".person-list").show().css({"z-index" : "22"}); //show();

    <cfif len(attributes.employee_id) or len(attributes.group_id) or len( attributes.enc_key )>
        get_all_messages(<cfoutput>#len(attributes.employee_id) ? attributes.employee_id : "''"#</cfoutput>, <cfoutput>#len(attributes.group_id) ? attributes.group_id : "''"#</cfoutput>, '<cfoutput>#len(attributes.enc_key) ? attributes.enc_key : ''#</cfoutput>');
    </cfif>

    <cfif attributes.subtab eq 1>
        $(".topButtonsDiv i.fa-smile-o").parent().css("background-color","rgb(214, 214, 214)");
        $("div.topButtonsDiv h4").html("<cfoutput>#getLang("member","24","Çevrimiçi")# #getLang("main","1580","Kullanıcılar")#</cfoutput>");
        window.activeWindow = 1;
    <cfelseif attributes.subtab eq 2>
        $(".topButtonsDiv i.catalyst-bubble").parent().css("background-color","rgb(214, 214, 214)");
        $("div.topButtonsDiv h4").html("<cfoutput>#getLang("objects","176","Hızlı Mesajlar")#</cfoutput>");
        window.activeWindow = 2;
    <cfelseif attributes.subtab eq 3>
        $(".topButtonsDiv i.catalyst-bubbles").parent().css("background-color","rgb(214, 214, 214)");
        $("div.topButtonsDiv h4").html("<cf_get_lang dictionary_id='32716.Gruplar'>");
        window.activeWindow = 4;
    </cfif>

    function get_all_messages(employee_id = "", group_id = "", enc_key = ""){
        
        window.messagepageid = "";
        window.messageGroupid = "";
        window.messageGroupEmpid = [];
        window.messageEncKey = "";
        
        if(employee_id != ''){
            
            window.messagepageid = employee_id;
            $("#LastMsgList ul.lightList li[data-id = " + employee_id + "] input[ type = checkbox ]").next('span').remove();
            AjaxPageLoad('V16/objects/display/dsp_all_message.cfm?&employee_id='+employee_id, 'get_all_right_message');
            if($(window).width() < 769) $(".person-list").css({"display":"none"});
        
        }else if( group_id != '' ){
            
            window.messageGroupid = group_id;
            var data = new FormData();
            data.append('wg_id', group_id);
            AjaxControlPostDataJson( "V16/objects/cfc/message_group.cfc?method=getMessageGroupEmp", data, function(response){
                if( response.length > 0 ){
                    response.forEach(element => {
                        window.messageGroupEmpid.push( element.EMPLOYEE_ID );
                    });
                    AjaxPageLoad('V16/objects/display/dsp_all_message.cfm?&group_id='+group_id, 'get_all_right_message');
                    if($(window).width() < 769) $(".person-list").css({"display":"none"});
                    $("#groupMsgList ul.lightList li[data-id = " + group_id + "] input[ type = checkbox ]").next('span').remove();
                }
            });

        }else if( enc_key != '' ){
            
            window.messageEncKey = enc_key;
            $("#visitorMsgList ul.lightList li[data-id = " + enc_key + "] input[ type = checkbox ]").next('span').remove();
            AjaxPageLoad('V16/objects/display/dsp_all_message.cfm?&enc_key='+enc_key, 'get_all_right_message');
            if($(window).width() < 769) $(".person-list").css({"display":"none"});

        }
    }

    function getWindow(id, el){
        /* id=> 1 Çevrimiçi kullanıcılar, id=> 2 Hızlı Mesajlar, id=> 3 Tüm Kullanıcılar, id=> 4 Süreç Mesajları */
        $(".person-list-header-font li").css("background-color","#ececec");
        $(el).parent().css("background-color","#d6d6d6");
        if(id == 1){
            $('#onlineUserList').show(); 
            $('#userListLeft, #groupMsgList, #LastMsgListİ #visitorMsgList').hide();
            $("div.topButtonsDiv h4").html("<cfoutput>#getLang("member","24","Çevrimiçi")# #getLang("main","1580","Kullanıcılar")#</cfoutput>");
            window.activeWindow = 1;
        }else if(id == 2){
            $('#LastMsgList').show(); 
            $('#onlineUserList, #groupMsgList, #userListLeft, #visitorMsgList').hide();
            $("div.topButtonsDiv h4").html("<cfoutput>#getLang("objects","176","Hızlı Mesajlar")#</cfoutput>");
            window.activeWindow = 2;
        }else if(id == 3){
            $('#userListLeft').show(); 
            $('#onlineUserList, #groupMsgList, #LastMsgList').hide();
            $("div.topButtonsDiv h4").html("<cfoutput>#getLang("main","1580","Kullanıcılar")#</cfoutput>");
            window.activeWindow = 3;
        }else if(id == 4){
            $('#groupMsgList').show(); 
            $('#LastMsgList, #onlineUserList, #userListLeft, #visitorMsgList').hide();
            $("div.topButtonsDiv h4").html("<cf_get_lang dictionary_id='32716.Gruplar'>");
            window.activeWindow = 4;
        }else if(id == 5){
            $('#visitorMsgList').show(); 
            $('#LastMsgList, #groupMsgList, #onlineUserList, #userListLeft').hide();
            $("div.topButtonsDiv h4").html("<cf_get_lang dictionary_id='62149.Ziyaretçiler'>");
            window.activeWindow = 5;
        }
    }
    function dataTemplate(mode){ // Kullanıcılar İçin Gelen Veriyi Giydirme
        var startrow = $("input[name=startrow]").val();
        var maxrows = $("input[name=maxrows]").val();
        var searchEmp = $("input[name=searchEmp]").val();
        if(searchEmp.length > 0) { var parameters = "searchEmp="+searchEmp; }
        else { var parameters = "startrow="+startrow+"&maxrows="+maxrows; }
        /* $('.userListLeft').after('<img src="/css/assets/template/contes/loading.gif" id="tableLoading" class="tableLoading" style="width: 40px;margin: 25px auto;display: flex;align-items: center;">'); */
        $.ajax({
            type : 'POST',
            dataType : 'json',
            url : 'V16/objects/cfc/messages.cfc?method=GET_EMPLOYEES',
            data : parameters,
            success : function(result){
                if(result.STATUS) {
                    result.DATA.forEach((e) =>{
                        $('.tableLoading').remove(); 
                        $("<li>").attr({"data-id" : e.EMPLOYEE_ID}).append(
                            $("<div>").addClass("ContentRow col col-12 col-md-12 col-sm-12 col-xs-12").append(
                                /* (e.PHOTO.length) ? $("<img>").attr({
                                        "src" : '<cfoutput>#upload_folder#</cfoutput>hr/'+e.PHOTO,
                                        "width" : "40",
                                        "height" : "40",
                                        "style" : "float:left"
                                    }).addClass("img-circle") : */$("<span>").addClass("avatextCt color-"+e.EMPLOYEE_NAME.charAt(0)).append(
                                        $("<small>").addClass("avatext").html(e.EMPLOYEE_NAME.charAt(0)+e.EMPLOYEE_SURNAME.charAt(0))
                                            )
                            ).append(
                                $("<span>").addClass("UpRow").html(e.EMPLOYEE_NAME +' '+e.EMPLOYEE_SURNAME),
                                    $("<span>").addClass("RightUpRow").append(
                                        $("<i>").attr({
                                            "href" : "javascript://",
                                            "title" : "<cf_get_lang dictionary_id='29696.Mesaj Gönder'>",
                                            "onclick" : "get_all_messages("+e.EMPLOYEE_ID+")"
                                        }).addClass("fa fa-comment fa-lg")
                                    ),
                                    $("<br>"),
                                    $("<span>").addClass("DownRow").html(e.POSITION_NAME)
                            )
                        ).appendTo($(".userListLeft"));
                    });
                } else{
                    $('#tableLoading').remove();
                    if(mode == 0){
                        $(".userListLeft").html("<span style='margin:auto;vertical-align:middle;font-size:18px;'><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'></span>");   
                    }         
                }
            }
        })

    }

    $("input[name=keyword]").keyup(function(){ // Son Mesajlar İçerisinde Arama Yapıldığında
        valLen = $("input[name=keyword]").val();
        $('#LastMsgList ul.lightList').after('<img src="/css/assets/template/contes/loading.gif" id="tableLoading" style="width: 40px;margin: 25px auto;display: flex;align-items: center;">');
        $.ajax({
            type : 'POST',
            dataType : 'json',
            url : 'V16/objects/cfc/messages.cfc?method=getFilter',
            data : {search : valLen},
            success : function(result){
                $("#LastMsgList ul.lightList").html("");
                if(result.STATUS){
                    result.DATA.forEach((e) => {
                        var dats = new Date(e.SENDDATE);
                        var dates = dats.getDate() +"/"+ dats.getMonth() + "/" + dats.getFullYear() + " - " + dats.getUTCHours() + ":" + dats.getUTCMinutes()
                        
                        $('#tableLoading').remove();  
                        $("<li>").attr({"data-id" : e.EMPLOYEE_ID}).append(
                            $("<a>").attr({
                                    "href" : "javascript://",
                                    "onclick" : "get_all_messages("+e.EMPLOYEE_ID+")"
                            }).append(
                                $("<div>").addClass("ContentRow col col-12 col-md-12 col-sm-12 col-xs-12").append(
                                /* (e.PHOTO.length) ? $("<img>").attr({
                                        "src" : '<cfoutput>#upload_folder#</cfoutput>hr/'+e.PHOTO,
                                        "width" : "40",
                                        "height" : "40",
                                        "style" : "float:left"
                                    }).addClass("img-circle") : */$("<span>").addClass("avatextCt color-"+e.EMPLOYEE_NAME.charAt(0)).append(
                                                                $("<small>").addClass("avatext").html(e.EMPLOYEE_NAME.charAt(0)+e.EMPLOYEE_SURNAME.charAt(0))
                                                                )
                                ).append(
                                    $("<span>").addClass("UpRow").html(e.EMPLOYEE_NAME +' '+e.EMPLOYEE_SURNAME),
                                        $("<span>").addClass("RightUpRow").html(dates),
                                        $("<br>"),
                                        $("<span>").addClass("DownRow").html(e.LASTMESSAGE.substring(0,40)).append(
                                            $("<input>").attr({
                                                'title' : '+ '+e.EMPLOYEE_NAME+' '+e.EMPLOYEE_SURNAME, 
                                                'style' : 'display:none',
                                                'type'  : 'checkbox',
                                                'name'  : 'multimessage',
                                                'value' : e.EMPLOYEE_ID
                                            }).addClass("pull-right checkbox")
                                        )
                                )
                            )
                        ).appendTo($("#LastMsgList ul.lightList"));
                        //console.log(e);
                    })
                }else{
                    $('#tableLoading').remove();
                    $("#LastMsgList ul.lightList").html("<span style='margin:auto;vertical-align:middle;font-size:18px;'><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'></span>");  
                }
            }
        });
    });
    $("input[name=searchOnGroup]").keyup(function(){ // Son Mesajlar İçerisinde Arama Yapıldığında
        $('#groupMsgList .lightList').html('<img src="/css/assets/template/contes/loading.gif" id="tableLoading" style="width: 40px;margin: 25px auto;display: flex;align-items: center;">');
        var data = new FormData();
        data.append( 'wg_name', $("input[name=searchOnGroup]").val() );
        AjaxControlPostDataJson( "V16/objects/cfc/message_group.cfc?method=getMessageGroupFilter", data, function(response) {
            $("#groupMsgList .lightList").html("");
            $('#tableLoading').remove();

            if(response.STATUS){
                response.DATA.forEach((e) => {
                    $("<li>").attr({"data-id" : e.WG_ID}).append(
                        $("<a>").attr({ "href" : "javascript://", "onclick" : "get_all_messages(''," + e.WG_ID + ")"}).append(
                            $("<div>").addClass("ContentRow col col-12 col-md-12 col-sm-12 col-xs-12").append(
                                $("<span>").addClass("avatextCt color-"+e.WG_NAME.charAt(0)).append(
                                    $("<small>").addClass("avatext").html(e.WG_NAME.charAt(0))
                                ),
                                $("<span>").addClass("UpRow").html(e.WG_NAME)
                            )
                        ),
                        $("<span>").addClass("DownRow").append(
                            $("<input>").attr({
                                'title' : '+ ' + e.WG_NAME, 
                                'style' : 'display:none',
                                'type'  : 'checkbox',
                                'name'  : 'multimessage',
                                'value' : e.WG_ID
                            }).addClass("pull-right checkbox")
                        )
                    ).appendTo($("#groupMsgList .lightList"));
                });
            }else $("#groupMsgList .lightList").html("<span style='margin:auto;vertical-align:middle;font-size:18px;'><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'></span>");
        });
    });
    $("input[name=searchEmp]").keyup(function(){ // Kullanıcılar İçerisinde Arama Yapıldığında
        if( $.trim($("input[name=searchEmp]").val().length ) != 0 ){
            $("input[name=startrow]").val("1");
            $(".userListLeft").html("");
            dataTemplate(0);
        }else{
            $(".userListLeft").html("");
            $("input[name=startrow]").val("1");
            dataTemplate(0);
            $("input[name=startrow]").val(parseInt($("input[name=startrow]").val()) + <cfoutput>#session.ep.maxrows#</cfoutput>);
        }
    });
    $("input[name=searchOnUser]").keyup(function(){ // Online Kullanıcılar İçerisinde Arama Yapıldığında...
        var searchVal = $(this).val();
        $('.OnlineuserListLeft').after('<img src="/css/assets/template/contes/loading.gif" id="tableLoading" style="width: 40px;margin: 25px auto;display: flex;align-items: center;">');
        $.ajax({
            type : 'POST',
            dataType : 'json',
            url : 'V16/objects/cfc/messages.cfc?method=ONLINE_USER_INTRANET',
            data : {search : searchVal},
            success : function(result){
                $(".OnlineuserListLeft").html("");
                if(result.STATUS){
                    $('#tableLoading').remove();  
                    for(i=1; i<=result.TOTALCOUNT-1; i++){
                        $("<li>").attr({"data-id" : result["DATA"][i]["USERID"]}).append(
                            $("<div>").addClass("ContentRow col col-12 col-md-12 col-sm-12 col-xs-12").append(
                                $("<div>").addClass("usersListLeft").append(
                                    $("<span>").addClass("avatextCt color-"+result["DATA"][i]["KULLANICI"].charAt(0)).append(
                                        $("<small>").addClass("avatext").html(result["DATA"][i]["KULLANICI"].charAt(0)+result["DATA"][i]["SURNAME"].charAt(0))
                                    )
                                )
                            ).append(
                                $("<div>").addClass("usersListRight").append(
                                    $("<span>").addClass("UpRow").html(result["DATA"][i]["KULLANICI"]),
                                    $("<span>").addClass("RightUpRow").append(
                                        $("<i>").addClass("fa fa-comment fa-lg").attr({
                                                "title" : "<cf_get_lang dictionary_id='29696.Mesaj Gönder'>",
                                                "onclick" : "get_all_messages("+result["DATA"][i]["USERID"]+")"
                                            })
                                    ),
                                    $("<br>"),
                                    $("<span>").addClass("DownRowOnline").html(result["DATA"][i]["POSITION_NAME"])
                                )
                            )

                        ).appendTo($(".OnlineuserListLeft"));
                      
                        for(j=0; j<result["DATA"][i]["FUSEACTION"].length; j++){
                            var str = result["DATA"][i]["FUSEACTION"][j]["ACTION_PAGE"];
                            var res = str.split("&");
                            var icon = "";    
                            if(result["DATA"][i]["FUSEACTION"][j]["ACTION_PAGE"] == 'Android')
                                icon = $("<i>").addClass("fa fa-android").attr({ "style" : "color:#4CAF50;margin-right:3px;"})
                            else if(result["DATA"][i]["FUSEACTION"][j]["ACTION_PAGE"] == 'iphone' || result["DATA"][i]["FUSEACTION"][j]["ACTION_PAGE"] == 'Safari')
                                icon = $("<i>").addClass("fa fa-apple").attr({ "style" : "color:#607D8B;margin-right:3px;" })
                            else
                                icon = $("<i>").addClass("fa fa-desktop").attr({ "style" : "color:#03A9F4;margin-right:3px;" })

                            $("ul.OnlineuserListLeft > li:last-child div.usersListRight > span:last-child").after(
                                    $("<br>"),
                                    $("<span>").addClass("DownRowOnline").append(
                                       icon, <cfif session.ep.admin > result["DATA"][i]["FUSEACTION"][j]["USER_IP"] + " - " + </cfif> result["DATA"][i]["FUSEACTION"][j]["SESSION_DATE"]
                                    ),
                                    $("<br>"),
                                    $("<span>").addClass("DownRowOnline").append(
                                        <cfif session.ep.admin>
                                        $("<i>").addClass("fa fa-cube").attr({ "style" : "color:#555555;margin-right:3px;"}),
                                        res[0],
                                        </cfif>
                                        $("<div>").addClass("pull-right").append(
                                            $("<a>").attr({
                                                "href" : "javascript://",
                                                "onclick" : "kickPerson("+result["DATA"][i]["FUSEACTION"][j]["USERID"]+","+result["DATA"][i]["FUSEACTION"][j]["USER_TYPE"]+","+result["DATA"][i]["FUSEACTION"][j]["SESSIONID"]+",this)"
                                            }).append(
                                                $("<i>").addClass("fa fa-trash").attr({
                                                    "style" : "color:#9E9E9E",
                                                    "title" : "<cfoutput>#getLang('objects',531)#</cfoutput>>"
                                                })
                                            )
                                        )
                                    )
                            )
                        }
                    }
                }
                else{
                    $('#tableLoading').remove();
                    $(".OnlineuserListLeft").html("<span style='margin:auto;vertical-align:middle;font-size:18px;'><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'></span>");  
                }
            }

        });
    });
    $("input[name=searchOnProcess]").keyup(function(){ // Süreç Mesajlarında Arama Yapıldığında
        dataProcess();
    });
    $( "div.scrltp" ).scroll(function(){ // Kullanıcılar içerisinde Scroll İle Veri Yüklemek için
        
        if( $.trim($("input[name=searchEmp]").val().length ) == 0){
            
            var winScroll = Math.floor($(this).scrollTop());
            var height =  Math.floor($( "div.scrltp" )[0].scrollHeight-$( "div.scrltp" )[0].offsetHeight); 	
            if(winScroll == height){
                dataTemplate(1);	
                $("input[name=startrow]").val(parseInt($("input[name=startrow]").val()) + <cfoutput>#session.ep.maxrows#</cfoutput>);
            }
        }
    });

    var userGroupCount = 0;

    $("ul.userGroupList li").click(function() {
        $(this).find('.userIcon').toggle();
        $(this).find('.acceptance').toggle();
        $(this).find("input[type=checkbox]").prop( "checked", $(this).find("input[type=checkbox]").is(":checked") ? false : true );
        userGroupCount = $("form[name = roomForm] input[name = group_user]:checked").length;
        if( userGroupCount > 0 ){
            $("#userGroupButton").prop("disabled",false);
            $("#userGroupPerson").html("<span>" + userGroupCount + " <cf_get_lang dictionary_id='62259.Kişi seçildi'></span>");
        }else{
            $("#userGroupButton").prop("disabled",true);
            $("#userGroupPerson").html("<span><cf_get_lang dictionary_id='62262.Listeden en az bir kişi seçmelisiniz'>!</span>");
        }
    });

    $("form[name = roomForm]").submit(function( e ) {
        
        var self = $(this);
        var selfControl = false;

        if( userGroupCount > 0 ){
            let data = new FormData( $(e.currentTarget)[0] );
            AjaxControlPostDataJson( "V16/objects/cfc/message_group.cfc?method=addMessageGroup", data, function(response) {
                if( response.status ){
                    
                    self.find('input[name = group_user]:checked').each(function () {//Oluşturulan grupta kendisi var mı?
                        if( $(this).val() == <cfoutput>#session.ep.userid#</cfoutput> ) selfControl = true;
                    })

                    if( selfControl ){

                        alert("<cf_get_lang dictionary_id='62260.ChatFlow odası başarıyla oluşturuldu'>!");
                        
                        var groupName = $("#wg_name").val();

                        var date = new Date();
                        date = date.getDate() +"/"+ date.getMonth() + "/" + date.getFullYear() + " - " + date.getUTCHours() + ":" + date.getUTCMinutes();

                        //Mesajlarım listesinin en başına yeni mesajı oluşturur.
                        $("<li>").attr({"data-id" : "" + response.wg_id}).append(
                            $("<div>").addClass("ContentRow col col-12 col-md-12 col-sm-12 col-xs-12").append(
                                $("<a>").attr({ "href" : "javascript://", "onclick" : "get_all_messages('', "+response.wg_id+")" }).append(
                                    $("<div>").append(
                                        $("<span>").addClass("avatextCt color-"+groupName.charAt(0)).append( $("<small>").addClass("avatext").html( groupName.charAt(0) ) ),
                                        $("<span>").addClass("UpRow").text(groupName),
                                        $("<span>").addClass("RightUpRow").text(date),
                                        $("<br>"),
                                        $("<span>").addClass("DownRow").text('')
                                    )
                                ),
                                $("<input>").attr({ 'title' : '+ ' + groupName, 'style' : 'display:none', 'type'  : 'checkbox', 'name'  : 'groupmessage'}).val( response.wg_id ).addClass("pull-right checkbox")
                            )
                        ).prependTo($("#groupMsgList ul.lightList"));

                        get_all_messages('', response.wg_id);

                    }else{
                        alert("<cf_get_lang dictionary_id='62260.ChatFlow odası başarıyla oluşturuldu'>!\n<cf_get_lang dictionary_id='62284.Grup üyeleri arasına eklenmediğiniz için gruba dahil edilmediniz'>");
                        location.href = '<cfoutput>#request.self#?fuseaction=objects.workflowpages&tab=1&subtab=2</cfoutput>';
                    }

                }else{
                    alert("<cf_get_lang dictionary_id='62261.ChatFlow odası oluşturulurken bir sorun oluştu'>!");
                }
            });
        }else{
            alert("<cf_get_lang dictionary_id='62262.Listeden en az bir kişi seçmelisiniz'>!");
        }
        
        return false;
    });

    $('.catalystClose').click(function(){
        $('#room_modal').hide();
    });

    setWarningCounts( window.warningCounter.chatCounter, window.warningCounter.warningCounter, 'ChatFlow' );

</script>