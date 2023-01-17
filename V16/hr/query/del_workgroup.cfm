<cfquery name="get_control" datasource="#dsn#">
	SELECT TOP 1 WORKGROUP_ID FROM PRO_WORKS WHERE WORKGROUP_ID = #GROUP_ID# <!--- iş kaydı--->
	UNION ALL
	SELECT TOP 1 WORKGROUP_ID FROM PRO_PROJECTS WHERE WORKGROUP_ID = #GROUP_ID# <!--- proje kaydı--->
	UNION ALL
	SELECT TOP 1 OPP_ID FROM WORK_GROUP WHERE WORKGROUP_ID = #GROUP_ID# AND OPP_ID IS NOT NULL <!---satış fırsatları proje grubu --->
	UNION ALL
	SELECT TOP 1 WORKGROUP_ID FROM BUDGET WHERE WORKGROUP_ID = #GROUP_ID# <!--- bütçe kaydı--->
</cfquery>
<cfquery name="get_service_control" datasource="#dsn3#">
	SELECT TOP 1 WORKGROUP_ID FROM SERVICE WHERE WORKGROUP_ID = #GROUP_ID# <!--- servis başvurusu--->
</cfquery>
<cfif get_control.recordcount or get_service_control.recordcount>
	<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='65076.İş grubunun bağlı olduğu kayıtlar var silemezsiniz'>");
			window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_workgroup&event=upd&workgroup_id=#attributes.WORKGROUP_ID#</cfoutput>";
	</script>
	<cfabort>
<cfelse>
	<cfquery name="get_group" datasource="#dsn#">
		SELECT HIERARCHY FROM WORK_GROUP WHERE WORKGROUP_ID = #GROUP_ID# 	
	</cfquery>
	<!--- bu hiyerarşinin üst grubunun bağlı olduğu başka bir alt hiyerarşi var mı?--->
	<cfquery name="get_control" datasource="#dsn#">
		SELECT HIERARCHY,WORKGROUP_NAME FROM WORK_GROUP WHERE HIERARCHY LIKE '#listdeleteat(get_group.hierarchy,ListLen(get_group.hierarchy,"."),".")#.%' AND WORKGROUP_ID <> #GROUP_ID#
	</cfquery>
	<cfif not get_control.recordcount>
		<!--- bu hiyerarşinin bağlı olduğu üst grubun SUB_WORKGROUP alanını 0 set et--->
		<cfquery name="upd_group" datasource="#dsn#">
			UPDATE WORK_GROUP SET SUB_WORKGROUP = 0 WHERE HIERARCHY LIKE '#listdeleteat(get_group.hierarchy,ListLen(get_group.hierarchy,"."),".")#'
		</cfquery>
	</cfif>
	<cfquery name="del_group" datasource="#DSN#">
	  DELETE FROM WORK_GROUP WHERE WORKGROUP_ID = #GROUP_ID# 	
	
	  DELETE FROM WORKGROUP_EMP_PAR WHERE WORKGROUP_ID = #GROUP_ID# 	
	</cfquery>
    <script type="text/javascript">
		window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_workgroup</cfoutput>";
	</script>
</cfif>
