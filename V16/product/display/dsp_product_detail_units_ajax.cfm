<!--- urun detay birimler liste,ekle,guncelle --->
<cfsetting showdebugoutput="no">
<cfquery name="GET_PRODUCT_UNIT" datasource="#DSN3#">
    SELECT 
        PRODUCT_UNIT_ID,
        IS_MAIN,
        MAIN_UNIT_ID,
        ADD_UNIT,
        MULTIPLIER,
        QUANTITY,
        MAIN_UNIT,
		IS_ADD_UNIT
    FROM 
        PRODUCT_UNIT 
    WHERE 
        PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> AND 
        PRODUCT_UNIT_STATUS = 1
</cfquery>
<cf_flat_list> 
	<cfoutput query="get_product_unit">
        <tbody>
            <tr>
                <td>
                    <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=product.form_upd_popup_unit&unit_id=#product_unit_id#');">
                    <cfif is_main is 1>
                        <cfset unit_id = MAIN_UNIT_ID>
                        #add_unit# = #MULTIPLIER# x #main_unit#
                    <cfelse>
                        <cfif isdefined("attributes.is_show_unit_amount") and attributes.is_show_unit_amount eq 1>
                        	<cfif len(get_product_unit.quantity)>
                            	#main_unit# = #tlformat(wrk_round(QUANTITY,8,1),4)#  x #add_unit#
                            <cfelse>
                            	1 #add_unit#  = #tlformat(wrk_round(MULTIPLIER,8,1),4)#  x #main_unit#
                            </cfif>
                        <cfelse>
                            #add_unit# = #wrk_round(MULTIPLIER,8,1)# x #main_unit#
                        </cfif>
                    </cfif>
                    </a> 
                </td>
            </tr>
        </tbody>
    </cfoutput>
</cf_flat_list>
