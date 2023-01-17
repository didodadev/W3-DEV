<!--- eklenmek istenen spectle aynı ozellikte bir master spect varsa onun idsi alınıyor yoksa yeni bir master spect kaydedilerek onunidsi yollaniyor--->
<!---AYNI TARZ SPECT VARMI KONTROLU--->
<cfif isdefined("attributes.value_stock_id") and len(attributes.value_stock_id)>
	<cfscript>
	satir=0;
	form_stock_id_list="";
	form_amount_list="";
	form_sevk_list="";
	form_stock_id_list_2="";
	form_amount_list_2="";
	form_sevk_list_2="";
	if(len(attributes.tree_record_num) and attributes.tree_record_num gt 0)
		for(i=1;i lte attributes.tree_record_num;i=i+1)
			if(isdefined("attributes.tree_row_kontrol#i#") and evaluate("attributes.tree_row_kontrol#i#") eq 1)
			{
				satir=satir+1;
				if(listlen(evaluate('attributes.tree_product_id#i#'),',') gt 1)
					form_stock_id_list = listappend(form_stock_id_list,listgetat(evaluate("attributes.tree_product_id#i#"),2,","),',');
				else
					form_stock_id_list = listappend(form_stock_id_list,evaluate("attributes.tree_stock_id#i#"),',');
				form_amount_list = listappend(form_amount_list,evaluate("attributes.tree_amount#i#"),',');
				if(isdefined('attributes.tree_is_sevk#i#'))
					form_sevk_list = listappend(form_sevk_list,1,',');
				else
					form_sevk_list = listappend(form_sevk_list,0,',');
			}
	if (isdefined("attributes.record_num") and len(attributes.record_num))
		for(i=1;i lte attributes.record_num;i=i+1)
			if(isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#") eq 1)
			{
				satir=satir+1;
				form_stock_id_list_2 = listappend(form_stock_id_list_2,evaluate("attributes.stock_id#i#"),',');
				form_amount_list_2 = listappend(form_amount_list_2,evaluate("attributes.amount#i#"),',');
				if(isdefined('attributes.is_sevk#i#'))
					form_sevk_list_2 = listappend(form_sevk_list_2,1,',');
				else
					form_sevk_list_2 = listappend(form_sevk_list_2,0,',');
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
			AND SPECT_MAIN.STOCK_ID=#attributes.value_stock_id#
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
					<cfloop list="#form_stock_id_list#" index="stok">
						<cfset st=st+1>
						(
							SPECT_MAIN_ROW.STOCK_ID=#stok# 
							AND SPECT_MAIN_ROW.AMOUNT=#listgetat(form_amount_list,st,',')#
							AND SPECT_MAIN_ROW.IS_PROPERTY=0
							AND IS_SEVK=#listgetat(form_sevk_list,st,',')#
						) 
						<cfif listlen(form_stock_id_list) gt st>OR</cfif>
					</cfloop>
					<cfset st=0>
					<cfloop list="#form_stock_id_list_2#" index="stok_2">
						<cfset st=st+1>
						<cfif listlen(form_stock_id_list_2) lt st or listlen(form_stock_id_list)>OR</cfif>
						(
							SPECT_MAIN_ROW.STOCK_ID=#stok_2# 
							AND	SPECT_MAIN_ROW.AMOUNT=#listgetat(form_amount_list_2,st,',')#
							AND SPECT_MAIN_ROW.IS_PROPERTY=1
							AND IS_SEVK=#listgetat(form_sevk_list_2,st,',')#
						)
					</cfloop>
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
					1,
					<cfif isdefined("attributes.value_product_id_deger") and len(attributes.value_product_id_deger)>#attributes.value_product_id_deger#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.value_stock_id") and len(attributes.value_stock_id)>#attributes.value_stock_id#<cfelse>NULL</cfif>,
					0,
					'#cgi.remote_addr#',
					#session.ep.userid#,
					#now()#
				)
		</cfquery>
		<cfset attributes.main_spect_id=MAX_ID.IDENTITYCOL>
		<cfif len(attributes.tree_record_num) and attributes.tree_record_num gt 0>
			<cfloop from="1" to="#attributes.tree_record_num#" index="i">
				<cfif isdefined("attributes.tree_row_kontrol#i#") and evaluate("attributes.tree_row_kontrol#i#") eq 1>
					<cfscript>
						form_product_id = listgetat(evaluate("attributes.tree_product_id#i#"),1,',');
						form_stock_id = listgetat(evaluate("attributes.tree_product_id#i#"),2,',');
						form_product_name = listgetat(evaluate("attributes.tree_product_id#i#"),7,',');
						form_amount = evaluate("attributes.tree_amount#i#");
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
								IS_SEVK
							)
							VALUES
							(
								#MAX_ID.IDENTITYCOL#,
								<cfif len(form_product_id)>#form_product_id#<cfelse>NULL</cfif>,
								<cfif len(form_stock_id)>#form_stock_id#<cfelse>NULL</cfif>,
								<cfif len(form_amount)>#form_amount#<cfelse>0</cfif>,
								<cfif len(form_product_name)>'#form_product_name#'<cfelse>NULL</cfif>,
								0,
								<cfif isdefined("attributes.tree_is_configure#i#")>1<cfelse>0</cfif>,
								<cfif isdefined("attributes.tree_is_sevk#i#")>1<cfelse>0</cfif>
							)
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>
		<!---session.ep.our_company_info.product_config 1 ise bu rrası çalışıyor--->
			<cfif isdefined("attributes.record_num") and len(attributes.record_num) and attributes.record_num neq "">
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
									#MAX_ID.IDENTITYCOL#,
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
			</cfif>
	<cfelse>
		<cfset attributes.main_spect_id=GET_SPECT.SPECT_MAIN_ID>
	</cfif>
</cfif>
<!---//AYNI TARZ SPECT VARMI KONTROLU--->
