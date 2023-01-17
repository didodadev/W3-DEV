<cfif len(attributes.start_date)><cf_date tarih='attributes.start_date'></cfif>
	<cfif len(attributes.finish_date)><cf_date tarih='attributes.finish_date'></cfif>
	<cfquery name="ADD_FUEL_PASSWORD" datasource="#dsn#">
		INSERT
			INTO
			ASSET_P_FUEL_PASSWORD
			(
				BRANCH_ID,
				COMPANY_ID,
				STATUS,
				USER_CODE,
				PASSWORD1,
				PASSWORD2,
				START_DATE,
				FINISH_DATE,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
			VALUES
			(
				#attributes.branch_id#,
				#attributes.company_id#,
				<cfif isdefined("attributes.status")>1<cfelse>0</cfif>,
				<cfif len(attributes.user_code)>'#attributes.user_code#'<cfelse>NULL</cfif>,
				<cfif len(attributes.password1)>'#attributes.password1#'<cfelse>NULL,</cfif>,
				<cfif len(attributes.password2)>'#attributes.password2#'<cfelse>NULL</cfif>,
				<cfif len(attributes.start_date)>#attributes.start_date#<cfelse>NULL</cfif>,
				<cfif len(attributes.finish_date)>#attributes.finish_date#<cfelse>NULL</cfif>,
				#now()#,
				#session.ep.userid#,
				  '#cgi.remote_addr#'
			)
	</cfquery>
	<cfif attributes.is_detail neq 1>
	
	<script type="text/javascript">
		// window.parent.frame_list_fuel_password.location.reload();
		// window.parent.frame_fuel_password.location.href='<cfoutput>#request.self#?fuseaction=assetcare.fuel_password</cfoutput>';
		window.location.reload();
		window.location.href='<cfoutput>#request.self#?fuseaction=assetcare.fuel_password</cfoutput>';
	
	</script>
	<cfelse>
	<script type="text/javascript">
		wrk_opener_reload(); 
		self.close();
	</script>
	</cfif>
	