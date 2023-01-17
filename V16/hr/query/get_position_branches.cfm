<cfif not session.ep.ehesap>
	<cfquery name="my_branches" datasource="#dsn#">
		SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #SESSION.EP.POSITION_CODE#
	</cfquery>
	<cfif not my_branches.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='1746.Hiçbir Şubeye Yetkiniz Yok!Şube Yetkilerinizi Düzenleyiniz'>!");
			history.back();
		</script>
		<cfabort>
	</cfif>
	<cfset my_branch_list = valuelist(my_branches.BRANCH_ID)>
</cfif>
