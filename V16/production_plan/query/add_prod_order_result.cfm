<cfsetting showdebugoutput="yes">
<cfinclude template="../../workdata/get_main_spect_id.cfm">
<cfif isDefined("session.pda")>
	<!--- Pda Kullanimi Icin Eklendi, Sayfa Pda Uretimden De Kullaniliyor FBS 20111215 --->
	<cfset session_userid = session.pda.userid>
	<cfset session_money = session.pda.money>
	<cfset session_money2 = session.pda.money2>
	<cfset session_our_company_info_spect_type = session.pda.our_company_info.spect_type>
<cfelse>
	<cfset session_userid = session.ep.userid>
	<cfset session_money = session.ep.money>
	<cfset session_money2 = session.ep.money2>
	<cfset session_our_company_info_spect_type = session.ep.our_company_info.spect_type>
</cfif>
<cfif len(attributes.start_date)><cf_date tarih='attributes.start_date'></cfif>
<cfif len(attributes.finish_date)><cf_date tarih='attributes.finish_date'></cfif>
<cfif len(attributes.expiration_date)><cf_date tarih='attributes.expiration_date'></cfif>
<cfscript>
	account_action_date=attributes.finish_date; /*muhasebe isleminde kullanılıyor*/
	attributes.start_date = createdatetime(year(attributes.start_date),month(attributes.start_date),day(attributes.start_date),attributes.start_h,attributes.start_m,0);
	attributes.finish_date = createdatetime(year(attributes.finish_date),month(attributes.finish_date),day(attributes.finish_date),attributes.finish_h,attributes.finish_m,0);
