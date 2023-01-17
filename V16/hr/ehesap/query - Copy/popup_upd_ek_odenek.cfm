<cfloop from="1" to="#attributes.rowCount#" index="i">
	<cfif evaluate("attributes.row_kontrol_#i#") eq 1>
		<cfif (evaluate("attributes.is_ehesap#i#") eq 1 and session.ep.ehesap) or evaluate("attributes.is_ehesap#i#") eq 0>
			<cfquery name="get_odenek_type" datasource="#dsn#">
				SELECT 
        	        ODKES_ID, 
                    COMMENT_PAY, 
                    PERIOD_PAY, 
                    METHOD_PAY, 
                    AMOUNT_PAY, 
                    SSK, 
                    TAX, 
                    SHOW, 
                    START_SAL_MON, 
                    END_SAL_MON, 
                    CALC_DAYS, 
                    FROM_SALARY, 
                    IS_KIDEM, 
                    RECORD_DATE, 
                    RECORD_EMP, 
                    RECORD_IP, 
                    UPDATE_EMP, 
                    UPDATE_DATE, 
                    UPDATE_IP, 
                    IS_EHESAP, 
                    IS_ISSIZLIK, 
                    IS_DAMGA, 
                    SSK_EXEMPTION_RATE, 
                    TAX_EXEMPTION_RATE, 
                    TAX_EXEMPTION_VALUE, 
                    IS_AYNI_YARDIM, 
                    MONEY, 
                    SSK_EXEMPTION_TYPE, 
                    AMOUNT_MULTIPLIER,
					IS_INCOME,
                    IS_NOT_EXECUTION,                    
					FACTOR_TYPE,
					COMMENT_TYPE,
					SSK_STATUE,
					STATUE_TYPE
                FROM 
    	            SETUP_PAYMENT_INTERRUPTION 
                WHERE 
	                ODKES_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.COMMENT_PAY_ID#i#')#">
			</cfquery>
			<cfquery name="add_row" datasource="#dsn#">
				INSERT INTO SALARYPARAM_PAY
					(
					COMMENT_PAY,
					COMMENT_PAY_ID,
					AMOUNT_PAY,
					AMOUNT_MULTIPLIER,
					SSK,
					TAX,
					IS_DAMGA,
					IS_ISSIZLIK,
					SHOW,
					METHOD_PAY,
					PERIOD_PAY,
					START_SAL_MON,
					END_SAL_MON,
					EMPLOYEE_ID,
					TERM,
					CALC_DAYS,
					IS_KIDEM,
					IN_OUT_ID,
					FROM_SALARY,
					<cfif session.ep.ehesap>
					IS_EHESAP,
					</cfif>
					IS_AYNI_YARDIM,
					SSK_EXEMPTION_RATE,
					SSK_EXEMPTION_TYPE,
					TAX_EXEMPTION_VALUE,
					TAX_EXEMPTION_RATE,
					MONEY,
					IS_INCOME,
					IS_NOT_EXECUTION,                                        
					FACTOR_TYPE,
					COMMENT_TYPE,
					IS_RD_DAMGA,
                    IS_RD_GELIR,
                    IS_RD_SSK,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP,
					DETAIL,
					SSK_STATUE,
					STATUE_TYPE,
					PROJECT_ID,
					PROCESS_STAGE
					)
				VALUES
					(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.COMMENT_PAY#i#')#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.COMMENT_PAY_ID#i#')#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.AMOUNT_PAY#i#')#">,
					<cfif len(get_odenek_type.amount_multiplier)><cfqueryparam cfsqltype="cf_sql_float" value="#get_odenek_type.amount_multiplier#"><cfelse>NULL</cfif>,
					<cfif len(evaluate("attributes.SSK#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.SSK#i#')#"><cfelse>NULL</cfif>,
					<cfif len(evaluate("attributes.TAX#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.TAX#i#')#"><cfelse>NULL</cfif>,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#evaluate('attributes.IS_DAMGA#i#')#">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#evaluate('attributes.IS_ISSIZLIK#i#')#">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#evaluate('attributes.SHOW#i#')#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.METHOD_PAY#i#')#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.PERIOD_PAY#i#')#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.START_SAL_MON#i#')#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.END_SAL_MON#i#')#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_ID#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.TERM#i#')#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.CALC_DAYS#i#')#">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#evaluate('attributes.IS_KIDEM#i#')#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">,
					<cfif len(evaluate("attributes.from_salary#i#"))><cfqueryparam cfsqltype="cf_sql_bit" value="#evaluate('attributes.from_salary#i#')#"><cfelse>NULL</cfif>,
					<cfif session.ep.ehesap>
						<cfqueryparam cfsqltype="cf_sql_bit" value="#evaluate('attributes.is_ehesap#i#')#">,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_bit" value="#evaluate('attributes.is_ayni_yardim#i#')#">,
					<cfif len(evaluate("attributes.SSK_EXEMPTION_RATE#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.SSK_EXEMPTION_RATE#i#')#"><cfelse>NULL</cfif>,
					<cfif len(evaluate("attributes.SSK_EXEMPTION_TYPE#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.SSK_EXEMPTION_TYPE#i#')#"><cfelse>NULL</cfif>,
					<cfif len(get_odenek_type.TAX_EXEMPTION_VALUE)><cfqueryparam cfsqltype="cf_sql_float" value="#get_odenek_type.TAX_EXEMPTION_VALUE#"><cfelse>NULL</cfif>,
					<cfif len(evaluate("attributes.TAX_EXEMPTION_RATE#i#"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.TAX_EXEMPTION_RATE#i#')#"><cfelse>NULL</cfif>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.money#i#')#">,
					<cfif len(evaluate("attributes.is_income#i#"))><cfqueryparam cfsqltype="cf_sql_bit" value="#evaluate('attributes.is_income#i#')#"><cfelse>0</cfif>,
					<cfif len(evaluate("attributes.is_not_execution#i#"))>#evaluate("attributes.is_not_execution#i#")#<cfelse>0</cfif>,
					<cfif len(evaluate("attributes.factor_type#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.factor_type#i#')#"><cfelse>NULL</cfif>,
					<cfif len(evaluate("attributes.comment_type#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.comment_type#i#')#"><cfelse>1</cfif>,
					<cfif len(evaluate("attributes.is_rd_damga#i#"))>#evaluate("attributes.is_rd_damga#i#")#<cfelse>0</cfif>,
                    <cfif len(evaluate("attributes.is_rd_gelir#i#"))>#evaluate("attributes.is_rd_gelir#i#")#<cfelse>0</cfif>,
                    <cfif len(evaluate("attributes.is_rd_ssk#i#"))>#evaluate("attributes.is_rd_ssk#i#")#<cfelse>0</cfif>,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
					<cfif len(evaluate("attributes.detail#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.detail#i#')#"><cfelse>NULL</cfif>,
					<cfif len(get_odenek_type.SSK_STATUE)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_odenek_type.SSK_STATUE#"><cfelse>1</cfif>,
					<cfif len(get_odenek_type.SSK_STATUE) and len(get_odenek_type.STATUE_TYPE) and get_odenek_type.SSK_STATUE eq 2><cfqueryparam cfsqltype="cf_sql_integer" value="#get_odenek_type.STATUE_TYPE#"><cfelse>0</cfif>,
					<cfif isdefined("attributes.project_id#i#") and len(evaluate("attributes.project_id#i#")) and len(evaluate("attributes.project_head#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.project_id#i#")#"><cfelse>NULL</cfif>,
					<cfif len(evaluate("attributes.process_stage#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.process_stage#i#')#"><cfelse>NULL</cfif>
					)
			</cfquery>
		</cfif>
	</cfif>
</cfloop>
<cfloop from="1" to="#attributes.rowCount_sabit#" index="i">
	<cfif evaluate("attributes.sabit_row_kontrol_#i#") eq 1>
		<cfif (evaluate("attributes.sabit_is_ehesap#i#") eq 1 and session.ep.ehesap) or evaluate("attributes.sabit_is_ehesap#i#") eq 0>
			<cfif len(evaluate("attributes.sabit_COMMENT_PAY_ID#i#"))>
				<cfquery name="get_odenek_type" datasource="#dsn#">
					SELECT 
                        ODKES_ID, 
                        COMMENT_PAY, 
                        PERIOD_PAY, 
                        METHOD_PAY, 
                        AMOUNT_PAY, 
                        SSK, 
                        TAX, 
                        SHOW, 
                        START_SAL_MON, 
                        END_SAL_MON, 
                        CALC_DAYS, 
                        FROM_SALARY, 
                        IS_KIDEM, 
                        RECORD_DATE, 
                        RECORD_EMP, 
                        RECORD_IP, 
                        UPDATE_EMP, 
                        UPDATE_DATE, 
                        UPDATE_IP, 
                        IS_EHESAP, 
                        IS_ISSIZLIK, 
                        IS_DAMGA, 
                        SSK_EXEMPTION_RATE, 
                        TAX_EXEMPTION_RATE, 
                        TAX_EXEMPTION_VALUE, 
                        IS_AYNI_YARDIM, 
                        MONEY, 
						IS_INCOME,
                        IS_NOT_EXECUTION,                        
                        SSK_EXEMPTION_TYPE, 
                        AMOUNT_MULTIPLIER,
						SSK_STATUE,
						STATUE_TYPE
                    FROM 
    	                SETUP_PAYMENT_INTERRUPTION 
                    WHERE 
	                    ODKES_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.sabit_COMMENT_PAY_ID#i#')#">
				</cfquery>
			</cfif>
			<cfquery name="add_row" datasource="#dsn#">
				UPDATE 
					SALARYPARAM_PAY
				SET
					COMMENT_PAY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.sabit_COMMENT_PAY#i#')#">,
					COMMENT_PAY_ID = <cfif len(evaluate("attributes.sabit_COMMENT_PAY_ID#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.sabit_COMMENT_PAY_ID#i#')#"><cfelse>NULL</cfif>,
					AMOUNT_PAY = <cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.sabit_AMOUNT_PAY#i#')#">,
					AMOUNT_MULTIPLIER = <cfif len(evaluate("attributes.sabit_COMMENT_PAY_ID#i#")) and len(get_odenek_type.AMOUNT_MULTIPLIER)><cfqueryparam cfsqltype="cf_sql_float" value="#get_odenek_type.AMOUNT_MULTIPLIER#"><cfelse>NULL</cfif>,
					TAX_EXEMPTION_VALUE = <cfif len(evaluate("attributes.sabit_COMMENT_PAY_ID#i#")) and len(get_odenek_type.TAX_EXEMPTION_VALUE)><cfqueryparam cfsqltype="cf_sql_float" value="#get_odenek_type.TAX_EXEMPTION_VALUE#"><cfelse>NULL</cfif>,
					SSK = <cfif len(evaluate("attributes.sabit_SSK#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.sabit_SSK#i#')#"><cfelse>NULL</cfif>,
					TAX = <cfif len(evaluate("attributes.sabit_TAX#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.sabit_TAX#i#')#"><cfelse>NULL</cfif>,
					IS_DAMGA = <cfqueryparam cfsqltype="cf_sql_bit" value="#evaluate('attributes.sabit_IS_DAMGA#i#')#">,
					IS_ISSIZLIK = <cfqueryparam cfsqltype="cf_sql_bit" value="#evaluate('attributes.sabit_IS_ISSIZLIK#i#')#">,
					SHOW = <cfqueryparam cfsqltype="cf_sql_bit" value="#evaluate('attributes.sabit_SHOW#i#')#">,
					METHOD_PAY = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.sabit_METHOD_PAY#i#')#">,
					PERIOD_PAY = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.sabit_PERIOD_PAY#i#')#">,
					START_SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.sabit_START_SAL_MON#i#')#">,
					END_SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.sabit_END_SAL_MON#i#')#">,
					EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_ID#">,
					TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.sabit_TERM#i#')#">,
					CALC_DAYS = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.sabit_CALC_DAYS#i#')#">,
					IS_KIDEM = <cfqueryparam cfsqltype="cf_sql_bit" value="#evaluate('attributes.sabit_IS_KIDEM#i#')#">,
					IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">,
					FROM_SALARY = <cfif len(evaluate("attributes.sabit_from_salary#i#"))><cfqueryparam cfsqltype="cf_sql_bit" value="#evaluate('attributes.sabit_from_salary#i#')#"><cfelse>NULL</cfif>,
					SSK_EXEMPTION_RATE = <cfif len(evaluate("attributes.sabit_SSK_EXEMPTION_RATE#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.sabit_SSK_EXEMPTION_RATE#i#')#"><cfelse>NULL</cfif>,
					TAX_EXEMPTION_RATE = <cfif len(evaluate("attributes.sabit_TAX_EXEMPTION_RATE#i#"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.sabit_TAX_EXEMPTION_RATE#i#')#"><cfelse>NULL</cfif>,
					SSK_EXEMPTION_TYPE = <cfif len(evaluate("attributes.sabit_SSK_EXEMPTION_TYPE#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.sabit_SSK_EXEMPTION_TYPE#i#')#"><cfelse>NULL</cfif>,
					<cfif session.ep.ehesap>IS_EHESAP = <cfqueryparam cfsqltype="cf_sql_bit" value="#evaluate('attributes.sabit_is_ehesap#i#')#">,</cfif>
					IS_AYNI_YARDIM = <cfqueryparam cfsqltype="cf_sql_bit" value="#evaluate('attributes.sabit_is_ayni_yardim#i#')#">,
					IS_INCOME = <cfif len(evaluate("attributes.sabit_is_income#i#"))><cfqueryparam cfsqltype="cf_sql_bit" value="#evaluate('attributes.sabit_is_income#i#')#"><cfelse>0</cfif>,
					IS_NOT_EXECUTION = <cfif len(evaluate("attributes.sabit_is_not_execution#i#"))>#evaluate("attributes.sabit_is_not_execution#i#")#<cfelse>0</cfif>,
                    FACTOR_TYPE = <cfif len(evaluate("attributes.sabit_factor_type#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.sabit_factor_type#i#')#"><cfelse>NULL</cfif>,
					COMMENT_TYPE = <cfif len(evaluate("attributes.sabit_comment_type#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.sabit_comment_type#i#')#"><cfelse>1</cfif>,
					MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.sabit_money#i#')#">,
					IS_RD_DAMGA = <cfif len(evaluate("attributes.sabit_is_rd_damga#i#"))>#evaluate("attributes.sabit_is_rd_damga#i#")#<cfelse>0</cfif>,
                    IS_RD_GELIR = <cfif len(evaluate("attributes.sabit_is_rd_gelir#i#"))>#evaluate("attributes.sabit_is_rd_gelir#i#")#<cfelse>0</cfif>,
                    IS_RD_SSK = <cfif len(evaluate("attributes.sabit_is_rd_ssk#i#"))>#evaluate("attributes.sabit_is_rd_ssk#i#")#<cfelse>0</cfif>,
					UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
					UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
					DETAIL = <cfif len(evaluate("attributes.sabit_detail#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.sabit_detail#i#')#"><cfelse>NULL</cfif>,
					SSK_STATUE = <cfif len(get_odenek_type.SSK_STATUE)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_odenek_type.SSK_STATUE#"><cfelse>1</cfif>,
					STATUE_TYPE = <cfif len(get_odenek_type.SSK_STATUE) and len(get_odenek_type.STATUE_TYPE) and get_odenek_type.SSK_STATUE eq 2><cfqueryparam cfsqltype="cf_sql_integer" value="#get_odenek_type.STATUE_TYPE#"><cfelse>0</cfif>,
					PROJECT_ID = <cfif isdefined("attributes.sabit_project_id#i#") and len(evaluate("attributes.sabit_project_id#i#")) and len(evaluate("attributes.sabit_project_head#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.sabit_project_id#i#")#"><cfelse>NULL</cfif>,
					PROCESS_STAGE = <cfif isDefined('attributes.sabit_process_stage#i#') And len(evaluate("attributes.sabit_process_stage#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.sabit_process_stage#i#')#"><cfelse>NULL</cfif>
				WHERE
					SPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.sabit_spp_id#i#')#">
			</cfquery>
		</cfif>
	<cfelse>
		<cfquery name="del_" datasource="#dsn#">
			DELETE FROM SALARYPARAM_PAY WHERE SPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.sabit_spp_id#i#')#">
		</cfquery>
	</cfif>
</cfloop>

<cfif isdefined("attributes.from_upd_salary") and len(attributes.from_upd_salary)>
	<cflocation url="#request.self#?fuseaction=ehesap.list_salary&event=upd&in_out_id=#attributes.in_out_id#&employee_id=#attributes.employee_id#&type=5" addtoken="No">
<cfelseif not isdefined("attributes.draggable")>
	<script type="text/javascript">
		window.close();
	</script>
<cfelse>
	<script type="text/javascript">
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
	</script>
</cfif>