 <cfif isdefined("attributes.is_form_submitted")>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<cfparam name="attributes.is_chief_valid" default="">
<cfsavecontent variable="ocak"><cf_get_lang_main no='180.Ocak'></cfsavecontent> 
<cfsavecontent variable="subat"><cf_get_lang_main no='181.şubat'></cfsavecontent> 
<cfsavecontent variable="mart"><cf_get_lang_main no='182.mart'></cfsavecontent> 
<cfsavecontent variable="nisan"><cf_get_lang_main no='183.nisan'></cfsavecontent> 
<cfsavecontent variable="mayis"><cf_get_lang_main no='184.mayıs'></cfsavecontent> 
<cfsavecontent variable="haziran"><cf_get_lang_main no='185.haziran'></cfsavecontent> 
<cfsavecontent variable="temmuz"><cf_get_lang_main no='186.temmuz'></cfsavecontent> 
<cfsavecontent variable="agustos"><cf_get_lang_main no='187.ağustos'></cfsavecontent> 
<cfsavecontent variable="eylul"><cf_get_lang_main no='188.eylül'></cfsavecontent> 
<cfsavecontent variable="ekim"><cf_get_lang_main no='189.ekim'></cfsavecontent> 
<cfsavecontent variable="kasim"><cf_get_lang_main no='190.kasım'></cfsavecontent> 
<cfsavecontent variable="aralik"><cf_get_lang_main no='191.aralık'></cfsavecontent>
<cfset my_month_list="#ocak#,#subat#,#mart#,#nisan#,#mayis#,#haziran#,#temmuz#,#agustos#,#eylul#,#ekim#,#kasim#,#aralik#">
<cfquery name="get_upper_position_code" datasource="#dsn#">
	SELECT 
		POSITION_CODE,
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME,
		EMPLOYEE_ID
	FROM
		EMPLOYEE_POSITIONS
	WHERE
		UPPER_POSITION_CODE = #session.ep.position_code#
