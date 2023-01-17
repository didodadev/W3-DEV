<cfif len(attributes.UPPER_ROW_ID) and len(attributes.UPPER_ROLE_HEAD) and len(form.hierarchy1_code) and len(form.hierarchy)>
	<cfset my_hierarchy_code = attributes.hierarchy1_code & '.' & attributes.hierarchy>
<cfelseif not len(attributes.UPPER_ROW_ID) or not len(attributes.UPPER_ROLE_HEAD)>
	<cfset my_hierarchy_code = attributes.workgroup_hierarchy & '.' & attributes.hierarchy>
<cfelseif len(form.hierarchy)>
	<cfset my_hierarchy_code = attributes.hierarchy>
<cfelse>
	<cfset my_hierarchy_code = ''>
</cfif>

<cfquery name="CHECK" datasource="#dsn#">
	SELECT
		HIERARCHY
	FROM
		WORKGROUP_EMP_PAR
	WHERE
		HIERARCHY = '#my_hierarchy_code#'
</cfquery>

<cfif check.recordcount>
	<script type="text/javascript">
	alert("<cf_get_lang dictionary_id='56828.Bu Hierarşi Kullanılmaktadır Lütfen Kodu Değiştiriniz'>!");
	history.back();
	</script>
	<cfabort>
</cfif>

<cfquery name="get_work_group" datasource="#dsn#">
	SELECT
		HIERARCHY,WORKGROUP_ID
	FROM
		WORK_GROUP
	WHERE
		HIERARCHY = '#attributes.workgroup_hierarchy#'
</cfquery>


<!--- aynı çalışan eklenmesin--->
<cfquery name="get_old_recs" datasource="#dsn#">
	SELECT 
    	PARTNER_ID,
        CONSUMER_ID,
        EMPLOYEE_ID
    FROM 
    	WORKGROUP_EMP_PAR
    WHERE 
    	WORKGROUP_ID = #get_work_group.WORKGROUP_ID#
</cfquery>

<cfif member_type is 'employee' and listfind(valuelist(get_old_recs.employee_id),employee_id)>
	<script type="text/javascript">
		alert("Bu çalışan iş grubunda zaten yer almaktadır!");
		history.back();
	</script>
	<cfabort>
<cfelseif member_type is 'consumer' and listfind(valuelist(get_old_recs.consumer_id),consumer_id)>
	<script type="text/javascript">
		alert("Bu çalışan iş grubunda zaten yer almaktadır!");
		history.back();
	</script>
	<cfabort>
<cfelseif member_type is 'partner' and listfind(valuelist(get_old_recs.partner_id),partner_id)>
	<script type="text/javascript">
		alert("Bu çalışan iş grubunda zaten yer almaktadır!");
		history.back();
	</script>
	<cfabort>
</cfif>

<cfquery name="add_worker_emp" datasource="#DSN#">
	INSERT INTO 
		WORKGROUP_EMP_PAR
	(
		ORDER_NO,
		UPPER_ROW_ID,
		WORKGROUP_ID,
		EMPLOYEE_ID,
		IS_REAL,
		IS_CRITICAL,
		HIERARCHY,
		ROLE_HEAD,
		ROLE_ID,
		IS_ORG_VIEW,
		CONSUMER_ID,
		COMPANY_ID,
		PARTNER_ID,
		RECORD_EMP,
		RECORD_IP,
		RECORD_DATE
	)
	VALUES
	(
		<cfif len(attributes.ORDER_NO)>#attributes.ORDER_NO#,<cfelse>NULL,</cfif>
		<cfif len(attributes.UPPER_ROW_ID) and len(attributes.UPPER_ROLE_HEAD)>#attributes.UPPER_ROW_ID#,<cfelse>NULL,</cfif>
		#get_work_group.WORKGROUP_ID#,
		<cfif len(attributes.employee_id)>#attributes.employee_id#,<cfelse>NULL,</cfif>
		<cfif isdefined("attributes.is_real")>1,<cfelse>0,</cfif>
		<cfif isdefined("attributes.is_critical")>1,<cfelse>0,</cfif>
		'#my_hierarchy_code#',
		'#attributes.role_head#',
		<cfif len(form.role_id)>#form.role_id#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.is_org_view")>1<cfelse>0</cfif>,
		<cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>#attributes.consumer_id#,<cfelse>NULL,</cfif>
		<cfif isdefined('attributes.company_id') and len(attributes.company_id)>#attributes.company_id#,<cfelse>NULL,</cfif>
		<cfif isdefined('attributes.partner_id') and len(attributes.partner_id)>#attributes.partner_id#,<cfelse>NULL,</cfif>
		#session.ep.userid#,
		'#cgi.remote_addr#',
		#now()#
	)
</cfquery>
<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#?fuseaction=service.list_workgroup&event=upd&workgroup_id=#attributes.WORKGROUP_ID#</cfoutput>';
</script>
