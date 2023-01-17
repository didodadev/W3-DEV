<cf_xml_page_edit fuseact="invent.add_invent_sale">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.comp_name" default="">
<cfparam name="attributes.partner_name" default="">
<cfset variable = '1'>
<cfset variable1 = '67'>
<cfset variable2 = '69'>
<cfif isDefined("attributes.ship_id")>
	<cfquery name="GET_SHIP" datasource="#dsn2#">
		SELECT SHIP_NUMBER,INVOICE_ID FROM INVOICE_SHIPS WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_id#"> AND SHIP_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> 
	</cfquery>
	<cfset attributes.invoice_id = GET_SHIP.INVOICE_ID>
<cfelse>
	<cfquery name="GET_SHIP" datasource="#dsn2#">
		SELECT SHIP_NUMBER FROM INVOICE_SHIPS WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> 
	</cfquery>
</cfif>
<cfif GET_SHIP.recordcount eq 0>
	<cfset hata  = 11>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='57997.Şube Yetkiniz Uygun Değil'> <cf_get_lang dictionary_id='57998.Veya'>  <cf_get_lang dictionary_id='57999.Çalıştığınız Muhasebe Dönemine Ait Böyle Bir Fatura Bulunamadı'> !</cfsavecontent>
	<cfset hata_mesaj  = message>
	<cfinclude template="../../dsp_hata.cfm">
