<cfif isdefined('attributes.cari_act_id') and len(attributes.cari_act_id)>
	<cflock name="#createuuid()#" timeout="20">
		<cftransaction>
			<cfquery name="DEL_CARI_ROWS" datasource="#dsn2#">
				DELETE FROM CARI_ROWS WHERE ACTION_TYPE_ID = 40 AND CARI_ACTION_ID = #attributes.cari_act_id#
			</cfquery>
		</cftransaction>
	</cflock>
</cfif>
<script type="text/javascript">
	location.href = document.referrer;
</script>
