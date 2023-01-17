<!--- Bu Sayfadan Gonderilen Parametreler Uretim Planlamadaki Standart Query Dosyalarina Gore Duzenleniyor FBS 20111215 --->
<cftry>
	<!--- Bu Bloktaki Bilgiler Dinamik Olarak Gelmek Uzere Degistirilecek!!!!!!!! --->
	<!--- EP --->
	<!---<cfset attributes.process_cat = 202>
	<cfset attributes.process_stage = 11>
	<cfset attributes.process_type_110 = 22>
	<cfset attributes.process_type_111 = 23>
	<cfset attributes.process_type_112 = 24>
	<cfset attributes.process_type_119 = 31>
	<cfset attributes.process_type_81 = 20>--->
	<!--- EST
	<cfset attributes.process_cat = 113>
	<cfset attributes.process_stage = 41>
	<cfset attributes.process_type_110 = 90>
	<cfset attributes.process_type_111 = 91>
	<cfset attributes.process_type_112 = 92>
	<cfset attributes.process_type_119 = 99>
	<cfset attributes.process_type_81 = 65>
	 --->
	<!--- //Bu Bloktaki Bilgiler Dinamik Olarak Gelmek Uzere Degistirilecek!!!!!!!! --->
	
	<cfset attributes.start_h = 0>
	<cfset attributes.start_m = 0>
	<cfset attributes.finish_h = 1>
	<cfset attributes.finish_m = 0>
	<cfset x_is_add_operation_result = 0>
	<cfset attributes.exit_department = attributes.exit_department_location>
	<cfset attributes.production_department = attributes.production_department_location>
	<cfset attributes.enter_department = attributes.enter_department_location>
	<cfset attributes.lot_no = attributes.search_lot_no>
	<cfset attributes.ref_no = "">
	<cfset attributes.old_lot_no = "">
	<cfset attributes.is_changed_spec_main = 0>
	<cfset form.process_cat = attributes.process_cat>
	<cfset attributes.order_no = "">
	<cfset attributes.reference_no = "">
	<cfset attributes.expense_employee_id = session.pda.userid>
	<cf_papers paper_type="production_result">
		
	<cfinclude template="../../production_plan/query/upd_prod_order_result.cfm">
	
	<!--- Stok Fisi Olusturuluyor --->
	<cfif isDefined("attributes.is_newstock") and attributes.is_newstock eq 1>
		<cfquery name="GET_PRODUCTION_RESULT_DETAIL" datasource="#DSN3#">
			SELECT 
				PRODUCTION_ORDERS.REFERENCE_NO REFERANS,
				PRODUCTION_ORDERS.PROJECT_ID,
				PRODUCTION_ORDERS.P_ORDER_NO,
				PRODUCTION_ORDERS.ORDER_ID,
				PRODUCTION_ORDERS.IS_DEMONTAJ,
				PRODUCTION_ORDERS.QUANTITY AS AMOUNT,
				PRODUCTION_ORDER_RESULTS.*
			FROM
				PRODUCTION_ORDERS,
				PRODUCTION_ORDER_RESULTS
			WHERE
				PRODUCTION_ORDERS.P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_id#"> AND 
				PRODUCTION_ORDER_RESULTS.PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pr_order_id#"> AND
				PRODUCTION_ORDERS.P_ORDER_ID = PRODUCTION_ORDER_RESULTS.P_ORDER_ID
		</cfquery>
		<cfset attributes.project_id = get_production_result_detail.project_id>
		<cfset attributes.pr_order_id = get_production_result_detail.pr_order_id>
		<cfset attributes.is_demontaj = get_production_result_detail.is_demontaj>
		
		<cfinclude template="../../production_plan/query/add_production_result_to_stock.cfm">
	</cfif>
	<!--- //Stok Fisi Olusturuluyor --->

	<script language="javascript" type="text/javascript">
		alert("İşlem Başarıyla Gerçekleşti!");
		window.location.href="<cfoutput>#request.self#?fuseaction=pda.form_upd_production_result&p_order_id=#attributes.p_order_id#&pr_order_id=#attributes.pr_order_id#</cfoutput>";
	</script>
	
	<cfcatch>
		<script language="javascript" type="text/javascript">
			alert("Üretim Sonucu Güncellenirken Sorun Oluştu!");
			window.history.back();
		</script>
	</cfcatch>
</cftry>