<cfelse>
	<cffile action="read" file="#index_folder#admin_tools#dir_seperator#xml#dir_seperator#reason_codes.xml" variable="xmldosyam" charset = "UTF-8">
	<cfset dosyam = XmlParse(xmldosyam)>
	<cfset xml_dizi = dosyam.REASON_CODES.XmlChildren>
	<cfset d_boyut = ArrayLen(xml_dizi)>
	<cfset reason_code_list = "">
	<cfloop index="abc" from="1" to="#d_boyut#">    	
		<cfset reason_code_list = listappend(reason_code_list,'#dosyam.REASON_CODES.REASONS[abc].REASONS_CODE.XmlText#--#dosyam.REASON_CODES.REASONS[abc].REASONS_NAME.XmlText#','*')>
	</cfloop>
	<cfquery name="GET_SALE_MONEY" datasource="#dsn2#">
		SELECT RATE2,MONEY_TYPE FROM INVOICE_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND IS_SELECTED=<cfqueryparam value="#variable#" cfsqltype="cf_sql_smallint">
	</cfquery>
	<cfif not GET_SALE_MONEY.recordcount>
		<cfquery name="GET_SALE_MONEY" datasource="#DSN#">
			SELECT MONEY,0 AS IS_SELECTED,* FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY_STATUS=<cfqueryparam value="#variable#" cfsqltype="cf_sql_smallint">
		</cfquery>
	</cfif>
	<cfquery name="GET_INVOICE" datasource="#dsn2#">
		SELECT 
	        INVOICE.*,
            CASE WHEN CA.ACTION_ID IS NOT NULL THEN CA.ACTION_ID ELSE 0 END AS RELATED_ACTION_ID,
        	CASE WHEN CA.ACTION_ID IS NOT NULL THEN 'CASH_ACTIONS' ELSE '' END AS RELATED_ACTION_TABLE,
            CASE
            	WHEN COMPANY.COMPANY_ID IS NOT NULL THEN COMPANY.USE_EFATURA
                WHEN CONSUMER.CONSUMER_ID IS NOT NULL THEN CONSUMER.USE_EFATURA
            END AS 
            	USE_EFATURA,
	        SPC.INVOICE_TYPE_CODE
        FROM 
            INVOICE
            	LEFT JOIN CASH_ACTIONS CA ON CA.PAPER_NO = INVOICE.INVOICE_NUMBER
                LEFT JOIN #dsn_alias#.COMPANY ON COMPANY.COMPANY_ID = INVOICE.COMPANY_ID AND COMPANY.USE_EFATURA = 1 AND COMPANY.EFATURA_DATE <= INVOICE.INVOICE_DATE
                LEFT JOIN #dsn_alias#.CONSUMER ON CONSUMER.CONSUMER_ID = INVOICE.CONSUMER_ID AND CONSUMER.USE_EFATURA = 1 AND CONSUMER.EFATURA_DATE <= INVOICE.INVOICE_DATE,
            #dsn3_alias#.SETUP_PROCESS_CAT SPC 
        WHERE
        	INVOICE.PROCESS_CAT = SPC.PROCESS_CAT_ID AND
        	INVOICE.INVOICE_CAT <> <cfqueryparam value="#variable1#" cfsqltype="cf_sql_smallint"> AND 
            INVOICE.INVOICE_CAT <> <cfqueryparam value="#variable2#" cfsqltype="cf_sql_smallint"> AND 
            INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#">
	</cfquery>
	<cfscript>
		get_invent_action = createObject("component", "V16.invoice.cfc.get_bill");
		CHK_SEND_INV= get_invent_action.CHK_SEND_INV(iid:attributes.invoice_id);
		CHK_SEND_ARC= get_invent_action.CHK_SEND_ARC(iid:attributes.invoice_id);
	</cfscript>
	<cfif not GET_INVOICE.recordcount>
		<br/><font class="txtbold"><cf_get_lang dictionary_id='57999.Çalıştığınız Muhasebe Dönemine Ait Böyle Bir Fatura Bulunamadı'> !</font>
		<cfexit method="exittemplate">
	</cfif>
	<cfquery name="GET_INVOICE_MONEY" datasource="#dsn2#">
		SELECT MONEY_TYPE AS MONEY,* FROM INVOICE_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#">
	</cfquery>
	<cfif not GET_INVOICE_MONEY.recordcount>
		<cfquery name="GET_INVOICE_MONEY" datasource="#DSN#">
			SELECT MONEY,0 AS IS_SELECTED,* FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY_STATUS=<cfqueryparam value="#variable#" cfsqltype="cf_sql_smallint">
		</cfquery>
	</cfif>
	<cfquery name="KASA" datasource="#dsn2#">
		SELECT * FROM CASH WHERE CASH_ACC_CODE IS NOT NULL ORDER BY CASH_NAME
	</cfquery>
	<cfquery name="GET_MONEY" datasource="#dsn#">
		SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = <cfqueryparam value="#variable#" cfsqltype="cf_sql_smallint">
	</cfquery>
	<cfquery name="GET_TAX" datasource="#dsn2#">
		SELECT * FROM SETUP_TAX ORDER BY TAX
	</cfquery>
	<cfquery name="GET_OTV" datasource="#DSN3#">
		SELECT TAX FROM SETUP_OTV WHERE PERIOD_ID = #session.ep.period_id# ORDER BY TAX
	</cfquery>
	<cfquery name="GET_ACCOUNTS" datasource="#dsn3#">
		SELECT ACCOUNT_ID,ACCOUNT_CURRENCY_ID,ACCOUNT_NAME FROM ACCOUNTS ORDER BY ACCOUNT_NAME
	</cfquery>
	<cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
		SELECT EXPENSE_ID,EXPENSE,EXPENSE_CODE FROM EXPENSE_CENTER ORDER BY EXPENSE
	</cfquery>
	<cfquery name="GET_SALE_DET" datasource="#dsn2#">
		SELECT 
			ACC_DEPARTMENT_ID
		FROM
			INVOICE
		WHERE
			INVOICE_CAT <> 67 AND
			INVOICE_CAT <> 69
	</cfquery>
    <cfquery name="get_einvoice_type" datasource="#DSN#" maxrows="1"><!---MCP tarafından #75351 numaralı iş için E-Fatura Kullanıp Kullanmadığı Kontrolü İçin kullanılacak. --->
         SELECT * FROM OUR_COMPANY_INFO WHERE COMP_ID = #session.ep.company_id#
    </cfquery>
	<cfquery name="CONTROL_EARCHIVE" datasource="#DSN2#">
		SELECT ISNULL(IS_CANCEL,0) IS_CANCEL FROM EARCHIVE_RELATION WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND ACTION_TYPE = 'INVOICE'
	</cfquery>
	<cfquery name="CONTROL_EINVOICE" datasource="#DSN2#">
		SELECT ACTION_ID FROM EINVOICE_RELATION WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND ACTION_TYPE = 'INVOICE'
	</cfquery>
	<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
	<cfform name="upd_invent" method="post" action="#request.self#?fuseaction=invent.emptypopup_upd_invent_sale">
		<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
		<input type="hidden" name="xml_total_budget" id="xml_total_budget" value="<cfoutput>#xml_total_budget#</cfoutput>">  
		<cf_box_elements id="invent_sale" name="invent_sale">
			<cfoutput>
				<input type="hidden" name="invoice_id" id="invoice_id" value="#attributes.invoice_id#">
				<input type="hidden" name="invoice_cari_action_type" id="invoice_cari_action_type" value="<cfif len(get_invoice.cari_action_type)>#get_invoice.cari_action_type#</cfif>">
				<input type="hidden" name="invoice_payment_plan" id="invoice_payment_plan" value="1">
			</cfoutput>
			<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group" id="item-process_cat">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.İşlem Tipi'> *</label>
					<div class="col col-8 col-xs-12"><cf_workcube_process_cat process_cat='#get_invoice.process_cat#' slct_width='140'></div>
				</div>
				<div class="form-group" id="item-comp_name">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'> *</label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfif len(get_invoice.employee_id) and len(get_invoice.acc_type_id)>
								<cfset emp_id = "#get_invoice.employee_id#_#get_invoice.acc_type_id#">
								<cfset acc_type_id = get_invoice.acc_type_id>
							<cfelseif len(get_invoice.employee_id)>
								<cfset emp_id = get_invoice.employee_id>
								<cfset acc_type_id = ''>
							</cfif>
							<cfoutput>
								<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif len(get_invoice.consumer_id)>#get_invoice.consumer_id#</cfif>">
								<input type="hidden" name="company_id" id="company_id" value="<cfif len(get_invoice.company_id)>#get_invoice.company_id#</cfif>">
								<input type="hidden" name="emp_id" id="emp_id" value="<cfif isdefined("emp_id") and len(emp_id)>#emp_id#</cfif>">
								<input type="text" name="comp_name" id="comp_name" value="<cfif len(get_invoice.company_id)>#get_par_info(get_invoice.company_id,1,0,0)#</cfif>" readonly="readonly" style="width:140px;">
							</cfoutput>
							<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.Seçiniz'>" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&select_list=1,2,3&field_name=upd_invent.partner_name&field_partner=upd_invent.partner_id&field_comp_name=upd_invent.comp_name&field_comp_id=upd_invent.company_id&field_consumer=upd_invent.consumer_id&field_emp_id=upd_invent.emp_id&field_revmethod_id=upd_invent.paymethod_id&field_adress_id=upd_invent.ship_address_id&field_long_address=upd_invent.adres&field_revmethod=upd_invent.paymethod&field_basket_due_value_rev=upd_invent.basket_due_value&call_function=change_paper_duedate()</cfoutput>','list');"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-partner_name">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57578.Yetkili'> *</label>
					<div class="col col-8 col-xs-12">
						<cfoutput>
							<input type="hidden" name="partner_id" id="partner_id" value="#get_invoice.partner_id#">
							<cfset str_par_names = "">
							<cfif len(get_invoice.PARTNER_ID)>
								<cfquery name="GET_SALE_DET_CONS" datasource="#dsn#">
									SELECT 
										PARTNER_ID,
										COMPANY_PARTNER_NAME,
										COMPANY_PARTNER_SURNAME
									FROM 
										COMPANY_PARTNER
									WHERE 
										PARTNER_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice.PARTNER_ID#">
								</cfquery>
								<cfset str_par_names = "#GET_SALE_DET_CONS.COMPANY_PARTNER_NAME# #GET_SALE_DET_CONS.COMPANY_PARTNER_SURNAME#" >
							<cfelseif len(get_invoice.consumer_id)>
								<cfset str_par_names = get_cons_info(get_invoice.consumer_id,0,0)>
							<cfelseif len(get_invoice.employee_id)>
								<cfset str_par_names = get_emp_info(get_invoice.employee_id,0,0,0,acc_type_id)>
							</cfif>
							<input type="text" name="partner_name" id="partner_name" value="#str_par_names#" readonly style="width:140px;">						
						</cfoutput>	
					</div>
				</div>
				<div class="form-group" id="item-employee">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56987.Satış Yapan'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="employee_id" id="employee_id"  value="<cfoutput>#get_invoice.sale_emp#</cfoutput>">
							<input type="text" name="employee" id="employee" onchange="clear_();" value="<cfoutput>#get_emp_info(get_invoice.sale_emp,0,0)#</cfoutput>" style="width:140px;">
							<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='56987.Satış Yapan'>" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=upd_invent.employee_id&field_name=upd_invent.employee&select_list=1','list');"></span>
						</div>
					</div>
				</div>
				<cfif session.ep.our_company_info.IS_EFATURA eq 1 >
					<div class="form-group" id="item-ship_address">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="34252.Sevk Adresi"></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="ship_address_id" id="ship_address_id" value="<cfoutput>#GET_INVOICE.SHIP_ADDRESS_ID#</cfoutput>">
								<cfinput type="text" name="adres" value="#GET_INVOICE.SHIP_ADDRESS#" maxlength="200">
								<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='34252.Sevk Adresi'>" onclick="add_adress();"></span>
							</div>
						</div>
					</div>
				</cfif>
			</div>
			<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
				<div class="form-group" id="item-invoice_date">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58759.Fatura Tarihi'> *</label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfinput type="text" name="invoice_date" validate="#validate_style#" value="#dateformat(get_invoice.invoice_date,dateformat_style)#" maxlength="10" onblur="change_money_info('upd_invent','invoice_date');">
							<span class="input-group-addon btnPointer" title="<cf_get_lang dictionary_id='58759.Fatura Tarihi'>" ><cf_wrk_date_image date_field="invoice_date" call_function="change_paper_duedate&change_money_info"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-serial_no">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label><cf_get_lang dictionary_id='57637.Seri No'> *</label>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <cfinput type="text" name="serial_number" maxlength="5" value="#get_invoice.serial_number#">
                        </div>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfinput type="text" name="serial_no" value="#get_invoice.serial_no#" onBlur="paper_control(this,'INVOICE',true,'#attributes.invoice_id#','#get_invoice.serial_no#','','','','','',upd_invent.serial_number);">
                        </div>
                    </div>
                </div>
				<div class="form-group" id="item-ship_number">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58138.İrsaliye No'> *</label>
					<div class="col col-8 col-xs-12">
						<cfinput type="text" name="ship_number" value="#GET_SHIP.SHIP_NUMBER#" maxlength="50">
					</div>
				</div>
				<cfif xml_is_department neq 0>
					<div class="form-group" id="item-acc_department">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'><cfif xml_is_department eq 2> *</cfif></label>
						<div class="col col-8 col-xs-12">
								<cf_wrkDepartmentBranch fieldId='acc_department_id' is_department='1' width='135' selected_value='#get_invoice.ACC_DEPARTMENT_ID#'>
						</div>
					</div>
				</cfif>
			</div>
			<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
				<div class="form-group" id="item-department_location">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58763.Depo'> *</label>
					<div class="col col-8 col-xs-12">
						<cfset location_info_ = get_location_info(get_invoice.department_id,get_invoice.department_location,1,1)>
						<cf_wrkdepartmentlocation
							returnInputValue="location_id,department_name,department_id,branch_id"
							returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
							fieldName="department_name"
							fieldid="location_id"
							department_fldId="department_id"
							branch_fldId="branch_id"
							branch_id="#listlast(location_info_,',')#"
							department_id="#get_invoice.department_id#"
							location_id="#get_invoice.department_location#"
							user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
							width="125">
					</div>
				</div>
				<div class="form-group" id="item-paymethod">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58516.Ödeme Yöntemi'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfif len(get_invoice.pay_method)>
								<cfquery name="get_paymethod" datasource="#DSN#">
									SELECT * FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = #get_invoice.PAY_METHOD#
								</cfquery>						  
								<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
								<input type="hidden" name="commission_rate" id="commission_rate" value="">
								<input type="hidden" name="paymethod_id" id="paymethod_id" value="<cfoutput>#get_invoice.pay_method#</cfoutput>">
								<input type="text" name="paymethod" id="paymethod" style="width:125px;"  value="<cfoutput>#get_paymethod.paymethod#</cfoutput>">
							<cfelseif len(get_invoice.card_paymethod_id)>
								<cfquery name="get_card_paymethod" datasource="#dsn3#">
									SELECT CARD_NO,COMMISSION_MULTIPLIER FROM CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID=#get_invoice.card_paymethod_id#
								</cfquery>
								<cfoutput>
									<input type="hidden" name="paymethod_id" id="paymethod_id" value="">
									<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="#get_invoice.card_paymethod_id#">
									<input type="hidden" name="commission_rate" id="commission_rate" value="#get_card_paymethod.commission_multiplier#">
									<input type="text" name="paymethod" id="paymethod" style="width:140px;"  value="#get_card_paymethod.card_no#">
								</cfoutput>
							<cfelse>
								<input type="hidden" name="paymethod_id" id="paymethod_id" value="">
								<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
								<input type="hidden" name="commission_rate" id="commission_rate" value="">
								<input type="text" name="paymethod" id="paymethod" style="width:125px;" value="">
							</cfif>
							<cfset card_link="&field_card_payment_id=upd_invent.card_paymethod_id&field_card_payment_name=upd_invent.paymethod&field_commission_rate=upd_invent.commission_rate">
							<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.Seçiniz'>" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_paymethods&field_id=upd_invent.paymethod_id&field_dueday=upd_invent.basket_due_value&function_name=change_paper_duedate&field_name=upd_invent.paymethod#card_link#</cfoutput>','list');"></span>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-xs-12"></label>
					<div class="col col-8 col-xs-12">
						
					</div>
				</div>
				<div class="form-group" id="item-basket_due_value">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label><cf_get_lang dictionary_id='57640.Vade'></label>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                           <input name="basket_due_value" id="basket_due_value" type="text" value="<cfif len(get_invoice.due_date) and len(get_invoice.invoice_date)><cfoutput>#datediff('d',get_invoice.invoice_date,get_invoice.due_date)#</cfoutput></cfif>" onchange="change_paper_duedate('invoice_date');" style="width:45px;">
                        </div>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
								<cfinput type="text" name="basket_due_value_date_" value="#dateformat(get_invoice.due_date,dateformat_style)#" onChange="change_paper_duedate('invoice_date',1);" validate="#validate_style#" maxlength="10" style="width:75px;" readonly>
								<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="basket_due_value_date_"></span>
							</div>
                        </div>
                    </div>
                </div>
				<cfif session.ep.our_company_info.project_followup eq 1>
					<div class="form-group" id="item-project">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cf_wrk_projects form_name='upd_invent' project_id='project_id' project_name='project_head'>
								<cfif len(get_invoice.project_id)>
									<cfquery name="GET_PROJECT" datasource="#dsn#">
										SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice.project_id#">
									</cfquery>
									<input type="hidden" name="project_id" id="project_id" value="<cfoutput>#get_invoice.project_id#</cfoutput>"> 
									<input type="text" name="project_head" id="project_head" value="<cfoutput>#get_project.project_head#</cfoutput>" style="width:125px;" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','150');" autocomplete="off">
								<cfelse>
									<input type="hidden" name="project_id" id="project_id" value=""> 
									<input type="text" name="project_head" id="project_head" style="width:125px;" value="" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','150');" autocomplete="off">
								</cfif>
								<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=upd_invent.project_id&project_head=upd_invent.project_head');"></span>
							</div>
						</div>
					</div>
				</cfif>
			</div>
			<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
				<div class="form-group" id="item-detail">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
					<div class="col col-8 col-xs-12">
						<textarea name="detail" id="detail" style="width:140px;height:50px;"><cfoutput>#get_invoice.note#</cfoutput></textarea>
					</div>
				</div>
				<div class="form-group" id="item-cash">
					<label class="col col-4 col-xs-12">
						<div id="kasa_sec_text">
							<cfif kasa.recordcount>
								<cf_get_lang dictionary_id='57448.Nakit Satış'>
								<input type="checkbox" name="cash" id="cash" onclick="gizle_goster(not);"<cfif get_invoice.is_cash eq 1>checked</cfif>>
							</cfif>
						</div>
					</label>
					<div class="col col-8 col-xs-12" <cfif get_invoice.is_cash neq 1> style="display:none;" </cfif> id="not">
						<cfif kasa.recordcount>
							<select name="kasa" id="kasa" style="width:138px;">
								<cfoutput query="kasa">
									<option value="#cash_id#;#cash_currency_id#" <cfif get_invoice.kasa_id eq cash_id>selected</cfif>>#cash_name#</option>
								</cfoutput>
							</select>
							<cfoutput query="kasa">
								<input type="hidden" name="str_kasa_parasi#cash_id#" id="str_kasa_parasi#cash_id#" value="#CASH_CURRENCY_ID#">
							</cfoutput>	
						</cfif>
					</div>
				</div>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
				<cf_record_info query_name='get_invoice' margin="1">
			</div>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
				<cfif not len(isClosed('INVOICE',attributes.invoice_id)) and (get_invoice.RELATED_ACTION_TABLE eq '' or not len(isClosed(get_invoice.RELATED_ACTION_TABLE,get_invoice.RELATED_ACTION_ID)))>
					<cfif get_invoice.is_iptal eq 1 and session.ep.our_company_info.is_earchive eq 1>
						<b><font color="FF0000"><cf_get_lang dictionary_id="59833.Fatura İptal Edildi"> <cfif control_earchive.recordcount and control_earchive.is_cancel eq 0>(<cf_get_lang dictionary_id="59847.İptal Bilgisi E-Arşiv Sistemine Gönderilmedi">)</cfif></font></b>
					<cfelse>
						<cfif chk_send_arc.recordcount and chk_send_arc.count gt 0 or (chk_send_inv.recordcount and chk_send_inv.count gt 0 )>
							<cf_workcube_buttons is_upd='1' add_function='kontrol()' is_delete='0' update_status="#get_invoice.upd_status#">
							<font color="FF0000"><cf_get_lang dictionary_id='60630.Fatura ile İlişkili e-Fatura veya e-Arşiv Olduğu için Silinemez!'>!</font>
						<cfelse>
							<cf_workcube_buttons is_upd='1' add_function='kontrol()' is_delete='1' update_status="#get_invoice.upd_status#" delete_page_url='#request.self#?fuseaction=invent.add_invent_sale&event=del&invoice_id=#attributes.invoice_id#&head=#get_invoice.invoice_number#&old_process_type=#get_invoice.invoice_cat#'>
						</cfif>
					</cfif>
				<cfelse>
					<font color="FF0000"><cf_get_lang dictionary_id='47262.Fatura kapama işlemi yapılan belgede değişiklik yapılamaz'>!</font>
				</cfif>
			</div>			
		</cf_box_footer>                    	 
		
		<cf_basket id="invent_sale_bask">
			<cfquery name="GET_ROWS" datasource="#dsn2#">
				SELECT DISTINCT
					INVOICE_ROW.NETTOTAL,
					INVOICE_ROW.GROSSTOTAL,
					INVOICE_ROW.PRICE,
                    INVOICE_ROW.PRICE_OTHER,
					INVOICE_ROW.TAX,
					INVOICE_ROW.OTV_ORAN,
					INVOICE_ROW.TAXTOTAL,
					INVOICE_ROW.OTVTOTAL,
					INVOICE_ROW.OTHER_MONEY_VALUE,
					INVOICE_ROW.OTHER_MONEY_GROSS_TOTAL,
					INVOICE_ROW.OTHER_MONEY,
					INVOICE_ROW.PRODUCT_ID,
					INVOICE_ROW.STOCK_ID,
					INVOICE_ROW.NAME_PRODUCT,
					INVOICE_ROW.UNIT_ID,
					INVOICE_ROW.UNIT,
					INVENTORY.*,
					INVENTORY_ROW.STOCK_OUT,
					INVENTORY_ROW.INVENTORY_ROW_ID,
					INVOICE_ROW.WRK_ROW_ID,
					INVOICE_ROW.REASON_CODE,
					INVOICE_ROW.REASON_NAME
				FROM
					INVOICE_ROW,
					#dsn3_alias#.INVENTORY INVENTORY,
					#dsn3_alias#.INVENTORY_ROW INVENTORY_ROW
				WHERE
					INVOICE_ROW.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND
					INVENTORY_ROW.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND
					INVENTORY.INVENTORY_ID = INVOICE_ROW.INVENTORY_ID AND
					INVENTORY_ROW.INVENTORY_ID = INVENTORY.INVENTORY_ID AND
					INVENTORY_ROW.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
				ORDER BY
					INVENTORY_ROW.INVENTORY_ROW_ID
			</cfquery>
			<cfset item_id_list=''>
			<cfset exp_center_id_list=''>
			<cfoutput query="GET_ROWS">
				<cfif len(SALE_EXPENSE_ITEM_ID) and not listfind(item_id_list,SALE_EXPENSE_ITEM_ID)>
					<cfset item_id_list=listappend(item_id_list,SALE_EXPENSE_ITEM_ID)>
				</cfif>
				<cfif len(SALE_EXPENSE_CENTER_ID) and not listfind(exp_center_id_list,SALE_EXPENSE_CENTER_ID)>
					<cfset exp_center_id_list=listappend(exp_center_id_list,SALE_EXPENSE_CENTER_ID)>
				</cfif>
			</cfoutput>
			<cfif len(item_id_list)>
				<cfset item_id_list=listsort(item_id_list,"numeric","ASC",",")>
				<cfquery name="get_exp_detail" datasource="#dsn2#">
					SELECT EXPENSE_ITEM_NAME,ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID IN (#item_id_list#) ORDER BY EXPENSE_ITEM_ID
				</cfquery>
			</cfif>
			<cfif len(exp_center_id_list)>
				<cfquery name="get_expense_center" datasource="#dsn2#">
					SELECT * FROM EXPENSE_CENTER WHERE EXPENSE_ID IN (#exp_center_id_list#) ORDER BY EXPENSE_ID
				</cfquery>
				<cfset exp_center_id_list = listsort(listdeleteduplicates(valuelist(get_expense_center.EXPENSE_ID,',')),'numeric','ASC',',')>
			</cfif>
			<cf_grid_list name="table1" id="table1" class="detail_basket_list">
				<thead>
					<cfif xml_multi_change eq 1>
					<tr>
						<th colspan="14"></th>
						<th nowrap="nowrap">
							<input type="hidden" name="account_id_all" id="account_id_all" value="" />
							<input type="text" name="account_code_all" id="account_code_all" value="" style="width:118px;"/>
							<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=upd_invent.account_id_all&field_name=upd_invent.account_code_all&function_name=change_acc_all()','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
						</th>
						<th colspan="2"></th>
						<th nowrap="nowrap">	<!--- masraf merkezi --->	
							<input type="hidden" name="expense_center_id_all" id="expense_center_id_all" value="">
							<input type="text" name="main_exp_center_name_all" id="main_exp_center_name_all" style="width:130px;" value="" onfocus="AutoComplete_Create('main_exp_center_name_all','EXPENSE,EXPENSE_CODE','EXPENSE,EXPENSE_CODE','get_expense_center','','EXPENSE_ID','expense_center_id_all','','3','200',true,'change_expense_center()');"  autocomplete="off">
							<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&field_id=upd_invent.expense_center_id_all&field_name=upd_invent.main_exp_center_name_all&call_function=change_expense_center()','list','popup_expense_center');"><img src="/images/plus_thin.gif" align="absbottom" border="0"></a>
						</th>
						<th nowrap="nowrap">
							<input type="hidden" name="budget_item_id_all" id="budget_item_id_all" value=""/>
							<input type="text" name="budget_item_name_all" id="budget_item_name_all" value="" style="width:115px;"/>
							<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&is_budget_items=1&field_id=upd_invent.budget_item_id_all&field_name=upd_invent.budget_item_name_all&field_account_no=upd_invent.budget_account_code_all&field_account_no2=upd_invent.budget_account_id_all&function_name=change_exp_all()','list');" ><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
						</th>
						<th nowrap="nowrap">
							<input type="hidden" name="budget_account_id_all" id="budget_account_id_all" value="" />
							<input type="text" name="budget_account_code_all" id="budget_account_code_all" value="" style="width:155px;"/>
							<img src="/images/plus_thin.gif" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=upd_invent.budget_account_id_all&field_name=upd_invent.budget_account_code_all&function_name=change_budget_acc_all()','list');" align="absmiddle" border="0"></a>
						</th>
						<th nowrap="nowrap">
							<input type="hidden" name="amort_account_id_all" id="amort_account_id_all" value="">
							<input type="text" name="amort_account_code_all" id="amort_account_code_all" value="" style="width:205px;">
							<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=upd_invent.amort_account_id_all&field_name=upd_invent.amort_account_code_all&function_name=change_amort_all()','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
						</th>
						<th colspan="3"></th>
					</tr>
					</cfif>
					<tr>
						<th><input name="record_num" id="record_num" type="hidden" value="<cfoutput>#get_rows.recordcount#</cfoutput>"> <input type="button" class="eklebuton" title="<cf_get_lang dictionary_id='57582.Ekle'>" onclick="f_upd_invent();"></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='58878.Demirbaş No'></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='57629.Açıklama'></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='57635.Miktar'></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='57638.Birim Fiyat'></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id="59342.Dövizli Birim Fiyat"></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='57639.KDV'> %</th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='58021.OTV'> % &nbsp;</th>
						<th nowrap="nowrap" style="text-align:right;"><cf_get_lang dictionary_id='57639.KDV'></th>
						<th nowrap="nowrap" style="text-align:right;">&nbsp;<cf_get_lang dictionary_id='58021.OTV'></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='58083.Net'><cf_get_lang dictionary_id='58084.Fiyat'></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='58083.Net'><cf_get_lang dictionary_id='56994.Döviz Fiyat'></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='57677.Döviz'></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='58456.Oran'>&nbsp;</th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='29420.Amortisman Yöntemi'></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='56909.Son Değer'></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='56966.Gelir/Gider'><cf_get_lang dictionary_id='56964.Farkı'></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='39939.İstisna'></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='58460.Masraf Merkezi'></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='58234.Bütçe Kalemi'></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='56966.Gelir/Gider'><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='56963.Amortisman'><cf_get_lang dictionary_id='56962.Karşılık'><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='57452.Stok'></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='56990.Stok Birimi'></th>
					</tr>
				</thead>
				<tbody>
					<cfset gross_toplam = 0>
					<cfset doviz_topla=0>
					<cfoutput query="get_rows">
						<cfset gross_toplam = gross_toplam + NETTOTAL>
						<tr id="frm_row#currentrow#">
							<td><input  type="hidden" value="1" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#"><a href="javascript://" onclick="sil('#currentrow#');"><img  src="images/delete_list.gif" border="0"></a></td>
							<td>
								<input type="hidden" name="wrk_row_id#currentrow#" id="wrk_row_id#currentrow#" value="#wrk_row_id#">
								<input type="hidden" name="wrk_row_relation_id#currentrow#" id="wrk_row_relation_id#currentrow#" value="">
								<input type="hidden" class="boxtext" name="invent_id#currentrow#" id="invent_id#currentrow#" value="#INVENTORY_ID#">
								<input type="text" class="boxtext" name="invent_no#currentrow#" id="invent_no#currentrow#" style="width:30px;" value="#INVENTORY_NUMBER#" title="#INVENTORY_NAME#" maxlength="50" readonly>
							</td>
							<cfset INVENTORY_NAME_ = INVENTORY_NAME>
							<cfif INVENTORY_NAME contains '"' or INVENTORY_NAME contains "'">
								<cfset INVENTORY_NAME_ = Replace(Replace(INVENTORY_NAME,'"','','all'),"'","",'all')>
							</cfif>
							<td><input type="text" class="boxtext" name="invent_name#currentrow#" id="invent_name#currentrow#" style="width:100px;" value="#INVENTORY_NAME_#" title="#INVENTORY_NAME_#" maxlength="100" readonly></td>
							<td><input type="text" name="quantity#currentrow#" id="quantity#currentrow#" style="width:100px;" class="box" value="#STOCK_OUT#" onblur="hesapla('#currentrow#');" onkeyup="return(FormatCurrency(this,event));" title="#INVENTORY_NAME#"></td>
							<td>
								<input type="text" name="row_total_#currentrow#" id="row_total_#currentrow#" value="#TLFormat(PRICE,session.ep.our_company_info.purchase_price_round_num)#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));" onblur="hesapla('#currentrow#');" style="width:100px;" class="box" title="#INVENTORY_NAME#">
							</td>
							<td>
								<input type="text" name="row_total2_#currentrow#" id="row_total2_#currentrow#" value="#TLFormat(PRICE_OTHER,session.ep.our_company_info.purchase_price_round_num)#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));" onblur="hesapla('#currentrow#',1);" style="width:100px;" class="box" title="#INVENTORY_NAME#">
							</td>
							<td>
								<select name="tax_rate#currentrow#" id="tax_rate#currentrow#" style="width:100px;" onchange="hesapla('#currentrow#');" class="box">
									<cfset deger_tax = TAX>
									<cfloop query="get_tax">
										<option value="#tax#" <cfif deger_tax eq TAX>selected</cfif>>#tax#</option>
									</cfloop>
								</select>
							</td>
							<td>
								<select name="otv_rate#currentrow#" id="otv_rate#currentrow#" style="width:100px;" onchange="hesapla('#currentrow#');" class="box">
									<cfset deger_otv = OTV_ORAN>
									<cfloop query="get_otv">
										<option value="#tax#" <cfif deger_otv eq TAX>selected</cfif>>#tax#</option>
									</cfloop>
								</select>
							</td>
							<td><input type="text" name="kdv_total#currentrow#" id="kdv_total#currentrow#" value="#TLFormat(TAXTOTAL,session.ep.our_company_info.purchase_price_round_num)#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));" style="width:60px;" onblur="hesapla('#currentrow#',1);" class="box" title="#INVENTORY_NAME#"></td>
							<td><input type="text" name="otv_total#currentrow#" id="otv_total#currentrow#" value="#TLFormat(OTVTOTAL,session.ep.our_company_info.purchase_price_round_num)#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));" style="width:60px;" onblur="hesapla('#currentrow#',1);" class="box" title="#INVENTORY_NAME#"></td>
							<td><input type="text" name="net_total#currentrow#" id="net_total#currentrow#" value="#TLFormat(GROSSTOTAL,session.ep.our_company_info.purchase_price_round_num)#" class="box" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));" onblur="hesapla('#currentrow#',3);"></td>
							<td><input type="text" name="row_other_total#currentrow#" id="row_other_total#currentrow#" value="#TLFormat(OTHER_MONEY_GROSS_TOTAL,session.ep.our_company_info.purchase_price_round_num)#" style="width:100px;" class="box" title="#INVENTORY_NAME#" onblur="hesapla('#currentrow#',4);"></td>
							<td>
								<select name="money_id#currentrow#" id="money_id#currentrow#" style="width:100px;" class="boxtext" onchange="hesapla('#currentrow#',1);">
									<cfset deger_money = OTHER_MONEY>
									<cfloop query="get_money">
									<option value="#money#,#rate1#,#rate2#" <cfif deger_money eq money>selected</cfif>>#money#</option>
									</cfloop>
								</select>
							</td>
							<td><input type="text"  class="box" readonly="yes"  name="amortization_rate#currentrow#" id="amortization_rate#currentrow#" style="width:100px;" value="#TLFormat(AMORTIZATON_ESTIMATE)#" onkeyup="return(FormatCurrency(this,event));" title="#INVENTORY_NAME#"></td>
							<cfif AMORTIZATON_METHOD eq 0>
								<cfsavecontent variable="method"><cf_get_lang dictionary_id='29421.Azalan Bakiye Üzerinden'></cfsavecontent>
							<cfelseif AMORTIZATON_METHOD eq 1>
								<cfsavecontent variable="method"><cf_get_lang dictionary_id='29422.Sabit Miktar Üzeriden'></cfsavecontent>
							</cfif>
							<td><input type="text" name="amortization_method#currentrow#" id="amortization_method#currentrow#" style="width:165px;" class="box" value="#method#" title="#INVENTORY_NAME#" readonly></td>
							<td nowrap="nowrap">
								<input type="hidden" name="account_id#currentrow#" id="account_id#currentrow#" value="#account_id#">
								<input type="text" name="account_code#currentrow#" id="account_code#currentrow#" class="boxtext" value="#ACCOUNT_ID#" title="#INVENTORY_NAME#" readonly="readonly">
								<a href="javascript://" onclick="pencere_ac_acc('#currentrow#');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
							</td>
							<td>
								<input type="hidden" name="unit_first_value#currentrow#" id="unit_first_value#currentrow#" value="#Tlformat(amount,8)#">
								<input type="hidden" name="total_first_value#currentrow#" id="total_first_value#currentrow#" value="#Tlformat(amount*stock_out)#">
								<input type="hidden" name="unit_last_value#currentrow#" id="unit_last_value#currentrow#" value="#Tlformat(last_inventory_value)#">
								<input type="text" name="last_inventory_value#currentrow#" id="last_inventory_value#currentrow#" value="#Tlformat(last_inventory_value*stock_out)#" style="width:100px;" class="box" readonly="yes">
							</td>
							<td>
								<input type="text" name="last_diff_value#currentrow#" id="last_diff_value#currentrow#" value="#Tlformat(nettotal - last_inventory_value*stock_out)#" style="width:100px;" class="box" readonly="yes">
							</td>
							<td nowrap="nowrap">
								<select name="reason_code#currentrow#" id="reason_code#currentrow#" style="width:175px;" class="boxtext">
									<option value=""><cf_get_lang dictionary_id='39939.İstisna'></option>
									<cfset reason_code_info_ = '#reason_code#--#reason_name#'>
									<cfloop list="#reason_code_list#" index="info_list" delimiters="*">
										<option value='#listfirst(info_list,'*')#' <cfif listfirst(info_list,'*') is reason_code_info_>selected</cfif>>#listlast(info_list,'*')#</option>
									</cfloop>
								</select>
							</td>
							<td nowrap="nowrap">
								<input type="hidden" name="expense_center_id#currentrow#" id="expense_center_id#currentrow#" value="#SALE_EXPENSE_CENTER_ID#" >
								<input type="text" name="expense_center_name#currentrow#" id="expense_center_name#currentrow#" onfocus="exp_center(#currentrow#);" value="<cfif len(SALE_EXPENSE_CENTER_ID) and len(exp_center_id_list)>#get_expense_center.expense[listfind(exp_center_id_list,SALE_EXPENSE_CENTER_ID,',')]#</cfif>" style="width:150px;" class="boxtext"><a href="javascript://" onclick="pencere_ac_exp_center(#currentrow#);"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
							</td>
							<td nowrap="nowrap">
								<input type="hidden" name="budget_item_id#currentrow#" id="budget_item_id#currentrow#" value="#SALE_EXPENSE_ITEM_ID#">
								<input type="text" name="budget_item_name#currentrow#" id="budget_item_name#currentrow#" onfocus="exp_item(#currentrow#);" value="<cfif len(SALE_EXPENSE_ITEM_ID) and len(item_id_list)>#get_exp_detail.EXPENSE_ITEM_NAME[listfind(item_id_list,SALE_EXPENSE_ITEM_ID,',')]#</cfif>" style="width:115px;" class="boxtext" title="#INVENTORY_NAME#">
								<a href="javascript://" onclick="pencere_ac_exp('#currentrow#');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
							</td>
							<td nowrap="nowrap">
								<input type="hidden" name="budget_account_id#currentrow#" id="budget_account_id#currentrow#" value="<cfif len(SALE_DIFF_ACCOUNT_ID)>#SALE_DIFF_ACCOUNT_ID#</cfif>">
								<input type="text" name="budget_account_code#currentrow#" id="budget_account_code#currentrow#" class="boxtext" value="<cfif len(SALE_DIFF_ACCOUNT_ID)>#SALE_DIFF_ACCOUNT_ID#</cfif>" title="#INVENTORY_NAME#" style="width:155px;" onfocus="AutoComplete_Create('budget_account_code#currentrow#','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','0','ACCOUNT_CODE','budget_account_id#currentrow#','','3','225');">
								<a href="javascript://" onclick="pencere_ac_acc_1('#currentrow#');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
							</td>
							<td nowrap="nowrap">
								<input type="hidden" name="amort_account_id#currentrow#" id="amort_account_id#currentrow#" value="<cfif len(AMORT_DIFF_ACCOUNT_ID)>#AMORT_DIFF_ACCOUNT_ID#</cfif>">
								<input type="text" name="amort_account_code#currentrow#" id="amort_account_code#currentrow#" class="boxtext" value="<cfif len(AMORT_DIFF_ACCOUNT_ID)>#AMORT_DIFF_ACCOUNT_ID#</cfif>" title="#INVENTORY_NAME#" style="width:205px;" onfocus="AutoComplete_Create('amort_account_code#currentrow#','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','0','ACCOUNT_CODE','amort_account_id#currentrow#','','3','225');">
								<a href="javascript://" onclick="pencere_ac_acc_2('#currentrow#');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
							</td>
							<td nowrap="nowrap">
								<input type="hidden" name="product_id#currentrow#" id="product_id#currentrow#" value="#PRODUCT_ID#">
								<input type="hidden" name="stock_id#currentrow#" id="stock_id#currentrow#" value="#STOCK_ID#">
								<input type="text" name="product_name#currentrow#" id="product_name#currentrow#" class="boxtext" value="#NAME_PRODUCT#" title="#INVENTORY_NAME#" onfocus="AutoComplete_Create('product_name#currentrow#','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','PRODUCT_ID,STOCK_ID,MAIN_UNIT,PRODUCT_UNIT_ID','product_id#currentrow#,stock_id#currentrow#,stock_unit#currentrow#,stock_unit_id#currentrow#','upd_invent',1,'','');">
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_product_names&product_id=upd_invent.product_id#currentrow#&field_id=upd_invent.stock_id#currentrow#&field_unit_name=upd_invent.stock_unit#currentrow#&field_main_unit=upd_invent.stock_unit_id#currentrow#&field_name=upd_invent.product_name#currentrow#','list');"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>								
							</td>
							<td nowrap="nowrap">
								<input type="hidden" name="stock_unit_id#currentrow#" id="stock_unit_id#currentrow#" value="#UNIT_ID#">
								<input type="text" name="stock_unit#currentrow#" id="stock_unit#currentrow#" width="100px" class="boxtext" value="#UNIT#" title="#INVENTORY_NAME#">
							</td>
						</tr>
					</cfoutput>
				</tbody>
			</cf_grid_list>
				<cfif len(GET_SALE_MONEY.RATE2)>
					<cfset doviz_topla=gross_toplam/GET_SALE_MONEY.RATE2>
				</cfif>
				<cf_basket_footer height="95">
					<div class="ui-row">
						<div id="sepetim_total">
							<div class="col col-2 col-md-3 col-sm-6 col-xs-12">
								<div class="totalBox">
									<div class="totalBoxHead font-grey-mint">
										<span class="headText"> <cf_get_lang dictionary_id='57677.Döviz'> </span>
										<div class="collapse">
											<span class="icon-minus"></span>
										</div>
									</div>
									<div class="totalBoxBody">
										<table>
											<input type="hidden" name="kur_say" id="kur_say" value="<cfoutput>#GET_INVOICE_MONEY.recordcount#</cfoutput>">
											<cfoutput>
												<cfloop query="GET_INVOICE_MONEY">
													<tr>
														<td>
															<input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money#">
															<input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
															<input type="radio" name="rd_money" id="rd_money" value="#money#,#currentrow#,#rate1#,#rate2#" onclick="toplam_hesapla();" <cfif get_invoice.other_money eq money>checked</cfif>>#money#
															<cfif session.ep.rate_valid eq 1>
																<cfset readonly_info = "yes">
															<cfelse>
																<cfset readonly_info = "no">
															</cfif>
														</td>
														<td valign="bottom">#TLFormat(rate1,0)#/<input type="text"  <cfif readonly_info>readonly</cfif> class="box" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" value="#TLFormat(rate2,session.ep.our_company_info.rate_round_num)#" <cfif money eq session.ep.money>readonly="yes"</cfif> style="width:50px;" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onblur="toplam_hesapla();"></td>
													</tr>
												</cfloop>
											</cfoutput>
										</table>                    
									</div>
								</div>
							</div>
							<div class="col col-4 col-md-5 col-sm-6 col-xs-12">
								<div class="totalBox">
									<div class="totalBoxHead font-grey-mint">
										<span class="headText"> <cf_get_lang dictionary_id='57492.Toplam'> </span>
										<div class="collapse">
											<span class="icon-minus"></span>
										</div>
									</div>
									<div class="totalBoxBody">
										<table>
											<tr>
												<td height="20" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57643.KDV Toplam'></td>
												<td  width="100" style="text-align:right;">
													<input type="text" name="kdv_total_amount" id="kdv_total_amount" class="box" value="<cfoutput>#TLFormat(get_invoice.TAXTOTAL,session.ep.our_company_info.purchase_price_round_num)#</cfoutput>"  readonly>
												</td>
												<td><cfoutput>#session.ep.money#</cfoutput></td>
											</tr>
											<tr>
												<td class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id ='58021.OTV'><cf_get_lang dictionary_id='57492.Toplam'></td>
												<td style="text-align:right;"><input type="text" name="otv_total_amount" id="otv_total_amount" class="box" value="<cfoutput>#TLFormat(get_invoice.OTV_TOTAL,session.ep.our_company_info.purchase_price_round_num)#</cfoutput>" readonly></td><td><cfoutput>#session.ep.money#</cfoutput></td>
											</tr>
											<tr>
												<td class="txtbold" style="text-align:right;">
													<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_stoppage_rates&field_stoppage_rate=upd_invent.stopaj_yuzde&field_stoppage_rate_id=upd_invent.stopaj_rate_id&field_decimal=#session.ep.our_company_info.purchase_price_round_num#&call_function=toplam_hesapla()</cfoutput>','list')"><img src="/images/plus_small.gif" title="Stopaj Oranları" border="0" align="absbottom"></a>
													<cf_get_lang dictionary_id='57711.Stopaj'>%
												</td>
												<input type="hidden" name="stopaj_rate_id" id="stopaj_rate_id" value="<cfoutput>#get_invoice.stopaj_rate_id#</cfoutput>">
												<td><input type="text" name="stopaj_yuzde" id="stopaj_yuzde" class="box" onblur="calc_stopaj();" onkeyup="return(FormatCurrency(this,event,0));" value="<cfoutput>#TLFormat(get_invoice.stopaj_oran,session.ep.our_company_info.purchase_price_round_num)#</cfoutput>" autocomplete="off"></td>
												
											</tr>
											<tr class="txtbold" style="text-align:right;">	
												<td></td>
												<td><input type="text" name="stopaj" id="stopaj" class="box" readonly="readonly" value="<cfoutput>#TLFormat(get_invoice.stopaj,session.ep.our_company_info.purchase_price_round_num)#</cfoutput>" onblur="toplam_hesapla(1);"></td>
											</tr>
											<tr>
											<td class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'></td>
											<td style="text-align:right;"><input type="text" name="total_amount" id="total_amount" class="box" readonly="" value="<cfoutput>#tlformat(get_invoice.GROSSTOTAL,session.ep.our_company_info.purchase_price_round_num)#</cfoutput>"></td><td><cfoutput>#session.ep.money#</cfoutput></td>
											</tr>
											<tr>
											<td class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57678.Fatura Altı İndirim'></td>
											<td style="text-align:right;"><input type="text" name="net_total_discount" id="net_total_discount" class="box" value="<cfif len(get_invoice.sa_discount)><cfoutput>#TLFormat(get_invoice.sa_discount,session.ep.our_company_info.purchase_price_round_num)#</cfoutput><cfelse>0</cfif>" onblur="toplam_hesapla();" onkeyup="return(FormatCurrency(this,event));"></td><td><cfoutput>#session.ep.money#</cfoutput></td>
											</tr>
											<tr>
											<td class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='56975.KDV li Toplam'></td>
											<td style="text-align:right;"><input type="text" name="net_total_amount" id="net_total_amount" class="box" readonly="" value="<cfoutput>#tlformat(get_invoice.nettotal,session.ep.our_company_info.purchase_price_round_num)#</cfoutput>"></td><td><cfoutput>#session.ep.money#</cfoutput></td>
											</tr>
										</table>
									</div>
								</div>
                    		</div>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
								<div class="totalBox">
									<div class="totalBoxHead font-grey-mint">
										<span class="headText"><cf_get_lang dictionary_id='58124.Döviz Toplam'> </span>
										<div class="collapse">
											<span class="icon-minus"></span>
										</div>
									</div>
									<div class="totalBoxBody" id="totalAmountList"> 
										<table>
											<tr>
												<td class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='56961.Döviz KDV Toplam'></td>
												<td style="text-align:right;">
													<input type="text" name="other_kdv_total_amount" id="other_kdv_total_amount" class="box" readonly value="<cfoutput>#TLFormat(get_invoice.taxtotal/get_sale_money.rate2,session.ep.our_company_info.purchase_price_round_num)#</cfoutput>">
												</td>
												<td>
													<input type="text" name="tl_value2" id="tl_value2" class="box" readonly="" value="<cfoutput>#get_invoice.other_money#</cfoutput>" style="width:40px;">
												</td>
											</tr>
											<tr>
												<td class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57796.Dövizli'><cf_get_lang dictionary_id ='58021.OTV'><cf_get_lang dictionary_id='57492.Toplam'></td>
												<td style="text-align:right;"><input type="text" name="other_otv_total_amount" id="other_otv_total_amount" class="box" readonly value="<cfoutput>#TLFormat(get_invoice.OTV_TOTAL/get_sale_money.rate2,session.ep.our_company_info.purchase_price_round_num)#</cfoutput>"></td><td><input type="text" name="tl_value5" id="tl_value5" class="box" readonly="" value="<cfoutput>#get_invoice.other_money#</cfoutput>" style="width:40px;"></td>
											</tr>
											<tr>
												<td class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='58124.Döviz Toplam'></td>
												<td id="rate_value1" style="text-align:right;"><input type="text" name="other_total_amount" id="other_total_amount" class="box" readonly="" value="<cfoutput>#TLFormat(doviz_topla,session.ep.our_company_info.purchase_price_round_num)#</cfoutput>"></td><td>
												<input type="text" name="tl_value1" id="tl_value1" class="box" readonly="" value="<cfoutput>#get_invoice.other_money#</cfoutput>" style="width:40px;"></td>
											</tr>
											<tr>
												<td class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='56902.Fatura Altı İndirim Döviz'></td>
												<td style="text-align:right;"><input type="text" name="other_net_total_discount" id="other_net_total_discount" class="box" readonly value="<cfoutput>#TLFormat(get_invoice.sa_discount/get_sale_money.rate2,session.ep.our_company_info.purchase_price_round_num)#</cfoutput>"></td><td>
												<input type="text" name="tl_value4" id="tl_value4" class="box" readonly="" value="<cfoutput>#get_invoice.other_money#</cfoutput>" style="width:40px;"></td>
											</tr>
											<tr>
												<td class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='56993.Döviz KDV li Toplam'></td>
												<td id="rate_value3" style="text-align:right;"><input type="text" name="other_net_total_amount" id="other_net_total_amount" class="box" readonly="" value="<cfoutput>#tlformat(get_invoice.other_money_value,session.ep.our_company_info.purchase_price_round_num)#</cfoutput>"></td><td>
												<input type="text" name="tl_value3" id="tl_value3" class="box" readonly="" value="<cfoutput>#get_invoice.other_money#</cfoutput>" style="width:40px;"></td>
											</tr>
										</table>
									</div>
								</div>
                    		</div>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
								<div class="totalBox">
									<table>
										<tr>
											<td>
												<input type="checkbox" name="tevkifat_box" id="tevkifat_box" onclick="gizle_goster(tevkifat_oran);gizle_goster(tevkifat_plus);gizle_goster(tevk_1);gizle_goster(tevk_2);gizle_goster(beyan_1);gizle_goster(beyan_2);toplam_hesapla();" <cfif get_invoice.tevkifat eq 1>checked</cfif>>
												<b><cf_get_lang dictionary_id='58022.Tevkifat'></b>
												<input type="hidden" id="tevkifat_id" name="tevkifat_id" value="<cfoutput>#get_invoice.tevkifat_id#</cfoutput>">
												<input type="text" name="tevkifat_oran" id="tevkifat_oran" value="<cfoutput>#TLFormat(get_invoice.tevkifat_oran)#</cfoutput>" readonly <cfif get_invoice.tevkifat neq 1>style="display:none;width:35px;"<cfelse>style="width:35px;"</cfif> onblur="toplam_hesapla();">
												<a <cfif get_invoice.tevkifat neq 1>style="display:none;cursor:pointer"</cfif> id="tevkifat_plus" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_tevkifat_rates&field_tevkifat_rate=upd_invent.tevkifat_oran&field_tevkifat_rate_id=upd_invent.tevkifat_id&call_function=toplam_hesapla()</cfoutput>','small')"> <img src="images/plus_thin.gif" border="0" alt="<cf_get_lang dictionary_id='58022.Tevkifat'>" align="absmiddle"></a>
											</td>
									</tr>
									<tr>
											<td id="tevk_1" <cfif get_invoice.tevkifat neq 1>style="display:none"</cfif>><b><cf_get_lang dictionary_id='58022.Tevkifat'> :</b></td>
											<td id="tevk_2" <cfif get_invoice.tevkifat neq 1>style="display:none"</cfif> nowrap="nowrap"><div id="tevkifat_text"></div></td>
									</tr>
									<tr>
											<td id="beyan_1" <cfif get_invoice.tevkifat neq 1>style="display:none"</cfif>><b><cf_get_lang dictionary_id='58024.Beyan Edilen'> :</b></td>
											<td id="beyan_2" <cfif get_invoice.tevkifat neq 1>style="display:none"</cfif> nowrap="nowrap"><div id="beyan_text"></div></td>
										</tr>
									</table>
								</div>
							</div>
                		</div>
					</div>
				</cf_basket_footer>
	</cf_basket>
	</cfform>
	</cf_box>
