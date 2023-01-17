<cfinclude template="../fbx_workcube_param_gecici.cfm">
<cfset attributes.upload_folder = "#index_folder#V16#dir_seperator#admin_tools">
<cfscript>
	session.ep = StructNew();
	session.ep.userid = 1;
</cfscript>
<cftry>
    <cfquery name="get_offer" datasource="#DSN#_1">
        SELECT TOP 1 * FROM OFFER
    </cfquery>
    <cfcatch type="any">
        <cfif fusebox.use_period>
			<cfset db_user_ = database_username>
            <cfset db_pass_ = database_password>
    		
            <cfif database_type IS "MSSQL">
                <cf_add_company_db username="#db_user_#" password="#db_pass_#" company_id="1" dsn="#DSN#" host="#database_host#" upload_folder="#attributes.upload_folder#">
            <!---<cfelseif database_type IS "DB2">
                <cf_add_company_db_db2 username="#db_user_#" password="#db_pass_#" company_id="1" dsn="#DSN#" host="#database_host#" upload_folder="#attributes.upload_folder#">
            --->
            </cfif>
        </cfif>
    </cfcatch>
</cftry>
<cfscript>
	StructDelete(session,'ep');
</cfscript>
