<cfquery name="GET_OFFTIME" datasource="#DSN#">
	SELECT 
		*,
		CASE 
            WHEN ISNULL(OFFTIME.SUB_OFFTIMECAT_ID,0) <> 0 THEN (SELECT top 1 OFFTIMECAT FROM SETUP_OFFTIME A WHERE A.OFFTIMECAT_ID = OFFTIME.SUB_OFFTIMECAT_ID)
            WHEN ISNULL(OFFTIME.SUB_OFFTIMECAT_ID,0) = 0 THEN (SELECT top 1  OFFTIMECAT FROM OFFTIME B WHERE B.OFFTIMECAT_ID = OFFTIME.OFFTIMECAT_ID)
        END AS NEW_CAT_NAME
	FROM 
		OFFTIME,
		SETUP_OFFTIME
	WHERE 
		OFFTIME_ID = #attributes.iid#
		and OFFTIME.OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID
</cfquery>
<cfset attributes.employee_id=get_offtime.employee_id>
<cfinclude template="/V16/hr/query/get_position_master.cfm">
<cfset record_=date_add('h',session.ep.time_zone,get_offtime.record_date)>
<cfset start_=date_add('h',session.ep.time_zone,get_offtime.startdate)>
<cfset end_=date_add('h',session.ep.time_zone,get_offtime.finishdate)>
<cfif len(get_offtime.WORK_STARTDATE)>
	<cfset work_start_= date_add('h',session.ep.time_zone,get_offtime.WORK_STARTDATE)>
<cfelse>				
	<cfset work_start_= date_add('d',1,get_offtime.finishdate)>
	<cfset work_start_= date_add('h',session.ep.time_zone,work_start_)>
</cfif>
<br/><br/>
<table align="center">
	<tr>
		<td>
		<table align="center">
			<tr>
				<td class="txtbold"><h4>İZİN TALEBİ</h4></td>
			</tr>
		</table>
		<table>
			<tr>
				<td class="txtbold" width="120"><cf_get_lang_main no='164.Çalışan'> : </td>
				<td width="220"><cfoutput>#get_emp_info(get_offtime.employee_id,0,0)#</cfoutput></td>
				<td class="txtbold" width="140"><cf_get_lang_main no='160.Departman'>/<cf_get_lang_main no='1085.Pozisyon'> : </td>
				<td width="220"><cfoutput>#get_position.position_name#/ #get_position.department_head# </cfoutput></td>
			</tr>
			<tr>
				<td class="txtbold">İzin Kategorisi : </td>
				<td><cfoutput >#get_offtime.NEW_CAT_NAME#</cfoutput></td>
				<td class="txtbold">İzin Hakediş Tarihi : </td>
				<td><cfoutput>#dateformat(get_offtime.deserve_date,dateformat_style)#</cfoutput></td>
			</tr>
			<tr>
				<td class="txtbold"><cf_get_lang_main no='641.Başlangıç Tarihi'> : </td>
				<td><cfoutput>#dateformat(start_,dateformat_style)#</cfoutput></td>
				<td class="txtbold"><cf_get_lang_main no='288.Bitiş Tarihi'> : </td>
				<td><cfoutput>#dateformat(end_,dateformat_style)#</cfoutput></td>
			</tr>
			<tr>
				<td class="txtbold">İşe Başlama Tarihi : </td>
				<td><cfoutput>#dateformat(work_start_,dateformat_style)#</cfoutput></td>
				<td class="txtbold"><cf_get_lang_main no='87.Telefon'> : </td>
				<td><cfoutput>#get_offtime.tel_code# #get_offtime.tel_no#</cfoutput></td>
			</tr>
			<tr>
				<td class="txtbold" rowspan="2"><cf_get_lang_main no='1311.Adres'> : </td>
				<td width="180"><cfoutput>#get_offtime.address#</cfoutput></td>
				<td class="txtbold"><cf_get_lang_main no='217.Açıklama'> : </td>
				<td rowspan="2" width="180"><cfoutput>#get_offtime.detail#</cfoutput></td>
			</tr>
		</table>
		</td>
	</tr>
</table>

