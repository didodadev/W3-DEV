<cf_date tarih="attributes.action_date">
<cf_papers paper_type="pro_material">
<cfset system_paper_no = paper_code & '-' & paper_number>
<cfset system_paper_no_add = paper_number>
<cfset attributes.fis_no= system_paper_no>
<cfif not isdefined("is_transaction")>
	<cflock name="#CREATEUUID()#" timeout="20">
		<cftransaction>
			 <cfinclude template="add_project_material_ic.cfm">
		</cftransaction>
	</cflock>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
<cfelse>
	<cfinclude template="add_project_material_ic.cfm">
</cfif>

