<cfif attributes.page_type eq 4>
	<cfquery name="GET_SHIP_DETAIL" datasource="#dsn2#">
		SELECT 
			(S.NETTOTAL-S.TAXTOTAL) AS BELGE_TOPLAM,
			SR.NETTOTAL AS SATIR_TOPLAM,
			SR.AMOUNT AS SATIR_MIKTAR,
            SR.EXTRA_COST AS MALIYET,
			S.SHIP_ID,
			SR.SHIP_ROW_ID,
			SR.STOCK_ID,
			SR.PRODUCT_ID,
			SR.IMPORT_INVOICE_ID,
			SR.IMPORT_PERIOD_ID,
			S.SHIP_DATE ACTION_DATE,
			SR.SPECT_VAR_ID,
			S.IS_DELIVERED,
			S.SHIP_NUMBER,
			S.PROJECT_ID,
			S.SHIP_DATE,
			PROCESS_CAT,
			S.DELIVER_STORE_ID DEPARTMENT_ID,
			S.LOCATION LOCATION_ID,
			(SELECT BRANCH_ID FROM #dsn_alias#.DEPARTMENT WHERE DEPARTMENT_ID = S.DELIVER_STORE_ID) BRANCH_ID
		FROM
			SHIP S,
			SHIP_ROW SR
		WHERE
			S.SHIP_ID= SR.SHIP_ID
			AND S.SHIP_ID = #attributes.cost_page_id#
			AND SR.EXTRA_COST > 0
	</cfquery>
	<cfquery name="get_cost_control" datasource="#dsn2#">
		SELECT INVOICE_COST_ID FROM INVOICE_COST WHERE SHIP_ID = #attributes.cost_page_id#
	</cfquery>
	<cfquery name="get_max_id" datasource="#dsn2#">
		SELECT MAX(INVOICE_COST_ID) MAX_ID FROM INVOICE_COST WHERE SHIP_ID = #attributes.cost_page_id#
	</cfquery>
<cfelse>
	<cfquery name="GET_SHIP_DETAIL" datasource="#dsn2#">
		SELECT 
			(INV.NETTOTAL-INV.TAXTOTAL) AS BELGE_TOPLAM,
			INV_R.NETTOTAL AS SATIR_TOPLAM,
			INV_R.AMOUNT AS SATIR_MIKTAR,
            INV_R.EXTRA_COST AS MALIYET,
			INV.INVOICE_ID,
			INV.PROJECT_ID,
			INV_R.INVOICE_ROW_ID,
			INV_R.PRODUCT_ID,
			INV.INVOICE_DATE ACTION_DATE,
			INV_R.SPECT_VAR_ID,
			PROCESS_CAT,
			INV.INVOICE_DATE ACTION_DATE,
			INV.INVOICE_NUMBER SHIP_NUMBER,
			INV.INVOICE_CAT,
			INV.DEPARTMENT_ID,
			INV.DEPARTMENT_LOCATION LOCATION_ID,
			(SELECT BRANCH_ID FROM #dsn_alias#.DEPARTMENT WHERE DEPARTMENT_ID = INV.DEPARTMENT_ID) BRANCH_ID
		FROM
			INVOICE INV,
			INVOICE_ROW INV_R,
			#dsn3_alias#.PRODUCT_UNIT PU
		WHERE
			INV.INVOICE_ID= INV_R.INVOICE_ID
			AND INV.INVOICE_ID = #attributes.cost_page_id#
			AND INV_R.EXTRA_COST > 0
			AND PU.PRODUCT_UNIT_ID = INV_R.UNIT_ID
	</cfquery>
	<cfquery name="get_cost_control" datasource="#dsn2#">
		SELECT INVOICE_COST_ID FROM INVOICE_COST WHERE INVOICE_ID = #attributes.cost_page_id#
	</cfquery>
	<cfquery name="get_max_id" datasource="#dsn2#">
		SELECT MAX(INVOICE_COST_ID) MAX_ID FROM INVOICE_COST WHERE INVOICE_ID = #attributes.cost_page_id#
	</cfquery>
</cfif>
<cfif GET_SHIP_DETAIL.recordcount and get_cost_control.recordcount>
	<cfquery name="get_process_cat" datasource="#dsn2#">
		SELECT IS_PROJECT_BASED_ACC,IS_ACCOUNT_GROUP FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #GET_SHIP_DETAIL.PROCESS_CAT#
	</cfquery>
	<cfif get_process_cat.IS_PROJECT_BASED_ACC eq 1 and attributes.page_type eq 4>
		<cfquery name="GET_COST_TOTAL" datasource="#dsn2#">
			SELECT 
				SUM(INVOICE_COST) AS COST_TOTAL
			FROM
				INVOICE_COST
			WHERE
				<cfif attributes.page_type eq 1>
				INVOICE_ID = #attributes.cost_page_id#
				<cfelse>
				SHIP_ID = #attributes.cost_page_id#
				</cfif>
		</cfquery>
	<cfelse>
		<cfquery name="GET_COST_TOTAL" datasource="#dsn2#">
			SELECT 
				SUM(INVOICE_COST) AS COST_TOTAL,
				EXPENSE_ITEM_ID,
				ACCOUNT_CODE
			FROM
				INVOICE_COST
			WHERE
				<cfif attributes.page_type eq 1>
				INVOICE_ID = #attributes.cost_page_id#
				<cfelse>
				SHIP_ID = #attributes.cost_page_id#
				</cfif>
			GROUP BY
				EXPENSE_ITEM_ID,
				ACCOUNT_CODE
		</cfquery>
	</cfif>
	<cfscript>
		borc_tutarlar = '';
		borc_hesaplar = '';
		other_currency_borc_list= '';
		other_amount_borc_list= '';
		alacak_tutarlar = '';
		alacak_hesaplar = '';
		other_currency_alacak_list= '';
		other_amount_alacak_list= '';
		satir_detay_list = ArrayNew(2);
		total_maliyet = 0;
		acc_project_list_alacak='';
		acc_project_list_borc='';
	</cfscript>
	<cfset cost_total=0>
	<cfoutput query="GET_SHIP_DETAIL">
		<cfif SATIR_TOPLAM eq 0>
			<cfif len(SPECT_VAR_ID)>
				<cfquery name="GET_SPEC" datasource="#DSN2#">
					SELECT 
						SPECT_MAIN_ID
					FROM 
						#dsn3_alias#.SPECTS
					WHERE
						SPECT_VAR_ID=#SPECT_VAR_ID#
				</cfquery>
			</cfif>
			<cfquery name="GET_COST" datasource="#DSN2#" maxrows="1">
				SELECT 
					PURCHASE_NET_SYSTEM
				FROM
					#dsn3_alias#.PRODUCT_COST
				WHERE
					PRODUCT_ID=#PRODUCT_ID# AND
					START_DATE<=<cfif len(ACTION_DATE)>#createodbcdatetime(ACTION_DATE)#<cfelse>#NOW()#</cfif> AND
                    <cfif attributes.page_type eq 4>
						ACTION_ID <> #SHIP_ID#
                    <cfelse>
                    	ACTION_ID <> #INVOICE_ID#
                    </cfif>
					<cfif len(SPECT_VAR_ID) and GET_SPEC.RECORDCOUNT>
						AND SPECT_MAIN_ID=#GET_SPEC.SPECT_MAIN_ID#
					</cfif>
				ORDER BY
					START_DATE DESC,
					RECORD_DATE DESC
			</cfquery>
			<cfif GET_COST.RECORDCOUNT and GET_COST.PURCHASE_NET_SYSTEM gt 0>
				<cfset cost_total=cost_total+GET_COST.PURCHASE_NET_SYSTEM*SATIR_MIKTAR>
				<cfif len(SPECT_VAR_ID)>
					<cfset 'prod_cost_#PRODUCT_ID#_#SPECT_VAR_ID#'=GET_COST.PURCHASE_NET_SYSTEM*SATIR_MIKTAR>
				<cfelse>
					<cfset 'prod_cost_#PRODUCT_ID#'=GET_COST.PURCHASE_NET_SYSTEM*SATIR_MIKTAR>
				</cfif>
			</cfif>
		</cfif>
	</cfoutput>
	<cfoutput query="GET_SHIP_DETAIL">
		<cfset action_total=GET_SHIP_DETAIL.BELGE_TOPLAM+cost_total>
		<cfset birim_maliyet = GET_SHIP_DETAIL.MALIYET>
        <cfif attributes.page_type eq 4>
            <cfif birim_maliyet gt 0>
                <cfscript>
                    product_account_codes = get_product_account(prod_id:get_ship_detail.product_id);
                    
                    borc_tutarlar = listappend(borc_tutarlar,birim_maliyet*GET_SHIP_DETAIL.SATIR_MIKTAR,',');
                    other_currency_borc_list = listappend(other_currency_borc_list,'#session.ep.money#',',');
                    other_amount_borc_list =  listappend(other_amount_borc_list,birim_maliyet*GET_SHIP_DETAIL.SATIR_MIKTAR,',');
                    borc_hesaplar=listappend(borc_hesaplar,product_account_codes.ACCOUNT_CODE_PUR,',');		
                    acc_project_list_borc = ListAppend(acc_project_list_borc,GET_SHIP_DETAIL.PROJECT_ID,",");		
                    
                    satir_detay_list[1][listlen(borc_tutarlar)] = '#GET_SHIP_DETAIL.SHIP_NUMBER# İTHAL MAL GİRİŞİ';
                    total_maliyet = total_maliyet + birim_maliyet*GET_SHIP_DETAIL.SATIR_MIKTAR;		
                    satir_detay_list[2][listlen(borc_tutarlar)] = '#GET_SHIP_DETAIL.SHIP_NUMBER# İTHAL MAL GİRİŞİ';
                    fis_detay = 'İTHAL MAL GİRİŞİ';
                </cfscript>
            </cfif>
        <cfelse>
            <cfif len(get_ship_detail.department_id) and len(get_ship_detail.location_id)>
                <cfquery name="GET_LOCATION_TYPE" datasource="#dsn2#">
                    SELECT LOCATION_TYPE FROM #dsn_alias#.STOCKS_LOCATION WHERE DEPARTMENT_ID=#get_ship_detail.department_id# AND LOCATION_ID=#get_ship_detail.location_id#
                </cfquery>
                <cfset location_type=GET_LOCATION_TYPE.LOCATION_TYPE>
            <cfelse>
                <cfset location_type = "">
            </cfif>
            <cfif birim_maliyet gt 0>
                <cfscript>
                    if(get_ship_detail.invoice_cat eq 591)
                        detail_ = '#GET_SHIP_DETAIL.SHIP_NUMBER# İTHALAT FATURASI';
                    else
                        detail_ = '#GET_SHIP_DETAIL.SHIP_NUMBER# MAL ALIM FATURASI';
                    product_account_codes = get_product_account(prod_id:get_ship_detail.product_id);
                    borc_tutarlar = listappend(borc_tutarlar,birim_maliyet*GET_SHIP_DETAIL.SATIR_MIKTAR,',');
                    other_currency_borc_list = listappend(other_currency_borc_list,'#session.ep.money#',',');
                    other_amount_borc_list =  listappend(other_amount_borc_list,birim_maliyet*GET_SHIP_DETAIL.SATIR_MIKTAR,',');
                    if(get_ship_detail.invoice_cat eq 591) //ithalat faturası ise
                    {
                        if(get_process_cat.IS_PROJECT_BASED_ACC eq 0)
                            borc_hesaplar=listappend(borc_hesaplar,product_account_codes.ACCOUNT_YURTDISI_PUR,',');	
                        else
                            borc_hesaplar=listappend(borc_hesaplar,product_account_codes.ACCOUNT_CODE_PUR,',');	
                    }
                    else if (location_type eq 1) //hammadde lokasyonu secilmisse
                        borc_hesaplar=listappend(borc_hesaplar,product_account_codes.MATERIAL_CODE,',');	
                    else
                        borc_hesaplar=listappend(borc_hesaplar,product_account_codes.ACCOUNT_CODE_PUR,',');	
                    acc_project_list_borc = ListAppend(acc_project_list_borc,GET_SHIP_DETAIL.PROJECT_ID,",");
                    satir_detay_list[1][listlen(borc_tutarlar)] = '#detail_#';
                    
                    total_maliyet = total_maliyet + birim_maliyet*GET_SHIP_DETAIL.SATIR_MIKTAR;		
                    fis_detay = 'MAL ALIM FATURASI';
                </cfscript>
            </cfif>
        </cfif>
	</cfoutput>
    <cfoutput query="GET_COST_TOTAL">
        <cfset birim_maliyet = GET_COST_TOTAL.cost_total/GET_SHIP_DETAIL.SATIR_MIKTAR>
        <cfif attributes.page_type eq 4>
			<cfscript>
                if(get_process_cat.IS_PROJECT_BASED_ACC eq 0 and len(GET_COST_TOTAL.EXPENSE_ITEM_ID))
                {
                    alacak_tutarlar = listappend(alacak_tutarlar,birim_maliyet,',');
                    other_currency_alacak_list = listappend(other_currency_alacak_list,'#session.ep.money#',',');
                    other_amount_alacak_list =  listappend(other_amount_alacak_list,birim_maliyet,',');
                    alacak_hesaplar=listappend(alacak_hesaplar,GET_COST_TOTAL.ACCOUNT_CODE,',');
                    acc_project_list_alacak = ListAppend(acc_project_list_alacak,GET_SHIP_DETAIL.PROJECT_ID,",");
                }			
            </cfscript>
        <cfelse>
            <cfif len(get_ship_detail.department_id) and len(get_ship_detail.location_id)>
                <cfquery name="GET_LOCATION_TYPE" datasource="#dsn2#">
                    SELECT LOCATION_TYPE FROM #dsn_alias#.STOCKS_LOCATION WHERE DEPARTMENT_ID=#get_ship_detail.department_id# AND LOCATION_ID=#get_ship_detail.location_id#
                </cfquery>
                <cfset location_type=GET_LOCATION_TYPE.LOCATION_TYPE>
            <cfelse>
                <cfset location_type = "">
            </cfif>
            <cfif birim_maliyet gt 0>
                <cfscript>
                    if(get_process_cat.IS_PROJECT_BASED_ACC eq 0 and len(GET_COST_TOTAL.ACCOUNT_CODE))
                    {
                        alacak_tutarlar = listappend(alacak_tutarlar,birim_maliyet*GET_SHIP_DETAIL.SATIR_MIKTAR,',');
                        other_currency_alacak_list = listappend(other_currency_alacak_list,'#session.ep.money#',',');
                        other_amount_alacak_list =  listappend(other_amount_alacak_list,birim_maliyet*GET_SHIP_DETAIL.SATIR_MIKTAR,',');
                        alacak_hesaplar=listappend(alacak_hesaplar,GET_COST_TOTAL.ACCOUNT_CODE,',');
                        acc_project_list_alacak = ListAppend(acc_project_list_alacak,GET_SHIP_DETAIL.PROJECT_ID,",");
                        satir_detay_list[2][listlen(alacak_tutarlar)] = '#detail_#';
                    }
                </cfscript>
            </cfif>
        </cfif>
    </cfoutput>
	<cfif get_process_cat.IS_PROJECT_BASED_ACC eq 1 and attributes.page_type eq 4 and total_maliyet gt 0>
		<cfquery name="get_pro_detail" datasource="#dsn2#">
			SELECT ACCOUNT_CODE_PUR FROM #dsn3_alias#.PROJECT_PERIOD WHERE PROJECT_ID = #GET_SHIP_DETAIL.PROJECT_ID# AND PERIOD_ID = #session.ep.period_id#
		</cfquery>
		<cfscript>
			alacak_tutarlar = total_maliyet;
			other_currency_alacak_list = session.ep.money;
			other_amount_alacak_list =  total_maliyet;
			alacak_hesaplar=get_pro_detail.ACCOUNT_CODE_PUR;
			acc_project_list_alacak = ListAppend(acc_project_list_alacak,GET_SHIP_DETAIL.PROJECT_ID,",");
		</cfscript>
	<cfelseif get_process_cat.IS_PROJECT_BASED_ACC eq 1 and attributes.page_type eq 1 and total_maliyet gt 0>
		<cfquery name="get_pro_detail" datasource="#dsn2#">
			SELECT ACCOUNT_CODE_PUR,ACCOUNT_YURTDISI_PUR,MATERIAL_CODE FROM #dsn3_alias#.PROJECT_PERIOD WHERE <cfif len(GET_SHIP_DETAIL.PROJECT_ID)> PROJECT_ID = #GET_SHIP_DETAIL.PROJECT_ID# AND </cfif> PERIOD_ID = #session.ep.period_id#
		</cfquery>
		<cfscript>
			alacak_tutarlar = total_maliyet;
			other_currency_alacak_list = session.ep.money;
			other_amount_alacak_list =  total_maliyet;
			if(get_ship_detail.invoice_cat eq 591)
				alacak_hesaplar=get_pro_detail.ACCOUNT_YURTDISI_PUR;			
			else if (location_type eq 1) //hammadde lokasyonu secilmisse
				alacak_hesaplar=get_pro_detail.MATERIAL_CODE;		
			else
				alacak_hesaplar=get_pro_detail.ACCOUNT_CODE_PUR;
			acc_project_list_alacak = ListAppend(acc_project_list_alacak,GET_SHIP_DETAIL.PROJECT_ID,",");		
			satir_detay_list[2][listlen(alacak_tutarlar)] = '#detail_#';
		</cfscript>
	</cfif>
	<cfif listlen(borc_tutarlar)>
		<cfscript>
			GET_NO_ = cfquery(datasource:"#dsn2#", sqlstring:"SELECT * FROM #dsn3_alias#.SETUP_INVOICE_PURCHASE");
			str_fark_gelir =GET_NO_.FARK_GELIR;
			str_fark_gider =GET_NO_.FARK_GIDER;
			str_max_round = 0.1;
			str_round_detail = fis_detay;
			
			DOC_INFO_ = cfquery(datasource:"#dsn2#",sqlstring:"SELECT TOP 1 DOCUMENT_TYPE,PAYMENT_TYPE FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_TYPE = 120");
			
			document_type_ = DOC_INFO_.DOCUMENT_TYPE;
			payment_type_ = DOC_INFO_.PAYMENT_TYPE;
			
			muhasebeci (
					action_id:get_max_id.MAX_ID,
					workcube_process_type : get_process_type.process_type,
					workcube_process_cat: form.process_cat,
					account_card_type:13,
					action_table : 'INVOICE_COST',
					islem_tarihi:createodbcdatetime(get_ship_detail.ACTION_DATE),
					borc_hesaplar: borc_hesaplar,
					borc_tutarlar: borc_tutarlar,
					other_amount_borc : other_amount_borc_list,
					other_currency_borc :other_currency_borc_list,
					alacak_hesaplar: alacak_hesaplar,
					alacak_tutarlar: alacak_tutarlar,
					other_amount_alacak : other_amount_alacak_list,
					other_currency_alacak : other_currency_alacak_list,
					fis_detay:fis_detay,
					fis_satir_detay: satir_detay_list,
					belge_no : GET_SHIP_DETAIL.SHIP_NUMBER,
					is_account_group: get_process_cat.is_account_group,
					dept_round_account :str_fark_gider,
					claim_round_account : str_fark_gelir,
					max_round_amount :str_max_round,
					round_row_detail:str_round_detail,
					to_branch_id : get_ship_detail.branch_id,
					acc_project_list_alacak : acc_project_list_alacak,
					acc_project_list_borc : acc_project_list_borc,
					document_type : document_type_,
					payment_method : payment_type_
					);
		</cfscript>
	</cfif>
</cfif>
