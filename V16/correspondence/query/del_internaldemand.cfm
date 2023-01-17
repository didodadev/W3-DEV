<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<!--- Silme Islemi Yapiliyor --->
		<cfinclude template="del_internaldemand_ic.cfm">
	</cftransaction>
</cflock>
<cfif isdefined('attributes.type_') and attributes.type_ eq 1>
	<script type="text/javascript">
		window.location.href = '<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_purchasedemand</cfoutput>';
	</script>
<cfelse>
	<script type="text/javascript">
		window.location.href = '<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_internaldemand</cfoutput>';
	</script>
</cfif>
