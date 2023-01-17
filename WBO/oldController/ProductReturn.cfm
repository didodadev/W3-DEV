<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cf_get_lang_set module_name="service">
    <cf_xml_page_edit fuseact="objects.popup_add_product_return">
    <cfparam name="attributes.listing_type" default="2">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.product_process_type" default="">
    <cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
        <cf_date tarih = "attributes.finish_date">
    <cfelse>
        <cfset attributes.finish_date = createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#')>
    </cfif>
    <cfif isdefined("attributes.start_date") and len(attributes.start_date)>
        <cf_date tarih = "attributes.start_date">
    <cfelse>
        <cfset attributes.start_date = dateadd('ww',-1,attributes.finish_date)>
    </cfif>
    <cfquery name="GET_RETURN_CATS" datasource="#DSN3#">
        SELECT RETURN_CAT_ID,RETURN_CAT FROM SETUP_PROD_RETURN_CATS ORDER BY RETURN_CAT
    </cfquery>
    <cfquery name="GET_RETURN_STAGES" datasource="#DSN#">
        SELECT
            PTR.STAGE,
            PTR.PROCESS_ROW_ID
        FROM
            PROCESS_TYPE_ROWS PTR,
            PROCESS_TYPE_OUR_COMPANY PTO,
            PROCESS_TYPE PT
        WHERE
            PT.IS_ACTIVE = 1 AND
            PTR.PROCESS_ID = PT.PROCESS_ID AND
            PT.PROCESS_ID = PTO.PROCESS_ID AND
            PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%service.add_return%">
        ORDER BY
            PTR.LINE_NUMBER
    </cfquery>
    <cfif isdefined("attributes.form_submitted")>
        <cfinclude template="../service/query/get_return.cfm">
    <cfelse>
        <cfset get_returns.recordcount = 0>
    </cfif>
    <cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
    <cfparam name="attributes.page" default="1">
    <cfparam name="attributes.totalrecords" default = "#get_returns.recordcount#">
    <cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
