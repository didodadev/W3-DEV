<cflock timeout="60">
	<cftransaction>
		<cfquery name="GET_CARE_CONTROL" datasource="#DSN#">
			SELECT ASSET_ID FROM CARE_STATES WHERE ASSET_ID = #attributes.asset_id#
		</cfquery>
		<cfif get_care_control.recordcount>
			<cfquery name="DEL_CARE_CONTROL" datasource="#DSN#">
				DELETE FROM CARE_STATES WHERE ASSET_ID = #attributes.asset_id#
			</cfquery>
		</cfif>
		<cfif len(attributes.record_num) and attributes.record_num neq "">
			<cfloop from="1" to="#attributes.record_num#" index="i">
				<cfif evaluate("attributes.row_kontrol#i#")>
					<cfset form_care_date = evaluate("attributes.care_date#i#")>
					<cf_date tarih = 'form_care_date'>
					<cfscript>
						form_care_type = evaluate("attributes.care_type#i#");
						form_aciklama = evaluate("attributes.aciklama#i#");
						form_care_type_period = evaluate("attributes.care_type_period#i#");
						form_official_emp = evaluate("attributes.official_emp#i#");
						form_official_emp_id = evaluate("attributes.official_emp_id#i#");
						form_gun = evaluate("attributes.gun#i#");
						form_saat = evaluate("attributes.saat#i#");
						form_dakika = evaluate("attributes.dakika#i#");
						if(attributes.is_motorized eq 1)
						form_km = evaluate("attributes.care_km_period#i#");
					</cfscript>
					<cfquery name="ADD_CARE_PERIODS" datasource="#DSN#">
						INSERT
						INTO
						CARE_STATES
						(
							CARE_TYPE_ID,
							ASSET_ID,
							CARE_STATE_ID,
							PERIOD_ID,
							CARE_DAY,
							CARE_HOUR,
							CARE_MINUTE,
							<cfif attributes.is_motorized eq 1>CARE_KM,</cfif>
							RECORD_EMP,
							RECORD_IP,
							RECORD_DATE,
							IS_ACTIVE,
							DETAIL,
							PERIOD_TIME,
							OFFICIAL_EMP_ID
						)
						VALUES
						(
							2,
							#attributes.asset_id#,
							#form_care_type#,
							<cfif len(form_care_type_period)>#form_care_type_period#<cfelse>NULL</cfif>,
							<cfif len(form_gun)>#form_gun#<cfelse>NULL</cfif>,
							<cfif len(form_saat)>#form_saat#<cfelse>NULL</cfif>,
							<cfif len(form_dakika)>#form_dakika#<cfelse>NULL</cfif>,
							<cfif attributes.is_motorized eq 1><cfif isnumeric(form_km)>#form_km#<cfelse>0</cfif>,</cfif>
							#session.ep.userid#,
							'#cgi.remote_addr#',
							#now()#,
							1,
							<cfif len(form_aciklama)>'#form_aciklama#'<cfelse>NULL</cfif>,
							<cfif len(form_care_date)>#form_care_date#<cfelse>NULL</cfif>,
							<cfif len(form_official_emp) and len(form_official_emp_id)>#form_official_emp_id#<cfelse>NULL</cfif>
						)
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>
	</cftransaction>
</cflock>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
