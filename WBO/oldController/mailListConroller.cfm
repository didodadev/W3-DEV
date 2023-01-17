<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfif isdefined("attributes.is_form_submitted")>
        <cfset form_varmi = 1>
    <cfelse>
        <cfset form_varmi = 0>
    </cfif>
    <cfparam name="attributes.keyword" default="">
    <cfquery name="GET_MAILLIST" datasource="#DSN#">
        SELECT 
            MAILLIST_NAME,
            MAILLIST_SURNAME,
            MAILLIST_EMAIL,
            MAILLIST_TELCOD,
            MAILLIST_TEL,
            MAILLIST_CONTENT
        FROM
            MAILLIST
        <cfif len(attributes.keyword)>
        WHERE
            MAILLIST_NAME + ' ' + MAILLIST_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
            MAILLIST_EMAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
            MAILLIST_CONTENT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
            MAILLIST_TELCOD + ' ' + MAILLIST_TEL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
        </cfif>
    </cfquery>
    <cfparam name="attributes.page" default="1">
    <cfparam name="attributes.maxrows" default="20">
    <cfparam name="attributes.totalrecords" default=#get_maillist.recordcount#>
    <cfset attributes.startrow =((attributes.page-1)*attributes.maxrows+1)>
</cfif>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
<cfscript>


// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'campaign.list_maillist';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'campaign/display/list_maillist.cfm';


</cfscript>
