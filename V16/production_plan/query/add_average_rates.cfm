<cfquery name="del_row" datasource="#dsn3#">
	DELETE FROM ASSEMPTION_AVERAGE_RATES
</cfquery>
<cfloop from="5" to="8" index="kk">
	<cfloop from="1" to="6" index="jj">
		<cfif isdefined("attributes.value_#kk#_#jj#") and len(evaluate("attributes.value_#kk#_#jj#"))>
			<cfquery name="add_row" datasource="#dsn3#">
				INSERT INTO
					ASSEMPTION_AVERAGE_RATES
				(
					METHOD_ID,
					MONTH_VALUE,
					AVERAGE_RATE,
					RECORD_EMP,
					RECORD_DATE,
					RECORD_IP
				)
				VALUES
				(
					#kk#,
					#jj#,
					#filterNum(evaluate("attributes.value_#kk#_#jj#"),2)#,
					#session.ep.userid#,
					#now()#,
					'#cgi.remote_addr#'		
				)
			</cfquery>
		</cfif>
	</cfloop>
</cfloop>
<cflocation url="#request.self#?fuseaction=prod.form_add_average_rates" addtoken="no">

