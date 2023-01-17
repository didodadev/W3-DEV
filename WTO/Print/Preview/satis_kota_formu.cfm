<cfquery name="get_quotas" datasource="#dsn3#">
	SELECT * FROM SALES_QUOTAS WHERE SALES_QUOTA_ID = #attributes.action_id#
</cfquery>
<cfquery name="get_row" datasource="#dsn3#">
	SELECT * FROM SALES_QUOTAS_ROW WHERE SALES_QUOTA_ID = #attributes.action_id#
</cfquery>
<cfif len(get_quotas.sales_zone_id)>
	<cfquery name="get_zones" datasource="#dsn#">
		SELECT SZ_NAME FROM SALES_ZONES WHERE SZ_ID = #get_quotas.sales_zone_id#
	</cfquery>
</cfif>
<cfif len(get_quotas.ims_code_id)>
	<cfquery name="get_ims_code" datasource="#dsn#">
		SELECT IMS_CODE,IMS_CODE_NAME FROM SETUP_IMS_CODE WHERE IMS_CODE_ID = #get_quotas.ims_code_id#
	</cfquery>
</cfif>
<cfquery name="CHECK" datasource="#DSN#">
	SELECT 
		ASSET_FILE_NAME2,
		ASSET_FILE_NAME2_SERVER_ID,
	    COMPANY_NAME
	FROM 
		OUR_COMPANY 
	WHERE 
		<cfif isdefined("attributes.our_company_id")>
			COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
		<cfelse>
			<cfif isDefined("session.ep.company_id") and len(session.ep.company_id)>
				COMP_ID = #session.ep.company_id#
			<cfelseif isDefined("session.pp.company_id") and len(session.pp.company_id)>	
				COMP_ID = #session.pp.company_id#
			<cfelseif isDefined("session.ww.our_company_id")>
				COMP_ID = #session.ww.our_company_id#
			<cfelseif isDefined("session.cp.our_company_id")>
				COMP_ID = #session.cp.our_company_id#
			</cfif> 
		</cfif> 
