<cffunction name="get_paper" access="public" returnType="query" output="no">
	<cfargument name="paper_type" required="yes" type="string">
	<cfargument name="paper_type2" required="no" type="string">
	
	<cfswitch expression="#arguments.paper_type#">
		<cfcase value="ship,revenue_receipt,invoice,e_invoice">
			<cfquery name="get_paper" datasource="#dsn3#">
				SELECT * FROM PAPERS_NO WHERE EMPLOYEE_ID = #session.ep.userid# ORDER BY PAPER_ID DESC 
			</cfquery>
			<cfif not (len(evaluate('get_paper.#arguments.paper_type#_NO')) and len(evaluate('get_paper.#arguments.paper_type#_NUMBER')))>
				<cfquery name="get_paper" datasource="#dsn3#">
					SELECT
						*
					FROM
						PAPERS_NO PN,
						#dsn_alias#.SETUP_PRINTER_USERS SPU
					WHERE
						PN.PRINTER_ID = SPU.PRINTER_ID AND
						SPU.PRINTER_EMP_ID = #session.ep.userid#
					ORDER BY
						PAPER_ID DESC 
				</cfquery>
			</cfif>
		</cfcase>
		<cfcase value="offer,order">
			<cfquery name="GET_PAPER" datasource="#DSN3#">
				SELECT 
					*
				FROM
					GENERAL_PAPERS 
				WHERE 
					ZONE_TYPE = <cfif isDefined("session.ep.userid")>0<cfelse>1</cfif> AND
					PAPER_TYPE = #arguments.paper_type2#
			</cfquery>
		</cfcase>
		<cfcase value="budget_plan,campaign,promotion,catalog,support,opportunity,service_app,prod_order,cat_prom,target_market,stock_fis,subscription,production_result,ship_fis,credit,pro_material,internal_demand,cari_to_cari,debit_claim,cash_to_cash,cash_payment,virman,incoming_transfer,outgoing_transfer,purchase_doviz,sale_doviz,creditcard_revenue,creditcard_payment,expense_cost,income_cost,production_lot,expenditure_request,quality_control,tahakkuk_plan,travel_demand,ship_internal,credit_revenue,credit_payment">
			<cfquery name="GET_PAPER" datasource="#DSN3#">
				SELECT * FROM GENERAL_PAPERS WHERE PAPER_TYPE IS NULL 
			</cfquery>
		</cfcase>
		<cfcase value="employee,emp_app,g_service_app,asset,fixtures">
			<cfquery name="GET_PAPER" datasource="#dsn#">
				SELECT * FROM GENERAL_PAPERS_MAIN WHERE EMPLOYEE_NUMBER IS NOT NULL
			</cfquery>
		</cfcase>
	</cfswitch>	
	<cfreturn get_paper>
</cffunction>