</cfscript>
<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
    <cfquery name="upd_gen" datasource="#dsn3#">
        UPDATE 
            GENERAL_PAPERS
        SET
            PRODUCTION_RESULT_NUMBER = PRODUCTION_RESULT_NUMBER + 1
        WHERE
            PRODUCTION_RESULT_NUMBER IS NOT NULL
    </cfquery>
	<!---<cf_papers paper_type="PRODUCTION_RESULT">--->
    <cfquery name="GET_GEN_PAPER" datasource="#DSN3#">
        SELECT PRODUCTION_RESULT_NUMBER,PRODUCTION_RESULT_NO FROM GENERAL_PAPERS WHERE PAPER_TYPE IS NULL
    </cfquery>
	<cfscript>
		system_paper_no = GET_GEN_PAPER.PRODUCTION_RESULT_NO & '-' & GET_GEN_PAPER.PRODUCTION_RESULT_NUMBER;
		//system_paper_no_add = paper_number;
		hour_time=0;
		start_minute=(attributes.start_h*60)+attributes.start_m;
		finish_minute=(attributes.finish_h*60)+attributes.finish_m;
		hour_time=(finish_minute-start_minute)/60;
	</cfscript>
    <cfstoredproc procedure="ADD_PRODUCTION_ORDER_RESULT" datasource="#DSN3#">
        <cfprocparam cfsqltype="cf_sql_integer" value="#attributes.p_order_id#">
        <cfprocparam cfsqltype="cf_sql_integer" value="#attributes.process_cat#">
        <cfif len(attributes.start_date)>
            <cfprocparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
        <cfelse>
            <cfprocparam cfsqltype="cf_sql_timestamp" value="NULL" null="yes">
        </cfif>
        <cfif len(attributes.finish_date)>
            <cfprocparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
        <cfelse>
            <cfprocparam cfsqltype="cf_sql_timestamp" value="NULL" null="yes">
        </cfif>
        <cfif len(attributes.exit_department) and len(attributes.exit_department_id)>
            <cfprocparam cfsqltype="cf_sql_integer" value="#attributes.exit_department_id#">
        <cfelse>
            <cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
        </cfif>
        <cfif len(attributes.exit_department) and len(attributes.exit_location_id)>
            <cfprocparam cfsqltype="cf_sql_integer" value="#attributes.exit_location_id#">
        <cfelse>
            <cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
        </cfif>
        <cfif len(attributes.station_id) and len(attributes.station_name)>
            <cfprocparam cfsqltype="cf_sql_integer" value="#attributes.station_id#">
        <cfelse>
            <cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
        </cfif>
        <cfif len(attributes.production_order_no)>
            <cfprocparam cfsqltype="cf_sql_varchar" value="#attributes.production_order_no#">
        <cfelse>
            <cfprocparam cfsqltype="cf_sql_varchar" value="NULL" null="yes">
        </cfif>
        <cfif len(system_paper_no)>
            <cfprocparam cfsqltype="cf_sql_varchar" value="#system_paper_no#">
        <cfelse>
            <cfprocparam cfsqltype="cf_sql_varchar" value="NULL" null="yes">
        </cfif>
        <cfif len(attributes.enter_department) and len(attributes.enter_department_id)>
            <cfprocparam cfsqltype="cf_sql_integer" value="#attributes.enter_department_id#">
        <cfelse>
            <cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
        </cfif>
        <cfif len(attributes.enter_department) and len(attributes.enter_location_id)>
            <cfprocparam cfsqltype="cf_sql_integer" value="#attributes.enter_location_id#">
        <cfelse>
            <cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
        </cfif>
        <cfif len(attributes.order_no)>
            <cfprocparam cfsqltype="cf_sql_varchar" value="#attributes.order_no#">
        <cfelse>
            <cfprocparam cfsqltype="cf_sql_varchar" value="NULL" null="yes">
        </cfif>
        <cfif isDefined("attributes.reference_no") and len(attributes.reference_no)>
            <cfprocparam cfsqltype="cf_sql_varchar" value="#attributes.reference_no#">
        <cfelse>
            <cfprocparam cfsqltype="cf_sql_varchar" value="NULL" null="yes">
        </cfif>
        <cfif len(attributes.expense_employee_id)>
            <cfprocparam cfsqltype="cf_sql_integer" value="#attributes.expense_employee_id#">
        <cfelse>
            <cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
        </cfif>
        <cfprocparam cfsqltype="cf_sql_integer" value="#session_userid#">
        <cfprocparam cfsqltype="cf_sql_timestamp" value="#now()#">
        <cfprocparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
        <cfif len(attributes.lot_no)>
            <cfprocparam cfsqltype="cf_sql_varchar" value="#attributes.lot_no#">
        <cfelse>
            <cfprocparam cfsqltype="cf_sql_varchar" value="NULL" null="yes">
        </cfif>
        <cfif len(attributes.production_department) and len(attributes.production_department_id)>
            <cfprocparam cfsqltype="cf_sql_integer" value="#attributes.production_department_id#">
        <cfelse>
            <cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
        </cfif>
        <cfif len(attributes.production_department) and len(attributes.production_location_id)>
            <cfprocparam cfsqltype="cf_sql_integer" value="#attributes.production_location_id#">
        <cfelse>
            <cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
        </cfif>
        <cfprocparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
        <cfprocparam cfsqltype="cf_sql_bit" value="0">
		<cfprocparam cfsqltype="cf_sql_varchar" value="WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session_userid##round(rand()*100)#">
		<cfif len(attributes.expiration_date)>
            <cfprocparam cfsqltype="cf_sql_timestamp" value="#attributes.expiration_date#">
        <cfelse>
            <cfprocparam cfsqltype="cf_sql_timestamp" value="NULL" null="yes">
        </cfif>
    </cfstoredproc>

    <cfstoredproc procedure="UPD_PRODUCTION_ORDERS_REF_NO" datasource="#dsn3#">
        <cfif len(attributes.ref_no)>
         	<cfprocparam cfsqltype="cf_sql_varchar" value="#attributes.ref_no#">
        <cfelse>
        	<cfprocparam cfsqltype="cf_sql_varchar" value="NULL" null="yes">
        </cfif>
		<cfprocparam cfsqltype="cf_sql_integer" value="#attributes.p_order_id#">
	</cfstoredproc>
    
	<cfif attributes.lot_no neq attributes.old_lot_no><!--- Eğer Lot no değişmiş ise üretim emrindeki lot numarasınıda değiştiriyoruz! --->
        <cfstoredproc procedure="UPD_PRO_ORDER_LOT_NUMBER" datasource="#dsn3#">
            <cfif len(attributes.lot_no)>
                <cfprocparam cfsqltype="cf_sql_varchar" value="#attributes.lot_no#">
            <cfelse>
                <cfprocparam cfsqltype="cf_sql_varchar" value="NULL" null="yes">
            </cfif>
            <cfprocparam cfsqltype="cf_sql_integer" value="#attributes.p_order_id#">
		</cfstoredproc>
	</cfif>

    <cfstoredproc procedure="GET_PRODUCTION_ORDER_RESULT_MAX_ID" datasource="#dsn3#">
    	<cfprocresult name="GET_MAX2">
    </cfstoredproc>

  <!---  <cfstoredproc procedure="UPD_GENERAL_PAPERS" datasource="#dsn3#">
    	<cfprocparam cfsqltype="cf_sql_integer" value="#system_paper_no_add#">
    </cfstoredproc>--->
	
	<cfscript>
		value_price = 0;
		value_price_extra = 0;
		value_price2 = 0;
		value_price_extra2 = 0;
	</cfscript>
	<!--- Sonuç kısmındaki ürün 1 tane ise vede XML ayarlarından "Sarf değişikliklerinden spec değişssin" seçeneği seçilmiş ise satırların değişmesi duruma göre spect kontrolü yapmak üzere specer fonksiyonuna gönderilmek üzere değişkenler tanımlanıyor --->
	<cfif attributes.record_num eq 1 and attributes.is_changed_spec_main eq 1>
		<cfscript>
			m_main_stock_id = attributes.STOCK_ID1;
			m_main_product_id = attributes.PRODUCT_ID1;
			if(len(attributes.SPECT_NAME1))
			m_spec_name = attributes.SPECT_NAME1;
			else
			m_spec_name = attributes.product_name1;
			m_row_count=0;
			m_spec_total_value = 0;
			m_spec_other_total_value = 0;
			m_other_money = session_money2;
			m_main_prod_price = attributes.COST_PRICE1;
			m_main_product_money = attributes.MONEY1;
			if(isdefined("attributes.COST_PRICE_21"))
			{
				m_main_prod_price_2 = attributes.COST_PRICE_21;
				m_main_product_money_2 = attributes.MONEY_21;
			}
			m_stock_id_list="";
			m_product_id_list="";
			m_lot_no_list="";
			m_product_name_list="";
			m_amount_list="";
			m_sevk_list="";
			m_product_price_list="";
			m_product_money_list="";
			m_product_price_2_list="";
			m_product_money_2_list="";
			m_is_property_list ="";//0 set edilecek sarf olduğu için
			m_property_id_list ="";
			m_variation_id_list="";
			m_total_min_list = "";
			m_total_max_list = "";
			m_tolerance_list="";
			m_is_configure_list="";
			m_diff_price_list = "";
			m_related_spect_main_id_list ="";
		</cfscript>
	</cfif>
	<!--- SARFLAR --->
	<cfif len(attributes.record_num_exit) and attributes.record_num_exit neq "">
		<cfloop from="1" to="#attributes.record_num_exit#" index="st">
			<cfif evaluate("attributes.row_kontrol_exit#st#")>
				<cfif len(evaluate("attributes.expiration_date_exit#st#"))>
					<cfset form_expiration_date_exit = evaluate("attributes.expiration_date_exit#st#")>
					<cf_date tarih="form_expiration_date_exit">
				<cfelse>
					<cfset form_expiration_date_exit ="">
				</cfif>
				<cfscript>
					form_tree_type_exit = evaluate("attributes.tree_type_exit_#st#");
					if(isdefined("attributes.line_number_exit_#st#"))
						form_line_number_exit = evaluate("attributes.line_number_exit_#st#");
					else
						form_line_number_exit = "";
					if(isdefined("attributes.wrk_row_id_exit_#st#"))
						form_wrk_row_id_exit = evaluate("attributes.wrk_row_id_exit_#st#");
					else
						form_wrk_row_id_exit = "";
					form_spec_main_id_exit = evaluate("attributes.spec_main_id_exit#st#");
					if(isdefined("attributes.barcode_exit#st#"))
						form_barcode_exit = evaluate("attributes.barcode_exit#st#");
					else
						form_barcode_exit = '';
					form_product_id_exit = evaluate("attributes.product_id_exit#st#");
					form_stock_id_exit = evaluate("attributes.stock_id_exit#st#");
					form_lot_no_exit = evaluate("attributes.lot_no_exit#st#");
					
					form_amount_exit = evaluate("attributes.amount_exit#st#");
					if(isdefined("attributes.amount_exit2_#st#"))
						form_amount_exit2_ = evaluate("attributes.amount_exit2_#st#");
					else
						form_amount_exit2_ = '';
					form_unit_id_exit = evaluate("attributes.unit_id_exit#st#");
					if(isdefined("attributes.unit2_exit#st#"))
					form_unit2_exit = evaluate("attributes.unit2_exit#st#");
					else
					form_unit2_exit ='';
					form_serial_no_exit = evaluate("attributes.serial_no_exit#st#");
					form_exit_product_name = evaluate("attributes.product_name_exit#st#");
					form_exit_unit = evaluate("attributes.unit_exit#st#");
					form_spect_id_exit = evaluate("attributes.spect_id_exit#st#");
					form_spect_name_exit = evaluate("attributes.spect_name_exit#st#");
					form_is_production_spect_exit = evaluate("attributes.is_production_spect_exit#st#");//eğer sarfa spect seçilmemişse ve üretilen bir ürünse bu sarf,otomatik olarak spect oluşacak.

					form_cost_id_exit = evaluate("attributes.cost_id_exit#st#");
					form_kdv_amount_exit=evaluate("attributes.kdv_amount_exit#st#");
					form_cost_price_system_exit=evaluate("attributes.cost_price_system_exit#st#");
					form_purchase_extra_cost_system_exit=evaluate("attributes.purchase_extra_cost_system_exit#st#");
					form_purchase_extra_cost_exit=evaluate("attributes.purchase_extra_cost_exit#st#");//filterNum
					form_money_system_exit = evaluate("attributes.money_system_exit#st#");
					form_cost_price_exit = evaluate("attributes.cost_price_exit#st#");
					form_money_exit = evaluate("attributes.money_exit#st#");

					/* form_cost_price_exit=replace(replace(form_cost_price_exit,".","","all"),",",".","all");
					form_amount_exit=replace(replace(form_amount_exit,".","","all"),",",".","all");
					attributes.amount1=replace(replace(attributes.amount1,".","","all"),",",".","all"); */

					if (isdefined("attributes.is_manual_cost_exit#st#") and evaluate("attributes.is_manual_cost_exit#st#") eq 1)
						form_is_manual_cost_exit = evaluate("attributes.is_manual_cost_exit#st#");
					else
						form_is_manual_cost_exit = 0;
					if (isdefined("attributes.cost_price_exit_2#st#"))
					{
						form_cost_price_exit_2 = evaluate("attributes.cost_price_exit_2#st#");
						form_cost_price_exit_extra_2 = evaluate("attributes.purchase_extra_cost_exit_2#st#");
						form_money_exit_2 = evaluate("attributes.money_exit_2#st#");
					}
					else
					{
						form_cost_price_exit_2 = 0;
						form_cost_price_exit_extra_2 = 0;
						form_money_exit_2 = '';
					}
					if(isdefined("attributes.width_exit#st#"))
					width_exit = evaluate("attributes.width_exit#st#");
					else
					width_exit = '';
					if(isdefined("attributes.height_exit#st#"))
					height_exit = evaluate("attributes.height_exit#st#");
					else
					height_exit = '';
					if(isdefined("attributes.length_exit#st#"))
					length_exit = evaluate("attributes.length_exit#st#");
					else
					length_exit = '';
					if(isdefined("attributes.specific_weight_exit#st#"))
					specific_weight_exit = evaluate("attributes.specific_weight_exit#st#");
					else
					specific_weight_exit = '';
					if(isdefined("attributes.weight_exit#st#"))
					weight_exit = evaluate("attributes.weight_exit#st#");
					else
					weight_exit = '';
					if(attributes.record_num eq 1  and attributes.is_changed_spec_main eq 1)
					{
						m_row_count=m_row_count+1;
						m_product_id_list = listappend(m_product_id_list,form_product_id_exit,',');
						m_stock_id_list =  listappend(m_stock_id_list,form_stock_id_exit,',');
						m_product_name_list =  listappend(m_product_name_list,form_exit_product_name,',');
						m_lot_no_list = listappend(m_lot_no_list,form_lot_no_exit,',');
						m_amount_list = listappend(m_amount_list,form_amount_exit/attributes.amount1,',');//sarfların miktarı bölü ana ürünün miktarı
						if(isdefined('attributes.is_sevkiyat#st#'))
							m_sevk_list = listappend(m_sevk_list,1,',');
						else
							m_sevk_list = listappend(m_sevk_list,0,',');
						m_product_price_list = 	listappend(m_product_price_list,form_cost_price_exit,',');
						m_product_money_list = listappend(m_product_money_list,form_money_exit,',');
						if(isdefined("form_cost_price_exit_2"))
						{
							m_product_price_2_list = 	listappend(m_product_price_2_list,form_cost_price_exit_2,',');
							m_product_money_2_list = listappend(m_product_money_2_list,form_money_exit_2,',');
						}
						else
						{
							m_product_price_2_list = 	listappend(m_product_price_2_list,0,',');
							m_product_money_2_list = listappend(m_product_money_2_list,0,',');
						}
						m_is_property_list = listappend(m_is_property_list,0,',');
						m_property_id_list = listappend(m_property_id_list,0,',');
						m_variation_id_list = listappend(m_variation_id_list,0,',');
						m_total_min_list = listappend(m_total_min_list,0,',');
						m_total_max_list = listappend(m_total_max_list,0,',');
						m_tolerance_list = listappend(m_tolerance_list,'-',',');
						m_is_configure_list = listappend(m_is_configure_list,1,',');
						m_diff_price_list = listappend(m_diff_price_list,0,',');
						if(len(form_spec_main_id_exit))
							m_related_spect_main_id_list =  listappend(m_related_spect_main_id_list,form_spec_main_id_exit,',');
						else
							m_related_spect_main_id_list =  listappend(m_related_spect_main_id_list,0,',');
							
					}
				</cfscript>
				<!--- Üretilen fakat spect seçilmemiş ürünler için spect kontrolü --->
				<cfif not len(form_spec_main_id_exit) and form_is_production_spect_exit eq 1 ><!--- spect seçilmemiş ise ve ürün üretiliyor ise --->
					<cfscript>
							'new_spec_value#st#' = get_main_spect_id(form_stock_id_exit);
							if(len(Evaluate('new_spec_value#st#').SPECT_MAIN_ID))
								form_spec_main_id_exit = Evaluate('new_spec_value#st#').SPECT_MAIN_ID;
							else
								form_spec_main_id_exit = 0;
					</cfscript>
				</cfif>
				<!--- Sarf --->
                <cfif isDefined('session.ep.userid')>
					<cfset wrk_row_id_sarf = 'WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##get_max2.max_id##form_stock_id_exit#_2'>
				<cfelseif isDefined('session.pda.userid')>
					<cfset wrk_row_id_sarf = 'WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.pda.userid##round(rand()*100)##get_max2.max_id##form_stock_id_exit#_2'>                
                </cfif>
                <cfstoredproc procedure="ADD_PRODUCTION_ORDER_RESULTS_ROW_S" datasource="#dsn3#">
                    <cfprocparam cfsqltype="cf_sql_varchar" value="#form_tree_type_exit#"><!--- EĞER S GELİRSE NORMAL SARF P GELİRSE  PHANTOM ÜRÜN'ÜN İÇERİĞİNDEN  O GELİRSE OPERASYONUN ALTINDAN GELEN ÜRÜN ANLAMAINA GELMEKTEDİR. --->
                    <cfprocparam cfsqltype="cf_sql_integer" value="2">
                    <cfprocparam cfsqltype="cf_sql_integer" value="#get_max2.max_id#">
                    <cfif isdefined("form_barcode_exit") and len(form_barcode_exit)>
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#form_barcode_exit#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_varchar" value="NULL" null="yes">
                    </cfif>
                    <cfif len(form_stock_id_exit)>
                        <cfprocparam cfsqltype="cf_sql_integer" value="#form_stock_id_exit#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
                    </cfif>
                    <cfif len(form_product_id_exit)>
                        <cfprocparam cfsqltype="cf_sql_integer" value="#form_product_id_exit#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
                    </cfif>
                    <cfif Len(form_lot_no_exit)>
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#form_lot_no_exit#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_varchar" value="NULL" null="yes">
                    </cfif>
                    <cfif len(form_amount_exit)>
                        <cfprocparam cfsqltype="cf_sql_float" value="#form_amount_exit#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_float" value="NULL" null="yes">
                    </cfif>
                    <cfif isdefined('form_amount_exit2_') and len(form_amount_exit2_) and len(form_unit2_exit)>
                        <cfprocparam cfsqltype="cf_sql_float" value="#form_amount_exit2_#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_float" value="NULL" null="yes">
                    </cfif>
                    <cfif len(form_unit_id_exit)>
                        <cfprocparam cfsqltype="cf_sql_integer" value="#form_unit_id_exit#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
                    </cfif>
                    <cfif len(form_unit2_exit)>
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#form_unit2_exit#" null="yes">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_varchar" value="NULL" null="yes">
                    </cfif>
                    <cfif len(form_serial_no_exit)>
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#form_serial_no_exit#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_varchar" value="NULL" null="yes">
                    </cfif>
                    <cfprocparam cfsqltype="cf_sql_varchar" value="#left(form_exit_product_name,75)#">
                    <cfprocparam cfsqltype="cf_sql_varchar" value="#left(form_exit_unit,75)#">
                    <cfif isdefined("attributes.is_sevkiyat#st#")>
                        <cfprocparam cfsqltype="cf_sql_bit" value="1">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_bit" value="0">
                    </cfif>
                    <cfif len(form_spect_id_exit)>
                        <cfprocparam cfsqltype="cf_sql_integer" value="#form_spect_id_exit#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
                    </cfif>
                    <cfif len(form_spec_main_id_exit) and form_spec_main_id_exit gt 0>
                        <cfprocparam cfsqltype="cf_sql_integer" value="#form_spec_main_id_exit#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
                    </cfif>
                    <cfif len(form_spect_name_exit)>
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#left(form_spect_name_exit,50)#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_varchar" value="NULL" null="yes">
                    </cfif>								
                    <cfif len(form_cost_id_exit) and (form_cost_id_exit neq 0)>
                        <cfprocparam cfsqltype="cf_sql_integer" value="#form_cost_id_exit#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
                    </cfif>
                    <cfif len(form_kdv_amount_exit)>
                        <cfprocparam cfsqltype="cf_sql_float" value="#form_kdv_amount_exit#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_float" value="0">
                    </cfif>
                    <cfif len(form_cost_price_system_exit)>
                        <cfprocparam cfsqltype="cf_sql_float" value="#form_cost_price_system_exit#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_float" value="0">
                    </cfif>
                    <cfif len(form_money_system_exit)>
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#form_money_system_exit#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#session_money#">
                    </cfif>
                    <cfif len(form_purchase_extra_cost_system_exit)>
                        <cfprocparam cfsqltype="cf_sql_float" value="#form_purchase_extra_cost_system_exit#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_float" value="0">
                    </cfif>
                    <cfif len(form_cost_price_system_exit) and len(form_amount_exit)>
                        <cfprocparam cfsqltype="cf_sql_float" value="#form_cost_price_system_exit*form_amount_exit#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_float" value="0">
                    </cfif>
                    <cfif len(form_cost_price_exit)>
                        <cfprocparam cfsqltype="cf_sql_float" value="#form_cost_price_exit#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_float" value="0">
                    </cfif>
                    <cfif len(form_money_exit)>
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#form_money_exit#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#session_money#" >
                    </cfif>
                    <cfif isdefined("form_cost_price_exit_2") and len(form_cost_price_exit_2)>
                        <cfprocparam cfsqltype="cf_sql_float" value="#form_cost_price_exit_2#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_float" value="0">
                    </cfif>
                    <cfif isdefined("form_cost_price_exit_extra_2") and len(form_cost_price_exit_extra_2)>
                        <cfprocparam cfsqltype="cf_sql_float" value="#form_cost_price_exit_extra_2#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_float" value="0">
                    </cfif>
                    <cfif isdefined("form_money_exit_2") and  len(form_money_exit_2)>
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#form_money_exit_2#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#session_money2#">
                    </cfif>
                    <cfif len(form_purchase_extra_cost_exit)>
                        <cfprocparam cfsqltype="cf_sql_float" value="#form_purchase_extra_cost_exit#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_float" value="0">
                    </cfif>
                    <cfif len(form_cost_price_exit)>
                        <cfprocparam cfsqltype="cf_sql_float" value="#form_cost_price_exit*form_amount_exit#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_float" value="0">
                    </cfif>
                    <cfif isdefined("attributes.product_name2_exit#st#")>
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#left(evaluate('attributes.product_name2_exit#st#'),250)#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_varchar" value="NULL" null="yes">
                    </cfif>
                    <cfif isdefined("attributes.is_add_info_#st#")>
                        <cfprocparam cfsqltype="cf_sql_bit" value="1">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_bit" value="0">
                    </cfif>
                    <cfif isdefined("attributes.is_free_amount#st#") and evaluate("attributes.is_free_amount#st#") eq 1>
                        <cfprocparam cfsqltype="cf_sql_bit" value="1">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_bit" value="0">
                    </cfif>
                    <cfprocparam cfsqltype="cf_sql_varchar" value="#wrk_row_id_sarf#">
					<cfif len(form_wrk_row_id_exit)>
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#form_wrk_row_id_exit#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_varchar" value="NULL" null="yes">
                    </cfif>
                    <cfif len(form_line_number_exit)>
                        <cfprocparam cfsqltype="cf_sql_integer" value="#form_line_number_exit#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_integer" value="0" null="yes">
                    </cfif>
					<cfprocparam cfsqltype="cf_sql_bit" value="#form_is_manual_cost_exit#">
					<cfif len(form_expiration_date_exit)>
						<cfprocparam cfsqltype="cf_sql_timestamp" value="#form_expiration_date_exit#">
					<cfelse>
						<cfprocparam cfsqltype="cf_sql_timestamp" value="NULL" null="yes">
					</cfif>
					<cfif len(width_exit)>
						<cfprocparam cfsqltype="cf_sql_float" value="#width_exit#">
					<cfelse>
						<cfprocparam cfsqltype="cf_sql_float" value="NULL" null="yes">
					</cfif>
					<cfif len(height_exit)>
						<cfprocparam cfsqltype="cf_sql_float" value="#height_exit#">
					<cfelse>
						<cfprocparam cfsqltype="cf_sql_float" value="NULL" null="yes">
					</cfif>
					<cfif len(length_exit)>
						<cfprocparam cfsqltype="cf_sql_float" value="#length_exit#">
					<cfelse>
						<cfprocparam cfsqltype="cf_sql_float" value="NULL" null="yes">
					</cfif>
					<cfif len(specific_weight_exit)><cfprocparam cfsqltype="cf_sql_float" value="#specific_weight_exit#"><cfelse><cfprocparam cfsqltype="cf_sql_float" value="0"></cfif>
					<cfif len(weight_exit)><cfprocparam cfsqltype="cf_sql_float" value="#weight_exit#"><cfelse><cfprocparam cfsqltype="cf_sql_float" value="0"></cfif>
                </cfstoredproc>
				<cfscript>
					if(not len(form_amount_exit))form_amount_exit=0;
					if(not len(form_cost_price_system_exit))form_cost_price_system_exit=0;
					if(not len(form_purchase_extra_cost_system_exit))form_purchase_extra_cost_system_exit=0;
					value_price = value_price + form_cost_price_system_exit * form_amount_exit;
					value_price_extra = value_price_extra + form_purchase_extra_cost_system_exit * form_amount_exit;
					value_price2 = value_price2 + form_cost_price_exit_2 * form_amount_exit;
					value_price_extra2 = value_price_extra2 + form_cost_price_exit_extra_2 * form_amount_exit;
					//writeoutput('Sarflar ___ value_price=#value_price#<br/>');
					//writeoutput('Sarflar ___ value_price_extra=#value_price_extra#<br/>');
				</cfscript>
			</cfif>
		</cfloop>
		 <!--- Sarflar değişti ise ve XML ayarlarından "Sarf değişikliklerinden spec değişssin" seçeneği seçilmiş ise spect değiştir --->
		<cfif attributes.record_num eq 1 and attributes.is_changed_spec_main eq 1>
			<!--- Sonuç kısmında ürün 1 tane ise yukarıda oluşturulan değişkenler ile önce sadece MAIN SPECT oluşturuluyor,daha sonra aşağıda formdan gelen sonuç 
			kısmındaki ürünün spect_main_id'si ile karşılaştırma yapılacak ve eğer fonksiyondan gelen main spect id formdan gelen ürünün main spect id'sinden 
			farklı ise(bu durumda ürünün sarfları değiştirilmiş demektir,eklenmiş çıkarılmış yada alternatifi seçilmiş olabilir.) aşağıdaki blokta fonksiyondan
			gelen main_spect_id'yi kullanarak yeni bir spect oluşturulacak ve bu yeni spect id ile üretim tabloları güncellenecek. --->
			<cfscript>
				a=specer(
				dsn_type : dsn3,
				spec_is_tree : 0,
				only_main_spec: 1,
				spec_row_count : m_row_count,
				spec_type : session_our_company_info_spect_type,
				main_stock_id : m_main_stock_id ,
				main_product_id : m_main_product_id,
				spec_name : m_spec_name,
				spec_total_value : m_spec_total_value,
				spec_other_total_value : m_spec_other_total_value,
				other_money : m_other_money,
				main_prod_price : m_main_prod_price,
				main_product_money:m_main_product_money,
				product_id_list : m_product_id_list,
				stock_id_list : m_stock_id_list,
				product_name_list:m_product_name_list,
				amount_list:m_amount_list,
				is_sevk_list:m_sevk_list,
				product_price_list:m_product_price_list,
				product_money_list:m_product_money_list,
				product_price_2_list:m_product_price_2_list,
				product_money_2_list:m_product_money_2_list,
				is_property_list:m_is_property_list,
				property_id_list : m_property_id_list,
				variation_id_list : m_variation_id_list,
				total_max_list : m_total_max_list,
				total_min_list : m_total_min_list,
				tolerance_list:m_tolerance_list,
				is_configure_list : m_is_configure_list,
				diff_price_list :m_diff_price_list,
				related_spect_id_list : m_related_spect_main_id_list
				);	
			</cfscript>
			<!--- Burda formdan gelen sonuç kısmındaki ürünün spect id'sini kullanarak hangi main_spect_id'ye bağlı olduğunu çekiyoruz --->
			<cfif not len(attributes.SPECT_ID1) and len(attributes.SPEC_MAIN_ID1)>
				<cfset SPECT_CHANGE_CONTROL.SPECT_MAIN_ID = attributes.SPEC_MAIN_ID1>
			<cfelseif len(attributes.SPECT_ID1)>
				<cfquery name="SPECT_CHANGE_CONTROL" datasource="#DSN3#">
					SELECT SPECT_MAIN_ID FROM SPECTS WHERE SPECT_VAR_ID = #attributes.SPECT_ID1#
				</cfquery>
			</cfif>
			<!--- Formdan gelen,sonuç kısmındaki ürünün spect_main_id'si yukarıdaki main spect oluşturan specer fonksiyonundan gelen main_spect_id'den farklı ise(sarf ürünleri değiştirilmiş anlamına geliyor)  --->
			<cfif isdefined("SPECT_CHANGE_CONTROL") and SPECT_CHANGE_CONTROL.SPECT_MAIN_ID neq listgetat(a,1,',')>
				<cfscript>
				//Buradada fonksiyondan gelen main_spect_id kullanılarak yeni bir spect_id oluşturuluyor
				main_to_spect = specer(
						dsn_type:dsn3,
						spec_type:session_our_company_info_spect_type,
						main_spec_id:listgetat(a,1,','),
						main_stock_id : m_main_stock_id ,
						main_product_id : m_main_product_id,
						spec_name : m_spec_name,
						add_to_main_spec:1
						
					);
				</cfscript>
				<!--- Oluşturulan yeni spect id ve ismi --->
				<cfset new_created_spect_main_id = listgetat(main_to_spect,1,',')>
				<cfset new_created_spect_id = listgetat(main_to_spect,2,',')>
				<cfset new_created_spect_name = listgetat(main_to_spect,3,',')>
			</cfif>
		</cfif>
	</cfif>
	<!---fireler kayıt ediliyor--->
	<cfif len(attributes.record_num_outage) and attributes.record_num_outage neq "">
		<cfloop from="1" to="#attributes.record_num_outage#" index="i">
			<cfif evaluate("attributes.row_kontrol_outage#i#")>
				<cfif len(evaluate("attributes.expiration_date_outage#i#"))>
					<cfset form_expiration_date_outage = evaluate("attributes.expiration_date_outage#i#")>
					<cf_date tarih="form_expiration_date_outage">
				<cfelse>
					<cfset form_expiration_date_outage ="">
				</cfif>
				<cfscript>
					if(isdefined("attributes.barcode_outage#i#"))
						form_barcode_outage = evaluate("attributes.barcode_outage#i#");
					else
						form_barcode_outage = '';
					if(isdefined("attributes.wrk_row_id_outage_#i#"))
						form_wrk_row_id_outage = evaluate("attributes.wrk_row_id_outage_#i#");
					else
						form_wrk_row_id_outage = "";
					if(isdefined("attributes.line_number_outage_#i#"))
						form_line_number_outage = evaluate("attributes.line_number_outage_#i#");
					else
						form_line_number_outage = "";	
					form_product_id_outage = evaluate("attributes.product_id_outage#i#");
					form_stock_id_outage = evaluate("attributes.stock_id_outage#i#");
					form_lot_no_outage = evaluate("attributes.lot_no_outage#i#");
					form_amount_outage = evaluate("attributes.amount_outage#i#");
					if(isdefined("attributes.amount_outage2_#i#"))
						form_amount_outage2_ = evaluate("attributes.amount_outage2_#i#");
					else
						form_amount_outage2_ ='';	
					form_unit_id_outage = evaluate("attributes.unit_id_outage#i#");
					if(isdefined("attributes.unit2_outage#i#"))
						form_unit2_outage = evaluate("attributes.unit2_outage#i#");
					else
						form_unit2_outage = '';
					form_serial_no_outage = evaluate("attributes.serial_no_outage#i#");
					form_kdv_amount_outage = evaluate("attributes.kdv_amount_outage#i#");
					form_spect_id_outage = evaluate("attributes.spect_id_outage#i#");
					form_spec_main_id_outage = evaluate("attributes.spec_main_id_outage#i#");
					form_spect_name_outage = evaluate("attributes.spect_name_outage#i#");
					form_outage_unit = evaluate("attributes.unit_outage#i#");
					form_outage_product_name = evaluate("attributes.product_name_outage#i#");
					
					form_cost_id_outage = evaluate("attributes.cost_id_outage#i#");
					form_product_cost_outage=evaluate("attributes.product_cost_outage#i#");
					form_product_cost_money_outage=evaluate("attributes.product_cost_money_outage#i#");
					form_kdv_amount_outage=evaluate("attributes.kdv_amount_outage#i#");
					form_cost_price_system_outage=evaluate("attributes.cost_price_system_outage#i#");
					form_purchase_extra_cost_system_outage=evaluate("attributes.purchase_extra_cost_system_outage#i#");
					form_purchase_extra_cost_outage=evaluate("attributes.purchase_extra_cost_outage#i#");
					form_money_system_outage=evaluate("attributes.money_system_outage#i#");
					form_cost_price_outage=evaluate("attributes.cost_price_outage#i#");
					form_money_outage=evaluate("attributes.money_outage#i#");
					if (isdefined("attributes.is_manual_cost_outage#i#") and evaluate("attributes.is_manual_cost_outage#i#") eq 1)
						form_is_manual_cost_outage = evaluate("attributes.is_manual_cost_outage#i#");
					else
						form_is_manual_cost_outage = 0;
					if(isdefined("attributes.cost_price_outage_2#i#"))
					{
						form_cost_price_outage_2=evaluate("attributes.cost_price_outage_2#i#");
						form_cost_price_outage_extra_2 = evaluate("attributes.purchase_extra_cost_outage_2#i#");
						form_money_outage_2=evaluate("attributes.money_outage_2#i#");
					}
					else
					{
						form_cost_price_outage_2=0;
						form_cost_price_outage_extra_2=0;
						form_money_outage_2='';
					}
					if(isdefined("attributes.width_outage#i#"))
					width_outage = evaluate("attributes.width_outage#i#");
					else
					width_outage = '';
					if(isdefined("attributes.height_outage#i#"))
					height_outage = evaluate("attributes.height_outage#i#");
					else
					height_outage = '';
					if(isdefined("attributes.length_outage#i#"))
					length_outage = evaluate("attributes.length_outage#i#");
					else
					length_outage = '';
					if(isdefined("attributes.specific_weight_outage#i#"))
					specific_weight_outage = evaluate("attributes.specific_weight_outage#i#");
					else
					specific_weight_outage = '';
					if(isdefined("attributes.weight_outage#i#"))
					weight_outage = evaluate("attributes.weight_outage#i#");
					else
					weight_outage = '';
				</cfscript>
                <cfif isDefined('session.ep.userid')>
					<cfset wrk_row_id_fire = 'WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##get_max2.max_id##form_stock_id_outage#_3'>
				<cfelseif isDefined('session.pda.userid')>
					<cfset wrk_row_id_fire = 'WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.pda.userid##round(rand()*100)##get_max2.max_id##form_stock_id_outage#_3'>                
                </cfif>
                <!--- Fire --->
                <cfstoredproc procedure="ADD_PRODUCTION_ORDER_RESULTS_ROW_O" datasource="#dsn3#">
                    <cfprocparam cfsqltype="cf_sql_integer" value="3">
                    <cfprocparam cfsqltype="cf_sql_integer" value="#get_max2.max_id#">
                    <cfif isdefined("form_barcode_outage") and len(form_barcode_outage)>
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#form_barcode_outage#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_varchar" value="NULL" null="yes">
                    </cfif>
                    <cfif len(form_stock_id_outage)>
                        <cfprocparam cfsqltype="cf_sql_integer" value="#form_stock_id_outage#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
                    </cfif>
                    <cfif len(form_product_id_outage)>
                        <cfprocparam cfsqltype="cf_sql_integer" value="#form_product_id_outage#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
                    </cfif>
                    <cfif len(form_lot_no_outage)>
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#form_lot_no_outage#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_varchar" value="NULL" null="yes">
                    </cfif>
                    <cfif len(form_amount_outage)>
                        <cfprocparam cfsqltype="cf_sql_float" value="#form_amount_outage#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_float" value="NULL" null="yes">
                    </cfif>
                    <cfif len(form_amount_outage2_) and len(form_unit2_outage)>
                        <cfprocparam cfsqltype="cf_sql_float" value="#form_amount_outage2_#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_float" value="NULL" null="yes">
                    </cfif>
                    <cfif len(form_unit_id_outage)>
                        <cfprocparam cfsqltype="cf_sql_integer" value="#form_unit_id_outage#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
                    </cfif>
                    <cfif len(form_unit2_outage)>
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#form_unit2_outage#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_varchar" value="NULL" null="yes">
                    </cfif>
                    <cfif len(form_serial_no_outage)>
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#form_serial_no_outage#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_varchar" value="NULL" null="yes">
                    </cfif>
                    <cfprocparam cfsqltype="cf_sql_varchar" value="#left(form_outage_product_name,75)#">
                    <cfprocparam cfsqltype="cf_sql_varchar" value="#left(form_outage_unit,75)#">
                    <cfprocparam cfsqltype="cf_sql_bit" value="0">
                    <cfif len(form_spect_id_outage)>
                        <cfprocparam cfsqltype="cf_sql_integer" value="#form_spect_id_outage#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
                    </cfif>
                    <cfif len(form_spec_main_id_outage)>
                        <cfprocparam cfsqltype="cf_sql_integer" value="#form_spec_main_id_outage#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
                    </cfif>
                    <cfif len(form_spect_name_outage)>
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#left(form_spect_name_outage,50)#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_varchar" value="NULL" null="yes">
                    </cfif>								
                    <cfif len(form_cost_id_outage) and (form_cost_id_outage neq 0)>
                        <cfprocparam cfsqltype="cf_sql_integer" value="#form_cost_id_outage#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
                    </cfif>
                    <cfif len(form_kdv_amount_outage)>
                        <cfprocparam cfsqltype="cf_sql_float" value="#form_kdv_amount_outage#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_float" value="0">
                    </cfif>
                    <cfif len(form_cost_price_system_outage)>
                        <cfprocparam cfsqltype="cf_sql_float" value="#form_cost_price_system_outage#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_float" value="0">
                    </cfif>
                    <cfif len(form_money_system_outage)>
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#form_money_system_outage#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#session_money#">
                    </cfif>
                    <cfif len(form_purchase_extra_cost_system_outage)>
                        <cfprocparam cfsqltype="cf_sql_float" value="#form_purchase_extra_cost_system_outage#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_float" value="0">
                    </cfif>
                    <cfif len(form_cost_price_system_outage) and len(form_amount_outage)>
                        <cfprocparam cfsqltype="cf_sql_float" value="#form_cost_price_system_outage*form_amount_outage#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_float" value="0">
                    </cfif>,
                    <cfif len(form_cost_price_outage)>
                        <cfprocparam cfsqltype="cf_sql_float" value="#form_cost_price_outage#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_float" value="0">
                    </cfif>
                    <cfif len(form_money_outage)>
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#form_money_outage#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#session_money#"> 
                    </cfif>
                    <cfif isdefined("form_cost_price_outage_2") and len(form_cost_price_outage_2)>
                        <cfprocparam cfsqltype="cf_sql_float" value="#form_cost_price_outage_2#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_float" value="0">
                    </cfif>
                    <cfif isdefined("form_cost_price_outage_extra_2") and len(form_cost_price_outage_extra_2)>
                        <cfprocparam cfsqltype="cf_sql_float" value="#form_cost_price_outage_extra_2#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_float" value="0">
                    </cfif>
                    <cfif isdefined("form_money_outage_2") and len(form_money_outage_2)>
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#form_money_outage_2#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#session_money2#">
                    </cfif>
                    <cfif len(form_purchase_extra_cost_outage)>
                        <cfprocparam cfsqltype="cf_sql_float" value="#form_purchase_extra_cost_outage#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_float" value="0">
                    </cfif>
                    <cfif len(form_cost_price_outage)>
                        <cfprocparam cfsqltype="cf_sql_float" value="#form_cost_price_outage*form_amount_outage#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_float" value="0">
                    </cfif>
                    <cfif isdefined("attributes.product_name2_outage#i#")>
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#left(evaluate('attributes.product_name2_outage#i#'),250)#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_varchar" value="NULL" null="yes">
                    </cfif>
                    <cfprocparam cfsqltype="cf_sql_varchar" value="#wrk_row_id_fire#">
					<cfif len(form_wrk_row_id_outage)>
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#form_wrk_row_id_outage#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_varchar" value="NULL" null="yes">
                    </cfif>
					<cfif len(form_line_number_outage)>
                        <cfprocparam cfsqltype="cf_sql_integer" value="#form_line_number_outage#">
                    <cfelse>
                        <cfprocparam cfsqltype="cf_sql_integer" value="0" null="yes">
                    </cfif>
					<cfprocparam cfsqltype="cf_sql_bit" value="#form_is_manual_cost_outage#">
					<cfif len(form_expiration_date_outage)>
						<cfprocparam cfsqltype="cf_sql_timestamp" value="#form_expiration_date_outage#">
					<cfelse>
						<cfprocparam cfsqltype="cf_sql_timestamp" value="NULL" null="yes">
					</cfif>
					<cfif len(width_outage)>
						<cfprocparam cfsqltype="cf_sql_float" value="#width_outage#">
					<cfelse>
						<cfprocparam cfsqltype="cf_sql_float" value="NULL" null="yes">
					</cfif>
					<cfif len(height_outage)>
						<cfprocparam cfsqltype="cf_sql_float" value="#height_outage#">
					<cfelse>
						<cfprocparam cfsqltype="cf_sql_float" value="NULL" null="yes">
					</cfif>
					<cfif len(length_outage)>
						<cfprocparam cfsqltype="cf_sql_float" value="#length_outage#">
					<cfelse>
						<cfprocparam cfsqltype="cf_sql_float" value="NULL" null="yes">
					</cfif>
					<cfif len(specific_weight_outage)><cfprocparam cfsqltype="cf_sql_float" value="#specific_weight_outage#"><cfelse><cfprocparam cfsqltype="cf_sql_float" value="0"></cfif>
					<cfif len(weight_outage)><cfprocparam cfsqltype="cf_sql_float" value="#weight_outage#"><cfelse><cfprocparam cfsqltype="cf_sql_float" value="0"></cfif>
                </cfstoredproc>
				<cfscript>
					if(not len(form_amount_outage))form_amount_outage=0;
					if(not len(form_cost_price_system_outage))form_cost_price_system_outage=0;
					if(not len(form_purchase_extra_cost_system_outage))form_purchase_extra_cost_system_outage=0;
					value_price = value_price + form_cost_price_system_outage * form_amount_outage;
					value_price_extra = value_price_extra + form_purchase_extra_cost_system_outage * form_amount_outage;
					value_price2 = value_price2 + form_cost_price_outage_2 * form_amount_outage;
					value_price_extra2 = value_price_extra2 + form_cost_price_outage_extra_2 * form_amount_outage;
				</cfscript>
			</cfif>
		</cfloop>
	</cfif>
	<cfquery name="get_prod_order" datasource="#dsn3#">
		SELECT STOCK_ID FROM PRODUCTION_ORDERS WHERE P_ORDER_ID = #attributes.p_order_id#
	</cfquery> 
	<cfif len(attributes.record_num) and attributes.record_num neq "">
		<cfset record_num_ = 0>
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif evaluate("attributes.row_kontrol#i#") and not(isdefined("attributes.is_free_amount_#i#") and len(evaluate("attributes.is_free_amount_#i#")) and evaluate("attributes.is_free_amount_#i#")) and evaluate("attributes.stock_id#i#") eq get_prod_order.stock_id>
				<cfset record_num_ = record_num_ + 1>
			</cfif>
		</cfloop>
		<cfif attributes.is_demontaj neq 1>
			<cfscript>
				total_cost=0;
				total_cost2=0;
				if(record_num_ GT 1)
				for(j=1;j lte attributes.record_num;j=j+1)
				{
					if(evaluate("attributes.row_kontrol#j#"))
					{		
						form_amount_1 = evaluate("attributes.amount#j#");
						form_cost_price_system_1 = evaluate("attributes.cost_price_system#j#");
						if(not len(form_cost_price_system_1))form_cost_price_system_1=0;
						total_cost=total_cost+(form_cost_price_system_1*form_amount_1);
						if(isdefined("attributes.cost_price_2#j#"))
						{
							form_cost_price_system_2 = evaluate("attributes.cost_price_2#j#");
							if(not len(form_cost_price_system_2))form_cost_price_system_2=0;
							total_cost2=total_cost2+(form_cost_price_system_2*form_amount_1);
						}
					}
				}
				else
				{
					total_cost=100;
					total_cost2=100;
				}// ürün tek satirsa sarflarin maliyetinin tüm miktarını o ürüne yazar
				if(total_cost gt 0)
				{
					birim_cost=value_price/total_cost;
					birim_cost_extra=value_price_extra/total_cost;
					//writeoutput('birim_cost=#birim_cost#===value_price=#value_price#/100(total_cost)');
					//writeoutput('birim_cost_extra=#birim_cost_extra#===value_price_extra=#value_price_extra#/100(total_cost)');
				}
				else
				{
					birim_cost=0;
					birim_cost_extra=0;
				}
				if(total_cost2 gt 0)
				{
					birim_cost2=value_price2/total_cost2;
					birim_cost_extra2=value_price_extra2/total_cost2;
				}
				else
				{
					birim_cost2=0;
					birim_cost_extra2=0;
				}
			</cfscript>
		<cfelse>
			<cfset birim_cost=1>
			<cfset birim_cost_extra=1>
			<cfset birim_cost2=1>
			<cfset birim_cost_extra2=1>
		</cfif>
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif evaluate("attributes.row_kontrol#i#")>
				<cfscript>
					form_tree_type = evaluate("attributes.tree_type_#i#");
					if(isdefined("attributes.barcode#i#"))
						form_barcode = evaluate("attributes.barcode#i#");
					else
						form_barcode = '';
					if(isdefined("attributes.wrk_row_id_#i#"))
						wrk_row_id = evaluate("attributes.wrk_row_id_#i#");
					else
						wrk_row_id = '';
					if(isdefined("attributes.fire_amount_#i#"))
						fire_amount_ = evaluate("attributes.fire_amount_#i#");
					else
						fire_amount_ = 0;
					form_product_id = evaluate("attributes.product_id#i#");
					form_stock_id = evaluate("attributes.stock_id#i#");
					form_amount = evaluate("attributes.amount#i#");
					if(isdefined("attributes.amount2_#i#"))
						form_amount2 = evaluate("attributes.amount2_#i#");
					else
						form_amount2 = '';
					form_unit_id = evaluate("attributes.unit_id#i#");
					if(isdefined("attributes.unit2#i#"))
					form_unit2 = evaluate("attributes.unit2#i#");
					else
					form_unit2 ='';
					if(isdefined("attributes.width#i#"))
					width = evaluate("attributes.width#i#");
					else
					width = '';
					if(isdefined("attributes.height#i#"))
					height = evaluate("attributes.height#i#");
					else
					height = '';
					if(isdefined("attributes.length#i#"))
					length = evaluate("attributes.length#i#");
					else
					length = '';
					if(isdefined("attributes.specific_weight#i#"))
					specific_weight = evaluate("attributes.specific_weight#i#");
					else
					specific_weight = '';
					if(isdefined("attributes.weight#i#"))
					weight = evaluate("attributes.weight#i#");
					else
					weight = '';
					if(isdefined("attributes.work_id#i#"))
					work_id = evaluate("attributes.work_id#i#");
					else
					work_id = '';
					if(isdefined("attributes.work_head#i#"))
					work_head = evaluate("attributes.work_head#i#");
					else
					work_head = '';
					form_unit = evaluate("attributes.unit#i#");
					form_kdv_amount = evaluate("attributes.kdv_amount#i#");
					form_product_name = evaluate("attributes.product_name#i#");
					form_spect_name = evaluate("attributes.spect_name#i#");
					form_spect_id = evaluate("attributes.spect_id#i#");
					form_spec_main_id = evaluate("attributes.SPEC_MAIN_ID#i#");
					form_cost_id = evaluate("attributes.cost_id#i#");
					form_product_cost=evaluate("attributes.product_cost#i#");
					form_product_cost_money=evaluate("attributes.product_cost_money#i#");
					form_kdv_amount=evaluate("attributes.kdv_amount#i#");
					form_cost_price_system=evaluate("attributes.cost_price_system#i#");
					form_purchase_extra_cost_system=evaluate("attributes.purchase_extra_cost_system#i#");
					form_purchase_extra_cost=evaluate("attributes.purchase_extra_cost#i#");
					form_money_system=evaluate("attributes.money_system#i#");
					form_cost_price=evaluate("attributes.cost_price#i#");
					form_money=evaluate("attributes.money#i#");
					if(isdefined("attributes.cost_price_2#i#"))
					{
						form_cost_price_2=evaluate("attributes.cost_price_2#i#");
						if (isdefined("attributes.cost_price_extra_2#i#"))
							form_cost_price_extra_2=evaluate("attributes.cost_price_extra_2#i#");
						else
							form_cost_price_extra_2=0;
						form_money_2=evaluate("attributes.money_2#i#");
					}
					else
					{
						form_cost_price_2=0;
						form_cost_price_extra_2=0;
						form_money_2='';
					}
					if(not (isdefined("attributes.is_free_amount_#i#") and evaluate("attributes.is_free_amount_#i#")) and form_stock_id eq get_prod_order.stock_id)
					{
						if(record_num_ eq 1 and is_demontaj eq 0)
						{
							form_cost_price_system=100;
							form_purchase_extra_cost_system=100;
							form_cost_price_2=100;
							form_cost_price_extra_2=100;
						}// sonuc ürünü tek satir oldugunda total_cost 100 atandıgı için burdada 100 atanıyor maliyetin tamamı bu ürüne yazıyor
						else 
						{
							if(not len(form_cost_price_system))form_cost_price_system=0;
							if(not len(form_cost_price_2))form_cost_price_2=0;
							if(not len(form_cost_price_extra_2))form_cost_price_extra_2=0;
						}
						if(record_num_ eq 1)
						{//bir üretim soncu varsa maliyet adede bölünüyorki birim maliyet bulunsun
							deger_value_price=(birim_cost*form_cost_price_system)/form_amount;
							deger_value_price_extra=(birim_cost_extra*form_purchase_extra_cost_system)/form_amount;
							deger_value_price2=(birim_cost2*form_cost_price_2)/form_amount;
							deger_value_price_extra2=(birim_cost_extra2*form_cost_price_extra_2)/form_amount;
							//writeoutput('deger_value_price=(birim_cost*form_cost_price_system)/form_amount<br/>deger_value_price=(#birim_cost#*#form_cost_price_system#)/#form_amount#');	
						}
						else
						{
							deger_value_price=(birim_cost*form_cost_price_system);
							deger_value_price_extra=(birim_cost_extra*form_purchase_extra_cost_system);
							deger_value_price2=(birim_cost2*form_cost_price_2);
							deger_value_price_extra2=(birim_cost_extra2*form_cost_price_extra_2);
						}
						deger_value_total_price = deger_value_price * form_amount;
					}
					else if(isdefined("attributes.is_free_amount_#i#") and evaluate("attributes.is_free_amount_#i#"))
					{
						deger_value_price=(form_cost_price_system);
						deger_value_price_extra=(form_purchase_extra_cost_system);
						deger_value_price2=(form_cost_price_2);
						deger_value_price_extra2=(form_cost_price_extra_2);
					}
					else
					{
						deger_value_price=(form_cost_price_system);
						deger_value_price_extra=(form_purchase_extra_cost_system);
						deger_value_price2=(form_cost_price_2);
						deger_value_price_extra2=(form_cost_price_extra_2);
					}
					//writeoutput('deger_value_total_price = #deger_value_price# * #form_amount#_______deger_value_total_price=#deger_value_total_price#<br/>');
					//writeoutput('Son Olarak Bulunan deger_value_price=#deger_value_price# PURCHASE_NET_SYSTEM alanına yazılıyor...<br/> ve deger_value_total_price =#deger_value_total_price# değeride PURCHASE_NET_SYSTEM_TOTAL alanına yazılıyor.. ');
				</cfscript>
                <cfif isDefined('session.ep.userid')>
					<cfset wrk_row_id_ = 'WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##get_max2.max_id##form_stock_id#_1'>
				<cfelseif isDefined('session.pda.userid')>
					<cfset wrk_row_id_ = 'WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.pda.userid##round(rand()*100)##get_max2.max_id##form_stock_id#_1'>                
                </cfif>
				<cfstoredproc procedure="ADD_PRODUCTION_ORDER_RESULTS_ROW" datasource="#dsn3#">	
                    <cfprocparam cfsqltype="cf_sql_varchar" value="#form_tree_type#"><!--- EĞER S GELİRSE NORMAL SARF P GELİRSE  PHANTOM ÜRÜN'ÜN İÇERİĞİNDEN  O GELİRSE OPERASYONUN ALTINDAN GELEN ÜRÜN ANLAMAINA GELMEKTEDİR. --->
                    <cfprocparam cfsqltype="cf_sql_integer" value="1">
                    <cfprocparam cfsqltype="cf_sql_varchar" value="#get_max2.max_id#">
                    <cfif isdefined("form_barcode") and len(form_barcode)><cfprocparam cfsqltype="cf_sql_varchar" value="#form_barcode#"><cfelse><cfprocparam cfsqltype="cf_sql_varchar" value="NULL"></cfif>
                    <cfif len(form_stock_id)><cfprocparam cfsqltype="cf_sql_integer" value="#form_stock_id#"><cfelse><cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes"></cfif>
                    <cfif len(form_product_id)><cfprocparam cfsqltype="cf_sql_integer" value="#form_product_id#"><cfelse><cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes"></cfif>
                    <cfif len(form_amount)><cfprocparam cfsqltype="cf_sql_float" value="#form_amount#"><cfelse><cfprocparam cfsqltype="cf_sql_float" value="NULL" null="yes"></cfif>
                    <cfif len(form_amount2) and len(form_amount2)><cfprocparam cfsqltype="cf_sql_float" value="#form_amount2#"><cfelse><cfprocparam cfsqltype="cf_sql_float" value="NULL" null="yes"></cfif>,
                    <cfif len(form_unit_id)><cfprocparam cfsqltype="cf_sql_integer" value="#form_unit_id#"><cfelse><cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes"></cfif>
                    <cfif len(form_unit2)><cfprocparam cfsqltype="cf_sql_varchar" value="#form_unit2#"><cfelse><cfprocparam cfsqltype="cf_sql_varchar" value="NULL"></cfif>
                    <cfprocparam cfsqltype="cf_sql_varchar" value="#left(form_product_name,75)#">
                    <cfprocparam cfsqltype="cf_sql_varchar" value="#left(form_unit,75)#">
                    <cfif len(form_spect_id)><cfprocparam cfsqltype="cf_sql_integer" value="#form_spect_id#"><cfelse><cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes"></cfif>
                    <cfif len(form_spec_main_id)><cfprocparam cfsqltype="cf_sql_integer" value="#form_spec_main_id#"><cfelse><cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes"></cfif>
                    <cfif len(form_spect_name)><cfprocparam cfsqltype="cf_sql_varchar" value="#left(form_spect_name,50)#"><cfelse><cfprocparam cfsqltype="cf_sql_varchar" value="NULL"></cfif>								
                    <cfif len(form_cost_id) and (form_cost_id neq 0)><cfprocparam cfsqltype="cf_sql_integer" value="#form_cost_id#"><cfelse><cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes"></cfif>
                    <cfif len(form_kdv_amount)><cfprocparam cfsqltype="cf_sql_float" value="#form_kdv_amount#"><cfelse><cfprocparam cfsqltype="cf_sql_float" value="0"></cfif>
                    <cfif len(deger_value_price)><cfprocparam cfsqltype="cf_sql_float" value="#deger_value_price#"><cfelse><cfprocparam cfsqltype="cf_sql_float" value="0"></cfif>
                    <cfif len(form_money_system)><cfprocparam cfsqltype="cf_sql_varchar" value="#form_money_system#"><cfelse><cfprocparam cfsqltype="cf_sql_varchar" value="#session_money#"></cfif>
                    <cfif len(deger_value_price_extra)><cfprocparam cfsqltype="cf_sql_float" value="#deger_value_price_extra#"><cfelse><cfprocparam cfsqltype="cf_sql_float" value="0"></cfif>
                    <cfif isdefined("deger_value_total_price") and len(deger_value_total_price)><cfprocparam cfsqltype="cf_sql_float" value="#deger_value_total_price#"><cfelse><cfprocparam cfsqltype="cf_sql_float" value="0"></cfif>
                    <cfif len(form_cost_price)><cfprocparam cfsqltype="cf_sql_float" value="#form_cost_price#"><cfelse><cfprocparam cfsqltype="cf_sql_float" value="0"></cfif>
                    <cfif len(form_money)><cfprocparam cfsqltype="cf_sql_varchar" value="#form_money#"><cfelse><cfprocparam cfsqltype="cf_sql_varchar" value="#session_money#"></cfif>
                    <cfif isdefined("deger_value_price2") and len(deger_value_price2)><cfprocparam cfsqltype="cf_sql_float" value="#deger_value_price2#"><cfelse><cfprocparam cfsqltype="cf_sql_float" value="0"></cfif>,
                    <cfif isdefined("deger_value_price_extra2") and len(deger_value_price_extra2)><cfprocparam cfsqltype="cf_sql_float" value="#deger_value_price_extra2#"><cfelse><cfprocparam cfsqltype="cf_sql_float" value="0"></cfif>,
                    <cfif isdefined("form_money_2") and len(form_money_2)><cfprocparam cfsqltype="cf_sql_varchar" value="#form_money_2#"><cfelse><cfprocparam cfsqltype="cf_sql_varchar" value="#session_money2#"></cfif>
                    <cfif len(form_purchase_extra_cost)><cfprocparam cfsqltype="cf_sql_float" value="#form_purchase_extra_cost#"><cfelse><cfprocparam cfsqltype="cf_sql_float" value="0"></cfif>
                    <cfif len(form_cost_price) and len(form_amount)><cfprocparam cfsqltype="cf_sql_float" value="#form_cost_price*form_amount#"><cfelse><cfprocparam cfsqltype="cf_sql_float" value="0"></cfif>,
                    <cfif isdefined("attributes.product_name2#i#")><cfprocparam cfsqltype="cf_sql_varchar" value="#left(evaluate('attributes.product_name2#i#'),250)#"><cfelse><cfprocparam cfsqltype="cf_sql_varchar" value="NULL"></cfif>
                    <cfif len(fire_amount_)><cfprocparam cfsqltype="cf_sql_float" value="#fire_amount_#"><cfelse><cfprocparam cfsqltype="cf_sql_float" value="0"></cfif>
                    <cfif isdefined("attributes.is_free_amount_#i#") and evaluate("attributes.is_free_amount_#i#")><cfprocparam cfsqltype="cf_sql_bit" value="1"><cfelse><cfprocparam cfsqltype="cf_sql_bit" value="0"></cfif>
                    <cfprocparam cfsqltype="cf_sql_varchar" value="#wrk_row_id_#">
                    <cfif len(wrk_row_id)><cfprocparam cfsqltype="cf_sql_varchar" value="#wrk_row_id#"><cfelse><cfprocparam cfsqltype="cf_sql_varchar" value="NULL"></cfif>
					<cfif len(width)><cfprocparam cfsqltype="cf_sql_float" value="#width#"><cfelse><cfprocparam cfsqltype="cf_sql_float" value="0"></cfif>
					<cfif len(height)><cfprocparam cfsqltype="cf_sql_float" value="#height#"><cfelse><cfprocparam cfsqltype="cf_sql_float" value="0"></cfif>
					<cfif len(length)><cfprocparam cfsqltype="cf_sql_float" value="#length#"><cfelse><cfprocparam cfsqltype="cf_sql_float" value="0"></cfif>
					<cfif len(specific_weight)><cfprocparam cfsqltype="cf_sql_float" value="#specific_weight#"><cfelse><cfprocparam cfsqltype="cf_sql_float" value="0"></cfif>
					<cfif len(weight)><cfprocparam cfsqltype="cf_sql_float" value="#weight#"><cfelse><cfprocparam cfsqltype="cf_sql_float" value="0"></cfif>
					<cfif len(work_id)><cfprocparam cfsqltype="cf_sql_integer" value="#work_id#"><cfelse><cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes"></cfif>
					<cfif len(work_head)><cfprocparam cfsqltype="cf_sql_varchar" value="#work_head#"><cfelse><cfprocparam cfsqltype="cf_sql_varchar" value="NULL" null="yes"></cfif>
					</cfstoredproc>                
				<!--- Özellik --->
			</cfif>
		</cfloop>
	</cfif>
	<cfif isdefined('new_created_spect_id')><!--- Eğer ana ürün için yeni bir spect id oluşmuş ise --->
        <cfstoredproc procedure="UPD_PROD_ORDER_SPECT" datasource="#dsn3#">
        	<cfprocparam cfsqltype="cf_sql_integer" value="#new_created_spect_id#">
            <cfprocparam cfsqltype="cf_sql_varchar" value="#new_created_spect_name#">
            <cfprocparam cfsqltype="cf_sql_integer" value="#new_created_spect_main_id#">
            <cfprocparam cfsqltype="cf_sql_integer" value="#attributes.p_order_id#">
        </cfstoredproc>

        <cfstoredproc procedure="UPD_PROD_ORDER_ROW_SPECT" datasource="#dsn3#">
        	<cfprocparam cfsqltype="cf_sql_integer" value="#new_created_spect_id#">
            <cfprocparam cfsqltype="cf_sql_varchar" value="#new_created_spect_name#">
            <cfprocparam cfsqltype="cf_sql_integer" value="#new_created_spect_main_id#">
            <cfprocparam cfsqltype="cf_sql_integer" value="#get_max2.max_id#">
        </cfstoredproc>
        
		<cfif isdefined('attributes.ORDER_ROW_ID') and ListLen(attributes.ORDER_ROW_ID,',')>
			<!--- Buraya girerse bu üretim sipariş ile ilişkilidir demektir,bu sebeble oluşan yeni spect_var_id için siparişide güncelliyoruz. --->
			<cfloop from="1" to="#ListLen(attributes.ORDER_ROW_ID,',')#" index="i_in_d">
				<cfquery name="UPD_ORDERS" datasource="#dsn3#">
					UPDATE ORDER_ROW SET SPECT_VAR_ID = #new_created_spect_id# WHERE ORDER_ROW_ID = #ListGetAt(attributes.ORDER_ROW_ID,i_in_d,',')# 
				</cfquery>
			</cfloop>
		</cfif>
	</cfif>
	<cfquery name="GET_PROCESS_TYPE" datasource="#dsn3#">
		SELECT 
			PROCESS_TYPE,
			IS_ACCOUNT,
			IS_ACCOUNT_GROUP,
			ACTION_FILE_NAME,
			ACTION_FILE_FROM_TEMPLATE,
			ISNULL(IS_DEPT_BASED_ACC,0) IS_DEPT_BASED_ACC
		 FROM 
			SETUP_PROCESS_CAT 
		WHERE 
			PROCESS_CAT_ID = #form.process_cat#
	</cfquery>
	<cfif isDefined("session.ep")><!--- PDA de gelmemesi icin --->
		<cfscript>
			if(GET_PROCESS_TYPE.IS_ACCOUNT eq 1)
			{
				is_dept_based_acc = GET_PROCESS_TYPE.IS_DEPT_BASED_ACC;
				include('prod_order_result_account_process.cfm');
				muhasebeci(
					action_id : get_max2.max_id,
					workcube_process_type : get_process_type.process_type,
					workcube_process_cat : form.process_cat,
					muhasebe_db : '#dsn3#',
					account_card_type : 13,
					islem_tarihi : account_action_date,
					borc_hesaplar : str_borclu_hesaplar,
					borc_tutarlar : str_borc_tutar,
					other_amount_borc : str_borc_dovizli,
					other_currency_borc : str_other_currency_borc,
					alacak_hesaplar : str_alacakli_hesaplar,
					alacak_tutarlar : str_alacak_tutar,
					other_amount_alacak : str_alacak_dovizli,
					other_currency_alacak :str_other_currency_alacak,
					to_branch_id : to_branch_id,
					fis_detay : 'ÜRETİM SONUCU',
					fis_satir_detay : 'Üretim Sonucu',
					belge_no : form.production_result_no,
					is_account_group : get_process_type.is_account_group,
					acc_project_id : iif((isdefined("attributes.project_id") and len(attributes.project_id) and isDefined("attributes.project_name") and len(attributes.project_name)),attributes.project_id,de(''))
				);
			}
		</cfscript>
	</cfif>
    <!--- üRETİMİN AŞAMSINI DEĞİŞTİRİYORUZ. --->	
	<cfquery name="get_result_amount" datasource="#dsn3#">
		SELECT
			ISNULL(SUM(POR_.AMOUNT),0) RESULT_AMOUNT
		FROM
			PRODUCTION_ORDER_RESULTS_ROW POR_,
			PRODUCTION_ORDER_RESULTS POO
		WHERE
			POR_.PR_ORDER_ID = POO.PR_ORDER_ID
			AND POO.P_ORDER_ID = #attributes.p_order_id#
			AND POR_.TYPE = 1
			AND POO.IS_STOCK_FIS = 1
			AND POR_.SPEC_MAIN_ID IN (SELECT PRODUCTION_ORDERS.SPEC_MAIN_ID FROM PRODUCTION_ORDERS WHERE PRODUCTION_ORDERS.P_ORDER_ID = POO.P_ORDER_ID)
	</cfquery>
     <cfquery name="upd_prod_orders" datasource="#dsn3#">
        UPDATE PRODUCTION_ORDERS SET IS_STAGE = 2,RESULT_AMOUNT=#get_result_amount.RESULT_AMOUNT# WHERE P_ORDER_ID = #attributes.p_order_id#<!--- 1 ATIYORUZ ÇÜNKÜ ÜRETİM BAŞLAMIŞ OLUYOR. --->
    </cfquery>
	<cfif len(get_process_type.action_file_name)><!--- secilen islem kategorisine bir action file eklenmisse --->
		<cf_workcube_process_cat 
			process_cat="#form.process_cat#"
			action_id = #get_max2.max_id#
			is_action_file = 1
			action_file_name='#get_process_type.action_file_name#'
			action_page='#request.self#?fuseaction=prod.list_results&event=upd&p_order_id=#attributes.p_order_id#&pr_order_id=#get_max2.max_id#'
			action_db_type = '#dsn3#'
			is_template_action_file = '#get_process_type.action_file_from_template#'>
	</cfif>
	</cftransaction>
