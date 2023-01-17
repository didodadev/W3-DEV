<!--- <cfdump var="#attributes#" abort> --->
<cfif len(attributes.start_date)><cf_date tarih='attributes.start_date'></cfif>
	<cfif len(attributes.finish_date)><cf_date tarih='attributes.finish_date'></cfif>
	<cfquery name="UPD_FUEL_PASSWORD" datasource="#dsn#">
		UPDATE
			ASSET_P_FUEL_PASSWORD
		SET
			BRANCH_ID = <cfif len(attributes.branch_id)>#attributes.branch_id#<cfelse>NULL</cfif>,
			COMPANY_ID = #attributes.company_id#,
			STATUS = <cfif isdefined("attributes.status")>1<cfelse>0</cfif>,
			USER_CODE = <cfif len(attributes.user_code)>'#attributes.user_code#'<cfelse>NULL</cfif>,
			PASSWORD1 = <cfif len(attributes.password1)>'#attributes.password1#'<cfelse>NULL</cfif>,
			PASSWORD2 = <cfif len(attributes.password2)>'#attributes.password2#'<cfelse>NULL</cfif>,
			START_DATE = <cfif len(attributes.start_date)>#attributes.start_date#<cfelse>NULL</cfif>,
			FINISH_DATE = <cfif len(attributes.finish_date)>#attributes.finish_date#<cfelse>NULL</cfif>,
			UPDATE_DATE = #now()#,
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_IP = '#cgi.remote_addr#',
			CARD_NO = <cfif len(attributes.card_no)>#attributes.card_no#<cfelse>NULL</cfif> 
		WHERE
			PASSWORD_ID = #attributes.password_id#
	</cfquery>
	<cfif isdefined("attributes.is_detail")>
	<script type="text/javascript">
		wrk_opener_reload(); 
		self.close();
	</script>
	<cfelse>
	<script type="text/javascript">
		window.location.href='<cfoutput>#request.self#?fuseaction=assetcare.fuel_password</cfoutput>';
		self.close();
	</script>
	</cfif>
	