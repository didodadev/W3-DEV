<cf_get_lang_set module_name="salesplan">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cf_xml_page_edit>
    <cfif isdefined("attributes.is_form_submitted")>
        <cfset form_varmi = 1>
    <cfelse>
        <cfset form_varmi = 0>
    </cfif>
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.ch_company_id" default="">
    <cfparam name="attributes.ch_consumer_id" default="">
    <cfparam name="attributes.ch_company" default="">
    <cfparam name="attributes.employee_id" default="">
    <cfparam name="attributes.employee_name" default="">
    <cfparam name="attributes.team_id" default="">
    <cfparam name="attributes.team_name" default="">
    <cfparam name="attributes.is_active" default="">
  <cfparam name="attributes.start_date" default="">
    <cfparam name="attributes.finish_date" default="">
    <cfparam name="attributes.process_stage_type" default="">
    <cfparam name="attributes.quota_type" default="">
    <cfparam name="attributes.period_type" default="">
    <cfparam name="attributes.result_info" default="">
    <cfparam name="attributes.listing_type" default="0">
    <cfif isDefined("attributes.is_form_submitted")>
        <cfif isDate(attributes.start_date)><cf_date tarih="attributes.start_date"></cfif>
        <cfif isDate(attributes.finish_date)><cf_date tarih="attributes.finish_date"></cfif>
        <cfquery name="get_sales_quota" datasource="#dsn3#">
            SELECT
            	S.PAPER_NO,
                S.PLAN_DATE,
                S.FINISH_DATE,
                S.COMPANY_ID,
                S.DETAIL,
                S.TOTAL_AMOUNT,
                S.OTHER_TOTAL_AMOUNT,
                S.OTHER_MONEY,
                S.PLANNER_EMP_ID,
                S.SALES_QUOTA_ID,
                S.CONSUMER_ID,       
                E.EMPLOYEE_NAME,
                E.EMPLOYEE_SURNAME,
                PTR.STAGE,
                C.NICKNAME,
                CON.CONSUMER_NAME,
                CON.CONSUMER_SURNAME
                <cfif Len(attributes.listing_type) and attributes.listing_type eq 1>
                	,SW.SALES_QUOTA_ROW_ID,
                    SW.SUPPLIER_ID,
                    SW.BRAND_ID,
                    SW.CATEGORY_ID,
                    SW.MULTI_CATEGORY_ID,
                    SW.QUANTITY,
                    SW.ROW_PREMIUM_PERCENT,
                    SW.ROW_PREMIUM_TOTAL,
                    SW.ROW_EXTRA_STOCK,
                    SW.ROW_PROFIT_PERCENT, 
                    SW.ROW_PROFIT_TOTAL,
                    SW.ROW_TOTAL,
                    PB.BRAND_NAME,	 	 			
                	P.PRODUCT_NAME,
                    (
					CASE WHEN CATEGORY_ID IS NOT NULL
						THEN (SELECT PRODUCT_CAT FROM PRODUCT_CAT WHERE PRODUCT_CATID = SW.CATEGORY_ID)
					WHEN MULTI_CATEGORY_ID IS NOT NULL
						THEN (
								SELECT LEFT(PRODUCT_CAT, LEN(PRODUCT_CAT) - 1) 
								FROM 
								(
								SELECT PRODUCT_CAT + ',' FROM PRODUCT_CAT WHERE CHARINDEX(','+CONVERT(VARCHAR(MAX),PRODUCT_CATID)+',',MULTI_CATEGORY_ID) <> 0
								FOR XML PATH ('')
								) c (PRODUCT_CAT)
						)
					ELSE
						''
					END
				) AS CAT_NAME
                </cfif>
            FROM
                <cfif Len(attributes.listing_type) and attributes.listing_type eq 1><!--- Satir Bazinda --->
                    SALES_QUOTAS_ROW SW
                    LEFT JOIN #dsn1_alias#.PRODUCT P ON P.PRODUCT_ID = SW.PRODUCT_ID
                    LEFT JOIN PRODUCT_CAT PC ON SW.CATEGORY_ID = PC.PRODUCT_CATID
                	LEFT JOIN #dsn1_alias#.PRODUCT_BRANDS PB ON SW.BRAND_ID = PB.BRAND_ID,
                </cfif>
                SALES_QUOTAS S
                LEFT JOIN #dsn_alias#.EMPLOYEES E ON S.PLANNER_EMP_ID = E.EMPLOYEE_ID
                LEFT JOIN #dsn_alias#.PROCESS_TYPE_ROWS PTR ON S.PROCESS_STAGE = PTR.PROCESS_ROW_ID
                LEFT JOIN #dsn_alias#.COMPANY C ON S.COMPANY_ID = C.COMPANY_ID
                LEFT JOIN #dsn_alias#.CONSUMER CON ON CON.CONSUMER_ID = S.CONSUMER_ID
            WHERE 
                S.SALES_QUOTA_ID IS NOT NULL
                <cfif Len(attributes.listing_type) and attributes.listing_type eq 1>
                    AND S.SALES_QUOTA_ID = SW.SALES_QUOTA_ID
                </cfif>
                <cfif len(attributes.keyword)>
                    AND S.PAPER_NO LIKE '%#attributes.keyword#%'
                </cfif>	
                <cfif len(attributes.process_stage_type)>
                    AND S.PROCESS_STAGE = #attributes.process_stage_type#
                </cfif>
                <cfif len(attributes.is_active)>
                    AND S.IS_ACTIVE = #attributes.is_active#
                </cfif>
                <cfif len(attributes.ch_company_id) and len(attributes.ch_company)>
                    AND S.COMPANY_ID = #attributes.ch_company_id#
                </cfif>
                <cfif len(attributes.ch_consumer_id)  and len(attributes.ch_company)>
                    AND S.CONSUMER_ID = #attributes.ch_consumer_id#
                </cfif>
                <cfif len(attributes.employee_id) and len(attributes.employee_name)>
                    AND S.EMPLOYEE_ID = #attributes.employee_id#
                </cfif>
                <cfif len(attributes.team_id) and len(attributes.team_name)>
                    AND S.TEAM_ID = #attributes.team_id#
                </cfif>
                <cfif len(attributes.quota_type)>
                    AND S.IS_SALES_PURCHASE = #attributes.quota_type#
                </cfif>
                <cfif Len(attributes.listing_type) and attributes.listing_type eq 1>
                    <cfif len(attributes.period_type)>
                        AND SW.PERIOD_TYPE = #attributes.period_type#
                    </cfif>
                    <cfif len(attributes.result_info)>
                        <cfif attributes.result_info eq 0>
                            AND (SELECT COUNT(SQRR.RELATION_ID) FROM SALES_QUOTAS_ROW_RELATION SQRR WHERE SQRR.SALES_QUOTAS_ROW_ID = SW.SALES_QUOTA_ROW_ID AND TYPE = 1) < SW.PERIOD_COUNT
                        <cfelse>
                            AND (SELECT COUNT(SQRR.RELATION_ID) FROM SALES_QUOTAS_ROW_RELATION SQRR WHERE SQRR.SALES_QUOTAS_ROW_ID = SW.SALES_QUOTA_ROW_ID AND TYPE = 1) = SW.PERIOD_COUNT
                        </cfif>
                    </cfif>
                <cfelse>
                    <cfif len(attributes.period_type)>
                        AND S.SALES_QUOTA_ID IN(SELECT SWW.SALES_QUOTA_ID FROM SALES_QUOTAS_ROW SWW WHERE SWW.PERIOD_TYPE = #attributes.period_type#)
                    </cfif>
                </cfif>
                <cfif isDate(attributes.start_date)>
                    AND S.PLAN_DATE >= #attributes.start_date#
                </cfif>
                <cfif isDate(attributes.finish_date)>
                    AND S.FINISH_DATE <= #attributes.finish_date#
                </cfif>
            ORDER BY
                S.PLAN_DATE
        </cfquery>    
	<cfelse>
        <cfset Get_Sales_Quota.recordcount = 0>
    </cfif>
    <cfquery name="GET_STAGE" datasource="#DSN#">
        SELECT
            PTR.STAGE,
            PTR.PROCESS_ROW_ID 
        FROM
            PROCESS_TYPE_ROWS PTR,
            PROCESS_TYPE_OUR_COMPANY PTO,
            PROCESS_TYPE PT
        WHERE
            PT.IS_ACTIVE = 1 AND
            PT.PROCESS_ID = PTR.PROCESS_ID AND
            PT.PROCESS_ID = PTO.PROCESS_ID AND
            PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%salesplan.list_sales_quotas%">
        ORDER BY
            PTR.LINE_NUMBER
    </cfquery>
    <cfparam name="attributes.page" default="1">
    <cfparam name="attributes.is_form_submitted" default="">
    <cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
    <cfparam name="attributes.totalrecords" default="#GET_SALES_QUOTA.recordcount#">
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfelseif isdefined("attributes.event") and ListFindNoCase('add,upd',attributes.event)>
	<cf_xml_page_edit fuseact="salesplan.add_sales_quota">   
	<cfif isdefined("attributes.q_id") and len(attributes.q_id)>
        <cfquery name="get_sales_quotas" datasource="#dsn3#">
            SELECT 
            	SQ.*,
                SZT.TEAM_NAME 
            FROM 
            	SALES_QUOTAS SQ
                LEFT JOIN  #dsn_alias#.SALES_ZONES_TEAM SZT ON SQ.TEAM_ID = SZT.TEAM_ID
            WHERE 
            	SQ.SALES_QUOTA_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.q_id#">
        </cfquery>
        <cfquery name="get_sales_quotas_row" datasource="#dsn3#">
            SELECT 
            	* 
           FROM 
           		SALES_QUOTAS_ROW SQR
                LEFT JOIN #dsn_alias#.COMPANY C ON C.COMPANY_ID = SQR.SUPPLIER_ID
                LEFT JOIN #dsn3_alias#.PRODUCT_BRANDs PB ON PB.BRAND_ID = SQR.BRAND_ID 
			WHERE 
            	SALES_QUOTA_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.q_id#"> 
			ORDER BY SALES_QUOTA_ROW_ID
        </cfquery>
        <cfquery name="get_sales_quotas_money" datasource="#dsn3#">
            SELECT MONEY_TYPE AS MONEY,* FROM SALES_QUOTAS_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.q_id#">
        </cfquery>
    </cfif>
	<cfif (isdefined("attributes.q_id") and not get_sales_quotas_money.recordcount) or not isdefined("attributes.q_id")>
        <cfquery name="get_sales_quotas_money" datasource="#dsn2#">
            SELECT MONEY,0 AS IS_SELECTED,* FROM SETUP_MONEY ORDER BY MONEY_ID
        </cfquery>
    </cfif>
    <cfquery name="GET_PRODUCT_CAT" datasource="#DSN3#">
        SELECT HIERARCHY,PRODUCT_CATID,PRODUCT_CAT FROM PRODUCT_CAT ORDER BY HIERARCHY
    </cfquery>
    <cfquery name="get_company_cat" datasource="#DSN#">
        SELECT COMPANYCAT_ID, COMPANYCAT FROM  COMPANY_CAT  ORDER BY COMPANYCAT
    </cfquery>
    <cfquery name="GET_SALES_ZONES" datasource="#dsn#">
        SELECT SZ_ID,SZ_NAME FROM SALES_ZONES ORDER BY SZ_NAME
    </cfquery>
	 <cfif is_multi_dimension eq 1>
            <cfquery name="GET_CUSTOMER_VALUE" datasource="#DSN#">
                SELECT CUSTOMER_VALUE_ID,CUSTOMER_VALUE FROM SETUP_CUSTOMER_VALUE ORDER BY CUSTOMER_VALUE
            </cfquery>
            <cfquery name="GET_RESOURCE" datasource="#dsn#">
                SELECT RESOURCE_ID,RESOURCE FROM COMPANY_PARTNER_RESOURCE ORDER BY RESOURCE
            </cfquery>            
            <cfif isdefined("attributes.q_id") and len(get_sales_quotas.related_budget_id)>	
                <cfquery name="get_budget" datasource="#dsn#">
                    SELECT BUDGET_NAME FROM BUDGET WHERE BUDGET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_sales_quotas.related_budget_id#">
                </cfquery>
            </cfif>
            <cfif isdefined("attributes.q_id") and Len(get_sales_quotas.branch_id)>
                <cfquery name="get_branch" datasource="#dsn#">
                    SELECT BRANCH_NAME FROM BRANCH WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_sales_quotas.branch_id#">
                </cfquery>
            </cfif>
            <cfif isdefined("attributes.q_id") and Len(get_sales_quotas.department_id)>
                <cfquery name="get_department" datasource="#dsn#">
                    SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_sales_quotas.department_id#">
                </cfquery>
            </cfif>
	</cfif>
	<cfif isdefined("attributes.q_id") and Len(get_sales_quotas.ims_code_id)>
        <cfquery name="get_ims" datasource="#dsn#">
            SELECT IMS_CODE,IMS_CODE_NAME FROM SETUP_IMS_CODE WHERE IMS_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_SALES_QUOTAS.IMS_CODE_ID#">
        </cfquery>
    </cfif>
	<cfif attributes.event is 'add'> 
        <cfset attributes.start_date = date_add('d',-7,createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#'))>
        <cfset attributes.finish_date = date_add('d',+7,createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#'))>
        <cfif is_multi_dimension eq 1>   
            
            
            
        </cfif>		
	</cfif>   
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$( document ).ready(function() {
			document.list_quota.keyword.focus();
		});	
		function kontrol()
		{
			if (!date_check (document.getElementById('start_date'),document.getElementById('finish_date'),"<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Büyün Olamaz'>!"))
				return false;
			else
				return true;
		}
		function connectAjax(crtrow,q_id)
		{
			var bb = '<cfoutput>#request.self#?fuseaction=salesplan.emptypopup_dsp_detail_quota_result&quota_row_id='+q_id+'&premium_stock_id=#premium_stock_id#</cfoutput>';
			AjaxPageLoad(bb,'DISPLAY_QUOTA_DETAIL'+crtrow,1);
		}
	<cfelseif isdefined("attributes.event") and listfindnocase('add,upd',attributes.event)>
		<cfif isdefined("attributes.q_id") and len(attributes.q_id)>
				row_count=<cfoutput>#get_sales_quotas_row.recordcount#</cfoutput>;
			<cfelse>
				row_count=0;
		</cfif>
			function sil(sy)
			{
				var my_element=eval("document.sales_quota.row_kontrol"+sy);
				my_element.value=0;
				var my_element=eval("frm_row"+sy);
				my_element.style.display="none";
				toplam_hesapla();
			}
			function autocomp(no)
			{
				AutoComplete_Create("row_comp_name" + no,"MEMBER_NAME,MEMBER_PARTNER_NAME","MEMBER_NAME,MEMBER_PARTNER_NAME","get_member_autocomplete","1,0,0","COMPANY_ID","row_company_id" + no,"sales_quota",3,225);
			}
			function pencere_ac_brand(no)
			{
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_brands&brand_id=sales_quota.row_brand_id' + no +'&brand_name=sales_quota.row_brand_name' + no +'','list');
			}
			function pencere_ac_company(no)
			{
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&select_list=2&field_comp_name=sales_quota.row_comp_name' + no +'&field_comp_id=sales_quota.row_company_id' + no + '','list');
			}
			function pencere_ac_category(no)
			{
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_cat_names&field_id=sales_quota.row_category' + no + '&field_name=sales_quota.row_category_name' + no + '&is_sub_category=1<cfif x_row_multi_category_selected eq 1>&is_multi_selection=1</cfif>','list');
			}
			function Dhesapla(row_no)
			{
				
				var d_satir_toplam=filterNum(eval('document.sales_quota.row_other_total'+row_no).value);
				var d_satir_toplam_max = filterNum(eval('document.sales_quota.row_other_total_max'+row_no).value);
				if('<cfoutput>#session.ep.money2#</cfoutput>' == '')
					for(i=1;i<=document.sales_quota.kur_say.value;i++)
					{
						if(document.sales_quota.rd_money.checked == true)
						{
							form_txt_rate2_ = filterNum(eval("document.sales_quota.txt_rate2_"+i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
							eval('document.sales_quota.row_total'+row_no).value = commaSplit(d_satir_toplam*form_txt_rate2_);
							eval('document.sales_quota.row_total_max'+row_no).value = commaSplit(d_satir_toplam_max*form_txt_rate2_);
						}
					}
				else 
					for(i=1;i<=document.sales_quota.kur_say.value;i++)
					{
						if(document.sales_quota.rd_money[i-1].checked == true)
						{
							form_txt_rate2_ = filterNum(eval("document.sales_quota.txt_rate2_"+i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
							eval('document.sales_quota.row_total'+row_no).value = commaSplit(d_satir_toplam*form_txt_rate2_);
							eval('document.sales_quota.row_total_max'+row_no).value = commaSplit(d_satir_toplam_max*form_txt_rate2_);
						}
					}
					hesapla(row_no,0);
			}
			function hesapla(row_no,type)//satirdaki işlemleri hesaplar
			{	
				var satir_toplam = filterNum(eval('document.sales_quota.row_total'+row_no).value);
				var satir_toplam_max = filterNum(eval('document.sales_quota.row_total_max'+row_no).value);
				if(type != undefined && type == 1 && document.sales_quota.x_premium_percent_2_3.value != 1)
				{
					eval('document.sales_quota.premium_per_'+row_no).value = commaSplit(filterNum(commaSplit(filterNum(eval('document.sales_quota.row_premium_total'+row_no).value)*100/satir_toplam)));
					eval('document.sales_quota.profit_per'+row_no).value = commaSplit(filterNum(commaSplit(filterNum(eval('document.sales_quota.row_profit_total'+row_no).value)*100/satir_toplam)));
				}
				else
				{
					var row_premium_total_1 = filterNum(commaSplit(satir_toplam*filterNum(eval('document.sales_quota.premium_per_'+row_no).value)/100));
					var row_premium_total_2 = filterNum(commaSplit((satir_toplam-row_premium_total_1)*filterNum(eval('document.sales_quota.premium_per2_'+row_no).value)/100));
					var row_premium_total_3 = filterNum(commaSplit((satir_toplam-row_premium_total_1-row_premium_total_2)*filterNum(eval('document.sales_quota.premium_per3_'+row_no).value)/100));
					eval('document.sales_quota.row_premium_total'+row_no).value = commaSplit(row_premium_total_1 + row_premium_total_2 + row_premium_total_3);
					eval('document.sales_quota.row_profit_total'+row_no).value = commaSplit(satir_toplam*filterNum(eval('document.sales_quota.profit_per'+row_no).value)/100);
				}
				if(type==undefined || (type!=undefined && type!=0))
				{
				<cfif attributes.event is 'add'>	
					if('<cfoutput>#session.ep.money2#</cfoutput>' == '')
				<cfelseif attributes.event is 'upd'>
					if(document.sales_quota.kur_say.value == 1)
				</cfif>
					for(i=1;i<=document.sales_quota.kur_say.value;i++)
					{
						if(document.sales_quota.rd_money.checked == true)
						{
							form_txt_rate2_ = filterNum(eval("document.sales_quota.txt_rate2_"+i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
							eval('document.sales_quota.row_other_total'+row_no).value = commaSplit(satir_toplam/form_txt_rate2_);
							eval('document.sales_quota.row_other_total_max'+row_no).value = commaSplit(satir_toplam_max/form_txt_rate2_);
						}
					}
				else 
					for(i=1;i<=document.sales_quota.kur_say.value;i++)
					{
						if(document.sales_quota.rd_money[i-1].checked == true)
						{
							form_txt_rate2_ = filterNum(eval("document.sales_quota.txt_rate2_"+i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
							eval('document.sales_quota.row_other_total'+row_no).value = commaSplit(satir_toplam/form_txt_rate2_);
							eval('document.sales_quota.row_other_total_max'+row_no).value = commaSplit(satir_toplam_max/form_txt_rate2_);
						}
					}
				}
				toplam_hesapla();
			}
			
			function toplam_hesapla()
			{
				var total_quantity = 0;
				var total_amount = 0;
				var other_total_amount = 0;
				<cfif attributes.event is 'add'>
					var stock_quantity_total = 0;
				<cfelseif attributes.event is 'upd'>
					var extra_stock_total = 0;
				</cfif>
				var prem_total = 0;
				var total_profit = 0;
				for(j=1;j<=document.sales_quota.record_num.value;j++)
				{		
					if(eval("document.sales_quota.row_kontrol"+j).value==1)
					{
						total_quantity += parseFloat(filterNum(eval('document.sales_quota.quantity'+j).value));
						total_amount += parseFloat(filterNum(eval('document.sales_quota.row_total'+j).value));
						other_total_amount += parseFloat(filterNum(eval('document.sales_quota.row_other_total'+j).value));						
						<cfif attributes.event is 'add'>
							stock_quantity_total += parseFloat(filterNum(eval('document.sales_quota.extra_stock'+j).value));
						<cfelseif attributes.event is 'upd'>
							extra_stock_total  += parseFloat(filterNum(eval('document.sales_quota.extra_stock'+j).value));
						</cfif>
						prem_total += parseFloat(filterNum(eval('document.sales_quota.row_premium_total'+j).value));
						total_profit += parseFloat(filterNum(eval('document.sales_quota.row_profit_total'+j).value));
					}
				}
				document.sales_quota.toplam_miktar.value = total_quantity;
				document.sales_quota.toplam_tutar.value = commaSplit(total_amount);
				document.sales_quota.tutar_doviz.value = commaSplit(other_total_amount);				
				<cfif attributes.event is 'add'>
					document.sales_quota.mal_miktar.value = stock_quantity_total;
				<cfelseif attributes.event is 'upd'>
					document.sales_quota.mal_miktar.value = extra_stock_total;
				</cfif>
				document.sales_quota.prim_tutar.value = commaSplit(prem_total);
				document.sales_quota.kar_tutar.value = commaSplit(total_profit);
				
			}
			function toplam_doviz_hesapla()
			{
				<cfif attributes.event is 'add'>
				if('<cfoutput>#session.ep.money2#</cfoutput>' == '')
				<cfelseif attributes.event is 'upd'>
				if(document.sales_quota.kur_say.value == 1)
				</cfif>
					for (var t=1; t<=document.sales_quota.kur_say.value; t++)
					{		
						if(document.sales_quota.rd_money.checked == true)
						{
							for(k=1;k<=document.sales_quota.record_num.value;k++)
							{		
								rate2_value = filterNum(eval("document.sales_quota.txt_rate2_"+t).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
								eval('document.sales_quota.row_other_total'+k).value = commaSplit(filterNum(eval('document.sales_quota.row_total'+k).value)/rate2_value);
								eval('document.sales_quota.row_other_total_max'+k).value = commaSplit(filterNum(eval('document.sales_quota.row_total_max'+k).value)/rate2_value);
							}
						}
					}
			
				else
					for (var t=1; t<=document.sales_quota.kur_say.value; t++)
					{		
						if(document.sales_quota.rd_money[t-1].checked == true)
						{
							for(k=1;k<=document.sales_quota.record_num.value;k++)
							{		
								rate2_value = filterNum(eval("document.sales_quota.txt_rate2_"+t).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
								eval('document.sales_quota.row_other_total'+k).value = commaSplit(filterNum(eval('document.sales_quota.row_total'+k).value)/rate2_value);
								eval('document.sales_quota.row_other_total_max'+k).value = commaSplit(filterNum(eval('document.sales_quota.row_total_max'+k).value)/rate2_value);
							}
						}
					}
				toplam_hesapla();
			}
			function kontrol()
			{	
				var record_exist=0;
				period_list_0 = '';
				period_list_1 = '';
				period_list_2 = '';
				period_list_3 = '';
				for(r=1;r<=document.sales_quota.record_num.value;r++)
				{
					if(eval("document.sales_quota.row_kontrol"+r).value==1)
					{
						record_exist=1;
						if(eval('document.sales_quota.period_type'+r).value == 0)
							period_list_0+=eval('document.sales_quota.period_type'+r).value;
						else if(eval('document.sales_quota.period_type'+r).value == 1)
							period_list_1+=eval('document.sales_quota.period_type'+r).value;
						else if(eval('document.sales_quota.period_type'+r).value == 1)
							period_list_2+=eval('document.sales_quota.period_type'+r).value;
						else
							period_list_3+=eval('document.sales_quota.period_type'+r).value;
					}
				}
				if(document.sales_quota.employee_name != undefined && document.sales_quota.employee_name.value != '' && document.sales_quota.team_name.value != '') 
				{
					alert("<cf_get_lang no='152.Lütfen Takım veya Çalışandan Sadece Birini Seçiniz'>!");
					return false;
				}
				if(document.sales_quota.employee_name != undefined && document.sales_quota.employee_name.value == '' && document.sales_quota.team_name.value == '') 
				{
					alert("<cf_get_lang no='153.Lütfen Takım veya Çalışandan Birini Seçiniz'>!");
					return false;
				}
				if (document.sales_quota.quota_type.value == '') 
				{
					alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang no='150.Kota Türü'>!");
					return false;
				}
				new_diff = datediff(document.sales_quota.start_date.value,document.sales_quota.finish_date.value,0);
				<cfif x_period_type eq 1>
					if((period_list_0 != '' || period_list_1 != ''|| period_list_2 != '' || period_list_3 != '') && new_diff < 89)
					{
						alert("3 Aylık Planlama Yapabilmek İçin Tarih Aralığı 90'dan Küçük Olmamalı !");
						return false;
					}
				</cfif>
					/*if(period_list_0 != '' && new_diff < 30)
					{
						alert("<cf_get_lang no='193.Aylık Planlama Yapabilmek İçin Tarih Aralığı 30 dan Küçük Olmamalı'> !");
						return false;
					}
					else if(period_list_1 != '' && new_diff < 90)
					{
						alert("<cf_get_lang no='194.3 Aylık Planlama Yapabilmek İçin Tarih Aralığı 90 dan Küçük Olmamalı'> !");
						return false;
					}
					else if(period_list_2 != '' && new_diff < 364)
					{
						alert("<cf_get_lang no='195.Yıllık Planlama Yapabilmek İçin Tarih Aralığı 365 den Küçük Olmamalı'> !");
						return false;
					}*/		
				
				if (record_exist == 0) 
				{
					alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='1096.Satır'>");
					return false;
				}
				unformat_fields();
				return process_cat_control();
				return false;
			}
			function unformat_fields()
			{
				for(rm=1;rm<=document.sales_quota.record_num.value;rm++)
				{
					eval("document.sales_quota.row_total"+rm).value =  filterNum(eval("document.sales_quota.row_total"+rm).value);
					eval("document.sales_quota.row_total_max"+rm).value =  filterNum(eval("document.sales_quota.row_total_max"+rm).value);
					eval("document.sales_quota.quantity"+rm).value =  filterNum(eval("document.sales_quota.quantity"+rm).value);
					eval("document.sales_quota.row_other_total"+rm).value =  filterNum(eval("document.sales_quota.row_other_total"+rm).value);
					eval("document.sales_quota.row_other_total_max"+rm).value =  filterNum(eval("document.sales_quota.row_other_total_max"+rm).value);
					eval("document.sales_quota.premium_per_"+rm).value =  filterNum(eval("document.sales_quota.premium_per_"+rm).value);
					eval("document.sales_quota.premium_per2_"+rm).value =  filterNum(eval("document.sales_quota.premium_per2_"+rm).value);
					eval("document.sales_quota.premium_per3_"+rm).value =  filterNum(eval("document.sales_quota.premium_per3_"+rm).value);
					eval("document.sales_quota.row_premium_total"+rm).value =  filterNum(eval("document.sales_quota.row_premium_total"+rm).value);
					eval("document.sales_quota.profit_per"+rm).value =  filterNum(eval("document.sales_quota.profit_per"+rm).value);
					eval("document.sales_quota.row_profit_total"+rm).value =  filterNum(eval("document.sales_quota.row_profit_total"+rm).value);
				}
			
				document.sales_quota.toplam_tutar.value = filterNum(document.sales_quota.toplam_tutar.value);
				document.sales_quota.toplam_miktar.value = filterNum(document.sales_quota.toplam_miktar.value);
				document.sales_quota.tutar_doviz.value = filterNum(document.sales_quota.tutar_doviz.value);
				document.sales_quota.prim_tutar.value = filterNum(document.sales_quota.prim_tutar.value);
				document.sales_quota.kar_tutar.value = filterNum(document.sales_quota.kar_tutar.value);
				for(st=1;st<=document.sales_quota.kur_say.value;st++)
				{
					eval('document.sales_quota.txt_rate2_' + st).value = filterNum(eval('document.sales_quota.txt_rate2_' + st).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
					eval('document.sales_quota.txt_rate1_' + st).value = filterNum(eval('document.sales_quota.txt_rate1_' + st).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				}
			}
				function ac_kapa(type)
	{
	/* type1=Tedarikci type2=Marka type3=Kategori type4=Ürün */
		if(type==1)
		{
			if(document.sales_quota.is_wiew_purveyor.checked == false)
			{
				gizle(g_tedarikci);
				for(rt=1;rt<=row_count;rt++)
					gizle(eval("tedarikci_"+rt));
			}
			else 
			{
				goster(g_tedarikci);
				for(dt=1;dt<=row_count;dt++)
					goster(eval("tedarikci_"+dt));
			}
		}
		if(type==2)
		{
			if(document.sales_quota.is_wiew_mark.checked == false)
			{
				gizle(g_marka);
				for(rt=1;rt<=row_count;rt++)
					gizle(eval("marka_"+rt));
			}
			else 
			{
				//Ürün gizleniyor
				document.sales_quota.is_wiew_product.checked = false
				gizle(g_urun);
				gizle(g_mal_fazlasi);
				for(rt=1;rt<=row_count;rt++)
				{
					gizle(eval("urun_"+rt));
					gizle(eval("mal_fazlasi"+rt));
				}
				goster(g_marka);
				for(dt=1;dt<=row_count;dt++)
					goster(eval("marka_"+dt));
			}
		}
		if(type==3)
		{
			if(document.sales_quota.is_wiew_cat.checked == false)
			{
				gizle(g_kategori);
				for(rt=1;rt<=row_count;rt++)
					gizle(eval("kategori_"+rt));
				<cfif x_products_not_included eq 1>
					gizle(g_urun2_);
					for(ut=1;ut<=row_count;ut++)
						gizle(eval("urun2_"+ut));
				</cfif>
			}
			else 
			{
				<cfif attributes.event is 'add'>
				//Ürün gizleniyor
				document.sales_quota.is_wiew_product.checked = false
				gizle(g_urun);
				for(rt=1;rt<=row_count;rt++)
					gizle(eval("urun_"+rt));
				<cfelseif attributes.event is 'upd'>
					for(rt=1;rt<=row_count;rt++)
						gizle(eval("urun_"+rt));	
				</cfif>	
				goster(g_kategori);
				for(dt=1;dt<=row_count;dt++)
					goster(eval("kategori_"+dt));
				<cfif x_products_not_included eq 1>
					goster(g_urun2_);
					for(ut=1;ut<=row_count;ut++)
						goster(eval("urun2_"+ut));
				</cfif>
			}
		}
		if(type==4)
		{
			if(document.sales_quota.is_wiew_product.checked == false)
			{
				gizle(g_urun);
				gizle(g_mal_fazlasi);
				for(rt=1;rt<=row_count;rt++)
				{
					gizle(eval("urun_"+rt));
					gizle(eval("mal_fazlasi"+rt));
				}
			}
			else 
			{
				//Kategori gizleniyor
				gizle(g_kategori);
				document.sales_quota.is_wiew_cat.checked = false
				for(rt=1;rt<=row_count;rt++)
					gizle(eval("kategori_"+rt));
				<cfif x_products_not_included eq 1>
					//Urun2 gizleniyor
					gizle(g_urun2_);
					document.sales_quota.is_wiew_cat.checked = false
					for(ut=1;ut<=row_count;ut++)
						gizle(eval("urun2_"+ut));
				</cfif>
				//Marka Gizleniyor
				gizle(g_marka);
				document.sales_quota.is_wiew_mark.checked = false
				for(rt=1;rt<=row_count;rt++)
					gizle(eval("marka_"+rt));
				//Ürün Gösteriliyor
				goster(g_urun);
				goster(g_mal_fazlasi);
				for(dt=1;dt<=row_count;dt++)
				{
					goster(eval("urun_"+dt));
					goster(eval("mal_fazlasi"+dt));
				}
			}
		}
	}	
		<cfif attributes.event is 'upd'>
			function add_row()
			{
				if(document.sales_quota.is_wiew_purveyor.checked==true)
					var ekle_tedarik=1;
				else
					var ekle_tedarik=0;
				
				if(document.sales_quota.is_wiew_mark.checked==true)
					var ekle_marka=1;
				else
					var ekle_marka=0;
				
				if(document.sales_quota.is_wiew_cat.checked==true)
				{
					var ekle_kategori=1;
					var ekle_urun2_=1;
				}
				else
				{
					var ekle_kategori=0;
					var ekle_urun2_=0;
				}
				
				if(document.sales_quota.is_wiew_product.checked==true)
					var ekle_urun=1;
				else
					var ekle_urun=0;
				
				row_count++;
				var newRow;
				var newCell;
				newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
				newRow.setAttribute("name","frm_row" + row_count);
				newRow.setAttribute("id","frm_row" + row_count);		
				newRow.setAttribute("NAME","frm_row" + row_count);
				newRow.setAttribute("ID","frm_row" + row_count);		
				newRow.className = 'color-row';
				document.sales_quota.record_num.value=row_count;
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" ><a style="cursor:pointer" onclick="sil(' + row_count + ');"  ><img  src="images/delete_list.gif" border="0"></a>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute("name","tedarikci_" + row_count);
				newCell.setAttribute("id","tedarikci_" + row_count);		
				newCell.setAttribute("NAME","tedarikci_" + row_count);
				newCell.setAttribute("ID","tedarikci_" + row_count);
				if(ekle_tedarik==0)
					newCell.style.display = 'none';
				newCell.innerHTML = '<input type="hidden" name="row_company_id' + row_count +'" id="row_company_id' + row_count +'"><input type="text" name="row_comp_name' + row_count +'" id="row_comp_name' + row_count +'" style="width:123px;"  class="boxtext" onFocus="autocomp('+row_count+');"><a href="javascript://"><img src="/images/plus_thin.gif" onclick="pencere_ac_company('+ row_count +');" align="absmiddle" border="0"></a>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute("name","marka_" + row_count);
				newCell.setAttribute("id","marka_" + row_count);		
				newCell.setAttribute("NAME","marka_" + row_count);
				newCell.setAttribute("ID","marka_" + row_count);
				if(ekle_marka==0)
					newCell.style.display = 'none';
				newCell.innerHTML = '<input type="hidden" name="row_brand_id' + row_count +'"><input type="text" name="row_brand_name' + row_count +'"  style="width:118px;" class="boxtext"><a href="javascript://"><img src="/images/plus_thin.gif" onclick="pencere_ac_brand('+ row_count +');" align="absmiddle" border="0"></a>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute('nowrap','nowrap');
				newCell.setAttribute("name","kategori_" + row_count);
				newCell.setAttribute("id","kategori_" + row_count);		
				newCell.setAttribute("NAME","kategori_" + row_count);
				newCell.setAttribute("ID","kategori_" + row_count);
				if(ekle_kategori==0)
					newCell.style.display = 'none';
				newCell.innerHTML ='<input type="hidden" name="row_category'+ row_count +'" id="row_category'+ row_count +'"><input type="text" style="width:<cfif x_row_multi_category_selected eq 1>240<cfelse>110</cfif>px;" readonly class="boxtext" name="row_category_name'+ row_count +'" id="PRODUCT_CAT'+ row_count +'"> <a href="javascript://"><img src="/images/plus_thin.gif" onclick="pencere_ac_category('+ row_count +');"  border="0" align="absmiddle" alt="Ürün Kategorisi Ekle!"></a>';
				<cfif x_products_not_included eq 1>
						newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("name","urun2_" + row_count);
					newCell.setAttribute("id","urun2_" + row_count);		
					newCell.setAttribute("NAME","urun2_" + row_count);
					newCell.setAttribute("ID","urun2_" + row_count);
					if(ekle_urun2_==0)
						newCell.style.display = 'none';
					newCell.innerHTML = '<input  type="hidden" name="product_id2' + row_count +'"><input  type="hidden" name="stock_id2' + row_count +'" ><input type="text" name="product_name2' + row_count +'" class="boxtext" style="width:240px;"> <a href="javascript://" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_product_names</cfoutput>&product_id=sales_quota.product_id2" + row_count + "&field_id=sales_quota.stock_id2" + row_count + "&field_name=sales_quota.product_name2" + row_count +"&is_multi_selection=1','list');"+'"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>';
				</cfif>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute("name","urun_" + row_count);
				newCell.setAttribute("id","urun_" + row_count);		
				newCell.setAttribute("NAME","urun_" + row_count);
				newCell.setAttribute("ID","urun_" + row_count);
				if(ekle_urun==0)
					newCell.style.display = 'none';
				newCell.innerHTML = '<input  type="hidden" name="product_id' + row_count +'"><input  type="hidden" name="stock_id' + row_count +'" ><input type="text" name="product_name' + row_count +'" class="boxtext" style="width:133px;"><a href="javascript://" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_product_names</cfoutput>&product_id=sales_quota.product_id" + row_count + "&field_id=sales_quota.stock_id" + row_count + "&field_name=sales_quota.product_name" + row_count + "','list');"+'"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>';
				<cfif x_period_type eq 1>
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<select name="period_type'+ row_count +'" style="width:150px;" class="box"><option value="0">1.Dönem(01.01-31.03)</option><option value="1">2.Dönem(01.04-30.06)</option><option value="2">3.Dönem(01.07-30.09)</option><option value="3">4.Dönem(01.10-31.12)</option></select>';
				<cfelse>
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<select name="period_type'+ row_count +'" style="width:70px;" class="box"><option value="0">Ay</option><option value="1">3 Ay</option><option value="2">Yıl</option></select>';
				</cfif>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="quantity' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event,0));" style="width:100%;" class="box" onBlur="if(filterNum(this.value) <=1) this.value=1;hesapla('+row_count+');">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="row_total' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+');">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="row_total_max' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+');">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="row_other_total' + row_count +'" value="0"  onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);Dhesapla('+row_count+');">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="row_other_total_max' + row_count +'" value="0"  onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);Dhesapla('+row_count+');">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="premium_per_' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+');">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="premium_per2_' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+');">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="premium_per3_' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+');">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="row_premium_total' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+',1);">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute("id","mal_fazlasi" + row_count);
				if(ekle_urun==0)
					newCell.style.display = 'none';
				newCell.innerHTML = '<input type="text" name="extra_stock' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event,0));" style="width:100%;" class="box" onBlur="if(filterNum(this.value) <0) this.value=0;hesapla('+row_count+');">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="profit_per' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+');">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="row_profit_total' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+',1);">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="row_detail' + row_count +'" style="width:100%;" class="boxtext" maxlength="300">';
				newCell = newRow.insertCell(newRow.cells.length);		


			}
		</cfif>
	
		<cfif attributes.event is 'add'>			
			function add_row(row_company_id,row_comp_name,row_brand_id,row_brand_name,row_category,row_category_name,product_id,stock_id,product_name,period_type,quantity,row_total,row_total_max,row_other_total,row_other_total_max,premium_per_,premium_per2_,premium_per3_,row_premium_total,extra_stock,profit_per,row_profit_total,row_detail)
			{
				if(quantity) // Import dosyada zorunlu alan
					import_file = 1;
				else
					import_file = 0;
		
				if(document.sales_quota.is_wiew_purveyor.checked==true)
					var ekle_tedarik=1;
				else
					var ekle_tedarik=0;
				
				if(document.sales_quota.is_wiew_mark.checked==true)
					var ekle_marka=1;
				else
					var ekle_marka=0;
				
				if(document.sales_quota.is_wiew_cat.checked==true)
				{
					var ekle_kategori=1;
					var ekle_urun2_=1;
				}
				else
				{
					var ekle_kategori=0;
					var ekle_urun2_=0;
				}
				
				if(document.sales_quota.is_wiew_product.checked==true)
					var ekle_urun=1;
				else
					var ekle_urun=0;
				
				row_count++;
				var newRow;
				var newCell;
				newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
				newRow.setAttribute("name","frm_row" + row_count);
				newRow.setAttribute("id","frm_row" + row_count);		
				newRow.setAttribute("NAME","frm_row" + row_count);
				newRow.setAttribute("ID","frm_row" + row_count);		
				newRow.className = 'color-row';
				document.sales_quota.record_num.value=row_count;
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute('nowrap','nowrap');
				newCell.innerHTML = '<input type="hidden" value="1" name="row_kontrol' + row_count +'" ><a style="cursor:pointer" onclick="sil(' + row_count + ');"><img  src="images/delete_list.gif" border="0"></a>';
				newCell = newRow.insertCell(newRow.cells.length);//Tedarikçi
				newCell.setAttribute("name","tedarikci_" + row_count);
				newCell.setAttribute("id","tedarikci_" + row_count);		
				newCell.setAttribute("NAME","tedarikci_" + row_count);
				newCell.setAttribute("ID","tedarikci_" + row_count);
				if(ekle_tedarik==0)
					newCell.style.display = 'none';	
				newCell.setAttribute('nowrap','nowrap');	
				if(import_file == 1 && row_company_id.length)
					newCell.innerHTML = '<input type="hidden" name="row_company_id' + row_count +'" id="row_company_id' + row_count +'" value="' + row_company_id +'"><input type="text" name="row_comp_name' + row_count +'" id="row_comp_name' + row_count +'" value="' + row_comp_name +'" style="width:118px;" class="boxtext"  onFocus="autocomp('+row_count+');"><a href="javascript://"><img src="/images/plus_thin.gif" onclick="pencere_ac_company('+ row_count +');" align="absmiddle" border="0"></a>';
				else
					newCell.innerHTML = '<input type="hidden" name="row_company_id' + row_count +'" id="row_company_id' + row_count +'"><input type="text" name="row_comp_name' + row_count +'" id="row_comp_name' + row_count +'" style="width:118px;" class="boxtext"  onFocus="autocomp('+row_count+');"><a href="javascript://"><img src="/images/plus_thin.gif" onclick="pencere_ac_company('+ row_count +');" align="absmiddle" border="0"></a>';
					
				newCell = newRow.insertCell(newRow.cells.length);//Marka
				newCell.setAttribute('nowrap','nowrap');
				newCell.setAttribute("name","marka_" + row_count);
				newCell.setAttribute("id","marka_" + row_count);		
				newCell.setAttribute("NAME","marka_" + row_count);
				newCell.setAttribute("ID","marka_" + row_count);
				if(ekle_marka==0)
					newCell.style.display = 'none';
				if(import_file == 1 && row_brand_id.length)
					newCell.innerHTML = '<input type="hidden" name="row_brand_id' + row_count +'" id="row_brand_id' + row_count +'" value="'+row_brand_id+'"><input type="text" name="row_brand_name' + row_count +'" id="row_brand_name' + row_count +'" value="'+row_brand_name+'" style="width:118px;"  onFocus="AutoComplete_Create(\'row_brand_name' + row_count +'\',\'BRAND_NAME\',\'BRAND_NAME\',\'get_brand\',\'\',\'BRAND_ID\',\'row_brand_id' + row_count +'\',\'sales_quota\',3,120);" class="boxtext"><a href="javascript://"><img src="/images/plus_thin.gif" onclick="pencere_ac_brand('+ row_count +');" align="absmiddle" border="0"></a>';
				else
					newCell.innerHTML = '<input type="hidden" name="row_brand_id' + row_count +'" id="row_brand_id' + row_count +'"><input type="text" name="row_brand_name' + row_count +'" id="row_brand_name' + row_count +'" style="width:118px;"  onFocus="AutoComplete_Create(\'row_brand_name' + row_count +'\',\'BRAND_NAME\',\'BRAND_NAME\',\'get_brand\',\'\',\'BRAND_ID\',\'row_brand_id' + row_count +'\',\'sales_quota\',3,120);" class="boxtext"><a href="javascript://"><img src="/images/plus_thin.gif" onclick="pencere_ac_brand('+ row_count +');" align="absmiddle" border="0"></a>';
					
				newCell = newRow.insertCell(newRow.cells.length);//kategori
				newCell.setAttribute('nowrap','nowrap');
				newCell.setAttribute("name","kategori_" + row_count);
				newCell.setAttribute("id","kategori_" + row_count);		
				newCell.setAttribute("NAME","kategori_" + row_count);
				newCell.setAttribute("ID","kategori_" + row_count);
				if(ekle_kategori==0)
					newCell.style.display = 'none';
				if(import_file == 1 && row_category.length)
					newCell.innerHTML ='<input type="hidden" name="row_category'+ row_count +'" id="row_category'+ row_count +'" value="'+row_category+'"><input type="text" style="width:<cfif x_row_multi_category_selected eq 1>238<cfelse>108</cfif>px;" class="boxtext" name="row_category_name'+ row_count +'" id="row_category_name'+ row_count +'" value="'+row_category_name+'"> <a href="javascript://"><img src="/images/plus_thin.gif" onclick="pencere_ac_category('+ row_count +');"  border="0" alt="Ürün Kategorisi Ekle!" align="absmiddle"></a>';
				else
					newCell.innerHTML ='<input type="hidden" name="row_category'+ row_count +'" id="row_category'+ row_count +'"><input type="text" style="width:<cfif x_row_multi_category_selected eq 1>238<cfelse>108</cfif>px;" class="boxtext" name="row_category_name'+ row_count +'" id="row_category_name'+ row_count +'"> <a href="javascript://"><img src="/images/plus_thin.gif" onclick="pencere_ac_category('+ row_count +');"  border="0" alt="Ürün Kategorisi Ekle!" align="absmiddle"></a>';
					
				<cfif x_products_not_included eq 1>
					newCell = newRow.insertCell(newRow.cells.length);//Urun2(Prime Dahil Edilmeyecek Urunler)
					newCell.setAttribute("name","urun2_" + row_count);
					newCell.setAttribute("id","urun2_" + row_count);		
					newCell.setAttribute("NAME","urun2_" + row_count);
					newCell.setAttribute("ID","urun2_" + row_count);
					if(ekle_urun2_==0)
						newCell.style.display = 'none';
					newCell.setAttribute('nowrap','nowrap');
					newCell.innerHTML = '<input  type="hidden" name="product_id2' + row_count +'" ><input  type="hidden" name="stock_id2' + row_count +'" ><input type="text" name="product_name2' + row_count +'" id="product_name2' + row_count +'" class="boxtext" style="width:241px;" onFocus="AutoComplete_Create(\'product_name2' + row_count +'\',\'PRODUCT_NAME\',\'PRODUCT_NAME\',\'get_product_autocomplete\',\'0\',\'PRODUCT_ID,STOCK_ID\',\'product_id2' + row_count +',stock_id2' + row_count +'\',\'sales_quota\',3,128);"><a href="javascript://" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_product_names</cfoutput>&product_id=sales_quota.product_id2" + row_count + "&field_id=sales_quota.stock_id2" + row_count + "&field_name=sales_quota.product_name2" + row_count + "&is_multi_selection=1','list');"+'"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>';
				</cfif>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute("name","urun_" + row_count);
				newCell.setAttribute("id","urun_" + row_count);		
				newCell.setAttribute("NAME","urun_" + row_count);
				newCell.setAttribute("ID","urun_" + row_count);
				if(ekle_urun==0)
					newCell.style.display = 'none';
				newCell.setAttribute('nowrap','nowrap');
				if(import_file == 1 && product_id.length)
					newCell.innerHTML = '<input type="hidden" name="product_id' + row_count +'" id="product_id' + row_count +'" value="'+product_id+'"><input  type="hidden" name="stock_id' + row_count +'" id="stock_id' + row_count +'" value="'+stock_id+'"><input type="text" name="product_name' + row_count +'" id="product_name' + row_count +'" value="'+product_name+'" class="boxtext" style="width:135px;" onFocus="AutoComplete_Create(\'product_name' + row_count +'\',\'PRODUCT_NAME\',\'PRODUCT_NAME\',\'get_product_autocomplete\',\'0\',\'PRODUCT_ID,STOCK_ID\',\'product_id' + row_count +',stock_id' + row_count +'\',\'sales_quota\',3,128);"><a href="javascript://" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_product_names</cfoutput>&product_id=sales_quota.product_id" + row_count + "&field_id=sales_quota.stock_id" + row_count + "&field_name=sales_quota.product_name" + row_count + "','list');"+'"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>';
				else
					newCell.innerHTML = '<input type="hidden" name="product_id' + row_count +'" id="product_id' + row_count +'"><input  type="hidden" name="stock_id' + row_count +'" id="stock_id' + row_count +'"><input type="text" name="product_name' + row_count +'" id="product_name' + row_count +'" class="boxtext" style="width:135px;" onFocus="AutoComplete_Create(\'product_name' + row_count +'\',\'PRODUCT_NAME\',\'PRODUCT_NAME\',\'get_product_autocomplete\',\'0\',\'PRODUCT_ID,STOCK_ID\',\'product_id' + row_count +',stock_id' + row_count +'\',\'sales_quota\',3,128);"><a href="javascript://" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_product_names</cfoutput>&product_id=sales_quota.product_id" + row_count + "&field_id=sales_quota.stock_id" + row_count + "&field_name=sales_quota.product_name" + row_count + "','list');"+'"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>';
		
				<cfif x_period_type eq 1>
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<select name="period_type'+ row_count +'" id="period_type'+ row_count +'" style="width:150px;" class="box"><option value="0">1.Dönem(01.01-31.03)</option><option value="1">2.Dönem(01.04-30.06)</option><option value="2">3.Dönem(01.07-30.09)</option><option value="3">4.Dönem(01.10-31.12)</option></select>';
				<cfelse>
					newCell = newRow.insertCell(newRow.cells.length);
					
				if(import_file == 1 && period_type.length)
				{
					switch(period_type)
					{
						case '1' : text_ = '<option value="0"><cf_get_lang_main no="1312.Ay"></option><option value="1" selected>3 <cf_get_lang_main no="1312.Ay"></option><option value="2"><cf_get_lang_main no="1043.Yıl"></option>'; break;
						case '2' : text_ = '<option value="0"><cf_get_lang_main no="1312.Ay"></option><option value="1">3 <cf_get_lang_main no="1312.Ay"></option><option value="2" selected><cf_get_lang_main no="1043.Yıl"></option>'; break;
						default : text_ = '<option value="0" selected><cf_get_lang_main no="1312.Ay"></option><option value="1">3 <cf_get_lang_main no="1312.Ay"></option><option value="2"><cf_get_lang_main no="1043.Yıl"></option>'; break;
					}
					newCell.innerHTML = '<select name="period_type'+ row_count +'" id="period_type'+ row_count +'" style="width:70px;" class="box">'+text_+'</select>';
				}
				else
					newCell.innerHTML = '<select name="period_type'+ row_count +'" id="period_type'+ row_count +'" style="width:70px;" class="box"><option value="0"><cf_get_lang_main no="1312.Ay"></option><option value="1">3 <cf_get_lang_main no="1312.Ay"></option><option value="2"><cf_get_lang_main no="1043.Yıl"></option></select>';
				</cfif>
				
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute('nowrap','nowrap');
				if(import_file == 1 && quantity.length)
					newCell.innerHTML = '<input type="text" name="quantity' + row_count +'" id="quantity' + row_count +'" value="'+quantity+'" onkeyup="return(FormatCurrency(this,event,0));" style="width:100%;" class="box" onBlur="if(filterNum(this.value) <=1) this.value=1;hesapla('+row_count+');">';
				else
					newCell.innerHTML = '<input type="text" name="quantity' + row_count +'" id="quantity' + row_count +'" value="1" onkeyup="return(FormatCurrency(this,event,0));" style="width:100%;" class="box" onBlur="if(filterNum(this.value) <=1) this.value=1;hesapla('+row_count+');">';
		
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute('nowrap','nowrap');
				if(import_file == 1 && row_total.length)
					newCell.innerHTML = '<input type="text" name="row_total' + row_count +'" id="row_total' + row_count +'" value="'+row_total+'" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+');">';
				else
					newCell.innerHTML = '<input type="text" name="row_total' + row_count +'" id="row_total' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+');">';
		
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute('nowrap','nowrap');
				if(import_file == 1 && row_total_max.length)
					newCell.innerHTML = '<input type="text" name="row_total_max' + row_count +'" id="row_total_max' + row_count +'" value="'+row_total_max+'" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+');">';
				else
					newCell.innerHTML = '<input type="text" name="row_total_max' + row_count +'" id="row_total_max' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+');">';
				
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute('nowrap','nowrap');
				if(import_file == 1 && row_other_total.length)
					newCell.innerHTML = '<input type="text" name="row_other_total' + row_count +'" id="row_other_total' + row_count +'" value="'+row_other_total+'" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);Dhesapla('+row_count+');">';
				else
					newCell.innerHTML = '<input type="text" name="row_other_total' + row_count +'" id="row_other_total' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);Dhesapla('+row_count+');">';
					
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute('nowrap','nowrap');
				if(import_file == 1 && row_other_total_max.length)
					newCell.innerHTML = '<input type="text" name="row_other_total_max' + row_count +'" id="row_other_total_max' + row_count +'" value="'+row_other_total_max+'"  onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);Dhesapla('+row_count+');">';
				else
					newCell.innerHTML = '<input type="text" name="row_other_total_max' + row_count +'" id="row_other_total_max' + row_count +'" value="0"  onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);Dhesapla('+row_count+');">';
				
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute('nowrap','nowrap');
				if(import_file == 1 && premium_per_.length)
					newCell.innerHTML = '<input type="text" name="premium_per_' + row_count +'" id="premium_per_' + row_count +'" value="'+premium_per_+'" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+');">';
				else
					newCell.innerHTML = '<input type="text" name="premium_per_' + row_count +'" id="premium_per_' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+');">';
				
				newCell = newRow.insertCell(newRow.cells.length);
				if(import_file == 1 && premium_per2_.length)
					newCell.innerHTML = '<input type="text" name="premium_per2_' + row_count +'" id="premium_per2_' + row_count +'" value="'+premium_per2_+'" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+');">';
				else
					newCell.innerHTML = '<input type="text" name="premium_per2_' + row_count +'" id="premium_per2_' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+');">';
				
				newCell = newRow.insertCell(newRow.cells.length);
				if(import_file == 1 && premium_per3_.length)
					newCell.innerHTML = '<input type="text" name="premium_per3_' + row_count +'" id="premium_per3_' + row_count +'" value="'+premium_per3_+'" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+');">';
				else
					newCell.innerHTML = '<input type="text" name="premium_per3_' + row_count +'" id="premium_per3_' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+');">';
		
				newCell = newRow.insertCell(newRow.cells.length);
				if(import_file == 1 && row_premium_total.length)
					newCell.innerHTML = '<input type="text" name="row_premium_total' + row_count +'" id="row_premium_total' + row_count +'" value="'+row_premium_total+'" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+',1);">';
				else
					newCell.innerHTML = '<input type="text" name="row_premium_total' + row_count +'" id="row_premium_total' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+',1);">';
		
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute("id","mal_fazlasi" + row_count);
				if(ekle_urun==0)
					newCell.style.display = 'none';
				if(import_file == 1 && extra_stock.length)
					newCell.innerHTML = '<input type="text" name="extra_stock' + row_count +'" id="extra_stock' + row_count +'" value="'+extra_stock+'" onkeyup="return(FormatCurrency(this,event,0));" style="width:100%;" class="box" onBlur="if(filterNum(this.value) <0) this.value=0;hesapla('+row_count+');">';
				else
					newCell.innerHTML = '<input type="text" name="extra_stock' + row_count +'" id="extra_stock' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event,0));" style="width:100%;" class="box" onBlur="if(filterNum(this.value) <0) this.value=0;hesapla('+row_count+');">';
		
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute('nowrap','nowrap');
				if(import_file == 1 && profit_per.length)
					newCell.innerHTML = '<input type="text" name="profit_per' + row_count +'" id="profit_per' + row_count +'" value="'+profit_per+'" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+');">';
				else
					newCell.innerHTML = '<input type="text" name="profit_per' + row_count +'" id="profit_per' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+');">';
				
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute('nowrap','nowrap');
				if(import_file == 1 && row_profit_total.length)
					newCell.innerHTML = '<input type="text" name="row_profit_total' + row_count +'" id="row_profit_total' + row_count +'" value="'+row_profit_total+'" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+',1);">';
				else
					newCell.innerHTML = '<input type="text" name="row_profit_total' + row_count +'" id="row_profit_total' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+',1);">';
				
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute('nowrap','nowrap');
				if(import_file == 1 && row_detail.length)
					newCell.innerHTML = '<input type="text" name="row_detail' + row_count +'" id="row_detail' + row_count +'" value="'+row_detail+'" style="width:100%;" class="boxtext" maxlength="300">';
				else
					newCell.innerHTML = '<input type="text" name="row_detail' + row_count +'" id="row_detail' + row_count +'" style="width:100%;" class="boxtext" maxlength="300">';
				
				if(import_file == 1)
					hesapla(row_count);
				
			}	
			function open_file()
			{
				document.getElementById('satis_kota_planlama_file').style.display='';
				AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects.popup_add_sales_quota_from_file&type=2<cfif isdefined("attributes.multi_id")>&multi_id=#attributes.multi_id#</cfif></cfoutput>','satis_kota_planlama_file',1);
				return false;
			}
			</cfif>
	</cfif>
