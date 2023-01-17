<cf_get_lang_set module_name="settings">
<cfif not isdefined("attributes.is_pos_operation")><cfset attributes.is_pos_operation = 0></cfif>
<cfquery name="OUR_COMPANY" datasource="#dsn#">
	SELECT 
    	COMP_ID, 
        COMPANY_NAME, 
        NICK_NAME
    FROM 
	    OUR_COMPANY 
    ORDER BY 
    	COMPANY_NAME
</cfquery>
<cfquery name="get_pos_operation" datasource="#dsn3#">
    SELECT 
    	POS_OPERATION_ID, 
        IS_ACTIVE, 
        POS_OPERATION_NAME 
    FROM 
	    POS_OPERATION 
    WHERE 
    	IS_ACTIVE = 1
</cfquery>
<cf_catalystHeader>
<cfparam name="attributes.our_company_ids" default="#session.ep.company_id#">
<cfform name="add_schedule" action="" method="post">
<cfsavecontent variable="title"><cf_get_lang dictionary_id='42738.Zaman Ayarlı Görev Ekle'></cfsavecontent>
<cf_box title="#title#" resize="1">
    <cf_box_elements>
                    <!--- LEFT --->
        <div class="col col-6 col-sm-6 col-xs-12">
            <div class="form-group">
                <label class="col col-4 col-md-3 col-xs-12"><cf_get_lang dictionary_id='49674.Görev'> <cf_get_lang dictionary_id='57897.Adı'> *</label>
                    <div class="col col-8 col-xs-12">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='42745.Görev Adi Girmelisiniz'></cfsavecontent>
                    <cfinput type="text" name="schedule_name" id="schedule_name" value="" style="width:225px;" maxlength="150" required="yes" message="#message#" validate="noblanks">
                </div>
            </div>
            <div class="form-group">
                <label class="col col-4 col-md-3 col-xs-12"><cf_get_lang dictionary_id='29761.URL'> *</label>
                    <div class="col col-8 col-xs-12">
                    <cfinput type="text" name="schedule_url" value="#fusebox.server_machine_list#/#request.self#?fuseaction=schedules.emptypopup_schedule_action" style="width:225px;">
                </div>
            </div>
            <div class="form-group">
                <label class="col col-4 col-md-3 col-xs-12"><cf_get_lang dictionary_id='45176.Görev Seçiniz'></label>
                <div class="col col-8 col-xs-12">
                    <cfif attributes.is_pos_operation eq 0>
                        <cfoutput>
                            <select name="currency_schedule" id="currency_schedule" style="width:225px" onChange="change_currency_info();">
                                <option value=""><cf_get_lang dictionary_id='45176.Görev Seçiniz'></option>
                                <option value="#fusebox.server_machine_list#/#request.self#?fuseaction=schedules.emptypopup_hourly"><cf_get_lang dictionary_id='43462.Piyasalarda Kurlar Gösterilsin'></option>
                                <option value="#fusebox.server_machine_list#/#request.self#?fuseaction=schedules.emptypopup_import_currency"><cf_get_lang dictionary_id='43468.Piyasalardaki Kurlar Sistem Kurlarını Güncellesin'></option>
                                <option value="#fusebox.server_machine_list#/#request.self#?fuseaction=schedules.emptypopup_upd_currency_info"><cf_get_lang dictionary_id='43525.İleri Tarihli Kurlar Sistem Kurlarını Güncellesin'></option>
                                <option value="#fusebox.server_machine_list#/#request.self#?fuseaction=schedules.emptypopup_get_social_media_info"><cf_get_lang dictionary_id='45177.Sosyal Medya Güncellensin'></option>
                                <option value="#fusebox.server_machine_list#/#request.self#?fuseaction=schedules.emptypopup_upd_warning_confirm_actions"><cf_get_lang dictionary_id='60683.Onaylardaki Güncellemeler Belgeleri Güncellesin'></option>
                                <option value="#fusebox.server_machine_list#/#request.self#?fuseaction=bank.emptypopup_wodiba_api_accounts"><cf_get_lang dictionary_id='43846.WoDiBa Banka Bakiyelerini Güncelle'></option>
                                <option value="#fusebox.server_machine_list#/#request.self#?fuseaction=bank.emptypopup_wodiba_api_actions"><cf_get_lang dictionary_id='43921.WoDiBa Banka Hareketlerini Güncelle'></option>
                                <option value="#fusebox.server_machine_list#/#request.self#?fuseaction=bank.emptypopup_wodiba_process_actions"><cf_get_lang dictionary_id='44026.WoDiBa Banka Hareketlerini Sisteme Kaydet'></option>
                                <option value="#fusebox.server_machine_list#/#request.self#?fuseaction=bank.emptypopup_wodiba_bank_transaction_types"><cf_get_lang dictionary_id='59884.WoDiBa Banka İşlem Tipleri Servisi'></option>
                            </select>
                        </cfoutput>
                    </cfif>
                </div>
            </div>
            <div class="form-group">
                <label class="col col-4 col-md-3 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'> *</label>
                    <div class="col col-8 col-xs-12">
                    <textarea name="detail" id="detail" style="width:225px;height:45px;" value=""></textarea>
                </div>
            </div>
            <div class="form-group">
                <label class="col col-4 col-md-3 col-xs-12"><cf_get_lang dictionary_id='43477.İlişkili Şirket'></label>
                    <div class="col col-8 col-xs-12">
                    <cfif attributes.is_pos_operation eq 0>	  
                        <cf_multiselect_check
                            name="our_company_ids"
                            option_name="nick_name"
                            option_value="comp_id"
                            table_name="OUR_COMPANY"
                            width="225">
                    </cfif>
                </div>
            </div>
        </div>
                    <!--- RIGHT --->
        <div class="col col-6 col-sm-6 col-xs-12">
            <div class="form-group">
                <label class="col col-2 col-md-2 col-xs-2"><cf_get_lang dictionary_id='57501.Başlangıç'> *</label>
                <div class="col col-5 col-md-5 col-xs-5">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
                        <cfinput type="text" name="startdate" id="startdate" required="Yes" validate="#validate_style#" message="#message#" readonly="yes">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                    </div>
                </div>
                <div class="col col-5 col-md-5 col-sm-5 col-xs-5">
                    <cf_wrkTimeFormat name="start_clock" value="">
                </div>
            </div>
            <div class="form-group">
                <label class="col col-2 col-md-2 col-xs-2"><cf_get_lang dictionary_id='57502.Bitiş'></label>
                <div class="col col-5 col-md-5 col-xs-5">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='30123.Bitiş Tarihini Kontrol Ediniz '></cfsavecontent>
                        <cfinput type="text" name="finishdate" validate="#validate_style#" value="" message="#message#">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                    </div>
                </div>
                <div class="col col-5 col-md-5 col-sm-5 col-xs-5">
                    <cf_wrkTimeFormat name="finish_clock" value="">
                </div>
            </div>
            <div class="form-group" id="item-periyod">
                <label class="col col-3 col-xs-3 col-md-3 control-label"><cf_get_lang dictionary_id='42674.Periyot'></label>
                <input class="col col-1 col-xs-1 col-md-1" type="radio" name="ScheduleType" id="ScheduleType1" value="Once">
                <label class="col col-2 col-xs-2 col-md-2"><cf_get_lang dictionary_id='42746.Bir Defa'></label>
                <div class="col col-6 col-xs-12 input-group">
                    <cf_wrkTimeFormat name="Once_Hour" value="">	
                    <span class="input-group-addon no-bg"></span>
                    <select name="Once_Minute" id="Once_Minute">
                        <option value="00" selected> <cf_get_lang dictionary_id='58127.Dakika'></option>
                        <cfloop from="1" to="59" index="i">
                            <cfoutput><option value="#i#">#i#</option></cfoutput>
                        </cfloop>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label class="col col-3 col-xs-3 col-md-3 control-label"></label>
                <input class="col col-1 col-xs-1 col-md-1" type="Radio" name="ScheduleType" id="ScheduleType2" value="Recurring" checked>
                <label class="col col-2 col-xs-2 col-md-2"><cf_get_lang dictionary_id='42747.Yinelenerek'></label>
                <div class="col col-6 col-xs-12 input-group">
                    <select name="Interval" id="Interval">
                        <option value="Daily"><cf_get_lang dictionary_id='58457.Gunluk'></option>
                        <option value="Weekly"><cf_get_lang dictionary_id='58458.Haftalik'></option>
                        <option value="Monthly"><cf_get_lang dictionary_id='58932.Aylik'></option>
                    </select>												
                    <span class="input-group-addon no-bg"></span>
                    <cf_wrkTimeFormat name="Recurring_Hour" value="">
                    <span class="input-group-addon no-bg"></span>
                    <select name="Recurring_Minute" id="Recurring_Minute">
                        <option value="00" selected><cf_get_lang dictionary_id='58127.Dakika'></option>
                        <cfloop from="1" to="59" index="i">
                            <cfoutput><option value="#i#">#i#</option></cfoutput>
                        </cfloop>
                    </select>
                </div>
            </div>
            <div class="form-group" id="item-periyod2">
                <label class="col col-3 col-xs-3 col-md-3 control-label"></label>
                <input class="col col-1 col-xs-1 col-md-1" type="Radio" name="ScheduleType" id="ScheduleType3" value="Custom">
                <label class="col col-2 col-xs-2 col-md-2"><cf_get_lang dictionary_id='42827.Gunluk Her'></label>
                <div class="col col-6 col-md-6 col-xs-6">
                    <label class="col col-2 col-md-3 col-xs-12"><cf_get_lang dictionary_id='57491.Saat'></label>
                    <div class="col col-2">
                        <cfinput name="customInterval_hour" id="customInterval_hour" type="text" maxlength="2" validate="integer" range="0,23">
                    </div>
                    <label class="col col-2 col-md-3 col-xs-12"><cf_get_lang dictionary_id='58127.Dakika'></label>
                    <div class="col col-2">
                        <cfinput name="customInterval_min" id="customInterval_min" type="text" maxlength="2" validate="integer" range="0,59">
                    </div>
                    <label class="col col-2 col-md-3 col-xs-12"><cf_get_lang dictionary_id='42828.Saniye'></label>
                    <div class="col col-2">
                        <cfinput name="customInterval_sec" id="customInterval_sec" type="text" maxlength="2" validate="integer" range="0,59">
                    </div>
                </div>
            </div>
        </div>
        </div>
        <!--- BUTTON --->
        <cf_box_footer>
            <div class="form-group">
                <cf_workcube_buttons type_format="1" is_upd='0'>
            </div>
        </cf_box_footer>
    </cf_box_elements>
