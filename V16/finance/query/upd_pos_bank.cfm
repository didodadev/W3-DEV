<cfquery name="CHECK_POS" datasource="#dsn3#">
	SELECT POS_ID FROM POS_EQUIPMENT_BANK WHERE POS_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.POS_CODE#"> AND POS_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.POS_ID#">
</cfquery>
<cfif check_pos.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='54959.Aynı Kodlu Bir Cihaz Daha Var'> \r<cf_get_lang dictionary_id='54960.Lütfen Başka Bir Kod Giriniz'>!");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfquery name="ADD_POS" datasource="#dsn3#">
	UPDATE
		POS_EQUIPMENT_BANK
	SET
		POS_CODE = <cfif isdefined("attributes.POS_CODE") and len(attributes.POS_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.POS_CODE#"><cfelse>NULL</cfif>,
		EQUIPMENT = <cfif isdefined("attributes.EQUIPMENT") and len(attributes.EQUIPMENT)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.EQUIPMENT#"><cfelse>NULL</cfif>,
		BRANCH_ID = <cfif isdefined("attributes.BRANCH_ID") and len(attributes.BRANCH_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.BRANCH_ID#"><cfelse>NULL</cfif>,  
		CASHIER1 = <cfif isdefined("attributes.POS_CODE1") and len(attributes.POS_CODE1)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.POS_CODE1#"><cfelse>NULL</cfif>,
		CASHIER2 = 	<cfif isdefined("attributes.POS_CODE2") and len(attributes.POS_CODE2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.POS_CODE2#"><cfelse>NULL</cfif>,
		ASSETP_ID = <cfif isdefined("attributes.assetp_id") and len(attributes.assetp_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_id#"><cfelse>NULL</cfif>,  
		UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
		UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		ACCOUNT_ID = <cfif isdefined("attributes.account_id") and len(attributes.account_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.account_id#"><cfelse>NULL</cfif>,  
		COMPANY_ID = <cfif isdefined("attributes.company_id") and len(attributes.company_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"><cfelse>NULL</cfif>, 
		SELLER_CODE = <cfif isdefined("attributes.seller_code") and len(attributes.seller_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.seller_code#"><cfelse>NULL</cfif>
	WHERE
		POS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.POS_ID#">
</cfquery>
<script type="text/javascript">	
	
		location.href = document.referrer;	
	
</script>