<cfinclude template="../query/get_basket_rows.cfm">
<cfif fusebox.use_stock_speed_reserve><!--- sipariste anında urun rezerve calısıyorsa, sepetteki urunlerin rezerveleri de siliniyor --->
	<!--- E.A stored proc'a çevirdim 20130305 6 AYA SİLİNSİN --->
	<!---<cfquery name="DEL_RESERVE_ROWS" datasource="#DSN3#">
		DELETE FROM ORDER_ROW_RESERVED WHERE PRE_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cftoken#">
	</cfquery>--->
    <cfstoredproc procedure="DEL_ORDER_ROW_RESERVED" datasource="#DSN3#">
    	<cfprocparam cfsqltype="cf_sql_varchar" value="#cftoken#">
    </cfstoredproc>
</cfif>

<cfif isDefined('attributes.is_control_zero_stock') and attributes.is_control_zero_stock eq 1>
    <cfquery name="GET_STOCK_LAST" datasource="#DSN2#">
        <cfif isdefined("attributes.is_zero_stock_dept") and len(attributes.is_zero_stock_dept) and listlen(attributes.is_zero_stock_dept,'-') eq 2>
            get_stock_last_location_function '#ValueList(get_rows.stock_id)#'
        <cfelseif isdefined("session.ww.department_ids") and len(session.ww.department_ids)>
            get_stock_last_location_function '#ValueList(get_rows.stock_id)#'
        <cfelseif isdefined("session.pp.department_ids") and len(session.pp.department_ids)>
            get_stock_last_location_function '#ValueList(get_rows.stock_id)#'
        <cfelse>
            get_stock_last_function '#ValueList(get_rows.stock_id)#'
        </cfif>
    </cfquery>
    
    <cfquery name="GET_LAST_STOCKS_1" dbtype="query">
        SELECT
            SUM(SALEABLE_STOCK) AS SALEABLE_STOCK,
            STOCK_ID
        FROM
            GET_STOCK_LAST
        <cfif isdefined("attributes.is_zero_stock_dept") and len(attributes.is_zero_stock_dept) and listlen(attributes.is_zero_stock_dept,'-') eq 2>
            WHERE
                DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.is_zero_stock_dept,1,'-')#"> AND 
                LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.is_zero_stock_dept,2,'-')#">	
        <cfelseif isdefined("session.ww.department_ids") and len(session.ww.department_ids)>
            WHERE DEPARTMENT_ID IN (#session.ww.department_ids#)
        <cfelseif isdefined("session.pp.department_ids") and len(session.pp.department_ids)>
            WHERE DEPARTMENT_ID IN (#session.pp.department_ids#)
        </cfif>
        GROUP BY 
            STOCK_ID
    </cfquery>
</cfif>

<cfoutput query="get_rows">
	<!--- BK 20100423 Dore de sorun oldugu icin--->
	<cfif isdefined("attributes.amount_#order_row_id#")>		
		<!--- BK eski hali 20110725 <cfset new_value_ = evaluate('attributes.amount_#order_row_id#')/PROM_STOCK_AMOUNT> --->
        <cfset new_value_ = filternum(evaluate('attributes.amount_#order_row_id#'),fusebox.Format_Currency)/prom_stock_amount>
        <cfif isDefined('attributes.is_control_zero_stock') and attributes.is_control_zero_stock eq 1>
            <cfquery name="GET_LAST_STOCK" dbtype="query">
                SELECT * FROM GET_LAST_STOCKS_1 WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#">
            </cfquery>
            <cfif not get_last_stock.recordcount or (get_last_stock.recordcount and (get_last_stock.saleable_stock-new_value_) lt 0)>
                <script language="javascript">
                    alert('#product_name# ürünü yeterli miktarda stokta bulunmamaktadır.');
                    window.location.href='#request.self#?fuseaction=objects2.list_basket<cfif isDefined('attributes.consumer_id') and len(attributes.consumer_id)>&consumer_id=#attributes.consumer_id#</cfif>';
                </script>
                <cfabort>
            </cfif>        
        </cfif>
        
		<cfquery name="UPD_" datasource="#DSN3#">
			UPDATE ORDER_PRE_ROWS SET QUANTITY = #new_value_# WHERE ORDER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_row_id#">
		</cfquery>
		<cfif fusebox.use_stock_speed_reserve> <!--- sipariste anında urun rezerve calısıyorsa, sepetteki urunlerin rezerveleri de siliniyor --->
			<cfif (len(get_rows.stock_action_type) and not listfind('1,2,3',get_rows.stock_action_type,',')) or not len(get_rows.stock_action_type)>
				<cfquery name="ADD_RESERVE_" datasource="#DSN3#">
					INSERT INTO 
						ORDER_ROW_RESERVED
                        (
                            STOCK_ID,
                            PRODUCT_ID,
                            RESERVE_STOCK_OUT,
                            ORDER_ROW_ID,
                            PRE_ORDER_ID,
                            IS_BASKET
                        ) 
                        VALUES
                        (
                            #get_rows.stock_id#,
                            #get_rows.product_id#,
                            #new_value_#,
                            #order_row_id#,
                            '#CFTOKEN#',
                            1				
                        )
				</cfquery>
			</cfif>
		</cfif>
	</cfif>
</cfoutput>

<cfif not isDefined('attributes.fuseact')>
	<cfset attributes.fuseact = 'objects2.list_basket'>
</cfif>

<cfif isDefined('attributes.consumer_id') and len(attributes.consumer_id)>
	<cflocation url="#request.self#?fuseaction=#attributes.fuseact#&consumer_id=#attributes.consumer_id#" addtoken="no">
<cfelse>
	<cflocation url="#request.self#?fuseaction=#attributes.fuseact#" addtoken="no">
</cfif>
