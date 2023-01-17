<cfparam name="attributes.search_department_id" default="">

<cfif isdefined("attributes.start_date") and len(attributes.start_date) and isdate(attributes.start_date)>
	<cf_date tarih='attributes.start_date'>
<cfelse>
	<cfset attributes.start_date = createodbcdatetime('#year(now())#-#month(now())#-#day(now())#')>
</cfif>

<cfif isdefined("attributes.finish_date") and len(attributes.finish_date) and isdate(attributes.finish_date)>
	<cf_date tarih='attributes.finish_date'>
<cfelse>
	<cfset attributes.finish_date = createodbcdatetime('#year(now())#-#month(now())#-#day(now())#')>
</cfif>

<cfquery name="get_departments_search" datasource="#dsn#">
	SELECT 
    	DEPARTMENT_ID,DEPARTMENT_HEAD 
    FROM 
    	DEPARTMENT D
    WHERE
    	D.IS_STORE IN (1,3) AND
        ISNULL(D.IS_PRODUCTION,0) = 0
    ORDER BY 
    	DEPARTMENT_HEAD
</cfquery>

<cfsavecontent  variable="title"><cf_get_lang dictionary_id='61869.Depo Talep Raporu'></cfsavecontent>
<cf_report_list_search title="#title#" >
    <cf_report_list_search_area>
        <cfform action="#request.self#?fuseaction=retail.depo_order_report" method="post" name="search_depo">
            <input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
            <div class="row">
                <div class="col col-12 col-xs-12">
                    <div class="row formContent">
                        <div class="row" type="row">
                            <div class="col col-3 col-md-6 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                                    <div class="col col-12 col-xs-12">
                                        <select name="search_department_id" id="search_department_id">
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <cfoutput query="get_departments_search">
                                                <option value="#DEPARTMENT_ID#" <cfif attributes.search_department_id eq DEPARTMENT_ID>selected</cfif>>#DEPARTMENT_HEAD#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
                                    <div class="col col-4 col-sm-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
                                            <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" required="yes" style="width:65px;">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
                                    <div class="col col-4 col-sm-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'></cfsavecontent>
                                            <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" required="yes" style="width:65px;">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row ReportContentBorder">
                		<div class="ReportContentFooter">
                            <cf_wrk_search_button button_type="1" search_function="control_search_depo()">
                        </div>
                    </div>
                </div>
            </div>
        </cfform>
    </cf_report_list_search_area>
</cf_report_list_search>

	

<script>
function control_search_depo()
{
	if(document.getElementById('search_department_id').value == '')
	{
		alert('<cf_get_lang dictionary_id='53200.Departman Seçiniz'>!');
		return false;
	}
	return true;
}
</script>
<cfif isdefined("attributes.is_form_submitted")>

<cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
    SELECT 
        PRODUCT_CAT.PRODUCT_CATID, 
        PRODUCT_CAT.HIERARCHY, 
        PRODUCT_CAT.PRODUCT_CAT
    FROM 
        PRODUCT_CAT,
        PRODUCT_CAT_OUR_COMPANY PCO
    WHERE 
        PRODUCT_CAT.PRODUCT_CATID = PCO.PRODUCT_CATID AND
        PCO.OUR_COMPANY_ID = #session.ep.company_id# 
    ORDER BY 
        HIERARCHY ASC
</cfquery>
<cfset hierarchy_list = valuelist(GET_PRODUCT_CAT.HIERARCHY)>
<cfset hierarchy_name_list = valuelist(GET_PRODUCT_CAT.PRODUCT_CAT,'╗')>

