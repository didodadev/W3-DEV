<cf_get_lang_set module_name="campaign">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
<cfif isdefined("attributes.form_submitted") and attributes.form_submitted eq 1>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<cfparam name="attributes.task_par_id" default="">
<cfparam name="attributes.task_cmp_id" default="">
<cfparam name="attributes.task_employee_id" default="">
<cfparam name="attributes.task_person_name" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.form_submitted" default="0">
<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
<cfelse>
	<cfset attributes.start_date = "">
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
<cfelse>
	<cfset attributes.finish_date = "">
</cfif>
<cfif isdefined("attributes.form_submitted") and attributes.form_submitted eq 1>
	<cfquery name="get_forwarded_mail_list" datasource="#dsn3#">
	SELECT 
			E.EMPLOYEE_NAME,E.EMPLOYEE_SURNAME,
			SC.CONT_ID,SC.SENDER_EMP,
			SC.SEND_DATE,
			CAM.CAMP_ID,
            CAM.CAMP_HEAD,
			C.CONT_HEAD
		FROM 
			#dsn_alias#.SEND_CONTENTS SC ,
			CAMPAIGNS CAM,
			#dsn_alias#.CONTENT_RELATION CR,
			#dsn_alias#.CONTENT C,
			#dsn_alias#.EMPLOYEES E
		WHERE
		 	CR.ACTION_TYPE = 'CAMPAIGN_ID'
			AND CR.ACTION_TYPE_ID=CAM.CAMP_ID
			AND SC.CONT_ID = C.CONTENT_ID 
			AND CR.CONTENT_ID = C.CONTENT_ID
			AND E.EMPLOYEE_ID=SC.SENDER_EMP
			AND SC.CAMP_ID=CAM.CAMP_ID
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
			AND
			(
				CAM.CAMP_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
				CAM.CAMP_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
				CAM.CAMP_OBJECTIVE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
			)
		</cfif>
		<cfif len(attributes.task_employee_id)>
			AND SC.SENDER_EMP=#attributes.task_employee_id#
		</cfif>
		<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
			AND SC.SEND_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
		</cfif>
		<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
			AND SC.SEND_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',7,attributes.finish_date)#">
		</cfif>
		ORDER BY SC.SEND_DATE DESC
	</cfquery>
    <cfset ids_list2="">
	<cfset campaign_id_list2 = ValueList(get_forwarded_mail_list.camp_id)>
    <cfoutput query="get_forwarded_mail_list">
        <cfset ids_list2 = listappend(ids_list2,"#camp_id#-#cont_id#")>
    </cfoutput>
    <cfset sender_id_list2 = ValueList(get_forwarded_mail_list.sender_emp)>
<cfelse>
	<cfset get_forwarded_mail_list.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="20">
<cfparam name="attributes.totalrecords" default="#get_forwarded_mail_list.recordcount#">
<cfset attributes.startrow =((attributes.page-1)*attributes.maxrows+1)>
</cfif>
<cfscript>


// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'campaign.list_forwarded_campaign_content';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'campaign/display/list_forwarded_campaign_content.cfm';
	

// Tab Menus //
	//tabMenuStruct = StructNew();
//	tabMenuStruct['#attributes.fuseaction#'] = structNew();
//	tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
	
	
</cfscript>
<script type="text/javascript">
//Event : list
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		function kontrol()
			{
				if( !date_check(document.getElementById('start_date'),document.getElementById('finish_date'), "<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
					return false;
				else
					return true;
			}
		document.getElementById('keyword').focus();
	</cfif>
</script>
