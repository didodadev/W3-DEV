<cfinclude template="../../objects/functions/add_consumer_history.cfm">
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="hist_cont" datasource="#dsn#">
			SELECT * FROM CONSUMER WHERE CONSUMER_ID = #attributes.cons_id#
		</cfquery>
		<cfif ((attributes.mobilcat_id neq hist_cont.mobil_code) or
			(isDefined("attributes.work_telcode") and attributes.work_telcode neq hist_cont.consumer_worktelcode) or 
			(isdefined("attributes.work_tel") and attributes.work_tel neq hist_cont.consumer_worktel) or
			(isdefined("attributes.mobiltel") and attributes.mobiltel neq hist_cont.mobiltel) or
			(isdefined("attributes.consumer_email") and attributes.consumer_email neq hist_cont.consumer_email)
			)>
			<cfscript>
				add_consumer_history(consumer_id:attributes.cons_id);
			</cfscript>
		</cfif>
		<cfquery name="UPD_CONSUMER" datasource="#DSN#">
			UPDATE
				CONSUMER 
			SET
				CONSUMER_WORKTEL = <cfif isdefined("attributes.work_tel") and len(attributes.work_tel)>'#attributes.work_tel#'<cfelse>NULL</cfif>,
				CONSUMER_WORKTELCODE = <cfif isdefined("attributes.work_telcode") and len(attributes.work_telcode)>'#attributes.work_telcode#'<cfelse>NULL</cfif>,
				MOBIL_CODE = <cfif len(attributes.mobilcat_id)>'#attributes.mobilcat_id#'<cfelse>NULL</cfif>,
				MOBILTEL = <cfif len(attributes.mobiltel)>'#attributes.mobiltel#'<cfelse>NULL</cfif>,
				CONSUMER_EMAIL = <cfif len(attributes.consumer_email)>'#attributes.consumer_email#'<cfelse>NULL</cfif>,
				SEX = <cfif isdefined("attributes.sex") and attributes.sex eq 1>1<cfelse>0</cfif>,
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = '#cgi.remote_addr#'
			WHERE 
				CONSUMER_ID = #attributes.cons_id#
		</cfquery>
	</cftransaction>
</cflock>	
