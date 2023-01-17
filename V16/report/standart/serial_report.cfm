<cfparam name="attributes.module_id_control" default="14">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.start_date2" default="">
<cfparam name="attributes.finish_date2" default="">
<cfparam name="attributes.start_date"  default="#date_add('d',-7,createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#'))#">
<cfparam name="attributes.finish_date" default="#createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#')#">
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date) and isdefined("attributes.is_form_submit")>
	<cf_date tarih = "attributes.start_date">
</cfif>
<cfif isdefined("attributes.start_date2") and isdate(attributes.start_date2)>
	<cf_date tarih = "attributes.start_date2">
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date) and isdefined("attributes.is_form_submit")>
	<cf_date tarih = "attributes.finish_date">
</cfif>
<cfif isdefined("attributes.finish_date2") and isdate(attributes.finish_date2)>
	<cf_date tarih = "attributes.finish_date2">
</cfif>
<cfparam name="attributes.serial_no" default="">
<cfparam name="attributes.rma_no" default="">
<cfparam name="attributes.lot_no" default="">
<cfparam name="attributes.process_no" default="">
<cfparam name="attributes.process_cat_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.brand_id" default="">
<cfparam name="attributes.is_sale" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.subscription_id" default="">
<cfparam name="attributes.subscription_no" default="">
<cfparam name="attributes.order_type" default="0">
<cfsavecontent  variable="title"><cf_get_lang no ='143.Seri No Raporu'></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cf_box title="#title#">
<cfform name="search_" action="#request.self#?fuseaction=report.serial_report" method="post">
	<cf_box_elements vertical="1">
        <input type="hidden" name="is_form_submit" id="is_form_submit" value="1">
		<cfoutput>
			<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
				<div class="form-group">
					<label><cf_get_lang_main no='245.Ürün'></label>
					<div class="input-group">
						<input type="hidden" name="product_id" id="product_id" value="<cfif isdefined("attributes.product_id")>#attributes.product_id#</cfif>">
						<input type="hidden" name="stock_id" id="stock_id" value="<cfif isdefined("attributes.stock_id")>#attributes.stock_id#</cfif>">
						<input type="text" name="product" id="product" style="width:100px;"  onfocus="AutoComplete_Create('product','PRODUCT_NAME','PRODUCT_NAME,STOCK_ID','get_product_autocomplete','0','PRODUCT_ID,STOCK_ID','product_id,stock_id','','3','200');" autocomplete="off" value="<cfif isdefined("attributes.product")>#attributes.product#</cfif>" >
						<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('#request.self#?fuseaction=objects.popup_product_names&field_id=search_.stock_id&product_id=search_.product_id&field_name=search_.product','list');"></span>
					</div>
				</div>
				<div class="form-group">
					<label><cf_get_lang_main no='74.Kategori'></label>
					<div class="input-group"><cf_wrk_product_cat form_name='search_' product_cat_id='product_catid' hierarchy_code='product_hierarchy' product_cat_name='product_cat'>
						<input type="hidden" name="product_hierarchy" id="product_hierarchy" value="<cfif isdefined("attributes.product_hierarchy")>#attributes.product_hierarchy#</cfif>">
						<input type="hidden" name="product_catid" id="product_catid" value="<cfif isdefined("attributes.product_catid")>#attributes.product_catid#</cfif>">
						<input type="text" name="product_cat" id="product_cat" style="width:100px;" value="<cfif isdefined("attributes.product_cat")>#attributes.product_cat#</cfif>" onkeyup="get_product_cat();" onFocus="AutoComplete_Create('product_cat','HIERARCHY,PRODUCT_CAT','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID','productcat_id','form','3','200');">
						<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=search_.product_catid&field_name=search_.product_cat&field_hierarchy=search_.product_hierarchy');"></span>
					</div>	
				</div>
				<div class="form-group">
					<label><cf_get_lang_main no ='246.Üye'></label>
					<div class="input-group">
						<input type="Hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id")>#attributes.company_id#</cfif>">
						<input type="text" name="company" id="company" style="width:100px;" value="<cfif isdefined("attributes.company")>#attributes.company#</cfif>" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','company_id','','3','150');">
						<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=search_.company_id&field_comp_name=search_.company&select_list=2','list');"></span>
					</div>
				</div>
				<div class="form-group">
					<label><cf_get_lang_main no ='1435.Marka'></label>
					<cf_wrkProductBrand
							width="100"
							compenent_name="getProductBrand"               
							boxwidth="240"
							boxheight="150"
							brand_ID="#attributes.brand_id#">
					
				</div>
			</div>
			<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
				<div class="form-group">
					<label><cf_get_lang_main no ='225.Seri No'></label>
					<cfinput type="text" value="#attributes.serial_no#" name="serial_no" style="width:100px;">
				</div>
				<div class="form-group">
					<label><cf_get_lang no ='1942.Lot No'></label>
					<cfinput type="text" value="#attributes.lot_no#" name="lot_no" style="width:100px;">
				</div>
				<div class="form-group">
					<label><cf_get_lang_main no ='1360.İşlem No'></label>
					<cfinput type="text" value="#attributes.process_no#" name="process_no" style="width:100px;">
				</div>
				<div class="form-group">
					<label><cf_get_lang_main no='388.İşlem Tipi'></label>
					
						<cfset process_cat_id_ship_list = "70,71,72,73,74,75,76,77,78,79,81,811,84">
						<cfset process_cat_id_service_list = "85,86,140,141">
						<cfset process_cat_id_plug_list = "110,11,112,113,114,115,119,1190,1131,116,118,1182">
						<cfset process_cat_id_product_list = "171">
						<cfset process_cat_id_system_list = "1193">
						<select name="process_cat_id" id="process_cat_id" style="width:195px;">
							<option value="" selected><cf_get_lang_main no='388.İşlem Tipi'></option>
							<optgroup label="<cf_get_lang no='308.İrsaliyeler'>">
								<cfloop list="#process_cat_id_ship_list#" index="aa">
									<option value="#aa#" <cfif attributes.process_cat_id eq aa>selected</cfif>>#get_process_name(aa)#</option>
								</cfloop>
							</optgroup>
							<optgroup label="<cf_get_lang no='326.Servis ve RMA'>">
								<cfloop list="#process_cat_id_service_list#" index="bb">
									<option value="#bb#" <cfif attributes.process_cat_id eq bb>selected</cfif>>#get_process_name(bb)#</option>
								</cfloop>
							</optgroup>
							<optgroup label="<cf_get_lang no='327.Fişler'>">
								<cfloop list="#process_cat_id_plug_list#" index="cc">
									<option value="#cc#" <cfif attributes.process_cat_id eq cc>selected</cfif>>#get_process_name(cc)#</option>
								</cfloop>
							</optgroup>
							<optgroup label="<cf_get_lang_main no='44.Üretim'>">
								<cfloop list="#process_cat_id_product_list#" index="dd">
									<option value="#dd#" <cfif attributes.process_cat_id eq dd>selected</cfif>>#get_process_name(dd)#</option>
								</cfloop>
							</optgroup>
							<optgroup label="Sistem">
								<cfloop list="#process_cat_id_system_list#" index="ee">
									<option value="#ee#" <cfif attributes.process_cat_id eq ee>selected</cfif>>#get_process_name(ee)#</option>
								</cfloop>
							</optgroup>
						</select>
					
				</div>
			</div>
			<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
				<div class="form-group">	
					<label><cf_get_lang_main no ='2234.Lokasyon'>
					<div class="input-group">
						<input type="hidden" name="department_id" id="department_id" value="<cfif isdefined("attributes.department_id")>#attributes.department_id#</cfif>">
						<input type="hidden" name="location_id" id="location_id" value="<cfif isdefined("attributes.location_id")>#attributes.location_id#</cfif>">					
						<input type="text" name="department" id="department" value="<cfif isdefined("attributes.department")>#attributes.department#</cfif>" style="width:100px;" onfocus="AutoComplete_Create('department','DEPARTMENT_HEAD','DEPARTMENT_HEAD','get_department1','','DEPARTMENT_ID','department_id','add_asset_it','3','200','add_department()');">
						<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_stores_locations&form_name=search_&field_name=department&field_location_id=location_id&field_id=department_id','medium');">
						</span>
					</div>	
				</div>
				
				<div class="form-group">
					<label><cf_get_lang_main no='1736.Tedarikçi'></label>
					<div class="input-group">
						<input type="Hidden" name="tedarikci_company_id" id="tedarikci_company_id" value="<cfif isdefined("attributes.tedarikci_company_id")>#attributes.tedarikci_company_id#</cfif>">
						<input type="text" name="tedarikci_company" id="tedarikci_company" style="width:100px;" value="<cfif isdefined("attributes.tedarikci_company")>#attributes.tedarikci_company#</cfif>" onfocus="AutoComplete_Create('tedarikci_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','company_id','','3','150');">
						<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=search_.tedarikci_company_id&field_comp_name=search_.tedarikci_company&select_list=2','list');"></span>
					
					</div>	
				</div>
				<div class="form-group">
					<label><cf_get_lang no ='144.RMA No'></label>
					<cfinput type="text" value="#attributes.rma_no#" name="rma_no" style="width:100px;">	
				</div>
				<cfif session.ep.our_company_info.subscription_contract eq 1>
					<div class="form-group">
						<label style="width:75px;"><cf_get_lang_main no='1705.Sistem'></label>		
						<div class="input-group">
							<input type="hidden" name="subscription_id" id="subscription_id" value="<cfif isdefined("attributes.subscription_id")><cfoutput>#attributes.subscription_id#</cfoutput></cfif>">
							<input type="text" name="subscription_no" id="subscription_no" value="<cfif isdefined("attributes.subscription_no")><cfoutput>#attributes.subscription_no#</cfoutput></cfif>" style="width:100px;" onfocus="AutoComplete_Create('subscription_no','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO','get_subscription','2','SUBSCRIPTION_ID','subscription_id','','3','100');" autocomplete="off">
							<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_subscription&field_id=search_.subscription_id&field_no=search_.subscription_no'</cfoutput>,'list','popup_list_subscription');"></span>
						</div>
					</div>
				</cfif>
				<div class="form-group">
					<label>
						<select name="is_sale" id="is_sale" style="width:150px;">
							<option value="0" <cfif isdefined("attributes.is_sale") and attributes.is_sale eq 0>selected</cfif>><cf_get_lang dictionary_id='65026.Çıkışı Yapılmamış Seriler'></option>
							<option value="1" <cfif isdefined("attributes.is_sale") and attributes.is_sale eq 1>selected</cfif>><cf_get_lang dictionary_id='65027.Çıkışı Yapılmış Seriler'></option>
							<option value="2" <cfif isdefined("attributes.is_sale") and attributes.is_sale eq 2>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
						</select>
						
					</label>
				</div>
			</div>
			<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
				<div class="form-group">
					<label><cf_get_lang_main no='330.Tarih'></label>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12 padding-right-5">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang_main no='326.Başlangıç Tarihi Girmelisiniz'>!</cfsavecontent>
							<cfinput type="text" name="start_date" maxlength="10" value="#dateformat(attributes.start_date,dateformat_style)#" style="width:75px;" validate="#validate_style#" message="#message#">
							<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
						</div>
					</div>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang_main no='327.Bitiş Tarihi Girmelisiniz'>!</cfsavecontent>
							<cfinput type="text" name="finish_date" maxlength="10" value="#dateformat(attributes.finish_date,dateformat_style)#" style="width:75px;" validate="#validate_style#" message="#message#">
							<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label><cf_get_lang no="701.belge tarihi"></label>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12 padding-right-5">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang_main no='326.Başlangıç Tarihi Girmelisiniz'>!</cfsavecontent>
							<cfinput type="text" name="start_date2" maxlength="10" value="#dateformat(attributes.start_date2,dateformat_style)#" style="width:75px;" validate="#validate_style#" message="#message#">
							<span class="input-group-addon"><cf_wrk_date_image date_field="start_date2"></span>
						</div>
					</div>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang_main no='327.Bitiş Tarihi Girmelisiniz'>!</cfsavecontent>
							<cfinput type="text" name="finish_date2" maxlength="10" value="#dateformat(attributes.finish_date2,dateformat_style)#" style="width:75px;" validate="#validate_style#" message="#message#">
							<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date2"></span>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label><cf_get_lang_main no='71.Kayıt'></label>
					<div class="input-group">
						<input type="hidden" name="employee_id" id="employee_id" style="width:100px;" value="<cfif isDefined('attributes.employee_id') and isDefined('attributes.employee')>#attributes.employee_id#</cfif>" >
						<input type="text" name="employee" id="employee" style="width:100px;" value="<cfif isDefined('attributes.employee')>#attributes.employee#</cfif>" onfocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE,MEMBER_NAME','employee_id,employee','','3','135');">
						<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=search_.employee_id&field_name=search_.employee&select_list=1&is_form_submitted=1','list');"></span>
					</div>
				</div>
				<div class="form-group">
					<label><cf_get_lang dictionary_id='65023.Sıralama Tipi'></label>
					<select name="order_type" id="order_type" style="width:100px;">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<option value="1" <cfif attributes.order_type eq 1>selected</cfif>><cf_get_lang dictionary_id='65024.Seri No Artan'></option>
							<option value="2" <cfif attributes.order_type eq 2>selected</cfif>><cf_get_lang dictionary_id='65025.Seri No Azaltan'></option>
						</select>
				</div>
				<div class="form-group">
					<label>
						<input type="checkbox" name="is_last_action" id="is_last_action" value="1" <cfif isdefined("attributes.is_last_action")>checked</cfif>> <cf_get_lang no ='1941.Son İşlemler'>
					</label>
				</div>
			</div>
        </cfoutput>
    </cf_box_elements>
    <cf_box_footer>
		<label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'></label>
        <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
         <cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" message="#message#" maxlength="3" style="width:25px;">
        <cfelse>
            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,250" message="#message#" maxlength="3" style="width:25px;">
        </cfif>
		<cfsavecontent variable="message"><cf_get_lang_main no ='499.Çalıştır'></cfsavecontent>
		<!--- <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1' tag_module="serial_basket" is_ajax="1"> --->
        <cf_wrk_report_search_button button_type="1" is_excel="1" search_function="control()">
    </cf_box_footer>
