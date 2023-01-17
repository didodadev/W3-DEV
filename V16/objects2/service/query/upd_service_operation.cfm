<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
        <cfquery name="DEL_SERVICE_OPERATION" datasource="#DSN3#">
            DELETE FROM SERVICE_OPERATION WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
        </cfquery>
        <cfloop from="1" to="#attributes.record_num#" index="i">
            <cfif evaluate("attributes.row_kontrol#i#")>
                <cfset form_spare_part_type = evaluate("attributes.spare_part_type#i#")>
                <cfset form_stock_id = evaluate("attributes.stock_id#i#")>
                <cfset form_product_id = evaluate("attributes.product_id#i#")>
                <cfset form_product = evaluate("attributes.product#i#")>
                <cfif isdefined("attributes.amount#i#") and len(evaluate("attributes.amount#i#"))>
                    <cfset form_amount = evaluate("attributes.amount#i#")>
                <cfelse>
                    <cfset form_amount = ''>
                </cfif>
                <cfif isdefined("attributes.unit_id#i#") and len(evaluate("attributes.unit_id#i#"))>
                    <cfset form_unit_name = evaluate("attributes.unit_name#i#")>
                    <cfset form_unit_id = evaluate("attributes.unit_id#i#")>
                <cfelse>
                    <cfset form_unit_id = ''>
                    <cfset form_unit_name = ''>
                </cfif>
                <cfset form_price = evaluate("attributes.price#i#")>
                <cfset form_total_price = evaluate("attributes.total_price#i#")>
                <cfset form_detail = evaluate("attributes.product#i#")>
                <cfset form_wrk_row_id = evaluate("attributes.wrk_row_id#i#")>
                <cfif isdefined("attributes.serial_no_#i#")>
                  <cfset form_serial_no = evaluate("attributes.serial_no_#i#")>
                </cfif>
                
                <cfif isdefined("attributes.is_total#i#")>
                    <cfset is_total_ = 1>
                <cfelse>
                    <cfset is_total_ = 0>
                </cfif>
                
                <cfquery name="ADD_SERVICE_OPERATION" datasource="#DSN3#">
                    INSERT INTO
                        SERVICE_OPERATION
                        (
                            SERVICE_ID,
                            SPARE_PART_ID,
                            STOCK_ID,
                            PRODUCT_ID,
                            PRODUCT_NAME,
                            AMOUNT,
                            UNIT_ID,
                            UNIT,
                            PRICE,
                            TOTAL_PRICE,
                            CURRENCY,
                            DETAIL,
                            IS_TOTAL,
                            WRK_ROW_ID,
                            SERVICE_EMP_ID,
                            SERIAL_NO,
                            RECORD_MEMBER,
                            RECORD_IP,
                            RECORD_DATE			
                        )
                        VALUES
                        (
                            #attributes.service_id#,
                            #form_spare_part_type#,
                            <cfif len(form_stock_id)>#form_stock_id#<cfelse>NULL</cfif>,
                            <cfif len(form_product_id)>#form_product_id#<cfelse>NULL</cfif>,
                            '#form_product#',
                            <cfif len(form_amount)>#form_amount#<cfelse>NULL</cfif>,
                            <cfif len(form_unit_id)>#form_unit_id#<cfelse>NULL</cfif>,
                            <cfif len(form_unit_name)>'#form_unit_name#'<cfelse>NULL</cfif>,
                            <cfif len(form_price)>#form_price#<cfelse>NULL</cfif>,
                            <cfif len(form_total_price)>#form_total_price#<cfelse>NULL</cfif>,
                            <cfif isdefined("attributes.money#i#") and len(evaluate("attributes.money#i#"))>'#listfirst(evaluate("attributes.money#i#"),";")#'<cfelse>NULL</cfif>,
                            <cfif len(form_detail)>'#form_detail#'<cfelse>NULL</cfif>,
                            #is_total_#,
                            <cfif len(form_wrk_row_id)>'#form_wrk_row_id#'<cfelse>NULL</cfif>,
                            <cfif isdefined("attributes.employee_id_#i#") and len(evaluate("attributes.employee_id_#i#"))>#evaluate("attributes.employee_id_#i#")#<cfelse>NULL</cfif>,
                            <cfif isdefined('form_serial_no') and len(form_serial_no)>'#form_serial_no#'<cfelse>NULL</cfif>,
                            #session.pp.userid#,
                            '#cgi.remote_addr#',
                            #now()#
                       )
                </cfquery>
            </cfif>
        </cfloop>
    </cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=objects2.upd_service&service_id=#attributes.service_id#</cfoutput>';
</script>
