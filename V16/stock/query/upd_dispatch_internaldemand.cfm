<cf_get_lang_set module_name="stock"><!--- sayfanin en altinda kapanisi var --->
<cfif isDefined("attributes.shipDel")>
	<cfinclude template="upd_dispatch_internal_del.cfm">
<cfelse>
	<cfif len(attributes.DELIVER_DATE_FRM)>
        <cf_date tarih = 'attributes.DELIVER_DATE_FRM'>
        <cfset attributes.PROCESS_DATE=attributes.DELIVER_DATE_FRM>
    </cfif>
    <cf_date tarih = 'attributes.SHIP_DATE'>
    
    <cfif len(attributes.LOCATION_IN_ID) >
        <cfset int_loc_in = attributes.LOCATION_IN_ID >
        <cfset int_dep_in = attributes.DEPARTMENT_IN_ID >
    <cfelse>
        <cfset int_loc_in = "NULL" >
        <cfset int_dep_in = attributes.DEPARTMENT_IN_ID >
    </cfif>
    <cfif len(attributes.LOCATION_ID) >
        <cfset attributes.LOCATION_ID_OUT = attributes.LOCATION_ID >
        <cfset attributes.DEPARTMENT_ID_OUT = attributes.DEPARTMENT_ID >
    <cfelse>
        <cfset attributes.LOCATION_ID_OUT = "NULL" >
        <cfset attributes.DEPARTMENT_ID_OUT = attributes.DEPARTMENT_ID >
    </cfif>
    
    <cflock name="#CreateUUID()#" timeout="20">
    <cftransaction>
        <cfquery name="UPD_SALE" datasource="#DSN2#">
            UPDATE
                SHIP_INTERNAL
            SET
                <cfif isDefined('attributes.SHIP_METHOD') and len(attributes.SHIP_METHOD)>
                    SHIP_METHOD = #attributes.SHIP_METHOD#,
                </cfif>
                SHIP_DATE = #attributes.SHIP_DATE#,
                DELIVER_DATE = <cfif len(attributes.DELIVER_DATE_FRM)>#attributes.DELIVER_DATE_FRM#,<cfelse>NULL,</cfif>
                PROCESS_STAGE = #attributes.process_stage#,
                DISCOUNTTOTAL = <cfif isdefined("attributes.BASKET_DISCOUNT_TOTAL")>#attributes.BASKET_DISCOUNT_TOTAL#,<cfelse>0,</cfif>
                NETTOTAL = <cfif isdefined("attributes.basket_net_total")>0#attributes.basket_net_total#,<cfelse>0,</cfif>
                GROSSTOTAL = <cfif isdefined("attributes.basket_gross_total")>0#attributes.basket_gross_total#,<cfelse>0,</cfif>
                TAXTOTAL = <cfif isdefined("attributes.basket_tax_total")>0#attributes.basket_tax_total#,<cfelse>0,</cfif>
                MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
                RATE1 = #attributes.basket_rate1#,
                RATE2 = #attributes.basket_rate2#,
                DEPARTMENT_OUT = #attributes.DEPARTMENT_ID_OUT#,
                LOCATION_OUT = #attributes.LOCATION_ID_OUT#,
                DEPARTMENT_IN = #int_dep_in#,
                LOCATION_IN = #int_loc_in#,
                DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#">,
                UPDATE_DATE = #now()#,
                UPDATE_EMP = #session.ep.userid#,
                PAPER_NO = <cfif isdefined("attributes.ship_internal_number") and len(attributes.ship_internal_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ship_internal_number#"><cfelse>NULL</cfif>
            WHERE
                DISPATCH_SHIP_ID = #attributes.UPD_ID#
        </cfquery>	
        <!--- SHIP_ROWS EKLENIR LOOP ILE  --->
        <cfquery name="DEL_SHIP_ROWS" datasource="#DSN2#">
            DELETE FROM  SHIP_INTERNAL_ROW WHERE DISPATCH_SHIP_ID = #attributes.UPD_ID#
        </cfquery>
        <cfloop from="1" to="#attributes.rows_#" index="i">
            <cf_date tarih="attributes.deliver_date#i#">	
            <cfquery name="ADD_SHIP_ROW" datasource="#DSN2#">
                INSERT INTO
                    SHIP_INTERNAL_ROW
                    (
                        NAME_PRODUCT,
                        DISPATCH_SHIP_ID,
                        STOCK_ID,
                        PRODUCT_ID,
                        AMOUNT,
                        AMOUNT2,
				        UNIT2,
                        UNIT,
                        UNIT_ID,					
                        TAX,
                        <cfif len(evaluate("attributes.price#i#"))>
                        PRICE,
                        </cfif>
                        DISCOUNT,
                        DISCOUNT2,
                        DISCOUNT3,
                        DISCOUNT4,
                        DISCOUNT5,
                        DISCOUNT6,
                        DISCOUNT7,
                        DISCOUNT8,
                        DISCOUNT9,
                        DISCOUNT10,					
                        DELIVER_DATE,
                        DELIVER_DEPT,
                        DELIVER_LOC,
                        <cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>					
                        SPECT_VAR_ID,
                        SPECT_VAR_NAME,
                        </cfif>
                        LOT_NO,
                        PRICE_OTHER,
                        PRODUCT_NAME2,
                        ROW_PROJECT_ID,
                        BASKET_EXTRA_INFO_ID,
                        SELECT_INFO_EXTRA,
                	    DETAIL_INFO_EXTRA,
                        OTHER_MONEY
                    )
                VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#left(wrk_eval('attributes.product_name#i#'),250)#">,
                        #attributes.UPD_ID#,
                        #evaluate("attributes.stock_id#i#")#,
                        #evaluate("attributes.product_id#i#")#,
                        #evaluate("attributes.amount#i#")#,
                        <cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("attributes.amount_other#i#")#">,
				        <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("attributes.unit_other#i#")#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.unit#i#')#">,
                        #evaluate("attributes.unit_id#i#")#,					
                        #evaluate("attributes.tax#i#")#,
                        <cfif len(evaluate("attributes.price#i#"))>
                        #evaluate("attributes.price#i#")#,
                        </cfif>
                        <cfif isdefined('attributes.indirim1#i#') and len(evaluate('attributes.indirim1#i#'))>#evaluate('attributes.indirim1#i#')#<cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.indirim2#i#') and len(evaluate('attributes.indirim2#i#'))>#evaluate('attributes.indirim2#i#')#<cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.indirim3#i#') and len(evaluate('attributes.indirim3#i#'))>#evaluate('attributes.indirim3#i#')#<cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.indirim4#i#') and len(evaluate('attributes.indirim4#i#'))>#evaluate('attributes.indirim4#i#')#<cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.indirim5#i#') and len(evaluate('attributes.indirim5#i#'))>#evaluate('attributes.indirim5#i#')#<cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.indirim6#i#') and len(evaluate('attributes.indirim6#i#'))>#evaluate('attributes.indirim6#i#')#<cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.indirim7#i#') and len(evaluate('attributes.indirim7#i#'))>#evaluate('attributes.indirim7#i#')#<cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.indirim8#i#') and len(evaluate('attributes.indirim8#i#'))>#evaluate('attributes.indirim8#i#')#<cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.indirim9#i#') and len(evaluate('attributes.indirim9#i#'))>#evaluate('attributes.indirim9#i#')#<cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.indirim10#i#') and len(evaluate('attributes.indirim10#i#'))>#evaluate('attributes.indirim10#i#')#<cfelse>NULL</cfif>,
                        
                        <cfif isdefined("attributes.deliver_date#i#") and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
                        #attributes.DEPARTMENT_ID_OUT#,
                        #attributes.LOCATION_ID_OUT#,
                        <cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
                            #evaluate('attributes.spect_id#i#')#,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.spect_name#i#')#">,
                        </cfif>
                        <cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))>#evaluate('attributes.lot_no#i#')#<cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.price_other#i#') and len(evaluate('attributes.price_other#i#'))>#evaluate("attributes.price_other#i#")#<cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.product_name_other#i#') and len(evaluate('attributes.product_name_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.product_name_other#i#')#"><cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.row_project_id#i#') and len(evaluate('attributes.row_project_id#i#')) and isdefined('attributes.row_project_name#i#') and len(evaluate('attributes.row_project_name#i#'))>#evaluate('attributes.row_project_id#i#')#<cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.basket_extra_info#i#') and len(evaluate('attributes.basket_extra_info#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.basket_extra_info#i#')#"><cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.select_info_extra#i#') and len(evaluate('attributes.select_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.select_info_extra#i#')#"><cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.detail_info_extra#i#') and len(evaluate('attributes.detail_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.detail_info_extra#i#')#"><cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.other_money_#i#') and len(evaluate('attributes.other_money_#i#'))>'#evaluate("attributes.other_money_#i#")#'<cfelse>NULL</cfif>
                    )
            </cfquery>
        </cfloop>
        <cf_workcube_process
            is_upd='1' 
            data_source='#dsn2#' 
            old_process_line='#attributes.old_process_line#'
            process_stage='#attributes.process_stage#' 
            record_member='#session.ep.userid#' 
            record_date='#now()#' 
            action_table='SHIP_INTERNAL'
            action_column='DISPATCH_SHIP_ID'
            action_id='#attributes.upd_id#'
            action_page='index.cfm?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_dispatch_internaldemand&event=upd&ship_id=#attributes.upd_id#' 
            warning_description='Sevk Talebi : #attributes.upd_id#'>
    </cftransaction>
    </cflock>	
    <cfscript>basket_kur_ekle(action_id:attributes.UPD_ID,table_type_id:10,process_type:1);</cfscript>
    <script type="text/javascript">
        window.location.href="<cfoutput>#request.self#?fuseaction=stock.add_dispatch_internaldemand&event=upd&ship_id=#attributes.UPD_ID#</cfoutput>";
    </script>
    <cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
</cfif>