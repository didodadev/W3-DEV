<!---
	FBS 20080716 CRM de musteri detayindaki iliskili subelerde, kapatma secildiginde popup aciliyor,
	burada bu popupa girilen bilgilerin history kayitlari tutulup goruntuleniyor...
	Ornek Link : <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=crm.popup_member_branch_history&related_id=#get_company_related.related_id#</cfoutput>','medium','popup_member_branch_history');"><img src="/images/history.gif" alt="<cf_get_lang_main no='61.Tarihçe'>" border="0"></a>
--->
<cfquery name="get_closed_history" datasource="#dsn#">
	SELECT
		CBR.COMPANY_ID,
		CBR.BRANCH_ID,
		CH.CLOSED_START_DATE,
		CH.CLOSED_FINISH_DATE,
		CH.IS_CLOSED,
		CH.RECORD_EMP,
		CH.RECORD_DATE
	FROM 
		COMPANY_BRANCH_CLOSED_HISTORY CH,
		COMPANY_BRANCH_RELATED CBR
	WHERE
		CBR.RELATED_ID = CH.RELATED_ID AND
		CH.RELATED_ID = #attributes.related_id#
	ORDER BY
		CH.RECORD_DATE DESC
</cfquery>
<cfquery name="get_member_name" datasource="#dsn#">
	SELECT
		C.FULLNAME
	FROM
		COMPANY_BRANCH_RELATED CBR,
		COMPANY C
	WHERE
		CBR.COMPANY_ID = C.COMPANY_ID AND
		CBR.RELATED_ID = #attributes.related_id#
</cfquery>
<cfquery name="get_branch_name" datasource="#dsn#">
	SELECT
		B.BRANCH_NAME
	FROM
		COMPANY_BRANCH_RELATED CBR,
		BRANCH B
	WHERE
		CBR.BRANCH_ID = B.BRANCH_ID AND
		CBR.RELATED_ID = #attributes.related_id#
</cfquery>
<table width="100%" height="35" align="center" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td class="headbold" height="35">&nbsp;<cf_get_lang_main no='61.Tarihçe'> : <strong><cfoutput>#get_member_name.fullname# - #get_branch_name.branch_name#</cfoutput></strong></td>
	</tr>
</table>
<table width="98%" cellpadding="2" cellspacing="1" class="color-border" align="center">
	<tr class="color-header">
		<td class="form-title"><cf_get_lang dictionary_id="57487.No"></td>
		<td class="form-title"><cf_get_lang_main no='344.Durum'></td>
		<td class="form-title" width="90" align="center"><cf_get_lang_main no ='641.Başlangıç Tarihi'></td>
		<td class="form-title" width="90" align="center"><cf_get_lang_main no ='288.Bitiş Tarihi'></td>
		<td class="form-title"><cf_get_lang no ='796.Değişiklik Yapan'></td>
		<td class="form-title" width="110" align="center"><cf_get_lang no ='797.Değişiklik Tarihi'></td>
	</tr>
	<cfif get_closed_history.recordcount>
		<cfset record_list = "">
		<cfoutput query="get_closed_history">
			<cfif len(record_emp) and not listfind(record_list,record_emp)>
				<cfset record_list=listappend(record_list,record_emp)>
			</cfif>
		</cfoutput>
		<cfif len(record_list)>
			<cfset record_list = listsort(record_list,'numeric','ASC',',')>
			<cfquery name="get_record" datasource="#dsn#">
				 SELECT EMPLOYEE_ID,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#record_list#) ORDER BY EMPLOYEE_ID
			</cfquery>
			<cfset record_list = listsort(listdeleteduplicates(valuelist(get_record.employee_id,',')),'numeric','ASC',',')>
		</cfif>
		<cfoutput query="get_closed_history">
			<tr class="color-row">
				<td>#currentrow#</td>
				<td><cfif is_closed eq 1><cf_get_lang no ='798.Kapatma'><cfelseif is_closed eq 0><cf_get_lang_main no ='141.Kapat'></cfif></td>
				<td align="center"><cfif len(closed_start_date)>#DateFormat(closed_start_date,dateformat_style)#<cfelse>-</cfif></td>
				<td align="center"><cfif len(closed_finish_date)>#DateFormat(closed_finish_date,dateformat_style)#<cfelse>-</cfif></td>
				<td>#get_record.employee_name[listfind(record_list,record_emp,',')]# #get_record.employee_surname[listfind(record_list,record_emp,',')]#</td>
				<td align="center">#DateFormat(record_date,dateformat_style)# - #TimeFormat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#</td>
			</tr>
		</cfoutput>
	<cfelse>
		<tr class="color-row" height="20">
			<td colspan="6"><cf_get_lang_main no='72.Kayıt Yok'>!</td>
		</tr>
	</cfif>
</table>
