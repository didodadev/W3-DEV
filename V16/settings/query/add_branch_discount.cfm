<cfif len(attributes.record_num) and attributes.record_num neq "">
    <cfloop from="1" to="#attributes.record_num#" index="i">
     <cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#") eq 1>
        <cfif len(evaluate("attributes.branch_discount_id#i#"))>
            <cfquery name="UPD_BRANCH_DISCOUNT" datasource="#dsn3#">
                UPDATE
                    SETUP_BRANCH_DISCOUNT
                SET
                    BRANCH_ID = #evaluate("attributes.branch_id#i#")#,
                    PAYMETHOD_ID = <cfif len(evaluate("attributes.payment_type_id#i#")) and len(evaluate("attributes.payment_type#i#"))>#evaluate("attributes.payment_type_id#i#")#<cfelse>NULL</cfif>,
                    CARD_PAYMETHOD_ID = <cfif len(evaluate("attributes.card_paymethod_id#i#")) and len(evaluate("attributes.payment_type#i#"))>#evaluate("attributes.card_paymethod_id#i#")#<cfelse>NULL</cfif>,
                    BRAND_ID = <cfif len(evaluate("attributes.brand_id#i#")) and len(evaluate("attributes.brand_name#i#"))>#evaluate("attributes.brand_id#i#")#<cfelse>NULL</cfif>,
                    PRODUCT_CAT_ID = <cfif len(evaluate("attributes.cat_id#i#")) and len(evaluate("attributes.category_name#i#"))>#evaluate("attributes.cat_id#i#")#<cfelse>NULL</cfif>,
                    DISCOUNT = <cfif len(evaluate("attributes.discount#i#"))>#evaluate("attributes.discount#i#")#<cfelse>NULL</cfif>,
                    UPDATE_DATE = #now()#,
                    UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
                    UPDATE_EMP = #session.ep.userid#
               WHERE
                    ID = #evaluate("attributes.branch_discount_id#i#")#
            </cfquery>
        <cfelse>
            <cfquery name="ADD_BRANCH_DISCOUNT" datasource="#dsn3#">
                INSERT INTO 
                    SETUP_BRANCH_DISCOUNT 
                    (
                       BRANCH_ID,
                       PAYMETHOD_ID,
                       CARD_PAYMETHOD_ID,
                       BRAND_ID,
                       PRODUCT_CAT_ID,
                       DISCOUNT,
                       RECORD_DATE,
                       RECORD_EMP,
                       RECORD_IP
                    )
                    VALUES     
                    (
                       #evaluate("attributes.branch_id#i#")#,
                       <cfif len(evaluate("attributes.payment_type_id#i#")) and len(evaluate("attributes.payment_type#i#"))>#evaluate("attributes.payment_type_id#i#")#<cfelse>NULL</cfif>,
                       <cfif len(evaluate("attributes.card_paymethod_id#i#")) and len(evaluate("attributes.payment_type#i#"))>#evaluate("attributes.card_paymethod_id#i#")#<cfelse>NULL</cfif>,
                       <cfif len(evaluate("attributes.brand_id#i#")) and len(evaluate("attributes.brand_name#i#"))>#evaluate("attributes.brand_id#i#")#<cfelse>NULL</cfif>,
                       <cfif len(evaluate("attributes.cat_id#i#")) and len(evaluate("attributes.category_name#i#"))>#evaluate("attributes.cat_id#i#")#<cfelse>NULL</cfif>,
                       <cfif len(evaluate("attributes.discount#i#"))>#evaluate("attributes.discount#i#")#<cfelse>NULL</cfif>,
                       #now()#,
                       #session.ep.userid#,
                       <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">
                    )
            </cfquery>
        </cfif>
     <cfelseif len(evaluate("attributes.branch_discount_id#i#"))>
     	<cfquery name="del_branch_discount" datasource="#dsn3#">
        	DELETE FROM SETUP_BRANCH_DISCOUNT WHERE ID = #evaluate("attributes.branch_discount_id#i#")#
        </cfquery>
     </cfif>
    </cfloop>
</cfif>
<cflocation url="#request.self#?fuseaction=settings.form_add_branch_discount" addtoken="No">
