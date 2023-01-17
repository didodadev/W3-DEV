<cfif isDefined("attributes.question_type_1") and isDefined("attributes.question_type_2") and isDefined("attributes.question_type_3")>
	<cftransaction>
		<cfquery name="GET_PRO_TREE" datasource="#dsn3#">
			SELECT * FROM PRODUCT_TREE WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.FROM_STOCK_ID#">
		</cfquery>

		<cfoutput query="GET_PRO_TREE">
			<cfloop from="1" to="#attributes.STOCK_DETAIL_COUNT#" index="i">
				<cfif len(GET_PRO_TREE.QUESTION_ID) >	
					<cfquery name="get_alternative_prod_id" datasource="#DSN3#"> 
						SELECT
							AP.STOCK_ID,
							AP.ALTERNATIVE_PRODUCT_ID 
						FROM 
							#dsn3#.ALTERNATIVE_PRODUCTS AS AP,
							#dsn1#.STOCKS_PROPERTY AS SP
						WHERE 
							AP.TREE_STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.FROM_STOCK_ID#"> AND
							AP.QUESTION_ID = #GET_PRO_TREE.QUESTION_ID# AND
							SP.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.to_stock_id_#i#")#"> AND
							AP.PROPERTY_ID = SP.PROPERTY_DETAIL_ID
					</cfquery>
					<cfif get_alternative_prod_id.recordCount>
						<cfset v_prod_id = get_alternative_prod_id.ALTERNATIVE_PRODUCT_ID>
						<cfset v_stock_id = get_alternative_prod_id.STOCK_ID>
					<cfelse>
						<cfset v_prod_id = GET_PRO_TREE.PRODUCT_ID>
						<cfset v_stock_id = GET_PRO_TREE.RELATED_ID>
					</cfif>
				<cfelse>
					<cfset v_prod_id = GET_PRO_TREE.PRODUCT_ID>
					<cfset v_stock_id = GET_PRO_TREE.RELATED_ID>
				</cfif>
				<cfquery name="ADD_PRO_TREE" datasource="#DSN3#">
					INSERT INTO PRODUCT_TREE(
						STOCK_ID,
						RELATED_ID,
						PRODUCT_ID,
						HIERARCHY,
						IS_TREE,
						AMOUNT,
						UNIT_ID,
						IS_CONFIGURE,
						IS_SEVK,
						SPECT_MAIN_ID,
						LINE_NUMBER,
						OPERATION_TYPE_ID,
						IS_PHANTOM,
						RELATED_PRODUCT_TREE_ID,
						PROCESS_STAGE,
						QUESTION_ID,
						ALTERNATIVE_STOCK_ID,
						PRODUCT_WIDTH,
						PRODUCT_LENGTH,
						PRODUCT_HEIGHT,
						PRODUCT_PROPERTY
					)
					VALUES( 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.to_stock_id_#i#")#">,
						<cfif len(v_stock_id)>#v_stock_id#<cfelse>NULL</cfif>,
						<cfif len(v_prod_id)>#v_prod_id#<cfelse>NULL</cfif>,
						<cfif len(GET_PRO_TREE.HIERARCHY)>#GET_PRO_TREE.HIERARCHY#<cfelse>NULL</cfif>,
						<cfif len(GET_PRO_TREE.IS_TREE)>#GET_PRO_TREE.IS_TREE#<cfelse>NULL</cfif>,
						<cfif len(GET_PRO_TREE.AMOUNT)>#GET_PRO_TREE.AMOUNT#<cfelse>NULL</cfif>,
						<cfif len(GET_PRO_TREE.UNIT_ID)>#GET_PRO_TREE.UNIT_ID#<cfelse>NULL</cfif>,
						<cfif len(GET_PRO_TREE.IS_CONFIGURE)>#GET_PRO_TREE.IS_CONFIGURE#<cfelse>NULL</cfif>,
						<cfif len(GET_PRO_TREE.IS_SEVK)>#GET_PRO_TREE.IS_SEVK#<cfelse>NULL</cfif>,
						<cfif len(GET_PRO_TREE.SPECT_MAIN_ID)>#GET_PRO_TREE.SPECT_MAIN_ID#<cfelse>NULL</cfif>,
						<cfif len(GET_PRO_TREE.LINE_NUMBER)>#GET_PRO_TREE.LINE_NUMBER#<cfelse>NULL</cfif>,
						<cfif len(GET_PRO_TREE.OPERATION_TYPE_ID)>#GET_PRO_TREE.OPERATION_TYPE_ID#<cfelse>NULL</cfif>,
						<cfif len(GET_PRO_TREE.IS_PHANTOM)>#GET_PRO_TREE.IS_PHANTOM#<cfelse>NULL</cfif>,
						<cfif len(GET_PRO_TREE.RELATED_PRODUCT_TREE_ID)>#GET_PRO_TREE.RELATED_PRODUCT_TREE_ID#<cfelse>NULL</cfif>,
						NULL,
						<cfif len(GET_PRO_TREE.QUESTION_ID)>#GET_PRO_TREE.QUESTION_ID#<cfelse>NULL</cfif>,
						<cfset counter = 0 />
						<cfif attributes.question_type_1 gt 0 >
							<cfset counter += attributes.question_type_1 />
							<cfset rsp = false />
							<cfloop from="1" to="#counter#" index="k">
								<cfif isDefined("attributes.add_stock_id_#i#_#k#") and len(evaluate("attributes.add_stock_id_#i#_#k#"))>
									<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.add_stock_id_#i#_#k#")#">,
									<cfset rsp = true>
									<cfbreak>
								</cfif>
							</cfloop>
							<cfif !rsp>
								NULL,
							</cfif>
						<cfelse>
							NULL,
						</cfif>
						<cfif attributes.question_type_2 gt 0 >
							<cfset count = counter gt 0 ? counter + 1 : 1 />
							<cfset counter += attributes.question_type_2 />
							<cfset rsp = false />
							<cfloop from="#count#" to="#counter#" index="k">
								<cfif (isDefined("attributes.product_width_#i#_#k#") and len(evaluate("attributes.product_width_#i#_#k#"))) or (isDefined("attributes.product_length_#i#_#k#") and len(evaluate("attributes.product_length_#i#_#k#"))) or (isDefined("attributes.product_height_#i#_#k#") and len(evaluate("attributes.product_height_#i#_#k#"))) >
									<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.product_width_#i#_#k#")#" null="#len(evaluate("attributes.product_width_#i#_#k#"))?'no':'yes'#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.product_length_#i#_#k#")#" null="#len(evaluate("attributes.product_length_#i#_#k#"))?'no':'yes'#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.product_height_#i#_#k#")#" null="#len(evaluate("attributes.product_height_#i#_#k#"))?'no':'yes'#">, 
									<cfset rsp = true>
									<cfbreak>
								</cfif>
							</cfloop>
							<cfif !rsp>
								NULL,
								NULL,
								NULL,
							</cfif>
						<cfelse>
							NULL,
							NULL,
							NULL,
						</cfif>
						<cfif attributes.question_type_3 gt 0 >
							<cfset count = counter gt 0 ? counter + 1 : 1 />
							<cfset counter += attributes.question_type_3 />
							<cfset rsp = false />
							<cfloop from="#count#" to="#counter#" index="k">
								<cfif isDefined("attributes.property_id_#i#_#k#") and len(evaluate("attributes.property_id_#i#_#k#"))>
									<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.property_id_#i#_#k#")#">
									<cfset rsp = true>
									<cfbreak>
								</cfif>
							</cfloop>
							<cfif !rsp>
								NULL
							</cfif>
						<cfelse>
							NULL
						</cfif>
					)
				</cfquery>
			</cfloop>
		</cfoutput>
		<cfloop from="1" to="#attributes.STOCK_DETAIL_COUNT#" index="i">
			<cfif isDefined("attributes.to_stock_id_#i#") and len(evaluate("attributes.to_stock_id_#i#"))>
				<cfquery name="ADD_WORK_PROD" datasource="#DSN3#">
					INSERT INTO WORKSTATIONS_PRODUCTS(
						WS_ID,
						STOCK_ID,
						CAPACITY,
						PRODUCTION_TIME,
						PRODUCTION_TIME_TYPE,
						SETUP_TIME,
						MIN_PRODUCT_AMOUNT,
						PRODUCTION_TYPE,
						PROCESS,
						MAIN_STOCK_ID,
						OPERATION_TYPE_ID,
						RECORD_EMP,
						RECORD_IP,
						RECORD_DATE,
						ASSET_ID
					)
					SELECT 
						WS_ID,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.to_stock_id_#i#")#">,
						CAPACITY,
						PRODUCTION_TIME,
						PRODUCTION_TIME_TYPE,
						SETUP_TIME,
						MIN_PRODUCT_AMOUNT,
						PRODUCTION_TYPE,
						PROCESS,
						MAIN_STOCK_ID,
						OPERATION_TYPE_ID,
						RECORD_EMP,
						RECORD_IP,
						RECORD_DATE,
						ASSET_ID
					FROM 
						WORKSTATIONS_PRODUCTS
					WHERE 
						STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.FROM_STOCK_ID#">
				</cfquery>
				<cfquery name="get_operation" datasource="#dsn3#">
					SELECT * FROM PRODUCT_TREE WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.FROM_STOCK_ID#"> AND RELATED_ID IS NULL
				</cfquery>
				<cfloop query="#get_operation#">
					<cfquery name="get_las_ind" datasource="#dsn3#">
						SELECT * FROM PRODUCT_TREE WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.to_stock_id_#i#")#"> AND OPERATION_TYPE_ID = #get_operation.OPERATION_TYPE_ID#
					</cfquery>
					<cfscript>
						writeTree(get_operation.product_tree_id,get_las_ind.product_tree_id);
					</cfscript>
				</cfloop>
			</cfif>
		</cfloop>
	</cftransaction>
	<script>
		closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>');
		window.location.reload();
	</script>
