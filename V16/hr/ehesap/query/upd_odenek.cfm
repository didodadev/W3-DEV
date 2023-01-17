<cfquery name="upd_odenek" datasource="#dsn#">
	UPDATE 
		SETUP_PAYMENT_INTERRUPTION
	SET
		STATUS = <cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
		COMMENT_PAY = '#attributes.comment#',
		PERIOD_PAY = #attributes.PERIOD#,
		METHOD_PAY = #attributes.METHOD#,
		AMOUNT_PAY = #attributes.AMOUNT#,
		SSK = #attributes.SSK#,
		TAX = #attributes.TAX#,
		SHOW = <cfif isDefined("attributes.SHOW")>1, <cfelse>0,</cfif>
		CALC_DAYS = #attributes.CALC_DAYS#,
		<cfif session.ep.ehesap>
		IS_EHESAP = <cfif isDefined("attributes.IS_EHESAP")>1,<cfelse>0,</cfif>
		</cfif>
		IS_KIDEM = <cfif isDefined("attributes.IS_KIDEM")>1, <cfelse>0,</cfif>
		IS_ISSIZLIK = #attributes.IS_ISSIZLIK#,
		IS_DAMGA = #attributes.IS_DAMGA#,
		START_SAL_MON = #attributes.start_sal_mon#,
		END_SAL_MON = #attributes.end_sal_mon#,
		IS_ODENEK = 1,
		FROM_SALARY=#attributes.from_salary#,
		SSK_EXEMPTION_TYPE = <cfif len(attributes.SSK_EXEMPTION_TYPE)>#attributes.SSK_EXEMPTION_TYPE#<cfelse>NULL</cfif>,
		SSK_EXEMPTION_RATE = <cfif len(attributes.ssk_muafiyet_orani)>#attributes.ssk_muafiyet_orani#<cfelse>NULL</cfif>,
		TAX_EXEMPTION_RATE = <cfif len(attributes.gelir_vergisi_muafiyet_orani)>#attributes.gelir_vergisi_muafiyet_orani#<cfelse>NULL</cfif>,
		TAX_EXEMPTION_VALUE = <cfif len(attributes.gelir_vergisi_limiti)>#attributes.gelir_vergisi_limiti#<cfelse>NULL</cfif>,
		AMOUNT_MULTIPLIER = <cfif len(attributes.amount_multiplier)>#attributes.amount_multiplier#<cfelse>NULL</cfif>,
		IS_AYNI_YARDIM = <cfif isDefined("attributes.is_ayni_yardim")>1,<cfelse>0,</cfif>
		IS_INCOME = <cfif isDefined("attributes.is_income")>1,<cfelse>0,</cfif>
		IS_NOT_EXECUTION = <cfif isDefined("attributes.is_not_execution")>1,<cfelse>0,</cfif>
        MONEY = '#attributes.money#',
		ACC_TYPE_ID = <cfif isDefined("attributes.acc_type_id") and len(attributes.acc_type_id)>#attributes.acc_type_id#<cfelse>NULL</cfif>,
		FACTOR_TYPE = <cfif isDefined("attributes.factor_type") and len(attributes.factor_type)>#attributes.factor_type#<cfelse>NULL</cfif>,
		COMMENT_TYPE = <cfif isDefined("attributes.comment_type") and len(attributes.comment_type)>#attributes.comment_type#<cfelse>NULL</cfif>,
		IS_RD_DAMGA = <cfif isDefined("attributes.is_rd_damga")>1<cfelse>0</cfif>,
        IS_RD_GELIR  = <cfif isDefined("attributes.is_rd_gelir")>1<cfelse>0</cfif>,
        IS_RD_SSK  = <cfif isDefined("attributes.is_rd_ssk")>1<cfelse>0</cfif>,
		CHILD_HELP = <cfif isDefined("attributes.child_help") and attributes.child_help eq 1>1<cfelse>0</cfif>,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_DATE = #now()#,
		UPDATE_IP = '#cgi.REMOTE_ADDR#',
		SSK_STATUE = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.ssk_statue#" null = "no">,
		STATUE_TYPE = <cfif isdefined("attributes.statue_type") and len(attributes.statue_type) and attributes.ssk_statue eq 2><cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.statue_type#"><cfelse>NULL</cfif>,
		DYNAMIC_RULES_ID = <cfif IsDefined("attributes.dynamic_rules_id") and len(attributes.dynamic_rules_id)><cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.dynamic_rules_id#"><cfelse>NULL</cfif>,
		EXTRA_PAYMENT_ID = <cfif IsDefined("attributes.extra_payment_id") and len(attributes.extra_payment_id)><cfqueryparam CFSQLType = "cf_sql_nvarchar" value = "#attributes.extra_payment_id#"><cfelse>NULL</cfif>
	WHERE
		ODKES_ID = #attributes.ODKES_ID#
</cfquery>
<script type="text/javascript">
   	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
  	 	window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
		location.reload();
	</cfif>
</script>
