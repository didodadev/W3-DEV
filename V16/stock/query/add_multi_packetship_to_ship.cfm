<!--- 	
	FBS 20110101
	Sorunlu Kayitlar Varsa; Sorunlu Kaydin Bulundugu Sevkiyattan, Ilgili Sonuc Satirinda Servis Verildi Alanini, 
	Emirlere Tekrar Gelmemesi Icin Update Eder (Ilerde Action File Yapilabilir) 
 --->
 <cfsetting showdebugoutput="yes">
<cfset Problem_Row_Relation_Ids = "">
<cfif isDefined("attributes.record_num") and Len(attributes.record_num)>
	<cfloop from="1" to="#attributes.record_num#" index="wro">
		<cfif isDefined("attributes.row_kontrol#wro#") and Evaluate("attributes.row_kontrol#wro#") eq 1>
			<cfif not ListFind(attributes.order_wrk_row_list,Evaluate("attributes.order_wrk_row_id#wro#"))>
				<cfset Problem_Row_Relation_Ids = ListAppend(Problem_Row_Relation_Ids,Evaluate("attributes.order_wrk_row_id#wro#"))>
			</cfif>
		</cfif>
	</cfloop>
	<cfquery name="Get_Ship_Result_Row_Problem" datasource="#dsn2#">
		SELECT SHIP_RESULT_ID, WRK_ROW_ID FROM SHIP_RESULT_ROW WHERE SHIP_RESULT_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_result_id#"> AND IS_PROBLEM = 0 AND WRK_ROW_RELATION_ID IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" value="#Problem_Row_Relation_Ids#">)
	</cfquery>
	<cfif Get_Ship_Result_Row_Problem.RecordCount>
		<cfloop query="Get_Ship_Result_Row_Problem">
			<cfquery name="Upd_Ship_Result_Row_Problem" datasource="#dsn2#">
				UPDATE
					SHIP_RESULT_ROW_COMPLETE
				SET
					IS_GIVE_SERVICE = 1
				WHERE
					SHIP_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Ship_Result_Row_Problem.Ship_Result_Id#"> AND
					WRK_ROW_RELATION_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Get_Ship_Result_Row_Problem.Wrk_Row_Id#">
			</cfquery>
		</cfloop>
	</cfif>
</cfif>
<cfif x_select_process_type eq 1>
	<!--- Irsaliye Ekleme --->
	<cfinclude template="../../objects/functions/add_ship_from_order.cfm">
	<cfsetting requesttimeout="6000">
	<cfif Len(attributes.order_wrk_row_list)and len(attributes.process_type_ship)>
		<cftry>
			İrsaliyeler Oluşuyor Lütfen Sayfayı Yenilemeyiniz !
			<cfscript>
				add_ship_from_order(order_wrk_row_id_list:attributes.order_wrk_row_list,process_catid:listlast(attributes.process_type_ship,'_'),ship_result_id:attributes.ship_result_id,x_ship_group_dept:attributes.x_ship_group_dept);
			</cfscript>
			<cfcatch> 
				<script type="text/javascript">
					alert("İrsaliye Kaydınız Tamamlanamadı.Lütfen Verilerin Doğruluğunu Kontrol Ediniz!");
					history.back();
				</script>
			</cfcatch>
		</cftry>
	</cfif>
<cfelse>
	<!--- Fatura Ekleme --->
	<cfinclude template="../../objects/functions/add_invoice_from_ship_result.cfm">
	<cfsetting requesttimeout="6000">
	<cfif Len(attributes.order_wrk_row_list)and len(attributes.process_type_ship)>
		 <cftry>
			Faturalar Oluşuyor Lütfen Sayfayı Yenilemeyiniz !
			<cfscript>
				add_invoice_from_ship_result(order_wrk_row_id_list:attributes.order_wrk_row_list,process_catid:listlast(attributes.process_type_ship,'_'),ship_result_id:attributes.ship_result_id,x_ship_group_dept:attributes.x_ship_group_dept);
			</cfscript>
			<cfcatch> 
				<script type="text/javascript">
					alert("Fatura Kaydınız Tamamlanamadı.Lütfen Verilerin Doğruluğunu Kontrol Ediniz!");
					history.back();
				</script>
			</cfcatch>
		</cftry>
	</cfif>
</cfif>

