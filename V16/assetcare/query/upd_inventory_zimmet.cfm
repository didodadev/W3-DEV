<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
	<cfquery name="upd_invent" datasource="#dsn#">
		UPDATE
			EMPLOYEES_INVENT_ZIMMET
		SET		
			COMPANY_ID = #attributes.company_id#,
			EMPLOYEE_ID = #attributes.employee_id#,
			UPDATE_DATE = #now()#,
			UPDATE_EMP = #SESSION.EP.USERID#,
			UPDATE_IP = '#CGI.REMOTE_ADDR#',
            PROCESS_STAGE = #attributes.process_stage#
		WHERE
			ZIMMET_ID = #attributes.ZIMMET_ID#
	</cfquery>
	
	<cfquery name="del_max" datasource="#DSN#">
		DELETE
		FROM
			EMPLOYEES_INVENT_ZIMMET_ROWS
		WHERE
			ZIMMET_ID=#attributes.ZIMMET_ID#
	</cfquery>
	<cfloop from="1" to="#attributes.record_num#" index="i">
	<cfif evaluate("attributes.row_kontrol#i#") eq 1>
		<cfset attributes.tarih=evaluate("attributes.tarih#i#")>
			<cf_date tarih='attributes.tarih'>
				<cfset "attributes.tarih#i#"=attributes.tarih>
				<cfquery name="add_invent_row" datasource="#DSN#">
				INSERT INTO
					EMPLOYEES_INVENT_ZIMMET_ROWS		
						(
							ZIMMET_ID,
							DEVICE_NAME,
							INVENTORY_NO,
							PROPERTY,
							ZIMMET_DATE,
							ASSET_ID,
							GIVEN_EMP_ID
						)
						VALUES
						(
							#attributes.ZIMMET_ID#,
							'#wrk_eval("device_name#i#")#',
							'#wrk_eval("inventory_no_#i#")#',
							'#wrk_eval("property_#i#")#',
							<cfif len(attributes.tarih)>#attributes.tarih#<cfelse>NULL</cfif>,
							'#evaluate("asset_id_#i#")#',
							'#evaluate("given_id_#i#")#'
						)
				</cfquery>
		</cfif>
	</cfloop>	
	</cftransaction>
</cflock>
<script type="text/javascript">
	location.href = document.referrer;
</script>
