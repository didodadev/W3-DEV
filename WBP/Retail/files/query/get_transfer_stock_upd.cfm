<cfquery name="get_departments_search" datasource="#dsn#">
	SELECT 
    	DEPARTMENT_ID,
        DEPARTMENT_HEAD,
        HIERARCHY 
    FROM 
    	DEPARTMENT D
    WHERE
    	D.IS_STORE IN (1,3) AND
        ISNULL(D.IS_PRODUCTION,0) = 0 AND
        HIERARCHY IS NOT NULL AND
        DEPARTMENT_ID <> #attributes.department_id#
    ORDER BY 
    	DEPARTMENT_HEAD
</cfquery>

<cfquery name="get_dept" datasource="#dsn#">
	SELECT 
    	DEPARTMENT_ID,
        DEPARTMENT_HEAD,
        HIERARCHY 
    FROM 
    	DEPARTMENT D
    WHERE
        DEPARTMENT_ID = #attributes.department_id#
</cfquery>

<cfset only_this_year = 1>

<cfif month(now()) eq 1 and day(now()) lte order_control_day>
	<cfset only_this_year = 0>
</cfif>

<cfif month(now()) eq 12 and day(now()) gt order_control_day>
	<cfset only_this_year = 0>
</cfif>

<cfquery name="get_periods" datasource="#dsn#">
	SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID IS NOT NULL <cfif only_this_year eq 1>AND PERIOD_YEAR = #year(now())#</cfif>
    	
</cfquery>
<cfquery name="get_periods_ic" datasource="#dsn#">
	SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID IS NOT NULL <cfif only_this_year eq 1>AND PERIOD_YEAR = #year(now())#</cfif>
</cfquery>

<cfquery name="get_stock_info" datasource="#dsn2#" result="get_stock_info_r">
	EXEC get_stock_last_location_function '#attributes.stock_id#'
</cfquery>

<cfoutput query="get_stock_info">
	<cfif department_id gt 0>
        <cfset 'stock_#department_id#' = PRODUCT_STOCK>
    </cfif>
</cfoutput>

<cfquery name="get_transfers" datasource="#dsn_Dev#">
    SELECT
        *
    FROM
        STOCK_TRANSFER_LIST
    WHERE
        STOCK_ID = #attributes.stock_id# AND
        DEPARTMENT_ID = #attributes.department_id#
</cfquery>
<cfoutput query="get_transfers">
    <cfset 'dagilim_#to_department_id#' = amount>
</cfoutput>
<form name="add_form" action="<cfoutput>#request.self#?fuseaction=retail.emptypopup_get_transfer_stock_upd_action</cfoutput>" method="post">
<cfoutput>
    <input type="hidden" name="stock_id" value="#attributes.stock_id#"/>
    <input type="hidden" name="department_id" value="#attributes.department_id#"/>
    <input type="hidden" name="department_id_list" value="#valuelist(get_departments_search.department_id)#"/>
