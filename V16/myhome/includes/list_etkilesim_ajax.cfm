<cfsetting showdebugoutput="no">
<cfif not isdefined("attributes.to_day") or not len(attributes.to_day)>
	<cfset attributes.to_day=now()>
</cfif>
<cfquery name="GET_SERVICE" datasource="#dsn#">
	SELECT
		CUS_HELP_ID,
		APPLICANT_NAME,
        DETAIL
	FROM
		CUSTOMER_HELP
	WHERE 
			(
				(
				RECORD_DATE < #DATEADD("D",1,attributes.to_day)# AND
				RECORD_DATE > #DATEADD("D",-1,attributes.to_day)#
				)
				OR
				(
				UPDATE_DATE < #DATEADD("D",1,attributes.to_day)# AND
				UPDATE_DATE > #DATEADD("D",-1,attributes.to_day)#
				)
			)
			OR
			(
				RECORD_DATE < #DATEADD("D",1,attributes.to_day)# AND
				UPDATE_DATE > #DATEADD("D",-1,attributes.to_day)#
			)
	ORDER BY
		RECORD_DATE DESC
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default=10>
<cfparam name="attributes.totalrecords" default=#get_service.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_flat_list>
	<tbody>
		<cfoutput query="get_service" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<tr>
				<td><a href="#request.self#?fuseaction=call.helpdesk&event=upd&cus_help_id=#cus_help_id#" target="_blank" class="tableyazi">#left(detail,75)#</a> </td>
				<td>#applicant_name#</td>
			</tr>
		</cfoutput>
		<cfif not get_service.recordcount>
			<tr>
				<td><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
			</tr>
		</cfif>
	</tbody>
</cf_flat_list>
 