</cf_box>
</cfform>
    <!--- <table>
        <tr>
            <td width="40"><cf_get_lang dictionary_id='219.Ad'>*</td>
            <td width="240">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='762.Görev Adi Girmelisiniz'></cfsavecontent>
                <cfinput type="text" name="schedule_name" id="schedule_name" value="" style="width:225px;" maxlength="150" required="yes" message="#message#" validate="noblanks">
            </td>
            <td width="60" align="left"><cf_get_lang dictionary_id='89.Başlangıç'> *</td>
            <td>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='326.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
                <cfinput type="text" name="startdate" id="startdate"  style="width:80px;" required="Yes" validate="#validate_style#" message="#message#" readonly="yes">
                <cf_wrk_date_image date_field="startdate">
                <cf_wrkTimeFormat name="start_clock" value="">
            </td>				
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='1964.URL'>*</td>
            <td>
                <cfinput type="text" name="schedule_url" value="#fusebox.server_machine_list#/#request.self#?fuseaction=schedules.emptypopup_schedule_action" style="width:225px;">
            </td>
            <td><cf_get_lang dictionary_id='90.Bitiş'></td>
            <td>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='2326.Bitiş Tarihini Kontrol Ediniz '></cfsavecontent>
                <cfinput type="text" name="finishdate" style="width:80px;" validate="#validate_style#" value="" message="#message#">
                <cf_wrk_date_image date_field="finishdate">
                 <cf_wrkTimeFormat name="finish_clock" value="">				
            </td>
        </tr>
        <tr>
            <td></td>
            <cfif attributes.is_pos_operation eq 0>
                <td valign="top">
                    <cfoutput>
                    <select name="currency_schedule" id="currency_schedule" style="width:225px" onChange="change_currency_info();">
                        <option value=""><cf_get_lang dictionary_id='3191.Görev Seçiniz'></option>
                        <option value="#fusebox.server_machine_list#/#request.self#?fuseaction=schedules.emptypopup_hourly"><cf_get_lang dictionary_id='1479.Piyasalarda Kurlar Gösterilsin'></option>
                        <option value="#fusebox.server_machine_list#/#request.self#?fuseaction=schedules.emptypopup_import_currency"><cf_get_lang dictionary_id='1485.Piyasalardaki Kurlar Sistem Kurlarını Güncellesin'></option>
                        <option value="#fusebox.server_machine_list#/#request.self#?fuseaction=schedules.emptypopup_upd_currency_info"><cf_get_lang dictionary_id='1542.İleri Tarihli Kurlar Sistem Kurlarını Güncellesin'></option>
                        <option value="#fusebox.server_machine_list#/#request.self#?fuseaction=schedules.emptypopup_get_social_media_info"><cf_get_lang dictionary_id='3192.Sosyal Medya Güncellensin'></option>
                        <option value="#fusebox.server_machine_list#/#request.self#?fuseaction=schedules.emptypopup_upd_warning_confirm_actions">Onaylardaki Güncellemeler Belgeleri Güncellesin</option>
                        <option value="#fusebox.server_machine_list#/#request.self#?fuseaction=bank.emptypopup_wodiba_api_accounts"><cf_get_lang dictionary_id='1863.WoDiBa Banka Bakiyelerini Güncelle'></option>
                        <option value="#fusebox.server_machine_list#/#request.self#?fuseaction=bank.emptypopup_wodiba_api_actions"><cf_get_lang dictionary_id='1938.WoDiBa Banka Hareketlerini Güncelle'></option>
                        <option value="#fusebox.server_machine_list#/#request.self#?fuseaction=bank.emptypopup_wodiba_process_actions"><cf_get_lang dictionary_id='2043.WoDiBa Banka Hareketlerini Sisteme Kaydet'></option>
                    </select>
                    </cfoutput>
                </td>
            <cfelse>
                <td></td>
            </cfif>
            <td valign="top"><cf_get_lang dictionary_id='691.Periyot'></td>
            <td rowspan="3" valign="top">
            <table>
                <tr>
                    <td><input type="radio" name="ScheduleType" id="ScheduleType1" value="Once"></td>
                    <td nowrap><cf_get_lang dictionary_id='763.Bir Defa'>&nbsp;&nbsp;</td>
                    <td>
                        
                         <cf_wrkTimeFormat name="Once_Hour" value="">	
                        <select name="Once_Minute" id="Once_Minute">
                            <option value="00" selected> <cf_get_lang dictionary_id='715.Dakika'></option>
                            <cfloop from="1" to="59" index="i">
                                <cfoutput><option value="#i#">#i#</option></cfoutput>
                            </cfloop>
                        </select>	
                        																			
                    </td>			
                </tr>
                <tr>
                    <td height="8" colspan="3"><hr size="1" noshade></td>
                </tr>
                <tr>
                    <td><input type="Radio" name="ScheduleType" id="ScheduleType2" value="Recurring" checked></td>
                    <td nowrap><cf_get_lang dictionary_id='764.Yinelenerek'>&nbsp;&nbsp;</td>
                    <td>
                        <select name="Interval" id="Interval">
                            <option value="Daily"><cf_get_lang dictionary_id='1045.Gunluk'></option>
                            <option value="Weekly"><cf_get_lang dictionary_id='1046.Haftalik'></option>
                            <option value="Monthly"><cf_get_lang dictionary_id='1520.Aylik'></option>
                        </select>
                        &nbsp;&nbsp;&nbsp;													
                      
                         <cf_wrkTimeFormat name="Recurring_Hour" value="">
                        <select name="Recurring_Minute" id="Recurring_Minute">
                            <option value="00" selected><cf_get_lang dictionary_id='715.Dakika'></option>
                            <cfloop from="1" to="59" index="i">
                                <cfoutput><option value="#i#">#i#</option></cfoutput>
                            </cfloop>
                        </select>										
                    </td>
                </tr>
                <tr>
                    <td height="8" colspan="3"><hr size="1" noshade></td>
                </tr>
                <tr>
                    <td><input type="Radio" name="ScheduleType" id="ScheduleType3" value="Custom"></td>
                    <td><cf_get_lang dictionary_id='844.Gunluk Her'></td>
                    <td>
                        <cfinput name="customInterval_hour" id="customInterval_hour" type="text" maxlength="2" validate="integer" range="0,23" style="width:25px;">
                        &nbsp;<cf_get_lang dictionary_id='79.Saat'>
                        &nbsp;
                        <cfinput name="customInterval_min" id="customInterval_min" type="text" maxlength="2" validate="integer" range="0,59" style="width:25px;">
                        &nbsp;<cf_get_lang dictionary_id='715.Dakika'>
                        &nbsp;
                        <cfinput name="customInterval_sec" id="customInterval_sec" type="text" maxlength="2" validate="integer" range="0,59" style="width:25px;">
                        <cf_get_lang dictionary_id='845.Saniye'>
                    </td>
                </tr>						
            </table>			
            </td>
        </tr>
        <tr>
            <td valign="top"><cf_get_lang dictionary_id='217.Açıklama'></td>
            <td valign="top"><textarea name="detail" id="detail" style="width:225px;height:45px;" value=""></textarea></td>
            <td></td>
        </tr>	
        <cfif attributes.is_pos_operation eq 0>	  
            <tr height="35">
                <td><cf_get_lang dictionary_id='1494 .İlişkili Şirket'></td>
                <td>
                <cf_multiselect_check
                 name="our_company_ids"
                 option_name="nick_name"
                 option_value="comp_id"
                 table_name="OUR_COMPANY"
                 width="225">
                </td>
                <td></td>
            </tr>
        <cfelse>
            <tr><td colspan="2"></td></tr>
        </cfif>
        <tr>
            <cfif attributes.is_pos_operation eq 1>
                <td colspan="2">
                    <cf_form_list>
                        <thead>
                            <tr>
                                <th><input type="button" class="eklebuton" title="" onClick="add_row();"></th>
                                <th style="width:50px;">&nbsp;Sıra *</th>
                                <th style="width:160px;">&nbsp;Kural *</th>
                            </tr>
                        </thead>
                        <tbody id="link_table">
                            <input name="record_num" id="record_num" type="hidden" value="0">
                            <input name="is_pos_operation" id="is_pos_operation" type="hidden" value="1">
                        </tbody>
                    </cf_form_list>	
                    <br />
                </td>
            <cfelse>
                <td colspan="2"></td>
            </tr></cfif>
        
    </table> --->
