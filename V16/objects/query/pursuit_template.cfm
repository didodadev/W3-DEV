<cfquery name="get_pursuit_templates" datasource="#dsn#">
    SELECT 
        TEMPLATE_CONTENT 
    FROM 
        TEMPLATE_FORMS
    WHERE
        IS_PURSUIT_TEMPLATE = 1	
    <cfif isDefined("attributes.pursuit_template_id")>		
        AND TEMPLATE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pursuit_template_id#">
    </cfif>			
    ORDER BY 
        TEMPLATE_HEAD	
</cfquery>
<cfmodule
    template="/fckeditor/fckeditor.cfm"
    toolbarset="pursuitTemplate"
    basepath="/fckeditor/"
    instancename="mail_detail"
    valign="top"
    value="#get_pursuit_templates.TEMPLATE_CONTENT#"
    width="435"
    height="180">