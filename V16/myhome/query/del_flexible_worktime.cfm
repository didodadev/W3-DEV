<cfset flex_component = createObject("component","V16.myhome.cfc.flexible_worktime")>
<cfset process_component = createObject("component","V16.objects.cfc.process_is_active")>
<cfif attributes.fuseaction eq 'myhome'>
    <cfset flexible_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.flexible_id,accountKey:'wrk')>
</cfif>
<cfset del_flexible = flex_component.DEL_FLEXIBLE(worktime_flexible_id : flexible_id)>
<cfset del_flexible_row = flex_component.DEL_FLEXIBLE_ROW(worktime_flexible_id : flexible_id)>
<cfset passive_process = process_component.PROCESS_IS_ACTIVE(action_table : 'WORKTIME_FLEXIBLE', action_id : flexible_id, is_active : 0)>
<script type="text/javascript">
    <cfif listfirst(attributes.fuseaction,'.') is 'myhome'>
    window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.flexible_worktime</cfoutput>";
    <cfelse>
        window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.flexible_worktime</cfoutput>";
    </cfif>
</script>