<cfelseif isdefined("attributes.event") and ListFindNoCase('add,upd',attributes.event)>
	<cfif attributes.event is 'add'>
    	<cf_xml_page_edit fuseact="objects.popup_add_product_return">
        <cfparam name="attributes.company_id" default="">
        <cfparam name="attributes.stock_id" default="">
        <cfparam name="attributes.product_id" default="">
        <cfparam name="attributes.product_name" default="">
        <cfparam name="attributes.consumer_id" default="">
        <cfparam name="attributes.comp_name" default="">
        <cfparam name="attributes.invoice_no" default="">
        <cfquery name="GET_PERIOD" datasource="#DSN#">
            SELECT PERIOD_YEAR, PERIOD_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> ORDER BY PERIOD_YEAR
        </cfquery>	
        <cfif ((len(attributes.company_id) or len(attributes.consumer_id)) and len(attributes.comp_name)) or (len(attributes.stock_id) and len(attributes.product_name)) or (len(attributes.invoice_no))>
            <cfset my_source = '#dsn#_#invoice_year#_#session.ep.company_id#'>
            <cfquery name="GET_HIERARCHIES" datasource="#DSN#">
                SELECT
                    DISTINCT
                    SZ_HIERARCHY
                FROM
                    SALES_ZONES_ALL_1
                WHERE
                    POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
            </cfquery>
            <cfset row_block = 500>
            <!---XML de en Fazla Kac Kampanya oncesine Iade Girilebilsin? secenegi varsa kampanya kontrolleri yapiliyor --->
            <cfif len(camp_count)>
                <cfquery name="GET_CAMP_DATE" datasource="#DSN3#" maxrows="1"><!--- icinde bulunulan kampanya --->
                    SELECT 
                        CAMP_ID,
                        CAMP_STARTDATE
                    FROM 
                        CAMPAIGNS 
                    WHERE 
                        CAMP_STARTDATE < #now()# AND
                        CAMP_FINISHDATE > #now()#
                </cfquery>
                <cfif get_camp_date.recordcount>
                    <!--- BK 20100809 kampanya baslangic tarihi bir gün geriye cekildi. --->
                    <cfquery name="GET_FIRST_CAMP_" datasource="#DSN3#" maxrows="#camp_count#">
                        SELECT DATEADD(DAY,-1,CAMP_STARTDATE) CAMP_STARTDATE,CAMP_FINISHDATE,CAMP_ID FROM CAMPAIGNS WHERE CAMP_STARTDATE <= #createodbcdatetime(get_camp_date.camp_startdate)# ORDER BY CAMP_FINISHDATE DESC
                    </cfquery>
                    <cfquery name="GET_MIN_CAMP_" dbtype="query" maxrows="1">
                        SELECT CAMP_ID,CAMP_STARTDATE,CAMP_FINISHDATE FROM GET_FIRST_CAMP_ ORDER BY CAMP_FINISHDATE
                    </cfquery>
                </cfif>
            </cfif>
            <cfquery name="GET_SEARCH_RESULTS_" datasource="#my_source#">
                <cfif not(isdefined('attributes.company_id') and len(attributes.company_id))>
                    SELECT
                        INVOICE_ROW.STOCK_ID,
                        INVOICE_ROW.PRODUCT_ID,
                        INVOICE.INVOICE_NUMBER,
                        INVOICE_ROW.INVOICE_ROW_ID,
                        INVOICE_ROW.PRICE,
                        INVOICE_ROW.TAX,
                        INVOICE_ROW.AMOUNT,
                        INVOICE.INVOICE_DATE,
                        INVOICE.INVOICE_ID
                    FROM
                        INVOICE,
                        INVOICE_ROW,
                        #dsn_alias#.CONSUMER C
                    WHERE
                        INVOICE.INVOICE_ID = INVOICE_ROW.INVOICE_ID AND
                        INVOICE.PURCHASE_SALES = 1 AND
                        INVOICE.CONSUMER_ID = C.CONSUMER_ID AND
                        INVOICE.IS_IPTAL = 0 AND
                        INVOICE.INVOICE_CAT NOT IN (55,56)	<!--- Demirbaslar haric --->
                        <cfif isdefined('attributes.invoice_no') and len(attributes.invoice_no)>AND INVOICE.INVOICE_NUMBER = '#attributes.invoice_no#'</cfif>	
                        <cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>AND C.CONSUMER_ID = #attributes.consumer_id#</cfif>	
                        <cfif isdefined('attributes.stock_id') and len(attributes.stock_id) and isdefined('attributes.stock_id') and len(attributes.stock_id)>
                            AND INVOICE_ROW.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
                        </cfif>	
                        <cfif isdefined("is_inventory") and is_inventory eq 1>
                            AND INVOICE_ROW.PRODUCT_ID IN(SELECT P.PRODUCT_ID FROM #dsn3_alias#.PRODUCT P WHERE P.PRODUCT_ID = INVOICE_ROW.PRODUCT_ID AND (P.IS_INVENTORY = 1 OR P.IS_KARMA = 1))
                        </cfif>
                        <cfif session.ep.our_company_info.sales_zone_followup eq 1>
                            <!--- Satis Takimda Ekip Lideri veya Satıs Takiminda Ekipde ise ilgili IMS ler--->
                            AND 
                            (
                                C.IMS_CODE_ID IN (
                                                    SELECT
                                                        IMS_ID
                                                    FROM
                                                        #dsn_alias#.SALES_ZONES_ALL_2
                                                    WHERE
                                                        POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
                                                 )
                            <!--- Satis bolgeleri ekibinde veya Satis bolgesinde yonetici ise kendisi ve altindaki IMS ler--->			
                            <cfif get_hierarchies.recordcount>
                                OR C.IMS_CODE_ID IN (
                                                    SELECT
                                                        IMS_ID
                                                    FROM
                                                        #dsn_alias#.SALES_ZONES_ALL_1
                                                    WHERE											
                                                        <cfloop index="page_stock" from="0" to="#(ceiling(get_hierarchies.recordcount/row_block))-1#">
                                                            <cfset start_row=(page_stock*row_block)+1>	
                                                            <cfset end_row=start_row+(row_block-1)>
                                                            <cfif (end_row) gte get_hierarchies.recordcount>
                                                                <cfset end_row=get_hierarchies.recordcount>
                                                            </cfif>
                                                                (
                                                                <cfloop index="add_stock" from="#start_row#" to="#end_row#">
                                                                    <cfif (add_stock mod row_block) neq 1> OR</cfif> SZ_HIERARCHY+'.' LIKE '#get_hierarchies.sz_hierarchy[add_stock]#%'
                                                                </cfloop>
                                                                
                                                                )<cfif (ceiling(get_hierarchies.recordcount/row_block))-1 neq page_stock> OR</cfif>													
                                                        </cfloop>											
                                                )
                              </cfif>
                             )
                        </cfif>
                        <cfif len(camp_count) and get_camp_date.recordcount and get_min_camp_.recordcount>
                            AND INVOICE.INVOICE_DATE > #createodbcdatetime(get_min_camp_.camp_startdate)#
                        </cfif>
                </cfif>
                <cfif not(isdefined('attributes.consumer_id') and len(attributes.consumer_id)) and not(isdefined('attributes.company_id') and len(attributes.company_id))>
                    UNION ALL
                </cfif>
                <cfif not(isdefined('attributes.consumer_id') and len(attributes.consumer_id))>
                    SELECT
                        INVOICE_ROW.STOCK_ID,
                        INVOICE_ROW.PRODUCT_ID,
                        INVOICE.INVOICE_NUMBER,
                        INVOICE_ROW.INVOICE_ROW_ID,
                        INVOICE_ROW.PRICE,		
                        INVOICE_ROW.TAX,
                        INVOICE_ROW.AMOUNT,				
                        INVOICE.INVOICE_DATE,
                        INVOICE.INVOICE_ID
                    FROM
                        INVOICE,
                        INVOICE_ROW,
                        #dsn_alias#.COMPANY C
                    WHERE
                        INVOICE.INVOICE_ID = INVOICE_ROW.INVOICE_ID AND
                        INVOICE.PURCHASE_SALES = 1 AND
                        INVOICE.COMPANY_ID = C.COMPANY_ID AND
                        INVOICE.IS_IPTAL = 0 AND
                        INVOICE.INVOICE_CAT NOT IN (55,56)	<!--- Demirbaslar haric --->
                        <cfif isdefined('attributes.invoice_no') and len(attributes.invoice_no)> AND INVOICE.INVOICE_NUMBER = '#attributes.invoice_no#'</cfif>	
                        <cfif isdefined('attributes.company_id') and len(attributes.company_id)>AND C.COMPANY_ID = #attributes.company_id#</cfif>	
                        <cfif isdefined('attributes.stock_id') and len(attributes.stock_id) and isdefined('attributes.stock_id') and len(attributes.stock_id)>
                            AND INVOICE_ROW.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
                        </cfif>	
                        <cfif isdefined("is_inventory") and is_inventory eq 1>
                            AND INVOICE_ROW.PRODUCT_ID IN(SELECT P.PRODUCT_ID FROM #dsn3_alias#.PRODUCT P WHERE P.PRODUCT_ID = INVOICE_ROW.PRODUCT_ID AND P.IS_INVENTORY=1)
                        </cfif>
                        <cfif session.ep.our_company_info.sales_zone_followup eq 1>
                            <!--- Satis Takimda Ekip Lideri veya Satıs Takiminda Ekipde ise ilgili IMS ler--->
                            AND 
                            (
                                C.IMS_CODE_ID IN (
                                                    SELECT
                                                        IMS_ID
                                                    FROM
                                                        #dsn_alias#.SALES_ZONES_ALL_2
                                                    WHERE
                                                        POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
                                                 )
                            <!--- Satis bolgeleri ekibinde veya Satis bolgesinde yonetici ise kendisi ve altindaki IMS ler--->			
                            <cfif get_hierarchies.recordcount>
                                OR C.IMS_CODE_ID IN (
                                                    SELECT
                                                        IMS_ID
                                                    FROM
                                                        #dsn_alias#.SALES_ZONES_ALL_1
                                                    WHERE											
                                                        <cfloop index="page_stock" from="0" to="#(ceiling(get_hierarchies.recordcount/row_block))-1#">
                                                            <cfset start_row=(page_stock*row_block)+1>	
                                                            <cfset end_row=start_row+(row_block-1)>
                                                            <cfif (end_row) gte get_hierarchies.recordcount>
                                                                <cfset end_row=get_hierarchies.recordcount>
                                                            </cfif>
                                                                (
                                                                <cfloop index="add_stock" from="#start_row#" to="#end_row#">
                                                                    <cfif (add_stock mod row_block) neq 1> OR</cfif> SZ_HIERARCHY+'.' LIKE '#get_hierarchies.sz_hierarchy[add_stock]#%'
                                                                </cfloop>
                                                                
                                                                )<cfif (ceiling(get_hierarchies.recordcount/row_block))-1 neq page_stock> OR</cfif>													
                                                        </cfloop>											
                                                )
                              </cfif>
                             )
                        </cfif>
                        <cfif len(camp_count) and get_camp_date.recordcount and get_min_camp_.recordcount>
                            AND INVOICE.INVOICE_DATE > #createodbcdatetime(get_min_camp_.camp_startdate)#
                        </cfif>
                    </cfif>
                ORDER BY
                    INVOICE.INVOICE_DATE DESC
            </cfquery>
        
            <cfif get_search_results_.recordcount>
                <cfquery name="GET_PERIOD_ID" dbtype="query">
                    SELECT PERIOD_ID FROM GET_PERIOD WHERE PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_year#">
                </cfquery>
                <cfquery name="GET_INVOICE_" datasource="#my_source#">
                    SELECT COMPANY_ID, PARTNER_ID, CONSUMER_ID FROM INVOICE WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_search_results_.invoice_id#">
                </cfquery>
                <cfquery name="GET_KABUL_ALL" datasource="#DSN3#">
                    SELECT 
                        SPRR.STOCK_ID,
                        SPRR.INVOICE_ROW_ID,
                        SPRR.AMOUNT
                    FROM
                        SERVICE_PROD_RETURN SPR,
                        SERVICE_PROD_RETURN_ROWS SPRR
                    WHERE 
                        SPR.RETURN_ID = SPRR.RETURN_ID AND
                        SPRR.INVOICE_ROW_ID IN(#valuelist(get_search_results_.invoice_row_id)#) AND
                        SPR.PERIOD_ID = #get_period_id.period_id#				
                    <cfif is_return_control eq 1>
                        AND SPRR.RETURN_ACT_TYPE = 1
                    </cfif>				
                </cfquery>
                <cfquery name="GET_PRODUCT_NAME2" datasource="#DSN3#">
                    SELECT 
                        PRODUCT_NAME,
                        PRODUCT_ID,
                        STOCK_ID,
                        BARCOD,
                        STOCK_CODE_2,
                        STOCK_CODE 
                    FROM 
                        STOCKS
                    WHERE
                        STOCK_ID IN (#listdeleteduplicates(ValueList(get_search_results_.stock_id,','))#)
                </cfquery>
            </cfif>
        </cfif>
        <cfparam name="attributes.invoice_year" default="#session.ep.period_year#">
        <cfquery name="GET_RETURN_CAT" datasource="#DSN3#">
            SELECT RETURN_CAT_ID, RETURN_CAT FROM SETUP_PROD_RETURN_CATS ORDER BY RETURN_CAT
        </cfquery>
    <cfelseif attributes.event is 'upd'>
    	<cf_get_lang_set module_name="service">
    	<cf_xml_page_edit fuseact="objects.popup_add_product_return">
		<cfif not isdefined("is_process_row")>
            <cfset is_process_row = 0>
        </cfif>
        <cfif not isdefined("is_cancel_cat")>
            <cfset is_cancel_cat = 0>
        </cfif>
        <cfif is_process_row eq 1>
            <cf_workcube_process_info>
            <cfif len(process_rowid_list)>
                <cfquery name="GET_STAGE" datasource="#DSN#">
                    SELECT STAGE, PROCESS_ROW_ID FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#process_rowid_list#)
                </cfquery>
            </cfif>
        </cfif>
        
        <cfquery name="GET_RETURN" datasource="#DSN3#">
            SELECT SERVICE_CONSUMER_ID,SERVICE_COMPANY_ID,SERVICE_PARTNER_ID FROM SERVICE_PROD_RETURN WHERE RETURN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.return_id#">
        </cfquery>
        <cfquery name="GET_RETURN_DETAIL" datasource="#DSN3#">
            SELECT
                SPR.RETURN_ID,
                SPR.PERIOD_ID,
                SPR.INVOICE_ID,
                SPR.SERVICE_PARTNER_ID,
                SPR.SERVICE_CONSUMER_ID,
                SPR.RECORD_EMP,
                SPR.RECORD_DATE,
                SPR.UPDATE_EMP,
                SPR.UPDATE_DATE,
                SPRR.IS_SHIP,
                SPRR.AMOUNT,
                SPRR.RETURN_ROW_ID,
                SPRR.RETURN_TYPE ROW_RETURN_TYPE,
                <!--- SPRR.RETURN_TYPE_OTHER ROW_RETURN_TYPE_OTHER, --->
                SPRR.RETURN_ACT_TYPE ROW_RETURN_ACT_TYPE,
                SPRR.RETURN_STAGE,
                SPRR.STOCK_ID,
                SPRR.RETURN_CANCEL_TYPE,
                SPRR.DETAIL,
                SPRR.ACCESSORIES,
                SPRR.PACKAGE,
                SPRR.INVOICE_ROW_ID
            FROM
                SERVICE_PROD_RETURN SPR,
                SERVICE_PROD_RETURN_ROWS SPRR
            WHERE
                SPR.RETURN_ID = SPRR.RETURN_ID AND
                SPR.RETURN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.return_id#">
        </cfquery>
        <!--- Takip kayitlari cekiliyor --->
        <cfquery name="GET_ORDER_DEMAND" datasource="#DSN3#">
            SELECT RETURN_ROW_ID FROM ORDER_DEMANDS WHERE RETURN_ROW_ID IN (#valuelist(get_return_detail.return_row_id)#) AND GIVEN_AMOUNT <> 0
        </cfquery>
        
        <cfquery name="GET_RETURN_AMOUNT" datasource="#DSN3#">
            SELECT 
               SUM(SPRR.AMOUNT) AS SUM_AMOUNT,
               SPRR.STOCK_ID,
               SPRR.INVOICE_ROW_ID                             
            FROM 
               SERVICE_PROD_RETURN_ROWS SPRR,
               SERVICE_PROD_RETURN SPR
            WHERE
               SPRR.RETURN_ID =  SPR.RETURN_ID AND
               SPRR.INVOICE_ROW_ID IN (#valuelist(get_return_detail.invoice_row_id)#)
            <cfif len(get_return.service_consumer_id)>
               AND SPR.SERVICE_CONSUMER_ID = #get_return.service_consumer_id#
            <cfelseif len(get_return.service_partner_id)>
               AND SPR.SERVICE_PARTNER_ID = #get_return.service_partner_id#                              
            </cfif>
            <cfif is_return_control eq 1>
               AND SPRR.RETURN_ACT_TYPE = 1
            </cfif>                  
            GROUP BY 
               SPRR.STOCK_ID, 
               SPRR.INVOICE_ROW_ID                             
        </cfquery>
        
        <cfquery name="GET_RETURN_CAT" datasource="#DSN3#">
            SELECT RETURN_CAT_ID, RETURN_CAT FROM SETUP_PROD_RETURN_CATS ORDER BY RETURN_CAT
        </cfquery>
        <cfquery name="GET_CANCEL_CAT" datasource="#DSN3#">
            SELECT CANCEL_CAT_ID, CANCEL_CAT FROM SETUP_PROD_CANCEL_CATS ORDER BY CANCEL_CAT
        </cfquery>
        <cfquery name="GET_PERIOD" datasource="#DSN#">
            SELECT PERIOD_ID,PERIOD_YEAR,OUR_COMPANY_ID FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_return_detail.period_id#">
        </cfquery>
        <cfset my_source = '#dsn#_#get_period.period_year#_#get_period.our_company_id#'>
        <cfquery name="GET_INV_NO" datasource="#my_source#">
            SELECT 
                IR.AMOUNT,
                I.INVOICE_NUMBER
            FROM
                INVOICE I,
                INVOICE_ROW IR
            WHERE
                IR.INVOICE_ID = I.INVOICE_ID AND
                I.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_return_detail.invoice_id#">
        </cfquery>
        
        <cfquery name="GET_INV_ROW" datasource="#my_source#">
            SELECT 
                AMOUNT,
                INVOICE_ROW_ID
            FROM
                INVOICE_ROW 
            WHERE
                INVOICE_ROW_ID IN (#valuelist(get_return_detail.invoice_row_id)#)
        </cfquery>
    </cfif>
</cfif>
<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$( document ).ready(function() {
			document.getElementById('keyword').focus();
		});	
		function kontrol_et()
		{
			kontrol_ = 0;
			if (document.send_form_.return_row_ids.length != undefined) /* n tane*/
			{
				for (i=0; i < document.send_form_.return_row_ids.length; i++)
				{
					if (document.send_form_.return_row_ids[i].checked)
						kontrol_ = 1;
				}
			}
			else
			{
				if (document.send_form_.return_row_ids.checked)
					kontrol_ = 1;	
			}
			
			if (document.send_form_.return_row_ids.length != undefined) /* n tane*/
			{
				perakende_kontrol_ = 0;
				diger_kontrol_ = 0;
				for (j=0; j < document.send_form_.return_row_ids.length; j++)
				{
					if (document.send_form_.return_row_ids[j].checked)
					{
						m = j + 1;
						if(eval('document.send_form_.invoice_cat_' + m).value==52)
							perakende_kontrol_ = 1;
						else
							diger_kontrol_ = 1;
					}
				}
				if(perakende_kontrol_==1 && diger_kontrol_==1)
				{
					alert("<cf_get_lang no ='288.Farklı İki (2) Tür Faturayı Aynı İrsaliyeye Çekemezsiniz'>!");
					return false;
				}
			}
			
			if(kontrol_ == 0)
			{
				alert("<cf_get_lang no ='226.Hiçbir İade İşlemi Seçmediniz'>!");
				return false;
			}
			return true;
		}
		
		function list_kontrol()
		{
			if( !date_check(document.all.start_date, document.all.finish_date, "<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
				return false;
			else
				return true;
		}
		
		function check_all_return_rows()
		{
			if(document.getElementById('check_all').checked)
			{
				for (j=0; j < document.send_form_.return_row_ids.length; j++)
				{
					document.send_form_.return_row_ids[j].checked=true;
				}
			}
			else
			{
				for (j=0; j < document.send_form_.return_row_ids.length; j++)
				{
					document.send_form_.return_row_ids[j].checked=false;
				}
			}
		}
	<cfelseif attributes.event is 'add'>
		if(document.getElementById('invoice_row_list')!= undefined)
			invoice_row_list = document.getElementById('invoice_row_list').value;
		else
			invoice_row_list = '';
			
		function page_control()
		{
			if(document.search_product_return.comp_name.value == '' && document.search_product_return.product_name.value == '' && document.search_product_return.invoice_no.value == '')
			{
				alert("Arama Kriterlerinden En Az Birini Seçmelisiniz !");
				return false;
			}
			return true;
		}
			
		<cfif ((len(attributes.company_id) or len(attributes.consumer_id)) and len(attributes.comp_name)) or (len(attributes.stock_id) and len(attributes.product_name)) or (len(attributes.invoice_no)) and (isdefined('get_search_results_') and get_search_results_.recordcount)>
			function check_all(deger)
			{
				<cfif get_search_results_.recordcount>
					if(add_ins_return.hepsi.checked)
					{
						for(i=1;i<=<cfoutput>#listlen(valuelist(get_search_results_.invoice_row_id))#</cfoutput>;++i)
						{
							selected_row_id = list_getat(invoice_row_list,i,',');
							document.getElementById('is_check'+selected_row_id).checked = true;
							document.getElementById('amount'+selected_row_id).value = parseFloat(document.getElementById('invoice_amount'+selected_row_id).value)-parseFloat(document.getElementById('old_kabul' + selected_row_id).value);
						}
					}
					else
					{
						for(i=1;i<=<cfoutput>#listlen(valuelist(get_search_results_.invoice_row_id))#</cfoutput>;++i)
						{
							selected_row_id = list_getat(invoice_row_list,i,',');
							document.getElementById('is_check' + selected_row_id).checked = false;
							document.getElementById('amount'+selected_row_id).value = 0;
						}
					}
				</cfif>
			}
			function check_row(deger,row_id)
			{
				if(deger)
				{
					eval("document.add_ins_return.is_check" + row_id).checked = true;
					eval("document.add_ins_return.amount" + row_id).value = parseFloat(eval("document.add_ins_return.invoice_amount" + row_id).value-eval("document.add_ins_return.old_kabul" + row_id).value);
				}
				else
				{
					eval("document.add_ins_return.is_check" + row_id).checked = false;
					eval("document.add_ins_return.amount" + row_id).value = 0;
				}
			}
			function add_kontrol()
			{
				var send_prom_url='';
				kontrol_ = 0;
				<!---for(i=1;i<=<cfoutput>#listlen(valuelist(get_search_results_.invoice_row_id))#</cfoutput>;++i)
				{
					selected_row_id = list_getat(invoice_row_list,i,',');
					if(document.getElementById('is_check'+selected_row_id).checked == true)
					{
						kontrol_ = 1;
						if(document.getElementById('amount'+selected_row_id).value <= 0)
						{
							alert(i+". <cf_get_lang no='886.Satır İçin İşlem Miktarı Girmelisiniz'>!");
							return false;
						}
						
						if(document.getElementById('returncat'+selected_row_id).value == '')
						{
							alert(i+". Satır İçin İşlem Nedeni Seçmelisiniz !");
							return false;
						}	
		
		
						cikan_ = parseInt(document.getElementById('invoice_amount'+selected_row_id).value);
						kabul_ = parseInt(document.getElementById('old_kabul'+selected_row_id).value);
						kont_ = cikan_ - kabul_;
						
						if(kont_ < document.getElementById('amount'+selected_row_id).value)
						{
							alert(i+". <cf_get_lang no='887.Satır İçin Çıkan Üründen Fazla İade Alamazsınız'>!");
							return false;
						}	
												
						<cfif isdefined('is_check_promotions') and is_check_promotions eq 1><!--- detayli promosyon kontrolu icin iade edilen stocklar aliniyor --->
							if(send_prom_url=='')
								send_prom_url= document.getElementById('stock_id'+selected_row_id).value;
							else
								send_prom_url=send_prom_url+','+document.getElementById('stock_id'+selected_row_id).value;
						</cfif>				
					}
				}
				if(kontrol_ == 0)
				{
					alert("<cf_get_lang no='885.Ürün Servis İşlemi Yapmadınız'>!");
					return false;
				}--->
				
				<cfif isdefined('is_check_promotions') and is_check_promotions eq 1><!--- detaylı promosyon kontrolu yapılıyor --->
					AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects2.emptypopup_ajax_check_paper_promotion_products</cfoutput>&stock_list='+send_prom_url+'&invoice_id='+add_ins_return.invoice_id.value+'','check_proms',1);
				</cfif>
				return true;
			}
			function Unformatfields()
			{
				<cfoutput query="get_search_results_">
					document.add_ins_return.amount#invoice_row_id#.value = filterNum(document.add_ins_return.amount#invoice_row_id#.value);
				</cfoutput>
				return true;
			}
			
			function change_all_returncat()
			{
				for(i=1;i<=<cfoutput>#listlen(valuelist(get_search_results_.invoice_row_id))#</cfoutput>;++i)
				{
					selected_row_id = list_getat(invoice_row_list,i,',');
					document.getElementById('returncat'+selected_row_id).value = document.getElementById('returncat').value;
				}
			}
		</cfif>
	<cfelseif attributes.event is 'upd'>
		function check_all()
		{
			if(document.getElementById('is_check_all').checked)
			{
				if(document.upd_return.is_check.length != undefined) {
					for (i=0; i < document.upd_return.is_check.length; i++)
					document.upd_return.is_check[i].checked= true;	
				}
				else document.upd_return.is_check.checked= true;		
			}
			else
			{	
				if(document.upd_return.is_check.length != undefined) {
					for (i=0; i < document.upd_return.is_check.length; i++)
						document.upd_return.is_check[i].checked= false;
				}
				else document.upd_return.is_check.checked= false;		
			}
		}
		
		function upd_kontrol()
		{
			kontrol_ = 0;
			if (document.upd_return.is_check.length != undefined)
			{
				for (i=0; i < document.upd_return.is_check.length; i++)
				{
					if(document.upd_return.is_check[i].checked)
						kontrol_ = 1;
				}							
			}
			else
			{
				if (document.upd_return.is_check.checked)
					kontrol_ = 1;	
			}
			
			if(kontrol_ == 0)
			{
				alert("<cf_get_lang no='226.Hiçbir İade İşlemi Seçmediniz'>!");
				return false;
			}
			
			kontrol_temp = 0;
			
			<cfoutput query="get_return_detail">
				
				if(document.upd_return.amount_#return_row_id#.value <= 0)
				{
					alert("#currentrow#. Satır İçin İade Miktarı Girmelisiniz !");
					return false;
				}	
				
				cikan_ = parseInt(document.upd_return.invoice_amount_#return_row_id#.value);
				kabul_ = parseInt(document.upd_return.return_amount_#return_row_id#.value);
				kont_ = cikan_ - kabul_;
				
				if(kont_ < document.upd_return.amount_#return_row_id#.value)
				{
					alert("#currentrow#.  Satır İçin Çıkan Üründen Fazla İade Alamazsınız !");
					return false;
				}	
			</cfoutput>
			return true;
		}			
	</cfif>	
</script>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
		
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'service.product_return';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'service/display/list_product_return.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'service.product_return';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'objects/form/add_return.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'objects/query/add_return.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = '';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'service.product_return';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'service/form/upd_product_return.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'service/query/upd_return.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'service.product_return&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'return_id=##return_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##return_id##';
	
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=service.emptypopup_del_return&return_id=#attributes.return_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'service/query/del_product_return.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'service/query/del_product_return.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'service.product_return';
	}
	
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[345]#';//Uyarılar
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=service.popup_upd_product_return&action_name=return_id&action_id=#url.return_id#','list')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[170]#';//Ekle
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=service.product_return&event=add','horizantal')";
				
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>
