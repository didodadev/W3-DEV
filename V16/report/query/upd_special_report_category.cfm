<cflock name="#createUUID()#" timeout="20">
	<CFTRANSACTION>
		<cfquery name="upd_special_report_cat" datasource="#dsn#">
			UPDATE
				SETUP_REPORT_CAT
			SET
				REPORT_CAT = '#FORM.REPORT_CAT#',
                DETAIL = '#FORM.DETAIL#',
				<cfif isDefined('form.upper_cat_id') and len(form.upper_cat_id)>HIERARCHY = '#FORM.UPPER_CAT_ID#',</cfif>
				UPDATE_EMP = #SESSION.EP.USERID#, 
				UPDATE_IP = '#cgi.REMOTE_ADDR#', 
				UPDATE_DATE = #NOW()#
			WHERE
				REPORT_CAT_ID = #FORM.REPORT_CAT_ID#
		</cfquery>
		
        <cfquery name="upd_cat_hirarchy" datasource="#dsn#">
            UPDATE SETUP_REPORT_CAT SET HIERARCHY = <cfif len(form.upper_cat_id)>'#form.upper_cat_id#.#FORM.REPORT_CAT_ID#'<cfelse>'#FORM.REPORT_CAT_ID#'</cfif> WHERE REPORT_CAT_ID = #FORM.REPORT_CAT_ID#
        </cfquery>
	</CFTRANSACTION>
</cflock>

<cflocation url="#request.self#?fuseaction=report.form_upd_special_report_category&report_cat_id=#FORM.report_cat_id#" addtoken="no">
