<cfquery name="get_alternatives" datasource="#dsn3#">
    SELECT 
        ALTERNATIVE_PRODUCT_ID 
    FROM 
        ALTERNATIVE_PRODUCTS 
    WHERE
        PRODUCT_ID = #attributes.pid#
</cfquery>
<cfset alternativeList = valueList(get_alternatives.ALTERNATIVE_PRODUCT_ID)>
<cfset alternativeList = listPrepend(alternativeList,attributes.pid)>
    <cfquery name="delete_alternative" datasource="#dsn3#">
        DELETE FROM
            ALTERNATIVE_PRODUCTS
        WHERE 
            <cfif isdefined('attributes.pid') and len(attributes.pid)>
                PRODUCT_ID IN (#alternativeList#) OR ALTERNATIVE_PRODUCT_ID IN (#alternativeList#)
            </cfif>
            <cfif attributes.x_is_product_tree eq 1>
                <cfif isdefined('attributes.TREE_STOCK_ID') and len(attributes.TREE_STOCK_ID)>
                    AND TREE_STOCK_ID = #attributes.TREE_STOCK_ID#
                </cfif>
                <cfif isdefined('attributes.question_id') and len(attributes.question_id) and attributes.question_id neq 0>
                    AND QUESTION_ID = #attributes.question_id#
                </cfif>        
            </cfif>
            <cfif isdefined('attributes.product_tree_id') and len(attributes.product_tree_id)>
                AND PRODUCT_TREE_ID = #attributes.product_tree_id#
            </cfif>
    </cfquery>

<cfset product_id_list = ''>
<cfloop index="idx" from="1" to="#attributes.record_num#">
	<cfif Evaluate('attributes.row_kontrol#idx#')>
        <cfif isdefined('attributes.start_date#idx#') and len(Evaluate('attributes.start_date#idx#'))>
            <cf_date tarih='attributes.start_date#idx#'>
        </cfif>
        <cfif isdefined('attributes.finish_date#idx#') and len(Evaluate('attributes.finish_date#idx#'))>
            <cf_date tarih='attributes.finish_date#idx#'>
        </cfif>
		<cfquery name="add_anative" datasource="#dsn3#">
			INSERT INTO ALTERNATIVE_PRODUCTS
				(
					PRODUCT_ID,
					STOCK_ID,
					ALTERNATIVE_PRODUCT_ID,
					ALTERNATIVE_PRODUCT_NO,
					TREE_STOCK_ID,
                    PRODUCT_TREE_ID,
					USAGE_RATE,
					COMPANY_ID,
					ALTERNATIVE_PRODUCT_AMOUNT,
					START_DATE,
					FINISH_DATE,
					USEAGE_PRODUCT_AMOUNT,
					QUESTION_ID,
					SPECT_MAIN_ID,
					ALTERNATIVE_FIRE_AMOUNT,
					ALTERNATIVE_FIRE_RATE,
                    IS_PHANTOM,
					RECORD_DATE,
					RECORD_EMP
				)
		    VALUES
				(
					#attributes.pid#,
					<cfif isdefined('attributes.stock_id#idx#') and len(Evaluate('attributes.stock_id#idx#'))>#Evaluate('attributes.stock_id#idx#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.product_id#idx#') and len(Evaluate('attributes.product_id#idx#'))>#Evaluate('attributes.product_id#idx#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.alternative_product_no#idx#') and len(Evaluate('attributes.alternative_product_no#idx#'))>#Evaluate('attributes.alternative_product_no#idx#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.tree_stock_id#idx#') and len(Evaluate('attributes.tree_stock_id#idx#'))>#Evaluate('attributes.tree_stock_id#idx#')#<cfelseif isdefined('attributes.tree_stock_id') and len(Evaluate('attributes.tree_stock_id'))>#attributes.tree_stock_id#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.product_tree_id#idx#') and len(Evaluate('attributes.product_tree_id#idx#'))>#Evaluate('attributes.product_tree_id#idx#')#<cfelseif isdefined('attributes.product_tree_id') and len(Evaluate('attributes.product_tree_id'))>#attributes.product_tree_id#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.usage_rate#idx#') and len(Evaluate('attributes.usage_rate#idx#'))>#Evaluate('attributes.usage_rate#idx#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.COMPANY_ID#idx#') and len(Evaluate('attributes.COMPANY_ID#idx#'))>#Evaluate('attributes.COMPANY_ID#idx#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.alternative_product_amount#idx#') and len(Evaluate('attributes.alternative_product_amount#idx#'))>#Evaluate('attributes.alternative_product_amount#idx#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.start_date#idx#') and len(Evaluate('attributes.start_date#idx#'))>#Evaluate('attributes.start_date#idx#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.finish_date#idx#') and len(Evaluate('attributes.finish_date#idx#'))>#Evaluate('attributes.finish_date#idx#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.useage_product_amount#idx#') and len(Evaluate('attributes.useage_product_amount#idx#'))>#Evaluate('attributes.useage_product_amount#idx#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.question_id') and len(Evaluate('attributes.question_id'))>#attributes.question_id#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.spect_main_id#idx#') and len(Evaluate('attributes.spect_main_id#idx#'))>#Evaluate('attributes.spect_main_id#idx#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.alternative_fire_amount#idx#') and len(Evaluate('attributes.alternative_fire_amount#idx#'))>#Evaluate('attributes.alternative_fire_amount#idx#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.alternative_fire_rate#idx#') and len(Evaluate('attributes.alternative_fire_rate#idx#'))>#Evaluate('attributes.alternative_fire_rate#idx#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.is_phantom#idx#') and len(Evaluate('attributes.is_phantom#idx#'))>#Evaluate('attributes.is_phantom#idx#')#<cfelse>NULL</cfif>,
					#NOW()#,
					#session.ep.userid#
				)
        </cfquery>
    </cfif>
</cfloop>
<cfquery name="get_alternatives" datasource="#dsn3#">
    SELECT 
        ALTERNATIVE_PRODUCT_ID 
    FROM 
        ALTERNATIVE_PRODUCTS 
    WHERE
        PRODUCT_ID = #attributes.pid#
</cfquery>
<cfloop query="get_alternatives">
    <cfquery name="add_alternatives" datasource="#dsn3#">
        INSERT INTO ALTERNATIVE_PRODUCTS
    (
        PRODUCT_ID,
        STOCK_ID,
        ALTERNATIVE_PRODUCT_ID,
        ALTERNATIVE_PRODUCT_NO,
        TREE_STOCK_ID,
        PRODUCT_TREE_ID,
        USAGE_RATE,
        COMPANY_ID,
        ALTERNATIVE_PRODUCT_AMOUNT,
        START_DATE,
        FINISH_DATE,
        USEAGE_PRODUCT_AMOUNT,
        QUESTION_ID,
        SPECT_MAIN_ID,
        ALTERNATIVE_FIRE_AMOUNT,
        ALTERNATIVE_FIRE_RATE,
        IS_PHANTOM,
        RECORD_DATE,
        RECORD_EMP
    )
VALUES
    (
        #ALTERNATIVE_PRODUCT_ID#,
        #attributes.pid#,
        #attributes.pid#,
        <cfif isdefined('attributes.alternative_product_no#idx#') and len(Evaluate('attributes.alternative_product_no#idx#'))>#Evaluate('attributes.alternative_product_no#idx#')#<cfelse>NULL</cfif>,
        <cfif isdefined('attributes.tree_stock_id#idx#') and len(Evaluate('attributes.tree_stock_id#idx#'))>#Evaluate('attributes.tree_stock_id#idx#')#<cfelseif isdefined('attributes.tree_stock_id') and len(Evaluate('attributes.tree_stock_id'))>#attributes.tree_stock_id#<cfelse>NULL</cfif>,
        <cfif isdefined('attributes.product_tree_id#idx#') and len(Evaluate('attributes.product_tree_id#idx#'))>#Evaluate('attributes.product_tree_id#idx#')#<cfelseif isdefined('attributes.product_tree_id') and len(Evaluate('attributes.product_tree_id'))>#attributes.product_tree_id#<cfelse>NULL</cfif>,
        <cfif isdefined('attributes.usage_rate#idx#') and len(Evaluate('attributes.usage_rate#idx#'))>#Evaluate('attributes.usage_rate#idx#')#<cfelse>NULL</cfif>,
        <cfif isdefined('attributes.COMPANY_ID#idx#') and len(Evaluate('attributes.COMPANY_ID#idx#'))>#Evaluate('attributes.COMPANY_ID#idx#')#<cfelse>NULL</cfif>,
        <cfif isdefined('attributes.alternative_product_amount#idx#') and len(Evaluate('attributes.alternative_product_amount#idx#'))>#Evaluate('attributes.alternative_product_amount#idx#')#<cfelse>NULL</cfif>,
        <cfif isdefined('attributes.start_date#idx#') and len(Evaluate('attributes.start_date#idx#'))>#Evaluate('attributes.start_date#idx#')#<cfelse>NULL</cfif>,
        <cfif isdefined('attributes.finish_date#idx#') and len(Evaluate('attributes.finish_date#idx#'))>#Evaluate('attributes.finish_date#idx#')#<cfelse>NULL</cfif>,
        <cfif isdefined('attributes.useage_product_amount#idx#') and len(Evaluate('attributes.useage_product_amount#idx#'))>#Evaluate('attributes.useage_product_amount#idx#')#<cfelse>NULL</cfif>,
        <cfif isdefined('attributes.question_id') and len(Evaluate('attributes.question_id'))>#attributes.question_id#<cfelse>NULL</cfif>,
        <cfif isdefined('attributes.spect_main_id#idx#') and len(Evaluate('attributes.spect_main_id#idx#'))>#Evaluate('attributes.spect_main_id#idx#')#<cfelse>NULL</cfif>,
        <cfif isdefined('attributes.alternative_fire_amount#idx#') and len(Evaluate('attributes.alternative_fire_amount#idx#'))>#Evaluate('attributes.alternative_fire_amount#idx#')#<cfelse>NULL</cfif>,
        <cfif isdefined('attributes.alternative_fire_rate#idx#') and len(Evaluate('attributes.alternative_fire_rate#idx#'))>#Evaluate('attributes.alternative_fire_rate#idx#')#<cfelse>NULL</cfif>,
        <cfif isdefined('attributes.is_phantom#idx#') and len(Evaluate('attributes.is_phantom#idx#'))>#Evaluate('attributes.is_phantom#idx#')#<cfelse>NULL</cfif>,
        #NOW()#,
        #session.ep.userid#
    )
    <cfif get_alternatives.recordCount gt 1>
        <cfloop from="1" to="#get_alternatives.recordCount#" index="idx">
            <cfif get_alternatives.ALTERNATIVE_PRODUCT_ID[idx] neq ALTERNATIVE_PRODUCT_ID>
            ,(
        #ALTERNATIVE_PRODUCT_ID#,
        #get_alternatives.ALTERNATIVE_PRODUCT_ID[idx]#,
        #get_alternatives.ALTERNATIVE_PRODUCT_ID[idx]#,
        <cfif isdefined('attributes.alternative_product_no#idx#') and len(Evaluate('attributes.alternative_product_no#idx#'))>#Evaluate('attributes.alternative_product_no#idx#')#<cfelse>NULL</cfif>,
        <cfif isdefined('attributes.tree_stock_id#idx#') and len(Evaluate('attributes.tree_stock_id#idx#'))>#Evaluate('attributes.tree_stock_id#idx#')#<cfelseif isdefined('attributes.tree_stock_id') and len(Evaluate('attributes.tree_stock_id'))>#attributes.tree_stock_id#<cfelse>NULL</cfif>,
        <cfif isdefined('attributes.product_tree_id#idx#') and len(Evaluate('attributes.product_tree_id#idx#'))>#Evaluate('attributes.product_tree_id#idx#')#<cfelseif isdefined('attributes.product_tree_id') and len(Evaluate('attributes.product_tree_id'))>#attributes.product_tree_id#<cfelse>NULL</cfif>,
        <cfif isdefined('attributes.usage_rate#idx#') and len(Evaluate('attributes.usage_rate#idx#'))>#Evaluate('attributes.usage_rate#idx#')#<cfelse>NULL</cfif>,
        <cfif isdefined('attributes.COMPANY_ID#idx#') and len(Evaluate('attributes.COMPANY_ID#idx#'))>#Evaluate('attributes.COMPANY_ID#idx#')#<cfelse>NULL</cfif>,
        <cfif isdefined('attributes.alternative_product_amount#idx#') and len(Evaluate('attributes.alternative_product_amount#idx#'))>#Evaluate('attributes.alternative_product_amount#idx#')#<cfelse>NULL</cfif>,
        <cfif isdefined('attributes.start_date#idx#') and len(Evaluate('attributes.start_date#idx#'))>#Evaluate('attributes.start_date#idx#')#<cfelse>NULL</cfif>,
        <cfif isdefined('attributes.finish_date#idx#') and len(Evaluate('attributes.finish_date#idx#'))>#Evaluate('attributes.finish_date#idx#')#<cfelse>NULL</cfif>,
        <cfif isdefined('attributes.useage_product_amount#idx#') and len(Evaluate('attributes.useage_product_amount#idx#'))>#Evaluate('attributes.useage_product_amount#idx#')#<cfelse>NULL</cfif>,
        <cfif isdefined('attributes.question_id') and len(Evaluate('attributes.question_id'))>#attributes.question_id#<cfelse>NULL</cfif>,
        <cfif isdefined('attributes.spect_main_id#idx#') and len(Evaluate('attributes.spect_main_id#idx#'))>#Evaluate('attributes.spect_main_id#idx#')#<cfelse>NULL</cfif>,
        <cfif isdefined('attributes.alternative_fire_amount#idx#') and len(Evaluate('attributes.alternative_fire_amount#idx#'))>#Evaluate('attributes.alternative_fire_amount#idx#')#<cfelse>NULL</cfif>,
        <cfif isdefined('attributes.alternative_fire_rate#idx#') and len(Evaluate('attributes.alternative_fire_rate#idx#'))>#Evaluate('attributes.alternative_fire_rate#idx#')#<cfelse>NULL</cfif>,
        <cfif isdefined('attributes.is_phantom#idx#') and len(Evaluate('attributes.is_phantom#idx#'))>#Evaluate('attributes.is_phantom#idx#')#<cfelse>NULL</cfif>,
        #NOW()#,
        #session.ep.userid#
    )
    </cfif>
        </cfloop>
    </cfif>
    </cfquery>
</cfloop>
<script type="text/javascript">
	<cfif isdefined('attributes.call_function')>
		if(typeof(opener.<cfoutput>#attributes.call_function#</cfoutput>) == 'object')
			opener.<cfoutput>#attributes.call_function#()</cfoutput>;
	</cfif>
	window.close();
</script>