</cfoutput>
<cf_ajax_list>
	<thead>
    	<tr>
        	<th style="color:black;" colspan="3">
            	&nbsp;
				<cfoutput>
                	<b><a href="index.cfm?fuseaction=retail.transfer_branch_list" target="branch_transfer">#get_dept.department_head# Dağılımı</a></b>
                </cfoutput>
            </th>
            <th colspan="2" style="color:black; text-align:right;">
            	<cfquery name="get_row_stock"  dbtype="query">
                    SELECT 
                        SUM(PRODUCT_STOCK) AS SONSTOK 
                    FROM 
                        get_stock_info
                    WHERE 
                        DEPARTMENT_ID = #attributes.department_id#
                </cfquery>
            	<cfoutput>
                	<b>Stok : <cfif get_row_stock.recordcount and len(get_row_stock.SONSTOK)>#get_row_stock.SONSTOK#<cfelse>0</cfif></b>
                </cfoutput>
                &nbsp;
            </th>
        </tr>
    </thead>
    <thead>
    	<tr>
        	<th>Departman</th>
            <th style="text-align:right;">Stok</th>
            <th style="text-align:right;">Sip. Bakiye</th>
            <th style="text-align:right;">Dağılım</th>
            <th style="text-align:right;"><a href="javascript://" onclick="hide('manage_s_tranfer_div');"><img src="/images/closethin.gif"/></a></th>
        </tr>
    </thead>
    <tbody>
    <cfoutput query="get_departments_search">
    	<cfset dept_ = get_departments_search.department_id>
    	<cfquery name="get_eski_dagilim" datasource="#dsn#">
				SELECT
                	SUM(MIKTAR - KARSILANAN) AS BEKLENEN
                FROM
                    (
					<cfset count_ = 0>
                    <cfloop query="get_periods">
                    <cfset count_ = count_ + 1>
                    <cfset m_p_year = get_periods.period_year[count_]>
                    <cfset m_our_comp = get_periods.our_company_id[count_]>
                        SELECT
                            ISNULL((
                                SELECT
                                    SUM(AMOUNT) AS AMOUNT_TOTAL
                                FROM
                                    (
                                        <cfset p_count_ = 0>
                                        <cfloop query="get_periods_ic">
                                            <cfset p_count_ = p_count_ + 1>
                                            SELECT 
                                                SROW.AMOUNT
                                            FROM 
                                                #dsn#_#get_periods_ic.period_year#_#get_periods_ic.our_company_id#.SHIP_ROW SROW 
                                            WHERE 
                                                SROW.WRK_ROW_RELATION_ID = SIR.WRK_ROW_ID
                                        <cfif p_count_ neq get_periods_ic.recordcount>
                                            UNION ALL
                                        </cfif>
                                        </cfloop>
                                    ) T1
                            ),0) AS KARSILANAN,
                            CASE WHEN SI.DEPARTMENT_IN = #dept_# THEN SIR.AMOUNT ELSE (-1 * SIR.AMOUNT) END AS MIKTAR
                        FROM
                            #dsn#_#m_p_year#_#m_our_comp#.SHIP_INTERNAL SI,
                            #dsn#_#m_p_year#_#m_our_comp#.SHIP_INTERNAL_ROW SIR
                        WHERE
                            SI.DELIVER_DATE >= #dateadd('d',order_control_day,bugun_)# AND
       						SI.DELIVER_DATE < #dateadd('d',1,bugun_)# AND
                            SI.DISPATCH_SHIP_ID = SIR.DISPATCH_SHIP_ID AND
                            (SI.DEPARTMENT_IN = #dept_# OR SI.DEPARTMENT_OUT = #dept_#) AND
                            SIR.STOCK_ID = #attributes.stock_id#
                        <cfif count_ neq get_periods.recordcount>
                        UNION ALL
                        </cfif>
                    </cfloop>
                  ) T_ALL
        </cfquery>
        <cfif get_eski_dagilim.recordcount and len(get_eski_dagilim.BEKLENEN)>
        	<cfset dagilim_ = get_eski_dagilim.BEKLENEN>
        <cfelse>
        	<cfset dagilim_ = 0>
        </cfif>
    	<tr>
        	<td>#DEPARTMENT_HEAD#</td>
            <td style="text-align:right;">
            	<cfif isdefined("stock_#department_id#")>
                	#evaluate("stock_#department_id#")#
                <cfelse>
                	0
                </cfif>
            </td>
            <cfquery name="get_siparis" datasource="#dsn3#">
                SELECT
                    SUM(ORR.QUANTITY) AS SIPARISLER
                FROM
                    ORDERS O INNER JOIN
                    ORDER_ROW ORR ON ORR.ORDER_ID = O.ORDER_ID
                WHERE
                    O.ORDER_STAGE = #valid_order_stage_# AND
                    O.PURCHASE_SALES = 0 AND
                    ORR.ORDER_ROW_CURRENCY NOT IN (-3,-10) AND
                    ORR.STOCK_ID = #attributes.stock_id# AND
                    O.DELIVER_DEPT_ID = #department_id# AND
                    O.ORDER_DATE >= #dateadd('d',order_control_day,bugun_)# AND
                    O.ORDER_DATE < #dateadd('d',1,bugun_)# 
            </cfquery>
            <cfif get_siparis.recordcount and len(get_siparis.SIPARISLER)>
                <cfset sip_ = get_siparis.SIPARISLER>
            <cfelse>
                <cfset sip_ = 0>
            </cfif>
            <td style="text-align:right;">#sip_#</td>
            <td style="text-align:right;">#dagilim_#</td>
            <td style="text-align:right;">
            	<cfif isdefined("dagilim_#department_id#")>
                	<cfset dag_ = evaluate("dagilim_#department_id#")>
                <cfelse>
                	<cfset dag_ = 0>
                </cfif>
                <input type="text" name="amount_#department_id#" value="#dag_#" style="width:30px; text-align:right;" onfocus="this.select();" onkeyup="return(formatcurrency(this,event,0));"/>
            </td>
        </tr>
    </cfoutput>
    </tbody>
    <tfoot>
    	<tr>
        	<td colspan="3"><div id="manage_s_tranfer_div_action"></div></td>
            <td colspan="2" style="text-align:right;">
            	<input type="button" value="Dağılım Yap" onclick="t_submit();"/>
            </td>
        </tr>
    </tfoot>
</cf_ajax_list>
</form>
<script>
<cfoutput>
function t_submit()
{
	AjaxFormSubmit('add_form','manage_s_tranfer_div_action',1,'Kaydediliyor','Kaydedildi','index.cfm?fuseaction=retail.emptypopup_get_transfer_stock','dagitim_#attributes.DEPARTMENT_ID#_#attributes.stock_id#','1');	
}
</cfoutput>
</script>
