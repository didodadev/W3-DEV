
<cfif len(attributes.add_stock_id) and len(attributes.product_name)>
    <cfquery name="check_sub" datasource="#dsn3#">
        SELECT
            PRODUCT_ID
        FROM
            PRODUCT_TREE
        WHERE
            RELATED_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.MAIN_STOCK_ID#">
        AND
            STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.add_stock_id#">
    </cfquery>
    <cfif check_sub.recordcount or (attributes.PRODUCT_ID eq attributes.MAIN_PRODUCT_ID)>
        <script type="text/javascript">
            alert("<cf_get_lang no ='627.Bu ürünü eklerseniz Ürün Ağacınızda Hirerarşi sorunu oluşur'>!");
            history.back();
        </script>
        <cfabort>
    </cfif>
</cfif>
<cfif attributes.MAIN_STOCK_ID neq attributes.add_stock_id>
	<cfinclude template="../query/get_history_product_tree.cfm">
	<cfquery name="add_sub" datasource="#dsn3#" result="MAX_ID">
    	INSERT INTO
			PRODUCT_TREE
			(
				STOCK_ID,
                PRODUCT_ID,
				RELATED_ID,
				AMOUNT,
				UNIT_ID,
				SPECT_MAIN_ID,
				IS_CONFIGURE,
				IS_SEVK,
                LINE_NUMBER,
                OPERATION_TYPE_ID,
                IS_PHANTOM,
                RELATED_PRODUCT_TREE_ID,
                QUESTION_ID,
				PROCESS_STAGE,
				MAIN_STOCK_ID,
				IS_FREE_AMOUNT,
				FIRE_AMOUNT,
				FIRE_RATE,
				DETAIL,
                RECORD_EMP,
             	RECORD_DATE,
				PRODUCT_WIDTH,
				PRODUCT_LENGTH,
				PRODUCT_HEIGHT,
				TREE_TYPE
			)
		VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.main_stock_id#">,
				<cfif  isdefined('attributes.product_id') and len(attributes.product_id) and len(attributes.product_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_iD#"><cfelse>NULL</cfif>,
				<cfif len(attributes.add_stock_id) and len(attributes.product_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.add_stock_iD#"><cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_float" value ="#attributes.AMOUNT#">,
				<cfif len(attributes.UNIT_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.UNIT_ID#"><cfelse>NULL</cfif>,
				<cfif len(attributes.spect_main_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.spect_main_iD#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.is_configure") and len(attributes.is_configure)>0<cfelse>1</cfif>,
				<cfif isdefined("attributes.is_sevk") and len(attributes.is_sevk)>1<cfelse>0</cfif>,
                <cfif isdefined('attributes.line_number') and len(attributes.line_number)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.line_number#"><cfelse>NULL</cfif>,
                <cfif isdefined('attributes.operation_type_id') and len(attributes.operation_type_id) and not len(attributes.product_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.operation_type_iD#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.is_phantom') and len(attributes.is_phantom)>1<cfelse>0</cfif>,
				<cfif isdefined('attributes.PRODUCT_TREE_ID') and len(attributes.PRODUCT_TREE_ID) ><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PRODUCT_TREE_ID#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.alternative_questions') and len(attributes.alternative_questions) ><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.alternative_questions#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.process_stage_') and len(attributes.process_stage_) ><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage_#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.operation_main_stock_id") and len(attributes.operation_main_stock_id) and isdefined('attributes.PRODUCT_TREE_ID') and len(attributes.PRODUCT_TREE_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.operation_main_stock_iD#"><cfelse>NULL</cfif>,
               	<cfif isdefined("attributes.is_free_amount")>1<cfelse>0</cfif>,
				<cfif isdefined('attributes.fire_amount') and len(attributes.fire_amount)><cfqueryparam cfsqltype="cf_sql_float" value ="#attributes.fire_amount#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.fire_rate') and len(attributes.fire_rate)><cfqueryparam cfsqltype="cf_sql_float" value ="#attributes.fire_rate#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.detail') and len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#"><cfelse>NULL</cfif>,
			    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfif isdefined('attributes.product_width') and len(attributes.product_width)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_width#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.product_length') and len(attributes.product_length)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_length#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.product_height') and len(attributes.product_height)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_height#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.tree_types') and len(attributes.tree_types)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.tree_types#"><cfelse>NULL</cfif>       
			)
	</cfquery>
	<!---Ek Bilgiler--->
    <cfset attributes.actionId = attributes.MAIN_STOCK_ID>
    <!---Ek Bilgiler--->
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang no ='628.Ürüne Kendisini Ekleyemezsiniz'>!");
		history.back();
	</script>
	<cfabort>
</cfif>

<cfif isdefined("attributes.operation_main_stock_id")>
	<cfif isdefined('attributes.PRODUCT_TREE_ID') and isdefined("attributes.product_sample_id")and len(attributes.PRODUCT_TREE_ID) and not len(attributes.product_sample_id)>
		<script type="text/javascript">
            window.location.href='<cfoutput>#request.self#?fuseaction=prod.list_product_tree&event=upd&product_tree_id=#attributes.PRODUCT_TREE_ID#&main_stock_id=#attributes.operation_main_stock_id#</cfoutput>';
        </script>
	<cfelseif isdefined("attributes.product_sample_id")>
		<script type="text/javascript">
			window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
		</script>
	<cfelse>
		<script type="text/javascript">
            window.location.href='<cfoutput>#request.self#?fuseaction=prod.list_product_tree&event=upd&product_id=#main_product_id#&stock_id=#attributes.MAIN_STOCK_ID#&main_stock_id=#attributes.operation_main_stock_id#</cfoutput>';
        </script>
	</cfif>

<cfelse>
	<cfif isdefined('attributes.PRODUCT_TREE_ID') and isdefined("attributes.product_sample_id") and len(attributes.PRODUCT_TREE_ID) and not len(attributes.product_sample_id)>
		<script type="text/javascript">
            window.location.href='<cfoutput>#request.self#?fuseaction=prod.list_product_tree&event=upd&product_tree_id=#attributes.PRODUCT_TREE_ID#</cfoutput>';
        </script>
		<cfelseif isdefined("attributes.product_sample_id")>
			<script type="text/javascript">
				window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
			</script>
	<cfelse>
		<script type="text/javascript">
            window.location.href='<cfoutput>#request.self#?fuseaction=prod.list_product_tree&event=upd&product_id=#main_product_id#&stock_id=#attributes.MAIN_STOCK_ID#</cfoutput>';
        </script>
	</cfif>
</cfif>