<cfquery name="get_internaldemand" datasource="#DSN2#">
SELECT
	(SELECT ISNULL(SUM(STOCK_IN-STOCK_OUT),0) AS REAL_STOCK FROM STOCKS_ROW WHERE STOCKS_ROW.STOCK_ID = T1.STOCK_ID AND STOCKS_ROW.STORE = #merkez_depo_id#) AS DEPO_STOCK,
    (SELECT ISNULL(SUM(STOCK_IN-STOCK_OUT),0) AS REAL_STOCK FROM STOCKS_ROW WHERE STOCKS_ROW.STOCK_ID = T1.STOCK_ID AND STOCKS_ROW.STORE = #attributes.search_department_id#) AS MAGAZA_STOCK,
    PRODUCT_NAME,
    PROPERTY,
    STOCK_CODE,
    DEP,
    STOCK_ID,
    SUM(TALEP_EDILEN) AS TALEP_MIKTARI,
    SUM(KARSILANAN) AS KARSILANAN_MIKTAR,
    SUM(TALEP_EDILEN - KARSILANAN) AS SATIR_MIKTARI
FROM
	(
	SELECT
        (SELECT D.DEPARTMENT_HEAD FROM #dsn#.DEPARTMENT D WHERE D.DEPARTMENT_ID = SI.DEPARTMENT_IN) DEP,
        ISNULL(((SELECT SUM(SROW.AMOUNT) AS AMOUNT_TOTAL FROM SHIP_ROW SROW WHERE SROW.WRK_ROW_RELATION_ID = SIR.WRK_ROW_ID)),0) AS KARSILANAN,
        SIR.AMOUNT AS TALEP_EDILEN,
        S.STOCK_CODE,
        S.PRODUCT_NAME,
        S.PROPERTY,
        S.STOCK_ID
        
	FROM 
		SHIP_INTERNAL SI,
        SHIP_INTERNAL_ROW SIR,
        #dsn3_alias#.STOCKS S
	WHERE	
            SIR.STOCK_ID = S.STOCK_ID AND
        SI.DEPARTMENT_OUT = #merkez_depo_id# AND 
        SI.DEPARTMENT_IN = #attributes.search_department_id# AND 
        SI.SHIP_DATE >= #attributes.start_date# AND 
        SI.SHIP_DATE <= #attributes.finish_date# AND
        SIR.DISPATCH_SHIP_ID = SI.DISPATCH_SHIP_ID AND
                SIR.AMOUNT >= ISNULL((SELECT SUM(SROW.AMOUNT) AS AMOUNT_TOTAL FROM SHIP_ROW SROW WHERE SROW.WRK_ROW_RELATION_ID = SIR.WRK_ROW_ID),0)
    ) AS T1 
GROUP BY
	PRODUCT_NAME,
    PROPERTY,
    STOCK_CODE,
    STOCK_ID,
    DEP
ORDER BY
     STOCK_CODE ASC,
     PRODUCT_NAME ASC
</cfquery> 
<style> 
.big_list tr td {
	font-size:8px;
}
</style> 
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='61641.Ana Grup'></th>
                    <th><cf_get_lang dictionary_id='61642.Alt Grup'> 1</th>
                    <th><cf_get_lang dictionary_id='61642.Alt Grup'> 2</th>
                    <th><cf_get_lang dictionary_id='57657.Ürün'></th>
                <!--- <th style="text-align:right;">Talep Edilen</th>--->
                    <th style="text-align:right;"><cf_get_lang dictionary_id='61870.Depo Stok Raporu'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='62191.Şube Stok'></th>
                    <!---
                    <th style="text-align:right;">Karşılanan</th>--->
                    <th style="text-align:right;"><cf_get_lang dictionary_id='58444.Kalan'></th>
                    
                </tr>
            </thead>
            <tbody>
                <cfset last_birinci_ = "">
                <cfset last_ikinci_ = "">
                <cfset last_ucuncu_ = "">
                <cfoutput query="get_internaldemand">
                    <cfset birinci_ = listfirst(stock_code,'.')>
                    <cfset ikinci_ = birinci_ & '.' & listgetat(stock_code,2,'.')>
                    <cfset ucuncu_ = ikinci_ & '.' & listgetat(stock_code,3,'.')>
                    <tr>
                        <td>#currentrow#</td>
                        <td>
                            <cfif len(birinci_) and (not len(last_birinci_) or last_birinci_ is not birinci_) and listfind(hierarchy_list,birinci_)>
                                <cfset sira_ = listfind(hierarchy_list,birinci_)>
                                #listgetat(hierarchy_name_list,sira_,'╗')#
                            <cfelse>
                                #birinci_#
                            </cfif>
                        </td>
                        <td>
                            <cfif len(ikinci_) and (not len(last_ikinci_) or last_ikinci_ is not ikinci_) and listfind(hierarchy_list,ikinci_)>
                                <cfset sira_ = listfind(hierarchy_list,ikinci_)>
                                #listgetat(hierarchy_name_list,sira_,'╗')#
                            <cfelse>
                                #ikinci_#
                            </cfif>
                        </td>
                        <td>
                            <cftry>
                            <cfif len(ucuncu_) and (not len(last_ucuncu_) or last_ucuncu_ is not ucuncu_) and listfind(hierarchy_list,ucuncu_)>
                                <cfset sira_ = listfind(hierarchy_list,ucuncu_)>
                                #listgetat(hierarchy_name_list,sira_,'╗')#
                            <cfelse>
                                #ucuncu_#
                            </cfif>
                            <cfcatch type="any">
                            </cfcatch>
                            </cftry>
                        </td>
                        <td>#PROPERTY#</td>
                    <!--- <td style="text-align:right;">#TLFORMAT(TALEP_MIKTARI)#</td>--->
                        <td style="text-align:right;">#TLFORMAT(DEPO_STOCK)#</td>
                        <td style="text-align:right;">#TLFORMAT(MAGAZA_STOCK)#</td>
                        <!---
                        <td style="text-align:right;">#TLFORMAT(KARSILANAN_MIKTAR)#</td>--->
                        <td style="text-align:right;">#TLFORMAT(SATIR_MIKTARI)#</td>
                        
                    </tr>
                    <cfset last_birinci_ = birinci_>
                    <cfset last_ikinci_ = ikinci_>
                    <cfset last_ucuncu_ = ucuncu_>
                </cfoutput>
            </tbody>
        </cf_grid_list>
    </cf_box>
</div>
</cfif>