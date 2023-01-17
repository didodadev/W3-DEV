<cfquery name="get_emp" datasource="#DSN#">
	SELECT
		ZIMMET_ID
	FROM
		EMPLOYEES_INVENT_ZIMMET
	WHERE
		EMPLOYEE_ID=#attributes.employee_id#
</cfquery>
<cfif get_emp.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='753.Seçtiginiz Çalışana Ait Zimmet Kaydı Bulunmaktadır'>!");
		history.back();
	</script>
	<cfabort>
</cfif>
<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="add_invent" datasource="#DSN#" result="MAX_ID">
			INSERT INTO 
				EMPLOYEES_INVENT_ZIMMET
				(	
					COMPANY_ID,
					EMPLOYEE_ID,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP,
                    PROCESS_STAGE
				)
				VALUES
				(
					#attributes.company_id#,
					#attributes.employee_id#,
					#now()#,
					#SESSION.EP.USERID#,
					'#CGI.REMOTE_ADDR#',
                    #attributes.process_stage#
				)
		</cfquery>
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif evaluate("attributes.row_kontrol#i#") eq 1>
			<cfset attributes.tarih=evaluate("attributes.tarih#i#")>
			<cfif len(attributes.tarih)>
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
						#MAX_ID.IDENTITYCOL#,
						'#wrk_eval("device_name#i#")#',
						'#wrk_eval("inventory_no_#i#")#',
						'#wrk_eval("property_#i#")#',
						<cfif len(attributes.tarih)>#attributes.tarih#<cfelse>NULL</cfif>,
						#evaluate("asset_id_#i#")#,
						#given_emp_id#	
					)
				</cfquery>
			</cfif>
			</cfif>
		</cfloop>	
	</cftransaction>
</cflock>
	<script type="text/javascript">
	location.href = document.referrer;
	</script>

