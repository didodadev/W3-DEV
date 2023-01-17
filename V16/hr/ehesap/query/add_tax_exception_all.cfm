<cfif isdefined("attributes.record_num")>
<cfloop from="1" to="#attributes.record_num#" index="i">
	<cfif evaluate("attributes.row_kontrol_#i#") eq 1 and len(evaluate("attributes.employee_id#i#")) and len(evaluate("attributes.comment_pay#i#"))>
        <cfquery name="get_types" datasource="#dsn#">
            SELECT 
        	    TAX_EXCEPTION_ID, 
                TAX_EXCEPTION, 
                START_MONTH, 
                FINISH_MONTH, 
                AMOUNT, 
                MONEY_ID, 
                CALC_DAYS, 
                YUZDE_SINIR, 
                RECORD_DATE,
                RECORD_EMP, 
                RECORD_IP, 
                UPDATE_EMP, 
                UPDATE_DATE, 
                UPDATE_IP, 
                IS_ISVEREN, 
                IS_SSK, 
				IS_ALL_PAY,
                EXCEPTION_TYPE 
            FROM 
    	        TAX_EXCEPTION 
            WHERE
	            TAX_EXCEPTION_ID = #evaluate("attributes.tax_exception_id#i#")#
        </cfquery>
		<cfquery name="add_row" datasource="#dsn#">
			INSERT INTO SALARYPARAM_EXCEPT_TAX
				(
				TAX_EXCEPTION,
				AMOUNT,
				START_MONTH,
				FINISH_MONTH,
				EMPLOYEE_ID,
				TERM,
				CALC_DAYS,
				IN_OUT_ID,
				EXCEPTION_TYPE,
				YUZDE_SINIR,
				IS_ALL_PAY,
				IS_ISVEREN,
				IS_SSK,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
				)
			VALUES
				(
				'#wrk_eval("attributes.comment_pay#i#")#',
				#evaluate("attributes.amount_pay#i#")#,
				#evaluate("attributes.start_sal_mon#i#")#,
				#evaluate("attributes.end_sal_mon#i#")#,
				#evaluate("attributes.employee_id#i#")#,
				#evaluate("attributes.term#i#")#,
				#get_types.calc_days#,
				#evaluate("attributes.employee_in_out_id#i#")#,
                <cfif len(get_types.EXCEPTION_TYPE)>#get_types.EXCEPTION_TYPE#<cfelse>NULL</cfif>,
				<cfif len(get_types.YUZDE_SINIR)>#get_types.YUZDE_SINIR#<cfelse>NULL</cfif>,
				<cfif len(get_types.IS_ALL_PAY)>#get_types.IS_ALL_PAY#<cfelse>0</cfif>,
				<cfif len(get_types.IS_ISVEREN)>#get_types.IS_ISVEREN#<cfelse>0</cfif>,
				<cfif len(get_types.IS_SSK)>#get_types.IS_SSK#<cfelse>0</cfif>,
				#now()#,
				#session.ep.userid#,
				'#cgi.REMOTE_ADDR#'
				)
		</cfquery>
	</cfif>
</cfloop>
</cfif>
<script type="text/javascript">
	location.href="<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.list_tax_except";
</script>
