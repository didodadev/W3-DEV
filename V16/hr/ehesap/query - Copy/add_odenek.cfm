<CFLOCK name="#CREATEUUID()#" timeout="20">
	<CFTRANSACTION>
		<cfquery name="get_max_id" datasource="#dsn#">
		   SELECT MAX(ODKES_ID) AS MAX_ID FROM SETUP_PAYMENT_INTERRUPTION
		</cfquery>
		<cfquery name="ADD_ODENEK" datasource="#DSN#">
			INSERT INTO
				SETUP_PAYMENT_INTERRUPTION
				  (
					STATUS,
					ODKES_ID,
					COMMENT_PAY,
					PERIOD_PAY,
					METHOD_PAY,
					AMOUNT_PAY,
					SSK,
					TAX,
					SHOW,
					CALC_DAYS,
					START_SAL_MON,
					END_SAL_MON,
					IS_ODENEK,
					IS_KIDEM,
					IS_ISSIZLIK,
					IS_DAMGA,
					FROM_SALARY,
					SSK_EXEMPTION_TYPE,
					SSK_EXEMPTION_RATE,
					TAX_EXEMPTION_RATE,
					TAX_EXEMPTION_VALUE,
					AMOUNT_MULTIPLIER,
					IS_AYNI_YARDIM,
					IS_INCOME,
					MONEY,
					ACC_TYPE_ID,
					FACTOR_TYPE,
					COMMENT_TYPE,
                    IS_NOT_EXECUTION,
					IS_RD_DAMGA,
       				IS_RD_GELIR,
        			IS_RD_SSK,
					CHILD_HELP,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP,
					SSK_STATUE,
					STATUE_TYPE,
					DYNAMIC_RULES_ID,
					EXTRA_PAYMENT_ID
				  )
			  VALUES
				(
					<cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
					<cfif len(get_max_id.MAX_ID)>
					#get_max_id.MAX_ID#+1,
					<cfelse>
					1,
					</cfif>
					'#attributes.comment#',
					#attributes.PERIOD#,
					#attributes.METHOD#,
					<cfif isDefined("attributes.AMOUNT") and len(attributes.AMOUNT)>#attributes.AMOUNT#<cfelse>0</cfif>,
					#attributes.SSK#,
					#attributes.TAX#,
					<cfif isDefined("attributes.show")>1<cfelse>0</cfif>,
					#attributes.CALC_DAYS#,
					#attributes.start_sal_mon#,
					#attributes.end_sal_mon#,
					1,
					<cfif isDefined("attributes.IS_KIDEM")>1<cfelse>0</cfif>,
					#attributes.IS_ISSIZLIK#,
					#attributes.IS_DAMGA#,
					#attributes.from_salary#,
					<cfif len(attributes.SSK_EXEMPTION_TYPE)>#attributes.SSK_EXEMPTION_TYPE#<cfelse>NULL</cfif>,
					<cfif len(attributes.ssk_muafiyet_orani)>#attributes.ssk_muafiyet_orani#<cfelse>NULL</cfif>,
					<cfif len(attributes.gelir_vergisi_muafiyet_orani)>#attributes.gelir_vergisi_muafiyet_orani#<cfelse>NULL</cfif>,
					<cfif len(attributes.gelir_vergisi_limiti)>#attributes.gelir_vergisi_limiti#<cfelse>NULL</cfif>,
					<cfif len(attributes.amount_multiplier)>#attributes.amount_multiplier#<cfelse>NULL</cfif>,
					<cfif isDefined("attributes.is_ayni_yardim")>1<cfelse>0</cfif>,
					<cfif isDefined("attributes.is_income")>1<cfelse>0</cfif>,
					'#attributes.money#',
					<cfif isDefined("attributes.acc_type_id") and len(attributes.acc_type_id)>#attributes.acc_type_id#<cfelse>NULL</cfif>,
					<cfif isDefined("attributes.factor_type") and len(attributes.factor_type)>#attributes.factor_type#<cfelse>NULL</cfif>,
					<cfif isDefined("attributes.comment_type") and len(attributes.comment_type)>#attributes.comment_type#<cfelse>NULL</cfif>,
					<cfif isDefined("attributes.is_not_execution")>1<cfelse>0</cfif>,
					<cfif isDefined("attributes.is_rd_damga")>1<cfelse>0</cfif>,
					<cfif isDefined("attributes.is_rd_gelir")>1<cfelse>0</cfif>,
					<cfif isDefined("attributes.is_rd_ssk")>1<cfelse>0</cfif>,
					<cfif isDefined("attributes.child_help") and attributes.child_help eq 1>1<cfelse>0</cfif>,
                    #NOW()#,
					#SESSION.EP.USERID#,
					'#CGI.REMOTE_ADDR#',
					<cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.ssk_statue#" null = "no">,
					<cfif isdefined("attributes.statue_type") and len(attributes.statue_type) and attributes.ssk_statue eq 2><cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.statue_type#"><cfelse>NULL</cfif>,
					<cfif IsDefined("attributes.dynamic_rules_id") and len(attributes.dynamic_rules_id)><cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.dynamic_rules_id#"><cfelse>NULL</cfif>,
					<cfif IsDefined("attributes.extra_payment_id") and len(attributes.extra_payment_id)><cfqueryparam CFSQLType = "cf_sql_nvarchar" value = "#attributes.extra_payment_id#"><cfelse>NULL</cfif>
				)
		</cfquery>
	</CFTRANSACTION>
</CFLOCK>
<script type="text/javascript">
  	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
  		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
		location.reload();
	</cfif>
</script>