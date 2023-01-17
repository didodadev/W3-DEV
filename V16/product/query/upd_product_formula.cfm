<cflock timeout="60">
	<cftransaction>
		<cfquery name="upd_formula" datasource="#dsn3#">
			UPDATE
				SETUP_PRODUCT_FORMULA
			SET
				IS_ACTIVE = <cfif isdefined("attributes.is_active")>1,<cfelse>0,</cfif>
				FORMULA_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.formula_name#">,
                FORMULA_STOCK_ID = <cfif len(attributes.product_name) and len(attributes.stock_id)>#attributes.stock_id#<cfelse>NULL</cfif>,
				UPDATE_EMP = #session.ep.userid#, 
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#REMOTE_ADDR#">,
				UPDATE_DATE = #now()#
			WHERE
				PRODUCT_FORMULA_ID = #attributes.id#
		</cfquery>
        <cfquery name="del_component" datasource="#dsn3#">
        	DELETE FROM SETUP_PRODUCT_FORMULA_COMPONENTS WHERE PRODUCT_FORMULA_ID = #attributes.id#
        </cfquery>
        <cfquery name="del_component" datasource="#dsn3#">
        	DELETE FROM SETUP_PRODUCT_FORMULA_VARIATION WHERE PRODUCT_FORMULA_ID = #attributes.id#
        </cfquery>
        <cfquery name="del_component" datasource="#dsn3#">
        	DELETE FROM SETUP_PRODUCT_FORMULA_ROWS WHERE PRODUCT_FORMULA_ID = #attributes.id#
        </cfquery>
        <cfloop from="1" to="#attributes.record_num#" index="i">
            <cfscript>
                form_order_no = evaluate("attributes.order_no#i#");
                form_property_id = evaluate("attributes.property_id#i#");
                form_property = evaluate("attributes.property#i#");
                form_amount_type = evaluate("attributes.amount_type#i#");
				if(len(evaluate("attributes.amount#i#")))
					form_amount = filternum(evaluate("attributes.amount#i#"),4);
				else
					form_amount = '';
		    </cfscript>
            <cfif evaluate("attributes.row_control#i#")>
                <cfquery name="add_componen" datasource="#dsn3#" result="MAX_ID">
                    INSERT INTO
                        SETUP_PRODUCT_FORMULA_COMPONENTS
                        (
                            PRODUCT_FORMULA_ID,
                            ORDER_NO,
                            PROPERTY_ID,
                            AMOUNT_TYPE,
                            AMOUNT
                        )
                    VALUES
                        (
                            #attributes.id#,
                            <cfif len(form_order_no)>#form_order_no#,<cfelse>NULL,</cfif>
                            <cfif len(form_property_id) and len(form_property)>#form_property_id#,<cfelse>NULL,</cfif>
                            <cfif len(form_amount_type)>#form_amount_type#<cfelse>NULL</cfif>,
                            <cfif len(form_amount)>#form_amount#<cfelse>NULL</cfif>
                        )
                </cfquery>
                <cfloop from="1" to="#attributes.record_num2#" index="kk">
                    <cfscript>
                        form_row_property_id = evaluate("attributes.row_property_id#kk#");
                        form_variation_id = evaluate("attributes.variation_id#kk#");
                        if(len(evaluate("attributes.variation_value#kk#")))
                            form_variation_value = filternum(evaluate("attributes.variation_value#kk#"));
                        else
                            form_variation_value = '';
                    </cfscript>
                    <cfif evaluate("attributes.row_control2_#kk#") and form_row_property_id eq form_property_id>
                        <cfquery name="add_var" datasource="#dsn3#">
                            INSERT INTO
                                SETUP_PRODUCT_FORMULA_VARIATION
                                (
                                   PRODUCT_FORMULA_ID,
                                   PRODUCT_COMPENENT_ID,
                                   VARIATION_PROPERTY_DETAIL_ID,
                                   VARIATON_PROPERTY_VALUE
                                )
                            VALUES
                                (
                                    #attributes.id#,
                                    #MAX_ID.IDENTITYCOL#,
                                    <cfif len(form_variation_id)>#form_variation_id#,<cfelse>NULL,</cfif>
                                    <cfif len(form_variation_value)>#form_variation_value#<cfelse>NULL</cfif>
                                )
                        </cfquery>
                    </cfif>
                </cfloop>
            </cfif>
        </cfloop>
        <cfloop from="1" to="#attributes.record_num_formula#" index="i">
            <cfscript>
                form_order_no = evaluate("attributes.order_no_formula#i#");
                form_property_id = evaluate("attributes.property_id_formula#i#");
                form_row_no = evaluate("attributes.row_no_formula#i#");
				if(len(evaluate("attributes.number_formula#i#")))
					form_amount = filternum(evaluate("attributes.number_formula#i#"),8);
				else
					form_amount = '';
                form_property_id2 = evaluate("attributes.property_id_formula2_#i#");
                form_row_no2 = evaluate("attributes.row_no_formula2_#i#");
				if(len(evaluate("attributes.number_formula2_#i#")))
					form_amount2 = filternum(evaluate("attributes.number_formula2_#i#"),8);
				else
					form_amount2 = '';
                form_act_type = evaluate("attributes.act_type#i#");
		    </cfscript>
            <cfif evaluate("attributes.row_control_formula#i#")>
                <cfquery name="add_componen" datasource="#dsn3#">
                    INSERT INTO
                        SETUP_PRODUCT_FORMULA_ROWS
                        (
                            PRODUCT_FORMULA_ID,
                            ORDER_NO,
                            PROPERTY_ID,
                            RELATED_ROW,
                            PRO_AMOUNT,
                            PROPERTY_ID1,
                            RELATED_ROW1,
                            PRO_AMOUNT1,
                            ACT_TYPE           
                        )
                    VALUES
                        (
                            #attributes.id#,
                            <cfif len(form_order_no)>#form_order_no#,<cfelse>NULL,</cfif>
                            <cfif len(form_property_id)>#form_property_id#,<cfelse>NULL,</cfif>
                            <cfif len(form_row_no)>#form_row_no#<cfelse>NULL</cfif>,
                            <cfif len(form_amount)>#form_amount#<cfelse>NULL</cfif>,
                            <cfif len(form_property_id2)>#form_property_id2#,<cfelse>NULL,</cfif>
                            <cfif len(form_row_no2)>#form_row_no2#<cfelse>NULL</cfif>,
                            <cfif len(form_amount2)>#form_amount2#<cfelse>NULL</cfif>,
                            <cfif len(form_act_type)>#form_act_type#<cfelse>NULL</cfif>
                        )
                </cfquery>
            </cfif>
        </cfloop>
	</cftransaction>
</cflock>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