</script>



<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	if(not isdefined("attributes.event"))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'salesplan.list_sales_quotas';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'salesplan/display/list_sales_quotas.cfm';
	
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'salesplan.add_sales_quota';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'salesplan/form/add_sales_quota.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'salesplan/query/add_sales_quota.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'salesplan.list_sales_quotas&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'salesplan.upd_sales_quota';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'salesplan/form/upd_sales_quota.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'salesplan/query/upd_sales_quota.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'salesplan.list_sales_quotas&event=upd&q_id=';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'q_id=##attributes.q_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.q_id##';
	
	if(IsDefined("attributes.event") && (attributes.event is 'upd' || attributes.event is 'del'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'salesplan.emptypopup_del_sales_quota&quota_id=#attributes.q_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'salesplan/query/del_sales_quota.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'salesplan/query/del_sales_quota.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'salesplan.list_sales_quotas';
	}
	
	if(isdefined("attributes.event") and attributes.event is 'add')
	{
		multi_id = '';
		if(isdefined("attributes.multi_id"))
			multi_id = attributes.multi_id;
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['text'] = '#lang_array_main.item[2576]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['onClick'] = "openBox('#request.self#?fuseaction=objects.popup_add_sales_quota_from_file&type=2&multi_id=#multi_id#',this)";
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	sub_category = 0;
	if(isdefined("x_product_cat_sub_category") and x_product_cat_sub_category eq 1)
		sub_category = 1;
		
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array.item[155]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=salesplan.popup_targets_quota&q_id=#attributes.q_id#&purchase_sales=#GET_SALES_QUOTAS.IS_SALES_PURCHASE#&x_period_type=#x_period_type#&sub_category=#sub_category#','horizantal')";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[345]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=salesplan.upd_sales_quota&action_name=q_id&action_id=#attributes.q_id#','list')";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=salesplan.list_sales_quotas&event=add";		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array_main.item[64]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=salesplan.list_sales_quotas&event=add&q_id=#attributes.q_id#";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.q_id#&print_type=340','page')";
		
		
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'salesplanListSalesQuotas';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'SALES_QUOTAS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-process_stage','item-paper_no','item-start_date','item-finish_date','item-quota_type']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.
</cfscript>
