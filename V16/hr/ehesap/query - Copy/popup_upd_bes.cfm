<cfloop from="1" to="#attributes.rowCount_sabit#" index="i">
	<cfif evaluate("attributes.sabit_row_kontrol_#i#") eq 1>
        <cfquery name="add_row" datasource="#dsn#">
            UPDATE 
                SALARYPARAM_BES
            SET
                COMMENT_BES_ID = #evaluate("attributes.sabit_comment_bes_id#i#")#, 
                COMMENT_BES = '#wrk_eval("attributes.sabit_comment_bes#i#")#',
                RATE_BES = #evaluate("attributes.sabit_amount_bes#i#")#,
                START_SAL_MON = #evaluate("attributes.sabit_start_sal_mon#i#")#,
                END_SAL_MON = #evaluate("attributes.sabit_end_sal_mon#i#")#,
                EMPLOYEE_ID = #attributes.EMPLOYEE_ID#,
                TERM = #evaluate("attributes.sabit_term#i#")#,
                UPDATE_DATE = #NOW()#,
                UPDATE_EMP = #SESSION.EP.USERID#,
                UPDATE_IP = '#CGI.REMOTE_ADDR#'
            WHERE
                EMPLOYEE_ID=#attributes.EMPLOYEE_ID# AND
                IN_OUT_ID = #attributes.in_out_id# AND
                SPB_ID = #evaluate("attributes.sabit_spb_id#i#")#
        </cfquery>
	<cfelse>
		<cfquery name="del_" datasource="#dsn#">
			DELETE FROM SALARYPARAM_BES WHERE SPB_ID = #evaluate("attributes.sabit_spb_id#i#")#
		</cfquery>
	</cfif>
</cfloop>
<cfloop from="1" to="#attributes.rowCount#" index="i">
	<cfif evaluate("attributes.row_kontrol_#i#") eq 1>
        <cfquery name="add_row" datasource="#dsn#">
            INSERT INTO SALARYPARAM_BES
                (
                	COMMENT_BES_ID,
                    COMMENT_BES,
                    RATE_BES,
                    START_SAL_MON,
                    END_SAL_MON,
                    EMPLOYEE_ID,
                    TERM,
                    IN_OUT_ID,
                    UPDATE_DATE,
                    UPDATE_EMP,
                    UPDATE_IP
                )
            VALUES
                (
                    #evaluate("attributes.comment_bes_id#i#")#,
                    '#wrk_eval("attributes.comment_bes#i#")#',
                    #evaluate("attributes.amount_bes#i#")#,
                    #evaluate("attributes.start_sal_mon#i#")#,
                    #evaluate("attributes.end_sal_mon#i#")#,
                    #attributes.employee_id#,
                    #evaluate("attributes.term#i#")#,
                    #attributes.in_out_id#,
                    #NOW()#,
                    #SESSION.EP.USERID#,
                    '#CGI.REMOTE_ADDR#'
                )
        </cfquery>
	</cfif>
</cfloop>
<cfif isdefined("attributes.from_upd_salary") and len(attributes.from_upd_salary)>
	<cflocation url="#request.self#?fuseaction=ehesap.list_salary&event=upd&in_out_id=#attributes.in_out_id#&employee_id=#attributes.employee_id#&type=8" addtoken="No">
<cfelseif not isdefined("attributes.draggable")>
	<script type="text/javascript">
		window.close();
	</script>
<cfelse>
	<script type="text/javascript">
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
	</script>
</cfif>