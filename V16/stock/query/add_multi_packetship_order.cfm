<cfsetting showdebugoutput="no">
<cfquery name="Get_Related_Order_Row" datasource="#dsn3#">
	SELECT
		(SELECT SHIP_METHOD FROM #dsn_alias#.SHIP_METHOD WHERE SHIP_METHOD_ID = O.SHIP_METHOD) SHIPMETHOD_NAME,
		(SELECT PACKAGE_CONTROL_TYPE FROM #dsn1_alias#.PRODUCT WHERE PRODUCT_ID = OW.PRODUCT_ID) CONTROL_TYPE,
		*
	FROM
		ORDERS O,
		ORDER_ROW OW
	WHERE
		O.ORDER_ID = OW.ORDER_ID AND
		OW.ORDER_ROW_ID IN (#ListSort(attributes.order_row_list_,"numeric","asc",",")#)
	ORDER BY
		O.ORDER_NUMBER
</cfquery>

<cfoutput>
<cflock timeout="60">
<cftransaction>
	<cfset Repeat_Order_Numbers = "">
	<cfset Planning_Date = attributes.Planning_Date_>
	<cfset Process_Stage = attributes.process_stage>
	<cfloop query="Get_Related_Order_Row">
		
		<cfset Is_Problem_ = Evaluate('attributes.is_problem_#Order_Row_Id#')>
		<cfset Old_Planning_Id = Evaluate('attributes.old_equipment_planning_#Order_Row_Id#')>
		<cfset Planning_Id = Evaluate('attributes.equipment_planning_#Order_Row_Id#')>
		<cfif isDefined('attributes.diff_amount_#Order_Row_Id#')>
			<cfset Order_Amount = Evaluate('attributes.diff_amount_#Order_Row_Id#')>
		<cfelse>
			<cfset Order_Amount = 0>
		</cfif>
		<cfif Purchase_Sales eq 0 and Order_Zone eq 0><!--- Alis Siparisi --->
			<cfset Order_Type = 0>
		<cfelse><!--- Satis Siparisi --->
			<cfset Order_Type = 1>
		</cfif>
		<cfset Result_Wrk_Row_Id = '#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)#'>
		<cfif Len(Planning_Id)>
			<cfquery name="Get_Ship_Result" datasource="#dsn2#">
				SELECT SHIP_RESULT_ID,MAIN_SHIP_FIS_NO FROM SHIP_RESULT WHERE OUT_DATE = #Planning_Date# AND EQUIPMENT_PLANNING_ID = #Planning_Id# AND IS_TYPE = #Order_Type#
			</cfquery>
			<cfif Get_Ship_Result.RecordCount>
				<cfset Max_Ship_Result_Id = Get_Ship_Result.Ship_Result_Id>
				<cfset Paper_Full = Get_Ship_Result.MAIN_SHIP_FIS_NO>	
			<cfelseif (Planning_Id neq Old_Planning_Id) or Not Len(Old_Planning_Id)>
				<!--- Eger Daha Once Sevkiyat Kaydi Yapilmamissa veya Yapilmis Ancak Yenisine Esit Degil Ise Yeni Bir Kayit Yapilir --->
				<cfquery name="Get_Ship_Fis_No" datasource="#dsn2#">
					SELECT SHIP_FIS_NO, SHIP_FIS_NUMBER FROM #dsn3_alias#.GENERAL_PAPERS GENERAL_PAPERS WHERE PAPER_TYPE IS NULL
				</cfquery>
				<cfset Paper_Code = Evaluate('Get_Ship_Fis_No.Ship_Fis_No')>
				<cfset Paper_Number = Evaluate('Get_Ship_Fis_No.Ship_Fis_Number') +1>
				<cfset Paper_Full = '#Paper_Code#-#Paper_Number#'>

				<cfquery name="Add_Ship_Result" datasource="#dsn2#">
					INSERT INTO
						SHIP_RESULT
					(
						IS_ORDER_TERMS,
						IS_TYPE,
						EQUIPMENT_PLANNING_ID,
						COMPANY_ID,
						PARTNER_ID,
						CONSUMER_ID,
						SHIP_METHOD_TYPE,
						DELIVER_POS,
						MAIN_SHIP_FIS_NO,
						SHIP_FIS_NO,
						OUT_DATE,
						SHIP_STAGE,
						RECORD_EMP,
						RECORD_IP,
						RECORD_DATE
					)
					VALUES
					(
						1,
						#Order_Type#,
						<cfif Len(Planning_Id)>#Planning_Id#<cfelse>NULL</cfif>,
						<cfif len(Company_Id)>#Company_Id#<cfelse>NULL</cfif>,
						<cfif len(Partner_Id)>#Partner_Id#<cfelse>NULL</cfif>,
						<cfif Len(Consumer_Id)>#Consumer_Id#<cfelse>NULL</cfif>,
						1,
						#Session.Ep.UserId#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Paper_Full#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Paper_Full#">,
						#Planning_Date#,
						#Process_Stage#,
						#Session.Ep.UserId#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Cgi.Remote_Addr#">,
						#Now()#
					)
				</cfquery>
				<cfquery name="Upd_General_Paper_Number" datasource="#dsn2#"><!---  Kullanilan Belge Numarasi Update Edilir --->
					UPDATE #dsn3_alias#.GENERAL_PAPERS SET SHIP_FIS_NUMBER = #Paper_Number# WHERE SHIP_FIS_NUMBER IS NOT NULL
				</cfquery>
				<cfquery name="Get_Result_Max" datasource="#dsn2#"><!--- Max Deger Kullanilmak Uzere Alinir --->
					SELECT MAX(SHIP_RESULT_ID) SHIP_RESULT_ID FROM SHIP_RESULT
				</cfquery>
				<cfset Max_Ship_Result_Id = Get_Result_Max.Ship_Result_Id>
			</cfif>
			
			<!--- Bu Asamadan Sonra Satir Bazli Kayitlar Kontrol Edilir --->		
			<cfif Not Len(Old_Planning_Id) and Len(Planning_Id)>
				<cfquery name="Get_Ship_Result_Row" datasource="#dsn2#">
					SELECT * FROM SHIP_RESULT_ROW WHERE SHIP_RESULT_ID = #Max_Ship_Result_Id# AND WRK_ROW_RELATION_ID = '#Get_Related_Order_Row.Wrk_Row_Id#'
				</cfquery>
				<!--- Burada Ayni Satirlar Tekrardan Eklenmesin Diye Daha Once De Planda Var Mi Kontrol Ediyor --->
				<cfif not Get_Ship_Result_Row.RecordCount>
					<!--- Daha Once Kaydedilmis Bir Plan Degilse Yenisinin Satiri Insert Edilir --->
					<cfquery name="Add_Ship_Result_Row" datasource="#dsn2#">
						INSERT INTO
							SHIP_RESULT_ROW
						(
							IS_PROBLEM,
							SHIP_RESULT_ID,
							ORDER_ID,
							ORDER_ROW_ID,
							ORDER_ROW_AMOUNT,
							ORDER_NUMBER,
							DELIVER_ADRESS,
							WRK_ROW_ID,
							WRK_ROW_RELATION_ID
						)
						VALUES
						(
							
							#Is_Problem_#,
							#Max_Ship_Result_Id#,
							#Order_Id#,
							#Order_Row_Id#,
							#Order_Amount#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Order_Number#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Ship_Address#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Result_Wrk_Row_Id#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Get_Related_Order_Row.Wrk_Row_Id#">
						)
					</cfquery>
					
					<!--- Bilesen Kontrolleri Yapiliyor --->
					<cfif Get_Related_Order_Row.Control_Type eq 2 and Len(Get_Related_Order_Row.Spect_Var_Id)>
						<cfquery name="Get_Result_Row_Max" datasource="#dsn2#"><!--- Max Deger Kullanilmak Uzere Alinir --->
							SELECT MAX(SHIP_RESULT_ROW_ID) SHIP_RESULT_ROW_ID FROM SHIP_RESULT_ROW
						</cfquery>
						<cfquery name="Get_Component_Info" datasource="#dsn2#">
							SELECT (SELECT PRODUCT_ID FROM #dsn1_alias#.STOCKS WHERE STOCK_ID = SPECTS_ROW.STOCK_ID) COMP_PRODUCT_ID, * FROM #dsn3_alias#.SPECTS_ROW WHERE SPECT_ID = #Get_Related_Order_Row.Spect_Var_Id# AND IS_PROPERTY IN (0,4) AND STOCK_ID IS NOT NULL ORDER BY LINE_NUMBER
						</cfquery>
						<cfif Get_Component_Info.RecordCount>
							<cfloop query="Get_Component_Info">
								<cfquery name="Add_Ship_Result_Row_Component" datasource="#dsn2#">
									INSERT INTO
										SHIP_RESULT_ROW_COMPONENT
									(
										SHIP_RESULT_ROW_ID,
										SHIP_RESULT_ID,
										COMPONENT_PRODUCT_ID,
										COMPONENT_PRODUCT_NAME,
										COMPONENT_STOCK_ID,
										COMPONENT_SPECT_ID,
										COMPONENT_SPECT_ROW_ID,
										COMPONENT_AMOUNT,
										ORDER_ROW_ID,
										ORDER_ROW_PRODUCT_ID,
										SHIP_RESULT_ROW_AMOUNT,
										LINE_NUMBER,
										WRK_ROW_RELATION_ID
									)
									VALUES
									(
										#Get_Result_Row_Max.Ship_Result_Row_Id#,
										#Max_Ship_Result_Id#,
										<cfif Len(Get_Component_Info.Comp_Product_Id)>#Get_Component_Info.Comp_Product_Id#<cfelse>NULL</cfif>,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#Get_Component_Info.Product_Name#">,
										#Get_Component_Info.Stock_Id#,
										#Get_Component_Info.Spect_Id#,
										#Get_Component_Info.Spect_Row_Id#,
										#Get_Component_Info.Amount_Value#,
										#Get_Related_Order_Row.Order_Row_Id#,
										#Get_Related_Order_Row.Product_Id#,
										0,<!--- Sevkiyat Detayindan Girilecek Olan Miktar Olacak --->
										<cfif Len(Get_Component_Info.Line_Number) and isnumeric(Get_Component_Info.Line_Number)>#Get_Component_Info.Line_Number#<cfelse>0</cfif>,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#Get_Related_Order_Row.Wrk_Row_Id#">
									)
								</cfquery>
							</cfloop>
						</cfif>
					</cfif>
				<cfelse>
					<cfset Repeat_Order_Numbers = Repeat_Order_Numbers & " #Get_Ship_Result_Row.Order_Number# / #Get_Related_Order_Row.Product_Name# \n">
				</cfif>
				<!--- //Bilesen Kontrolleri Yapiliyor --->
			<cfelseif Len(Old_Planning_Id) and Old_Planning_Id eq Planning_Id>
				<!--- Daha Once Varolup, Yine Ayni Ekip Ile Planlanmis Ise Miktar Update Edilir --->
				<cfquery name="Upd_Ship_Result_Row" datasource="#dsn2#">
					UPDATE
						SHIP_RESULT_ROW
					SET
						ORDER_ROW_AMOUNT = #Order_Amount#
					WHERE
						SHIP_RESULT_ID = #Max_Ship_Result_Id# AND
						WRK_ROW_RELATION_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Get_Related_Order_Row.Wrk_Row_Id#">
				</cfquery>
			<cfelseif Len(Old_Planning_Id) and Old_Planning_Id neq Planning_Id>
				<!--- Daha Once Varolup, Ekip Degismis Ise; Ilgili Siparisin Sevkiyat Satiri Silinip Yeni Ekibin Bulundugu Plana Insert Edilir,
					Eger Sevkiyat Planinda Sadece Ilgili Siparis Satiri Bulunuyor Ise, Sevkiyat Satiri Ile Sevkiyat Plani Da Silinir --->
				<cfquery name="Get_Old_Ship_Result_Info" datasource="#dsn2#">
					SELECT
						SR.SHIP_RESULT_ID,
						SRR.ORDER_ROW_AMOUNT
					FROM
						SHIP_RESULT SR,
						SHIP_RESULT_ROW SRR
					WHERE
						SR.SHIP_RESULT_ID = SRR.SHIP_RESULT_ID AND
						SR.OUT_DATE = #Planning_Date# AND 
						SR.EQUIPMENT_PLANNING_ID = #Old_Planning_Id# AND
						SR.IS_TYPE = #Order_Type#
				</cfquery>
				<cfif Get_Old_Ship_Result_Info.RecordCount>
					<cfquery name="Del_Ship_Result_Row_Component" datasource="#dsn2#">
					 	DELETE FROM SHIP_RESULT_ROW_COMPONENT WHERE SHIP_RESULT_ID = #Get_Old_Ship_Result_Info.Ship_Result_Id# AND ORDER_ROW_ID = #Order_Row_Id#
					</cfquery>
					<cfquery name="Del_Ship_Result_Row" datasource="#dsn2#"> --->
						DELETE FROM SHIP_RESULT_ROW WHERE SHIP_RESULT_ID = #Get_Old_Ship_Result_Info.Ship_Result_Id# AND ORDER_ROW_ID = #Order_Row_Id#
					</cfquery>
				</cfif>
				<cfif Get_Old_Ship_Result_Info.RecordCount eq 1>
					<cfquery name="Del_Ship_Result" datasource="#dsn2#">
						DELETE FROM SHIP_RESULT WHERE SHIP_RESULT_ID = #Get_Old_Ship_Result_Info.Ship_Result_Id#
					</cfquery>
				</cfif>
				<cfquery name="Add_Ship_Result_Row" datasource="#dsn2#">
					INSERT INTO
						SHIP_RESULT_ROW
					(
						IS_PROBLEM,
						SHIP_RESULT_ID,
						ORDER_ID,
						ORDER_ROW_ID,
						ORDER_ROW_AMOUNT,
						ORDER_NUMBER,
						DELIVER_ADRESS,
						WRK_ROW_ID,
						WRK_ROW_RELATION_ID
					)
					VALUES
					(
						#Is_Problem_#,
						#Max_Ship_Result_Id#,
						#Order_Id#,
						#Order_Row_Id#,
						#Order_Amount#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Order_Number#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Ship_Address#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Result_Wrk_Row_Id#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Get_Related_Order_Row.Wrk_Row_Id#">
					)
				</cfquery>
				<!--- Bilesen Kontrolleri Yapiliyor --->
				<cfif Get_Related_Order_Row.Control_Type eq 2 and Len(Get_Related_Order_Row.Spect_Var_Id)>
					<cfquery name="Get_Result_Row_Max" datasource="#dsn2#"><!--- Max Deger Kullanilmak Uzere Alinir --->
						SELECT MAX(SHIP_RESULT_ROW_ID) SHIP_RESULT_ROW_ID FROM SHIP_RESULT_ROW
					</cfquery>
					<cfquery name="Get_Component_Info" datasource="#dsn2#">
						SELECT (SELECT PRODUCT_ID FROM #dsn1_alias#.STOCKS WHERE STOCK_ID = SPECTS_ROW.STOCK_ID) COMP_PRODUCT_ID, * FROM #dsn3_alias#.SPECTS_ROW WHERE SPECT_ID = #Get_Related_Order_Row.Spect_Var_Id# AND IS_PROPERTY IN (0,4) AND STOCK_ID IS NOT NULL ORDER BY LINE_NUMBER
					</cfquery>
					<cfif Get_Component_Info.RecordCount>
						<cfloop query="Get_Component_Info">
							<cfquery name="Add_Ship_Result_Row_Component" datasource="#dsn2#">
								INSERT INTO
									SHIP_RESULT_ROW_COMPONENT
								(
									SHIP_RESULT_ROW_ID,
									SHIP_RESULT_ID,
									COMPONENT_PRODUCT_ID,
									COMPONENT_PRODUCT_NAME,
									COMPONENT_STOCK_ID,
									COMPONENT_SPECT_ID,
									COMPONENT_SPECT_ROW_ID,
									COMPONENT_AMOUNT,
									ORDER_ROW_ID,
									ORDER_ROW_PRODUCT_ID,
									SHIP_RESULT_ROW_AMOUNT,
									LINE_NUMBER,
									WRK_ROW_RELATION_ID
								)
								VALUES
								(
									#Get_Result_Row_Max.Ship_Result_Row_Id#,
									#Max_Ship_Result_Id#,
									<cfif Len(Get_Component_Info.Comp_Product_Id)>#Get_Component_Info.Comp_Product_Id#<cfelse>NULL</cfif>,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#Get_Component_Info.Product_Name#">,
									#Get_Component_Info.Stock_Id#,
									#Get_Component_Info.Spect_Id#,
									#Get_Component_Info.Spect_Row_Id#,
									#Get_Component_Info.Amount_Value#,
									#Get_Related_Order_Row.Order_Row_Id#,
									#Get_Related_Order_Row.Product_Id#,
									0,<!--- Sevkiyat Detayindan Girilecek Olan Miktar Olacak --->
									<cfif Len(Get_Component_Info.Line_Number) and isnumeric(Get_Component_Info.Line_Number)>#Get_Component_Info.Line_Number#<cfelse>0</cfif>,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#Get_Related_Order_Row.Wrk_Row_Id#">
								)
							</cfquery>
						</cfloop>
					</cfif>
				</cfif>
				<!--- //Bilesen Kontrolleri Yapiliyor --->
			</cfif>
		<cfelseif Not Len(Planning_Id)>
			<!--- Yoksa Olanları Siliyoruz --->
			<cfquery name="Get_Old_Ship_Result_Info" datasource="#dsn2#">
				SELECT
					SR.SHIP_RESULT_ID
				FROM
					SHIP_RESULT SR,
					SHIP_RESULT_ROW SRR
				WHERE
					SR.SHIP_RESULT_ID = SRR.SHIP_RESULT_ID AND
					SR.OUT_DATE = #Planning_Date# AND 
					SR.EQUIPMENT_PLANNING_ID = #Old_Planning_Id# AND
					SR.IS_TYPE = #Order_Type#
			</cfquery>
			<cfif Get_Old_Ship_Result_Info.RecordCount>
				<cfquery name="Del_Ship_Result_Row_Component" datasource="#dsn2#">
					DELETE FROM SHIP_RESULT_ROW_COMPONENT WHERE SHIP_RESULT_ID = #Get_Old_Ship_Result_Info.Ship_Result_Id# AND WRK_ROW_RELATION_ID = '#Get_Related_Order_Row.Wrk_Row_Id#'
				</cfquery>
				<cfquery name="Del_Ship_Result_Row" datasource="#dsn2#">
					DELETE FROM SHIP_RESULT_ROW WHERE SHIP_RESULT_ID = #Get_Old_Ship_Result_Info.Ship_Result_Id# AND WRK_ROW_RELATION_ID = '#Get_Related_Order_Row.Wrk_Row_Id#'
				</cfquery>
			</cfif>
			<cfif Get_Old_Ship_Result_Info.RecordCount eq 1>
				<cfquery name="Del_Ship_Result" datasource="#dsn2#">
					DELETE FROM SHIP_RESULT WHERE SHIP_RESULT_ID = #Get_Old_Ship_Result_Info.Ship_Result_Id#
				</cfquery>
			</cfif>
		</cfif>
	</cfloop>
</cftransaction>
</cflock>
</cfoutput>
<cfif len(Planning_Id)>
<cf_workcube_process 
	is_upd='1' 
	old_process_line='0'
	process_stage='#attributes.process_stage#'
	record_member='#session.ep.userid#' 
	record_date='#now()#'
	action_table='SHIP_RESULT'
	action_column='SHIP_RESULT_ID'
    
	action_id='#Max_Ship_Result_Id#'
    
	action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_upd_multi_packetship&main_ship_fis_no=#paper_full#'
	warning_description = 'Sevkiyat No : #Paper_Full#'>
</cfif>
<cfset url_location_ = "&is_submitted=1&planning_date=#DateFormat(Planning_Date,dateformat_style)#">
<cfif isdefined("attributes.date1_") and Len(attributes.date1_)><cfset url_location_ = "#url_location_#&date1=#DateFormat(attributes.date1_,dateformat_style)#"></cfif>
<cfif isdefined("attributes.date2_") and Len(attributes.date2_)><cfset url_location_ = "#url_location_#&date2_=#DateFormat(attributes.date2_,dateformat_style)#"></cfif>
<cfif isdefined("attributes.cat_") and Len(attributes.cat_)><cfset url_location_ = "#url_location_#&cat=#attributes.cat_#"></cfif>
<cfif isdefined("attributes.product_code_") and Len(attributes.product_code_) and isdefined("attributes.product_cat_") and Len(attributes.product_cat_)>
	<cfset url_location_ = "#url_location_#&product_code=#attributes.product_code_#&product_cat_id=#attributes.product_cat_id_#&product_cat=#attributes.product_cat_#">
</cfif>
<cfif isdefined("attributes.consumer_id_") and Len(attributes.consumer_id_)><cfset url_location_ = "#url_location_#&consumer_id=#attributes.consumer_id_#&company=#UrlEncodedFormat(attributes.company_)#"></cfif>
<cfif isdefined("attributes.company_id_") and Len(attributes.company_id_)><cfset url_location_ = "#url_location_#&company_id=#attributes.company_id_#&company=#UrlEncodedFormat(attributes.company_)#"></cfif>
<cfif isdefined("attributes.ref_no_") and Len(attributes.ref_no_)><cfset url_location_ = "#url_location_#&ref_no=#attributes.ref_no_#"></cfif>
<cfif isdefined("attributes.keyword_") and Len(attributes.keyword_)><cfset url_location_ = "#url_location_#&keyword=#attributes.keyword_#"></cfif>
<cfif isdefined("attributes.records_problems")><cfset url_location_ = "#url_location_#&records_problems=#attributes.records_problems#"></cfif>
<script type="text/javascript">
	<cfif Len(Repeat_Order_Numbers)>
		alert("Aşağıda Belirtilen Siparişler Daha Önce Planlanmıştır, Lütfen Kontrol Ediniz ! \n<cfoutput>#Repeat_Order_Numbers#</cfoutput>");
	</cfif>
	window.open('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,".")#.list_multi_packetship&planning_date=#DateFormat(Planning_Date,dateformat_style)#&form_submitted=1</cfoutput>','page');
	window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_command#url_location_#</cfoutput>";
</script>
