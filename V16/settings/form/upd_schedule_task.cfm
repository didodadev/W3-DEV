<cf_get_lang_set module_name="settings">
    <cfif not (isdefined("attributes.is_pos_operation") and len(attributes.is_pos_operation))><cfset attributes.is_pos_operation = 0></cfif>
    <cfquery name="OUR_COMPANY" datasource="#dsn#">
        SELECT 
            COMP_ID, 
            COMPANY_NAME, 
            NICK_NAME, 
            RECORD_EMP, 
            RECORD_DATE, 
            RECORD_IP, 
            UPDATE_EMP, 
            UPDATE_DATE, 
            UPDATE_IP 
        FROM 
            OUR_COMPANY 
        ORDER BY 
            COMPANY_NAME
    </cfquery>
    <cfquery name="get_pos_operation_row" datasource="#dsn#">
        SELECT 
            SCHEDULE_ID, 
            ROW_NUMBER, 
            POS_OPERATION_ID 
        FROM 
            SCHEDULE_SETTINGS_ROW 
        WHERE 
            SCHEDULE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.schedule_id#">
    </cfquery>
    <cfquery name="get_pos_operation" datasource="#dsn3#">
        SELECT * FROM POS_OPERATION ORDER BY POS_OPERATION_NAME
    </cfquery>
    
    <cf_catalystHeader>
    <cfparam name="attributes.our_company_ids" default="#session.ep.company_id#">
    <cfinclude template="../query/get_schedules.cfm">
    <cfsavecontent variable="img">
        <a href="<cfoutput>#request.self#?fuseaction=report.list_schedules&event=add</cfoutput>"><img src="/images/plus1.gif" title="<cf_get_lang dictionary_id='57582.Ekle'>"/></a>
    </cfsavecontent>
    <cfsavecontent variable="title"><cf_get_lang dictionary_id='42831.Zaman Ayarlı Görev Güncelle'></cfsavecontent>
        <cf_box title="#title#" resize="1">
            <cfform name="upd_schedule" action="" method="post">
                <input type="hidden" name="schedule_id" id="schedule_id" value="<cfoutput>#GET_SCHEDULES.SCHEDULE_ID#</cfoutput>">
                <cf_box_elements> 
                    <div class="col col-6 col-sm-6 col-xs-12">
                        <div class="form-group">
                            <label class="col col-4 col-md-3 col-xs-12"><cf_get_lang dictionary_id='49674.Görev'> <cf_get_lang dictionary_id='57897.Adı'></label>
                            <div class="col col-8 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='42745.Görev Adi Girmelisiniz'></cfsavecontent>
                                <cfinput type="text" name="schedule_name" id="schedule_name" value="#trim(GET_SCHEDULES.SCHEDULE_NAME)#" maxlength="150" required="yes"  message="#message#" validate="noblanks">
                                <input type="hidden" name="old_schedule_name" id="old_schedule_name" value="<cfoutput>#GET_SCHEDULES.SCHEDULE_NAME#</cfoutput>">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-4 col-md-3 col-xs-12"><cf_get_lang dictionary_id='29761.URL'>*</label>
                                <div class="col col-8 col-xs-12">
                                    <cfset schedule_url_ = Left(GET_SCHEDULES.SCHEDULE_URL,(Len(GET_SCHEDULES.SCHEDULE_URL)-Len(ListLast(GET_SCHEDULES.SCHEDULE_URL,'&'))-1))>
                                    <cfinput  type="text" name="schedule_url" value="#schedule_url_#">
                                </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-4 col-md-3 col-xs-12"><cf_get_lang dictionary_id='45176.Görev Seçiniz'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfif attributes.is_pos_operation eq 0>
                                        <cfoutput>
                                            <select name="currency_schedule" id="currency_schedule" style="width:225px" onChange="change_currency_info();">
                                                <option value=""><cf_get_lang dictionary_id='45176.Görev Seçiniz'></option>
                                                <option value="#fusebox.server_machine_list#/#request.self#?fuseaction=schedules.emptypopup_hourly" <cfif schedule_url_ contains '#request.self#?fuseaction=schedules.emptypopup_hourly'>selected</cfif>><cf_get_lang dictionary_id='43462.Piyasalarda Kurlar Gösterilsin'></option>
                                                <option value="#fusebox.server_machine_list#/#request.self#?fuseaction=schedules.emptypopup_import_currency" <cfif schedule_url_ contains '#request.self#?fuseaction=schedules.emptypopup_import_currency'>selected</cfif>><cf_get_lang dictionary_id='43468.Piyasalardaki Kurlar Sistem Kurlarını Güncellesin'></option>
                                                <option value="#fusebox.server_machine_list#/#request.self#?fuseaction=schedules.emptypopup_upd_currency_info" <cfif schedule_url_ contains '#request.self#?fuseaction=schedules.emptypopup_upd_currency_info'>selected</cfif>><cf_get_lang dictionary_id='43525.İleri Tarihli Kurlar Sistem Kurlarını Güncellesin'></option>
                                                <option value="#fusebox.server_machine_list#/#request.self#?fuseaction=schedules.emptypopup_get_social_media_info"<cfif schedule_url_ contains '#request.self#?fuseaction=schedules.emptypopup_get_social_media_info'>selected</cfif>><cf_get_lang dictionary_id='45177.Sosyal Medya Güncellensin'></option>
                                                <option value="#fusebox.server_machine_list#/#request.self#?fuseaction=schedules.emptypopup_upd_warning_confirm_actions"<cfif schedule_url_ contains '#request.self#?fuseaction=schedules.emptypopup_upd_warning_confirm_actions'>selected</cfif>><cf_get_lang dictionary_id='60683.Onaylardaki Güncellemeler Belgeleri Güncellensin'></option>
                                                <option value="#fusebox.server_machine_list#/#request.self#?fuseaction=bank.emptypopup_wodiba_api_accounts"<cfif schedule_url_ contains 'bank.emptypopup_wodiba_api_accounts'>selected</cfif>><cf_get_lang dictionary_id='43846.WoDiBa Banka Bakiyelerini Güncelle'></option>
                                                <option value="#fusebox.server_machine_list#/#request.self#?fuseaction=bank.emptypopup_wodiba_api_actions"<cfif schedule_url_ contains 'bank.emptypopup_wodiba_api_actions'>selected</cfif>><cf_get_lang dictionary_id='43921.WoDiBa Banka Hareketlerini Güncelle'></option>
                                                <option value="#fusebox.server_machine_list#/#request.self#?fuseaction=bank.emptypopup_wodiba_process_actions"<cfif schedule_url_ contains 'bank.emptypopup_wodiba_process_actions'>selected</cfif>><cf_get_lang dictionary_id='44026.WoDiBa Banka Hareketlerini Sisteme Kaydet'></option>
                                                <option value="#fusebox.server_machine_list#/#request.self#?fuseaction=bank.emptypopup_wodiba_bank_transaction_types"<cfif schedule_url_ contains 'bank.emptypopup_wodiba_bank_transaction_types'>selected</cfif>><cf_get_lang dictionary_id='59884.WoDiBa Banka İşlem Tipleri Servisi'></option>
                                            </select>
                                        </cfoutput>
                                    <cfelse>
                                    </cfif>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-4 col-md-3 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-8 col-xs-12">
                                <textarea name="detail" id="detail" style="width:225px;height:45px;"><cfoutput>#GET_SCHEDULES.SCHEDULE_DESC#</cfoutput></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <cfif attributes.is_pos_operation eq 0>				  			  				  
                            <label class="col col-4 col-md-3 col-xs-12"><cf_get_lang dictionary_id='43477.İlişkili Şirket'></label>
                            <div class="col col-8 col-xs-12">
                            <cf_multiselect_check
                                name="our_company_ids"
                                option_name="nick_name"
                                option_value="comp_id"
                                table_name="OUR_COMPANY"
                                value="#GET_SCHEDULES.RELATED_COMPANY_INFO#"
                                width="225">
                            <cfelse>
                            </cfif>
                            </div>
                        </div>
                    </div>
                    <div class="col col-6 col-sm-6 col-xs-12">
                        <div class="form-group">
                            <label class="col col-2 col-md-2 col-xs-2"><cf_get_lang dictionary_id='57501.Başlangıç'> *</label>
                            <div class="col col-5 col-md-5 col-xs-5">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
                                <div class="input-group">
                                    <cfinput type="text" name="startdate" id="startdate" value="#DateFormat(GET_SCHEDULES.SCHEDULE_STARTDATE,dateformat_style)#" required="Yes" validate="#validate_style#" message="#message#" readonly="yes">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                                </div>
                            </div>
                            <div class="col col-5 col-md-5 col-sm-5 col-xs-5">
                                <cf_wrkTimeFormat name="start_clock" value="#TIMEFORMAT(GET_SCHEDULES.SCHEDULE_STARTDATE,"HH")#">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-2 col-md-2 col-xs-2"><cf_get_lang dictionary_id='57502.Bitiş'></label>
                            <div class="col col-5 col-md-5 col-xs-5">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='30123.Bitiş Tarihini Kontrol Ediniz '></cfsavecontent>
                                <div class="input-group">
                                    <cfinput type="text" name="finishdate" value="#DateFormat(GET_SCHEDULES.SCHEDULE_FINISHDATE,dateformat_style)#"  validate="#validate_style#" message="#message#">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                                </div>
                            </div>
                            <div class="col col-5 col-md-5 col-sm-5 col-xs-5">
                                <cf_wrkTimeFormat name="finish_clock" value="#TIMEFORMAT(GET_SCHEDULES.SCHEDULE_FINISHDATE,"HH")#">
                            </div>
                        </div>
                        <!---
                        <div class="form-group">
                            <label class="col col-4 col-md-3 col-xs-12"><cf_get_lang dictionary_id='691.Peryod'></label>
                                <div class="portBoxBodyStandart  scrollContent">
                                    <div id="body_box_3083592" style=";width:100%;">
                                        <table class="ui-table-list ui-form">
                                            <thead>
                                                <tr>
                                                    <th><cf_get_lang dictionary_id='763.Bir Defa'></th>
                                                    <th><cf_get_lang dictionary_id='764.Yinelenerek'></th>	
                                                    <th><cf_get_lang dictionary_id='844.Günlük Her'></th>	
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td>
                                                        <div class="form-group">
                                                            <input type="radio" name="ScheduleType" id="ScheduleType1" value="Once" <cfif GET_SCHEDULES.SCHEDULE_TYPE eq "Once">checked</cfif>>
                                                            <cfif (GET_SCHEDULES.SCHEDULE_TYPE eq "Once")>
                                                                <cf_wrkTimeFormat name="Once_Hour" value="#TIMEFORMAT(GET_SCHEDULES.SCHEDULE_STARTDATE,"HH")#">
                                                                <cfelse>
                                                                <cf_wrkTimeFormat name="Once_Hour" value="">
                                                            </cfif>
                                                            <select name="Once_Minute" id="Once_Minute">
                                                                <option value="00" selected><cf_get_lang dictionary_id='715.Dakika'></option>
                                                                <cfloop from="1" to="59" index="i">
                                                                    <cfoutput><option value="#i#"<cfif (GET_SCHEDULES.SCHEDULE_TYPE eq "Once") and (TIMEFORMAT(GET_SCHEDULES.SCHEDULE_STARTDATE,"mm") eq i)> selected</cfif>>#i#</option></cfoutput>
                                                                </cfloop>
                                                            </select>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div class="form-group">
                                                            <input type="Radio" name="ScheduleType" id="ScheduleType2" value="Recurring"<cfif GET_SCHEDULES.SCHEDULE_TYPE eq "Recurring"> checked</cfif>>
                                                            <select name="Interval" id="Interval">
                                                                <option value="Daily" <cfif (GET_SCHEDULES.SCHEDULE_TYPE eq "Recurring") and (GET_SCHEDULES.SCHEDULE_INTERVAL eq 'Daily')>selected</cfif>><cf_get_lang dictionary_id='1045.Gunluk'></option>
                                                                <option value="Weekly" <cfif (GET_SCHEDULES.SCHEDULE_TYPE eq "Recurring") and (GET_SCHEDULES.SCHEDULE_INTERVAL eq 'Weekly')>selected</cfif>><cf_get_lang dictionary_id='1046.Haftalik'></option>
                                                                <option value="Monthly" <cfif (GET_SCHEDULES.SCHEDULE_TYPE eq "Recurring") and (GET_SCHEDULES.SCHEDULE_INTERVAL eq 'Monthly')>selected</cfif>><cf_get_lang dictionary_id='1520.Aylik'></option>
                                                            </select>
                                                            <cfif (GET_SCHEDULES.SCHEDULE_TYPE eq "Recurring")>
                                                            <cf_wrkTimeFormat name="Recurring_Hour" value="#TIMEFORMAT(GET_SCHEDULES.SCHEDULE_STARTDATE,"HH")#">
                                                            <cfelse>
                                                            <cf_wrkTimeFormat name="Recurring_Hour" value="">
                                                            </cfif>
    
                                                            <select name="Recurring_Minute" id="Recurring_Minute">
                                                                <option value="00" selected><cf_get_lang dictionary_id='715.Dakika'></option>
                                                                <cfloop from="1" to="59" index="i">
                                                                    <cfoutput><option value="#i#"<cfif (GET_SCHEDULES.SCHEDULE_TYPE eq "Recurring") and (TIMEFORMAT(GET_SCHEDULES.SCHEDULE_STARTDATE,"mm") eq i)> selected</cfif>>#i#</option></cfoutput>
                                                                </cfloop>
                                                            </select>		
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div class="form-group">
                                                            <input type="Radio" name="ScheduleType" id="ScheduleType3" value="Custom"<cfif GET_SCHEDULES.SCHEDULE_TYPE eq "Custom"> checked</cfif>>
                                                            <cfset hours = "">
                                                            <cfset mins = "">
                                                            <cfset secs = "">
                                                            <cfif GET_SCHEDULES.SCHEDULE_TYPE eq "Custom">
                                                                <cfset hours = INT(GET_SCHEDULES.SCHEDULE_INTERVAL / 3600)>
                                                                <cfset mins = INT((GET_SCHEDULES.SCHEDULE_INTERVAL - (hours * 3600)) / 60)>
                                                                <cfset secs = INT(GET_SCHEDULES.SCHEDULE_INTERVAL - (hours * 3600) - (mins * 60))>										
                                                            </cfif>
                                                            <cfinput name="customInterval_hour" type="text" maxlength="2" value="#hours#" validate="integer" range="0,23" style="width:25px;"><cf_get_lang dictionary_id='79.Saat'>
                                                            <cfinput name="customInterval_min" type="text" maxlength="2" value="#mins#" validate="integer" range="0,59" style="width:25px;"><cf_get_lang dictionary_id='715.Dakika'>
                                                            <cfinput name="customInterval_sec" type="text" maxlength="2" value="#secs#" validate="integer" range="0,59"  style="width:25px;"><cf_get_lang dictionary_id='845.Saniye'>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        --->
                        <div class="form-group" id="item-periyod">
                            <label class="col col-3 col-xs-3 col-md-3 control-label"><cf_get_lang dictionary_id='42674.Periyot'></label>
                            <input class="col col-1 col-xs-1 col-md-1" type="radio" name="ScheduleType" id="ScheduleType1" value="Once" <cfif GET_SCHEDULES.SCHEDULE_TYPE eq "Once">checked</cfif>>
                            <label class="col col-2 col-xs-2 col-md-2"><cf_get_lang dictionary_id='42746.Bir Defa'></label>
                            <div class="col col-6 col-xs-12 input-group">
                                <cfif (GET_SCHEDULES.SCHEDULE_TYPE eq "Once")>
                                <cf_wrkTimeFormat name="Once_Hour" value="#TIMEFORMAT(GET_SCHEDULES.SCHEDULE_STARTDATE,"HH")#">	
                                <cfelse>
                                <cf_wrkTimeFormat name="Once_Hour" value="">	
                                </cfif>
                                <span class="input-group-addon no-bg"></span>
                                <select name="Once_Minute" id="Once_Minute">
                                    <option value="00" selected> <cf_get_lang dictionary_id='58127.Dakika'></option>
                                    <cfloop from="1" to="59" index="i">
                                        <cfoutput><option value="#i#" <cfif (GET_SCHEDULES.SCHEDULE_TYPE eq "Once") and (TIMEFORMAT(GET_SCHEDULES.SCHEDULE_STARTDATE,"mm") eq i)>selected</cfif>>#i#</option></cfoutput>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-periyod2">
                            <label class="col col-3 col-xs-3 col-md-3 control-label"></label>
                            <input class="col col-1 col-xs-1 col-md-1" type="Radio" name="ScheduleType" id="ScheduleType2" value="Recurring" <cfif GET_SCHEDULES.SCHEDULE_TYPE eq "Recurring"> checked</cfif>>
                            <label class="col col-2 col-xs-2 col-md-2"><cf_get_lang dictionary_id='42747.Yinelenerek'></label>
                            <div class="col col-6 col-xs-6 col-md-12 input-group">
                                <select name="Interval" id="Interval">
                                    <option value="Daily" <cfif (GET_SCHEDULES.SCHEDULE_TYPE eq "Recurring") and (GET_SCHEDULES.SCHEDULE_INTERVAL eq 'Daily')>selected</cfif>><cf_get_lang dictionary_id='58457.Gunluk'></option>
                                    <option value="Weekly" <cfif (GET_SCHEDULES.SCHEDULE_TYPE eq "Recurring") and (GET_SCHEDULES.SCHEDULE_INTERVAL eq 'Weekly')>selected</cfif>><cf_get_lang dictionary_id='58458.Haftalik'></option>
                                    <option value="Monthly" <cfif (GET_SCHEDULES.SCHEDULE_TYPE eq "Recurring") and (GET_SCHEDULES.SCHEDULE_INTERVAL eq 'Monthly')>selected</cfif>><cf_get_lang dictionary_id='58932.Aylik'></option>
                                </select>					
                                <span class="input-group-addon no-bg"></span>
                                <cfif (GET_SCHEDULES.SCHEDULE_TYPE eq "Recurring")>							
                                    <cf_wrkTimeFormat name="Recurring_Hour" value="#TIMEFORMAT(GET_SCHEDULES.SCHEDULE_STARTDATE,"HH")#">
                                <cfelse>
                                    <cf_wrkTimeFormat name="Recurring_Hour" value="">
                                </cfif>
                                <span class="input-group-addon no-bg"></span>
                                <select name="Recurring_Minute" id="Recurring_Minute">
                                    <option value="00" selected><cf_get_lang dictionary_id='58127.Dakika'></option>
                                    <cfloop from="1" to="59" index="i">
                                        <cfoutput><option value="#i#" <cfif (GET_SCHEDULES.SCHEDULE_TYPE eq "Recurring") and (TIMEFORMAT(GET_SCHEDULES.SCHEDULE_STARTDATE,"mm") eq i)> selected</cfif>>#i#</option></cfoutput>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <cfset hours = "">
                        <cfset mins = "">
                        <cfset secs = "">
                        <cfif GET_SCHEDULES.SCHEDULE_TYPE eq "Custom">
                        <cfset hours = INT(GET_SCHEDULES.SCHEDULE_INTERVAL / 3600)>
                        <cfset mins = INT((GET_SCHEDULES.SCHEDULE_INTERVAL - (hours * 3600)) / 60)>
                        <cfset secs = INT(GET_SCHEDULES.SCHEDULE_INTERVAL - (hours * 3600) - (mins * 60))>
                        </cfif>
                        <div class="form-group" id="item-periyod3">
                            <label class="col col-3 col-xs-12 control-label"></label>
                            <input class="col col-1" type="Radio" name="ScheduleType" id="ScheduleType3" value="Custom" <cfif GET_SCHEDULES.SCHEDULE_TYPE eq "Custom"> checked</cfif>>
                            <label class="col col-2"><cf_get_lang dictionary_id='58457.Günlük'><cf_get_lang dictionary_id='830.Her'></label>
                            <div class="col col-6 col-md-6 col-xs-6">
                                
                                <label class="col col-2 col-md-3 col-xs-12"><cf_get_lang dictionary_id='57491.Saat'></label>
                                <div class="col col-2">
                                    <cfinput name="customInterval_hour" id="customInterval_hour" type="text" maxlength="2" value="#hours#" validate="integer" range="0,23" style="width:25px;">
                                </div>
    
                                <label class="col col-2"><cf_get_lang dictionary_id='58127.Dakika'></label>
                                <div class="col col-2">
                                    <cfinput name="customInterval_min" id="customInterval_min" type="text" maxlength="2" value="#mins#" validate="integer" range="0,59" style="width:25px;">
                                </div>
                                
                                <label class="col col-2"><cf_get_lang dictionary_id='42828.Saniye'></label>
                                <div class="col col-2">
                                    <cfinput name="customInterval_sec" id="customInterval_sec" type="text" maxlength="2" value="#secs#" validate="integer" range="0,59" style="width:25px;">
                                </div>
                            </div>
                        </div>
                    </div>
                    <tr>
                        <cfif attributes.is_pos_operation eq 1>
                            <td colspan="2">
                                <cf_form_list>
                                <thead>
                                    <tr>
                                        <th><input type="button" class="eklebuton" title="" onClick="add_row();"></th>
                                        <th style="width:50px;">&nbsp;<cf_get_lang dictionary_id='58577.Sıra'> *</th>
                                        <th style="width:160px;">&nbsp;<cf_get_lang dictionary_id='39613.Kural'> *</th>
                                    </tr>
                                </thead>
                                <tbody id="link_table">
                                    <input name="record_num" id="record_num" type="hidden" value="<cfoutput>#get_pos_operation_row.recordcount#</cfoutput>">
                                    <input name="is_pos_operation" id="is_pos_operation" type="hidden" value="1">
                                    <cfoutput query="get_pos_operation_row">
                                        <tr id="my_row_#currentrow#">
                                            <td>
                                                <input type="hidden" name="row_kontrol_#currentrow#" id="row_kontrol_#currentrow#" value="1" /><a style="cursor:pointer" onclick="sil(#currentrow#);" ><img src="images/delete_list.gif" border="0"></a>
                                            </td>
                                            <td>
                                                <input type="text" name="pos_line_#currentrow#" id="pos_line_#currentrow#" value="#get_pos_operation_row.row_number#" style="width:50px;">
                                            </td>
                                            <td>
                                                <select name="pos_operation_id_#currentrow#" id="pos_operation_id_#currentrow#" style="width:150px;">
                                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                    <cfloop query="get_pos_operation">
                                                        <option value="#get_pos_operation.pos_operation_id#" <cfif get_pos_operation_row.pos_operation_id eq get_pos_operation.pos_operation_id>selected</cfif>>#get_pos_operation.pos_operation_name#</option>
                                                    </cfloop>
                                                </select>
                                            </td>
                                        </tr>
                                    </cfoutput>
                                </tbody>
                                </cf_form_list>	
                            </td>
                        <cfelse>
                            <td colspan="2"></td>
                        </tr>
                    </cfif>
                </cf_box_elements>
            <cf_box_footer>
            <cf_record_info query_name="GET_SCHEDULES">
            <cf_workcube_buttons is_upd='1' add_function='control()' delete_page_url='#request.self#?fuseaction=settings.list_schedule_settings&event=del&schedule_id=#attributes.schedule_id#'>
            <cfif not (schedule_url_ contains '#fusebox.server_machine_list#/#request.self#?fuseaction=report.list_schedules&event=upd' or schedule_url_ contains '#fusebox.server_machine_list#/#request.self#?fuseaction=schedules.emptypopup_import_currency' or schedule_url_ contains '#fusebox.server_machine_list#/#request.self#?fuseaction=schedules.emptypopup_hourly' or schedule_url_ contains '#fusebox.server_machine_list#/#request.self#?fuseaction=schedules.emptypopup_upd_warning_confirm_actions')>
                <cf_workcube_buttons type_format="1" add_function='control_schedule()' is_upd='0' is_cancel='0' insert_info='#getlang('','Çalıştır',57911)#' insert_alert=''>
            </cfif>
            </cf_box_footer>
        </cfform>
    </cf_box>
    <script type="text/javascript">
        row_count = "<cfoutput>#get_pos_operation_row.recordcount#</cfoutput>";
        function sil(sy)
        {
            var my_element=eval("document.upd_schedule.row_kontrol_"+sy);
            my_element.value=0;
            var my_element=eval("my_row_"+sy);
            my_element.style.display="none";
        }
        function add_row()
        {
            row_count++;
            var newRow;
            var newCell;
            
            newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);	
            newRow.setAttribute("name","my_row_" + row_count);
            newRow.setAttribute("id","my_row_" + row_count);		
            newRow.setAttribute("NAME","my_row_" + row_count);
            newRow.setAttribute("ID","my_row_" + row_count);		
            document.upd_schedule.record_num.value=row_count;
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="hidden" name="row_kontrol_'+ row_count +'" value="1" /><a style="cursor:pointer" onclick="sil(' + row_count + ');" ><img src="images/delete_list.gif" border="0"></a>';	
            newCell= newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="pos_line_'+ row_count +'" id="pos_line_'+ row_count +'" value="" style="width:50px;">';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML= '<select name="pos_operation_id_'+ row_count +'" style="width:150px;"><option value="">Seçiniz</option><cfoutput query="get_pos_operation"><option value="#get_pos_operation.pos_operation_id#">#get_pos_operation.pos_operation_name#</option></cfoutput></select>';
        }
        function control_schedule()
        {
            alert_info = "<cf_get_lang dictionary_id='831.Zaman Ayarlı Görev Çalıştırılacaktır. Emin misiniz'> ?";
            if (confirm(alert_info)) 
            {
                windowopen('','small','cc_che');
                upd_schedule.action='<cfoutput>#request.self#?fuseaction=schedules.emptypopup_schedule_action&schedule_id=#attributes.schedule_id#&is_from_upd</cfoutput>';
                upd_schedule.target='cc_che';
                upd_schedule.submit();
                return false;
            }
            else 
                return false;
        }
        function control()
        {
            if((document.upd_schedule.ScheduleType[2].checked && document.upd_schedule.ScheduleType[2].value == 'Custom') && ((document.upd_schedule.customInterval_min.value.length == 0) || (document.upd_schedule.customInterval_sec.value.length == 0) || (document.upd_schedule.customInterval_hour.value.length == 0)))
            {
                alert('<cf_get_lang dictionary_id="44679.Period Verileri Eksik">');
                return false;
            }
            return true;
        }
        function change_currency_info()//kurlarla ilgili fuseaction ları URL input una taşır
        {
            x = document.upd_schedule.currency_schedule.selectedIndex;
            if (document.upd_schedule.currency_schedule[x].value != ""){
                document.upd_schedule.schedule_url.value = document.upd_schedule.currency_schedule[x].value;
                if(x == 6){//WoDiBa Banka Bakiyelerini Güncelle
                    document.getElementById('schedule_name').value = '<cfoutput>#uCase(replace(employee_url,'.','_','All'))#</cfoutput>_UPDATE_WODIBA_ACCOUNTS';
                    document.getElementById('detail').value = 'Wodiba Gateway sisteminden banka hesap bakiyelerini alır.';
                }
                if(x == 7){//WoDiBa Banka Hareketlerini Güncelle
                    document.getElementById('schedule_name').value = '<cfoutput>#uCase(replace(employee_url,'.','_','All'))#</cfoutput>_UPDATE_WODIBA_ACTIONS';
                    document.getElementById('detail').value = 'Wodiba Gateway sisteminden banka hareketlerini alır.';
                }
                if(x == 8){//WoDiBa Banka Hareketlerini Sisteme Kaydet
                    document.getElementById('schedule_name').value = '<cfoutput>#uCase(replace(employee_url,'.','_','All'))#</cfoutput>_WODIBA_PROCESS_ACTIONS';
                    document.getElementById('detail').value = 'Wodina banka hareketlerini Banka, Cari, Muhasebe ve Bütçe kayıtlarına dönüştürür.';
                }
                if(x == 9){//WoDiBa Banka İşlem Tipleri Servisi
                    document.getElementById('schedule_name').value = '<cfoutput>#uCase(replace(employee_url,'.','_','All'))#</cfoutput>_WODIBA_TRANSACTION_TYPE_SERVICE';
                    document.getElementById('detail').value = 'Wodiba Gateway sisteminden banka işlem kodlarını alır.';
                }
                if(x == 6 || x == 7 || x == 8 || x == 9){
                    document.getElementById('startdate').value = '<cfoutput>#DateFormat(Now(),"dd/mm/YYYY")#</cfoutput>';
                    document.getElementById('ScheduleType3').checked = true;
                    document.getElementById('customInterval_hour').value = 0;
                    document.getElementById('customInterval_min').value = 5;
                    document.getElementById('customInterval_sec').value = 0;
                }
            }
            else
                document.upd_schedule.schedule_url.value = '<cfoutput>#fusebox.server_machine_list#/#request.self#?fuseaction=schedules.emptypopup_schedule_action</cfoutput>';
        }
    </script>
    <cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
    