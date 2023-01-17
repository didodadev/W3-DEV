<cfsetting showdebugoutput="no">
<CF_DATE tarih="start_">
<CF_DATE tarih="finish_">
<cfquery name="get_price_types" datasource="#dsn_dev#">
    SELECT
        *
    FROM
        PRICE_TYPES
    ORDER BY
    	IS_STANDART DESC,
    	TYPE_ID ASC
</cfquery>

<script>
<cfoutput query="get_price_types">j_price_type_#TYPE_ID# = '#TYPE_code# - #TYPE_NAME#';</cfoutput>
</script>

<cfif isdefined("start_")>
    <cfquery name="get_prices_all" datasource="#dsn_dev#">
    SELECT
        *
    FROM
        (
        SELECT
            PT.*,
            ISNULL(PT.IS_ACTIVE_S,0) AS IS_ACTIVE_S_,
            ISNULL(PT.IS_ACTIVE_P,0) AS IS_ACTIVE_P_,
            P.PRODUCT_NAME,
            (SELECT TOP 1 ETR.SUB_TYPE_NAME FROM EXTRA_PRODUCT_TYPES_ROWS ETR WHERE PT.PRODUCT_ID = ETR.PRODUCT_ID AND ETR.TYPE_ID = #uretici_type_id#) AS SUB_TYPE_NAME,
            ISNULL(PT.NEW_PRICE,(PT.NEW_PRICE_KDV/(1+SKDV/100))) NEW_PRICE_2,
            ISNULL(PTY.TYPE_NAME,'AKTARIM') TYPE_NAME,
            (SELECT COUNT(STP.PRODUCT_ID) FROM SEARCH_TABLES_PRODUCTS STP WHERE STP.TABLE_CODE = PT.TABLE_CODE) AS URUN_SAYISI              
        FROM
            #dsn1_alias#.PRODUCT P,
            PRICE_TABLE PT
            LEFT JOIN PRICE_TYPES PTY ON PT.PRICE_TYPE = PTY.TYPE_ID
        WHERE
            PT.PRODUCT_ID IN (#attributes.product_id_list#) AND
            ISNULL(PT.IS_ACTIVE_S,0) = #attributes.is_active# AND
            PT.TABLE_CODE = '#attributes.table_code#' AND
            PT.STARTDATE = #start_# AND
            PT.FINISHDATE = #finish_# AND
            PT.PRODUCT_ID = P.PRODUCT_ID AND
            PT.STARTDATE IS NOT NULL AND
            PT.FINISHDATE IS NOT NULL
        ) T1
    WHERE
        <cfif len(attributes.sub_type_name)>
            SUB_TYPE_NAME = '#URLDecode(attributes.sub_type_name)#' AND
        <cfelse>
            SUB_TYPE_NAME IS NULL AND
        </cfif>
        <cfif len(attributes.price_type)>
            PRICE_TYPE = #attributes.price_type# AND
        </cfif>
        ROW_ID > 0
    ORDER BY
        FINISHDATE DESC,
        STARTDATE DESC,
        ROW_ID DESC
    </cfquery>
<cfelse>
	<cfquery name="get_prices_all" datasource="#dsn_dev#">
    SELECT
        *
    FROM
        (
        SELECT
            PT.*,
            ISNULL(PT.IS_ACTIVE_S,0) AS IS_ACTIVE_S_,
            ISNULL(PT.IS_ACTIVE_P,0) AS IS_ACTIVE_P_,
            P.PRODUCT_NAME,
            (SELECT TOP 1 ETR.SUB_TYPE_NAME FROM EXTRA_PRODUCT_TYPES_ROWS ETR WHERE PT.PRODUCT_ID = ETR.PRODUCT_ID AND ETR.TYPE_ID = #uretici_type_id#) AS SUB_TYPE_NAME,
            ISNULL(PT.NEW_PRICE,(PT.NEW_PRICE_KDV/(1+SKDV/100))) NEW_PRICE_2,
            ISNULL(PTY.TYPE_NAME,'AKTARIM') TYPE_NAME,
            (SELECT COUNT(STP.PRODUCT_ID) FROM SEARCH_TABLES_PRODUCTS STP WHERE STP.TABLE_CODE = PT.TABLE_CODE) AS URUN_SAYISI              
        FROM
            #dsn1_alias#.PRODUCT P,
            PRICE_TABLE PT
            LEFT JOIN PRICE_TYPES PTY ON PT.PRICE_TYPE = PTY.TYPE_ID
        WHERE
            PT.ROW_ID = (SELECT TOP 1 PT2.ROW_ID FROM PRICE_TABLE PT2 WHERE PT.TABLE_CODE = PT2.TABLE_CODE AND PT2.PRODUCT_ID = PT.PRODUCT_ID ORDER BY PT2.ROW_ID DESC) AND
            PT.PRODUCT_ID IN (#attributes.product_id_list#) AND
            <cfif not isdefined("attributes.wrk_id")>
                PT.TABLE_CODE = '#attributes.table_code#' AND
            </cfif>
            PT.PRODUCT_ID = P.PRODUCT_ID AND
            PT.STARTDATE IS NOT NULL AND
            PT.FINISHDATE IS NOT NULL
        ) T1
    WHERE
    	<cfif isdefined("attributes.price_type") and len(attributes.price_type)>
            PRICE_TYPE = #attributes.price_type# AND
        </cfif>
        <cfif isdefined("attributes.action_code") and len(attributes.action_code)>
            ACTION_CODE = '#attributes.action_code#' AND
        </cfif>
        <cfif isdefined("attributes.wrk_id") and len(attributes.wrk_id)>
            WRK_ID = '#attributes.wrk_id#' AND
        </cfif>
        ROW_ID > 0
    ORDER BY
        FINISHDATE DESC,
        STARTDATE DESC,
        ROW_ID DESC
    </cfquery>
</cfif>


<cfif attributes.new_page eq 0>
	<script>
		deger_ = window.opener.document.getElementById('ilk_kez_fiyat_at').value;
        tum_urunler = window.opener.document.getElementById('all_product_list').value;
        eleman_sayisi = list_len(tum_urunler);
        
        if(deger_ == 1)
        {
            for (var cm=1; cm <= eleman_sayisi; cm++)
            {
                product_id_ = list_getat(tum_urunler,cm);
                window.opener.document.getElementById('is_selected_' + product_id_).checked = false;
            }
        }
        
        <cfoutput query="get_prices_all">
            <cfset discount_list = "">
            <cfloop from="1" to="10" index="ccc">
                <cfif len(evaluate("discount#ccc#")) and evaluate("discount#ccc#") neq 0>
                    <cfset discount_list = listappend(discount_list,tlformat(evaluate("discount#ccc#")),'+')>
                </cfif>
            </cfloop>
            window.opener.document.getElementById('NEW_ALIS_START_#product_id#').value = '#TLFormat(brut_alis,session.ep.our_company_info.sales_price_round_num)#';
            window.opener.document.getElementById('NEW_ALIS_#product_id#').value = '#TLFormat(NEW_ALIS,session.ep.our_company_info.sales_price_round_num)#';
            window.opener.document.getElementById('NEW_ALIS_KDVLI_#product_id#').value = '#TLFormat(NEW_ALIS_KDV,session.ep.our_company_info.sales_price_round_num)#';
            window.opener.document.getElementById('sales_discount_#product_id#').value = '#discount_list#';
            window.opener.document.getElementById('p_discount_manuel_#product_id#').value = '#manuel_discount#';
            window.opener.document.getElementById('price_type_#product_id#').value = '#price_type#';
            window.opener.document.getElementById('startdate_#product_id#').value = '#dateformat(startdate,"dd/mm/yyyy")#';
            window.opener.document.getElementById('finishdate_#product_id#').value = '#dateformat(finishdate,"dd/mm/yyyy")#';
            window.opener.document.getElementById('p_startdate_#product_id#').value = '#dateformat(p_startdate,"dd/mm/yyyy")#';
            window.opener.document.getElementById('p_finishdate_#product_id#').value = '#dateformat(p_finishdate,"dd/mm/yyyy")#';
            window.opener.document.getElementById('product_price_change_lastrowid_#product_id#').value = '#row_id#';
            if(#is_active_s_# == 0)
                window.opener.document.getElementById('is_active_s_#product_id#').checked = false;
            else
                window.opener.document.getElementById('is_active_s_#product_id#').checked = true;
                
            if(#is_active_p_# == 0)
                window.opener.document.getElementById('is_active_p_#product_id#').checked = false;
            else
                window.opener.document.getElementById('is_active_p_#product_id#').checked = true;
                
            window.opener.document.getElementById('p_ss_marj_#product_id#').value = '#TLFormat(margin)#';
            window.opener.document.getElementById('p_marj_#product_id#').value = '#TLFormat(p_margin)#';
            window.opener.document.getElementById('FIRST_SATIS_PRICE_#product_id#').value = '#TLFormat(new_price_2,session.ep.our_company_info.sales_price_round_num)#';
            window.opener.document.getElementById('FIRST_SATIS_PRICE_KDV_#product_id#').value = '#TLFormat(NEW_PRICE_KDV,session.ep.our_company_info.sales_price_round_num)#';
            
            window.opener.document.getElementById('is_selected_#product_id#').checked = true;
            window.opener.select_row('#product_id#');
            window.opener.hesapla_satis('#product_id#','kdvli');
        </cfoutput>
        
        window.opener.document.getElementById('ilk_kez_fiyat_at').value = '0';
        <cfif attributes.is_selected eq 1>
            window.opener.document.getElementById('selected_p_type').value = '1';
            window.opener.arama_yap();
        </cfif>
        <cfif attributes.is_close eq 1>
            window.close();
        </cfif>
        <cfif isdefined("attributes.is_group") and attributes.is_group eq 1>
            group_can_start = 1;
        </cfif>
    
        liste_ = window.opener.document.getElementById('all_product_list').value;
        eleman_sayisi = list_len(window.opener.document.getElementById('all_product_list').value);
    </script>
<cfelse>
	<script>
	    deger_ = window.opener.document.info_form.ilk_kez_fiyat_at.value;
		if(deger_ == '1')
        {
            var rows = window.opener.$('#jqxgrid').jqxGrid('getboundrows');
			var eleman_sayisi = rows.length;
			
			deger_ = 0;
			for (var m=0; m < eleman_sayisi; m++)
			{
				rows[m].active_row = false;
			}	
        }
        <cfoutput query="get_prices_all">
			<cfquery name="get_price_dept" datasource="#dsn_dev#">
				SELECT DEPARTMENT_ID FROM PRICE_TABLE_DEPARTMENTS WHERE ROW_ID = #ROW_ID#
			</cfquery>
            <cfset discount_list = "">
            <cfloop from="1" to="10" index="ccc">
                <cfif len(evaluate("discount#ccc#")) and evaluate("discount#ccc#") neq 0>
                    <cfset discount_list = listappend(discount_list,tlformat(evaluate("discount#ccc#")),'+')>
                </cfif>
            </cfloop>
			
			var datainformations = window.opener.$('##jqxgrid').jqxGrid('getboundrows');
			var eleman_sayisi = datainformations.length;
			
			for (var m=0; m < eleman_sayisi; m++)
			{
				var last_row = datainformations[m];

				rtype_ = last_row.row_type;
				product_id_ = last_row.product_id;
				ana_urun_ = last_row.ReportsTo;
				
				if(rtype_ == 1 && product_id_ == '#product_id#')
				{
					last_row.product_price_change_lastrowid = '#row_id#';
					last_row.new_alis_start = #brut_alis#;
					last_row.new_alis = #NEW_ALIS#;
					last_row.new_alis_kdvli = #NEW_ALIS_KDV#;
					last_row.sales_discount = '#discount_list#';
					last_row.p_discount_manuel = <cfif len(manuel_discount)>#manuel_discount#<cfelse>0</cfif>;
					
					last_row.price_type = j_price_type_#price_type#;
					last_row.price_type_id = #price_type#;
					
					last_row.startdate = '#dateformat(startdate,"dd/mm/yyyy")#';
					last_row.finishdate = '#dateformat(finishdate,"dd/mm/yyyy")#';
					last_row.p_startdate = '#dateformat(p_startdate,"dd/mm/yyyy")#';
					last_row.p_finishdate = '#dateformat(p_finishdate,"dd/mm/yyyy")#';
					
					if(#is_active_s_# == 0)
						last_row.is_active_s = false;
					else
						last_row.is_active_s = true;
					
					if(#is_active_p_# == 0)
						last_row.is_active_p = false;
					else
						last_row.is_active_p = true;
						
					if(#p_product_type# == 0)
						last_row.p_product_type = false;
					else
						last_row.p_product_type = true;
					
					kar_ = 100 - (wrk_round(#NEW_ALIS_KDV# / #NEW_PRICE_KDV# * 100));
					kar_ = wrk_round(kar_,2); 
					
					last_row.p_ss_marj = kar_;
					last_row.alis_kar = #p_margin#;
					last_row.first_satis_price = #new_price_2#;
					last_row.first_satis_price_kdv = #NEW_PRICE_KDV#;
					
					<cfif get_price_dept.recordcount>
						last_row.price_departments = '#valuelist(get_price_dept.department_id)#';
					<cfelse>
						last_row.price_departments = '';
					</cfif>
					
					last_row.active_row = true;
					
					/*
					datarow = last_row;
					window.opener.$("##jqxgrid").jqxGrid('updaterow',id,datarow,true);
					//window.opener.hesapla_satis(m,'kdvli','first_satis_price_kdv','#NEW_PRICE_KDV#');
					event.stopPropagation();
					*/
				}
				else if(rtype_ > 1 && parseInt(ana_urun_) == parseInt(#product_id#))
				{
					last_row.active_row = true;
					/*
					datarow = last_row;
					window.opener.$("##jqxgrid").jqxGrid('updaterow',id,datarow,true);
					event.stopPropagation();
					*/
				}
			}
        </cfoutput>
		window.opener.$("#jqxgrid").jqxGrid('applyfilters');
        window.opener.document.getElementById('ilk_kez_fiyat_at').value = '0';
        <cfif attributes.is_selected eq 1>
			window.opener.secilileri_getir();
        </cfif>
        <cfif attributes.is_close eq 1>
            window.close();
        </cfif>
        <cfif isdefined("attributes.is_group") and attributes.is_group eq 1>
            group_can_start = 1;
        </cfif>
    </script>
</cfif>