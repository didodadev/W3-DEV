<cfsetting showdebugoutput="no">
<cfscript>
	get_days = createObject("component","V16.hr.ehesap.cfc.proforma_puantaj");
	get_days.dsn = dsn;
	get_days.ssk_office = attributes.ssk_office;
	get_days.sal_year = attributes.sal_year;
	get_days.sal_mon = attributes.sal_mon;
	
	get_emps = get_days.get_emps();
</cfscript>

<cfif not get_emps.recordcount>
	<cf_get_lang dictionary_id='54638.Çalışan Kaydı Bulunamadı'>!
	<cfexit method="exittemplate">
</cfif>
<cfquery name="get_emps" datasource="#dsn#">
	SELECT 
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		EI.TC_IDENTY_NO,
		BA.AMOUNT AS ACTION_VALUE,
		BA.DUEDATE AS ACTION_DATE
	FROM 
		CORRESPONDENCE_PAYMENT BA,
		EMPLOYEES E,
		EMPLOYEES_IDENTY EI
	WHERE 
		BA.TO_EMPLOYEE_ID = E.EMPLOYEE_ID AND
		EI.EMPLOYEE_ID = E.EMPLOYEE_ID AND
		BA.TO_EMPLOYEE_ID IN (#valuelist(get_emps.employee_id)#) AND
		YEAR(BA.DUEDATE) = #attributes.sal_year# AND
		MONTH(BA.DUEDATE) = #attributes.sal_mon#
</cfquery>


<cf_ajax_list>
	<thead>
		<tr>
			<th><cf_get_lang dictionary_id='58577.Sıra'></th>
			<th><cf_get_lang dictionary_id='58025.TC Kimlik No'></th>
			<th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
			<th><cf_get_lang dictionary_id='57742.Tarih'></th>
			<th style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
		</tr>
	</thead>
	<tbody>
	<cfset total_value = 0>
	<cfoutput query="get_emps">
		<tr>
			<td>#currentrow#</td>
			<td>#tc_identy_no#</td>
			<td nowrap="nowrap">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
			<td>#dateformat(action_date,'dd/mm/yyyy')#</td>
			<td style="text-align:right;">#tlformat(ACTION_VALUE)#</td>
		</tr>
		<cfset total_value = total_value + ACTION_VALUE>
	</cfoutput>
	</tbody>
	<tfoot>
	<cfoutput>
		<tr class="color-list">
			<td colspan="3" class="formbold" style="text-align:right;"><cf_get_lang dictionary_id='53263.Toplamlar'></td>
			<td>#get_emps.recordcount# <cf_get_lang dictionary_id='29831.Kişi'></td>
			<td style="text-align:right;">#tlformat(total_value)#</td>
		</tr>
	</cfoutput>
	</tfoot>
</cf_ajax_list>