</div>
	<script type="text/javascript">
		<cfif get_invoice.tevkifat eq 1>//tevkifat hesapları için sayfa yüklenrken çağrılıyor
			toplam_hesapla();
		</cfif>
		function add_adress()
		{
			if(!(document.getElementById('company_id').value=="") || !(document.getElementById('consumer_id').value=="") || !(document.getElementById('employee_id').value==""))
			{
				if(document.getElementById('company_id').value!="")
				{
					str_adrlink = '&field_long_adres=upd_invent.adres&field_adress_id=upd_invent.ship_address_id&is_compname_readonly=1';
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(upd_invent.comp_name.value)+''+ str_adrlink , 'list');
					return true;
				}
				else
				{
					str_adrlink = '&field_long_adres=upd_invent.adres&field_adress_id=upd_invent.ship_address_id&is_compname_readonly=1';
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&keyword='+encodeURIComponent(upd_invent.partner_name.value)+''+ str_adrlink , 'list');
					return true;
				}
			}
			else
			{
				alert("<cf_get_lang dictionary_id='57183.Cari Hesap Seçmelisiniz'>");
				return false;
			}
		}
		function kontrol()
		{
			<cfif session.ep.our_company_info.is_efatura>
				var chk_efatura = wrk_safe_query("chk_efatura_count",'dsn2',0,'<cfoutput>#attributes.invoice_id#</cfoutput>');
				if(chk_efatura.recordcount > 0)
				{
				<cfif xml_upd_einvoice eq 0>
					alert("<cf_get_lang dictionary_id='57098.e-Faturası Oluşturulmuş Faturayı Güncelleyemezsiniz!'>");
					return false;
				<cfelse>		
					if(confirm("<cf_get_lang dictionary_id='57100.e-Faturası Oluşturulmuş Faturayı Güncellemek İstiyor musunuz!'>") == true);
					else
					return false;
				</cfif>
				}
			</cfif>	
			if (!chk_process_cat('upd_invent')) return false;
			if(!chk_period(upd_invent.invoice_date,"İşlem")) return false;
			if(!paper_control(document.upd_invent.serial_no,'INVOICE',true,<cfoutput>'#attributes.invoice_id#','#get_invoice.serial_no#'</cfoutput>,'','','','','',upd_invent.serial_number)) return false;
			if(!check_display_files('upd_invent')) return false;
			if(upd_invent.department_id.value=="")
			{
				alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='58763.Depo'>");
				return false;
			}
			 <cfif session.ep.our_company_info.IS_EFATURA eq 1 ><!--- MCP tarafından #75351 numaralı iş için eklendi.e-Fatura kullanıyorsa gösterilecek --->
		 	var get_efatura_info = wrk_query("SELECT USE_EFATURA FROM COMPANY WHERE COMPANY_ID = "+document.getElementById('company_id').value,"dsn");	
				if(get_efatura_info.USE_EFATURA == 1)															   
				{
					if(document.getElementById('ship_address_id').value =='' || document.getElementById('adres').value =='')
					{
						alert("<cf_get_lang dictionary_id='57343.Sevk Adresi Girmelisiniz'>!");
						return false;
					}
				}
			</cfif>
			<cfif xml_is_department eq 2>
				if( document.upd_invent.acc_department_id.options[document.upd_invent.acc_department_id.selectedIndex].value=="")
				{
					alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='57572.Departman'>");
					return false;
				} 
			</cfif>
			if(document.upd_invent.comp_name.value == ""  && document.upd_invent.consumer_id.value == "" && document.upd_invent.emp_id.value == "")
			{ 
				alert ("<cf_get_lang dictionary_id='56901.Cari Hesap Seçmelisiniz'>!");
				return false;
			}
			//Odeme Plani Guncelleme Kontrolleri
			if (document.upd_invent.invoice_cari_action_type.value == 5 && document.upd_invent.paymethod_id.value != "")
			{
				if (confirm("<cf_get_lang dictionary_id='29460.Güncellediğiniz Belgenin Ödeme Planı Yeniden Oluşturulacaktır'> !"))
					document.upd_invent.invoice_payment_plan.value = 1;
				else
					document.upd_invent.invoice_payment_plan.value = 0;
					<cfif xml_control_payment_plan_status eq 1>
						return false;
					</cfif>
			}
			record_exist=0;
			for(r=1;r<=upd_invent.record_num.value;r++)
			{
				if(eval("document.upd_invent.row_kontrol"+r).value == 1)
				{
					record_exist=1;
					if (eval("document.upd_invent.invent_no"+r).value == "")
					{ 
						alert ("<cf_get_lang dictionary_id='56981.Lütfen Demirbaş No Giriniz'>!");
						return false;
					}
					if (eval("document.upd_invent.invent_name"+r).value == "")
					{ 
						alert ("<cf_get_lang dictionary_id='56660.Lütfen Açıklama Giriniz'>  !");
						return false;
					}
					if ((eval("document.upd_invent.row_total_"+r).value == ""))
					{ 
						alert ("<cf_get_lang dictionary_id='29535.Lütfen Tutar Giriniz '>!");
						return false;
					}
					if (eval("document.upd_invent.account_code"+r).value == "")
					{ 
						alert ("<cf_get_lang dictionary_id='56989.Lütfen Muhasebe Kodu Seçiniz'>");
						return false;
					}
					if (eval("document.upd_invent.last_diff_value"+r).value != 0 && filterNum(eval("document.upd_invent.last_diff_value"+r).value) > 0 && eval("document.upd_invent.budget_account_code"+r).value == "")
					{ 
						alert ("<cf_get_lang dictionary_id='56958.Lütfen Gelir/Gider Farkı İçin Muhasebe Kodu Seçiniz'>!");
						return false;
					}
					if (eval("document.upd_invent.last_diff_value"+r).value != 0 && filterNum(eval("document.upd_invent.last_diff_value"+r).value) > 0 && eval("document.upd_invent.amort_account_code"+r).value == "")
					{ 
						alert ("<cf_get_lang dictionary_id='56957.Lütfen Amortisman Karşılık Muhasebe Kodu Seçiniz'>!");
						return false;
					}
					var listParam = eval("document.upd_invent.invent_id"+r).value;
					var get_invent_amortization = wrk_safe_query("get_inventory_amort_number","dsn3",0,listParam);
					if(get_invent_amortization.recordcount)
					{
						if(datediff(date_format(get_invent_amortization.ACTION_DATE,dateformat_style),document.upd_invent.invoice_date.value,0) <= 0)
						{
							alert("<cf_get_lang dictionary_id='59788.Değerlemesi Yapılan Demirbaş Bulunmaktadır'>! <cf_get_lang dictionary_id='58508.Satır'>: "+r);
							return false;
						}
					}
				}
			}
			if (record_exist == 0) 
				{
					alert("<cf_get_lang dictionary_id='56983.Lütfen Demirbaş Giriniz'>!");
					return false;
				}
			change_paper_duedate('invoice_date');
			return unformat_fields();
		}
		function unformat_fields()
		{
			for(r=1;r<=upd_invent.record_num.value;r++)
			{
				deger_total = eval("document.upd_invent.row_total_"+r);
				deger_total2 = eval("document.upd_invent.row_total2_"+r);
				deger_kdv_total= eval("document.upd_invent.kdv_total"+r);
				deger_otv_total= document.getElementById("otv_total"+r);
				deger_net_total = eval("document.upd_invent.net_total"+r);
				deger_other_net_total = eval("document.upd_invent.row_other_total"+r);
				deger_amortization_rate = eval("document.upd_invent.amortization_rate"+r);
				deger_unit_last= eval("document.upd_invent.unit_last_value"+r);
				total_deger_unit_last= eval("document.upd_invent.last_inventory_value"+r);
				deger_last_value= eval("document.upd_invent.last_diff_value"+r);
				deger_unit_first= eval("document.upd_invent.unit_first_value"+r);
				total_deger_unit_first= eval("document.upd_invent.total_first_value"+r);
				
				deger_total.value = filterNum(deger_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_total2.value = filterNum(deger_total2.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_kdv_total.value = filterNum(deger_kdv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_otv_total.value = filterNum(deger_otv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_net_total.value = filterNum(deger_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_other_net_total.value = filterNum(deger_other_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_amortization_rate.value = filterNum(deger_amortization_rate.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_unit_last.value = filterNum(deger_unit_last.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_last_value.value = filterNum(deger_last_value.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				total_deger_unit_last.value = filterNum(total_deger_unit_last.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_unit_first.value = filterNum(deger_unit_first.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				total_deger_unit_first.value = filterNum(total_deger_unit_first.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			}
			document.upd_invent.total_amount.value = filterNum(document.upd_invent.total_amount.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			document.upd_invent.kdv_total_amount.value = filterNum(document.upd_invent.kdv_total_amount.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>); 
			document.getElementById("otv_total_amount").value = filterNum(document.getElementById("otv_total_amount").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>); 
			document.upd_invent.net_total_amount.value = filterNum(document.upd_invent.net_total_amount.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			document.upd_invent.other_total_amount.value = filterNum(document.upd_invent.other_total_amount.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			document.upd_invent.other_kdv_total_amount.value = filterNum(document.upd_invent.other_kdv_total_amount.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>); 
			document.getElementById("other_otv_total_amount").value = filterNum(document.getElementById("other_otv_total_amount").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>); 
			document.upd_invent.other_net_total_amount.value = filterNum(document.upd_invent.other_net_total_amount.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			document.upd_invent.net_total_discount.value = filterNum(document.upd_invent.net_total_discount.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			document.upd_invent.tevkifat_oran.value = filterNum(document.upd_invent.tevkifat_oran.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			document.getElementById("stopaj_yuzde").value = filterNum(document.getElementById("stopaj_yuzde").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			document.getElementById("stopaj").value = filterNum(document.getElementById("stopaj").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			for(s=1;s<=upd_invent.kur_say.value;s++)
			{
				eval('upd_invent.txt_rate2_' + s).value = filterNum(eval('upd_invent.txt_rate2_' + s).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				eval('upd_invent.txt_rate1_' + s).value = filterNum(eval('upd_invent.txt_rate1_' + s).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			}
		}
		row_count=<cfoutput>#get_rows.recordcount#</cfoutput>;
		satir_say=<cfoutput>#get_rows.recordcount#</cfoutput>;
		function sil(sy)
		{
			var my_element=eval("upd_invent.row_kontrol"+sy);
			my_element.value=0;
			var my_element=eval("frm_row"+sy);
			my_element.style.display="none";
			toplam_hesapla();
			satir_say--;
		}
		function hesapla(satir,hesap_type)
		{
			var toplam_dongu_0 = 0;//satir toplam
			if(eval("document.upd_invent.row_kontrol"+satir).value==1)
			{
				deger_total = eval("document.upd_invent.row_total_"+satir);//tutar
				deger_total2 = eval("document.upd_invent.row_total2_"+satir);//dövizli tutar
				deger_miktar = eval("document.upd_invent.quantity"+satir);//miktar
				deger_kdv_total= eval("document.upd_invent.kdv_total"+satir);//kdv tutarı
				deger_otv_total= document.getElementById("otv_total"+satir);//otv tutarı
				deger_net_total = eval("document.upd_invent.net_total"+satir);//kdvli tutar
				deger_tax_rate = eval("document.upd_invent.tax_rate"+satir);//kdv oranı
				deger_otv_rate = document.getElementById("otv_rate"+satir);//otv oranı
				deger_other_net_total = eval("document.upd_invent.row_other_total"+satir);//dovizli tutar kdv dahil
				deger_first_value = eval("document.upd_invent.total_first_value"+satir);//İlk değer
				deger_first_unit_value = eval("document.upd_invent.unit_first_value"+satir);//İlk değer birim
				deger_last_value = eval("document.upd_invent.last_inventory_value"+satir);//Son değer
				deger_last_unit_value = eval("document.upd_invent.unit_last_value"+satir);//Son değer birim
				deger_diff_value = eval("document.upd_invent.last_diff_value"+satir);//Fark
				if(deger_total.value == "") deger_total.value = 0;
				if(deger_total2.value == "") deger_total2.value = 0;
				if(deger_kdv_total.value == "") deger_kdv_total.value = 0;
				if(deger_net_total.value == "") deger_net_total.value = 0;
				deger_money_id = eval("document.upd_invent.money_id"+satir);
				deger_money_id_ilk = list_getat(deger_money_id.value,2,',');
				deger_money_id_son = list_getat(deger_money_id.value,3,',');
				deger_total.value = filterNum(deger_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_total2.value = filterNum(deger_total2.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_kdv_total.value = filterNum(deger_kdv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_otv_total.value = filterNum(deger_otv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_net_total.value = filterNum(deger_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_other_net_total.value = filterNum(deger_other_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_miktar.value = filterNum(deger_miktar.value,0);
				deger_last_value.value = filterNum(deger_last_value.value);
				deger_last_unit_value.value = filterNum(deger_last_unit_value.value);
				deger_first_value.value = filterNum(deger_first_value.value);
				deger_first_unit_value.value = filterNum(deger_first_unit_value.value,8);
				deger_diff_value.value = filterNum(deger_diff_value.value);
				
				for(s=1;s<=upd_invent.kur_say.value;s++)
				{
					if(list_getat(document.upd_invent.rd_money[s-1].value,1,',') == list_getat(deger_money_id.value,1,','))
					{
						satir_rate2 = filterNum(document.getElementById("txt_rate2_"+s).value,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>);
						satir_rate1 = filterNum(document.getElementById("txt_rate1_"+s).value,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>);
					}
				}
				
				if(hesap_type == undefined)
				{
					deger_total2.value = parseFloat(deger_total.value)*(parseFloat(satir_rate1)/parseFloat(satir_rate2));
					deger_otv_total.value = (parseFloat(deger_total.value) * deger_miktar.value * deger_otv_rate.value)/100;
					<cfif isdefined('x_kdv_add_to_otv') and x_kdv_add_to_otv eq 0>  
						deger_kdv_total.value = ((parseFloat(deger_total.value) * parseFloat(deger_miktar.value)) * deger_tax_rate.value)/100;
					<cfelse>
						deger_kdv_total.value = ((parseFloat(deger_total.value* deger_miktar.value)+parseFloat(deger_otv_total.value)) * deger_tax_rate.value)/100;
					</cfif>
				}
				else if(hesap_type == 1)
				{
					deger_total.value = parseFloat(deger_total2.value)*(parseFloat(satir_rate2)/parseFloat(satir_rate1));
					deger_otv_total.value = (parseFloat(deger_total.value) * deger_miktar.value * deger_otv_rate.value)/100;
					<cfif isdefined('x_kdv_add_to_otv') and x_kdv_add_to_otv eq 0>  
						deger_kdv_total.value = ((parseFloat(deger_total.value) * parseFloat(deger_miktar.value)) * deger_tax_rate.value)/100;
					<cfelse>
						deger_kdv_total.value = ((parseFloat(deger_total.value* deger_miktar.value)+parseFloat(deger_otv_total.value)) * deger_tax_rate.value)/100;
					</cfif>
				}
				else if(hesap_type == 2)
				{
					<cfif isdefined('x_kdv_add_to_otv') and x_kdv_add_to_otv eq 0>  
						deger_total.value = ((parseFloat(deger_net_total.value)/parseFloat(deger_miktar.value))*100)/ (parseFloat(deger_tax_rate.value)+parseFloat(otv_rate_)+100);
						deger_kdv_total.value = (parseFloat(deger_total.value * deger_miktar.value * deger_tax_rate.value))/100;
						deger_otv_total.value = (parseFloat(deger_total.value * deger_miktar.value * deger_otv_rate.value))/100;
					<cfelse>
						deger_total.value = ((parseFloat(deger_net_total.value)*100)/ (parseFloat(deger_tax_rate.value)+100))/deger_miktar.value;
						deger_otv_total.value = (parseFloat(deger_total.value * deger_miktar.value * deger_otv_rate.value))/100;
						deger_kdv_total.value = ((parseFloat(deger_total.value * deger_miktar.value)+parseFloat(deger_otv_total.value)) * deger_tax_rate.value)/100;
					</cfif>
						deger_total2.value = parseFloat(deger_total.value)*(parseFloat(satir_rate1)/parseFloat(satir_rate2));
				}
				else if(hesap_type == 3)
				{
					<cfif isdefined('x_kdv_add_to_otv') and x_kdv_add_to_otv eq 0>
						deger_kdv_total.value = (parseFloat(deger_net_total.value * deger_tax_rate.value))/(100 + parseFloat(deger_tax_rate.value)+ parseFloat(deger_otv_rate.value));
						deger_otv_total.value = (parseFloat(deger_net_total.value * deger_otv_rate.value))/(100 + parseFloat(deger_tax_rate.value)+ parseFloat(deger_otv_rate.value));
					<cfelse>
						deger_kdv_total.value = (parseFloat(deger_net_total.value * deger_tax_rate.value))/(100 + parseFloat(deger_tax_rate.value));
						deger_otv_total.value = (parseFloat((deger_net_total.value - deger_kdv_total.value) * deger_otv_rate.value))/(100 + parseFloat(deger_otv_rate.value));
					</cfif>
						deger_total.value = parseFloat(deger_net_total.value - deger_kdv_total.value);
						deger_total.value = parseFloat(deger_total.value - deger_otv_total.value);
						deger_total.value = (deger_total.value/deger_miktar.value);
						deger_total2.value = parseFloat(deger_total.value)*(parseFloat(satir_rate1)/parseFloat(satir_rate2));
				}
				else if(hesap_type == 4)
				{
					for(s=1;s<=upd_invent.kur_say.value;s++)
					{
						if(list_getat(document.upd_invent.rd_money[s-1].value,1,',') == list_getat(deger_money_id.value,1,','))
						{
							satir_rate2 = filterNum(document.getElementById("txt_rate2_"+s).value);
							satir_rate1 = document.getElementById("txt_rate1_"+s).value;
						}
					}
					deger_net_total.value = parseFloat(deger_other_net_total.value) * (parseFloat(satir_rate2)/parseFloat(satir_rate1));
					
					<cfif isdefined('x_kdv_add_to_otv') and x_kdv_add_to_otv eq 0>
						deger_kdv_total.value = (parseFloat(deger_net_total.value * deger_tax_rate.value))/(100 + parseFloat(deger_tax_rate.value)+ parseFloat(deger_otv_rate.value));
						deger_otv_total.value = (parseFloat(deger_net_total.value * deger_otv_rate.value))/(100 + parseFloat(deger_tax_rate.value)+ parseFloat(deger_otv_rate.value));
					<cfelse>
						deger_kdv_total.value = (parseFloat(deger_net_total.value * deger_tax_rate.value))/(100 + parseFloat(deger_tax_rate.value));
						deger_otv_total.value = (parseFloat((deger_net_total.value - deger_kdv_total.value) * deger_otv_rate.value))/(100 + parseFloat(deger_otv_rate.value));
					</cfif>
						deger_total.value = parseFloat(deger_net_total.value - deger_kdv_total.value);
						deger_total.value = parseFloat(deger_total.value - deger_otv_total.value);
						deger_total.value = (deger_total.value/deger_miktar.value);
						deger_total2.value = parseFloat(deger_total.value)*(parseFloat(satir_rate1)/parseFloat(satir_rate2));
				}
				toplam_dongu_0 = (parseFloat(deger_total.value)*deger_miktar.value) + parseFloat(deger_kdv_total.value) + parseFloat(deger_otv_total.value);
				deger_other_net_total.value = ((parseFloat(deger_total.value) + parseFloat(deger_kdv_total.value) + parseFloat(deger_otv_total.value)) * parseFloat(deger_money_id_ilk) / (parseFloat(deger_money_id_son)));
				deger_net_total.value = commaSplit(toplam_dongu_0,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_last_value.value =  parseFloat(deger_last_unit_value.value * deger_miktar.value);
				deger_first_value.value =  parseFloat(deger_first_unit_value.value * deger_miktar.value);
				deger_diff_value.value = parseFloat((deger_total.value * deger_miktar.value)  - deger_last_value.value);
				deger_diff_value.value = commaSplit(deger_diff_value.value);
				deger_last_value.value = commaSplit(deger_last_value.value);
				deger_last_unit_value.value = commaSplit(deger_last_unit_value.value);
				deger_first_value.value = commaSplit(deger_first_value.value);
				deger_first_unit_value.value = commaSplit(deger_first_unit_value.value,8);
				deger_total.value = commaSplit(deger_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_total2.value = commaSplit(deger_total2.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_kdv_total.value = commaSplit(deger_kdv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_otv_total.value = commaSplit(deger_otv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_other_net_total.value = commaSplit(deger_other_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			}
			toplam_hesapla();
		}
		var stopaj_yuzde_;
		function calc_stopaj()
		{
			stopaj_yuzde_ = filterNum(document.getElementById("stopaj_yuzde").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			if((stopaj_yuzde_ < 0) || (stopaj_yuzde_ > 99.99))
			{
				alert("<cf_get_lang dictionary_id='50036.Stopaj Oranı'>!");
				document.getElementById("stopaj_yuzde").value = 0;
			}
			toplam_hesapla(0);
		}
		function toplam_hesapla(type)
		{
			var toplam_dongu_1 = 0;//tutar genel toplam
			var toplam_dongu_2 = 0;// kdv genel toplam
			var toplam_dongu_3 = 0;// kdvli genel toplam
			var toplam_dongu_4 = 0;// kdvli genel toplam
			var toplam_dongu_5 = 0;// ötv genel toplam
			var beyan_tutar = 0;
			var tevkifat_info = "";
			var beyan_tutar_info = "";
			var new_taxArray = new Array(0);
			var taxBeyanArray = new Array(0);
			var taxTevkifatArray = new Array(0);
			for(r=1;r<=upd_invent.record_num.value;r++)
			{
				if(eval("document.upd_invent.row_kontrol"+r).value==1)
				{
					toplam_dongu_4 = toplam_dongu_4 + (parseFloat(filterNum(eval("document.upd_invent.row_total_"+r).value) * filterNum(eval("document.upd_invent.quantity"+r).value)));
				}
			}			
			genel_indirim_yuzdesi = commaSplit(parseFloat(filterNum(document.upd_invent.net_total_discount.value),8) / parseFloat(toplam_dongu_4),8);
			genel_indirim_yuzdesi = filterNum(genel_indirim_yuzdesi,8);
			genel_indirim_yuzdesi = wrk_round(genel_indirim_yuzdesi,2);
			deger_discount_value = document.upd_invent.net_total_discount.value;
			deger_discount_value = filterNum(deger_discount_value,4);
			for(r=1;r<=upd_invent.record_num.value;r++)
			{
				if(eval("document.upd_invent.row_kontrol"+r).value==1)
				{
					deger_total = eval("document.upd_invent.row_total_"+r);//tutar
					deger_total2 = eval("document.upd_invent.row_total2_"+r);//dövizli tutar
					deger_miktar = eval("document.upd_invent.quantity"+r);//miktar
					deger_kdv_total= eval("document.upd_invent.kdv_total"+r);//kdv tutarı
					deger_otv_total= document.getElementById("otv_total"+r);//ötv tutarı
					deger_net_total = eval("document.upd_invent.net_total"+r);//kdvli tutar
					deger_tax_rate = eval("document.upd_invent.tax_rate"+r);//kdv oranı
					deger_other_net_total = eval("document.upd_invent.row_other_total"+r);//dovizli tutar kdv dahil
					deger_money_id = eval("document.upd_invent.money_id"+r);
					deger_money_id_ilk = list_getat(deger_money_id.value,1,',');
					for(s=1;s<=upd_invent.kur_say.value;s++)
						{
							if(list_getat(document.upd_invent.rd_money[s-1].value,1,',') == deger_money_id_ilk)
							{
								satir_rate2= eval("document.upd_invent.txt_rate2_"+s).value;
							}
						}
					deger_miktar.value = filterNum(deger_miktar.value,0);//miktar
					satir_rate2= filterNum(satir_rate2,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');			
					deger_total.value = filterNum(deger_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
					deger_total2.value = filterNum(deger_total2.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
					deger_kdv_total.value = filterNum(deger_kdv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
					deger_otv_total.value = filterNum(deger_otv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
					deger_net_total.value = filterNum(deger_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
					deger_other_net_total.value = filterNum(deger_other_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
					toplam_dongu_1 = toplam_dongu_1 + parseFloat(deger_total.value * deger_miktar.value);
	                deger_other_net_total.value = ((parseFloat(deger_total.value * deger_miktar.value) + parseFloat(deger_kdv_total.value) + parseFloat(deger_otv_total.value)) / (parseFloat(satir_rate2)));
					toplam_dongu_2 = toplam_dongu_2 + parseFloat(deger_kdv_total.value)- parseFloat(deger_kdv_total.value*genel_indirim_yuzdesi);
					toplam_dongu_5 = toplam_dongu_5 + parseFloat(deger_otv_total.value);
					deger_indirim_kdv = parseFloat(deger_kdv_total.value)- parseFloat(deger_kdv_total.value*genel_indirim_yuzdesi);
					toplam_dongu_3 = toplam_dongu_3 + ((parseFloat(deger_total.value)- (parseFloat(deger_total.value)*genel_indirim_yuzdesi)) * deger_miktar.value);
					toplam_dongu_3 = toplam_dongu_3 + parseFloat(deger_kdv_total.value)- parseFloat(deger_kdv_total.value*genel_indirim_yuzdesi);
					toplam_dongu_3 = toplam_dongu_3 + parseFloat(deger_otv_total.value);
					
					if(document.upd_invent.tevkifat_oran != undefined && document.upd_invent.tevkifat_oran.value != "" && upd_invent.tevkifat_box.checked == true)
					{//tevkifat hesaplamaları
						beyan_tutar = beyan_tutar + wrk_round(deger_indirim_kdv*filterNum(document.upd_invent.tevkifat_oran.value));
						if(new_taxArray.length != 0)
							for (var m=0; m < new_taxArray.length; m++)
							{	
								var tax_flag = false;
								if(new_taxArray[m] == deger_tax_rate.value){
									tax_flag = true;
									taxBeyanArray[m] += wrk_round(deger_indirim_kdv - (deger_indirim_kdv*(filterNum(document.upd_invent.tevkifat_oran.value))));
									taxTevkifatArray[m] += wrk_round(deger_indirim_kdv*(filterNum(document.upd_invent.tevkifat_oran.value)));
									break;
								}
							}
						if(!tax_flag){
							new_taxArray[new_taxArray.length] = deger_tax_rate.value;
							taxBeyanArray[taxBeyanArray.length] = wrk_round(deger_indirim_kdv - (deger_indirim_kdv*(filterNum(document.upd_invent.tevkifat_oran.value))));
							taxTevkifatArray[taxTevkifatArray.length] = wrk_round(deger_indirim_kdv*(filterNum(document.upd_invent.tevkifat_oran.value)));
						}
					}
					deger_net_total.value = commaSplit(deger_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
					deger_total.value = commaSplit(deger_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
					deger_total2.value = commaSplit(deger_total2.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
					deger_kdv_total.value = commaSplit(deger_kdv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
					deger_otv_total.value = commaSplit(deger_otv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
					deger_other_net_total.value = commaSplit(deger_other_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				}
			}	
			if(document.upd_invent.tevkifat_oran != undefined && document.upd_invent.tevkifat_oran.value != "" && upd_invent.tevkifat_box.checked == true)
			{//tevkifat hesaplamaları
				toplam_dongu_3 = toplam_dongu_3 - toplam_dongu_2 + beyan_tutar;
				toplam_dongu_2 = beyan_tutar;
				tevkifat_text.style.fontWeight = 'bold';
				tevkifat_text.innerHTML = '';
				beyan_text.style.fontWeight = 'bold';
				beyan_text.innerHTML = '';
				for (var tt=0; tt < new_taxArray.length; tt++)
				{
					tevkifat_text.innerHTML += '% ' + new_taxArray[tt] + ' : ' + commaSplit(taxBeyanArray[tt],4) + ' ';
					beyan_text.innerHTML += '% ' + new_taxArray[tt] + ' : ' + commaSplit(taxTevkifatArray[tt],4) + ' ';
				}
		 	}	
			
			var stopaj_yuzde_ = filterNum(document.getElementById("stopaj_yuzde").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			if(type == undefined || stopaj_yuzde_ == 0)
				stopaj_ = wrk_round(((toplam_dongu_1 * stopaj_yuzde_) / 100),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			else
				stopaj_ = filterNum(document.getElementById("stopaj").value);
				
			document.getElementById("stopaj_yuzde").value = commaSplit(stopaj_yuzde_);
			document.getElementById("stopaj").value = commaSplit(stopaj_,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);

			toplam_dongu_3 = toplam_dongu_3-parseFloat(stopaj_);
			//stopajlar hesaplandi
			document.upd_invent.total_amount.value = commaSplit(toplam_dongu_1,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			document.upd_invent.kdv_total_amount.value = commaSplit(toplam_dongu_2,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>); 
			document.getElementById('otv_total_amount').value = commaSplit(toplam_dongu_5,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			document.upd_invent.net_total_amount.value = commaSplit(toplam_dongu_3,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			for(s=1;s<=upd_invent.kur_say.value;s++)
			{
				form_txt_rate2_ = eval("document.upd_invent.txt_rate2_"+s);
				if(form_txt_rate2_.value == "")
					form_txt_rate2_.value = 1;
			}
			if(upd_invent.kur_say.value == 1)
				for(s=1;s<=upd_invent.kur_say.value;s++)
				{
					if(document.upd_invent.rd_money.checked == true)
					{
						deger_diger_para = document.upd_invent.rd_money;
						form_txt_rate2_ = eval("document.upd_invent.txt_rate2_"+s);
					}
				}
			else 
				for(s=1;s<=upd_invent.kur_say.value;s++)
				{
					if(document.upd_invent.rd_money[s-1].checked == true)
					{
						deger_diger_para = document.upd_invent.rd_money[s-1];
						form_txt_rate2_ = eval("document.upd_invent.txt_rate2_"+s);
					}
				}
			deger_money_id_1 = list_getat(deger_diger_para.value,1,',');
			deger_money_id_3 = list_getat(deger_diger_para.value,3,',');
			form_txt_rate2_.value = filterNum(form_txt_rate2_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			document.upd_invent.other_total_amount.value = commaSplit(toplam_dongu_1 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			document.upd_invent.other_kdv_total_amount.value = commaSplit(toplam_dongu_2 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>); 
			document.getElementById('other_otv_total_amount').value = commaSplit(toplam_dongu_5 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			document.upd_invent.other_net_total_amount.value = commaSplit(toplam_dongu_3 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			document.upd_invent.other_net_total_discount.value = commaSplit(deger_discount_value* parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			document.upd_invent.net_total_discount.value = commaSplit(deger_discount_value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			
			document.upd_invent.tl_value1.value = deger_money_id_1;
			document.upd_invent.tl_value2.value = deger_money_id_1;			//kdv
			document.getElementById('tl_value5').value = deger_money_id_1;	//otv
			document.upd_invent.tl_value3.value = deger_money_id_1;
			document.upd_invent.tl_value4.value = deger_money_id_1;
			form_txt_rate2_.value = commaSplit(form_txt_rate2_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
		function gonder(invent_id,invent_name,invent_no,quantity,acc_id,amort_rate,amortizaton_method,unit_last_value,last_inventory_value,unit_first_value,total_first_value,last_diff_value,expense_center_id,expense_center_name,budget_item_id,budget_item_name,debt_account_id,claim_account_id)
		{
			if(invent_name.indexOf('"') > -1)
				invent_name = invent_name.replace(/"/g,'');
			if(invent_name.indexOf("'") > -1)
				invent_name = invent_name.replace(/'/g,'');
			row_count++;
			satir_say++;
			var newRow;
			var newCell;
			newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);		
			newRow.setAttribute("NAME","frm_row" + row_count);
			newRow.setAttribute("ID","frm_row" + row_count);		
			newRow.className = 'color-row';
			document.upd_invent.record_num.value=row_count;
			newCell = newRow.insertCell(newRow.cells.length);
			x = '<input  type="hidden" value="WRK'+row_count+ js_create_unique_id() + row_count+'" name="wrk_row_id' + row_count +'"><input  type="hidden" value="" name="wrk_row_relation_id' + row_count +'">';
			newCell.innerHTML = x + '<input  type="hidden" value="1" name="row_kontrol' + row_count +'" ><a href="javascript://" onclick="sil(' + row_count + ');"><img  src="images/delete_list.gif" border="0"></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" name="invent_id' + row_count +'" value="'+ invent_id +'" readonly><input type="text" name="invent_no' + row_count +'" style="width:100px;" class="boxtext" value="'+ invent_no +'">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="invent_name' + row_count +'" style="width:100px;"  readonly class="boxtext" value="'+ invent_name +'" maxlength="100">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.title=eval("upd_invent.invent_name"+satir_say).value;
			newCell.innerHTML = '<input type="text" name="quantity' + row_count +'" style="width:100px;" class="box" value="'+ quantity +'" onBlur="hesapla(' + row_count +');" onkeyup="return(FormatCurrency(this,event));">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.title=eval("upd_invent.invent_name"+satir_say).value;
			newCell.innerHTML = '<input type="text" name="row_total_' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" onBlur="hesapla(' + row_count +');" style="width:100px;" class="box">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.title=eval("upd_invent.invent_name"+satir_say).value;
			newCell.innerHTML = '<input type="text" name="row_total2_' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" onBlur="hesapla(' + row_count +',1);" style="width:100px;" class="box">';
			//kdv orani
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.title=eval("upd_invent.invent_name"+satir_say).value;
			newCell.innerHTML = '<select name="tax_rate'+ row_count +'" style="width:100px;" onChange="hesapla('+ row_count +');" class="box"><cfoutput query="get_tax"><option value="#tax#">#tax#</option></cfoutput></select>';
			//otv orani
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.title=eval("upd_invent.invent_name"+satir_say).value;
			newCell.innerHTML = '<select name="otv_rate'+ row_count +'" id="otv_rate'+ row_count +'" style="width:100px;" onChange="hesapla('+ row_count +');" class="box"><cfoutput query="get_otv"><option value="#tax#">#tax#</option></cfoutput></select>';
			//kdv total
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.title=eval("upd_invent.invent_name"+satir_say).value;
			newCell.innerHTML = '<input type="text" name="kdv_total' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" style="width:100px;" onBlur="hesapla(' + row_count +',1);" class="box">';
			//otv total
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.title=eval("upd_invent.invent_name"+satir_say).value;
			newCell.innerHTML = '<input type="text" name="otv_total' + row_count +'" id="otv_total' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" style="width:100px;" onBlur="hesapla(' + row_count +',1);" class="box">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.title=eval("upd_invent.invent_name"+satir_say).value;	
	        newCell.innerHTML = '<input type="text" name="net_total' + row_count +'" id="net_total' + row_count +'" value="0" style="width:100px;" class="box" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" onblur="hesapla(' + row_count +',3);">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.title=eval("upd_invent.invent_name"+satir_say).value;
	        newCell.innerHTML = '<input type="text" name="row_other_total' + row_count +'" id="row_other_total' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" style="width:100px;" class="box" onblur="hesapla(' + row_count +',4);">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.title=eval("upd_invent.invent_name"+satir_say).value;
			newCell.innerHTML = '<select name="money_id' + row_count  +'" style="width:100px;" class="boxtext" onChange="hesapla('+ row_count +');"><cfoutput query="get_money"><option value="#money#,#rate1#,#rate2#" <cfif money eq session.ep.money>selected</cfif>>#money#</option></cfoutput></select>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.title=eval("upd_invent.invent_name"+satir_say).value;
			newCell.innerHTML = '<input type="text" readonly="yes" name="amortization_rate' + row_count +'" value="'+ amort_rate +'" style="width:100px;" class="box" onkeyup="return(FormatCurrency(this,event));">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.title=eval("upd_invent.invent_name"+satir_say).value;
			if(amortizaton_method == 0)
				newCell.innerHTML = '<input type="text" readonly name="amortization_method'+ row_count +'" style="width:165px;" class="box" value="<cf_get_lang dictionary_id='29421.Azalan Bakiye Üzerinden'>">';
			else if(amortizaton_method == 1)
				newCell.innerHTML = '<input type="text" readonlyname="amortization_method'+ row_count +'" style="width:165px;" class="box" value="<cf_get_lang dictionary_id='29422.Sabit Miktar Üzeriden'>">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.title=eval("upd_invent.invent_name"+satir_say).value;
			newCell.innerHTML = '<input  type="hidden" readonly name="account_id' + row_count +'" id="account_id' + row_count +'"  value="'+ acc_id +'"><input type="text" style="width:120px;" name="account_code' + row_count +'" id="account_code' + row_count +'" value="'+ acc_id +'" class="boxtext" onFocus="autocomp_account('+row_count+');"><a href="javascript://" onclick="pencere_ac_acc('+ row_count +');" ><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.title=eval("upd_invent.invent_name"+satir_say).value;	
			newCell.innerHTML = '<input type="hidden" name="unit_first_value' + row_count +'" value="'+ unit_first_value +'"><input type="hidden" name="total_first_value' + row_count +'" value="'+ total_first_value +'"><input type="hidden" name="unit_last_value' + row_count +'" value="'+ unit_last_value +'"><input type="text" name="last_inventory_value' + row_count +'" value="'+ last_inventory_value +'" style="width:100px;" class="box" onkeyup="return(FormatCurrency(this,event));" readonly="yes">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.title=eval("upd_invent.invent_name"+satir_say).value;	
			newCell.innerHTML = '<input type="text" name="last_diff_value' + row_count +'" value="'+last_diff_value+'" style="width:100px;" class="box" onkeyup="return(FormatCurrency(this,event));" readonly="yes">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.title=eval("upd_invent.invent_name"+satir_say).value;	
			newCell.innerHTML ='<input type="hidden" name="expense_center_id' + row_count +'" value="'+expense_center_id+'" id="expense_center_id' + row_count +'"><input type="text" id="expense_center_name' + row_count +'" name="expense_center_name' + row_count +'" onFocus="exp_center('+row_count+');" value="'+expense_center_name+'" style="width:150px;" class="boxtext"><a href="javascript://" onClick="pencere_ac_exp_center('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.title=eval("upd_invent.invent_name"+satir_say).value;	
			newCell.innerHTML = '<input  type="hidden" name="budget_item_id' + row_count +'" id="budget_item_id' + row_count +'" value='+budget_item_id+'><input type="text" style="width:118px;" name="budget_item_name' + row_count +'" id="budget_item_name' + row_count +'" class="boxtext" value="'+budget_item_name+'" onFocus="exp_item('+row_count+');"><a href="javascript://"><img src="/images/plus_thin.gif" onclick="pencere_ac_exp('+ row_count +');" align="absmiddle" border="0"></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.title=eval("upd_invent.invent_name"+satir_say).value;	
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input  type="hidden" name="budget_account_id' + row_count +'" id="budget_account_id' + row_count +'" value="'+debt_account_id+'"><input type="text" name="budget_account_code' + row_count +'" id="budget_account_code' + row_count +'" value="'+debt_account_id+'" class="boxtext" style="width:158px;" onFocus="autocomp_budget_account('+row_count+');"><a href="javascript://"onclick="pencere_ac_acc_1('+ row_count +');" ><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.title=eval("upd_invent.invent_name"+satir_say).value;	
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input  type="hidden" name="amort_account_id' + row_count +'" id="amort_account_id' + row_count +'" value="'+claim_account_id+'"><input type="text" name="amort_account_code' + row_count +'" id="amort_account_code' + row_count +'"  value="'+claim_account_id+'" class="boxtext" style="width:205px;" onFocus="autocomp_amort_account('+row_count+');"> <a href="javascript://"onclick="pencere_ac_acc_2('+ row_count +');" ><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.title=eval("upd_invent.invent_name"+satir_say).value;
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input  type="hidden" name="product_id' + row_count +'" id="product_id' + row_count +'"><input  type="hidden" name="stock_id' + row_count +'" id="stock_id' + row_count +'"><input type="text" name="product_name' + row_count +'" id="product_name' + row_count +'" class="boxtext" onFocus="AutoComplete_Create(\'product_name' + row_count +'\',\'PRODUCT_NAME\',\'PRODUCT_NAME,STOCK_CODE\',\'get_product_autocomplete\',\'0\',\'PRODUCT_ID,STOCK_ID,MAIN_UNIT,PRODUCT_UNIT_ID\',\'product_id' + row_count +',stock_id' + row_count +',stock_unit' + row_count  +',stock_unit_id' + row_count  +'\',\'upd_invent\',1,\'\',\'\');">'
								+' '+'<a href="javascript://" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_product_names</cfoutput>&product_id=upd_invent.product_id" + row_count + "&field_id=upd_invent.stock_id" + row_count + "&field_unit_name=upd_invent.stock_unit" + row_count + "&field_main_unit=upd_invent.stock_unit_id" + row_count + "&field_name=upd_invent.product_name" + row_count + "','list');"+'"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.title=eval("upd_invent.invent_name"+satir_say).value;
			newCell.innerHTML = '<input type="hidden" name="stock_unit_id' + row_count +'" id="stock_unit_id' + row_count +'"><input type="text" name="stock_unit' + row_count +'" id="stock_unit' + row_count +'" style="width:100px;" class="boxtext">';
		}
		/* masraf merkezi popup */
		function pencere_ac_exp_center(no)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&is_invoice=1&field_id=upd_invent.expense_center_id' + no +'&field_name=upd_invent.expense_center_name' + no,'list');
		}
		/* masraf merkezi autocomplete */
		function exp_center(no)
		{
			AutoComplete_Create("expense_center_name" + no,"EXPENSE,EXPENSE_CODE","EXPENSE,EXPENSE_CODE","get_expense_center","","EXPENSE_ID","expense_center_id"+no,"",3);
		}
		/* gider kalemi autocomplete */
		function exp_item(no)
		{
			AutoComplete_Create("budget_item_name" + no,"EXPENSE_ITEM_NAME","EXPENSE_ITEM_NAME","get_expense_item","","EXPENSE_ITEM_ID,ACCOUNT_CODE","budget_item_id"+no+",budget_account_code"+no,"",3);
		}
		function autocomp_account(no)
		{
			AutoComplete_Create("account_code"+no,"ACCOUNT_CODE,ACCOUNT_NAME","ACCOUNT_CODE,ACCOUNT_NAME","get_account_code","0","ACCOUNT_CODE","account_id"+no,"",3);
		}
		function autocomp_budget_account(no)
		{
			AutoComplete_Create("budget_account_code"+no,"ACCOUNT_CODE,ACCOUNT_NAME","ACCOUNT_CODE,ACCOUNT_NAME","get_account_code","0","ACCOUNT_CODE","budget_account_id"+no,"",3);
		}
		function autocomp_amort_account(no)
		{
			AutoComplete_Create("amort_account_code"+no,"ACCOUNT_CODE,ACCOUNT_NAME","ACCOUNT_CODE,ACCOUNT_NAME","get_account_code","0","ACCOUNT_CODE","amort_account_id"+no,"",3);
		}
		function pencere_ac_acc(no)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=upd_invent.account_id' + no +'&field_name=upd_invent.account_code' + no +'','list');
		}
		function pencere_ac_acc_1(no)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=upd_invent.budget_account_id' + no +'&field_name=upd_invent.budget_account_code' + no +'','list');
		}
		function pencere_ac_acc_2(no)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=upd_invent.amort_account_id' + no +'&field_name=upd_invent.amort_account_code' + no +'','list');
		}
		function pencere_ac_exp(no)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&is_budget_items=1&field_id=upd_invent.budget_item_id' + no +'&field_name=upd_invent.budget_item_name' + no +'&field_account_no=upd_invent.budget_account_code' + no +'&field_account_no2=upd_invent.budget_account_id' + no +'','list');
		}
		function pencere_ac_stock(no)
		{
				if(upd_invent.branch_id.value == '')
				{
					alert("<cf_get_lang dictionary_id='57723.Önce depo seçmelisiniz'>!");
					return false;
				}
				if(upd_invent.company_id.value.length==0)
				{ 
					alert("<cf_get_lang dictionary_id='57715.Önce Üye Seçiniz'>!");
					return false;
				}
				if(upd_invent.company_id!=undefined && upd_invent.company_id.value.length)
					windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_products&company_id='+upd_invent.company_id.value+'&int_basket_id=1&is_sale_product=0&update_product_row_id=0</cfoutput>','list');
		}
		function ayarla_gizle_goster()
		{
			if(upd_invent.cash.checked)
				kasa_sec.style.display='';
			else
				kasa_sec.style.display='none';
		}
		function f_upd_invent()
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_inventory&field_id=upd_invent.invent_id&is_sale=1','wide');
		}
		function change_paper_duedate(field_name,type,is_row_parse) 
		{
			paper_date_=eval('document.upd_invent.invoice_date.value');
			if(type!=undefined && type==1)
				document.upd_invent.basket_due_value.value = datediff(paper_date_,document.upd_invent.basket_due_value_date_.value,0);
			else
			{
				if(isNumber(document.upd_invent.basket_due_value)!= false && (document.upd_invent.basket_due_value.value != 0))
					document.upd_invent.basket_due_value_date_.value = date_add('d',+document.upd_invent.basket_due_value.value,paper_date_);
				else
				{
					document.upd_invent.basket_due_value_date_.value =paper_date_;
					if(document.upd_invent.basket_due_value.value == '')
						document.upd_invent.basket_due_value.value = datediff(paper_date_,document.upd_invent.basket_due_value_date_.value,0);
				}
			}
		}
		function change_acc_all()
		{
			var loopcount=document.getElementById('record_num').value;	
			if(loopcount>0)
			{
				for(var i=1;i<=loopcount;++i)
				{
					document.getElementById('account_id'+i).value = document.getElementById('account_id_all').value;
					document.getElementById('account_code'+i).value = document.getElementById('account_code_all').value;
				}
			}
		}
		function change_budget_acc_all()
		{
			var loopcount=document.getElementById('record_num').value;	
			if(loopcount>0)
			{
				for(var i=1;i<=loopcount;++i)
				{
					document.getElementById('budget_account_id'+i).value = document.getElementById('budget_account_id_all').value;
					document.getElementById('budget_account_code'+i).value = document.getElementById('budget_account_code_all').value;
				}
			}
		}
		function change_exp_all()
		{
			var loopcount=document.getElementById('record_num').value;
			if(loopcount>0)
			{
				for(var i=1;i<=loopcount;++i)
				{
					document.getElementById('budget_item_id'+i).value = document.getElementById('budget_item_id_all').value;
					document.getElementById('budget_item_name'+i).value = document.getElementById('budget_item_name_all').value;
					document.getElementById('budget_account_id'+i).value = document.getElementById('budget_account_id_all').value;
					document.getElementById('budget_account_code'+i).value = document.getElementById('budget_account_code_all').value;
				}
			}
		}
		function change_amort_all()
		{
			var loopcount=document.getElementById('record_num').value;	
			if(loopcount>0)
			{
				for(var i=1;i<=loopcount;++i)
				{
					document.getElementById('amort_account_id'+i).value = document.getElementById('amort_account_id_all').value;
					document.getElementById('amort_account_code'+i).value = document.getElementById('amort_account_code_all').value;
				}
			}
		}
		function clear_()
		{
			if(document.getElementById('employee').value=='')
			{
				document.getElementById('employee_id').value='';
			}
		}
		function change_expense_center()
		{
			var loopcount=document.getElementById('record_num').value;
			if(loopcount>0)
			{
				for(var i=1;i<=loopcount;++i)
				{
					document.getElementById('expense_center_id'+i).value = document.getElementById('expense_center_id_all').value;
					document.getElementById('expense_center_name'+i).value = document.getElementById('main_exp_center_name_all').value;
				}
			}
		}
		function kontrol2()
		{
			<cfif session.ep.our_company_info.is_efatura>
				var chk_efatura = wrk_safe_query("chk_efatura_count",'dsn2',0,'<cfoutput>#attributes.invoice_id#</cfoutput>');
				if(chk_efatura.recordcount > 0)
				{
					alert("<cf_get_lang dictionary_id='57114.Fatura ile İlişkili e-Fatura Olduğu için Silinemez!'>");
					return false;
				}	
			</cfif>
			return true;
		}
	</script>
</cfif>
