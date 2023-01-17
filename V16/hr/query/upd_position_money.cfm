<cfquery name="UPD_POSITION_MONEY" datasource="#DSN#">
	UPDATE
		EMPLOYEE_POSITIONS
	SET
		ONGR_UCRET = <cfif len(attributes.ONGR_UCRET)>#attributes.ONGR_UCRET#,<cfelse>NULL,</cfif>
		MONEY_ID = <cfif len(attributes.MONEY_ID)> #attributes.MONEY_ID#,<cfelse>NULL,</cfif>
		ON_MALIYET = <cfif len(attributes.ON_MALIYET)>#attributes.ON_MALIYET#,<cfelse>NULL,</cfif>
		ON_MALIYET_YIL = <cfif len(attributes.ON_MALIYET_YIL)>#attributes.ON_MALIYET_YIL#,<cfelse>NULL,</cfif>
		ON_HOUR = <cfif len(attributes.ON_HOUR)>#attributes.ON_HOUR#<cfelse>NULL</cfif>,
		ON_HOUR_DAILY = <cfif len(attributes.ON_HOUR_DAILY)>#attributes.ON_HOUR_DAILY#<cfelse>NULL</cfif>,
		TIME_COST_CONTROL = <cfif isdefined("attributes.TIME_COST_CONTROL")>1<cfelse>0</cfif>
	WHERE
		POSITION_ID = #attributes.id#	
</cfquery>
<cfquery name="DEL_POSITION_COST" datasource="#dsn#">
	DELETE FROM EMPLOYEE_POSITIONS_COST WHERE POSITION_ID = #attributes.id#
</cfquery>
<cfif attributes.record_num gt 0>
	<cfloop from="1" to="#attributes.record_num#" index="i">
		<cfif evaluate("attributes.row_kontrol#i#")>
			<cfscript>
				form_detail = evaluate("attributes.detail#i#");
				form_period = evaluate("attributes.period#i#");
				form_rakam = evaluate("attributes.rakam#i#");
			</cfscript>
			<cfquery name="INSERT_POSITION_COST" datasource="#dsn#">
				INSERT INTO
					EMPLOYEE_POSITIONS_COST
					(
						POSITION_ID,
						DETAIL,
						COST_TYPE,
						POSITION_COST
					)
					VALUES
					(
						#attributes.id#,
						<cfif len(form_detail)>'#form_detail#',<cfelse>NULL,</cfif>
						<cfif len(form_period)>#form_period#,<cfelse>NULL,</cfif>
						<cfif len(form_rakam)>#form_rakam#<cfelse>NULL</cfif>
					)
			</cfquery>
		</cfif>
	</cfloop>
</cfif>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
		location.reload();
	</cfif>
</script>

