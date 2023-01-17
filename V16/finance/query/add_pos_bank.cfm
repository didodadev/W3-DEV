<cfquery name="CHECK_POS" datasource="#dsn3#">
	SELECT POS_ID FROM POS_EQUIPMENT_BANK WHERE POS_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.POS_CODE#">
</cfquery>
<cfif check_pos.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='54959.Aynı Kodlu Bir Cihaz Daha Var'> \r<cf_get_lang dictionary_id='54960.Lütfen Başka Bir Kod Giriniz'>!");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfquery name="ADD_POS" datasource="#dsn3#" result="maxPos">
	INSERT INTO
		POS_EQUIPMENT_BANK
			(
				POS_CODE,
				EQUIPMENT,
				BRANCH_ID,
				ASSETP_ID,
				CASHIER1,
				CASHIER2,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP,
				ACCOUNT_ID,
				COMPANY_ID,
				SELLER_CODE
			)
		VALUES
			(
				<cfif isdefined("attributes.POS_CODE") and len(attributes.POS_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.POS_CODE#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.EQUIPMENT") and len(attributes.EQUIPMENT)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.EQUIPMENT#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.BRANCH_ID") and len(attributes.BRANCH_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.BRANCH_ID#"><cfelse>NULL</cfif>,  
				<cfif isdefined("attributes.assetp_id") and len(attributes.assetp_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_id#"><cfelse>NULL</cfif>,  
				<cfif isdefined("attributes.POS_CODE1") and len(attributes.POS_CODE1)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.POS_CODE1#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.POS_CODE2") and len(attributes.POS_CODE2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.POS_CODE2#"><cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                <cfif isdefined("attributes.account_id") and len(attributes.account_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.account_id#"><cfelse>NULL</cfif>,  
				<cfif isdefined("attributes.company_id") and len(attributes.company_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"><cfelse>NULL</cfif>,  
				<cfif isdefined("attributes.seller_code") and len(attributes.seller_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.seller_code#"><cfelse>NULL</cfif>
				
			)
</cfquery>
<script type="text/javascript">	
	
		location.href = document.referrer;	
	
</script>
