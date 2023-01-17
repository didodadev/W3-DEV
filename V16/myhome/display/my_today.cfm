<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0">
<tr><!-- sil -->
<cfinclude template="../../objects/display/tree_back.cfm">
<td <cfoutput>#td_back#</cfoutput>><cfinclude template="position_left_menu.cfm"></td>
  <td valign="top">
    <!-- sil -->
	<table width="98%" height="35" align="center" cellpadding="0" cellspacing="0" border="0">
        <tr>
          <td class="headbold"><cfoutput>#session.ep.name# #session.ep.surname#</cfoutput></td>
		</tr>
	</table>
<cfquery name="GET_TODAY_OFFTIMES" datasource="#DSN#">
	SELECT 
		OFFTIME.VALID, 
		OFFTIME.VALIDDATE,
		OFFTIME.EMPLOYEE_ID, 
		OFFTIME.OFFTIME_ID, 
		OFFTIME.VALID_EMPLOYEE_ID, 
		OFFTIME.STARTDATE, 
		OFFTIME.FINISHDATE, 
		OFFTIME.TOTAL_HOURS, 
		SETUP_OFFTIME.OFFTIMECAT
	FROM 
		OFFTIME,
		EMPLOYEES,
		SETUP_OFFTIME
	WHERE
		OFFTIME.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
		OFFTIME.EMPLOYEE_ID = #SESSION.EP.USERID# AND
		OFFTIME.OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID AND
		OFFTIME.EMPLOYEE_ID=EMPLOYEES.EMPLOYEE_ID AND
		OFFTIME.STARTDATE <= #NOW()# AND
		OFFTIME.FINISHDATE >= #NOW()#
</cfquery>

<table width="98%" height="35" align="center" cellpadding="0" cellspacing="0" border="0">
	<tr>
	  <td class="headbold"><cf_get_lang dictionary_id='31460.Günlük İzin Durumu'></td>
	</tr>
</table>
<table cellspacing="1" cellpadding="2" width="98%" border="0" class="color-border" align="center">
  <tr class="color-header">
	<td height="22" class="form-title"><cf_get_lang dictionary_id='57487.No'></td>
	<td class="form-title" width="120"><cf_get_lang dictionary_id='57486.Kategori'></td>
	<td class="form-title"><cf_get_lang dictionary_id='57570.Ad Soyad'></td>
	<td class="form-title" width="220"><cf_get_lang dictionary_id='31111.Tarihler'></td>
	<td class="form-title" width="150"><cf_get_lang dictionary_id='57500.Onay'></td>
  </tr>
  <cfif GET_TODAY_OFFTIMES.recordcount>
	<cfoutput query="GET_TODAY_OFFTIMES">
	  <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
		<td width="25"><A onClick="windowopen('#request.self#?fuseaction=myhome.popup_dsp_my_offtime&offtime_id=#offtime_id#','medium');" href="javascript://" class="tableyazi">#offtime_id#</a></td>
		<td><A onClick="windowopen('#request.self#?fuseaction=myhome.popup_dsp_my_offtime&offtime_id=#offtime_id#','medium');" href="javascript://" class="tableyazi">#offtimecat#</a></td>
		<td>#SESSION.EP.NAME# #SESSION.EP.SURNAME#</td>
		<td>#dateformat(date_add('h',session.ep.time_zone,startdate),dateformat_style)# ( #timeformat(date_add('h',session.ep.time_zone,startdate),timeformat_style)# ) - #dateformat(date_add('h',session.ep.time_zone,finishdate),dateformat_style)# ( #timeformat(date_add('h',session.ep.time_zone,finishdate),timeformat_style)# )</td>
		<td>
		  <cfif valid EQ 1>
			<cf_get_lang dictionary_id='57616.Onaylı'>-
			<cfif len(VALID_EMPLOYEE_ID)>
			  <cfset attributes.employee_id = VALID_EMPLOYEE_ID>
			  <cfinclude template="../query/get_hr_name.cfm">
			  #get_hr_name.employee_name# #get_hr_name.employee_surname#
			</cfif>
			<cfelse>
			<cfif validdate EQ "">
			  <cf_get_lang dictionary_id='31112.Bekliyor'>
			  <cfelse>
			  <cf_get_lang dictionary_id='57617.Reddedildi'>
			</cfif>
		  </cfif>
		</td>
	  </tr>
	</cfoutput>
   <cfelse>
	<tr class="color-row" height="20">
	  <td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
	</tr>
  </cfif>
</table>
<br/>
<table width="98%" height="35" align="center" cellpadding="0" cellspacing="0" border="0">
	<tr>
	  <td class="headbold"><cf_get_lang dictionary_id='31461.Günlük Ajanda'></td>
	</tr>
</table>
	
<!-- sil -->
</td>
</tr>
</table>
<!-- sil -->
