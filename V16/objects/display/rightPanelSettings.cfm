<cfscript>
	getInfoTemp = createObject("component","cfc.right_menu_fnc");
	//getMyCompanies = getInfoTemp.GET_COMPANIES('#dsn#','#session.ep.position_code#');
</cfscript>
<cfswitch expression = "#attributes.systemType#">
    <cfcase value="dictionary">
    	<cfset get_lang = getInfoTemp.getLangs('#dsn#')>
        <form name="formDictionary" method="post" action="<cfoutput>#request.self#?fuseaction=myhome.emptypopup_settings_process&id=dictionary</cfoutput>">
            <div class="ui-form-list ui-form-block">
                <div class="form-group">
                    <select class="form-control" name="lang" id="lang" onchange="AjaxFormSubmit('formDictionary','show_language',1,'Güncelleniyor','Güncellendi','','',1);">
                        <cfoutput query="get_lang">
                            <option name="lang"  value="#get_lang.language_short#" <cfif language_short is session.ep.language>selected</cfif>>#get_lang.language_set#</option>
                        </cfoutput>
                    </select>
                </div>
            </div>
            <div id="show_language"></div>
		</form>
	</cfcase>
    <cfcase value="period">
        <cfinclude template="../../myhome/display/list_myaccounts.cfm">
    </cfcase>
    <cfcase value="userGroup">
    	<cfset GET_USER_GROUP = getInfoTemp.GET_USER_GROUP('#session.ep.position_code#')>
        <cfset GET_USER_GROUP_MENU = getInfoTemp.GET_USER_GROUP_MENU_INSIDE('#session.ep.userid#')>
        <cfset GET_ALL_POS_BY_USERID = getInfoTemp.GET_ALL_POS_BY_USERID(session.ep.userid)>
        <cfset menus = 0>
        <form name="formUserGroup" method="post" action="<cfoutput>#request.self#?fuseaction=myhome.emptypopup_settings_process&id=userGroup</cfoutput>">
            <div class="ui-form-list ui-form-block">
                <div class="form-group"> 
                    <label><cf_get_lang dictionary_id='55478.Rol'> - <cf_get_lang dictionary_id='58497.Pozisyon'></label>
                    <select name="mng_employee_positions" id="mng_employee_positions" class="form-control" onchange="getUserGroup(this)">
                        <cfoutput query="GET_ALL_POS_BY_USERID">
                            <option value="#POSITION_CODE#-#POSITION_NAME#" #session.ep.position_code eq POSITION_CODE ? 'selected' : ''#>#POSITION_NAME#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group">
                    <label><cf_get_lang dictionary_id='30350.Yetki Grubu'></label>
                    <select class="form-control" name="user_group" id="user_group" onchange="get_menus($(this));">
                        <cfoutput query="GET_USER_GROUP">
                            <option value="#user_group_id#" <cfif GET_USER_GROUP_MENU eq user_group_id>selected</cfif>>#USER_GROUP_NAME#</option>
                            <cfif GET_USER_GROUP_MENU eq user_group_id AND len(WRK_MENU)>
                                <cfset menus = "#WRK_MENU#">
                            </cfif>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group">
                    <cfset GET_WRK_MENU = getInfoTemp.GET_WRK_MENU(menu_id:menus)>
                    <label><cf_get_lang dictionary_id='33490.Sistem Menüleri'></label>
                    <select class="form-control" name="wrk_menu" id="wrk_menu">
                        <option value="0" <cfif session.ep.MENU_ID eq 0>selected</cfif>><cf_get_lang dictionary_id='57236.Standart'></option>
                        <cfif GET_WRK_MENU.recordcount AND menus neq 0>
                            <cfoutput query="GET_WRK_MENU">
                                <option value="#WRK_MENU_ID#" <cfif session.ep.MENU_ID eq WRK_MENU_ID>selected</cfif>>#WRK_MENU_NAME#</option>
                            </cfoutput>
                        </cfif>
                    </select>               
                </div>
                <div class="form-group">
                    <label><cf_get_lang dictionary_id='31077.Arayüz'></label>
                    <select class="form-control" name="interface" id="interface">
                        <option value="0" <cfif session.ep.design_id eq 0 and session.ep.design_id eq 4>selected</cfif>><cf_get_lang dictionary_id='61133.Catalyst'></option>
                        <option value="1" <cfif session.ep.design_id eq 1 >selected</cfif>><cf_get_lang dictionary_id='49029.Holistic'></option>
                        <option value="2" <cfif session.ep.design_id eq 2 >selected</cfif>><cf_get_lang dictionary_id='63843.Watomic'></option>
                    </select> 
                </div>
                <div class="form-group">
                    <input type="hidden" name="color" value="<cfoutput>#session.ep.design_color#</cfoutput>">
                    <label><cf_get_lang dictionary_id='48128.Renk'></label>
                    <div style="background:white;"> 
                        <div class="square_body <cfoutput>#(not len (session.ep.design_color) or session.ep.design_color eq 1) ? 'square_body_active' : ''#</cfoutput>" data="1" title="<cf_get_lang dictionary_id='57236.Standart'>"><div class="square" style="background: #2b3643"></div></div>
                        <div class="square_body <cfoutput>#session.ep.design_color eq 2 ? 'square_body_active' : ''#</cfoutput>" data="2" title="<cf_get_lang dictionary_id='63408.Deep Blue'>"><div class="square" style="background: #2978B5"></div></div>
                        <div class="square_body <cfoutput>#session.ep.design_color eq 3 ? 'square_body_active' : ''#</cfoutput>" data="3" title="<cf_get_lang dictionary_id='63409.Green Soul'>"><div class="square" style="background: #009688"></div></div>
                        <div class="square_body <cfoutput>#session.ep.design_color eq 4 ? 'square_body_active' : ''#</cfoutput>" data="4" title="<cf_get_lang dictionary_id='63410.Terra Soil'>"><div class="square" style="background: #af7474"></div></div>
                        <div class="square_body <cfoutput>#session.ep.design_color eq 5 ? 'square_body_active' : ''#</cfoutput>" data="5" title="<cf_get_lang dictionary_id='63412.Golden Horn'>"><div class="square" style="background: #d08245"></div></div>
                        <div class="square_body <cfoutput>#session.ep.design_color eq 6 ? 'square_body_active' : ''#</cfoutput>" data="6" title="<cf_get_lang dictionary_id='63413.Silver Line'>"><div class="square" style="background: #8c8989"></div></div>
                    </div>
                </div>
                <script>
                    $(".square_body").click(function () {
                        $(".square_body").removeClass("square_body_active");
                        $(this).addClass("square_body_active");
                        $("input[name=color]").val($(this).attr("data"));
                    });
                </script>
            </div>
            <div class="ui-form-list-btn">
                <div id="show_userGroup" class="col col-6 pdn-l-0"></div>
                <div class="col col-6 pdn-r-0">
                    <a href="javascript://" class="ui-btn ui-btn-success" onClick="AjaxFormSubmit('formUserGroup','show_userGroup',1,'<cfoutput>#getLang('','Güncelleniyor',29723)#','#getLang('','Güncellendi',29724)#</cfoutput>','','',1);"><cf_get_lang dictionary_id='57461.Kaydet'></a>
                </div>
            </div>
        </form>
        <script>
            function getUserGroup(el){
                var position_code = $(el).val().split('-')[0];

                if( position_code != '' ){
                    var data = new FormData();
                    data.append('position_code', position_code);
                    AjaxControlPostDataJson( 'cfc/right_menu_fnc.cfc?method=GET_USER_GROUP_JSON', data, function(response){
                        if( response.length > 0 ){
                            $( "#user_group" ).html('');
                            response.forEach((e) => {
                                $("<option>").attr({"value":e.USER_GROUP_ID}).text(e.USER_GROUP_NAME).appendTo( $( "#user_group" ) );
                            });
                        }else{
                            $("#mng_employee_positions").val("<cfoutput>#session.ep.position_code#-#session.ep.position_name#</cfoutput>");
                            alert("<cf_get_lang dictionary_id='65113.Bu pozisyon için yetki grubu ataması yapılmamış'>.\n<cf_get_lang dictionary_id='65114.Bu rol ile erişim yapılamaz'>!\n<cf_get_lang dictionary_id='65115.Yetki grubuna atanmış bir rol-pozisyon seçiniz'>.");
                        }
                    });
                }
            }

            var get_menus = function (e){
                $('#wrk_menu')
                    .empty()
                    .append('<option value="0">Standart</option>');
                if(e.val()){
                    $.ajax({                
                        url: 'V16/objects/cfc/wrk_menu.cfc',
                        type: "GET",
                        data: ({method:'GET_MENU_JSON',usergroup:e.val()}),
                        success: function (returnData) {
                            if(returnData !=0){
                                var menuList = JSON.parse(returnData);                                 
                                $.each( menuList['DATA'], function( index ) {
                                    $('<option>').append(this[1]).attr({value:this[0]}).appendTo('#wrk_menu');					
                                });
                            }
                        },
                        error: function () {
                            console.warn('E:rightPanelSettings.cfm R:72 F:get_menus')
                        }
                    });
                }
            }
        </script>
    </cfcase>
    <cfcase value="thema">
        <div class="ui-form-list ui-form-block">
            <div class="form-group"> 
                <select class="form-control">				
                    <option>W3 Night</option>
                    <option>W3 Light</option>
                    <option>W3 Sunlight</option> 
                    <option>W3 Standart</option>                    
                </select>
            </div>
        </div>
    </cfcase>
    <cfcase value="menus">
    	<cfinclude template="../../myhome/query/my_sett.cfm">
        <cfset get_my_position_cat_user_group = getInfoTemp.GET_MY_POSITION_CAT_USER_GROUP('#dsn#','#session.ep.position_code#')>
        <cfif get_my_position_cat_user_group.recordcount>
            <cfset GET_OZEL_MENUS = getInfoTemp.GET_OZEL_MENUS('#dsn#','#get_my_position_cat_user_group.POSITION_CAT_ID#','#get_my_position_cat_user_group.USER_GROUP_ID#','#session.ep.userid#')>
        <cfelse>
            <cfset GET_OZEL_MENUS.recordcount = 0>
		</cfif>
       <form name="form_interface" method="post" action="<cfoutput>#request.self#?fuseaction=myhome.emptypopup_settings_process&id=interface</cfoutput>">
             <div class="ui-form-list ui-form-block">
                <div class="form-group"> 
                    <select name="interface" class="form-control"  onChange="AjaxFormSubmit('form_interface','show_interface',1,'Güncelleniyor','Güncellendi','<cfoutput>#request.self#?fuseaction=myhome.emptypopup_settings_process&id=interface</cfoutput>','mysettings_period');" >				
                       <option value="0"><cf_get_lang dictionary_id='57236.Standart'></option>
                       <cfif GET_OZEL_MENUS.recordcount>
                           <cfoutput query="GET_OZEL_MENUS">
                               <option value="#menu_id#" <cfif my_sett.ozel_menu_id eq menu_id>selected</cfif>>#menu_name#</option>     
                           </cfoutput>       
                       </cfif>
                    </select>
                </div>
             </div>
             <div id="show_interface"></div>
         </form>
    </cfcase>
    <cfcase value="documentSettings">
    	<cf_get_lang_set module_name="myhome">
		<cfoutput>
        	<cfset get_papers = getInfoTemp.get_papers('#dsn3#','#session.ep.userid#')>
            <cfform name="paper_form" action="#request.self#?fuseaction=myhome.emptypopup_settings_process&id=center_down" method="POST">
                <div class="ui-form-list ui-form-block">
                    <div class="form-group">
                        <label><cf_get_lang dictionary_id='31069.Tahsilat Makbuzu No'></label>
                        <div class="col col-12 col-md-12 col-sm-12 col-xs-12 padding-0">
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-6 pl-0">
                                <input type="text" name="revenue_receipt_no" id="revenue_receipt_no" class="form-control" value="#get_papers.REVENUE_RECEIPT_NO#">
                            </div>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-6 pr-0">
                                <input type="text" name="revenue_receipt_number" id="revenue_receipt_number" class="form-control" value="#get_papers.REVENUE_RECEIPT_NUMBER#">
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label><cf_get_lang dictionary_id='58133.Fatura No'></label>
                        <div class="col col-12 col-md-12 col-sm-12 col-xs-12 padding-0">
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-6 pl-0">
                                <input type="text" name="invoice_no" id="invoice_no" class="form-control" value="#get_papers.INVOICE_NO#">
                            </div>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-6 pr-0">
                                <input type="text" name="invoice_number" id="invoice_number" class="form-control" value="#get_papers.INVOICE_NUMBER#">
                            </div>
                        </div>    
                    </div>
                    <cfif session.ep.our_company_info.is_efatura>
                        <div class="form-group">
                            <label>E-<cf_get_lang dictionary_id='58133.Fatura No'></label>
                            <div class="col col-12 col-md-12 col-sm-12 col-xs-12 padding-0">
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-6 pl-0">
                                    <input type="text" name="e_invoice_no" id="e_invoice_no" class="form-control" value="#get_papers.E_INVOICE_NO#">
                                </div>
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-6 pr-0">
                                    <input type="text" name="e_invoice_number" id="e_invoice_number" class="form-control" value="#get_papers.E_INVOICE_NUMBER#">
                                </div>
                            </div>        
                        </div>
                    </cfif>
                    <div class="form-group">
                        <label><cf_get_lang dictionary_id='58138.İrsaliye No'></label>
                        <div class="col col-12 col-md-12 col-sm-12 col-xs-12 padding-0">
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-6 pl-0">
                                <input type="text" name="ship_no" id="ship_no" class="form-control" value="#get_papers.SHIP_NO#">
                            </div>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-6 pr-0">
                                <input type="text" name="ship_number" id="ship_number" class="form-control" value="#get_papers.SHIP_NUMBER#">
                            </div>
                        </div> 
                    </div>
                </div>
                <div class="ui-form-list-btn"> 
                    <div>
                        <a href="javascript://" class="ui-btn ui-btn-success" onClick="AjaxFormSubmit('paper_form','paper_div',1,'Güncelleniyor','Güncellendi','<cfoutput>#request.self#?fuseaction=myhome.list_myreport_number&my_emp_id=#session.ep.userid#&id=center_down');</cfoutput>"><cf_get_lang dictionary_id='57464.Güncelle'></a>
                    </div>
                </div>
                <div id="paper_div"></div>
            </cfform>
        </cfoutput>
    </cfcase>
    <cfcase value="favourites">
        <cfinclude template="../../myhome/display/list_myfavourites.cfm">
    </cfcase>
    <cfcase value="reports">
    	<cfset GET_MY_REPORTS = getInfoTemp.GET_MY_REPORTS('#dsn#','#session.ep.userid#')>
		<cfif GET_MY_REPORTS.RECORDCOUNT>
			<table class="ajax_list">
                <tbody>
                    <cfoutput query="GET_MY_REPORTS">
                        <tr>
                            <td>
                                <a href="#request.self#?fuseaction=report.detail_report&event=det&report_id=#report_id#">#report_name#</a>
                            </td>		
                        </tr>
                    </cfoutput>
                    <cfelse>
                    <tr>
                        <td colspan="3"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                    </tr>
                </tbody>
            </table>
        </cfif>
    </cfcase>
    <cfcase value="calendar">
    	<cf_get_lang_set module_name="myhome">
    	<cfinclude template="../../myhome/query/my_sett.cfm">
    	<cfset GET_EVENT_CATS = getInfoTemp.GET_EVENT_CAT_HEADER('#session.ep.userid#')>
        <cfform method="post" action="#request.self#?fuseaction=myhome.emptypopup_settings_process&id=center_top" name="formAgenda">
            <div class="ui-form-list ui-form-block">
                <div class="form-group">
                    <label><cf_get_lang dictionary_id='57930.Kullanici'></label>
                    <div class="input-group">
                    <cfif isdefined("session.agenda_userid")>
                        <!--- baskasinin ajandasinda --->
                        <cfif session.agenda_user_type is "e">
                            <!--- employee ajandasinda --->
                            <input type="hidden" name="member_type" id="member_type" value="employee">
                            <input type="hidden" name="member_id" id="member_id" value="<cfoutput>#session.agenda_userid#</cfoutput>">
                            <cfset attributes.employee_id = session.agenda_userid>
                            <cfinclude template="../../agenda/query/get_hr_name.cfm">
                            <input type="text" name="member" id="member" value="<cfoutput>#get_hr_name.employee_name# #get_hr_name.employee_surname#</cfoutput>" readonly>
                        <cfelseif session.agenda_user_type is "p">
                            <!--- partner ajandasinda --->
                            <input type="hidden" name="member_type" id="member_type" value="partner">
                            <input type="hidden" name="member_id" id="member_id" value="<cfoutput>#session.agenda_userid#</cfoutput>">
                            <cfset attributes.partner_id = session.agenda_userid>
                            <cfinclude template="../../agenda/query/get_partner_name.cfm">
                            <input type="text" name="member" id="member" value="<cfoutput>#get_partner_name.company_partner_name# #get_partner_name.company_partner_surname#</cfoutput>" readonly>
                        </cfif>
                    <cfelse>
                        <!--- kendi ajandasında --->
                        <input type="hidden" name="member_type" id="member_type" value="employee">
                        <input type="hidden" name="member_id" id="member_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
                        <input type="text" name="member" id="member" value="<cfoutput>#session.ep.name# #session.ep.surname#</cfoutput>" readonly>
                    </cfif>
                    <cfif get_module_user(47) and (fusebox.circuit contains 'objects')>
                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=formAgenda.member_id&field_name=formAgenda.member&field_type=formAgenda.member_type','list');"></span>
                    </cfif>    
                    </div>
                </div>
                 <div class="form-group">
                    <label><cf_get_lang dictionary_id='30863.Standart Olay Kategorisi'></label>
                    <select name="eventcat_idFormAgenda" id="eventcat_idFormAgenda" class="form-control">
                        <option value="" selected><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                        <cfoutput query="get_event_cats">
                            <option value="#eventcat_id#" <cfif eventcat_id eq my_sett.eventcat_id>selected</cfif>>#eventcat#</option>
                        </cfoutput>
                    </select>
                 </div>
                 <div class="form-group">
                    <label>
                        <cf_get_lang dictionary_id='31045.Ajandamı herkes görsün'>
                        <input type="checkbox" name="agenda" id="agenda" <cfif my_sett.agenda eq 1> checked</cfif>>
                    </label>
                </div>
                 <div class="form-group"> 
                     <label><cf_get_lang dictionary_id='31046.Saat Ayarı'></label>
                     <cf_wrkTimeZone width="336">
                 </div>
                 <div class="form-group">
                    <label><cf_get_lang dictionary_id='31490.Tarih Formatı'></label>
                    <select name="dateFormat" id="dateFormat" class="form-control">
                        <option value="dd/mm/yyyy" <cfif my_sett.dateformat_style is "dd/mm/yyyy">selected="selected"</cfif>><cf_get_lang dictionary_id='31503.Avrupa Formatı'>(dd/mm/yyyy)</option> 
                        <option value="mm/dd/yyyy" <cfif my_sett.dateformat_style is 'mm/dd/yyyy'>selected="selected"</cfif>><cf_get_lang dictionary_id='31512.Amerikan Formatı'>(mm/dd/yyyy)</option>
                    </select>
                </div>
                <div class="form-group">
                    <label><cf_get_lang dictionary_id='31492.Saat Formatı'></label>
                    <select name="timeFormat" id="timeFormat" class="form-control">
                        <option value="HH:MM" <cfif my_sett.timeformat_style eq "HH:MM">selected="selected"</cfif>><cf_get_lang dictionary_id='31503.Avrupa Formatı'>(HH:mm)</option> 
                        <option value="h:mm tt" <cfif my_sett.timeformat_style is 'h:mm tt'>selected="selected"</cfif>><cf_get_lang dictionary_id='31512.Amerikan Formatı'>(h:mm tt)</option>
                    </select>
                </div>
                <div class="form-group">
                    <label><cf_get_lang dictionary_id='57965.Hafta Başı'></label>
                    <select name="week_start" id="week_start" class="form-control">
                        <option value="1" <cfif my_sett.week_start eq 1>selected</cfif>><cf_get_lang dictionary_id='57604.Pazartesi'></option> 
                        <option value="0" <cfif my_sett.week_start eq 0>selected</cfif>><cf_get_lang dictionary_id='57610.Pazar'></option>
                    </select>
                </div>
            </div>
            <div class="ui-form-list-btn">
                <div id="showAgenda" class="col col-md-6 pdn-l-0"></div>
                <div class="col col-md-6 pdn-r-0">
                    <input type="submit" class="ui-btn ui-btn-success" value="<cf_get_lang dictionary_id='57464.Güncelle'>">
                </div>
            </div>
        </cfform> 
    </cfcase>
    <cfcase value="notification">
        <cfif isdefined('onesignal_appID') and len(onesignal_appID)>
            <script src="https://cdn.onesignal.com/sdks/OneSignalSDK.js" async=""></script>
            <script>
            session_user_id=<cfoutput>#SESSION.EP.USERID#</cfoutput>;
            session_position=<cfoutput>#SESSION.EP.POSITION_CODE#</cfoutput>;
            onesignal_appID = "<cfoutput>#onesignal_appID#</cfoutput>";	
            var OneSignal = window.OneSignal || [];
            OneSignal.push(function() {
                OneSignal.init({
                appId: onesignal_appID,
                });
            OneSignal.sendTags({emp_id: session_user_id});
            OneSignal.sendTags({position_code: session_position});
            });
            </script>
        </cfif>
        <div style="height:70px;">
            <div class='onesignal-customlink-container'><label class="font-grey-300"><cf_get_lang dictionary_id = "29727.İşlem bekleniyor">...</label></div>
        </div>
    </cfcase>
    <cfcase value="other">
    	<cf_get_lang_set module_name="myhome">
        <cfform method="post" action="#request.self#?fuseaction=myhome.emptypopup_settings_process&id=left" name="formTimeZone">
            <div class="ui-form-list ui-form-block">
                <div class="form-group">
                    <label><cf_get_lang dictionary_id="31128.Listeleme Maksimum Kayıt Sayısı"></label>
                    <input type="number" id="maxrows" name="maxrows" class="form-control" min="1" max="250" value="<cfoutput>#session.ep.maxrows#</cfoutput>">
                </div>
                <div class="form-group">
                    <label><cf_get_lang dictionary_id="31001.Session Timeout Süresi (dk.)"></label>
                    <input type="number" id="timeout_limit" name="timeout_limit" class="form-control" min="0" max="360" value="<cfoutput>#session.ep.timeout_min#</cfoutput>">
                </div>
                <cfif session.ep.admin>
                    <div class="form-group">
                        <label>
                            <cf_get_lang dictionary_id='60178.Development Mode'>
                            <input type="checkbox" name="is_dev_mode" id="is_dev_mode" value="1" <cfif isdefined("session.ep.lang_change_action") and session.ep.lang_change_action eq 1>checked="checked"</cfif>>
                        </label>
                    </div>
                    <cfif isdefined("session.ep.lang_change_action") and session.ep.lang_change_action eq 1>
                        <div class="form-group">
                            <a href="javascript://" class="font-grey-300" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_page_lang_list','wide')"><cf_get_lang dictionary_id='44473.Language Set'></a>
                        </div>
                    </cfif>
                </cfif>
            </div>
           <div class="ui-form-list-btn"> 
                <div id="time_zone_div" class="col col-md-6 pdn-l-0"></div>
                <div class="col col-md-6 pdn-r-0">
                    <input type="submit" class="ui-btn ui-btn-success" value="<cf_get_lang dictionary_id='57464.Güncelle'>">
                </div>
           </div>
        </cfform>
    </cfcase>
    <cfcase value="password">
        <cfset strippedForm = true>
    	<cf_get_lang_set module_name="myhome">
        <cfinclude template="../../myhome/display/list_myaccount_password.cfm">
    </cfcase>
	<cfdefaultcase>
		<cfset fusebox.is_special = false>
	</cfdefaultcase>
</cfswitch>

<script>
    $("form#formTimeZone").submit(function(){
        AjaxFormSubmit('formTimeZone','time_zone_div',1,'Güncelleniyor','Güncellendi','<cfoutput>#request.self#?fuseaction=myhome.list_myreport_number&my_emp_id=#session.ep.userid#&id=left</cfoutput>');
        return false;
    });
    $("form#formAgenda").submit(function(){
        AjaxFormSubmit('formAgenda','showAgenda',1,'Güncelleniyor','Güncellendi');
        return false;
    });
</script>