</cflock>
 <cf_workcube_process 
	is_upd='1' 
	old_process_line='0'
	process_stage='#attributes.process_stage#' 
	record_member='#session_userid#' 
	record_date='#now()#' 
	action_page='#request.self#?fuseaction=prod.list_results&event=upd&p_order_id=#attributes.p_order_id#&pr_order_id=#get_max2.max_id#' 
	action_id='#get_max2.max_id#'
	action_table='PRODUCTION_ORDER_RESULTS'
	action_column='PR_ORDER_ID'
	warning_description = 'Üretim Sonucu : #attributes.production_order_no#'>
	<cf_add_log  log_type="1" action_id="#get_max2.max_id#" action_name="#attributes.production_order_no#" paper_no="#attributes.production_result_no#" data_source="#dsn3#" process_stage="#attributes.process_stage#">
	<cfset attributes.actionId = get_max2.max_id>
	<cfif isDefined("session.ep") and not isdefined("attributes.from_order_operator")><!--- Pda de Gelmemesi Icin --->
        <script type="text/javascript">
			console.log("<cfoutput>#request.self#?fuseaction=prod.list_results&event=upd&p_order_id=#attributes.p_order_id#&pr_order_id=#get_max2.max_id#</cfoutput>");
            window.location.href = "<cfoutput>#request.self#?fuseaction=prod.list_results&event=upd&p_order_id=#attributes.p_order_id#&pr_order_id=#get_max2.max_id#</cfoutput>";
        </script>
		<cfelse>
			<script type="text/javascript">
				window.location.href="<cfoutput>#request.self#?fuseaction=production.order_operator&list_type=#attributes.list_type#&part=#attributes.part#</cfoutput>";
			</script>    
		</cfif>