<cfelse>
	<cfquery name="GET_PRO_TREE" datasource="#DSN3#">
		INSERT PRODUCT_TREE (
			STOCK_ID,
			RELATED_ID,
			PRODUCT_ID,
			HIERARCHY,
			IS_TREE,
			AMOUNT,
			UNIT_ID,
			IS_CONFIGURE,
			IS_SEVK,
			SPECT_MAIN_ID,
			LINE_NUMBER,
			OPERATION_TYPE_ID,
			IS_PHANTOM,
			RELATED_PRODUCT_TREE_ID,
			PROCESS_STAGE
		)
		SELECT 
			#attributes.to_stock_id#,
			RELATED_ID,
			PRODUCT_ID,
			HIERARCHY,
			IS_TREE,
			AMOUNT,
			UNIT_ID,
			IS_CONFIGURE,
			IS_SEVK,
			SPECT_MAIN_ID,
			LINE_NUMBER,
			OPERATION_TYPE_ID,
			IS_PHANTOM,
			RELATED_PRODUCT_TREE_ID,
			#attributes.process_stage_#
		FROM 
			PRODUCT_TREE
		WHERE 
			STOCK_ID = #attributes.FROM_STOCK_ID#
	</cfquery>
	<cfquery name="ADD_WORK_PROD" datasource="#DSN3#">
		INSERT WORKSTATIONS_PRODUCTS 
		(
			WS_ID,
			STOCK_ID,
			CAPACITY,
			PRODUCTION_TIME,
			PRODUCTION_TIME_TYPE,
			SETUP_TIME,
			MIN_PRODUCT_AMOUNT,
			PRODUCTION_TYPE,
			PROCESS,
			MAIN_STOCK_ID,
			OPERATION_TYPE_ID,
			RECORD_EMP,
			RECORD_IP,
			RECORD_DATE,
			ASSET_ID
		)
		SELECT 
			WS_ID,
			#attributes.to_stock_id#,
			CAPACITY,
			PRODUCTION_TIME,
			PRODUCTION_TIME_TYPE,
			SETUP_TIME,
			MIN_PRODUCT_AMOUNT,
			PRODUCTION_TYPE,
			PROCESS,
			MAIN_STOCK_ID,
			OPERATION_TYPE_ID,
			RECORD_EMP,
			RECORD_IP,
			RECORD_DATE,
			ASSET_ID
		FROM 
			WORKSTATIONS_PRODUCTS
		WHERE 
			STOCK_ID = #attributes.FROM_STOCK_ID#
	</cfquery>
	<cfquery name="get_operation" datasource="#dsn3#">
		SELECT * FROM PRODUCT_TREE WHERE STOCK_ID = #attributes.FROM_STOCK_ID# AND RELATED_ID IS NULL
	</cfquery>
	<cfoutput query="get_operation">
		<cfquery name="get_las_ind" datasource="#dsn3#">
			SELECT * FROM PRODUCT_TREE WHERE STOCK_ID = #attributes.to_stock_id# AND OPERATION_TYPE_ID = #get_operation.OPERATION_TYPE_ID#
		</cfquery>
		<cfscript>
			writeTree(get_operation.product_tree_id,get_las_ind.product_tree_id);
		</cfscript>
	</cfoutput>
	<script type="text/javascript">
		window.location.reload();
	</script>	
