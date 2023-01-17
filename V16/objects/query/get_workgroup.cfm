
<cfquery name="get_workgroup" datasource="#dsn#">
   SELECT * FROM WORK_GROUP ORDER BY WORKGROUP_NAME
</cfquery>
