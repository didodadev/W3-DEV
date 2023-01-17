
<cfset lot=''>
<cfif len(attributes.group_code)>
<cfset lot=attributes.group_code>
</cfif>
<cfif len(attributes.level)>
<cfquery name = "get_level" datasource="#dsn3#">
    SELECT 
        INSPECTION_LEVEL_CODE
    FROM
        SETUP_INSPECTION_LEVEL WHERE INSPECTION_LEVEL_ID=#attributes.level#
</cfquery>
<cfset lot=lot&"-"&get_level.INSPECTION_LEVEL_CODE>
</cfif>
<cfif len(attributes.quality)>
<cfquery name = "get_quality" datasource="#dsn3#">
    SELECT 
        CODE
    FROM
        QUALITY_SUCCESS WHERE SUCCESS_ID=#attributes.quality#
</cfquery>
<cfset lot=lot&"-"&get_quality.CODE>
</cfif>
<cfset paper_list_id=''>
<cfloop from="1" to="#attributes.record_num#" index="i">
    <cfif isdefined("attributes.action_list#i#")>
        <cfif i eq 1>
        <cfset paper_list_id=evaluate('attributes.action_list#i#')>
        <cfelse>
        <cfset paper_list_id=paper_list_id&","&evaluate('attributes.action_list#i#')>
        </cfif>
        <cfquery name="add_row_serial" datasource="#dsn3#">
            UPDATE
            SERVICE_GUARANTY_NEW
            SET
                <cfif attributes.group eq 1>LOT_NO=<cfif len(lot)><cfqueryparam cfsqltype="nvarchar" value="#lot#"><cfelse>NULL</cfif>,</cfif>
                INSPECTION_LEVEL_ID=<cfif len(attributes.level)>#attributes.level#<cfelse>NULL</cfif>,
                QUALITY_ID=<cfif len(attributes.quality)>#attributes.quality#<cfelse>NULL</cfif>,
                GROUP_CODE=<cfif len(attributes.group_code)>'#attributes.group_code#'<cfelse>NULL</cfif>
            WHERE
                GUARANTY_ID=#evaluate('attributes.action_list#i#')#
        </cfquery>
    </cfif>
</cfloop>
<!--- Aşama Component --->
 <cfset cmp_process = createObject('component','V16.workdata.get_process')>
<cfset get_process = cmp_process.GET_PROCESS_TYPES(faction_list : 'objects.serial_no')>
    <cfset totalValues = structNew()>
    <cfset totalValues = {
            total_offtime : 0
        }>
    <cfset paper_list_id = replace(paper_list_id,";",",","all")>
    <cf_workcube_general_process
        mode = "query"
        general_paper_parent_id = "#(isDefined("attributes.general_paper_parent_id") and len(attributes.general_paper_parent_id)) ? attributes.general_paper_parent_id : 0#"
        general_paper_no = "#attributes.general_paper_no#"
        general_paper_date = "#attributes.general_paper_date#"
        action_list_id = "#paper_list_id#"
        process_stage = "#attributes.process_stage#"
        general_paper_notice = "#attributes.general_paper_notice#"
        responsible_employee_id = "#(isDefined("attributes.responsible_employee_id") and len(attributes.responsible_employee_id) and isDefined("attributes.responsible_employee") and len(attributes.responsible_employee)) ? attributes.responsible_employee_id : 0#"
        responsible_employee_pos = "#(isDefined("attributes.responsible_employee_pos") and len(attributes.responsible_employee_pos) and isDefined("attributes.responsible_employee") and len(attributes.responsible_employee)) ? attributes.responsible_employee_pos : 0#"
        action_table = 'SERVICE_GUARANTY_NEW'
        action_column = 'GUARANTY_ID'
        action_page = '#request.self#?fuseaction=objects.serial_no'
        total_values = '#totalValues#'
    >
    <cfset attributes.approve_submit = 0>
<script>
   window.location.href="<cfoutput>#request.self#</cfoutput>?fuseaction=objects.serial_no";
</script>