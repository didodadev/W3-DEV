<cfsetting showdebugoutput="no">
<cfscript>
	attributes.purchase_labour_price = filterNum(attributes.purchase_labour_price);
	attributes.purchase_material_price = filterNum(attributes.purchase_material_price);
	attributes.purchase_engineering_price = filterNum(attributes.purchase_engineering_price);
	attributes.purchase_management_price = filterNum(attributes.purchase_management_price);
	attributes.sales_labour_price = filterNum(attributes.sales_labour_price);
	attributes.sales_material_price = filterNum(attributes.sales_material_price);
	attributes.sales_engineering_price = filterNum(attributes.sales_engineering_price);
	attributes.sales_management_price = filterNum(attributes.sales_management_price);
	
	attributes.purchase_labour_amount = filterNum(attributes.purchase_labour_amount);
	attributes.purchase_material_amount = filterNum(attributes.purchase_material_amount);
	attributes.purchase_engineering_amount = filterNum(attributes.purchase_engineering_amount);
	attributes.purchase_management_amount = filterNum(attributes.purchase_management_amount);
	attributes.sales_labour_amount = filterNum(attributes.sales_labour_amount);
	attributes.sales_material_amount = filterNum(attributes.sales_material_amount);
	attributes.sales_engineering_amount = filterNum(attributes.sales_engineering_amount);
	attributes.sales_management_amount = filterNum(attributes.sales_management_amount);
</cfscript>
<cfquery name="add_relation_pbs_code" datasource="#dsn3#">
	INSERT INTO
		RELATION_PBS_CODE
		(
			PBS_ID,
			PRODUCT_ID,
			OPPORTUNITY_ID,
			PROJECT_ID,
			OFFER_ID,
			DETAIL,
			PURCHASE_LABOUR_PRICE,
			PURCHASE_MATERIAL_PRICE,
			PURCHASE_ENGINEERING_PRICE,
			PURCHASE_MANAGEMENT_PRICE,
			SALES_LABOUR_PRICE,
			SALES_MATERIAL_PRICE,
			SALES_ENGINEERING_PRICE,
			SALES_MANAGEMENT_PRICE,
			PURCHASE_LABOUR_MONEY,
			PURCHASE_MATERIAL_MONEY,
			PURCHASE_ENGINEERING_MONEY,
			PURCHASE_MANAGEMENT_MONEY,
			SALES_LABOUR_MONEY,
			SALES_MATERIAL_MONEY,
			SALES_ENGINEERING_MONEY,
			SALES_MANAGEMENT_MONEY,
			PURCHASE_LABOUR_UNIT_ID,
			PURCHASE_MATERIAL_UNIT_ID,
			PURCHASE_ENGINEERING_UNIT_ID,
			PURCHASE_MANAGEMENT_UNIT_ID,
			SALES_LABOUR_UNIT_ID,
			SALES_MATERIAL_UNIT_ID,
			SALES_ENGINEERING_UNIT_ID,
			SALES_MANAGEMENT_UNIT_ID,
			PURCHASE_LABOUR_AMOUNT,
			PURCHASE_MATERIAL_AMOUNT,
			PURCHASE_ENGINEERING_AMOUNT,
			PURCHASE_MANAGEMENT_AMOUNT,
			SALES_LABOUR_AMOUNT,
			SALES_MATERIAL_AMOUNT,
			SALES_ENGINEERING_AMOUNT,
			SALES_MANAGEMENT_AMOUNT
		)
	VALUES
		(
			#attributes.pbs_id#,
			<cfif isdefined('attributes.pid_') and len(attributes.pid_)>#attributes.pid_#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.opp_id_') and len(attributes.opp_id_)>#attributes.opp_id_#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.project_id_') and len(attributes.project_id_)>#attributes.project_id_#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.offer_id_') and len(attributes.offer_id_)>#attributes.offer_id_#<cfelse>NULL</cfif>,
			<cfif len(attributes.rel_detail)>'#attributes.rel_detail#'<cfelse>NULL</cfif>,
			<cfif len(attributes.purchase_labour_price)>#attributes.purchase_labour_price#<cfelse>0</cfif>,
			<cfif len(attributes.purchase_material_price)>#attributes.purchase_material_price#<cfelse>0</cfif>,
			<cfif len(attributes.purchase_engineering_price)>#attributes.purchase_engineering_price#<cfelse>0</cfif>,
			<cfif len(attributes.purchase_management_price)>#attributes.purchase_management_price#<cfelse>0</cfif>,
			<cfif len(attributes.sales_labour_price)>#attributes.sales_labour_price#<cfelse>0</cfif>,
			<cfif len(attributes.sales_material_price)>#attributes.sales_material_price#<cfelse>0</cfif>,
			<cfif len(attributes.sales_engineering_price)>#attributes.sales_engineering_price#<cfelse>0</cfif>,
			<cfif len(attributes.sales_management_price)>#attributes.sales_management_price#<cfelse>0</cfif>,
			'#attributes.purchase_labour_money#',
			'#attributes.purchase_material_money#',
			'#attributes.purchase_engineering_money#',
			'#attributes.purchase_management_money#',
			'#attributes.sales_labour_money#',
			'#attributes.sales_material_money#',
			'#attributes.sales_engineering_money#',
			'#attributes.sales_management_money#',
			#attributes.purchase_labour_unit_id#,
			#attributes.purchase_material_unit_id#,
			#attributes.purchase_engineering_unit_id#,
			#attributes.purchase_management_unit_id#,
			#attributes.sales_labour_unit_id#,
			#attributes.sales_material_unit_id#,
			#attributes.sales_engineering_unit_id#,
			#attributes.sales_management_unit_id#,
			<cfif len(attributes.purchase_labour_amount)>#attributes.purchase_labour_amount#<cfelse>0</cfif>,
			<cfif len(attributes.purchase_material_amount)>#attributes.purchase_material_amount#<cfelse>0</cfif>,
			<cfif len(attributes.purchase_engineering_amount)>#attributes.purchase_engineering_amount#<cfelse>0</cfif>,
			<cfif len(attributes.purchase_management_amount)>#attributes.purchase_management_amount#<cfelse>0</cfif>,
			<cfif len(attributes.sales_labour_amount)>#attributes.sales_labour_amount#<cfelse>0</cfif>,
			<cfif len(attributes.sales_material_amount)>#attributes.sales_material_amount#<cfelse>0</cfif>,
			<cfif len(attributes.sales_engineering_amount)>#attributes.sales_engineering_amount#<cfelse>0</cfif>,
			<cfif len(attributes.sales_management_amount)>#attributes.sales_management_amount#<cfelse>0</cfif>
		)
