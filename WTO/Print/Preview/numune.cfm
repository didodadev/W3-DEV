<cfset comp = createObject('component','V16.product.cfc.product_sample')>
<cfset get_prod_sample = comp.GET_PRODUCT_SAMPLE(PRODUCT_SAMPLE_ID: attributes.product_sample_id)>
<cfset get_product_cat = comp.GET_PRODUCT_CAT(product_catid : get_prod_sample.product_cat_id )/>
<cfset GET_OPPORTUNITY_SAMPLE = comp.GET_OPPORTUNITY_SAMPLE(product_sample_id : attributes.product_sample_id)/>

<cfif GET_OPPORTUNITY_SAMPLE.recordcount>
    <cfif isdefined("GET_OPPORTUNITY_SAMPLE.company_id") and len(GET_OPPORTUNITY_SAMPLE.company_id)>
        <cfset company_name = get_par_info(GET_OPPORTUNITY_SAMPLE.company_id,1,1,0)>
        <cfset customer_emp = get_par_info(GET_OPPORTUNITY_SAMPLE.partner_id,0,-1,0)>
    <cfelseif  isdefined("GET_OPPORTUNITY_SAMPLE.CONSUMER_ID") and len(GET_OPPORTUNITY_SAMPLE.CONSUMER_ID)>
        <cfset company_name = get_cons_info(GET_OPPORTUNITY_SAMPLE.consumer_id,0,0)>
        <cfset customer_emp = get_cons_info(GET_OPPORTUNITY_SAMPLE.consumer_id,0,0,0)>
    <cfelse>
        <cfset company_name = ''>
        <cfset customer_emp = ''>
    </cfif>
<cfelse>
    <cfset company_name = ''>
    <cfset customer_emp = ''>
</cfif>

<cfif len(get_prod_sample.brand_id)>
    <cfquery name="get_brand_name" datasource="#dsn3#">
        SELECT BRAND_NAME FROM PRODUCT_BRANDS WHERE BRAND_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#get_prod_sample.brand_id#">
    </cfquery>
<cfelse>
    <cfset get_brand_name.BRAND_NAME= ''>
</cfif>

<cfif len(get_prod_sample.product_sample_cat_id)>
    <cfquery name="get_sample_cat" datasource="#dsn3#">
        SELECT PRODUCT_SAMPLE_CAT FROM PRODUCT_SAMPLE_CAT WHERE PRODUCT_SAMPLE_CAT_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#get_prod_sample.product_sample_cat_id#">
    </cfquery>
<cfelse>
    <cfset get_sample_cat.PRODUCT_SAMPLE_CAT= ''>
</cfif>

<cfif len(get_prod_sample.process_stage_id)>
    <cfquery name="get_process" datasource="#dsn#">
        SELECT PTR.STAGE as STAGE_NAME FROM PROCESS_TYPE_ROWS AS PTR WHERE PTR.PROCESS_ROW_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#get_prod_sample.process_stage_id#">
    </cfquery>
<cfelse>
    <cfset get_process.STAGE_NAME= ''>
</cfif> 

<cfif len(get_prod_sample.reference_product_id)>
    <cfquery name="get_prod_name" datasource="#dsn3#">
        SELECT PRODUCT_NAME FROM PRODUCT WHERE PRODUCT_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#get_prod_sample.reference_product_id#">
    </cfquery>
<cfelse>
    <cfset get_prod_name.PRODUCT_NAME =''>
</cfif>

<cfif len(get_prod_sample.OPPORTUNITY_ID)>
    <cfquery name="GET_OPPORTUNITY" datasource="#DSN3#">
        SELECT 
        OP.opp_no
        FROM 
            OPPORTUNITIES AS OP
        LEFT JOIN PRODUCT_SAMPLE AS PS ON OP.OPP_ID= PS.OPPORTUNITY_ID
        WHERE 
            PS.OPPORTUNITY_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#get_prod_sample.OPPORTUNITY_ID#">
    </cfquery>
<cfelse>
    <cfset GET_OPPORTUNITY.opp_no= ''>
</cfif>

<cf_woc_header>
    <cf_woc_elements>
        <cf_wuxi id="smp_name" data="#get_prod_sample.product_sample_name#" label="62603+57897" type="cell">
        <cf_wuxi id="smp_cat" data="#get_sample_cat.PRODUCT_SAMPLE_CAT#" label="62603+57486" type="cell">
        <cf_wuxi id="brand" data="#get_brand_name.BRAND_NAME#" label="58847" type="cell">
        <cf_wuxi id="prd_cat" data="#get_product_cat.PRODUCT_CAT#" label="29401" type="cell">
        <cf_wuxi id="designer" data="#get_emp_info(get_prod_sample.designer_emp_id,0,0)#" label="61924" type="cell">
        <cf_wuxi id="process" data="#get_process.STAGE_NAME#" label="58859" type="cell">
        <cf_wuxi id="cust_no" data="#get_prod_sample.customer_model_no#" label="62569" type="cell">
        <cf_wuxi id="tar_pri" data="#get_prod_sample.target_price# #get_prod_sample.target_price_currency#" label="62606" type="cell">
        <cf_wuxi id="sal_pri" data="#get_prod_sample.sales_price# #get_prod_sample.sales_price_currency#" label="48183" type="cell">
        <cf_wuxi id="tar_amo" data="#get_prod_sample.target_amount#" label="62607" type="cell"> 
        <cf_wuxi id="tar_date" data="#get_prod_sample.target_delivery_date#" label="57951+57645" type="cell">
        <cf_wuxi id="ref_prd" data="#get_prod_name.PRODUCT_NAME#" label="58784+44019" type="cell">
        <cf_wuxi id="rel_opp" data="#GET_OPPORTUNITY.opp_no#" label="38161" type="cell">
        <cf_wuxi id="cust" data="#company_name#" label="57457" type="cell">
        <cf_wuxi id="cust_cont" data="#customer_emp#" label="57457+57578" type="cell">
        <cf_wuxi id="detail" data="#get_prod_sample.product_sample_detail#" label="33077" type="cell">
    </cf_woc_elements>
<cf_woc_footer>