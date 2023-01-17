<cfif not isdefined("attributes.acc_type_id")>
	<cfquery name="add_acc_type" datasource="#dsn#" result="MAX_ID">
		INSERT INTO 
			SETUP_ACC_TYPE
		(
			ACC_TYPE_NAME,
			IS_HR_USER,
			IS_EHESAP_USER,
            IS_SALARY_ACCOUNT,
            IS_PAYMENT_ACCOUNT,
			RECORD_IP,
			RECORD_DATE,
			RECORD_EMP
		) 
		VALUES 
		(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.acc_type_name#">,
			<cfif isdefined("attributes.is_hr_user")>1<cfelse>0</cfif>,
			<cfif isdefined("attributes.is_ehesap_user")>1<cfelse>0</cfif>,
			<cfif isdefined("attributes.is_salary_account")>1<cfelse>0</cfif>,
			<cfif isdefined("attributes.is_payment_account")>1<cfelse>0</cfif>,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
		)
        SELECT SCOPE_IDENTITY() MAX_ID
	</cfquery>
    <cfset acc_type_id_ = add_acc_type.MAX_ID>
<cfelse>
	<cfquery name="upd_acc_type" datasource="#dsn#">
		UPDATE 
			SETUP_ACC_TYPE
		SET
			ACC_TYPE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.acc_type_name#">,
			IS_HR_USER = <cfif isdefined("attributes.is_hr_user")>1<cfelse>0</cfif>,
			IS_EHESAP_USER = <cfif isdefined("attributes.is_ehesap_user")>1<cfelse>0</cfif>,
			IS_SALARY_ACCOUNT = <cfif isdefined("attributes.is_salary_account")>1<cfelse>0</cfif>,
			IS_PAYMENT_ACCOUNT = <cfif isdefined("attributes.is_payment_account")>1<cfelse>0</cfif>,
            UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
			UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
		WHERE  
			ACC_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.acc_type_id#">
	</cfquery>
	<cfquery name="delete_type_posid" datasource="#dsn#">
		DELETE FROM SETUP_ACC_TYPE_POSID WHERE ACC_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.acc_type_id#">
    </cfquery>
    <cfset acc_type_id_ = attributes.acc_type_id>
</cfif>
<cfif isdefined('attributes.to_pos_ids') and len(attributes.to_pos_ids)>
	<cfloop list="#attributes.to_pos_ids#" delimiters="," index="indx">
		<cfquery name="add_type_posid" datasource="#dsn#">
			INSERT INTO
			SETUP_ACC_TYPE_POSID
			(
				ACC_TYPE_ID,
				POSITION_ID,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_integer" value="#acc_type_id_#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#indx#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
			 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">
			)                    
		</cfquery>
	</cfloop>
</cfif>
<cflocation url="#request.self#?fuseaction=settings.form_add_acc_type" addtoken="no">

