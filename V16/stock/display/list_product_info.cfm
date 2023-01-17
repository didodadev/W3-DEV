<div class="form-group" id="item-product_status">
    <label class="col col-4  col-xs-12 bold"><cf_get_lang dictionary_id='57756.durum'></label>
    <label class="col col-8 col-xs-12">
        <cfif get_product.product_status eq 1>
            <cf_get_lang dictionary_id='57493.Aktif'>
        <cfelseif get_product.product_status eq 0>
            <cf_get_lang dictionary_id='57494.Pasif'>
        </cfif>
    </label>
</div>
<div class="form-group" id="item-MAIN_UNIT">
    <label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='57636.birim'></label>
    <label class="col col-8 col-xs-12">
        <cfoutput>#get_product.MAIN_UNIT#</cfoutput>
    </label>
</div>
<div class="form-group" id="item-PRODUCT_CODE">
    <label class="col col-4  col-xs-12 bold"><cf_get_lang dictionary_id='57518.stok kodu'></label>
    <label class="col col-8 col-xs-12">
        <cfoutput>#get_product.PRODUCT_CODE#</cfoutput>
    </label>
</div>
<div class="form-group" id="item-PRODUCT_CODE_2">
    <label class="col col-4  col-xs-12 bold"><cf_get_lang dictionary_id='57789.özel kodu'></label>
    <label class="col col-8 col-xs-12">
        <cfoutput>#get_product.PRODUCT_CODE_2#</cfoutput>
    </label>
</div>
<div class="form-group" id="item-BARCOD">
    <label class="col col-4  col-xs-12 bold"><cf_get_lang dictionary_id='57633.barkod'></label>
    <label class="col col-8 col-xs-12">
        <cfoutput>#get_product.BARCOD#</cfoutput>
    </label>
</div>
<div class="form-group" id="item-PRODUCT_CAT">
    <label class="col col-4  col-xs-12 bold"><cf_get_lang dictionary_id='57486.kategori'></label>
    <label class="col col-8 col-xs-12">
        <cfoutput>#get_product.PRODUCT_CAT#</cfoutput>
    </label>
</div>
<div class="form-group" id="item-SHELF_LIFE">
    <label class="col col-4  col-xs-12 bold"><cf_get_lang dictionary_id='45237.raf ömrü'></label>
    <label class="col col-8 col-xs-12">
        <cfoutput>#get_product.SHELF_LIFE#</cfoutput> <cf_get_lang dictionary_id='57490.Gün'>
    </label>
</div>
<div class="form-group" id="item-COMPANY_ID">
    <label class="col col-4  col-xs-12 bold"><cf_get_lang dictionary_id='29533.tedarikçi'></label>
    <label class="col col-8 col-xs-12">
        <cfif len(get_product.COMPANY_ID)>
            <cfoutput>#get_par_info(GET_PRODUCT.COMPANY_ID,1,0,0)#</cfoutput>
        </cfif>
    </label>
</div>
<div class="form-group" id="item-PRODUCT_MANAGER">
    <label class="col col-4  col-xs-12 bold"><cf_get_lang dictionary_id='57544.Sorumlu'></label>
    <label class="col col-8 col-xs-12">
        <cfif len(GET_PRODUCT.PRODUCT_MANAGER)>
            <cfset attributes.pos_code= GET_PRODUCT.PRODUCT_MANAGER>
            <cfoutput>#get_emp_info(GET_PRODUCT.PRODUCT_MANAGER,1,0)#</cfoutput>
        </cfif>
    </label>
</div>
<cfquery name="GET_COST_INFO" datasource="#dsn3#">
    SELECT 
        PHYSICAL_DATE,
        DUE_DATE
    FROM 
        PRODUCT_COST 
    WHERE
        PRODUCT_ID = #attributes.pid#
    ORDER BY
        START_DATE DESC,
        RECORD_DATE DESC,
        PRODUCT_COST_ID DESC
</cfquery>
<div class="form-group" id="item-PHYSICAL_DATE">
    <label class="col col-4  col-xs-12 bold"><cf_get_lang dictionary_id='45568.Fiziksel Yaş'></label>
    <label class="col col-8 col-xs-12">
        <cfif len(GET_COST_INFO.PHYSICAL_DATE)><cfoutput>#dateformat(GET_COST_INFO.PHYSICAL_DATE,dateformat_style)#</cfoutput></cfif>
    </label>
</div>
<div class="form-group" id="item-DUE_DATE">
    <label class="col col-4  col-xs-12 bold"><cf_get_lang dictionary_id='36091.Finansal Yaş'></label>
    <label class="col col-8 col-xs-12">
        <cfif len(GET_COST_INFO.DUE_DATE)><cfoutput>#dateformat(GET_COST_INFO.DUE_DATE,dateformat_style)#</cfoutput></cfif>
    </label>
</div>
<!---Urun Ek Birimleri--->
<div class="form-group" id="item-get_product_unit">
    <label class="col col-4  col-xs-12 bold"><cf_get_lang dictionary_id='45245.Ek Birimler'></label>
    <label class="col col-8 col-xs-12">
        <cfquery name="get_product_unit" datasource="#DSN3#">
            SELECT ADD_UNIT,MULTIPLIER,MAIN_UNIT,IS_MAIN FROM PRODUCT_UNIT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> AND PRODUCT_UNIT_STATUS = 1
        </cfquery>
        <cfoutput query="get_product_unit">
            <cfif is_main is 1>
                #add_unit# = #MULTIPLIER# x #main_unit#<br />
            <cfelse>
                #add_unit# = #MULTIPLIER# x #main_unit#<br />
            </cfif>
        </cfoutput>
    </label>
</div>




