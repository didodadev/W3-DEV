<cf_get_lang_set module_name="myhome">
<cfif isdefined("attributes.is_form_submitted")>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<cfparam name="attributes.start_date" default='#dateformat(date_add("d", -7, now()),"dd/mm/yyyy")#'>
<cfparam name="attributes.finish_date" default='#dateformat(now(),"dd/mm/yyyy")#'>
<cfparam name="attributes.keyword" default="">
<cfif len(attributes.start_date)>
  <cf_date tarih='attributes.start_date'>
</cfif>
<cfif len(attributes.finish_date)>
  <cf_date tarih='attributes.finish_date'>
</cfif>
<cfinclude template="../myhome/query/get_notices.cfm">
<cfparam name='attributes.totalrecords' default="#get_notices.recordcount#">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

		<cfif get_notices.recordcount and form_varmi eq 1>
			<cfoutput query="get_notices" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfif len(get_notices.department_id) and len(get_notices.branch_id) and len(get_notices.our_company_id)>
					<cfquery name="get_branchs" datasource="#dsn#">
						SELECT 
							BRANCH.BRANCH_NAME,
							DEPARTMENT.DEPARTMENT_HEAD,
							OUR_COMPANY.NICK_NAME,
							OUR_COMPANY.COMPANY_NAME
						FROM 
							DEPARTMENT,
							BRANCH,
							OUR_COMPANY
						WHERE 
							OUR_COMPANY.COMP_ID=#get_notices.our_company_id# AND
							BRANCH.BRANCH_ID= #get_notices.branch_id# AND
							DEPARTMENT_ID = #get_notices.department_id#
					</cfquery>
				</cfif>
		  </cfoutput>
		</cfif>
<cfset url_str = "">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif len(attributes.start_date)>
	<cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,'dd/mm/yyyy')#">
</cfif>
<cfif len(attributes.finish_date)>
	<cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,'dd/mm/yyyy')#">
</cfif>
<cfif isdefined("attributes.is_form_submitted") and len(attributes.is_form_submitted)>
	<cfset url_str = "#url_str#&is_form_submitted=#attributes.is_form_submitted#">
</cfif>

<script type="text/javascript">
	<cfif isdefined("attributes.event") and attributes.event is "list" or not isdefined("attributes.event")>
		$(document).ready(function(){
			document.getElementById('keyword').focus();
		});
	<cfelseif isdefined("attributes.event") and (attributes.event is "add" or attributes.event is "upd")>

	</cfif>
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'myhome.list_notices';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'myhome/display/list_notices.cfm';
</cfscript>