<script type="text/javascript">
	row_count = 0;
	function sil(sy)
	{
		var my_element=eval("document.add_schedule.row_kontrol_"+sy);
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
		document.add_schedule.record_num.value=row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="row_kontrol_'+ row_count +'" value="1" /><a style="cursor:pointer" onclick="sil(' + row_count + ');" ><img src="images/delete_list.gif" border="0"></a>';	
		newCell= newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="pos_line_'+ row_count +'" id="pos_line_'+ row_count +'" value="" style="width:50px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML= '<select name="pos_operation_id_'+ row_count +'" style="width:150px;"><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option><cfoutput query="get_pos_operation"><option value="#get_pos_operation.pos_operation_id#">#get_pos_operation.pos_operation_name#</option></cfoutput></select>';
	}
	function change_currency_info()//kurlarla ilgili fuseaction ları URL input una taşır
	{
		x = document.add_schedule.currency_schedule.selectedIndex;
		if (document.add_schedule.currency_schedule[x].value != ""){
			document.add_schedule.schedule_url.value = document.add_schedule.currency_schedule[x].value;
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
			document.add_schedule.schedule_url.value = '<cfoutput>#fusebox.server_machine_list#/#request.self#?fuseaction=schedules.emptypopup_schedule_action</cfoutput>';
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">