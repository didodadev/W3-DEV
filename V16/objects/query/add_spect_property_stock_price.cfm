<script src="<cfoutput>#request.self#?fuseaction=home.emptypopup_js_functions</cfoutput>"></script>
<cfparam name="attributes.main_prod_price_currency" default="session.ep.money"><!---ana ürün olmadan spect ekleniyorsa ana ara birimi session.ep.money set ettim--->
	<cflock name="#createUUID()#" timeout="20">
		<cftransaction>
<!--- <cfinclude template="spect_main_control.cfm"> --->
<!--- eklenmek istenen spectle aynı ozellikte bir master spect varsa onun idsi alınıyor yoksa yeni bir master spect kaydedilerek onunidsi yollaniyor--->
<!---AYNI TARZ SPECT VARMI KONTROLU--->
<cfif isdefined("attributes.stock_id") and len(attributes.stock_id)>
	<cfscript>
	satir=0;
	form_property_id_list="";
	form_variation_id_list="";
	form_total_min_list="";
	form_total_max_list="";
	form_tolerans_list="";
	
	form_stock_id_list_2="";
	form_amount_list_2="";
	if(len(attributes.record_num) and attributes.record_num gt 0)	
		for(i=1;i lte attributes.record_num;i=i+1)
		{
			satir=satir+1;
			form_property_id_list = listappend(form_property_id_list,evaluate("attributes.property_id#i#"),',');
			if(len(evaluate("attributes.variation_id#i#")))
				form_variation_id_list = listappend(form_variation_id_list,evaluate("attributes.variation_id#i#"),',');
			else
				form_variation_id_list=form_variation_id_list&', ';
			if(len(evaluate("attributes.total_min#i#")))
				form_total_min_list = listappend(form_total_min_list,evaluate("attributes.total_min#i#"),',');
			else
				form_total_min_list=form_total_min_list&', ';
			if(len(evaluate("attributes.total_max#i#")))	
				form_total_max_list = listappend(form_total_max_list,evaluate("attributes.total_max#i#"),',');
			else
				form_total_max_list=form_total_max_list&', ';
			if(len(evaluate("attributes.tolerans#i#")))
				form_tolerans_list = listappend(form_tolerans_list,evaluate("attributes.tolerans#i#"),',');
			else
				form_tolerans_list=form_tolerans_list&', ';
		}
	if (isdefined("attributes.use_stock") and listlen(attributes.use_stock,','))
		for(i=1;i lte listlen(attributes.use_stock,',');i=i+1)
		{
				satir=satir+1;
				form_stock_id_list_2 = listappend(form_stock_id_list_2,evaluate("attributes.use_stock_id#i#"),',');
				form_amount_list_2 = listappend(form_amount_list_2,evaluate("attributes.stock_amount#i#"),',');
		}
	</cfscript>
	<cfquery name="GET_SPECT_ROW_COUNT" datasource="#DSN3#">
		SELECT 
			COUNT(SPECT_MAIN.STOCK_ID),
			SPECT_MAIN.SPECT_MAIN_ID
		FROM 
			SPECT_MAIN,SPECT_MAIN_ROW
		WHERE
			SPECT_MAIN.SPECT_MAIN_ID=SPECT_MAIN_ROW.SPECT_MAIN_ID
			AND SPECT_MAIN.STOCK_ID=#attributes.stock_id#
		GROUP BY 
			SPECT_MAIN.SPECT_MAIN_ID
		HAVING 
			COUNT(SPECT_MAIN.STOCK_ID)=#satir#
	</cfquery>
	<cfset spect_list_id=valuelist(GET_SPECT_ROW_COUNT.SPECT_MAIN_ID,',')>
	<cfif listlen(spect_list_id,',')>
		<cfset st=0>
		<cfquery name="GET_SPECT" datasource="#dsn3#">
			SELECT 
				COUNT(SPECT_MAIN_ROW.SPECT_MAIN_ROW_ID),
				SPECT_MAIN.SPECT_MAIN_ID,
				SPECT_MAIN.SPECT_MAIN_NAME
			FROM 
				SPECT_MAIN_ROW ,
				SPECT_MAIN
			WHERE
				SPECT_MAIN.SPECT_MAIN_ID IN (#spect_list_id#) AND
				SPECT_MAIN_ROW.SPECT_MAIN_ID=SPECT_MAIN.SPECT_MAIN_ID AND
				(
					<cfloop list="#form_property_id_list#" index="property">
						<cfset st=st+1>
						(
							SPECT_MAIN_ROW.PROPERTY_ID=#property#
							<cfif len(trim(listgetat(form_variation_id_list,st,',')))>
								AND SPECT_MAIN_ROW.VARIATION_ID=#listgetat(form_variation_id_list,st,',')#
							<cfelse>
								AND SPECT_MAIN_ROW.VARIATION_ID IS NULL
							</cfif>
							<cfif len(trim(listgetat(form_total_min_list,st,',')))>
								AND SPECT_MAIN_ROW.TOTAL_MIN=#listgetat(form_total_min_list,st,',')#
							<cfelse>
								AND SPECT_MAIN_ROW.TOTAL_MIN IS NULL
							</cfif>
							<cfif len(trim(listgetat(form_total_max_list,st,',')))>
								AND SPECT_MAIN_ROW.TOTAL_MAX=#listgetat(form_total_max_list,st,',')#
							<cfelse>
								AND SPECT_MAIN_ROW.TOTAL_MAX IS NULL
							</cfif>
							<cfif len(trim(listgetat(form_tolerans_list,st,',')))>
								AND SPECT_MAIN_ROW.TOLERANCE=#listgetat(form_tolerans_list,st,',')#
							<cfelse>
								AND SPECT_MAIN_ROW.TOLERANCE IS NULL
							</cfif>						
							AND SPECT_MAIN_ROW.IS_PROPERTY=1
						) 
						<cfif listlen(form_property_id_list) gt st>OR</cfif>
					</cfloop>
					<!---<cfset st=0>
					 <cfloop list="#form_stock_id_list_2#" index="stok_2">
						<cfset st=st+1>
						<cfif listlen(form_stock_id_list_2) lt st or listlen(form_stock_id_list)>OR</cfif>
						(
							SPECT_MAIN_ROW.STOCK_ID=#stok_2# 
							AND	SPECT_MAIN_ROW.AMOUNT=#listgetat(form_amount_list_2,st,',')#
							AND SPECT_MAIN_ROW.IS_PROPERTY=1
							AND IS_SEVK=#listgetat(form_sevk_list_2,st,',')#
						)
					</cfloop> --->
				)
			GROUP BY SPECT_MAIN.SPECT_MAIN_ID,SPECT_MAIN.SPECT_MAIN_NAME
			HAVING COUNT(SPECT_MAIN_ROW.SPECT_MAIN_ROW_ID)=#satir#
		</cfquery>
	</cfif>
	<cfif not isdefined('GET_SPECT.SPECT_MAIN_ID') or not len(GET_SPECT.SPECT_MAIN_ID)>
		<cfquery name="ADD_VAR_SPECT" datasource="#dsn3#" result="MAX_ID">
			INSERT
			INTO
				SPECT_MAIN
				(
					SPECT_MAIN_NAME,
					SPECT_TYPE,
					PRODUCT_ID,
					STOCK_ID,
					IS_TREE,
					RECORD_IP,
					RECORD_EMP,
					RECORD_DATE
				)
				VALUES
				(
					'#attributes.spect_name#',
					5,
					<cfif isdefined("attributes.product_id") and len(attributes.product_id)>#attributes.product_id#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.stock_id") and len(attributes.stock_id)>#attributes.stock_id#<cfelse>NULL</cfif>,
					0,
					'#cgi.remote_addr#',
					#session.ep.userid#,
					#now()#
				)
		</cfquery>
        <cfset GET_MAX_ID.MAX_ID = MAX_ID.IDENTITYCOL>
		<cfset attributes.main_spect_id=get_max_id.max_id>
		<cfif len(attributes.record_num) and attributes.record_num gt 0>
			<cfloop from="1" to="#attributes.record_num#" index="i">
				<cfscript>
					form_property_id = evaluate("attributes.property_id#i#");
					form_property_name = evaluate("attributes.property_name#i#");
					if(len(evaluate("attributes.variation_id#i#")))
						form_variation_id = evaluate("attributes.variation_id#i#");
					else
						form_variation_id='';
					if(len(evaluate("attributes.total_min#i#")))
						form_total_min = evaluate("attributes.total_min#i#");
					else
						form_total_min='';
					if(len(evaluate("attributes.total_max#i#")))	
						form_total_max = evaluate("attributes.total_max#i#");
					else
						form_total_max='';
					if(len(evaluate("attributes.tolerans#i#")))
						form_tolerans = evaluate("attributes.tolerans#i#");
					else
						form_tolerans='';
					
				</cfscript>					
				<cfquery name="ADD_ROW" datasource="#dsn3#">
					INSERT
					INTO
						SPECT_MAIN_ROW
						(
							SPECT_MAIN_ID,
							PRODUCT_ID,
							STOCK_ID,
							AMOUNT,
							PRODUCT_NAME,
							IS_PROPERTY,
							IS_CONFIGURE,
							IS_SEVK,
							PROPERTY_ID,
							VARIATION_ID,
							TOTAL_MIN,
							TOTAL_MAX,
							TOLERANCE
						)
						VALUES
						(
							#get_max_id.max_id#,
							NULL,
							NULL,
							0,
							<cfif len(form_property_name)>'#form_property_name#'<cfelse>NULL</cfif>,
							1,
							0,
							0,
							<cfif len(form_property_id)>#form_property_id#<cfelse>NULL</cfif>,
							<cfif len(form_variation_id)>#form_variation_id#<cfelse>NULL</cfif>,
							<cfif len(form_total_min)>#form_total_min#<cfelse>NULL</cfif>,
							<cfif len(form_total_max)>#form_total_max#<cfelse>NULL</cfif>,
							<cfif len(form_tolerans)>#form_tolerans#<cfelse>NULL</cfif>
						)
				</cfquery>
			</cfloop>
		</cfif>
			<!--- <cfif isdefined("attributes.record_num") and len(attributes.record_num) and attributes.record_num neq "">
				<cfloop from="1" to="#attributes.record_num#" index="i">
					<cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#")>
						<cfscript>
							form_product_id = evaluate("attributes.product_id#i#");
							form_stock_id = evaluate("attributes.stock_id#i#");
							form_amount = evaluate("attributes.amount#i#");
							form_property_id = evaluate("attributes.property_id#i#");
							form_variation_id = evaluate("attributes.variation_id#i#");
							form_total_min = evaluate("attributes.total_min#i#");
							form_total_max= evaluate("attributes.total_max#i#");
							form_product_name = evaluate("attributes.product_name#i#");
						</cfscript>
						<cfquery name="ADD_ROW" datasource="#dsn3#">
							INSERT
							INTO
								SPECT_MAIN_ROW
								(
									SPECT_MAIN_ID,
									PRODUCT_ID,
									STOCK_ID,
									AMOUNT,
									PROPERTY_ID,
									VARIATION_ID,
									TOTAL_MIN,
									TOTAL_MAX,
									PRODUCT_NAME,
									IS_PROPERTY,
									IS_CONFIGURE,
									IS_SEVK
								)
								VALUES
								(
									#get_max_id.max_id#,
									<cfif len(form_product_id)>#form_product_id#,<cfelse>NULL,</cfif>
									<cfif len(form_stock_id)>#form_stock_id#<cfelse>NULL</cfif>,
									<cfif len(form_amount)>#form_amount#,<cfelse>0,</cfif>
									<cfif len(form_property_id)>#form_property_id#,<cfelse>NULL,</cfif>
									<cfif len(form_variation_id)>#form_variation_id#,<cfelse>NULL,</cfif>
									<cfif len(form_total_min)>#form_total_min#,<cfelse>NULL,</cfif>
									<cfif len(form_total_max)>#form_total_max#,<cfelse>NULL,</cfif>
									<cfif len(form_product_name)>'#form_product_name#'<cfelse>NULL</cfif>,
									1,
									0,
									<cfif isdefined("attributes.is_sevk#i#")>1<cfelse>0</cfif>
								)
						</cfquery>
					</cfif>
				</cfloop>
			</cfif> --->
	<cfelse>
		<cfset attributes.main_spect_id=GET_SPECT.SPECT_MAIN_ID>
	</cfif>
</cfif>
<!---//AYNI TARZ SPECT VARMI KONTROLU--->




<!--- <cfabort> --->

		<cfquery name="ADD_VAR_SPECT" datasource="#dsn3#">
			INSERT
			INTO
				SPECTS
				(
					SPECT_MAIN_ID,
					SPECT_VAR_NAME,
					SPECT_TYPE,
					PRODUCT_ID,
					STOCK_ID,
					TOTAL_AMOUNT,
					OTHER_MONEY_CURRENCY,
					OTHER_TOTAL_AMOUNT,
					PRODUCT_AMOUNT,
					PRODUCT_AMOUNT_CURRENCY,
					IS_TREE,
					RECORD_IP,
					RECORD_EMP,
					RECORD_DATE
				)
				VALUES
				(
					#attributes.main_spect_id#,
					'#attributes.spect_name#',
					5,
					<cfif isdefined("attributes.product_id") and len(attributes.product_id)>#attributes.product_id#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.stock_id") and len(attributes.stock_id)>#attributes.stock_id#<cfelse>NULL</cfif>,
					0,
					'#listgetat(attributes.other_money,1,",")#',
					<cfif len(attributes.other_price)>#attributes.other_price#,<cfelse>0,</cfif>
					<cfif isdefined("attributes.price") and len(attributes.price)>#attributes.price#<cfelse>0</cfif>,
					'#session.ep.money#',
					0,
					'#cgi.remote_addr#',
					#session.ep.userid#,
					#now()#
				)
		</cfquery>
		<cfquery name="GET_MAX_ID" datasource="#dsn3#">
			SELECT MAX(SPECT_VAR_ID) AS MAX_ID FROM SPECTS
		</cfquery>
		<cfif isdefined("attributes.money_record_num") and attributes.money_record_num gt 0>
			<cfloop from="1" to="#attributes.money_record_num#" index="i">
				<cfscript>
					spec_money_type=listgetat(evaluate("attributes.MONEY#i#"),1);
					spec_txt_rate1=1;
					spec_txt_rate2=listgetat(evaluate("attributes.MONEY#i#"),2);
					if(spec_money_type eq listgetat(attributes.other_money,1,','))
						spec_money_select=1;
					else
						spec_money_select=0;
				</cfscript>
				<cfquery name="add_spec_money" datasource="#dsn3#">
					INSERT INTO
						SPECT_MONEY
						(
							MONEY_TYPE,
							ACTION_ID,
							RATE2,
							RATE1,
							IS_SELECTED
						)VALUES
						(
							'#spec_money_type#',
							#get_max_id.max_id#,
							#spec_txt_rate2#,
							#spec_txt_rate1#,
							#spec_money_select#
						)
				</cfquery>
			</cfloop>
			</cfif>
			<cfif isdefined('attributes.use_stock') and listlen(attributes.use_stock,',')>
				<cfloop list="#attributes.use_stock#" index="i" delimiters=",">
						<cfscript>
							form_product_id = evaluate("attributes.use_product_id#i#");
							form_stock_id = evaluate("attributes.use_stock_id#i#");
							form_stock_code = evaluate("attributes.use_stock_code#i#");
							form_spect_id = evaluate("attributes.use_spect_id#i#");
							form_manufact_code = evaluate("attributes.use_manufact_code#i#");
							form_shelf_number = evaluate("attributes.use_shelf_number#i#");
							form_amount = evaluate("attributes.use_amount#i#");
							form_value_money_type = session.ep.money;
							form_product_name = evaluate("attributes.use_product_name#i#");
							form_store = evaluate("attributes.use_store#i#");
							form_store_location = evaluate("attributes.use_store_location#i#");
						</cfscript>
						<cfquery name="ADD_ROW" datasource="#dsn3#">
							INSERT
							INTO
								SPECTS_ROW
								(
									SPECT_ID,
									PRODUCT_ID,
									STOCK_ID,
									AMOUNT_VALUE,
									TOTAL_VALUE,
									MONEY_CURRENCY,
									PRODUCT_NAME,
									IS_PROPERTY,
									IS_CONFIGURE,
									DIFF_PRICE,
									PRODUCT_COST,
									PRODUCT_COST_MONEY,
									PRODUCT_COST_ID,
									IS_SEVK,
									RELATED_SPECT_ID,
									SHELF_NUMBER,
									PRODUCT_MANUFACT_CODE
								)
								VALUES
								(
									#get_max_id.max_id#,
									<cfif len(form_product_id)>#form_product_id#<cfelse>NULL</cfif>,
									<cfif len(form_stock_id)>#form_stock_id#<cfelse>NULL</cfif>,
									<cfif len(form_amount)>#form_amount#<cfelse>0</cfif>,
									0,
									'#session.ep.money#',
									<cfif len(form_product_name)>'#form_product_name#'<cfelse>NULL</cfif>,
									0,
									0,
									0,
									0,
									NULL,
									NULL,
									0,
									<cfif len(form_spect_id)>#form_spect_id#<cfelse>NULL</cfif>,
									<cfif len(form_shelf_number)>'#form_shelf_number#'<cfelse>NULL</cfif>,
									<cfif len(form_manufact_code)>'#form_manufact_code#'<cfelse>NULL</cfif>
								)
						</cfquery>						
						
				</cfloop>
			</cfif>
			
			<cfloop from="1" to="#attributes.record_num#" index="i">
				
					<cfscript>
						form_property_id = evaluate("attributes.property_id#i#");
						form_variation_id = evaluate("attributes.variation_id#i#");
						form_total_min = evaluate("attributes.total_min#i#");
						form_total_max= evaluate("attributes.total_max#i#");
						form_tolerans= evaluate("attributes.tolerans#i#");
					</cfscript>
					<cfquery name="ADD_ROW" datasource="#dsn3#">
						INSERT
						INTO
							SPECTS_ROW
							(
								SPECT_ID,
								PRODUCT_ID,
								STOCK_ID,
								AMOUNT_VALUE,
								TOTAL_VALUE,
								MONEY_CURRENCY,
								PROPERTY_ID,
								VARIATION_ID,
								TOTAL_MIN,
								TOTAL_MAX,
								PRODUCT_NAME,
								IS_PROPERTY,
								IS_CONFIGURE,
								IS_SEVK,
								TOLERANCE
							)
							VALUES
							(
								#get_max_id.max_id#,
								NULL,
								NULL,
								0,<!--- <cfif len(form_amount)>#form_amount#,<cfelse>0,</cfif> --->
								0,
								'#session.ep.money#',<!--- bu alanlara ne atılacak???? --->
								<cfif len(form_property_id)>#form_property_id#,<cfelse>NULL,</cfif>
								<cfif len(form_variation_id)>#form_variation_id#,<cfelse>NULL,</cfif>
								<cfif len(form_total_min)>#form_total_min#,<cfelse>NULL,</cfif>
								<cfif len(form_total_max)>#form_total_max#,<cfelse>NULL,</cfif>
								NULL,
								1,
								0,
								0,
								<cfif len(form_tolerans)>#form_tolerans#<cfelse>NULL</cfif>
							)
					</cfquery>
			</cfloop>

	<cfquery name="PRODUCTS" datasource="#DSN3#">
		SELECT
			STOCKS.STOCK_ID,
			STOCKS.PRODUCT_ID,
			STOCKS.STOCK_CODE,
			PRODUCT.PRODUCT_NAME,
			STOCKS.PROPERTY,
			STOCKS.BARCOD AS BARCOD,
			PRODUCT.IS_INVENTORY,
			PRODUCT.TAX AS TAX,
			PRODUCT.IS_ZERO_STOCK,
			PRODUCT.IS_PRODUCTION,
			PRODUCT.PRODUCT_CATID,
			PRODUCT.PRODUCT_CODE,
			PRODUCT.IS_SERIAL_NO,
			STOCKS.MANUFACT_CODE,
			PRODUCT_UNIT.ADD_UNIT,
			PRODUCT_UNIT.PRODUCT_UNIT_ID,
			PRODUCT_UNIT.MAIN_UNIT,
			PRODUCT_UNIT.MULTIPLIER
		FROM
			#dsn1_alias#.PRODUCT PRODUCT,
			#dsn1_alias#.STOCKS STOCKS,
			#dsn1_alias#.PRODUCT_UNIT PRODUCT_UNIT
		WHERE
			STOCKS.STOCK_ID =#attributes.stock_id# AND
			PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
			PRODUCT_UNIT.PRODUCT_UNIT_STATUS = 1 AND 
			PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID
	</cfquery>
		</cftransaction>
	</cflock>
<script type="text/javascript">
	<cfoutput>
	opener.add_basket_row('#PRODUCTS.PRODUCT_ID#', '#PRODUCTS.STOCK_ID#', '#PRODUCTS.STOCK_CODE#', '#PRODUCTS.BARCOD#', '#PRODUCTS.MANUFACT_CODE#', '#PRODUCTS.PRODUCT_NAME#', '#PRODUCTS.PRODUCT_UNIT_ID#', '#PRODUCTS.ADD_UNIT#', '#get_max_id.max_id#', '#attributes.spect_name#', '#attributes.price#', '#attributes.other_price#', '#PRODUCTS.TAX#', '', '#attributes.discount_yuzde#', '0', '0', '0', '0', '0', '0', '0', '0', '0', '', '', '', '', '#listgetat(attributes.other_money,1)#', '0', '#attributes.amount#', '', '#PRODUCTS.IS_INVENTORY#','#PRODUCTS.IS_PRODUCTION#','','','','','','','','','#attributes.discount#','','','0','','','','0','','',1);
	</cfoutput>
	window.close();
</script>
