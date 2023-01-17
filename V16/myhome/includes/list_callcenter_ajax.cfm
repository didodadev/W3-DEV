<cfsetting showdebugoutput="no">
<cfif not isdefined("attributes.to_day") or not len(attributes.to_day)>
	<cfset attributes.to_day=now()>
</cfif>
<cfquery name="GET_SERVICE" datasource="#dsn#">
	SELECT
		SERVICE.SERVICE_HEAD,
		SERVICE.SERVICE_ID,
		SERVICE.APPLICATOR_NAME,
		SERVICE.SERVICE_COMPANY_ID,
		SERVICE.SERVICE_CONSUMER_ID,
		SERVICE_APPCAT.SERVICECAT
	FROM
		G_SERVICE AS SERVICE,
		G_SERVICE_APPCAT AS SERVICE_APPCAT
	WHERE 
		SERVICE.SERVICECAT_ID=SERVICE_APPCAT.SERVICECAT_ID AND
		(
			(
				(
				SERVICE.RECORD_DATE < #DATEADD("D",1,attributes.to_day)# AND
				SERVICE.RECORD_DATE > #DATEADD("D",-1,attributes.to_day)#
				)
				OR
				(
				SERVICE.UPDATE_DATE < #DATEADD("D",1,attributes.to_day)# AND
				SERVICE.UPDATE_DATE > #DATEADD("D",-1,attributes.to_day)#
				)
			)
			OR
			(
				SERVICE.RECORD_DATE < #DATEADD("D",1,attributes.to_day)# AND
				SERVICE.UPDATE_DATE > #DATEADD("D",-1,attributes.to_day)#
			)
		) AND SERVICE.RESP_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
	ORDER BY
		SERVICE.RECORD_DATE DESC
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default=10>
<cfparam name="attributes.totalrecords" default=#get_service.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_flat_list>
    <tbody>
		<cfoutput query="get_service" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<tr>
				<td><a href="#request.self#?fuseaction=call.list_service&event=upd&service_id=#SERVICE_ID#" class="tableyazi">#service_HEAD#</a> </td>
				<td> #SERVICECAT# </td>
				<td><cfif len(SERVICE_COMPANY_ID)>#get_par_info(SERVICE_COMPANY_ID,1,1,1)#</cfif> #APPLICATOR_NAME#</td>
			</tr>
		</cfoutput>
		<cfif not get_service.recordcount>
		<tr>
			<td><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
		</tr>
		</cfif>
    </tbody>
</cf_flat_list>
 

