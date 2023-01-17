<cfif len(attributes.del_denied_id)>
	<cfquery name="DEL_LOCK" datasource="#dsn#">
		DELETE FROM
			DENIED_PAGES_LOCK
		WHERE 
			DENIED_PAGE = '#attributes.denied_page#'
	</cfquery>
	<script type="text/javascript">
		<cfif isdefined("attributes.draggable")>
			closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
			location.reload();
		<cfelse>
			window.close();
		</cfif>
	</script>
<cfelse>
	<cfquery name="del_" datasource="#dsn#">
		DELETE FROM DENIED_PAGES_LOCK WHERE DENIED_PAGE = '#attributes.denied_page#'
	</cfquery>
	<cfif isDefined("attributes.to_pos_codes") and listlen(attributes.to_pos_codes)>
		<cfloop list="#attributes.to_pos_codes#" index="m">
			<cfquery name="insert_" datasource="#dsn#">
				INSERT INTO 
					DENIED_PAGES_LOCK
				(
					DENIED_TYPE,
					DENIED_PAGE,
					POSITION_CODE,
					PERIOD_ID,
					OUR_COMPANY_ID,
					UPDATE_EMP,
					UPDATE_DATE
					
				)
				VALUES
				(
					<cfif isdefined("attributes.denied_type")>1<cfelse>0</cfif>,
					'#attributes.denied_page#',
					#m#,
					<cfif isdefined("attributes.period_control") and isdefined("attributes.period_id") and listlen(attributes.period_id)>'#attributes.period_id#'<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.company_control") and isdefined("attributes.our_company_id") and listlen(attributes.our_company_id)>'#attributes.our_company_id#'<cfelse>NULL</cfif>,
					#session.ep.userid#,
					#now()#
				)
			</cfquery>
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
</cfif>
