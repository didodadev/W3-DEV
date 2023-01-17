<cfset url_str = "">
<cfif isdefined('attributes.keyword')>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined('attributes.day_type')>
	<cfset url_str = "#url_str#&day_type=#attributes.day_type#">
</cfif>
<cfif isdefined('attributes.related_company')>
	<cfset url_str = "#url_str#&related_company=#attributes.related_company#">
</cfif>
<cfif isdefined('attributes.pdks_status')>
	<cfset url_str = "#url_str#&pdks_status=#attributes.pdks_status#">
</cfif>
<cfif isdefined('attributes.form_submit')>
	<cfset url_str = "#url_str#&form_submit=#attributes.form_submit#">
</cfif>	
<cfif isdefined('attributes.branch_id')>
	<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
</cfif>	
<cfif isdefined('attributes.department')>
	<cfset url_str = "#url_str#&department=#attributes.department#">
</cfif>	
<cfif isdefined('attributes.filter_process')>
	<cfset url_str = "#url_str#&filter_process=#attributes.filter_process#">
</cfif>	
<cfif isdefined('attributes.date1')>
	<cfset url_str = "#url_str#&date1=#attributes.date1#">
</cfif>	
<cfif isdefined('attributes.date2')>
	<cfset url_str = "#url_str#&date2=#attributes.date2#">
</cfif>	
<cfif isdefined('attributes.hierarchy')>
	<cfset url_str = "#url_str#&hierarchy=#attributes.hierarchy#">
</cfif>	
<cfif isdefined('attributes.work_date1')>
	<cfset url_str = "#url_str#&work_date1=#attributes.work_date1#">
</cfif>	
<cfif isdefined('attributes.work_date2')>
	<cfset url_str = "#url_str#&work_date2=#attributes.work_date2#">
</cfif>	
<cfif isdefined('attributes.shift_status')>
	<cfset url_str = "#url_str#&shift_status=#attributes.shift_status#">
</cfif>	
<cfif isdefined('attributes.group_paper_no')>
	<cfset url_str = "#url_str#&group_paper_no=#attributes.group_paper_no#">
</cfif>	
<cfif isdefined('attributes.working_space')>
	<cfset url_str = "#url_str#&working_space=#attributes.working_space#">
</cfif>	
&work_date2=&related_company=&filter_process=702&shift_status=&branch_id=all&group_paper_no=&department=&working_space=
<cfloop from="1" to="#listlen(attributes.id_list)#" index="i">
	<cfset ewt_id = listlast(listgetat(attributes.id_list,i,','),';')>
    <cfquery name="del_worktime" datasource="#dsn#">
        DELETE FROM
            EMPLOYEES_EXT_WORKTIMES
        WHERE
            EWT_ID = #EWT_ID#
    </cfquery>
</cfloop>
<cfset process_component = createObject("component","V16.objects.cfc.process_is_active")>
<cfset passive_process = process_component.PROCESS_IS_ACTIVE(action_table : 'EMPLOYEES_EXT_WORKTIMES', action_id : ewt_id, is_active : 0)>
<cflocation url="#request.self#?fuseaction=#attributes.fsactn##url_str#" addtoken="No">
