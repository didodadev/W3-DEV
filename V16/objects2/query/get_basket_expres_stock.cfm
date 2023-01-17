<cfsetting showdebugoutput="no">
<cfquery name="getStock" datasource="#DSN3#">
	SELECT 
		S.PROPERTY,
		S.STOCK_ID,
		S.STOCK_CODE,
		P.PRODUCT_CODE,
		P.PRODUCT_CODE_2
	FROM 
		STOCKS S,
		PRODUCT P
	WHERE 
		P.PRODUCT_ID = S.PRODUCT_ID AND
		<cfif attributes.use_prod_code_type eq 1>
			S.STOCK_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.specialCode#"> AND
		<cfelseif  attributes.use_prod_code_type eq 2>
			P.PRODUCT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.specialCode#"> AND
		<cfelse>
			P.PRODUCT_CODE_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.specialCode#"> AND
		</cfif>
		S.STOCK_STATUS = 1 AND
		S.PROPERTY IS NOT NULL
</cfquery>
<cfset stock_id_list = valuelist(getStock.stock_id,',')>
<cfif len(stock_id_list)>
	<!---<cfquery name="GET_STOCK_LAST" datasource="#DSN2#">
		get_stock_last_function '#stock_id_list#'
	</cfquery>
	<cfloop query="get_stock_last">
		<cfset "last_stock_#get_stock_last.stock_id#" = get_stock_last.saleable_stock>
	</cfloop>--->
    <cfquery name="GET_STOCK_LAST" datasource="#DSN2#">
		<cfif isdefined("session.ww.department_ids") and len(session.ww.department_ids) or  isdefined("session.pp.department_ids") and len(session.pp.department_ids)>
            get_stock_last_location_function '#stock_id_list#'
        <cfelse>
            get_stock_last_function '#stock_id_list#'
        </cfif>
    </cfquery>
    <cfquery name="GET_LAST_STOCKS" dbtype="query">
        SELECT
            SUM(SALEABLE_STOCK) AS SALEABLE_STOCK,
            STOCK_ID
        FROM
            GET_STOCK_LAST
        <cfif isdefined("session.ww.department_ids") and len(session.ww.department_ids)>
            WHERE
                DEPARTMENT_ID IN (#session.ww.department_ids#)
        <cfelseif isdefined("session.pp.department_ids") and len(session.pp.department_ids)>
            WHERE
                DEPARTMENT_ID IN (#session.pp.department_ids#)
        </cfif>
        GROUP BY 
            STOCK_ID
    </cfquery>
    <cfloop query="GET_LAST_STOCKS">
		<cfset "last_stock_#GET_LAST_STOCKS.stock_id#" = GET_LAST_STOCKS.saleable_stock>
	</cfloop>
</cfif>

<cfoutput>
	<cfset div_heignt = 40+(20*getStock.recordcount)>
	<div id="_search_" style="position:absolute;width:100%;height:#div_heignt#;z-index:1;overflow:auto; z-index:9999;background-color: efefef; border: 1px outset cccccc;">
</cfoutput>
<table align="center" border="0" cellpadding="0" cellspacing="0" class="color-border" style="width:100%">
	<tr class="color-list" style="height:20px;">
		<td></td>
		<td align="right" style="text-align:right;"><a href="##" onclick="gizle(check_stock_layer<cfoutput>#attributes.satirNo#</cfoutput>);SatirBosalt();"><img src="../images/pod_close.gif" border="0"></a></td>
	</tr>
	<cfif getStock.recordcount>
        <cfoutput query="getStock">
            <cfif isdefined("last_stock_#stock_id#") and evaluate("last_stock_#stock_id#") gt 0>
                <tr onmouseover="this.className='color-list';" onmouseout="this.className='color-row';" class="color-row">
                    <cfif  attributes.use_prod_code_type eq 3>
                        <cfset name_ = '#product_code# #property#'>
                    <cfelse>
                        <cfset name_ = '#product_code_2# #property#'>
                    </cfif>
                    <td colspan="2"><a href="##" onclick="stockChange('#stock_code#','#name_#');" class="tableyazi">#currentrow# - #property#</a></td>
                </tr>
            </cfif>
        </cfoutput>
    <cfelse>
        <tr>
            <td colspan="2" style="vertical-align:top;">Kayıt Bulunamadı!</td>
        </tr>
    </cfif>
</table>
</div>
<script type="text/javascript">
	function stockChange(stock_code,name)
	{
		document.getElementById('special_code<cfoutput>#attributes.satirNo#</cfoutput>').value = name;
		document.getElementById('product_code<cfoutput>#attributes.satirNo#</cfoutput>').value = stock_code;
		gizle(check_stock_layer<cfoutput>#attributes.satirNo#</cfoutput>);
	}
	function SatirBosalt()
	{
		document.getElementById('special_code<cfoutput>#attributes.satirNo#</cfoutput>').value = '';
	}
</script>