</cfif>
<cfscript>
	function get_subs(related_tree_id){										
		SQLStr = "
				SELECT
					PRODUCT_TREE_ID RELATED_ID,
					ISNULL(PT.STOCK_ID,0) STOCK_ID,
					ISNULL(PT.SPECT_MAIN_ID,0) SPECT_MAIN_ROW_ID,
					ISNULL(PT.SPECT_MAIN_ID,0) AS SPECT_MAIN_ID,
					ISNULL(PT.QUESTION_ID,0) AS QUESTION_ID,
					ISNULL(PT.PRODUCT_ID,0) AS PRODUCT_ID,
					ISNULL(PT.OPERATION_TYPE_ID,0) OPERATION_TYPE_ID,
					ISNULL(PT.RELATED_ID,0) STOCK_RELATED_ID
				FROM 
					PRODUCT_TREE PT
				WHERE
					RELATED_PRODUCT_TREE_ID = #related_tree_id#
				ORDER BY
					LINE_NUMBER,
					STOCK_ID DESC
			";
		query1 = cfquery(SQLString : SQLStr, Datasource : dsn3);
		stock_id_ary='';
		for (str_i=1; str_i lte query1.recordcount; str_i = str_i+1)
		{
			stock_id_ary=listappend(stock_id_ary,query1.RELATED_ID[str_i],'█');
			stock_id_ary=listappend(stock_id_ary,query1.STOCK_RELATED_ID[str_i],'§');
		}
		return stock_id_ary;
	}
	function writeTree(related_tree_id,new_tree_id){
		var i = 1;
		var sub_products = get_subs(related_tree_id);
		for (i=1; i lte listlen(sub_products,'█'); i = i+1)
		{
			_next_tree_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),1,'§');//alt+987 = █ --//alt+789 = §
			_next_stock_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),2,'§');
			InsSQLStr = "
				INSERT PRODUCT_TREE 
				(
					STOCK_ID,
					RELATED_ID,
					PRODUCT_ID,
					HIERARCHY,
					IS_TREE,
					AMOUNT,
					UNIT_ID,
					IS_CONFIGURE,
					IS_SEVK,
					SPECT_MAIN_ID,
					LINE_NUMBER,
					OPERATION_TYPE_ID,
					IS_PHANTOM,
					RELATED_PRODUCT_TREE_ID,
					PROCESS_STAGE
				)
				SELECT 
					0,
					RELATED_ID,
					PRODUCT_ID,
					HIERARCHY,
					IS_TREE,
					AMOUNT,
					UNIT_ID,
					IS_CONFIGURE,
					IS_SEVK,
					SPECT_MAIN_ID,
					LINE_NUMBER,
					OPERATION_TYPE_ID,
					IS_PHANTOM,
					#new_tree_id#,
					NULL
				FROM 
					PRODUCT_TREE
				WHERE 
					PRODUCT_TREE_ID = #_next_tree_id_#
			";
			query1 = cfquery(SQLString : InsSQLStr, Datasource : dsn3, is_select:false);
			new_select_1 = "SELECT MAX(PRODUCT_TREE_ID) MAX_ID FROM PRODUCT_TREE";
			query1_ = cfquery(SQLString : new_select_1, Datasource : dsn3);
			if(_next_stock_id_ eq 0)
				writeTree(_next_tree_id_,query1_.max_id[1]);
		 }
	}
</cfscript>