</cfform>
</cf_box>
</div>
<cfif isdefined("attributes.is_form_submit")>
	<cfquery name="get_search_results_" datasource="#dsn3#">
		SELECT
			SG.GUARANTY_ID,
			CASE 
				WHEN SG.PROCESS_CAT IN (1719) THEN (SELECT RECORD_DATE FROM PRODUCTION_ORDER_RESULTS WHERE PR_ORDER_ID = SG.PROCESS_ID) 
				ELSE SG.RECORD_DATE
			END AS RECORD_DATE,
			SG.LOT_NO,
			SG.RMA_NO,
			SG.STOCK_ID,
			CASE 
				WHEN SG.PROCESS_CAT IN (1719) THEN (SELECT PR_ORDER_ID FROM PRODUCTION_ORDER_RESULTS WHERE PR_ORDER_ID = SG.PROCESS_ID) 
				ELSE SG.PROCESS_ID
			END AS PROCESS_ID,
			SG.SERIAL_NO,
			SG.IS_SALE,
			CASE WHEN SG.PROCESS_CAT IN (1719) THEN 171
			ELSE SG.PROCESS_CAT
			END PROCESS_CAT,
			CASE 
				WHEN SG.PROCESS_CAT IN (1719) THEN (SELECT RESULT_NO FROM PRODUCTION_ORDER_RESULTS WHERE PR_ORDER_ID = SG.PROCESS_ID) 
				ELSE SG.PROCESS_NO
			END AS PROCESS_NO,
			SG.SALE_CONSUMER_ID,
			SG.SALE_COMPANY_ID,
			SG.PURCHASE_GUARANTY_CATID,
			SG.SALE_GUARANTY_CATID,
			SG.SALE_START_DATE,
			SG.SALE_FINISH_DATE,
			SG.PURCHASE_COMPANY_ID,
			SG.IS_PURCHASE,
			SG.IN_OUT,
			SG.IS_RETURN,
			SG.IS_RMA,
			SG.IS_SERVICE,
			SG.IS_TRASH,
			SG.PURCHASE_CONSUMER_ID,
			SG.MAIN_STOCK_ID,
			SG.IS_SERI_SONU,
			SG.UNIT_ROW_QUANTITY,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME,
			D.DEPARTMENT_HEAD,
			S.BRAND_ID,
			S.COMPANY_ID,
			S.STOCK_CODE,
			S.PRODUCT_NAME,
			S.PROPERTY,
			S.BARCOD,
			S.PRODUCT_CATID,
			S.PRODUCT_ID,
			SL.COMMENT AS LOCATION,
			S.PRODUCT_CODE_2,
			CASE 
				WHEN SG.PROCESS_CAT IN (70,71,72,78,85,141,73,74,75,76,77,81,84,86,140,81,811) THEN (SELECT ISNULL((SELECT TOP 1 SR.ROW_PROJECT_ID FROM #DSN2_ALIAS#.SHIP_ROW SR WHERE SR.SHIP_ID = SG.PROCESS_ID),(SELECT S.PROJECT_ID FROM #DSN2_ALIAS#.SHIP S WHERE S.SHIP_ID = SG.PROCESS_ID)) AS PROJECT_ID)
				WHEN SG.PROCESS_CAT IN (110,111,112,113,114,115,119,1131) THEN (SELECT ISNULL((SELECT TOP 1 SFR.ROW_PROJECT_ID FROM #DSN2_ALIAS#.STOCK_FIS_ROW  SFR WHERE SFR.FIS_ID = SG.PROCESS_ID),(SELECT SF.PROJECT_ID FROM #DSN2_ALIAS#.STOCK_FIS SF WHERE SF.FIS_ID = SG.PROCESS_ID)) AS PROJECT_ID)
				WHEN SG.PROCESS_CAT IN (1193) THEN (SELECT PROJECT_ID FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = SG.PROCESS_ID) --1193 sistem
				WHEN SG.PROCESS_CAT IN (1194) THEN (SELECT PROJECT_ID FROM PRODUCTION_ORDERS WHERE PRODUCTION_ORDERS.P_ORDER_ID = SG.PROCESS_ID)--ÜRETİM EMRİ
				WHEN SG.PROCESS_CAT IN (171) THEN (SELECT	
														PRODUCTION_ORDERS.PROJECT_ID
													FROM
														PRODUCTION_ORDERS,
														PRODUCTION_ORDER_RESULTS
													WHERE
														PRODUCTION_ORDERS.P_ORDER_ID = PRODUCTION_ORDER_RESULTS.P_ORDER_ID AND
														PRODUCTION_ORDER_RESULTS.PR_ORDER_ID = SG.PROCESS_ID) --ÜRETİM SONUCU
				ELSE ''
			END AS PROJECT_ID,
			CASE 
				WHEN SG.PROCESS_CAT IN (1719) THEN (SELECT RECORD_EMP FROM PRODUCTION_ORDER_RESULTS WHERE PR_ORDER_ID = SG.PROCESS_ID) 
				ELSE SG.RECORD_EMP
			END AS RECORD_EMP,
			SG.MAIN_PROCESS_TYPE,
			SG.MAIN_PROCESS_ID
			,(SELECT COUNT(GUARANTY_ID) FROM SERVICE_GUARANTY_NEW WHERE SERIAL_NO = SG.SERIAL_NO AND STOCK_ID = SG.STOCK_ID AND IN_OUT = 1) AS COUNT1
			,(SELECT COUNT(GUARANTY_ID) FROM SERVICE_GUARANTY_NEW WHERE SERIAL_NO = SG.SERIAL_NO AND STOCK_ID = SG.STOCK_ID AND IN_OUT = 0) AS COUNT2
		FROM 
			SERVICE_GUARANTY_NEW SG,
			STOCKS S,
			#DSN_ALIAS#.EMPLOYEES E,
			#DSN_ALIAS#.DEPARTMENT D,
			#DSN_ALIAS#.STOCKS_LOCATION SL
		WHERE 
			SG.RECORD_EMP = E.EMPLOYEE_ID AND 
			SG.LOCATION_ID = SL.LOCATION_ID AND 
			SG.DEPARTMENT_ID = SL.DEPARTMENT_ID AND
			SG.DEPARTMENT_ID = D.DEPARTMENT_ID AND 
			SG.STOCK_ID = S.STOCK_ID
			<cfif len(attributes.employee_id) and len(attributes.employee)>
				AND SG.RECORD_EMP = #attributes.employee_id#
			</cfif>
			<cfif len(attributes.process_no)>
				AND SG.PROCESS_NO = '#attributes.process_no#'
			</cfif>
			<cfif len(attributes.serial_no)>
				AND SG.SERIAL_NO = '#attributes.serial_no#'
			</cfif>
			<cfif len(attributes.lot_no)>
				AND SG.LOT_NO = '#attributes.lot_no#'
			</cfif>
			<cfif len(attributes.rma_no)>
				AND SG.RMA_NO = '#attributes.rma_no#'
			</cfif>
			<cfif len(attributes.start_date) and len(attributes.finish_date)>
				AND 
				(
				SG.RECORD_DATE BETWEEN #attributes.start_date# AND #DATEADD("d",1,attributes.finish_date)#
				)
			<cfelseif len(attributes.start_date) and not len(attributes.finish_date)>
				AND SG.RECORD_DATE >= #attributes.start_date#
			<cfelseif len(attributes.finish_date)>
				AND SG.RECORD_DATE <= #attributes.finish_date#						
			</cfif>
			<cfif len(attributes.process_cat_id)>
				AND SG.PROCESS_CAT = #attributes.process_cat_id#
			</cfif>
			<cfif isdefined("attributes.product_id") and len(attributes.product_id) and len(attributes.product)>
				AND SG.STOCK_ID = '#attributes.stock_id#'
			</cfif>
			<cfif isdefined("attributes.department_id") and len(attributes.department_id) and len(attributes.department)>
				AND SG.DEPARTMENT_ID = #attributes.department_id#
				AND SG.LOCATION_ID = #attributes.location_id#
			</cfif>
			<cfif isdefined("attributes.product_catid") and len(attributes.product_catid) and len(attributes.product_cat)>
				AND
					(
					S.PRODUCT_CATID = #attributes.product_catid#
					OR
					S.PRODUCT_CODE LIKE '#attributes.product_hierarchy#.%'
					)
			</cfif>
			<cfif isdefined("attributes.company_id") and len(attributes.company_id) and len(attributes.company)>
				AND (SG.PURCHASE_COMPANY_ID = #attributes.company_id# OR SG.SALE_COMPANY_ID = #attributes.company_id#)
			</cfif>
			<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)>
				AND SG.SUBSCRIPTION_ID = #attributes.subscription_id#
			</cfif>
			<cfif isdefined("attributes.tedarikci_company_id") and len(attributes.tedarikci_company_id) and len(attributes.tedarikci_company)>
				AND S.COMPANY_ID = #attributes.tedarikci_company_id#
			</cfif>
			<cfif len(attributes.brand_id)>
				AND S.BRAND_ID = #attributes.brand_id#
			</cfif>
			<cfif isdefined("attributes.is_sale") and attributes.is_sale eq 1><!---Çıkışı Yapılmış --->
					AND SG.IN_OUT = 0
			</cfif>
			<cfif isdefined("attributes.is_last_action")><!--- son islem getir --->
				AND SG.GUARANTY_ID IN (
					SELECT
						MAX(SG2.GUARANTY_ID) AS G_ID 
					FROM
						SERVICE_GUARANTY_NEW SG2,
						STOCKS S2,
						#DSN_ALIAS#.EMPLOYEES E2,
						#DSN_ALIAS#.DEPARTMENT D2
					WHERE
						SG2.RECORD_EMP = E2.EMPLOYEE_ID AND 
						SG2.DEPARTMENT_ID = D2.DEPARTMENT_ID AND 
						SG2.STOCK_ID = S2.STOCK_ID
						<cfif len(attributes.employee_id) and len(attributes.employee)>
							AND SG2.RECORD_EMP = #attributes.employee_id#
						</cfif>
						<cfif len(attributes.process_no)>
							AND SG2.PROCESS_NO = '#attributes.process_no#'
						</cfif>
						<cfif len(attributes.serial_no)>
							AND SG2.SERIAL_NO = '#attributes.serial_no#'
						</cfif>
						<cfif len(attributes.lot_no)>
							AND SG2.LOT_NO = '#attributes.lot_no#'
						</cfif>
						<cfif len(attributes.rma_no)>
							AND SG2.RMA_NO = '#attributes.rma_no#'
						</cfif>
						<cfif len(attributes.start_date) and len(attributes.finish_date)>
							AND 
							(
							SG2.RECORD_DATE BETWEEN #attributes.start_date# AND #DATEADD("d",1,attributes.finish_date)#
							)
						<cfelseif len(attributes.start_date) and not len(attributes.finish_date)>
							AND SG2.RECORD_DATE >= #attributes.start_date#
						<cfelseif len(attributes.finish_date)>
							AND SG2.RECORD_DATE <= #attributes.finish_date#						
						</cfif>
						<cfif isdefined("attributes.product_id") and len(attributes.product_id) and len(attributes.product)>
							AND SG2.STOCK_ID = '#attributes.stock_id#'
						</cfif>
						<cfif isdefined("attributes.product_catid") and len(attributes.product_catid) and len(attributes.product_cat)>
							AND
								(
								S2.PRODUCT_CATID = #attributes.product_catid#
								OR
								S2.PRODUCT_CODE LIKE '#attributes.product_hierarchy#.%'
								)
						</cfif>
						<cfif isdefined("attributes.company_id") and len(attributes.company_id) and len(attributes.company)>
							AND (SG2.PURCHASE_COMPANY_ID = #attributes.company_id# OR SG2.SALE_COMPANY_ID = #attributes.company_id#)
						</cfif>
						<cfif isdefined("attributes.tedarikci_company_id") and len(attributes.tedarikci_company_id) and len(attributes.tedarikci_company)>
							AND S2.COMPANY_ID = #attributes.tedarikci_company_id#
						</cfif>
						<cfif isdefined("attributes.department_id") and len(attributes.department_id) and len(attributes.department)>
							AND SG2.DEPARTMENT_ID = #attributes.department_id#
							AND SG2.LOCATION_ID = #attributes.location_id#
						</cfif>
					GROUP BY
						SG2.STOCK_ID,
						SG2.SERIAL_NO
					)
			</cfif><!--- son islem getir --->
			<cfif len(attributes.start_date2) or len(attributes.finish_date2)>
			AND 
				(
						SG.PROCESS_ID IN (
										SELECT
											SHIP_ID FROM #DSN2_ALIAS#.SHIP S WHERE S.SHIP_TYPE = SG.PROCESS_CAT  AND SG.PERIOD_ID = #session.ep.period_id#
											<cfif len(attributes.start_date2)>
												AND SHIP_DATE >= #attributes.start_date2#
											</cfif>
											<cfif len(attributes.finish_date2)>
												AND SHIP_DATE <= #attributes.finish_date2#
											</cfif>
										)
						OR
						SG.PROCESS_ID IN (
										SELECT
											FIS_ID FROM #DSN2_ALIAS#.STOCK_FIS STOCK_FIS WHERE STOCK_FIS.FIS_TYPE = SG.PROCESS_CAT  AND SG.PERIOD_ID = #session.ep.period_id#
											<cfif len(attributes.start_date2)>
												AND FIS_DATE >= #attributes.start_date2#
											</cfif>
											<cfif len(attributes.finish_date2)>
												AND FIS_DATE <= #attributes.finish_date2#
											</cfif>
										)
						OR
						SG.PROCESS_ID IN (
							SELECT PR_ORDER_ID FROM PRODUCTION_ORDER_RESULTS WHERE SG.PROCESS_ID = PRODUCTION_ORDER_RESULTS.PR_ORDER_ID AND SG.PROCESS_CAT = 171 AND SG.PERIOD_ID =#session.ep.period_id#
									<cfif len(attributes.start_date2)>
										AND FINISH_DATE >= #attributes.start_date2#
									</cfif>
									<cfif len(attributes.finish_date2)>
										AND FINISH_DATE <= #attributes.finish_date2#
									</cfif>
								)
						OR
						SG.PROCESS_ID IN (
							SELECT PROCESS_CAT FROM #DSN2_ALIAS#.STOCK_EXCHANGE STOCK_EXCHANGE WHERE SG.PROCESS_CAT = STOCK_EXCHANGE.PROCESS_TYPE AND SG.PERIOD_ID = #session.ep.period_id#
									<cfif len(attributes.start_date2)>
										AND RECORD_DATE >= #attributes.start_date2#
									</cfif>
									<cfif len(attributes.finish_date2)>
										AND RECORD_DATE <= #attributes.finish_date2#
									</cfif>
								)
				)
			</cfif> <!--- Belge tarihi filtresi --->
		ORDER BY 
			<cfif attributes.order_type eq 1>
				SG.SERIAL_NO ASC
			<cfelseif attributes.order_type eq 2>
				SG.SERIAL_NO DESC
			<cfelse>
				SG.GUARANTY_ID DESC
			</cfif>
	</cfquery>
	<cfparam name="attributes.totalrecords" default="#get_search_results_.recordcount#">
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">
    <cfset get_search_results_.recordcount = 0>
</cfif>
<cfif isdefined("attributes.is_last_action")>
	<cfif get_search_results_.recordcount>
		<cfquery name="get_" dbtype="query">
			SELECT				
				MAX(GUARANTY_ID) AS UPPER_GUARANTY
			FROM
				get_search_results_
			GROUP BY
				STOCK_ID,
				SERIAL_NO
		</cfquery>
		<cfset guaranty_id_list = valuelist(get_.UPPER_GUARANTY)>
		<cfquery name="get_search_results_" dbtype="query">
			SELECT				
				*
			FROM
				get_search_results_
			WHERE
				GUARANTY_ID IN (#guaranty_id_list#)
			ORDER BY
				RECORD_DATE DESC
		</cfquery>
	</cfif>
</cfif>
<cfif isdefined("attributes.is_sale") and attributes.is_sale eq 0>
    <cfquery name="get_" dbtype="query">
        SELECT				
            SERIAL_NO,
            STOCK_ID
        FROM
            get_search_results_
        WHERE
            COUNT1 > COUNT2
        GROUP BY
            STOCK_ID,
            SERIAL_NO
    </cfquery>
    <cfset serial_list = valuelist(get_.SERIAL_NO)>
    <cfset guaranty_id_list1 = "">
    <cfloop  list="#serial_list#" index="kk">
    <cfquery name="get_deger" datasource="#DSN3#">
        SELECT MAX(GUARANTY_ID) as GUARANTY_ID FROM SERVICE_GUARANTY_NEW WHERE IN_OUT = 1 AND SERIAL_NO = '#kk#'
    </cfquery> 
        <cfif get_deger.recordcount>
        <cfset guaranty_id_list1 = listappend(guaranty_id_list1,get_deger.GUARANTY_ID)>
        </cfif>
    </cfloop>
    <cfif len(guaranty_id_list1)>
         <cfquery name="get_search_results_" dbtype="query">
            SELECT				
                *
            FROM
                get_search_results_
            WHERE
                GUARANTY_ID IN (#guaranty_id_list1#)
            ORDER BY
                RECORD_DATE DESC
        </cfquery>
        <cfset attributes.totalrecords = get_search_results_.recordcount>
    <cfelse>
    	<cfquery name="get_search_results_" dbtype="query">
        	SELECT * FROM get_search_results_ WHERE 1=2
        </cfquery> 
        <cfset attributes.totalrecords = 0>
    </cfif>
</cfif>
<cfparam name="attributes.page" default=1>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif attributes.is_excel eq 1>
	<cfset type_ = 1>
	<cfset filename = "#createuuid()#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-16">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-16">
<cfelse>
	<cfset type_ = 0>
</cfif>
<cf_report_list>
	<cfif attributes.is_excel eq 1>
		<cfset type_ = 1>
		<cfset attributes.startrow = 1>
		<cfset attributes.maxrows = get_search_results_.recordcount>
	<cfelse>
		<cfset type_ = 0>
	</cfif>
	<thead>
		<tr>
			<th><cf_get_lang_main no="1165.Sıra"></th>
			<th><cf_get_lang_main no ='225.Seri No'></th>
			<th><cf_get_lang dictionary_id='60368.Biri Miktar'></th>
			<th><cf_get_lang_main no ='245.Ürün'></th>
			<th><cf_get_lang_main no="1435.Marka"></th>
			<th><cf_get_lang_main no ='106.Stok Kodu'></th>
			<th><cf_get_lang_main no='377.Özel Kod'></th>
			<th><cf_get_lang_main no ='221.Barkod'></th>
			<th><cf_get_lang no ='148.Lot'></th>
			<th><cf_get_lang no ='149.RMA'></th>
			<th><cf_get_lang_main no ='218.Tip'></th>
			<th><cf_get_lang no ='150.Garanti Kategorisi'></th>
			<th width="60"><cf_get_lang_main no ='468.Belge No'></th>
			<th><cf_get_lang_main no='388.İşlem Tipi'></th>
			<th width="100"><cf_get_lang_main no='71.Kayıt'></th>
			<th width="65"><cf_get_lang_main no='330.Tarih'></th>
			<th width="65">Belge Tarihi</th>
			<th><cf_get_lang_main no='107.Cari Hesap'></th>
			<th><cf_get_lang_main no='1736.Tedarikçi'></th>
			<th><cf_get_lang_main no ='142.Giriş'> <cf_get_lang_main no='1351.Depo'></th>
			<th><cf_get_lang_main no ='19.Çıkış'> <cf_get_lang_main no='1351.Depo'></th>
			<th><cf_get_lang_main no ='4.Proje'></th>
		</tr>
	</thead>
	<tbody>
	<cfif get_search_results_.recordcount>
		<cfset brand_list=''>
		<cfoutput query="get_search_results_" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<cfif len(brand_id) and not listfind(brand_list,brand_id)>
				<cfset brand_list=listappend(brand_list,brand_id)>
			</cfif>
		</cfoutput>
		<cfif listlen(brand_list)>
			<cfquery name="get_brands" datasource="#DSN3#">
				SELECT BRAND_ID,BRAND_NAME FROM PRODUCT_BRANDS WHERE BRAND_ID IN (#brand_list#) ORDER BY BRAND_ID
			</cfquery>
			<cfset brand_list = listsort(listdeleteduplicates(valuelist(get_brands.brand_id,',')),"numeric","ASC",",")>
		</cfif>
		
		<cfoutput query="get_search_results_" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<cfset type="">
			<cfswitch expression = "#process_cat#">
				<cfcase value="171"><cfset type="objects.popup_dsp_prod_order_result"></cfcase><!--- Ürün Sonucu --->
				<cfcase value="110,111,112,113,114,115,119"><cfset type="popup_dsp_form_upd_fis"></cfcase><!--- Stok Fişleri --->
			<cfdefaultcase><cfset type=""></cfdefaultcase>
			</cfswitch>
			<cfif len(PURCHASE_GUARANTY_CATID)>
				<cfquery name="GET_GUARANTY_CAT" datasource="#dsn#">
					SELECT *,(SELECT GUARANTYCAT_TIME FROM SETUP_GUARANTYCAT_TIME WHERE GUARANTYCAT_TIME_ID = SETUP_GUARANTY.GUARANTYCAT_TIME) GUARANTYCAT_TIME_ FROM SETUP_GUARANTY WHERE GUARANTYCAT_ID = #PURCHASE_GUARANTY_CATID#
				</cfquery>
			<cfelseif len(SALE_GUARANTY_CATID)>
				<cfquery name="GET_GUARANTY_CAT" datasource="#dsn#">
					SELECT *,(SELECT GUARANTYCAT_TIME FROM SETUP_GUARANTYCAT_TIME WHERE GUARANTYCAT_TIME_ID = SETUP_GUARANTY.GUARANTYCAT_TIME) GUARANTYCAT_TIME_ FROM SETUP_GUARANTY WHERE GUARANTYCAT_ID = #SALE_GUARANTY_CATID#
				</cfquery>
			<cfelse>
				<cfset GET_GUARANTY_CAT.recordcount = 0>
			</cfif>
		<tr>
			<td>#currentrow#</td>
			<td>
				<cfif isdefined("attributes.is_excel")>
					#SERIAL_NO#
				<cfelse>
					<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.serial_no&event=det&product_serial_no=#SERIAL_NO#&seri_stock_id=#stock_id#&rma_no=','list')" class="tableyazi">#SERIAL_NO#</a>
				</cfif>
			</td>
				<cfquery name="get_unit_all" datasource="#dsn3#">
					SELECT ADD_UNIT, MULTIPLIER from STOCKS LEFT JOIN PRODUCT_UNIT ON STOCKS.PRODUCT_ID = PRODUCT_UNIT.PRODUCT_ID WHERE STOCK_ID = #STOCK_ID#
				</cfquery>
				<td>#tlformat(UNIT_ROW_QUANTITY)# #get_unit_all.ADD_UNIT#</td>
				<td>#PRODUCT_NAME# #PROPERTY#</td>
				<td><cfif len(brand_id)>#get_brands.BRAND_NAME[listfind(brand_list,brand_id,',')]#</cfif></td>
				<td>#STOCK_CODE#</td>
				<td>#PRODUCT_CODE_2#</td>
				<td>#BARCOD#</td>
				<td>#LOT_NO#</td>
				<td>#RMA_NO#</td>
			<td>
				<cfif process_cat eq 111><!--- Sarf fişi ise--->
					<cf_get_lang_main no='36.Satış'>
					<cfset attributes.guarantycat_id = SALE_GUARANTY_CATID>
				<cfelseif main_process_type eq 171><!--- Üretim sonucu sarf --->
					<cf_get_lang_main no='36.Satış'>
					<cfset attributes.guarantycat_id = SALE_GUARANTY_CATID>
				<cfelseif listfind('81,811,113',process_cat)><!--- sevk irsaliyesi --->
					<cfif in_out eq 1>
						<cf_get_lang_main no='764.Alış'>
						<cfset attributes.guarantycat_id = PURCHASE_GUARANTY_CATID>
					<cfelse>
						<cf_get_lang_main no='36.Satış'>
						<cfset attributes.guarantycat_id = SALE_GUARANTY_CATID>
					</cfif>
				<cfelse>
					<cfif is_sale eq 1>
						<cf_get_lang_main no='36.Satış'>
						<cfset attributes.guarantycat_id = SALE_GUARANTY_CATID>
					<cfelse>
						<cf_get_lang_main no='764.Alış'>
						<cfset attributes.guarantycat_id = PURCHASE_GUARANTY_CATID>
					</cfif>
				</cfif>
			</td>
			<td><cfif GET_GUARANTY_CAT.recordcount>#GET_GUARANTY_CAT.guarantycat# - #GET_GUARANTY_CAT.guarantycat_time_# <cf_get_lang_main no='1312.ay'></cfif> </td>	
			<td>#process_no#</td>	
			<td>#replace(get_process_name(process_cat),';','')#</td>	
			<td>#employee_name# #employee_surname#</td>	
			<td format="date">#dateformat(record_date,dateformat_style)#</td>
			<td format="date">
				<cfif len(PROCESS_ID)>
					<cfquery name="get_rec_date" datasource="#dsn2#">
						SELECT SHIP_DATE REC_DATE FROM SHIP WHERE SHIP_TYPE = #PROCESS_CAT#  AND SHIP_ID = #PROCESS_ID# AND SHIP_NUMBER = '#PROCESS_NO#'
					</cfquery>
					<cfif not get_rec_date.recordcount>
						<cfquery name="get_rec_date" datasource="#dsn2#">
							SELECT FIS_DATE REC_DATE FROM STOCK_FIS WHERE FIS_TYPE = #PROCESS_CAT#  AND FIS_ID = #PROCESS_ID# AND FIS_NUMBER = '#PROCESS_NO#'
						</cfquery>
						<cfif not get_rec_date.recordcount>
							<cfquery name="get_rec_date" datasource="#dsn2#">
								SELECT RECORD_DATE REC_DATE FROM STOCK_EXCHANGE WHERE PROCESS_TYPE = #PROCESS_CAT#  AND PROCESS_CAT =  #PROCESS_ID# AND EXCHANGE_NUMBER = '#PROCESS_NO#'              
							</cfquery>
							<cfif not get_rec_date.recordcount and process_cat eq 171>
								<cfquery name="get_rec_date" datasource="#dsn2#">
									SELECT FINISH_DATE REC_DATE FROM #dsn3_alias#.PRODUCTION_ORDER_RESULTS WHERE  PR_ORDER_ID = #PROCESS_ID# AND RESULT_NO = '#PROCESS_NO#'
								</cfquery> 
							</cfif>   
						</cfif>
					</cfif>
				<cfelse>
					<cfset get_rec_date.recordcount = 0>
				</cfif>
				<cfif get_rec_date.recordcount>
					#dateformat(get_rec_date.REC_DATE,dateformat_style)#
				</cfif>
			</td>
			<td>
				<cfif isdefined("attributes.is_excel")>
					<cfif len(sale_consumer_id)>#get_cons_info(sale_consumer_id,1,0)#
					<cfelseif len(sale_company_id)>#get_par_info(sale_company_id,1,1,0)#
					<cfelseif len(purchase_company_id)>#get_par_info(purchase_company_id,1,1,0)#
					<cfelseif len(purchase_consumer_id)>#get_cons_info(purchase_consumer_id,1,0)#
					</cfif>
				<cfelse>
					<cfif len(sale_consumer_id)>#get_cons_info(sale_consumer_id,1,1)#
					<cfelseif len(sale_company_id)>#get_par_info(sale_company_id,1,1,1)#
					<cfelseif len(purchase_company_id)>#get_par_info(purchase_company_id,1,1,1)#
					<cfelseif len(purchase_consumer_id)>#get_cons_info(purchase_consumer_id,1,1)#
					</cfif>
				</cfif>
			</td>
			<td>
				<cfif isdefined("attributes.is_excel")>
					<cfif len(company_id)>
						#get_par_info(company_id,1,1,0)#
					</cfif>				
				<cfelse>
					<cfif len(company_id)>
						#get_par_info(company_id,1,1,1)#
					</cfif>
				</cfif>
			</td>
			<td><cfif IN_OUT eq 1>#DEPARTMENT_HEAD# - #LOCATION#</cfif></td>
			
			<td>	
				<cfif IN_OUT eq 0>
					<cfif process_cat eq 111 and main_process_type eq 171>
						<cfquery name="get_dep" datasource="#dsn3#">
							SELECT 
								D.DEPARTMENT_HEAD,
								SL.COMMENT AS LOCATION
							FROM
								#DSN_ALIAS#.DEPARTMENT D,
								#DSN_ALIAS#.STOCKS_LOCATION SL
							WHERE
								SL.DEPARTMENT_ID = D.DEPARTMENT_ID AND
								D.DEPARTMENT_ID IN (SELECT EXIT_DEP_ID FROM PRODUCTION_ORDER_RESULTS WHERE PR_ORDER_ID = #MAIN_PROCESS_ID#)
								AND SL.LOCATION_ID IN (SELECT EXIT_LOC_ID FROM PRODUCTION_ORDER_RESULTS WHERE PR_ORDER_ID = #MAIN_PROCESS_ID#)
						</cfquery>
						<cfif get_dep.recordcount>
						#GET_DEP.DEPARTMENT_HEAD# - #GET_DEP.LOCATION#
						</cfif>
					<cfelse>
						#DEPARTMENT_HEAD# - #LOCATION#
					</cfif>            
				</cfif>
			</td>
			<td><cfif len(PROJECT_ID)>#GET_PROJECT_NAME(PROJECT_ID)#</cfif></td>
		</tr>
		</cfoutput>
	<cfelse>
		<tr>
			<td colspan="22"><cfif isdefined("attributes.is_form_submit")><cf_get_lang_main no='1074.Kayıt Bulunamadı'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz'></cfif></td>
		</tr>
	</cfif>
	</tbody>
</cf_report_list>
<cfif attributes.totalrecords gt attributes.maxrows>
	<cfset adres="report.serial_report&is_form_submit=1">
	<cfif len(attributes.serial_no)>
		<cfset adres="#adres#&serial_no=#attributes.serial_no#">
	</cfif>
	<cfif len(attributes.lot_no)>
		<cfset adres="#adres#&lot_no=#attributes.lot_no#">
	</cfif>
	<cfif len(attributes.brand_id)>
		<cfset adres="#adres#&brand_id=#attributes.brand_id#">
	</cfif>
	<cfif len(attributes.process_no)>
		<cfset adres="#adres#&process_no=#attributes.process_no#">
	</cfif>
	<cfif len(attributes.rma_no)>
		<cfset adres="#adres#&rma_no=#attributes.rma_no#">
	</cfif>
	<cfif len(attributes.start_date)>
		<cfset adres="#adres#&start_date=#dateformat(attributes.start_date)#">
	<cfelse>
		<cfset adres="#adres#&start_date=#attributes.start_date#">
	</cfif>
	<cfif len(attributes.finish_date)>
		<cfset adres="#adres#&finish_date=#dateformat(attributes.finish_date)#">
	<cfelse>
		<cfset adres="#adres#&finish_date=#attributes.finish_date#">
	</cfif>
	<cfif len(attributes.start_date2)>
		<cfset adres="#adres#&start_date2=#dateformat(attributes.start_date2)#">
	<cfelse>
		<cfset adres="#adres#&start_date2=#attributes.start_date2#">
	</cfif>
	<cfif len(attributes.finish_date2)>
		<cfset adres="#adres#&finish_date2=#dateformat(attributes.finish_date2)#">
	<cfelse>
		<cfset adres="#adres#&finish_date2=#attributes.finish_date2#">
	</cfif>            
	<cfif len(attributes.process_cat_id)>
		<cfset adres="#adres#&process_cat_id=#attributes.process_cat_id#">
	</cfif>
	<cfif isdefined("attributes.product_id") and len(attributes.product_id) and len(attributes.product)>
		<cfset adres="#adres#&product_id=#attributes.product_id#">
		<cfset adres="#adres#&product=#attributes.product#">
	</cfif>
		<cfif isdefined("attributes.stock_id") and len(attributes.stock_id) and len(attributes.stock_id)>
		<cfset adres="#adres#&stock_id=#attributes.stock_id#">
	</cfif>
	<cfif isdefined("attributes.product_catid") and len(attributes.product_catid) and len(attributes.product_cat)>
		<cfset adres="#adres#&product_catid=#attributes.product_catid#">
		<cfset adres="#adres#&product_cat=#attributes.product_cat#">
	</cfif>
	<cfif isdefined("attributes.product_hierarchy") and len(attributes.product_hierarchy)>
		<cfset adres="#adres#&product_hierarchy=#attributes.product_hierarchy#">
	</cfif>
	<cfif isdefined("attributes.company_id") and len(attributes.company_id) and len(attributes.company)>
		<cfset adres="#adres#&company_id=#attributes.company_id#">
		<cfset adres="#adres#&company=#attributes.company#">
	</cfif>
	<cfif isdefined("attributes.tedarikci_company_id") and len(attributes.tedarikci_company_id) and len(attributes.tedarikci_company)>
		<cfset adres="#adres#&tedarikci_company_id=#attributes.tedarikci_company_id#">
		<cfset adres="#adres#&tedarikci_company=#attributes.tedarikci_company#">
	</cfif>
	<cfif isdefined("attributes.department_id") and len(attributes.department_id) and len(attributes.department)>
		<cfset adres="#adres#&department_id=#attributes.department_id#">
		<cfset adres="#adres#&location_id=#attributes.location_id#">
		<cfset adres="#adres#&department=#attributes.department#">
	</cfif>
		<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)>
		<cfset adres="#adres#&subscription_id=#attributes.subscription_id#">
	</cfif>
	<cfif isdefined("attributes.order_type") and len(attributes.order_type)>
		<cfset adres="#adres#&order_type=#attributes.order_type#">
	</cfif>
	<cfif len(attributes.employee_id)>
		<cfset adres="#adres#&employee_id=#attributes.employee_id#">
	</cfif>
	<cfif len(attributes.employee)>
		<cfset adres="#adres#&employee=#attributes.employee#">
	</cfif>
	<cfif isdefined("attributes.is_last_action")>
		<cfset adres="#adres#&is_last_action=1">
	</cfif>
	<cfif len(attributes.is_sale)>
		<cfset adres="#adres#&is_sale=#attributes.is_sale#">
	</cfif>
	<cf_paging page="#attributes.page#" 
		maxrows="#attributes.maxrows#" 
		totalrecords="#attributes.totalrecords#" 
		startrow="#attributes.startrow#" 
		adres="#adres#">
</cfif>
<cfsetting showdebugoutput="yes">
<script type="text/javascript">
    function control() {
        if(document.search_.is_excel.checked==false){
            document.search_.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>";
            return true;
        }
        else
			document.search_.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_serial_report</cfoutput>";
    }
</script>