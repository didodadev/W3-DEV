<cflock timeout="60">
	<cftransaction>
    	<cfif isdefined("attributes.startdate") and len(attributes.startdate)><cf_date tarih="attributes.startdate"></cfif>
    	<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)><cf_date tarih="attributes.finishdate"></cfif>
            <cfif isDefined("attributes.image_file")  and len(attributes.image_file)>
				<cftry>
				   <cfset file_name = createUUID()>
				   <cffile action="UPLOAD" 
						   destination="#upload_folder#product#dir_seperator#" 
						   filefield="image_file"  
						   nameconflict="MAKEUNIQUE"> 
				   <cffile action="rename" source="#upload_folder#product#dir_seperator##cffile.serverfile#" destination="#upload_folder#product#dir_seperator##file_name#.#cffile.serverfileext#">
				   <cfcatch type="any">
					   <script type="text/javascript">
						   alert("Lütfen imaj dosyası giriniz!");
						   history.back();
					   </script>
					   <cfabort>
				   </cfcatch>
			   </cftry>
			   <cfset assetTypeName = listlast(cffile.serverfile,'.')>
			   <cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
			   <cfif listfind(blackList,assetTypeName,',')>
				   <cffile action="delete" file="#upload_folder#product#dir_seperator##file_name#.#cffile.serverfileext#">
				   <script type="text/javascript">
					   alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
					   history.back();
				   </script>
				   <cfabort>
			   </cfif>
		   </cfif>
		<cfquery name="upd_configrator" datasource="#dsn3#">
			UPDATE
				SETUP_PRODUCT_CONFIGURATOR
			SET
				IS_ACTIVE = <cfif isdefined("attributes.is_active")>1,<cfelse>0,</cfif>
				CONFIGURATOR_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.configuration_name#">,
				CONFIGURATOR_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.configuration_detail#">,
                CONFIGURATOR_STOCK_ID = <cfif IsDefined("attributes.stock_id") and len(attributes.stock_id) and IsDefined("attributes.product_name") and len(attributes.product_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#"><cfelse>NULL</cfif>,
                BRAND_ID = <cfif IsDefined("attributes.brand_id") and len(attributes.brand_id) and IsDefined("attributes.brand_name") and len(attributes.brand_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#"><cfelse>NULL</cfif>,
                PRODUCT_CAT_ID = <cfif IsDefined("attributes.cat_id") and len(attributes.cat_id) and IsDefined("attributes.category_name") and len(attributes.category_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cat_id#"><cfelse>NULL</cfif>,
                <cfif isDefined("attributes.image_file")  and len(attributes.image_file)>PATH = <cfqueryparam value = "#file_name#.#cffile.serverfileext#" CFSQLType = "cf_sql_varchar">, </cfif>
                ORIGIN = <cfif isDefined("attributes.origin") and len(attributes.origin)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.origin#"><cfelse>NULL</cfif>,
                WIDGET_ID = <cfif IsDefined("attributes.widget_id") and len(attributes.widget_id) and IsDefined("attributes.widget_friendly_name") and len(attributes.widget_friendly_name)><cfqueryparam value = "#attributes.widget_id#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
                START_DATE = <cfif IsDefined("attributes.startdate") and len(attributes.startdate)>#attributes.startdate#<cfelse>NULL</cfif>,
                FINISH_DATE = <cfif IsDefined("attributes.finishdate") and len(attributes.finishdate)>#attributes.finishdate#<cfelse>NULL</cfif>,
				UPDATE_EMP = #session.ep.userid#, 
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#REMOTE_ADDR#">,
				UPDATE_DATE = #now()#,
                USE_FORM = <cfif IsDefined("attributes.use_form") and len(attributes.use_form)><cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.use_form#" ><cfelse>NULL</cfif>,
                USE_CAT_IDS = <cfif IsDefined("attributes.use_cat_ids") and len(attributes.use_cat_ids)><cfqueryparam CFSQLType = "cf_sql_nvarchar" value = "#attributes.use_cat_ids#" ><cfelse>NULL</cfif>,
                USE_QUALITY_IDS = <cfif IsDefined("attributes.use_quality_ids") and len(attributes.use_quality_ids)><cfqueryparam CFSQLType = "cf_sql_varchar" value = "#attributes.use_quality_ids#" ><cfelse>NULL</cfif>,
                TREE_TYPES = <cfif IsDefined("attributes.tree_types") and len(attributes.tree_types)><cfqueryparam CFSQLType = "cf_sql_varchar" value = "#attributes.tree_types#" ><cfelse>NULL</cfif>,
                USE_PRODUCT_IDS = <cfif IsDefined("attributes.use_product_ids") and len(attributes.use_product_ids)><cfqueryparam CFSQLType = "cf_sql_varchar" value = "#attributes.use_product_ids#" ><cfelse>NULL</cfif>,
                USE_OPERATION_IDS = <cfif IsDefined("attributes.use_operation_ids") and len(attributes.use_operation_ids)><cfqueryparam CFSQLType = "cf_sql_varchar" value = "#attributes.use_operation_ids#" ><cfelse>NULL</cfif>,
                USE_COMPONENT = <cfif IsDefined("attributes.use_component") and len(attributes.use_component)><cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.use_component#" ><cfelse>NULL</cfif>,
                USE_WIDTH = <cfif IsDefined("attributes.use_width") and len(attributes.use_width)><cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.use_width#" ><cfelse>NULL</cfif>,
                USE_SIZE = <cfif IsDefined("attributes.use_size") and len(attributes.use_size)><cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.use_size#" ><cfelse>NULL</cfif>,
                USE_HEIGHT = <cfif IsDefined("attributes.use_height") and len(attributes.use_height)><cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.use_height#" ><cfelse>NULL</cfif>,
                USE_THICKNESS = <cfif IsDefined("attributes.use_thickness") and len(attributes.use_thickness)><cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.use_thickness#" ><cfelse>NULL</cfif>,
                USE_FIRE = <cfif IsDefined("attributes.use_fire") and len(attributes.use_fire)><cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.use_fire#" ><cfelse>NULL</cfif>,
                USE_FEATURE = <cfif IsDefined("attributes.use_feature") and len(attributes.use_feature)><cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.use_feature#" ><cfelse>NULL</cfif>,
                USE_TEST_PARAMETER = <cfif IsDefined("attributes.use_test_parameter") and len(attributes.use_test_parameter)><cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.use_test_parameter#" ><cfelse>NULL</cfif>
            WHERE
				PRODUCT_CONFIGURATOR_ID = #attributes.id#
		</cfquery>
        <cfquery name="del_component" datasource="#dsn3#">
        	DELETE FROM SETUP_PRODUCT_CONFIGURATOR_COMPONENTS WHERE PRODUCT_CONFIGURATOR_ID = #attributes.id#
        </cfquery>
        <cfquery name="del_component" datasource="#dsn3#">
        	DELETE FROM SETUP_PRODUCT_CONFIGURATOR_VARIATION WHERE PRODUCT_CONFIGURATOR_ID = #attributes.id#
        </cfquery>
        <cfquery name="del_component" datasource="#dsn3#">
        	DELETE FROM SETUP_PRODUCT_FORMULA_ROWS WHERE PRODUCT_CONFIGURATOR_ID = #attributes.id#
        </cfquery>
        <cfquery name="del_component" datasource="#dsn3#">
        	DELETE FROM SETUP_PRODUCT_CONFIGURATOR_PARAMETER WHERE PRODUCT_CONFIGURATOR_ID = #attributes.id#
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
                form_req_type = evaluate("attributes.req_type#i#");
                form_price_type = evaluate("attributes.price_type#i#");
				if(isdefined("attributes.property_row#i#"))
				{
					form_property_id_row = evaluate("attributes.property_id_row#i#");
					form_property_row = evaluate("attributes.property_row#i#");
           		}
				else
				{
					form_property_id_row = '';
					form_property_row = '';
				}
				if(isdefined("attributes.formula_id#i#"))
					form_formula_id = evaluate("attributes.formula_id#i#");
				else
					form_formula_id = '';
		    </cfscript>
            <cfif evaluate("attributes.row_control#i#")>
                <cfquery name="add_componen" datasource="#dsn3#" result="MAX_ID">
                    INSERT INTO
                        SETUP_PRODUCT_CONFIGURATOR_COMPONENTS
                        (
                            PRODUCT_CONFIGURATOR_ID,
                            ORDER_NO,
                            PROPERTY_ID,
                            PROPERTY_ID_ROW,
                            AMOUNT_TYPE,
                            AMOUNT,
                            REQUIRE_TYPE,
                            PRICE_TYPE,
                            FORMULA_ID
                        )
                    VALUES
                        (
                            #attributes.id#,
                            <cfif len(form_order_no)>#form_order_no#,<cfelse>NULL,</cfif>
                            <cfif len(form_property_id) and len(form_property)>#form_property_id#,<cfelse>NULL,</cfif>
                            <cfif len(form_property_id_row) and len(form_property_row)>#form_property_id_row#,<cfelse>NULL,</cfif>
                            <cfif len(form_amount_type)>#form_amount_type#<cfelse>NULL</cfif>,
                            <cfif len(form_amount)>#form_amount#<cfelse>NULL</cfif>,
                            <cfif len(form_req_type)>#form_req_type#<cfelse>NULL</cfif>,
                            <cfif len(form_price_type)>#form_price_type#<cfelse>NULL</cfif>,
                            <cfif len(form_formula_id)>#form_formula_id#<cfelse>NULL</cfif>
                        )
                </cfquery>
                <cfloop from="1" to="#attributes.record_num2#" index="kk">
                    <cfscript>
                        form_row_property_id = evaluate("attributes.row_property_id#kk#");
                        form_variation_id = evaluate("attributes.variation_id#kk#");
                        if(len(evaluate("attributes.variation_value#kk#")))
                            form_variation_value = filternum(evaluate("attributes.variation_value#kk#"),4);
                        else
                            form_variation_value = '';
                    </cfscript>
                    <cfif evaluate("attributes.row_control2_#kk#") and form_row_property_id eq form_property_id>
                        <cfquery name="add_var" datasource="#dsn3#">
                            INSERT INTO
                                SETUP_PRODUCT_CONFIGURATOR_VARIATION
                                (
                                   PRODUCT_CONFIGURATOR_ID,
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
                form_property_id2 = evaluate("attributes.property_id_formula2_#i#");
                form_row_no2 = evaluate("attributes.row_no_formula2_#i#");
                form_act_type = evaluate("attributes.act_type#i#");
		    </cfscript>
            <cfif evaluate("attributes.row_control_formula#i#")>
                <cfquery name="add_componen" datasource="#dsn3#">
                    INSERT INTO
                        SETUP_PRODUCT_FORMULA_ROWS
                        (
                            PRODUCT_CONFIGURATOR_ID,
                            ORDER_NO,
                            PROPERTY_ID,
                            RELATED_ROW,
                            PROPERTY_ID1,
                            RELATED_ROW1,
                            ACT_TYPE           
                        )
                    VALUES
                        (
                            #attributes.id#,
                            <cfif len(form_order_no)>#form_order_no#,<cfelse>NULL,</cfif>
                            <cfif len(form_property_id)>#form_property_id#,<cfelse>NULL,</cfif>
                            <cfif len(form_row_no)>#form_row_no#<cfelse>NULL</cfif>,
                            <cfif len(form_property_id2)>#form_property_id2#,<cfelse>NULL,</cfif>
                            <cfif len(form_row_no2)>#form_row_no2#<cfelse>NULL</cfif>,
                            <cfif len(form_act_type)>#form_act_type#<cfelse>NULL</cfif>
                        )
                </cfquery>
            </cfif>
        </cfloop>
        <cfif IsDefined("attributes.testParameterCount") and attributes.testParameterCount gt 0>
            <cfloop from="1" to="#attributes.testParameterCount#" index="i">
                <cfif isDefined("attributes.type_id#i#") and len(evaluate("attributes.type_id#i#"))>
                    <cfquery name="add_test_parameter" datasource="#dsn3#">
                        INSERT INTO SETUP_PRODUCT_CONFIGURATOR_PARAMETER
                        (
                            PRODUCT_CONFIGURATOR_ID,
                            TYPE_ID,
                            TYPE_DESCRIPTION,
                            STANDART_VALUE,
                            QUALITY_MEASURE,
                            TOLERANCE
                        )
                        VALUES
                        (
                            <cfqueryparam cfsqltype = "cf_sql_integer" value = "#attributes.id#">,
                            <cfif isdefined("attributes.type_id#i#") and len(evaluate("attributes.type_id#i#")) and isdefined("attributes.quality_control_type#i#") and len(evaluate("attributes.quality_control_type#i#"))><cfqueryparam cfsqltype = "cf_sql_integer" value = "#evaluate("attributes.type_id#i#")#"><cfelse>NULL</cfif>,
                            <cfif isdefined("attributes.type_description#i#") and len(evaluate("attributes.type_description#i#"))><cfqueryparam cfsqltype = "cf_sql_nvarchar" value = "#evaluate("attributes.type_description#i#")#"><cfelse>NULL</cfif>,
                            <cfif isdefined("attributes.standart_value#i#") and len(evaluate("attributes.standart_value#i#"))><cfqueryparam cfsqltype = "cf_sql_float" value = "#evaluate("attributes.standart_value#i#")#"><cfelse>NULL</cfif>,
                            <cfif isdefined("attributes.quality_measure#i#") and len(evaluate("attributes.quality_measure#i#"))><cfqueryparam cfsqltype = "cf_sql_float" value = "#evaluate("attributes.quality_measure#i#")#"><cfelse>NULL</cfif>,
                            <cfif isdefined("attributes.tolerance#i#") and len(evaluate("attributes.tolerance#i#"))><cfqueryparam cfsqltype = "cf_sql_float" value = "#evaluate("attributes.tolerance#i#")#"><cfelse>NULL</cfif>
                        )
                    </cfquery>
                </cfif>
            </cfloop>
        </cfif>
	</cftransaction>
</cflock>
<cfset attributes.actionid = attributes.id />