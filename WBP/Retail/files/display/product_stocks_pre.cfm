<cfparam name="attributes.view_type" default="m">
<cfparam name="attributes.view_start" default="#month(now())#">
<cfparam name="attributes.view_row" default="12">
<cfparam name="attributes.view_stock_type" default="1">
<cfparam name="attributes.view_stock_type1" default="1">
<cfparam name="attributes.search_department_id" default="#merkez_depo_id#">
<cfquery name="get_my_branches" datasource="#dsn#">
	SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#
</cfquery>
<cfif get_my_branches.recordcount>
	<cfset my_branch_list = valuelist(get_my_branches.BRANCH_ID)>
<cfelse>
	<cfset my_branch_list = '0'>
</cfif>
<cfquery name="get_departments_search" datasource="#dsn#">
	SELECT 
    	DEPARTMENT_ID,DEPARTMENT_HEAD,HIERARCHY 
    FROM 
    	DEPARTMENT D
    WHERE
    	D.IS_STORE IN (1,3) AND
        ISNULL(D.IS_PRODUCTION,0) = 0 AND
        BRANCH_ID IN (#MY_BRANCH_LIST#) AND        
        HIERARCHY IS NOT NULL
    ORDER BY 
    	DEPARTMENT_HEAD
</cfquery>

<cfif isdefined("attributes.stock_id")>
    <cfquery name="get_code" datasource="#dsn1#">
    	SELECT  
        	S.STOCK_CODE_2 AS CODE,
            S.PROPERTY,
            P.PRODUCT_NAME 
        FROM 
        	STOCKS S,
            PRODUCT P
        WHERE 
        	S.PRODUCT_ID = P.PRODUCT_ID AND
            S.STOCK_ID IN (#attributes.stock_id#)
    </cfquery>
    <cfif get_code.recordcount gt 1>
		<cfset header_ = "#get_code.PRODUCT_NAME#">
    <cfelse>
    	<cfset header_ = "#get_code.PROPERTY#">
    </cfif>
<cfelseif isdefined("attributes.product_id")>
    <cfquery name="get_stocks" datasource="#dsn3#">
    	SELECT STOCK_ID,PRODUCT_NAME FROM STOCKS WHERE PRODUCT_ID = #attributes.product_id#
    </cfquery>
    <cfset attributes.stock_id = valuelist(get_stocks.stock_id)>
    <cfset header_ = "#get_stocks.PRODUCT_NAME#">
</cfif>

<cf_medium_list_search>
<input type="hidden" id="view_type_d" value="<cfoutput>#attributes.view_type#</cfoutput>"/>
<input type="hidden" id="view_stock_type_d" value="<cfoutput>#attributes.view_stock_type#</cfoutput>"/>
<input type="hidden" id="stock_search_department_id_d" value="<cfoutput>#attributes.search_department_id#</cfoutput>"/>
    <table>
        <tr>
            <td class="formbold"><cfoutput>#header_#</cfoutput></td>
            <td>
                <select name="view_type" id="view_type">
                    <option value="m" <cfif attributes.view_type is 'm'>selected</cfif>>Aylık</option>
                    <option value="w" <cfif attributes.view_type is 'w'>selected</cfif>>Haftalık</option>
                    <option value="d" <cfif attributes.view_type is 'd'>selected</cfif>>Günlük</option>
                </select>
            </td>
            <td>
                <select name="view_stock_type" id="view_stock_type">
                    <option value="0" <cfif attributes.view_stock_type eq 0>selected</cfif>>Tümü</option>
                    <option value="1" <cfif attributes.view_stock_type eq 1>selected</cfif>>Perakende</option>
                    <option value="2" <cfif attributes.view_stock_type eq 2>selected</cfif>>Toptan</option>
                </select>
            </td>
            <td>Mağaza</td>
            <td>
                <select name="stock_search_department_id" id="stock_search_department_id" multiple="multiple">
                    <cfoutput query="get_departments_search">
                        <option value="#department_id#" <cfif listfind(attributes.search_department_id,department_id)>selected</cfif>>#department_head#</option>
                    </cfoutput>
                </select>
            </td>
        </tr>
    </table>
</cf_medium_list_search>
<script>
<cfoutput>
	adress_ = 'index.cfm?fuseaction=retail.popup_product_stocks';
	adress_ += '&stock_id=#attributes.stock_id#';
	<cfif isdefined("attributes.search_department_id")>
		adress_ += '&search_department_id=#attributes.search_department_id#';
	</cfif>
</cfoutput>
	AjaxPageLoad(adress_,'stock_window_inner','1');
</script>
<div id="stock_window_inner" style="width:100%;"></div>