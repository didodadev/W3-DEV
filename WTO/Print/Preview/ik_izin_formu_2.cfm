<!--- IK izin formu --->
<cf_get_lang_set module_name="ehesap"><!--- sayfanin en altinda kapanisi var --->
<cfquery name="GET_OFFTIME" datasource="#DSN#">
	SELECT 
		OFFTIME.*, 
		SETUP_OFFTIME.OFFTIMECAT,
		CASE 
            WHEN ISNULL(OFFTIME.SUB_OFFTIMECAT_ID,0) <> 0 THEN (SELECT top 1 OFFTIMECAT FROM SETUP_OFFTIME A WHERE A.OFFTIMECAT_ID = OFFTIME.SUB_OFFTIMECAT_ID)
            WHEN ISNULL(OFFTIME.SUB_OFFTIMECAT_ID,0) = 0 THEN (SELECT top 1  OFFTIMECAT FROM OFFTIME B WHERE B.OFFTIMECAT_ID = OFFTIME.OFFTIMECAT_ID)
        END AS NEW_CAT_NAME
	FROM 
		OFFTIME,
		SETUP_OFFTIME
	WHERE
		OFFTIME.OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID AND
		OFFTIME_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#">
</cfquery>
<cfset attributes.employee_id=get_offtime.employee_id>
<cfinclude template="/V16/hr/query/get_position_master.cfm">
<cfif get_offtime.recordcount eq 0>
	<cfoutput>Belge bulunamadı.</cfoutput>
	<cfabort/>
</cfif>
<cfset record_=date_add('h',session.ep.time_zone,get_offtime.record_date)>
<cfset start_=date_add('h',session.ep.time_zone,get_offtime.startdate)>
<cfset end_=date_add('h',session.ep.time_zone,get_offtime.finishdate)>
<cfif len(get_offtime.WORK_STARTDATE)>
	<cfset work_start_= date_add('h',session.ep.time_zone,get_offtime.WORK_STARTDATE)>
<cfelse>				
	<cfset work_start_= date_add('d',1,get_offtime.finishdate)>
	<cfset work_start_= date_add('h',session.ep.time_zone,work_start_)>
</cfif>
<cfquery name="check" datasource="#dsn#">
	SELECT 
		ASSET_FILE_NAME2,
		ASSET_FILE_NAME2_SERVER_ID
	FROM 
		OUR_COMPANY 
	WHERE 
	<cfif isDefined("session.ep.company_id")>
		COMP_ID = #session.ep.company_id#
	<cfelseif isDefined("session.pp.our_company_id")>	
		COMP_ID = #session.pp.our_company_id#
	<cfelseif isDefined("session.ww.our_company_id")>
		COMP_ID = #session.ww.our_company_id#
	<cfelseif isDefined("session.cp.our_company_id")>
		COMP_ID = #session.cp.our_company_id#
	</cfif>
</cfquery>
<br/><br/>
<table border="0" cellpadding="0" cellspacing="0" width="700" align="center">
	<tr>
		<td>
			<table border="1" width="100%" cellpadding="2" cellspacing="0">
				<tr class="txtbold">
					<td align="center" colspan="4" style="font-size:14px;" height="30"><cfoutput>#session.ep.company_nick#</cfoutput> İzin Formu</td></tr>
				<cfoutput>
				<tr>
					<td class="txtbold" width="120"><cf_get_lang_main no='164.Çalışan'></td>
					<td width="220">#get_emp_info(get_offtime.employee_id,0,0)#&nbsp;</td>
					<td class="txtbold" width="140"><cf_get_lang_main no='160.Departman'> / <cf_get_lang_main no='1085.Pozisyon'> </td>
					<td width="220">#get_position.position_name#<cfif len(get_position.department_head)> / </cfif>#get_position.department_head#&nbsp;</td>
				</tr>
				</cfoutput>
				<tr>
					<td class="txtbold"><cf_get_lang_main no='1163.İzin Kategorisi'></td>
					<td><cfoutput>#get_offtime.NEW_CAT_NAME#</cfoutput>&nbsp;</td>
					<td class="txtbold"><cf_get_lang_main no='87.Tel'> </td>
					<td><cfoutput>#get_offtime.tel_code# #get_offtime.tel_no#</cfoutput>&nbsp;</td>
				</tr>
				<cfoutput>
				<tr>
					<td class="txtbold"><cf_get_lang_main no='641.Başlangıç Tarihi'></td>
					<td>#dateformat(start_,dateformat_style)#&nbsp;#TimeFormat(start_,timeformat_style)#</td>
					<td class="txtbold"><cf_get_lang_main no='217.Açıklama'> </td>
					<td>#get_offtime.detail#&nbsp;</td>
				</tr>
				<tr>
				  <td class="txtbold"><cf_get_lang_main no='288.Bitiş Tarihi'> </td>
				  <td>#dateformat(end_,dateformat_style)#&nbsp;#TimeFormat(end_,timeformat_style)#</td>
				  <td class="txtbold"><cf_get_lang no='871.İşe Başlama Tarihi'> </td>
				  <td>#dateformat(work_start_,dateformat_style)#&nbsp;#TimeFormat(work_start_,timeformat_style)#</td>
				</tr>
				<tr>
					<td class="txtbold"><cf_get_lang_main no='1311.Adres'> </td>
					<td colspan="3">#get_offtime.address#&nbsp;</td>
				  </tr>
				<tr class="txtbold" style="height:15mm;">
					<td colspan="4" valign="top"><cf_get_lang_main no='1545.İmza'> </td>
				</tr>
				</cfoutput>
			</table>
			<br/>
			<table border="1" width="100%" cellpadding="2" cellspacing="0">
				<tr>
					<td width="50%" height="100" class="txtbold"><cf_get_lang no="1401.Bölüm Amiri"> <cf_get_lang_main no='1545.İmza'></td>
					<td width="50%" class="txtbold"><cf_get_lang no="1402.Bölüm Müdürü"> <cf_get_lang_main no='1545.İmza'></td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
