<cfif isdefined("attributes.is_delete") and attributes.is_delete eq 1>
	<cfquery name="del_security_login_inf" datasource="#dsn#">
    	TRUNCATE TABLE SECURITY_LOGIN_CONTROL
    </cfquery>
<cfelse>
	<cfif attributes.is_upd eq 1>
        <cfquery name="upd_login_inf" datasource="#dsn#">
            UPDATE
                SECURITY_LOGIN_CONTROL
            SET
                IS_ACTIVE = <cfif isdefined("attributes.IS_ACTIVE") and len(attributes.IS_ACTIVE)>1<cfelse>0</cfif>,
                LOGIN_COUNT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.LOGIN_COUNT#">
        </cfquery>
    <cfelse>
        <cfquery name="upd_login_inf" datasource="#dsn#">
            INSERT INTO SECURITY_LOGIN_CONTROL
            (
                IS_ACTIVE,
                LOGIN_COUNT
            )
            VALUES
            (
                <cfif isdefined("attributes.IS_ACTIVE") and len(attributes.IS_ACTIVE)>1<cfelse>0</cfif>,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.LOGIN_COUNT#"> 
            )
        </cfquery>
    </cfif>
</cfif>
<cflocation url="#request.self#?fuseaction=settings.form_add_login_inf" addtoken="no">
