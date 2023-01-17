<cfif isDefined("attributes.date")><cf_date tarih="attributes.date"></cfif>
<cfquery name="GET_EVENT_CATS" datasource="#DSN#">
	SELECT
		*
	FROM
		EVENT_CAT
	ORDER BY
		EVENTCAT
</cfquery>
<cfset url_string="">
<cfif isdefined("attributes.action_id") and len(attributes.action_id)>
	<cfset url_string="#url_string#&action_id=#attributes.action_id#">
</cfif>
<cfif isdefined("attributes.action_section") and len(attributes.action_section)>
	<cfset url_string="#url_string#&action_section=#attributes.action_section#">
</cfif>
<!--- 20051219 eğer sayfaya empapp_id yollanırsa olay eklerken onuda kaydediyor ve başlığa özgeçmişin adını yazıyor--->
<cfif isdefined("attributes.empapp_id") and len(attributes.empapp_id)>
	<cfset url_string="#url_string#&empapp_id=#attributes.empapp_id#">
	<cfquery name="GET_EMPAPP" datasource="#DSN#">
		SELECT
			NAME,
			SURNAME
		FROM
			EMPLOYEES_APP
		WHERE
			EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.empapp_id#">
	</cfquery>
</cfif>
<cfform name="add_event" method="post" action="#request.self#?fuseaction=objects.emptypopup_add_event#url_string#">
<table width="100%" border="0" cellspacing="0" cellpadding="0"  height="100%">
  <tr clasS="color-border">
	<td>
	<table width="100%" border="0" cellspacing="1" cellpadding="2" height="100%">
	  <tr class="color-list">
		<td colspan="2" height="35" class="headbold"><cf_get_lang no='624.Olay Ekle'> </td>
	  </tr>
	  <tr class="color-row">
		<td valign="top">
		<table border="0" width="430">
		  <tr>
          	<td width="75">Time Zone *</td>
			<td colspan="3">
			  <cfif isdefined("session.ep.time_zone")>
				<cfset my_time_zone = session.ep.time_zone>
			  <cfelse>
				<cfset my_time_zone = session.pp.time_zone>
			  </cfif>
			  <select name="time_zone" id="time_zone" style="width:100%">
				  <option value="-12" <cfif my_time_zone eq -12>selected</cfif>>(GMT-12:00) International Date Line West</option>
				  <option value="-11" <cfif my_time_zone eq -11>selected</cfif>>(GMT-11:00) Midway Island, Samoa</option>
				  <option value="-10" <cfif my_time_zone eq -10>selected</cfif>>(GMT-10:00) Hawaii</option>
				  <option value="-9"  <cfif my_time_zone eq -9> selected</cfif>>(GMT-09:00) Alaska</option>
				  <option value="-8"  <cfif my_time_zone eq -8> selected</cfif>>(GMT-08:00) Pacific Time (US & Canada); Tijuana</option>
				  <option value="-7"  <cfif my_time_zone eq -7> selected</cfif>>(GMT-07:00) Mountain Time (US & Canada)</option>
				  <option value="-6"  <cfif my_time_zone eq -6> selected</cfif>>(GMT-06:00) Saskatchewan</option>
				  <option value="-5"  <cfif my_time_zone eq -5> selected</cfif>>(GMT-05:00) Eastern Time (US & Canada)</option>
				  <option value="-4"  <cfif my_time_zone eq -4> selected</cfif>>(GMT-04:00) Atlantic Time (Canada)</option>
				  <option value="-3"  <cfif my_time_zone eq -3> selected</cfif>>(GMT-03:00) Greenland</option>
				  <option value="-2"  <cfif my_time_zone eq -2> selected</cfif>>(GMT-02:00) Mid-Atlantic</option>
				  <option value="-1"  <cfif my_time_zone eq -1> selected</cfif>>(GMT-01:00) Azores</option>
				  <option value="0"   <cfif my_time_zone eq 0>  selected</cfif>>(GMT) Greenwich Mean Time : Dublin, Edinburgh, Lisbon, London</option>
				  <option value="+1"  <cfif my_time_zone eq +1> selected</cfif>>(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna</option>
				  <option value="+2"  <cfif my_time_zone eq +2> selected</cfif>>(GMT+02:00) Athens, Istanbul, Minsk</option>
				  <option value="+3"  <cfif my_time_zone eq +3> selected</cfif>>(GMT+03:00) Moscow, St. Petersburg, Volgograd</option>
				  <option value="+4"  <cfif my_time_zone eq +4> selected</cfif>>(GMT+04:00) Baku, Tbilisi, Yerevan</option>
				  <option value="+5"  <cfif my_time_zone eq +5> selected</cfif>>(GMT+05:00) Islamabad, Karachi, Tashkent</option>
				  <option value="+6"  <cfif my_time_zone eq +6> selected</cfif>>(GMT+06:00) Almaty, Novosibirsk</option>
				  <option value="+7"  <cfif my_time_zone eq +7> selected</cfif>>(GMT+07:00) Bangkok, Hanoi, Jakarta</option>
				  <option value="+8"  <cfif my_time_zone eq +8> selected</cfif>>(GMT+08:00) Beijing, Chongqing, Hong Kong, Urumqi</option>
				  <option value="+9"  <cfif my_time_zone eq +9> selected</cfif>>(GMT+09:00) Osaka, Sapporo, Tokyo</option>
				  <option value="+10" <cfif my_time_zone eq +10>selected</cfif>>(GMT+10:00) Canberra, Melbourne, Sydney</option>
				  <option value="+11" <cfif my_time_zone eq +11>selected</cfif>>(GMT+11:00) Magadan, Solomon Is., New Caledonia</option>
				  <option value="+12" <cfif my_time_zone eq +12>selected</cfif>>(GMT+12:00) Fiji, Kamchatka, Marshall Is.</option>
				  <option value="+13" <cfif my_time_zone eq +13>selected</cfif>>(GMT+13:00) Nuku'alofa</option>
			  </select>
			</td>
		  </tr>
		  <tr>
			<td><cf_get_lang_main no='74.Kategori'> *</td>
			<td colspan="3">
			  <select name="eventcat_ID" id="eventcat_ID" style="width:100%">
                  <option value="0" selected><cf_get_lang_main no ='322.Seçiniz'></option>
                  <cfoutput query="get_event_cats">
                    <option value="#eventcat_ID#">#eventcat#</option>
                  </cfoutput>
			  </select>
			</td>
		  </tr>
		  <tr>
			<td><cf_get_lang_main no='89.Başlama'> *</td>
			<td width="195">
			  <cfsavecontent variable="message"><cf_get_lang no='8.Başlama girmelisiniz'></cfsavecontent>
			  <cfif isDefined("attributes.date")>
				<cfinput maxlength="10" required="Yes" validate="eurodate" message="#message#" type="text" name="startdate" value="#dateformat(attributes.date,'dd/mm/yyyy')#" style="width:65px;">
			  <cfelse>
				<cfinput maxlength="10" required="Yes" validate="eurodate" message="#message#" type="text" name="startdate" style="width:65px;" value="#dateformat(NOW(),'DD/MM/YYYY')#">
			  </cfif>
			  <cf_wrk_date_image date_field="startdate">
			</td>
			<td><cf_get_lang_main no='79.Saat'>/<cf_get_lang no='595.Dk'>:</td>
			<td>
                <select name="event_start_clock" id="event_start_clock">
                    <option value="0" selected><cf_get_lang_main no='79.Saat'></option>
                    <cfloop from="7" to="30" index="i">
                    <cfset saat=i mod 24>
                    	<option value="<cfoutput>#saat#</cfoutput>" <cfif isDefined("attributes.hour")><cfif attributes.hour eq saat>selected</cfif></cfif>><cfoutput>#saat#</cfoutput></option>
                    </cfloop>
                </select>
				<select name="event_start_minute" id="event_start_minute">
				  <option value="00" selected>00</option>
				  <option value="05">05</option>
				  <option value="10">10</option>
				  <option value="15">15</option>
				  <option value="20">20</option>
				  <option value="25">25</option>
				  <option value="30">30</option>
				  <option value="35">35</option>
				  <option value="40">40</option>
				  <option value="45">45</option>
				  <option value="50">50</option>
				  <option value="55">55</option>
				</select>
			</td>
		  </tr>
		  <tr>
			<td><cf_get_lang_main no='90.Bitiş'> *</td>
			<td>
			  <cfsavecontent variable="message2"><cf_get_lang no='9.Bitiş girmelisiniz'></cfsavecontent>
			  <cfif isDefined("attributes.date")>			    
			    <cfinput maxlength="10" type="text" name="finishdate" required="Yes" message="#message2#" validate="eurodate" value="#dateformat(attributes.date,'dd/mm/yyyy')#" style="width:65px;">
			  <cfelse>
			 	<cfinput maxlength="10" type="text" name="finishdate" required="Yes" message="#message2#" validate="eurodate" style="width:65px;" value="#dateformat(NOW(),'DD/MM/YYYY')#">
			  </cfif>
			  <cf_wrk_date_image date_field="finishdate">
			</td>
			<td><cf_get_lang_main no='79.Saat'>/<cf_get_lang no='595.Dk'>:</td>
			<td>
			  <select name="event_finish_clock" id="event_finish_clock">
                  <option value="0" selected><cf_get_lang_main no='79.Saat'></option>
                  <cfloop from="7" to="30" index="i">
                    <cfset saat=i mod 24>
                    <option value="<cfoutput>#saat#</cfoutput>" <cfif isDefined("attributes.hour")><cfif attributes.hour eq saat>selected</cfif></cfif>><cfoutput>#saat#</cfoutput></option>
                  </cfloop>
			  </select>
			  <select name="event_finish_minute" id="event_finish_minute">
				<option value="00" selected>00</option>
				<option value="05">05</option>
				<option value="10">10</option>
				<option value="15">15</option>
				<option value="20">20</option>
				<option value="25">25</option>
				<option value="30" <cfif isDefined("attributes.hour")>selected</cfif>>30</option>
				<option value="35">35</option>
				<option value="40">40</option>
				<option value="45">45</option>
				<option value="50">50</option>
				<option value="55">55</option>
			  </select>
			</td>
		  </tr>
		  <tr>
			<td><cf_get_lang_main no='68.Başlık'> *</td>
			<td colspan="3">				
			  <cfsavecontent variable="message"><cf_get_lang no='14.Başlık girmelisiniz'></cfsavecontent>
			  <cfif isdefined("attributes.empapp_id") and len(attributes.empapp_id) and get_empapp.recordcount>
			  	<cfinput type="text" name="EVENT_HEAD" style="width:100%" required="Yes" message="#message#" value="(#get_empapp.name# #get_empapp.surname# iş görüşmesi)">
			  <cfelse>
			  	<cfinput type="text" name="EVENT_HEAD" style="width:100%" required="Yes" message="#message#">
			  </cfif>
			</td>
		  </tr>
		  <tr>
			<td valign="top"><cf_get_lang_main no='217.açıklama'></td>
			<td colspan="3"><textarea name="event_detail" id="event_detail" style="width:100%;height:100px;"></textarea></td>
		  </tr>
		  <tr>
			<td><cf_get_lang_main no='88.Onay'></td>
			<td colspan="3">
			  <input type="hidden" name="validator_id" id="validator_id" value="">
			  <input type="hidden" name="validator_type" id="validator_type" value="">
			  <input type="text" name="validator" id="validator" value="" style="width:325px;">
			  <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_event.validator_id&field_id=add_event.validator_id&field_name=add_event.validator&field_type=add_event.validator_type','list');"><img src="/images/plus_list.gif" align="absmiddle" border="0"></a>
			</td>
		  </tr>
		    <input type="hidden" name="tos" id="tos" value="">
			<input type="hidden" name="ccs" id="ccs" value="">
		  <tr>
			<td></td>
			<td colspan="3">
			  <cfsavecontent variable="txt_1" ><cf_get_lang no='758.Bilgi Verilecekler'></cfsavecontent>
			  <cfsavecontent variable="txt_2"><cf_get_lang_main no='178.Katılımcılar'></cfsavecontent>
			  <cf_workcube_to_cc is_update="0" to_dsp_name="#txt_2#" cc_dsp_name="#txt_1#" form_name="add_event" str_list_param="1,7,8" data_type="1">
			</td>
		  </tr> 
		  <tr>
			<td></td>
			<td colspan="3"><img src="/images/cizgi_yan_50.gif" width="100%" height="15"></td>
		  </tr>
			<input type="hidden" name="reserve" id="reserve" value="">
		  <tr>
			<td height="35" colspan="4" align="right" style="text-align:right;"><cf_workcube_buttons is_upd='0' add_function='check()'></td>
		  </tr>
		</table>
		</td>
		<td valign="top">
		<table>
		  <tr>
			<td><cf_get_lang no='759.Uyarı Başlat'></td>
			<td colspan="4">
			<cfsavecontent variable="alert"><cf_get_lang_main no ='326.Uyarı Başlangıç Tarihi'></cfsavecontent>
			  <cfinput type="text" name="warning_start" style="width:75px;" value="" validate="eurodate" message="#alert#">
			  <cf_wrk_date_image date_field="warning_start">
			</td>
		  </tr>
		  <tr>
		  	<td><cf_get_lang no ='1413.Olay Yeri'></td>
			  <td><select name="event_place" id="event_place" style="width:85px;">
                    <option value="" selected><cf_get_lang_main no ='322.Seçiniz'></option>
                    <option value="1"><cf_get_lang no ='740.Ofis İçi'></option>
                    <option value="2"><cf_get_lang no ='741.Ofis Dışı'></option>
                    <option value="3">3.<cf_get_lang no ='1414.Parti Kurum'></option>
				</select>
              </td>
		  </tr>
		  <tr>
			<td><cf_get_lang no='600.EMail Uyarı'></td>
			<td>
			  <select name="email_alert_day" id="email_alert_day" style="width:75px;">
				<option value="0" selected><cf_get_lang no='760.Kaç'></option>
				<option value="1">1</option>
				<option value="2">2</option>
				<option value="3">3</option>
				<option value="4">4</option>
				<option value="5">5</option>
				<option value="6">6</option>
				<option value="7">7</option>
				<option value="10">10</option>
				<option value="15">15</option>
				<option value="30">30</option>
				<option value="60">60</option>
				<option value="90">90</option>
			  </select>
			</td>
			<td><cf_get_lang_main no='78.Gün'></td>
			<td>
			  <select name="email_alert_hour" id="email_alert_hour" style="width:55px;">
				<option value="0" selected><cf_get_lang no='760.Kaç'></option>
				<option value="0.25">15 <cf_get_lang no='595.dk'></option>
				<option value="0.5">30 <cf_get_lang no='595.dk'></option>
				<option value="1">1</option>
				<option value="2">2</option>
				<option value="3">3</option>
				<option value="4">4</option>
				<option value="5">5</option>
				<option value="6">6</option>
				<option value="7">7</option>
				<option value="8">8</option>
				<option value="9">9</option>
				<option value="10">10</option>
				<option value="12">12</option>
				<option value="16">16</option>
				<option value="18">18</option>
			  </select>
			</td>
			<td><cf_get_lang no='761.Saat Önce'></td>
		  </tr>
		  <tr>
			<td><cf_get_lang no='599.SMS Uyarı'></td>
			<td>
			  <select name="sms_alert_day" id="sms_alert_day" style="width:75px;">
				<option value="0" selected><cf_get_lang no='760.Kaç'></option>
				<option value="1">1</option>
				<option value="2">2</option>
				<option value="3">3</option>
				<option value="4">4</option>
				<option value="5">5</option>
				<option value="6">6</option>
				<option value="7">7</option>
				<option value="10">10</option>
				<option value="15">15</option>
				<option value="30">30</option>
				<option value="60">60</option>
				<option value="90">90</option>
			  </select>
			</td>
			<td><cf_get_lang_main no='78.Gün'></td>
			<td>
			  <select name="sms_alert_hour" id="sms_alert_hour" style="width:55px;">
			  	<option value="0" selected><cf_get_lang no='760.Kaç'></option>
				<option value="0.25">15 <cf_get_lang no='595.dk'></option>
				<option value="0.5">30 <cf_get_lang no='595.dk'></option>
				<option value="1">1</option>
				<option value="2">2</option>
				<option value="3">3</option>
				<option value="4">4</option>
				<option value="5">5</option>
				<option value="6">6</option>
				<option value="7">7</option>
				<option value="8">8</option>
				<option value="9">9</option>
				<option value="10">10</option>
				<option value="12">12</option>
				<option value="16">16</option>
				<option value="18">18</option>
			  </select>
			</td>
			  <td><cf_get_lang no='761.Saat Önce'></td>
			</tr>
			<tr>
			  <td><cf_get_lang no='773.Olay Tekrar'></td>
			  <td colspan="5">
				<select name="warning" id="warning" onChange="show_warn(this.selectedIndex);" style="width:75">
				  <option value="0" selected><cf_get_lang_main no='1134.Yok'></option>
				  <option value="1"><cf_get_lang no='763.Periodik'></option>
				</select>
			  </td>
			</tr>
			<tr id="warn_multiple">
			  <td><cf_get_lang no='764.Tekrar'></td>
			  <td colspan="4">
			    <input type="radio" name="warning_type" id="warning_type" value="7"><cf_get_lang no='765.Haftada Bir'>
				<input type="radio" name="warning_type" id="warning_type" value="30"><cf_get_lang no='766.Ayda Bir'></td>
			</tr>
			<tr id="warn_multiple2">
			  <td><cf_get_lang no='767.Tekrar Sayısı'></td>
			  <td colspan="4">
				<cfsavecontent variable="message"><cf_get_lang no='768.Tekrar Sayısı girmelisiniz'></cfsavecontent>
				<cfinput type="text" name="warning_count" passThrough="onkeyup=""return(FormatCurrency(this,event,0));""" value="" validate="integer" message="#message#" class="moneybox" maxlength="2" style="width:50px;"> 
				<cf_get_lang no='769.kez'></td>
			</tr>
			<tr>
			  <td align="right" style="text-align:right;"></td>
			  <td colspan="4" class="txtbold"><input type="checkbox" name="VIEW_TO_ALL" id="VIEW_TO_ALL" value="1" ><cf_get_lang no='774.Bu Olayı Herkes Görsün'></td>
			</tr>
			<tr>
			  <td align="right" style="text-align:right;"></td>
			  <td colspan="4" class="txtbold">
				<input type="Checkbox" name="EMAIL" id="EMAIL" value="1" >
				<cf_get_lang no ='1415.Kişiye Email Gönder'>
			  </td>
		    </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</cfform>
<script type="text/javascript">
function check()
{
	if (document.add_event.eventcat_ID.value == 0)
	{ 
		alert("<cf_get_lang no ='686.Olay Kategorisi Seçiniz'> !");
		return false;
	}

	if(document.add_event.warning.selectedIndex == 1)
		if(document.add_event.warning_count.value == "")
		{
			alert("<cf_get_lang no ='702.Tekrar Sayısı'> !");
			return false;
		}
		if(document.add_event.warning_count.value != "")
			if(document.add_event.warning_count.value < 2)
			{
				alert("<cf_get_lang no ='707.Tekrar Sayısı 1 den Büyük Olmalı'> !")
				return false;
			}
			if(document.add_event.warning.selectedIndex == 1)
			{
				if(document.add_event.warning_count.value != "")
					if(document.add_event.warning_count.value < 2)
					{
						alert("<cf_get_lang no ='707.Tekrar Sayısı 1 den Büyük Olmalı'> !")
						return false;
					}
		if (!((document.add_event.warning_type[0].status) || (document.add_event.warning_type[1].status) ))
		{
			alert("<cf_get_lang no ='708.Tekrar Periyodu'> !");
			return false;
		}
	}
	if ( (add_event.startdate.value != "") && (add_event.finishdate.value != "") )
		return time_check(add_event.startdate, add_event.event_start_clock, add_event.event_start_minute, add_event.finishdate,  add_event.event_finish_clock, add_event.event_finish_minute, "<cf_get_lang no ='743.Olay Başlama Tarihi Bitiş Tarihinden Once Olmalıdır'> !");

	if ( (add_event.warning_start.value != "") && (add_event.startdate.value != "") )
		return date_check(add_event.warning_start,add_event.startdate,"<cf_get_lang no ='709.Uyarı Tarihi Olay Başlama Tarihinden Önce Olmalıdır'>!");
	return true;
}

function show_warn(i)
{
/*uyari var*/
	if(i == 0)
		{
		/*tek uyari acik*/
		warn_multiple.style.display = 'none';
		warn_multiple2.style.display = 'none';
		}
	if(i == 1)
		{
		/*coklu uyari acik*/
		warn_multiple.style.display = '';
		warn_multiple2.style.display = '';
		}
}
	show_warn(0);

add_event_popup(window.opener.event_name,window.opener.event_emp_id,window.opener.event_pos_id,window.opener.event_pos_code,window.opener.event_cons_ids,window.opener.event_comp_ids,window.opener.event_par_ids,window.opener.event_grp_ids,window.opener.event_wgrp_ids,window.opener.event_add_type)

function add_event_popup(str_ekle,int_id,int_id2,int_id3,int_id4,int_id5,int_id6,int_id7,int_id8,add_type)
{
if (add_type>0 && add_type<4)
	{
	var newRow;
	var newCell;
	rowCount = document.all.tbl_to_names_row_count.value;
	newRow = document.getElementById("tbl_to_names").insertRow(document.getElementById("tbl_to_names").rows.length);
	newRow.setAttribute("name","workcube_to_row" + rowCount);
	newRow.setAttribute("id","workcube_to_row" + rowCount);		
	newRow.setAttribute("style","display:''");	
	newCell = newRow.insertCell();
	str_html = '';
	/*calisanlar*/
	if(add_type==1){
		str_html = str_html + '<input type="hidden" name="to_emp_ids" value="' + int_id + '">	<input type="hidden" name="to_pos_ids" value="' + int_id2 + '">';	
		str_html = str_html + '<input type="hidden" name="to_pos_codes" value="' + int_id3 + '">';	
		str_html = str_html + '<input type="hidden" name="to_cons_ids" value="">'
		str_html = str_html +'<input type="hidden" name="to_grp_ids" value=""><input type="hidden" name="to_wgrp_ids" value="">';
	}
	/*kurumsal*/
	if(add_type==2){
		str_html = str_html + '<input type="hidden" name="to_emp_ids" value="">	<input type="hidden" name="to_pos_ids" value="">';	
		str_html = str_html + '<input type="hidden" name="to_pos_codes" value="">';	
		str_html = str_html + '<input type="hidden" name="to_comp_ids" value="' + int_id5 + '"><input type="hidden" name="to_par_ids" value="' + int_id6 + '">';	
		str_html = str_html + '<input type="hidden" name="to_cons_ids" value="">'	
		str_html = str_html +'<input type="hidden" name="to_grp_ids" value=""><input type="hidden" name="to_wgrp_ids" value="">';
	}
	/*bireysel*/
	if(add_type==3){
		str_html = str_html + '<input type="hidden" name="to_emp_ids" value="">	<input type="hidden" name="to_pos_ids" value="">';	
		str_html = str_html + '<input type="hidden" name="to_pos_codes" value="">';	
		str_html = str_html + '<input type="hidden" name="to_cons_ids" value="' + int_id4 + '">'
		str_html = str_html +'<input type="hidden" name="to_grp_ids" value=""><input type="hidden" name="to_wgrp_ids" value="">';
	}
	
	if(add_type==1){
		str_del = '<a href="javascript://" onClick="workcube_to_delRow(' + rowCount +');"><img src="/images/delete_list.gif"  align="absmiddle" border="0"></a>&nbsp;';	
	}
	if(add_type==2){
		str_del='<a href="javascript://" onClick="workcube_to_delRow(' + rowCount +');"><img src="/images/delete_list.gif"  align="absmiddle" border="0"></a>&nbsp;';
	}
	if(add_type==3){
		str_del='<a href="javascript://" onClick="workcube_to_delRow(' + rowCount +');"><img src="/images/delete_list.gif"  align="absmiddle" border="0"></a>&nbsp;';	
	}
	
	newCell.innerHTML = str_del + str_html + str_ekle;
	}
	return 1;
}
</script>