</cfquery>
<cfset employee_id_list = listsort(valuelist(get_upper_position_code.employee_id,','),"numeric")>
<cfset kayit = 0>
<cfif len(employee_id_list)>
<cfquery name="get_list_training_request" datasource="#dsn#">
	SELECT
		TRR.*,
		TC.START_DATE,
		TC.FINISH_DATE
	FROM
		TRAINING_REQUEST_ROWS TRR,
		TRAINING_CLASS TC
	WHERE
		TRR.EMPLOYEE_ID IN (#employee_id_list#)
		AND TRR.CLASS_ID IS NOT NULL
		AND TRR.CLASS_ID = TC.CLASS_ID
		<cfif len(attributes.is_chief_valid)>
			AND TRR.IS_CHIEF_VALID = #attributes.is_chief_valid#
		</cfif>
	ORDER BY TRR.CLASS_ID
</cfquery>
<cfset kayit = get_list_training_request.recordcount>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#kayit#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset url_str = "">
<cfif isdefined("attributes.is_chief_valid")>
	<cfset url_str = "#url_str#&is_chief_valid=#attributes.is_chief_valid#">
</cfif>
<cfif isdefined("attributes.is_form_submitted")>
	<cfset url_str = "#url_str#&is_form_submitted=#attributes.is_form_submitted#">
</cfif>
<cfform name="search" method="post" action="#request.self#?fuseaction=training.list_class_valid">
<cf_big_list_search title="#getLang('training',183)#"> 
	<cf_big_list_search_area>
		<table>
			<cfinput type="hidden" name="is_form_submitted" value="1">
			<td><cf_get_lang_main no='48.Filtre'></td>
			<td>
				<select name="is_chief_valid" id="is_chief_valid">
                    <option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
                    <option value="1" <cfif attributes.is_chief_valid eq 1>selected</cfif>><cf_get_lang no='126.Onayladıklarım'>
                    <option value="0" <cfif attributes.is_chief_valid eq 0>selected</cfif>><cf_get_lang no='127.Onay Bekleyen'>
                    <option value="-1" <cfif attributes.is_chief_valid eq -1>selected</cfif>><cf_get_lang no='128.Reddedilen'>
				</select>
			</td>
			<td>
				<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyup="isNumber (this)" style="width:25px;">
			</td>
			<td><cf_wrk_search_button></td>
		</table>
	</cf_big_list_search_area>
</cf_big_list_search> 
</cfform>
<cf_big_list>
	<thead>
		<tr>
			<th width="30"><cf_get_lang_main no='1165.Sıra'></th>
			<th><cf_get_lang no ='72.Eğitim Adı'></th>
			<th><cf_get_lang no ='94.Eğitim Tarihi'></th>
			<th><cf_get_lang no ='95.Talep Tarihi'></th>
			<th><cf_get_lang_main no='158.Ad Soyad'></th>
			<th><cf_get_lang_main no='88.Onay'></th>
			<th><cf_get_lang_main no='330.Tarih'></th>
			<th class="header_icn_none" nowrap="nowrap"><cf_get_lang no ='184.Onay Ve Red'></th><!-- sil -->
		</tr>
	</thead>
	<tbody>
		<cfif isdefined("get_list_training_request") and get_list_training_request.recordcount>
			<cfoutput query="get_list_training_request" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td>#currentrow#</td>
					<td>
				<cfif len(CLASS_ID)>
					<cfquery name="get_class_name" datasource="#dsn#">
						SELECT CLASS_NAME FROM TRAINING_CLASS WHERE CLASS_ID = #CLASS_ID#
					</cfquery>
					#get_class_name.CLASS_NAME#
				</cfif>
					</td>
					<td>
				<cfif len(start_date) and start_date gt '1/1/1900' and len(finish_date) and finish_date gt '1/1/1900'>
					<cfif dateformat(start_date,dateformat_style) eq dateformat(now(),dateformat_style) or dateformat(finish_date,dateformat_style) eq dateformat(now(),dateformat_style) >
					<font  color="##FF0000"> </cfif>
					  <cfset startdate = date_add('h', session.ep.time_zone, start_date)>
					  <cfset finishdate = date_add('h', session.ep.time_zone, finish_date)>
					  #dateformat(startdate,dateformat_style)# (#timeformat(startdate,timeformat_style)#) - #dateformat(finishdate,dateformat_style)# (#timeformat(finishdate,timeformat_style)#) 
					<cfelseif len(MONTH_ID) and MONTH_ID>
						#ListGetAt(my_month_list,MONTH_ID)# - #SESSION.EP.PERIOD_YEAR#
				</cfif>
					</td>
					<td>#dateformat(RECORD_DATE,dateformat_style)#</td>
					<td>#get_emp_info(employee_id,0,1)#</td>
					<td><cfif is_chief_valid eq 0><cf_get_lang_main no='203.Bekliyor'><cfelseif is_chief_valid eq 1><cf_get_lang_main no='1287.Onaylandı'><cfelseif is_chief_valid eq -1><cf_get_lang_main no='205.Reddedildi'></cfif></td>
					<td>#dateformat(chief_valid_date,dateformat_style)#</td>
					 <!-- sil -->
					 <td align="center">
				<cfif is_chief_valid is "" or is_chief_valid eq 0>
					<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training.emptypopup_upd_valid&request_row_id=#request_row_id#&valid_type=1','small');"><input type="Image" src="/images/valid.gif" alt="Onayla"></a>
					<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training.emptypopup_upd_valid&request_row_id=#request_row_id#&valid_type=0','small');"><input type="Image" src="/images/refusal.gif" alt="Reddet"></a>
				</cfif>
					</td>
					 <!-- sil -->
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="9"><cfif form_varmi eq 0><cf_get_lang_main no='289. Filtre Ediniz'>!<cfelse><cf_get_lang_main no='72.Kayıt Yok'>!</cfif></td>
			</tr>
		</cfif>
	</tbody>
</cf_big_list>
<cf_paging 
    page="#attributes.page#" 
    maxrows="#attributes.maxrows#" 
    totalrecords="#attributes.totalrecords#" 
    startrow="#attributes.startrow#" 
    adres="training.list_class_valid#url_str#">
