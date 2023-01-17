<cfif len(attributes.is_rel_subs)>
	<cflock name="#CreateUUID()#" timeout="60">
		<cftransaction>
			<cfquery name="UPD_SUBS_INFO" datasource="#dsn3#">
				UPDATE
					SUBSCRIPTION_CONTRACT
				SET
					MEMBER_CC_ID = #attributes.member_cc_id#
				WHERE
					SUBSCRIPTION_ID IN (#attributes.is_rel_subs#)
			</cfquery>
		</cftransaction>
	</cflock>
</cfif>
<script type="text/javascript">
	window.close();
</script>