</cfquery>

<!--- urunle iliskili aktif firsatlar ve gundemdeki projelere eklenecek pbs ler--->
<cfif isdefined('attributes.pid_') and len(attributes.pid_)>
	<cfquery name="getProductPBS" datasource="#dsn3#">
		SELECT PBS_ID FROM RELATION_PBS_CODE WHERE PRODUCT_ID = #attributes.pid_#
	</cfquery>
	
	<!--- urunle iliskili proje --->
	<cfquery name="getProductProje" datasource="#dsn3#">
		SELECT PROJECT_ID FROM #dsn_alias#.PRO_PROJECTS WHERE PRODUCT_ID = #attributes.pid_# AND PROJECT_STATUS = 1
	</cfquery>
	
	<!--- urunle iliskili aktif firsat --->
	<cfquery name="getProductOpp" datasource="#dsn3#">
		SELECT 
			DISTINCT OPP.OPP_ID
		FROM 
			OPPORTUNITIES OPP,
			STOCKS S
		WHERE 
			S.STOCK_ID = OPP.STOCK_ID AND
			S.PRODUCT_ID = #attributes.pid_# AND
			OPP.OPP_STATUS = 1
	</cfquery>
	
	<cfloop query="getProductPBS">
		<cfloop query="getProductProje">
			<!--- proje pbsleri --->
			<cfquery name="get_rel_pbs_project" datasource="#dsn3#">
				SELECT PBS_ID FROM RELATION_PBS_CODE WHERE PROJECT_ID = #getProductProje.project_id# AND PBS_ID = #getProductPBS.pbs_id#
			</cfquery>
			<cfif get_rel_pbs_project.recordcount eq 0>
				<cfquery name="addRelationPBS" datasource="#dsn3#">
				INSERT INTO
					RELATION_PBS_CODE
					(
						PBS_ID,
						PRODUCT_ID,
						OPPORTUNITY_ID,
						PROJECT_ID,
						OFFER_ID,
						DETAIL,
						PURCHASE_LABOUR_PRICE,
						PURCHASE_MATERIAL_PRICE,
						PURCHASE_ENGINEERING_PRICE,
						PURCHASE_MANAGEMENT_PRICE,
						SALES_LABOUR_PRICE,
						SALES_MATERIAL_PRICE,
						SALES_ENGINEERING_PRICE,
						SALES_MANAGEMENT_PRICE,
						PURCHASE_LABOUR_MONEY,
						PURCHASE_MATERIAL_MONEY,
						PURCHASE_ENGINEERING_MONEY,
						PURCHASE_MANAGEMENT_MONEY,
						SALES_LABOUR_MONEY,
						SALES_MATERIAL_MONEY,
						SALES_ENGINEERING_MONEY,
						SALES_MANAGEMENT_MONEY,
						PURCHASE_LABOUR_UNIT_ID,
						PURCHASE_MATERIAL_UNIT_ID,
						PURCHASE_ENGINEERING_UNIT_ID,
						PURCHASE_MANAGEMENT_UNIT_ID,
						SALES_LABOUR_UNIT_ID,
						SALES_MATERIAL_UNIT_ID,
						SALES_ENGINEERING_UNIT_ID,
						SALES_MANAGEMENT_UNIT_ID,
						PURCHASE_LABOUR_AMOUNT,
						PURCHASE_MATERIAL_AMOUNT,
						PURCHASE_ENGINEERING_AMOUNT,
						PURCHASE_MANAGEMENT_AMOUNT,
						SALES_LABOUR_AMOUNT,
						SALES_MATERIAL_AMOUNT,
						SALES_ENGINEERING_AMOUNT,
						SALES_MANAGEMENT_AMOUNT
					)
					SELECT 
						PBS_ID,
						NULL,
						NULL,
						#getProductProje.project_id#,
						NULL,
						DETAIL,
						PURCHASE_LABOUR_PRICE,
						PURCHASE_MATERIAL_PRICE,
						PURCHASE_ENGINEERING_PRICE,
						PURCHASE_MANAGEMENT_PRICE,
						SALES_LABOUR_PRICE,
						SALES_MATERIAL_PRICE,
						SALES_ENGINEERING_PRICE,
						SALES_MANAGEMENT_PRICE,
						PURCHASE_LABOUR_MONEY,
						PURCHASE_MATERIAL_MONEY,
						PURCHASE_ENGINEERING_MONEY,
						PURCHASE_MANAGEMENT_MONEY,
						SALES_LABOUR_MONEY,
						SALES_MATERIAL_MONEY,
						SALES_ENGINEERING_MONEY,
						SALES_MANAGEMENT_MONEY,
						PURCHASE_LABOUR_UNIT_ID,
						PURCHASE_MATERIAL_UNIT_ID,
						PURCHASE_ENGINEERING_UNIT_ID,
						PURCHASE_MANAGEMENT_UNIT_ID,
						SALES_LABOUR_UNIT_ID,
						SALES_MATERIAL_UNIT_ID,
						SALES_ENGINEERING_UNIT_ID,
						SALES_MANAGEMENT_UNIT_ID,
						PURCHASE_LABOUR_AMOUNT,
						PURCHASE_MATERIAL_AMOUNT,
						PURCHASE_ENGINEERING_AMOUNT,
						PURCHASE_MANAGEMENT_AMOUNT,
						SALES_LABOUR_AMOUNT,
						SALES_MATERIAL_AMOUNT,
						SALES_ENGINEERING_AMOUNT,
						SALES_MANAGEMENT_AMOUNT
					FROM 
						RELATION_PBS_CODE 
					WHERE 
						PRODUCT_ID = #attributes.pid_# AND
						PBS_ID = #getProductPBS.pbs_id#
			</cfquery>
			</cfif>
		</cfloop>
		
		<cfloop query="getProductOpp">
			<!--- firsat pbsleri --->
			<cfquery name="get_rel_pbs_opp" datasource="#dsn3#">
				SELECT PBS_ID FROM RELATION_PBS_CODE WHERE OPPORTUNITY_ID = #getProductOpp.opp_id# AND PBS_ID = #getProductPBS.pbs_id#
			</cfquery>
			<cfif get_rel_pbs_opp.recordcount eq 0>
				<cfquery name="addRelationPBS" datasource="#dsn3#">
				INSERT INTO
					RELATION_PBS_CODE
					(
						PBS_ID,
						PRODUCT_ID,
						OPPORTUNITY_ID,
						PROJECT_ID,
						OFFER_ID,
						DETAIL,
						PURCHASE_LABOUR_PRICE,
						PURCHASE_MATERIAL_PRICE,
						PURCHASE_ENGINEERING_PRICE,
						PURCHASE_MANAGEMENT_PRICE,
						SALES_LABOUR_PRICE,
						SALES_MATERIAL_PRICE,
						SALES_ENGINEERING_PRICE,
						SALES_MANAGEMENT_PRICE,
						PURCHASE_LABOUR_MONEY,
						PURCHASE_MATERIAL_MONEY,
						PURCHASE_ENGINEERING_MONEY,
						PURCHASE_MANAGEMENT_MONEY,
						SALES_LABOUR_MONEY,
						SALES_MATERIAL_MONEY,
						SALES_ENGINEERING_MONEY,
						SALES_MANAGEMENT_MONEY,
						PURCHASE_LABOUR_UNIT_ID,
						PURCHASE_MATERIAL_UNIT_ID,
						PURCHASE_ENGINEERING_UNIT_ID,
						PURCHASE_MANAGEMENT_UNIT_ID,
						SALES_LABOUR_UNIT_ID,
						SALES_MATERIAL_UNIT_ID,
						SALES_ENGINEERING_UNIT_ID,
						SALES_MANAGEMENT_UNIT_ID,
						PURCHASE_LABOUR_AMOUNT,
						PURCHASE_MATERIAL_AMOUNT,
						PURCHASE_ENGINEERING_AMOUNT,
						PURCHASE_MANAGEMENT_AMOUNT,
						SALES_LABOUR_AMOUNT,
						SALES_MATERIAL_AMOUNT,
						SALES_ENGINEERING_AMOUNT,
						SALES_MANAGEMENT_AMOUNT
					)
					SELECT 
						PBS_ID,
						NULL,
						#getProductOpp.opp_id#,
						NULL,
						NULL,
						DETAIL,
						PURCHASE_LABOUR_PRICE,
						PURCHASE_MATERIAL_PRICE,
						PURCHASE_ENGINEERING_PRICE,
						PURCHASE_MANAGEMENT_PRICE,
						SALES_LABOUR_PRICE,
						SALES_MATERIAL_PRICE,
						SALES_ENGINEERING_PRICE,
						SALES_MANAGEMENT_PRICE,
						PURCHASE_LABOUR_MONEY,
						PURCHASE_MATERIAL_MONEY,
						PURCHASE_ENGINEERING_MONEY,
						PURCHASE_MANAGEMENT_MONEY,
						SALES_LABOUR_MONEY,
						SALES_MATERIAL_MONEY,
						SALES_ENGINEERING_MONEY,
						SALES_MANAGEMENT_MONEY,
						PURCHASE_LABOUR_UNIT_ID,
						PURCHASE_MATERIAL_UNIT_ID,
						PURCHASE_ENGINEERING_UNIT_ID,
						PURCHASE_MANAGEMENT_UNIT_ID,
						SALES_LABOUR_UNIT_ID,
						SALES_MATERIAL_UNIT_ID,
						SALES_ENGINEERING_UNIT_ID,
						SALES_MANAGEMENT_UNIT_ID,
						PURCHASE_LABOUR_AMOUNT,
						PURCHASE_MATERIAL_AMOUNT,
						PURCHASE_ENGINEERING_AMOUNT,
						PURCHASE_MANAGEMENT_AMOUNT,
						SALES_LABOUR_AMOUNT,
						SALES_MATERIAL_AMOUNT,
						SALES_ENGINEERING_AMOUNT,
						SALES_MANAGEMENT_AMOUNT
					FROM 
						RELATION_PBS_CODE 
					WHERE 
						PRODUCT_ID = #attributes.pid_# AND
						PBS_ID = #getProductPBS.pbs_id#
			</cfquery>
			</cfif>
		</cfloop>
	</cfloop>
</cfif>
<cfabort>
