<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.department_id" default="">
<cfif isdefined("form_submitted")>
    <cfquery name="GET_WORKGROUPS" datasource="#DSN#">
     SELECT 
       GOAL,
       WORKGROUP_ID,
       WORKGROUP_NAME 
     FROM 
       WORK_GROUP 
     WHERE 
        STATUS = 1
      <cfif len(attributes.keyword)>
          AND
        WORKGROUP_NAME LIKE <cfqueryparam cfsqltype="cf_sql_longvarchar" value="%#attributes.keyword#%">
      </cfif>
    </cfquery>
<cfelse>
	<cfset get_workgroups.recordcount = 0>    
</cfif>

<cfif fuseaction contains "popup">
	<cfset is_popup=1>
<cfelse>
	<cfset is_popup=0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_workgroups.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>


<cfset url_str = "">
<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
	<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
</cfif>
<cfif isdefined("attributes.department_id") and len(attributes.department_id)>
	<cfset url_str = "#url_str#&department_id=#attributes.department_id#">
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'rule.workgroup';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'rules/display/list_workgroup.cfm';	
	
</cfscript>