</cfquery>
<cfif get_row.recordcount>
    <cfset 
    
    company_list=''>
    <cfset brand_list=''>
    <cfset cat_list=''>
    <cfset product_list=''>
    <cfoutput query="get_row">
        <cfif len(supplier_id) and not listfind(company_list,supplier_id)>
            <cfset company_list=listappend(company_list,supplier_id)>
        </cfif>
        <cfif len(brand_id) and not listfind(brand_list,brand_id)>
            <cfset brand_list=listappend(brand_list,brand_id)>
        </cfif>
        <cfif len(category_id) and not listfind(cat_list,category_id)>
            <cfset cat_list=listappend(cat_list,category_id)>
        </cfif>
        <cfif len(product_id) and not listfind(product_list,product_id)>
            <cfset product_list=listappend(product_list,product_id)>
        </cfif>
    </cfoutput>
    <cfif len(company_list)>
        <cfset company_list = listsort(company_list,"numeric","ASC",",")>
        <cfquery name="GET_COM" datasource="#DSN#">
            SELECT FULLNAME,COMPANY_ID FROM COMPANY WHERE COMPANY_ID IN(#company_list#) ORDER BY COMPANY_ID
        </cfquery>
    </cfif>
    <cfif len(brand_list)>
        <cfset brand_list = listsort(brand_list,"numeric","ASC",",")>
        <cfquery name="GET_BRAND" datasource="#DSN1#">
            SELECT BRAND_ID,BRAND_NAME FROM PRODUCT_BRANDS WHERE BRAND_ID IN(#brand_list#) ORDER BY BRAND_ID
        </cfquery>
    </cfif>
    <cfif len(cat_list)>
        <cfset cat_list = listsort(cat_list,"numeric","ASC",",")>
        <cfquery name="GET_PRODUCT_CAT" datasource="#DSN3#">
            SELECT PRODUCT_CATID,PRODUCT_CAT FROM PRODUCT_CAT WHERE PRODUCT_CATID IN(#cat_list#) ORDER BY PRODUCT_CATID
        </cfquery>
    </cfif>
    <cfif len(product_list)>
        <cfset product_list = listsort(product_list,"numeric","ASC",",")>
        <cfquery name="GET_PRODUCT" datasource="#DSN1#">
            SELECT PRODUCT_ID,PRODUCT_NAME FROM PRODUCT WHERE PRODUCT_ID IN(#product_list#) ORDER BY PRODUCT_ID
        </cfquery>
    </cfif>
</cfif>
    <cfoutput query="get_row">
        <cfif isdefined("get_row.sales_zone_id") and len(get_row.sales_zone_id)>
            <cfset fullname_="#get_com.FULLNAME[listfind(company_list,get_row.supplier_id,',')]#">
        <cfelse>
            <cfset fullname_="">
        </cfif>
        <cfif isdefined("get_brand.BRAND_NAME") and len(get_brand.BRAND_NAME)>
            <cfset brandName_="#get_brand.BRAND_NAME[listfind(brand_list,get_row.brand_id,',')]#">
        <cfelse>
            <cfset brandName_="">
        </cfif>
        <cfset miktar_toplam=0>
                        <cfset tutar_toplam=0>
                        <cfset prim_toplam=0>
                        <cfset mal_toplam=0>
                        <cfset kar_toplam=0>
        <cfset miktar_toplam=miktar_toplam+quantity>
        <cfset tutar_toplam=tutar_toplam+row_total>
        <cfset prim_toplam=prim_toplam+row_premium_total>
        <cfset mal_toplam=mal_toplam+row_extra_stock>
        <cfset kar_toplam=kar_toplam+row_profit_total>
    </cfoutput>
<link rel="stylesheet" href="/css/assets/template/catalyst/print.css" type="text/css">
    <cf_woc_header>
        <cfoutput query="get_quotas">
            <cf_woc_elements>
                <cf_wuxi id="q-id" data="#get_emp_info(get_quotas.planner_emp_id,0,0)#"  label="31910" type="cell">
                <cf_wuxi id="q-id" data="#get_par_info(company_id,1,1,0)#"  label="57519" type="cell"> 
                <cf_wuxi id="q-id" data="#iif(len(sales_zone_id),'get_zones.sz_name',DE(''))#"  label="57519" type="cell"> 
                <cf_wuxi id="q-id" data="#paper_no#" label="57880" type="cell">
                <cf_wuxi id="q-id" data="#iif(len(partner_id ),'get_par_info(partner_id,0,-1,0)',DE(''))#"  label="57578" type="cell">
                <cf_wuxi id="q-id" data="#iif(len(ims_code_id),'get_ims_code.ims_code', DE(''))# #iif(len(ims_code_id),'get_ims_code.ims_code_name', DE(''))#"  label="58134" type="cell">  <!--- control --->
                <cf_wuxi id="q-id" data="#iif(len(plan_date ),'dateFormat(plan_date,dateformat_style)',DE(''))#"  label="57627" type="cell"> <!--- control --->
                <cf_wuxi id="q-id" data="#iif(len(detail ),'detail',DE(''))#"  label="57578" type="cell">
            <cf_woc_elements>   
        </cfoutput>
                
        <cfif get_row.recordcount>
            <cf_woc_list id="aaa">
                <thead>
                    <tr>
                        <cf_wuxi label="29533" type="cell" is_row="0" id="wuxi_29533"> 
                        <cf_wuxi label="58847" type="cell" is_row="0" id="wuxi_58847"> 
                        <cf_wuxi label="57486" type="cell" is_row="0" id="wuxi_57486"> 
                        <cf_wuxi label="57657" type="cell" is_row="0" id="wuxi_57657"> 
                        <cf_wuxi label="57635" type="cell" is_row="0" id="wuxi_57635"> 
                        <cf_wuxi label="57673" type="cell" is_row="0" id="wuxi_57673"> 
                        <cf_wuxi label="55776" type="cell" is_row="0" id="wuxi_55776"> 
                        <cf_wuxi label="48246" type="cell" is_row="0" id="wuxi_48246"> 
                        <cf_wuxi label="37660" type="cell" is_row="0" id="wuxi_37660"> 
                        <cf_wuxi label="39553" type="cell" is_row="0" id="wuxi_39553"> 
                        <cf_wuxi label="60216" type="cell" is_row="0" id="wuxi_60216"> 
                        <cf_wuxi label="57629" type="cell" is_row="0" id="wuxi_57629"> 
                    </tr>
                </thead>
                <tbody> 
                    <cfoutput query="get_row">
                    <tr>
                        <cf_wuxi data="#iif(len(supplier_id),'get_com.FULLNAME[listfind(company_list,supplier_id,",")]',DE('-'))#" type="cell" is_row="0"> 
                        <cf_wuxi data="#get_brand.BRAND_NAME[listfind(brand_list,brand_id,',')]#" type="cell" is_row="0"> 
                        <cf_wuxi data="#iif(len(category_id), 'get_product_cat.PRODUCT_CAT[listfind(cat_list,category_id,",")]',DE('-'))#" type="cell" is_row="0"> 
                        <cf_wuxi data="#iif(len(product_id),'get_product.PRODUCT_NAME[listfind(product_list,product_id,",")]',DE('-'))#" type="cell" is_row="0">  
                        <cf_wuxi data="#quantity#" type="cell" is_row="0">  
                        <cf_wuxi data="#TLFormat(ROW_TOTAL)#&nbsp;#session.ep.money#" type="cell" is_row="0">  
                        <cf_wuxi data="#TLFormat(ROW_PREMIUM_PERCENT)#&nbsp;" type="cell" is_row="0">  
                        <cf_wuxi data="#TLFormat(ROW_PREMIUM_TOTAL)#&nbsp;#session.ep.money#" type="cell" is_row="0">  
                        <cf_wuxi data="#ROW_EXTRA_STOCK#" type="cell" is_row="0">  
                        <cf_wuxi data="#TLFormat(ROW_PROFIT_PERCENT)#&nbsp;" type="cell" is_row="0">  
                        <cf_wuxi data="#TLFormat(ROW_PROFIT_TOTAL)#&nbsp;#session.ep.money#" type="cell" is_row="0">  
                        <cf_wuxi data="#row_detail#&nbsp;" type="cell" is_row="0">  

                        <cfset miktar_toplam=miktar_toplam+quantity>
                        <cfset tutar_toplam=tutar_toplam+row_total>
                        <cfset prim_toplam=prim_toplam+row_premium_total>
                        <cfset mal_toplam=mal_toplam+row_extra_stock>
                        <cfset kar_toplam=kar_toplam+row_profit_total>
                    </tr>
                    <tr>  
                        <td colspan="4" style="text-align:right;"><b><cf_get_lang_main no="80.Toplam"></b></td>
                        <cf_wuxi data="#miktar_toplam#" type="cell" is_row="0">
                        <cf_wuxi data="#TLFormat(tutar_toplam)#&nbsp;#session.ep.money#" type="cell" is_row="0">
                        <cf_wuxi data="#TLFormat(prim_toplam)#&nbsp;#session.ep.money#" type="cell" is_row="0">
                        <cf_wuxi data="&nbsp;" type="cell" is_row="0">
                        <cf_wuxi data="#TLFormat(prim_toplam)#&nbsp;#session.ep.money#" type="cell" is_row="0">
                        <cf_wuxi data="#mal_toplam#" type="cell" is_row="0">
                        <cf_wuxi data="&nbsp;" type="cell" is_row="0">
                        <cf_wuxi data="#TLFormat(kar_toplam)#&nbsp;#session.ep.money#" type="cell" is_row="0">
                    </tr>
                </cfoutput>
                </tbody>
            </cf_woc_list> 
        </cfif>
    <cf_woc_footer>