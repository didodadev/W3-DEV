<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="delete_report_rows" datasource="#dsn#">
			DELETE
			FROM
				ASSET_CARE_REPORT_ROW
			WHERE
				CARE_REPORT_ID = #url.care_report_id#
		</cfquery>
		<!---raporu silelim--->
		<cfquery name="delete_report" datasource="#dsn#">
			DELETE
			FROM
				ASSET_CARE_REPORT
			WHERE
				CARE_REPORT_ID = #url.care_report_id#
		</cfquery>
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.list_asset_care&form_submitted=1';
</script>
