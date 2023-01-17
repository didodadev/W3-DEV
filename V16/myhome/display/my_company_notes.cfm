<cfsetting showdebugoutput="no">
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfquery name="get_notes" datasource="#DSN#">
	SELECT 
		*
	FROM
		NOTES
	WHERE
		(
			IS_SPECIAL = 0
			OR (IS_SPECIAL = 1 AND (RECORD_EMP = #session.ep.userid# OR UPDATE_EMP = #session.ep.userid#))
		)
		<cfif isdefined("attributes.cpid")>
			AND ACTION_ID = #attributes.cpid#
			AND ACTION_SECTION = 'COMPANY_ID'
		<cfelse>
			AND 
			(ACTION_ID = #attributes.cid# AND ACTION_SECTION = 'CONSUMER_ID') OR
			(ACTION_ID IN (SELECT PARTNER_ID FROM COMPANY_PARTNER WHERE RELATED_CONSUMER_ID = #attributes.cid#) AND ACTION_SECTION = 'PARTNER_ID')
			<!--- Bireysel Uye iliskilendirilerek olusturulan partner icin eklendi fbs 20101218 --->
		</cfif>
	ORDER BY
		RECORD_DATE DESC
</cfquery>
<cfif get_notes.recordcount>
	<cfset employee_id_list=''>
	<cfoutput query="get_notes">
		<cfif len(record_emp) and not listfind(employee_id_list,record_emp)>
			<cfset employee_id_list=listappend(employee_id_list,record_emp)>
		</cfif>
	</cfoutput>
	<cfif len(employee_id_list)>
		<cfquery name="get_emp" datasource="#dsn#">
			SELECT
				EMPLOYEE_NAME,EMPLOYEE_SURNAME
			FROM
				EMPLOYEES
			WHERE
				EMPLOYEE_ID IN(#employee_id_list#)
			ORDER BY
				EMPLOYEE_ID
		</cfquery>
		<cfset employee_id_list=listsort(employee_id_list,"numeric","ASC",",")>
	</cfif>
</cfif>
<cf_ajax_list>
	<thead>
		 <tr>
			<th><cf_get_lang dictionary_id='57742.Tarih'></th>
			<th><cf_get_lang dictionary_id='57480.Başlık'></th>
			<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
			<th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
		</tr>
	</thead>
	<tbody>
	<cfif get_notes.recordcount>
		<cfoutput query="get_notes" startrow="1" maxrows="#attributes.maxrows#">
			<tr>
				<td>#dateformat(record_date,dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#</td>
				<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_form_upd_note&note_id=#note_id#','small');" class="tableyazi">#note_head#</a></td>
				<td>#note_body#</td>
				<td><cfif len(record_emp)><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_emp#','medium');" class="tableyazi">#get_emp.employee_name[listfind(employee_id_list,record_emp,',')]# #get_emp.employee_surname[listfind(employee_id_list,record_emp,',')]#</a></cfif></td>
			</tr>
		</cfoutput>
		<cfelse>
				<tr>
					<td colspan="4"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
				</tr> 
		</cfif>
	</tbody>
</cf_ajax_list>

