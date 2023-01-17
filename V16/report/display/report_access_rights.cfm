<cfif not session.ep.admin>
	<cfif isdefined("attributes.report_id")>
		<cfquery name="get_access" datasource="#dsn#">
			SELECT 
				COUNT(*) AS ACCESS_CONTROL
			FROM
				REPORT_ACCESS_RIGHTS,
				EMPLOYEE_POSITIONS
			WHERE
				REPORT_ACCESS_RIGHTS.REPORT_ID = #attributes.report_id# AND 
				EMPLOYEE_POSITIONS.EMPLOYEE_ID = #session.ep.userid# AND
				(
				REPORT_ACCESS_RIGHTS.POS_CAT_ID = EMPLOYEE_POSITIONS.POSITION_CAT_ID
				OR
				REPORT_ACCESS_RIGHTS.POS_CODE = #session.ep.position_code#
				)
		</cfquery>
		
		<cfif get_access.ACCESS_CONTROL IS 0>
			<cfset session.error_text = "Bu işlemi yapmaya yetki seviyeniz uygun değil.">
                <script type="text/javascript">
                    alert("<cf_get_lang dictionary_id ='29985.Bu Raporu Görüntülemeye Yetkili Değilsiniz'>!");
                    window.history.go(-1);
                </script>
			<cfabort>
		</cfif>
	</cfif>
</cfif>
