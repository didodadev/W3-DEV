<cfquery name="delete_alternative" datasource="#dsn3#">
	DELETE FROM
		ALTERNATIVE_PRODUCTS
	WHERE 
		<cfif isdefined('attributes.pid') and len(attributes.pid)>
	        PRODUCT_ID = #attributes.pid#
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
					PROPERTY_ID,
					RECORD_DATE,
					RECORD_EMP
				)
		  VALUES
				(
					#attributes.pid#,
					<cfif isdefined('attributes.stock_id#idx#') and len(Evaluate('attributes.stock_id#idx#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('attributes.stock_id#idx#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.product_id#idx#') and len(Evaluate('attributes.product_id#idx#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('attributes.product_id#idx#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.alternative_product_no#idx#') and len(Evaluate('attributes.alternative_product_no#idx#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('attributes.alternative_product_no#idx#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.tree_stock_id#idx#') and len(Evaluate('attributes.tree_stock_id#idx#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('attributes.tree_stock_id#idx#')#"><cfelseif isdefined('attributes.tree_stock_id') and len(Evaluate('attributes.tree_stock_id'))><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.tree_stock_id#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.product_tree_id#idx#') and len(Evaluate('attributes.product_tree_id#idx#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('attributes.product_tree_id#idx#')#"><cfelseif isdefined('attributes.product_tree_id') and len(Evaluate('attributes.product_tree_id'))><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_tree_id#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.usage_rate#idx#') and len(Evaluate('attributes.usage_rate#idx#'))><cfqueryparam cfsqltype="cf_sql_float" value="#Evaluate('attributes.usage_rate#idx#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.COMPANY_ID#idx#') and len(Evaluate('attributes.COMPANY_ID#idx#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('attributes.COMPANY_id#idx#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.alternative_product_amount#idx#') and len(Evaluate('attributes.alternative_product_amount#idx#'))><cfqueryparam cfsqltype="cf_sql_float" value="#Evaluate('attributes.alternative_product_amount#idx#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.start_date#idx#') and len(Evaluate('attributes.start_date#idx#'))><cfqueryparam cfsqltype="cf_sql_timestamp" value="#Evaluate('attributes.start_date#idx#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.finish_date#idx#') and len(Evaluate('attributes.finish_date#idx#'))><cfqueryparam cfsqltype="cf_sql_timestamp" value="#Evaluate('attributes.finish_date#idx#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.useage_product_amount#idx#') and len(Evaluate('attributes.useage_product_amount#idx#'))><cfqueryparam cfsqltype="cf_sql_float" value="#Evaluate('attributes.useage_product_amount#idx#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.question_id') and len(Evaluate('attributes.question_id'))><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.question_id#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.spect_main_id#idx#') and len(Evaluate('attributes.spect_main_id#idx#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('attributes.spect_main_id#idx#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.alternative_fire_amount#idx#') and len(Evaluate('attributes.alternative_fire_amount#idx#'))><cfqueryparam cfsqltype="cf_sql_float" value="#Evaluate('attributes.alternative_fire_amount#idx#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.alternative_fire_rate#idx#') and len(Evaluate('attributes.alternative_fire_rate#idx#'))><cfqueryparam cfsqltype="cf_sql_float" value="#Evaluate('attributes.alternative_fire_rate#idx#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.is_phantom#idx#') and len(Evaluate('attributes.is_phantom#idx#'))><cfqueryparam cfsqltype="cf_sql_bit" value="#Evaluate('attributes.is_phantom#idx#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.property_id#idx#') and len(Evaluate('attributes.property_id#idx#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('attributes.property_id#idx#')#"><cfelse>NULL</cfif>,
					#NOW()#,
					#session.ep.userid#
				)
		</cfquery>
    </cfif>
</cfloop>
<script type="text/javascript">
	<cfif not isdefined("attributes.modal_id") and not len(attributes.modal_id)>
		<cfif isdefined('attributes.call_function')>
			if(typeof(opener.<cfoutput>#attributes.call_function#</cfoutput>) == 'object')
				opener.<cfoutput>#attributes.call_function#()</cfoutput>;
		</cfif>
		
		window.close();
	<cfelse>
		<cfif isdefined('attributes.call_function')>
			if(typeof(<cfif not isdefined("attributes.modal_id") and not len(attributes.modal_id)>opener.</cfif><cfoutput>#attributes.call_function#</cfoutput>) == 'object')
				<cfif not isdefined("attributes.modal_id") and not  len(attributes.modal_id)>opener.</cfif><cfoutput>#attributes.call_function#()</cfoutput>;
		</cfif>
		
		closeBoxDraggable(<cfoutput>#attributes.modal_id#</cfoutput>);
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
	</cfif>


</script>
