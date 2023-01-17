<cf_xml_page_edit fuseact ="report.detail_report_product_tree">
<!--- TolgaS 20080730 üretilen ürünlerin alt kırılımları dahil olmak üzere getiriyor 
get_product_tree(stock_id,main_spec_id) fonksiyonu genel yapılırsa bu sayfadan kaldıracağız--->
<cfparam name="attributes.module_id_control" default="35">
<cfinclude template="report_authority_control.cfm">
<cfsetting showdebugoutput="yes">
<cfscript>
function get_product_tree(stock_id,main_spec_id,product_id)
{
	tr_count=1;
	product_tree_list='#stock_id#;#main_spec_id#;0;1;1;Adet;1;#product_id#';
	deep_level=1;
	while(tr_count lt listlen(product_tree_list,';'))
	{
		pre_stock_id=listgetat(product_tree_list,tr_count,';');
		pre_main_spec_id=listgetat(product_tree_list,tr_count+1,';');
		pre_deep_level=listgetat(product_tree_list,tr_count+2,';');
		pre_is_production=listgetat(product_tree_list,tr_count+3,';');
		pre_is_amount=listgetat(product_tree_list,tr_count+4,';');
		if(pre_is_production)//uretiliyorsa spec yada agac bileşenlerine baksın
		{		
			if(len(pre_main_spec_id) and pre_main_spec_id gt 0)//sepecli ise spec bileşenleri degil ise agac
				SQLStr = 'SELECT STOCKS.PRODUCT_CATID,STOCKS.PRODUCT_ID,SPECT_MAIN_ROW.STOCK_ID RELATED_ID,RELATED_MAIN_SPECT_ID AS SPECT_MAIN_ID,STOCKS.IS_PRODUCTION,SPECT_MAIN_ROW.AMOUNT,PRODUCT_UNIT.ADD_UNIT FROM SPECT_MAIN_ROW,STOCKS,PRODUCT_UNIT WHERE STOCKS.STOCK_ID=SPECT_MAIN_ROW.STOCK_ID AND PRODUCT_UNIT.PRODUCT_ID=STOCKS.PRODUCT_ID AND PRODUCT_UNIT.PRODUCT_UNIT_STATUS=1 AND PRODUCT_UNIT.IS_MAIN=1 AND SPECT_MAIN_ROW.SPECT_MAIN_ID = #pre_main_spec_id# ORDER BY SPECT_MAIN_ROW.LINE_NUMBER,STOCKS.STOCK_CODE';
			else
				SQLStr = 'SELECT STOCKS.PRODUCT_CATID,STOCKS.PRODUCT_ID,PRODUCT_TREE_ID,RELATED_ID,ISNULL(SPECT_MAIN_ID,0) SPECT_MAIN_ID, STOCKS.IS_PRODUCTION,PRODUCT_TREE.AMOUNT,PRODUCT_UNIT.ADD_UNIT FROM PRODUCT_TREE,STOCKS,PRODUCT_UNIT WHERE STOCKS.STOCK_ID=PRODUCT_TREE.RELATED_ID AND PRODUCT_UNIT.PRODUCT_ID=STOCKS.PRODUCT_ID AND PRODUCT_UNIT.PRODUCT_UNIT_STATUS=1 AND PRODUCT_UNIT.IS_MAIN=1 AND PRODUCT_TREE.STOCK_ID = #pre_stock_id# ORDER BY PRODUCT_TREE.LINE_NUMBER,STOCKS.STOCK_CODE';
			sub_query = cfquery(SQLString : SQLStr, Datasource : dsn3);
			if(sub_query.recordcount)
			{
				product_tree_list_gecici='';
				for(list_i=1;list_i lte tr_count;list_i=list_i+8)
				{
					product_tree_list_gecici = listappend(product_tree_list_gecici,listgetat(product_tree_list,list_i,';'),';');
					product_tree_list_gecici = listappend(product_tree_list_gecici,listgetat(product_tree_list,list_i+1,';'),';');
					product_tree_list_gecici = listappend(product_tree_list_gecici,listgetat(product_tree_list,list_i+2,';'),';');
					product_tree_list_gecici = listappend(product_tree_list_gecici,listgetat(product_tree_list,list_i+3,';'),';');
					product_tree_list_gecici = listappend(product_tree_list_gecici,listgetat(product_tree_list,list_i+4,';'),';');
					product_tree_list_gecici = listappend(product_tree_list_gecici,listgetat(product_tree_list,list_i+5,';'),';');
					product_tree_list_gecici = listappend(product_tree_list_gecici,listgetat(product_tree_list,list_i+6,';'),';');
					product_tree_list_gecici = listappend(product_tree_list_gecici,listgetat(product_tree_list,list_i+7,';'),';');
				}
				for (i=1; i lte sub_query.recordcount; i = i+1)
				{
					product_tree_list_gecici = listappend(product_tree_list_gecici,sub_query.RELATED_ID[i],';');
					if(len(sub_query.SPECT_MAIN_ID[i]))product_tree_list_gecici = listappend(product_tree_list_gecici,sub_query.SPECT_MAIN_ID[i],';'); else product_tree_list_gecici = listappend(product_tree_list_gecici,0,';');
					product_tree_list_gecici = listappend(product_tree_list_gecici,pre_deep_level+1,';');
					product_tree_list_gecici = listappend(product_tree_list_gecici,sub_query.IS_PRODUCTION[i],';');
					product_tree_list_gecici = listappend(product_tree_list_gecici,sub_query.AMOUNT[i],';');
					product_tree_list_gecici = listappend(product_tree_list_gecici,sub_query.ADD_UNIT[i],';');
					product_tree_list_gecici = listappend(product_tree_list_gecici,sub_query.PRODUCT_CATID[i],';');
					product_tree_list_gecici = listappend(product_tree_list_gecici,sub_query.PRODUCT_ID[i],';');
				}
				tr_count = tr_count+8;
				for(list_i=tr_count;list_i lt listlen(product_tree_list,';');list_i=list_i+8)
				{
					product_tree_list_gecici = listappend(product_tree_list_gecici,listgetat(product_tree_list,list_i,';'),';');
					product_tree_list_gecici = listappend(product_tree_list_gecici,listgetat(product_tree_list,list_i+1,';'),';');
					product_tree_list_gecici = listappend(product_tree_list_gecici,listgetat(product_tree_list,list_i+2,';'),';');
					product_tree_list_gecici = listappend(product_tree_list_gecici,listgetat(product_tree_list,list_i+3,';'),';');
					product_tree_list_gecici = listappend(product_tree_list_gecici,listgetat(product_tree_list,list_i+4,';'),';');
					product_tree_list_gecici = listappend(product_tree_list_gecici,listgetat(product_tree_list,list_i+5,';'),';');
					product_tree_list_gecici = listappend(product_tree_list_gecici,listgetat(product_tree_list,list_i+6,';'),';');
					product_tree_list_gecici = listappend(product_tree_list_gecici,listgetat(product_tree_list,list_i+7,';'),';');
				}
				product_tree_list=product_tree_list_gecici;
				product_tree_list_gecici='';
			}else{tr_count = tr_count+8;}
		}else{tr_count = tr_count+8;}
	}
	return product_tree_list;
}
</cfscript>
<cfquery name="GET_BRANDS" datasource="#dsn1#"><!--- Markalar --->
	SELECT
		PB.*
	FROM
		PRODUCT_BRANDS PB,
		PRODUCT_BRANDS_OUR_COMPANY PBO
	WHERE
		PB.BRAND_ID = PBO.BRAND_ID
		AND PBO.OUR_COMPANY_ID =  #session.ep.company_id# 
	ORDER BY 
		BRAND_NAME
</cfquery>
<cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
	SELECT 
		PRODUCT_CAT.PRODUCT_CATID, 
		PRODUCT_CAT.HIERARCHY, 
		PRODUCT_CAT.PRODUCT_CAT
	FROM 
		PRODUCT_CAT,
		PRODUCT_CAT_OUR_COMPANY PCO
	WHERE 
		PRODUCT_CAT.PRODUCT_CATID = PCO.PRODUCT_CATID AND
		PCO.OUR_COMPANY_ID = #session.ep.company_id#
	ORDER BY 
		HIERARCHY
</cfquery>
<cfparam name="attributes.stock_name" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.spect_main_id" default="">
<cfparam name="attributes.spect_name" default="">
<cfparam name="attributes.report_type" default="">
<cfparam name="attributes.short_code_id" default="">
<cfparam name="attributes.operation_type" default="">
<cfif isdefined('attributes.is_form_submited')>
	<cfquery name="GET_STOCKS" datasource="#DSN3#">
		SELECT 
			S.STOCK_CODE,
			S.PROPERTY,
			S.BARCOD,
			(S.PRODUCT_NAME + ' ' + ISNULL(S.PROPERTY,'')) PRODUCT_NAME,
			S.PROPERTY,
			S.PRODUCT_ID,
			S.STOCK_ID,
			S.PRODUCT_CATID
		FROM 
			STOCKS S
	</cfquery>
	<cfquery name="GET_PRODUCT" datasource="#DSN3#">
		SELECT 
			S.STOCK_ID,
			S.STOCK_CODE,
			S.PROPERTY,
			S.BARCOD,
			(S.PRODUCT_NAME + ' ' + ISNULL(S.PROPERTY,'')) PRODUCT_NAME,
			S.PROPERTY,
			S.PRODUCT_ID,
			S.PRODUCT_MANAGER,
			PC.PRODUCT_CAT,
			(SELECT TOP 1 SM.SPECT_MAIN_ID FROM SPECT_MAIN SM WHERE SM.STOCK_ID = S.STOCK_ID AND IS_TREE = 1 ORDER BY RECORD_DATE DESC) SPECT_MAIN_ID,
			PU.MAIN_UNIT,
			PR_S.PRICE,
			PR_S.MONEY
		FROM 
			PRODUCT_CAT PC,
			STOCKS S,
			PRODUCT_UNIT PU,
			PRICE_STANDART PR_S
		WHERE
			S.PRODUCT_CATID = PC.PRODUCT_CATID
			AND S.IS_PRODUCTION = 1
			AND PU.PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID 
			AND S.STOCK_ID IN(SELECT PT.STOCK_ID FROM PRODUCT_TREE PT WHERE PT.STOCK_ID IS NOT NULL)
			AND	PR_S.PRODUCT_ID = S.PRODUCT_ID 
			AND	PR_S.PRICESTANDART_STATUS = 1 
			AND	PR_S.PURCHASESALES = 0 
			<cfif len(attributes.stock_id) and len(attributes.stock_name)>
				AND S.STOCK_ID = #attributes.stock_id#
			</cfif>
			<cfif len(attributes.short_code_id)>
				AND S.SHORT_CODE_ID = #attributes.short_code_id#
			</cfif>
			<cfif isdefined('attributes.pos_code') and len(attributes.pos_code)>AND S.PRODUCT_MANAGER IN (#attributes.pos_code#)</cfif> 
			<cfif isdefined('attributes.category')>
				<cfif ListFind(attributes.category,1)>AND S.IS_INVENTORY = 1</cfif>
				<cfif ListFind(attributes.category,3)>AND S.IS_SALES = 1</cfif>
				<cfif ListFind(attributes.category,4)>AND S.IS_PURCHASE = 1</cfif>
				<cfif ListFind(attributes.category,5)>AND S.IS_PROTOTYPE = 1</cfif>
				<cfif ListFind(attributes.category,6)>AND S.IS_INTERNET = 1</cfif>
				<cfif ListFind(attributes.category,8)>AND S.IS_TERAZI = 1</cfif>
				<cfif ListFind(attributes.category,9)>AND S.IS_SERIAL_NO = 1</cfif>
				<cfif ListFind(attributes.category,10)>AND S.IS_ZERO_STOCK = 1</cfif>
				<cfif ListFind(attributes.category,11)>AND S.IS_KARMA = 1</cfif>
				<cfif ListFind(attributes.category,12)>AND S.IS_COST = 1</cfif>
			</cfif>
			<cfif isdefined('attributes.marks') and len(attributes.marks)>AND S.BRAND_ID IN (#attributes.marks#)</cfif>
			<cfif not isDefined("attributes.status")>AND S.PRODUCT_STATUS = 1 
			<cfelseif (isDefined("attributes.status") and (attributes.status neq 2))>AND S.PRODUCT_STATUS = #attributes.status# </cfif>
			<cfif isdefined('attributes.cat') and len(attributes.cat)>
				 AND(
				 <cfloop from="1" to="#listlen(attributes.cat)#" index="c"> 
					(S.STOCK_CODE LIKE '#ListGetAt(attributes.cat,c,',')#.%')
					 <cfif C neq listlen(attributes.cat)>OR</cfif>
				</cfloop>)
			</cfif>
		ORDER BY
			S.PRODUCT_NAME
	</cfquery>
	<cfquery name="get_temp_table" datasource="#dsn3#">
		IF object_id('tempdb..##TEMP_PRODUCT_ID') IS NOT NULL
		   BEGIN
			DROP TABLE ##TEMP_PRODUCT_ID 
		   END
	</cfquery>
	<cfquery name="temp_table" datasource="#dsn3#">
		CREATE TABLE ##TEMP_PRODUCT_ID 
		( 
			PRODUCT_ID	int,
			STOCK_ID int
		)
	</cfquery>
	<cfif get_product.recordcount>
		<cfquery name="get_sub_product_main" datasource="#dsn3#">
			<cfoutput query="get_product">
				INSERT INTO ##TEMP_PRODUCT_ID 
				(
					PRODUCT_ID,
					STOCK_ID
				)
				VALUES
				(
					#product_id#,
					#stock_id#
				)
			</cfoutput>
		</cfquery>
	</cfif>
	<cfif isdefined('attributes.is_price') or isdefined('attributes.is_cost') or isdefined('attributes.is_price_cat')>
		<cfif isdefined('attributes.is_price')>
			<cfquery name="get_period_kontrol" datasource="#dsn#">
				SELECT PERIOD_ID FROM SETUP_PERIOD WHERE PERIOD_YEAR < #session.ep.period_year# AND OUR_COMPANY_ID = #session.ep.company_id#
			</cfquery>
			<cfquery name="GET_PURCHASE_COST" datasource="#DSN2#">
				SELECT
					IR.OTHER_MONEY_VALUE / ISNULL(NULLIF(IR.AMOUNT,0),1) PRICE_OTHER,
					IR.OTHER_MONEY,
					IR.STOCK_ID,
					IR.NETTOTAL / ISNULL(NULLIF(IR.AMOUNT,0),1) PRICE
				FROM	
					INVOICE_ROW AS IR,
					INVOICE AS I
				WHERE
					I.PURCHASE_SALES = 0
					AND ISNULL(I.IS_IPTAL,0)=0 
					AND	I.INVOICE_ID = IR.INVOICE_ID
					AND I.INVOICE_ID = ( 
						SELECT TOP 1
							II.INVOICE_ID
						FROM	
							INVOICE_ROW AS IRR,
							INVOICE AS II
						WHERE
							II.PURCHASE_SALES = 0
							AND II.INVOICE_CAT IN (59,591)
							AND ISNULL(II.IS_IPTAL,0)=0 
							AND	II.INVOICE_ID = IRR.INVOICE_ID
							AND IRR.STOCK_ID = IR.STOCK_ID
						ORDER BY
							II.INVOICE_DATE DESC
					)
					<cfif attributes.report_type eq 2 and get_product.recordcount>
						AND IR.STOCK_ID IN(SELECT STOCK_ID FROM ##TEMP_PRODUCT_ID)
					</cfif>
				UNION ALL
				SELECT
					SR.COST_PRICE PRICE_OTHER,
					ISNULL(SR.OTHER_MONEY,'#session.ep.money#') OTHER_MONEY,
					SR.STOCK_ID,
					SR.COST_PRICE PRICE
				FROM	
					STOCK_FIS_ROW AS SR,
					STOCK_FIS AS S
				WHERE
					S.FIS_TYPE = 114
					AND	S.FIS_ID = SR.FIS_ID
					AND S.FIS_ID = ( 
						SELECT TOP 1
							SS.FIS_ID
						FROM	
							STOCK_FIS_ROW AS SRR,
							STOCK_FIS AS SS
						WHERE
							SS.FIS_TYPE = 114
							AND	SS.FIS_ID = SRR.FIS_ID
							AND SRR.STOCK_ID = SR.STOCK_ID
						ORDER BY
							SS.FIS_DATE DESC
					)
					AND SR.STOCK_ID NOT IN(
											SELECT
												IR.STOCK_ID
											FROM	
												INVOICE_ROW AS IR,
												INVOICE AS I
											WHERE
												I.PURCHASE_SALES = 0
												AND I.INVOICE_CAT IN (59,591)
												AND ISNULL(I.IS_IPTAL,0)=0 
												AND	I.INVOICE_ID = IR.INVOICE_ID
												AND IR.STOCK_ID IS NOT NULL
										)
					<cfif attributes.report_type eq 2 and get_product.recordcount>
						AND SR.STOCK_ID IN(SELECT STOCK_ID FROM ##TEMP_PRODUCT_ID)
					</cfif>
				<cfif get_period_kontrol.recordcount>
					UNION ALL
						SELECT
							IR.OTHER_MONEY_VALUE / ISNULL(NULLIF(IR.AMOUNT,0),1) PRICE_OTHER,
							IR.OTHER_MONEY,
							IR.STOCK_ID,
							IR.NETTOTAL / ISNULL(NULLIF(IR.AMOUNT,0),1) PRICE
						FROM	
							#dsn#_#session.ep.period_year-1#_#session.ep.company_id#.INVOICE_ROW AS IR,
							#dsn#_#session.ep.period_year-1#_#session.ep.company_id#.INVOICE AS I
						WHERE
							I.PURCHASE_SALES = 0
							AND ISNULL(I.IS_IPTAL,0)=0 
							AND	I.INVOICE_ID = IR.INVOICE_ID
							AND I.INVOICE_ID = ( 
								SELECT TOP 1
									II.INVOICE_ID
								FROM	
									#dsn#_#session.ep.period_year-1#_#session.ep.company_id#.INVOICE_ROW AS IRR,
									#dsn#_#session.ep.period_year-1#_#session.ep.company_id#.INVOICE AS II
								WHERE
									II.PURCHASE_SALES = 0
									AND II.INVOICE_CAT IN (59,591)
									AND ISNULL(II.IS_IPTAL,0)=0 
									AND	II.INVOICE_ID = IRR.INVOICE_ID
									AND IRR.STOCK_ID = IR.STOCK_ID
								ORDER BY
									II.INVOICE_DATE DESC
							)
							<cfif attributes.report_type eq 2 and get_product.recordcount>
								AND IR.STOCK_ID IN(SELECT STOCK_ID FROM ##TEMP_PRODUCT_ID)
							</cfif>
							AND IR.STOCK_ID NOT IN(
											SELECT
												IRRR.STOCK_ID
											FROM	
												INVOICE_ROW AS IRRR,
												INVOICE AS III
											WHERE
												III.PURCHASE_SALES = 0
												AND III.INVOICE_CAT IN (59,591)
												AND ISNULL(III.IS_IPTAL,0)=0 
												AND	III.INVOICE_ID = IRRR.INVOICE_ID
												AND IRRR.STOCK_ID IS NOT NULL
										)
							<cfif isdefined("xml_over_receipt") and xml_over_receipt eq 1>
								AND IR.STOCK_ID NOT IN(
												SELECT
													SRR.STOCK_ID
												FROM	
													STOCK_FIS_ROW AS SRR,
													STOCK_FIS AS SS
												WHERE
													SS.FIS_TYPE = 114
													AND	SS.FIS_ID = SRR.FIS_ID
													AND SRR.STOCK_ID = IR.STOCK_ID
											)
							</cfif>
				</cfif>
			</cfquery>
		<cfelseif isdefined('attributes.is_price_cat')>
			<cfquery name="GET_PURCHASE_COST" datasource="#DSN3#">
				SELECT
					<cfif isdefined('attributes.is_vat_price')>
						PC.PRICE PRICE_OTHER,
						PC.PRICE*SM.RATE2 PRICE,
					<cfelse>
						PC.PRICE_KDV PRICE_OTHER,
						PC.PRICE_KDV*SM.RATE2 PRICE,
					</cfif>
					PC.MONEY OTHER_MONEY,
					PC.PRODUCT_ID,
					ISNULL(PC.SPECT_VAR_ID,0) SPECT_MAIN_ID
				FROM	
					PRICE PC,
					#dsn2_alias#.SETUP_MONEY SM
				WHERE
					PC.MONEY = SM.MONEY
					<cfif isdefined('attributes.is_vat_price')>
						AND PRICE_ID = (SELECT TOP 1 PCC.PRICE_ID FROM PRICE PCC,PRICE_CAT PCCC WHERE PCC.PRICE_CATID = PCCC.PRICE_CATID AND PCCC.IS_PURCHASE=1 AND ISNULL(PC.SPECT_VAR_ID,0) = ISNULL(PCC.SPECT_VAR_ID,0) AND PCC.PRODUCT_ID = PC.PRODUCT_ID ORDER BY PCC.STARTDATE DESC,PCC.PRICE DESC)
					<cfelse>
						AND PRICE_ID = (SELECT TOP 1 PCC.PRICE_ID FROM PRICE PCC WHERE ISNULL(PC.SPECT_VAR_ID,0) = ISNULL(PCC.SPECT_VAR_ID,0) AND PCC.PRODUCT_ID = PC.PRODUCT_ID ORDER BY PCC.STARTDATE DESC,PCC.PRICE_KDV DESC)
					</cfif>
					<cfif attributes.report_type eq 2 and get_product.recordcount>
						AND PC.PRODUCT_ID IN(SELECT PRODUCT_ID FROM ##TEMP_PRODUCT_ID)
					</cfif>
			</cfquery>
		<cfelse>
			<cfquery name="GET_PURCHASE_COST" datasource="#DSN3#">
				SELECT
					(PC.PURCHASE_NET_ALL+PC.PURCHASE_EXTRA_COST) PRICE_OTHER,
					PC.PURCHASE_NET_MONEY OTHER_MONEY,
					PC.PRODUCT_ID,
                    PC.STOCK_ID,
					ISNULL(PC.SPECT_MAIN_ID,0) SPECT_MAIN_ID,
					(PC.PURCHASE_NET_ALL+PC.PURCHASE_EXTRA_COST)*SM.RATE2 PRICE
				FROM	
					PRODUCT_COST PC,
					#dsn2_alias#.SETUP_MONEY SM
				WHERE
					PC.PURCHASE_NET_MONEY = SM.MONEY
					<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
						AND PRODUCT_COST_ID = (SELECT TOP 1 PCC.PRODUCT_COST_ID FROM PRODUCT_COST PCC WHERE ISNULL(PC.SPECT_MAIN_ID,0) = ISNULL(PCC.SPECT_MAIN_ID,0) AND PCC.PRODUCT_ID = PC.PRODUCT_ID ORDER BY PCC.START_DATE DESC,PCC.RECORD_DATE DESC,PCC.PURCHASE_NET_SYSTEM DESC)
						<cfif len(attributes.spect_main_id)>
							AND SPECT_MAIN_ID = #attributes.spect_main_id#
						</cfif>
					<cfelse>
						AND PRODUCT_COST_ID = (SELECT TOP 1 PCC.PRODUCT_COST_ID FROM PRODUCT_COST PCC WHERE PCC.PRODUCT_ID = PC.PRODUCT_ID ORDER BY PCC.START_DATE DESC,PCC.RECORD_DATE DESC,PCC.PURCHASE_NET_SYSTEM DESC)
					</cfif>
					<cfif attributes.report_type eq 2 and get_product.recordcount>
						AND PC.PRODUCT_ID IN(SELECT PRODUCT_ID FROM ##TEMP_PRODUCT_ID)
					</cfif>
			</cfquery>
		</cfif>
		
		<cfoutput query="GET_PURCHASE_COST">
			<cfif isdefined("stock_id")>
				<cfset "price_other_#stock_id#" = price_other>
				<cfset "price_money_#stock_id#" = other_money>
			</cfif>
		</cfoutput>
	</cfif>
</cfif>
<cfscript>
	function get_subs(stock_id,product_tree_id,type,spect_type,rel_spect_id)//type 0 ise sarf 3 ise operasyon
	{//gelen stok id veya spec idye göre alt urunler ve speclerden olusan bir liste yollar
			if(isdefined('attributes.is_price_cat') and isdefined('attributes.is_vat_price'))
			{
				price_cat_parameter = 'ISNULL((SELECT TOP 1
											PC.PRICE PRICE_OTHER
										FROM	
											PRICE PC,
											#dsn2_alias#.SETUP_MONEY SM
										WHERE
											PC.MONEY = SM.MONEY
											AND PRICE_ID = (SELECT TOP 1 PCC.PRICE_ID FROM PRICE PCC,PRICE_CAT PCCC WHERE PCC.PRICE_CATID = PCCC.PRICE_CATID AND PCCC.IS_PURCHASE=1 AND ISNULL(PC.SPECT_VAR_ID,0) = ISNULL(PCC.SPECT_VAR_ID,0) AND PCC.PRODUCT_ID = PC.PRODUCT_ID ORDER BY PCC.STARTDATE DESC,PCC.PRICE DESC)
											AND PC.PRODUCT_ID = STOCKS.PRODUCT_ID),0) AS PURCHASE_COST_OTHER';
				price_cat_parameter2 = 'ISNULL((SELECT TOP 1
											PC.PRICE*SM.RATE2 PRICE
										FROM	
											PRICE PC,
											#dsn2_alias#.SETUP_MONEY SM
										WHERE
											PC.MONEY = SM.MONEY
											AND PRICE_ID = (SELECT TOP 1 PCC.PRICE_ID FROM PRICE PCC,PRICE_CAT PCCC WHERE PCC.PRICE_CATID = PCCC.PRICE_CATID AND PCCC.IS_PURCHASE=1 AND ISNULL(PC.SPECT_VAR_ID,0) = ISNULL(PCC.SPECT_VAR_ID,0) AND PCC.PRODUCT_ID = PC.PRODUCT_ID ORDER BY PCC.STARTDATE DESC,PCC.PRICE DESC)
											AND PC.PRODUCT_ID = STOCKS.PRODUCT_ID),0) AS PURCHASE_COST';
				price_cat_parameter3 = "ISNULL((SELECT TOP 1
											PC.MONEY
										FROM	
											PRICE PC,
											#dsn2_alias#.SETUP_MONEY SM
										WHERE
											PC.MONEY = SM.MONEY
											AND PRICE_ID = (SELECT TOP 1 PCC.PRICE_ID FROM PRICE PCC,PRICE_CAT PCCC WHERE PCC.PRICE_CATID = PCCC.PRICE_CATID AND PCCC.IS_PURCHASE=1 AND ISNULL(PC.SPECT_VAR_ID,0) = ISNULL(PCC.SPECT_VAR_ID,0) AND PCC.PRODUCT_ID = PC.PRODUCT_ID ORDER BY PCC.STARTDATE DESC,PCC.PRICE DESC)
											AND PC.PRODUCT_ID = STOCKS.PRODUCT_ID),'#session.ep.money#') AS PURCHASE_COST_MONEY";
			}
			else if(isdefined('attributes.is_price_cat') and not isdefined('attributes.is_vat_price'))
			{
				price_cat_parameter = 'ISNULL((SELECT TOP 1
											PC.PRICE_KDV PRICE_OTHER
										FROM	
											PRICE PC,
											#dsn2_alias#.SETUP_MONEY SM
										WHERE
											PC.MONEY = SM.MONEY
											AND PRICE_ID = (SELECT TOP 1 PCC.PRICE_ID FROM PRICE PCC WHERE ISNULL(PC.SPECT_VAR_ID,0) = ISNULL(PCC.SPECT_VAR_ID,0) AND PCC.PRODUCT_ID = PC.PRODUCT_ID ORDER BY PCC.STARTDATE DESC,PCC.PRICE_KDV DESC)
											AND PC.PRODUCT_ID = STOCKS.PRODUCT_ID),0) AS PURCHASE_COST_OTHER';
				price_cat_parameter2 = 'ISNULL((SELECT TOP 1
											PC.PRICE_KDV*SM.RATE2 PRICE
										FROM	
											PRICE PC,
											#dsn2_alias#.SETUP_MONEY SM
										WHERE
											PC.MONEY = SM.MONEY
											AND PRICE_ID = (SELECT TOP 1 PCC.PRICE_ID FROM PRICE PCC WHERE ISNULL(PC.SPECT_VAR_ID,0) = ISNULL(PCC.SPECT_VAR_ID,0) AND PCC.PRODUCT_ID = PC.PRODUCT_ID ORDER BY PCC.STARTDATE DESC,PCC.PRICE_KDV DESC)
											AND PC.PRODUCT_ID = STOCKS.PRODUCT_ID),0) AS PURCHASE_COST';
				price_cat_parameter3 = "ISNULL((SELECT TOP 1
											PC.MONEY
										FROM	
											PRICE PC,
											#dsn2_alias#.SETUP_MONEY SM
										WHERE
											PC.MONEY = SM.MONEY
											AND PRICE_ID = (SELECT TOP 1 PCC.PRICE_ID FROM PRICE PCC,PRICE_CAT PCCC WHERE PCC.PRICE_CATID = PCCC.PRICE_CATID AND PCCC.IS_PURCHASE=1 AND ISNULL(PC.SPECT_VAR_ID,0) = ISNULL(PCC.SPECT_VAR_ID,0) AND PCC.PRODUCT_ID = PC.PRODUCT_ID ORDER BY PCC.STARTDATE DESC,PCC.PRICE DESC)
											AND PC.PRODUCT_ID = STOCKS.PRODUCT_ID),'#session.ep.money#') AS PURCHASE_COST_MONEY";
			}
			else
			{	
				price_cat_parameter = '0 AS PURCHASE_COST_OTHER';
				price_cat_parameter2='0 AS PURCHASE_COST';
				price_cat_parameter3="'#session.ep.money#' AS PURCHASE_COST_MONEY";
			}
					
		if(spect_type eq 0)//ağaçtan gelecekse
		{
			if(type eq 0) where_parameter = 'PT.STOCK_ID = #stock_id#'; else where_parameter = 'RELATED_PRODUCT_TREE_ID = #product_tree_id#';
			SQLStr="
					SELECT
						0 AS SPECT_MAIN_ID,
						0 RELATED_MAIN_SPECT_ID,
						0 AS STOCK_ID,
						'-' AS STOCK_CODE,
						'-' AS BARCOD,
						'<font color=purple>'+OP.OPERATION_TYPE+'</font>' AS PRODUCT_NAME,
						'-' AS PROPERTY,
						'-' AS MAIN_UNIT,
						1 AS IS_PRODUCTION,
						0 AS IS_CONFIGURE,
						ISNULL(PT.QUESTION_ID,0) AS QUESTION_ID,
						0 AS PRODUCT_ID,
						ISNULL(PT.AMOUNT,0) AS AMOUNT,
						PT.PRODUCT_TREE_ID,
						ISNULL(PT.IS_SEVK,0) AS IS_SEVK,
						0 AS IS_PHANTOM,
						ISNULL(PT.LINE_NUMBER,0) AS LINE_NUMBER,
						OP.OPERATION_TYPE_ID,
						0 AS PRODUCT_COST,
						0 AS PURCHASE_COST_OTHER,
						0 AS PURCHASE_COST,
						'#session.ep.money#' AS PURCHASE_COST_MONEY,
						'#session.ep.money#' AS COST_MONEY,
						0 AS PRICE,
						'#session.ep.money#' AS MONEY,
						PT.STOCK_ID NEW_STOCK_ID
					FROM 
						OPERATION_TYPES OP,
						PRODUCT_TREE PT
					WHERE 
						OP.OPERATION_TYPE_ID = PT.OPERATION_TYPE_ID AND
						#where_parameter#
			UNION ALL
					SELECT 
						ISNULL(PT.SPECT_MAIN_ID,0) AS SPECT_MAIN_ID,
						0 RELATED_MAIN_SPECT_ID,
						STOCKS.STOCK_ID,
						STOCKS.STOCK_CODE,
						STOCKS.BARCOD,
						(STOCKS.PRODUCT_NAME + ' ' + ISNULL(STOCKS.PROPERTY,'')) PRODUCT_NAME,
						STOCKS.PROPERTY,
						PRODUCT_UNIT.MAIN_UNIT,
						STOCKS.IS_PRODUCTION,
						ISNULL(PT.IS_CONFIGURE,0) AS IS_CONFIGURE,
						ISNULL(PT.QUESTION_ID,0) AS QUESTION_ID,
						STOCKS.PRODUCT_ID,
						ISNULL(PT.AMOUNT,0) AS AMOUNT,
						PT.PRODUCT_TREE_ID,
						ISNULL(PT.IS_SEVK,0) AS IS_SEVK,
						ISNULL(PT.IS_PHANTOM,0) AS IS_PHANTOM,
						ISNULL(PT.LINE_NUMBER,0) AS LINE_NUMBER,
						0 AS OPERATION_TYPE_ID,
						ISNULL((SELECT TOP 1
							PC.PURCHASE_NET_ALL+PC.PURCHASE_EXTRA_COST
							FROM	
								PRODUCT_COST PC,
								#dsn2_alias#.SETUP_MONEY SM
							WHERE
								PC.PURCHASE_NET_MONEY = SM.MONEY
								AND PRODUCT_COST_ID = (SELECT TOP 1 PCC.PRODUCT_COST_ID FROM PRODUCT_COST PCC WHERE ISNULL(PC.SPECT_MAIN_ID,0) = ISNULL(PCC.SPECT_MAIN_ID,0) AND PCC.PRODUCT_ID = STOCKS.PRODUCT_ID AND PCC.PRODUCT_ID = PC.PRODUCT_ID ORDER BY PCC.START_DATE DESC,PCC.RECORD_DATE DESC,PCC.PURCHASE_NET_SYSTEM DESC)
								AND PC.PRODUCT_ID = STOCKS.PRODUCT_ID
							ORDER BY
								PRODUCT_COST_ID DESC
						),0) AS PRODUCT_COST,
						#price_cat_parameter#,	
						#price_cat_parameter2#,		
						#price_cat_parameter3#,
						ISNULL((SELECT TOP 1
							PURCHASE_NET_MONEY
						FROM	
							PRODUCT_COST PC,
							#dsn2_alias#.SETUP_MONEY SM
						WHERE
							PC.PURCHASE_NET_MONEY = SM.MONEY
							AND PRODUCT_COST_ID = (SELECT TOP 1 PCC.PRODUCT_COST_ID FROM PRODUCT_COST PCC WHERE ISNULL(PC.SPECT_MAIN_ID,0) = ISNULL(PCC.SPECT_MAIN_ID,0) AND PCC.PRODUCT_ID = STOCKS.PRODUCT_ID AND PCC.PRODUCT_ID = PC.PRODUCT_ID ORDER BY PCC.START_DATE DESC,PCC.RECORD_DATE DESC,PCC.PURCHASE_NET_SYSTEM DESC)
							AND PC.PRODUCT_ID = STOCKS.PRODUCT_ID
						ORDER BY
								PRODUCT_COST_ID DESC
						),'#session.ep.money#') AS COST_MONEY,
						PR_S.PRICE,
						PR_S.MONEY,
						PT.STOCK_ID NEW_STOCK_ID
					FROM
						STOCKS,
						PRODUCT_TREE PT,
						PRODUCT_UNIT,
						PRICE_STANDART PR_S
					WHERE
						PRODUCT_UNIT.PRODUCT_UNIT_ID = PT.UNIT_ID AND
						PT.RELATED_ID = STOCKS.STOCK_ID AND
						PR_S.PRODUCT_ID = STOCKS.PRODUCT_ID AND
						PR_S.PRICESTANDART_STATUS = 1 AND
						PR_S.PURCHASESALES = 0 AND
						#where_parameter#
				 ORDER BY NEW_STOCK_ID,SPECT_MAIN_ID	
			";
		}
		else
		{
			where_parameter = 'PT.SPECT_MAIN_ID = #rel_spect_id#';;
			SQLStr="
					SELECT
						0 AS SPECT_MAIN_ID,
						ISNULL(PT.RELATED_MAIN_SPECT_ID,0) AS RELATED_MAIN_SPECT_ID,
						0 AS STOCK_ID,
						'-' AS STOCK_CODE,
						'-' AS BARCOD,
						'<font color=purple>'+OP.OPERATION_TYPE+'</font>' AS PRODUCT_NAME,
						'-' AS PROPERTY,
						'-' AS MAIN_UNIT,
						1 AS IS_PRODUCTION,
						0 AS IS_CONFIGURE,
						ISNULL(PT.QUESTION_ID,0) AS QUESTION_ID,
						0 AS PRODUCT_ID,
						ISNULL(PT.AMOUNT,0) AS AMOUNT,
						ISNULL(PT.RELATED_TREE_ID,0) PRODUCT_TREE_ID,
						ISNULL(PT.IS_SEVK,0) AS IS_SEVK,
						0 AS IS_PHANTOM,
						ISNULL(PT.LINE_NUMBER,0) AS LINE_NUMBER,
						OP.OPERATION_TYPE_ID,
						0 AS PRODUCT_COST,
						0 AS PURCHASE_COST_OTHER,
						0 AS PURCHASE_COST,
						'#session.ep.money#' AS PURCHASE_COST_MONEY,
						'#session.ep.money#' AS COST_MONEY,
						0 AS PRICE,
						'#session.ep.money#' AS MONEY,
						ISNULL(PT.STOCK_ID,0) NEW_STOCK_ID
					FROM 
						OPERATION_TYPES OP,
						SPECT_MAIN_ROW PT
					WHERE 
						OP.OPERATION_TYPE_ID = PT.OPERATION_TYPE_ID AND
						#where_parameter#
			UNION ALL
					SELECT 
						ISNULL(PT.RELATED_MAIN_SPECT_ID,0) AS SPECT_MAIN_ID,
						ISNULL(PT.RELATED_MAIN_SPECT_ID,0) AS RELATED_MAIN_SPECT_ID,
						STOCKS.STOCK_ID,
						STOCKS.STOCK_CODE,
						STOCKS.BARCOD,
						STOCKS.PRODUCT_NAME,
						STOCKS.PROPERTY,
						PRODUCT_UNIT.MAIN_UNIT,
						STOCKS.IS_PRODUCTION,
						ISNULL(PT.IS_CONFIGURE,0) AS IS_CONFIGURE,
						ISNULL(PT.QUESTION_ID,0) AS QUESTION_ID,
						STOCKS.PRODUCT_ID,
						ISNULL(PT.AMOUNT,0) AS AMOUNT,
						ISNULL(PT.RELATED_TREE_ID,0) PRODUCT_TREE_ID,
						ISNULL(PT.IS_SEVK,0) AS IS_SEVK,
						ISNULL(PT.IS_PHANTOM,0) AS IS_PHANTOM,
						ISNULL(PT.LINE_NUMBER,0) AS LINE_NUMBER,
						0 AS OPERATION_TYPE_ID,
						ISNULL((SELECT TOP 1
							PC.PURCHASE_NET_ALL+PC.PURCHASE_EXTRA_COST
							FROM	
								PRODUCT_COST PC,
								#dsn2_alias#.SETUP_MONEY SM
							WHERE
								PC.PURCHASE_NET_MONEY = SM.MONEY
								AND PRODUCT_COST_ID = (SELECT TOP 1 PCC.PRODUCT_COST_ID FROM PRODUCT_COST PCC WHERE ISNULL(PC.SPECT_MAIN_ID,0) = ISNULL(PCC.SPECT_MAIN_ID,0) AND PCC.PRODUCT_ID = STOCKS.PRODUCT_ID AND PCC.PRODUCT_ID = PC.PRODUCT_ID ORDER BY PCC.START_DATE DESC,PCC.RECORD_DATE DESC,PCC.PURCHASE_NET_SYSTEM DESC)
								AND PC.PRODUCT_ID = STOCKS.PRODUCT_ID
							ORDER BY
								PRODUCT_COST_ID DESC
						),0) AS PRODUCT_COST,
						#price_cat_parameter#,	
						#price_cat_parameter2#,
						#price_cat_parameter3#,
						ISNULL((SELECT TOP 1
							PURCHASE_NET_MONEY
						FROM	
							PRODUCT_COST PC,
							#dsn2_alias#.SETUP_MONEY SM
						WHERE
							PC.PURCHASE_NET_MONEY = SM.MONEY
							AND PRODUCT_COST_ID = (SELECT TOP 1 PCC.PRODUCT_COST_ID FROM PRODUCT_COST PCC WHERE ISNULL(PC.SPECT_MAIN_ID,0) = ISNULL(PCC.SPECT_MAIN_ID,0) AND PCC.PRODUCT_ID = STOCKS.PRODUCT_ID AND PCC.PRODUCT_ID = PC.PRODUCT_ID ORDER BY PCC.START_DATE DESC,PCC.RECORD_DATE DESC,PCC.PURCHASE_NET_SYSTEM DESC)
							AND PC.PRODUCT_ID = STOCKS.PRODUCT_ID
						ORDER BY
							PRODUCT_COST_ID DESC
						),'#session.ep.money#') AS COST_MONEY,
						PR_S.PRICE,
						PR_S.MONEY,
						ISNULL(PT.STOCK_ID,0) NEW_STOCK_ID
					FROM
						STOCKS,
						SPECT_MAIN_ROW PT,
						PRODUCT_UNIT,
						PRICE_STANDART PR_S
					WHERE
						PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
						PT.STOCK_ID = STOCKS.STOCK_ID AND
						PR_S.PRODUCT_ID = STOCKS.PRODUCT_ID AND
						PR_S.PRICESTANDART_STATUS = 1 AND
						PR_S.PURCHASESALES = 0 AND
						#where_parameter#
				 ORDER BY RELATED_MAIN_SPECT_ID,LINE_NUMBER
			";
		}
		query1 = cfquery(SQLString : SQLStr, Datasource : dsn3);
		stock_id_ary = '';
		for (str_i=1; str_i lte query1.recordcount; str_i = str_i+1)
		{
			stock_id_ary=listappend(stock_id_ary,query1.STOCK_ID[str_i],'█');
			stock_id_ary=listappend(stock_id_ary,query1.PRODUCT_ID[str_i],'§');
			stock_id_ary=listappend(stock_id_ary,query1.STOCK_CODE[str_i],'§');
			if(len(query1.PROPERTY[str_i]))
				stock_id_ary=listappend(stock_id_ary,query1.PROPERTY[str_i],'§');
			else
				stock_id_ary=listappend(stock_id_ary,'-','§');
			stock_id_ary=listappend(stock_id_ary,query1.PRODUCT_NAME[str_i],'§');
			stock_id_ary=listappend(stock_id_ary,query1.SPECT_MAIN_ID[str_i],'§');
			stock_id_ary=listappend(stock_id_ary,query1.PRODUCT_TREE_ID[str_i],'§');
			stock_id_ary=listappend(stock_id_ary,query1.OPERATION_TYPE_ID[str_i],'§');
			stock_id_ary=listappend(stock_id_ary,query1.AMOUNT[str_i],'§');
			stock_id_ary=listappend(stock_id_ary,query1.IS_CONFIGURE[str_i],'§');
			stock_id_ary=listappend(stock_id_ary,query1.IS_SEVK[str_i],'§');
			stock_id_ary=listappend(stock_id_ary,query1.IS_PHANTOM[str_i],'§');
			stock_id_ary=listappend(stock_id_ary,query1.IS_PRODUCTION[str_i],'§');
			stock_id_ary=listappend(stock_id_ary,query1.LINE_NUMBER[str_i],'§');
			stock_id_ary=listappend(stock_id_ary,query1.QUESTION_ID[str_i],'§');
			if(len(query1.MAIN_UNIT[str_i]))
				stock_id_ary=listappend(stock_id_ary,query1.MAIN_UNIT[str_i],'§');
			else
				stock_id_ary=listappend(stock_id_ary,'-','§');
			stock_id_ary=listappend(stock_id_ary,query1.PRODUCT_COST[str_i],'§');
			stock_id_ary=listappend(stock_id_ary,query1.COST_MONEY[str_i],'§');
			stock_id_ary=listappend(stock_id_ary,query1.PRICE[str_i],'§');
			stock_id_ary=listappend(stock_id_ary,query1.MONEY[str_i],'§');
			stock_id_ary=listappend(stock_id_ary,query1.RELATED_MAIN_SPECT_ID[str_i],'§');
			stock_id_ary=listappend(stock_id_ary,query1.PURCHASE_COST_OTHER[str_i],'§');
			stock_id_ary=listappend(stock_id_ary,query1.PURCHASE_COST[str_i],'§');
			stock_id_ary=listappend(stock_id_ary,query1.PURCHASE_COST_MONEY[str_i],'§');
			if(len(query1.BARCOD[str_i]))
				stock_id_ary=listappend(stock_id_ary,query1.BARCOD[str_i],'§');
			else
			stock_id_ary=listappend(stock_id_ary,'-','§');
		}
		return stock_id_ary;
	}
	
	function writeRow(_next_stock_id_,_n_product_id_,_n_stock_code_,_n_property_,_n_product_name_,_n_spect_main_id_,_n_product_tree_id_,_n_operation_type_id_,_n_amount_,_n_is_confg_,_n_is_sevk_,_n_is_phantom_,_n_is_production_,_n_line_number_,_n_question_id_,_n_main_unit_,_n_prod_cost_,_n_cost_money_,_n_st_price_,_n_price_money_,_n_rel_spect_id_,_n_purchase_cost_other_,_n_purchase_cost_,_n_purchase_cost_money_,amount,_n_barcod_)
	
	{
		if((attributes.operation_type eq 2 and _next_stock_id_ neq 0) or (attributes.operation_type eq 1))
		{
			if((len(attributes.spect_main_id) and len(attributes.spect_name)))
				if(len(_n_rel_spect_id_) and _n_rel_spect_id_ neq 0)
					new_color ='color-gray_new';
				else
					new_color ='color-row';
			else
				if(len(_n_spect_main_id_) and _n_spect_main_id_ neq 0)
					new_color ='color-gray_new';
				else
					new_color ='color-row';
			if(_n_spect_main_id_ eq 0)_n_spect_main_id_= '';
			if(isdefined("attributes.is_cost"))
			{
				if(_n_prod_cost_ eq 0)
					color_ = 'color:##FF0000';
				else
					color_ = 'color: ';
			}
			else if(isdefined('attributes.is_price_cat') or isdefined('attributes.is_vat_price'))
			{
				if(_n_purchase_cost_ eq 0)
					color_ = 'color:##FF0000';
				else
					color_ = 'color: ';
			}
			if(isdefined("attributes.is_cost"))
			{
				if(xml_is_barcod == 1){
					writeoutput('
				<tr height="20" onMouseOut=this.className="#new_color#"; class="#new_color#">
					<td style="">#_n_stock_code_#</td>	
					<td style="">#_n_barcod_#</td>
					<td style="" width="400">#_n_product_name_#</td>
					<td style="">#_n_spect_main_id_#</td>
					<td style="text-align:right;">#tlformat(_n_amount_,8,0)#</td>
					<td style="">#_n_main_unit_#</td>
					<td style="text-align:right;">#tlformat(_n_prod_cost_,session.ep.our_company_info.purchase_price_round_num,0)#</td>
					<td style="">#_n_cost_money_#</td>
					<td style="text-align:right;">#tlformat(_n_st_price_,session.ep.our_company_info.purchase_price_round_num,0)#</td>
					<td style="">#_n_price_money_#</td>
				</tr>
				');
				}
				else{
				writeoutput('
				<tr height="20" onMouseOut=this.className="#new_color#"; class="#new_color#">
					<td style="">#_n_stock_code_#</td>					
					<td style="" width="400">#_n_product_name_#</td>
					<td style="">#_n_spect_main_id_#</td>
					<td style="text-align:right;">#tlformat(_n_amount_,8,0)#</td>
					<td style="">#_n_main_unit_#</td>
					<td style="text-align:right;">#tlformat(_n_prod_cost_,session.ep.our_company_info.purchase_price_round_num,0)#</td>
					<td style="">#_n_cost_money_#</td>
					<td style="text-align:right;">#tlformat(_n_st_price_,session.ep.our_company_info.purchase_price_round_num,0)#</td>
					<td style="">#_n_price_money_#</td>
				</tr>
				');
			}
				
			}
			else
			{
				if(isdefined('attributes.is_price_cat') or isdefined('attributes.is_vat_price'))
				{
					if(xml_is_barcod == 1){
						writeoutput('
						<tr height="20" onMouseOut=this.className="#new_color#"; class="#new_color#">
							<td style="">#_n_stock_code_#</td>	
							<td style="">#_n_barcod_#</td>
							<td style="" width="400">#_n_product_name_#</td>
							<td style="">#_n_spect_main_id_#</td>
							<td style="text-align:right;">#tlformat(_n_amount_,8,0)#</td>
							<td style="">#_n_main_unit_#</td>
							<td style="text-align:right;">#tlformat(_n_st_price_,session.ep.our_company_info.purchase_price_round_num,0)#</td>
							<td style="">#_n_price_money_#</td>
							<td style="text-align:right;">#TLFormat(_n_purchase_cost_other_,session.ep.our_company_info.purchase_price_round_num,0)#</td>
							<td style="text-align:right;">#TLFormat(_n_purchase_cost_other_*_n_amount_,session.ep.our_company_info.purchase_price_round_num,0)#</td>
							<td style="">#_n_purchase_cost_money_#</td>
							<td style="text-align:right;;">#TLFormat(amount*_n_purchase_cost_*_n_amount_,session.ep.our_company_info.purchase_price_round_num,0)#</td>
						</tr>
						');
					}
					else{
					writeoutput('
						<tr height="20" onMouseOut=this.className="#new_color#"; class="#new_color#">
							<td style="">#_n_stock_code_#</td>							
							<td style="" width="400">#_n_product_name_#</td>
							<td style="">#_n_spect_main_id_#</td>
							<td style="text-align:right;">#tlformat(_n_amount_,8,0)#</td>
							<td style="">#_n_main_unit_#</td>
							<td style="text-align:right;">#tlformat(_n_st_price_,session.ep.our_company_info.purchase_price_round_num,0)#</td>
							<td style="">#_n_price_money_#</td>
							<td style="text-align:right;">#TLFormat(_n_purchase_cost_other_,session.ep.our_company_info.purchase_price_round_num,0)#</td>
							<td style="text-align:right;">#TLFormat(_n_purchase_cost_other_*_n_amount_,session.ep.our_company_info.purchase_price_round_num,0)#</td>
							<td style="">#_n_purchase_cost_money_#</td>
							<td style="text-align:right;;">#TLFormat(amount*_n_purchase_cost_*_n_amount_,session.ep.our_company_info.purchase_price_round_num,0)#</td>
						</tr>
						');
					}
				}
				else
				{		
					if(xml_is_barcod == 1){	
					writeoutput('
						<tr height="20" onMouseOut=this.className="#new_color#"; class="#new_color#">
							<td style="">#_n_stock_code_#</td>	
							<td style="">#_n_barcod_#</td>							
							<td style="" width="400">#_n_product_name_#</td>
							<td style="">#_n_spect_main_id_#</td>
							<td style="text-align:right;">#tlformat(_n_amount_,8,0)#</td>
							<td style="">#_n_main_unit_#</td>
							<td style="text-align:right;">#tlformat(_n_st_price_,session.ep.our_company_info.purchase_price_round_num,0)#</td>
							<td style="">#_n_price_money_#</td>
						</tr>
						');
					}
					else{
					writeoutput('
						<tr height="20" onMouseOut=this.className="#new_color#"; class="#new_color#">
							<td style="">#_n_stock_code_#</td>							
							<td style="" width="400">#_n_product_name_#</td>
							<td style="">#_n_spect_main_id_#</td>
							<td style="text-align:right;">#tlformat(_n_amount_,8,0)#</td>
							<td style="">#_n_main_unit_#</td>
							<td style="text-align:right;">#tlformat(_n_st_price_,session.ep.our_company_info.purchase_price_round_num,0)#</td>
							<td style="">#_n_price_money_#</td>
						</tr>
						');
					}
				}
			}
		}
	}
	function writeTree(_next_stock_id_,_n_product_tree_id_,type,spect_type,rel_spect_id,amount)
	{
		var i = 1;
		var sub_products = get_subs(_next_stock_id_,_n_product_tree_id_,type,spect_type,rel_spect_id);
		for (i=1; i lte listlen(sub_products,'█'); i = i+1)
		{
			_next_stock_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),1,'§');
			_n_product_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),2,'§');
			_n_stock_code_ = ListGetAt(ListGetAt(sub_products,i,'█'),3,'§');	
			_n_property_ = ListGetAt(ListGetAt(sub_products,i,'█'),4,'§');
			_n_product_name_ = ListGetAt(ListGetAt(sub_products,i,'█'),5,'§');
			_n_spect_main_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),6,'§');
			_n_product_tree_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),7,'§');
			_n_operation_type_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),8,'§');
			_n_amount_ = wrk_round(ListGetAt(ListGetAt(sub_products,i,'█'),9,'§'),8,1);
			_n_is_confg_ = ListGetAt(ListGetAt(sub_products,i,'█'),10,'§');
			_n_is_sevk_ = ListGetAt(ListGetAt(sub_products,i,'█'),11,'§');
			_n_is_phantom_ = ListGetAt(ListGetAt(sub_products,i,'█'),12,'§');
			_n_is_production_ = ListGetAt(ListGetAt(sub_products,i,'█'),13,'§');
			_n_line_number_ = ListGetAt(ListGetAt(sub_products,i,'█'),14,'§');
			_n_question_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),15,'§');
			_n_main_unit_ = ListGetAt(ListGetAt(sub_products,i,'█'),16,'§');
			_n_prod_cost_ = ListGetAt(ListGetAt(sub_products,i,'█'),17,'§');
			_n_cost_money_ = ListGetAt(ListGetAt(sub_products,i,'█'),18,'§');
			_n_st_price_ = ListGetAt(ListGetAt(sub_products,i,'█'),19,'§');
			_n_price_money_ = ListGetAt(ListGetAt(sub_products,i,'█'),20,'§');
			_n_rel_spect_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),21,'§');
			_n_purchase_cost_other_ = ListGetAt(ListGetAt(sub_products,i,'█'),22,'§');
			_n_purchase_cost_ = ListGetAt(ListGetAt(sub_products,i,'█'),23,'§');
			_n_purchase_cost_money_ = ListGetAt(ListGetAt(sub_products,i,'█'),24,'§');
			_n_barcod_ = ListGetAt(ListGetAt(sub_products,i,'█'),25,'§');		
			
			writeRow(_next_stock_id_,_n_product_id_,_n_stock_code_,_n_property_,_n_product_name_,_n_spect_main_id_,_n_product_tree_id_,_n_operation_type_id_,_n_amount_,_n_is_confg_,_n_is_sevk_,_n_is_phantom_,_n_is_production_,_n_line_number_,_n_question_id_,_n_main_unit_,_n_prod_cost_,_n_cost_money_,_n_st_price_,_n_price_money_,_n_rel_spect_id_,_n_purchase_cost_other_,_n_purchase_cost_,_n_purchase_cost_money_,amount,_n_barcod_);
			if(spect_type eq 0)
			{
				if(_n_operation_type_id_ gt 0) type_=3;else type_=0;
				writeTree(_next_stock_id_,_n_product_tree_id_,type_,spect_type,_n_rel_spect_id_,_n_amount_);
			}
			else
			{
				if(_n_rel_spect_id_ gt 0)
					writeTree(_next_stock_id_,_n_product_tree_id_,0,spect_type,_n_rel_spect_id_,_n_amount_);
			}
		}
	}
</cfscript>

<cfquery name="get_money" datasource="#dsn2#">
	SELECT * FROM SETUP_MONEY
</cfquery>
<cfoutput query="get_money">
	<cfset "row_total_#money#" = 0>
	<cfset "all_total_#money#" = 0>
</cfoutput>
<cfset row_total = 0>
<cfset all_total = 0>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfif isdefined("get_product")>
	<cfparam name="attributes.totalrecords" default='#get_product.recordcount#'>
<cfelse>
	<cfset attributes.totalrecords=''>
</cfif>
<cfset attributes.startrow = (((attributes.page-1)*attributes.maxrows)) + 1>
<cfsavecontent variable="title"><cf_get_lang dictionary_id='39926.Ürün Ağacı Raporu'></cfsavecontent>
<cf_report_list_search title="#title#">
	<cf_report_list_search_area>
		<cfform name="list_product" method="post" action="">
				<div class="row">
					<div class="col col-12 col-xs-12">
						<div class="row formContent">
							<div class="row" type="row">
								<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='57486.Kategori'></label>
										<div class="col col-12 col-xs-12 ">
											<select name="cat" id="cat" multiple>
												<cfoutput query="get_product_cat">
													<cfif listlen(HIERARCHY,".") lte 6>
													<option value="#HIERARCHY#" <cfif isdefined('attributes.cat') and listfind(attributes.cat,HIERARCHY)>selected</cfif>>#HIERARCHY#-#product_cat#</option>
													</cfif>
												</cfoutput>
											</select>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58847.Marka'></label>
										<div class="col col-12 col-xs-12">
											<select name="marks" id="marks" multiple>
												<cfoutput query="GET_BRANDS">
												<option value="#BRAND_ID#"<cfif isdefined('attributes.marks') and listfind(attributes.marks,BRAND_ID)>selected</cfif>>#BRAND_NAME#</option>
												</cfoutput>
											</select>
										</div>
									</div>
								</div>
								<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='40146.Ürün Özellikleri'></label>
										<div class="col col-12 col-xs-12">
											<select name="category" id="category" multiple>
												<option value="1" <cfif isdefined('attributes.category') and ListFind(attributes.category,1)>selected</cfif>><cf_get_lang dictionary_id ='39441.Envantere Dahil'></option><!--- is_inventory --->
												<option value="3" <cfif isdefined('attributes.category') and ListFind(attributes.category,3)>selected</cfif>><cf_get_lang dictionary_id ='40149.Satışda'></option><!---is_SALES  --->
												<option value="4" <cfif isdefined('attributes.category') and ListFind(attributes.category,4)>selected</cfif>><cf_get_lang dictionary_id ='40151.Tedarik Ediliyor'></option><!--- is_purchase --->
												<option value="5" <cfif isdefined('attributes.category') and ListFind(attributes.category,5)>selected</cfif>><cf_get_lang dictionary_id ='40152.Özelleştirilebilir'></option><!--- IS_PROTOTYPE --->
												<option value="6" <cfif isdefined('attributes.category') and ListFind(attributes.category,6)>selected</cfif>><cf_get_lang dictionary_id ='40154.Internetde Satılıyor'></option><!---IS_INTERNET  --->
												<option value="8" <cfif isdefined('attributes.category') and ListFind(attributes.category,8)>selected</cfif>><cf_get_lang dictionary_id ='37067.Teraziye Gidiyor'></option><!--- IS_TERAZI --->
												<option value="9" <cfif isdefined('attributes.category') and ListFind(attributes.category,9)>selected</cfif>><cf_get_lang dictionary_id ='40158.Seri No Takibi Yapılıyor'></option><!--- is_serial_no --->
												<option value="10" <cfif isdefined('attributes.category') and ListFind(attributes.category,10)>selected</cfif>><cf_get_lang dictionary_id ='40159.Sıfır Stok'></option><!---IS_ZERO_STOCK  --->
												<option value="12" <cfif isdefined('attributes.category') and ListFind(attributes.category,12)>selected</cfif>><cf_get_lang dictionary_id ='40160.Maliyet Takibi Yapılıyor'></option><!---IS_COST  --->
											</select>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58448.Ürün Sorumlusu'></label>
										<div class="col col-12 col-xs-12">
											<select name="pos_code" id="pos_code" style="width:170px;height:72px" multiple>
												<cfif isdefined('attributes.pos_code') and len(attributes.pos_code)>
													<cfloop from="1" to="#listlen(attributes.pos_code)#" index="i">
													<cfoutput>
														<option value="#listgetat(attributes.pos_code, i, ',')#">#get_emp_info(listgetat(attributes.pos_code, i, ','),1,0)#</option>
													</cfoutput>
													</cfloop>
												</cfif>
											</select>
											<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_multi_pars&field_name=list_product.pos_code&select_list=1&is_upd=0&is_multiple=1','list');"><img src="/images/plus_list.gif" border="0" align="top" title="<cf_get_lang dictionary_id ='57582.Ekle'>"></a>
                                			<a href="javascript://" onclick="remove_field('pos_code');"><img src="/images/delete_list.gif" border="0" title="Sil" style="cursor=hand" align="top"></a>
                            			</div>
									</div>
								</div>
								<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='57657.Ürün'></label>
										<div class="col col-12 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="stock_id" id="stock_id" value="<cfoutput>#attributes.stock_id#</cfoutput>">
												<input type="hidden" name="product_id" id="product_id" value="<cfoutput>#attributes.product_id#</cfoutput>">
												<cfinput type="text" name="stock_name" id="stock_name" value="#attributes.stock_name#" onFocus="AutoComplete_Create('stock_name','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','STOCK_ID,PRODUCT_ID','stock_id,product_id','','3','225');" autocomplete="off">
												<span class="input-group-addon btnPointer icon-ellipsis"  onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=list_product.stock_id&product_id=list_product.product_id&field_name=list_product.stock_name','list');"></span>
											</div>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='57647.Spec'></label>
										<div class="col col-12 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="spect_main_id" id="spect_main_id" value="<cfoutput>#attributes.spect_main_id#</cfoutput>">
												<input type="text" name="spect_name" id="spect_name" value="<cfoutput>#attributes.spect_name#</cfoutput>">
												<span class="input-group-addon btnPointer icon-ellipsis"  onclick="product_control();"></span>
											</div>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="58225.Model"></label>
										<div class="col col-12 col-xs-12">
											<div class="input-group col-12">
												<cf_wrkproductmodel
													returninputvalue="short_code_id,short_code_name"
													returnqueryvalue="MODEL_ID,MODEL_NAME"
													width="150"
													fieldname="short_code_name"
													fieldid="short_code_id"
													compenent_name="getProductModel"            
													boxwidth="300"
													boxheight="150"                        
													model_id="#attributes.short_code_id#">
											</div>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57756.Durum'></label>
										<div class="col col-12 col-xs-12">
											<select name="status" id="status">
												<option value="1" <cfif isdefined('attributes.status') and attributes.status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
												<option value="0" <cfif isdefined('attributes.status') and attributes.status eq 0>selected </cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
												<option value="2" <cfif isdefined('attributes.status') and attributes.status eq 2>selected</cfif>><cf_get_lang dictionary_id ='57708.Tümü'></option>
											</select>
										</div>
									</div>
								</div>
								<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58960.Rapor Tipi'></label>
										<div class="col col-12 col-xs-12">
											<select name="report_type" onchange="kontrol_type();">
												<option value="1" <cfif isdefined("attributes.report_type") and attributes.report_type eq 1>selected</cfif>><cf_get_lang dictionary_id="29794.Yatay"></option>
												<option value="2" <cfif isdefined("attributes.report_type") and attributes.report_type eq 2>selected</cfif>><cf_get_lang dictionary_id="29793.Dikey"></option>
											</select>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="29419.Operasyon"></label>
										<div class="col col-12 col-xs-12">
											<select name="operation_type">
												<option value="1" <cfif isdefined("attributes.operation_type") and attributes.operation_type eq 1>selected</cfif>><cf_get_lang dictionary_id="39818.Operasyonlu"></option>
												<option value="2" <cfif isdefined("attributes.operation_type") and attributes.operation_type eq 2>selected</cfif>><cf_get_lang dictionary_id="39819.Operasyonsuz"></option>
											</select>
										</div>
									</div>
									<div class="form-group">
											<div class="col col-12 col-xs-12">
												<label><cf_get_lang dictionary_id ='40260.Son Alış Fiyatı'><cf_get_lang dictionary_id='58596.Göster'><input type="checkbox" name="is_price" id="is_price" onclick="check_price(1);" value="1" <cfif isdefined('attributes.is_price')>checked</cfif>></label><br />
												<label><cf_get_lang dictionary_id ="39801.Son Girilen Fiyatı Göster"><input type="checkbox" name="is_price_cat" id="is_price_cat" onclick="check_price(3);" value="1" <cfif isdefined('attributes.is_price_cat')>checked</cfif>></label><br />
												<label><cf_get_lang dictionary_id ='39086.Maliyet Göster'><input type="checkbox" name="is_cost" id="is_cost" onclick="check_price(2);" value="1" <cfif isdefined('attributes.is_cost')>checked</cfif>></label><br />
												<label><cf_get_lang dictionary_id ="40031.KDV siz Alış Fiyatı Göster"><input type="checkbox" name="is_vat_price" id="is_vat_price" value="1" <cfif isdefined('attributes.is_vat_price')>checked</cfif>></label>
											</div>
										</div>
								</div>
							</div>
						</div>
						<div class="row ReportContentBorder">
							<div class="ReportContentFooter">
								<label><cf_get_lang dictionary_id ='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>checked</cfif>></label>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
								<cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
									<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" message="#message#" onKeyUp="isNumber(this)" maxlength="3" style="width:25px;">
								<cfelse>
									<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" onKeyUp="isNumber(this)" message="#message#" maxlength="3" style="width:25px;">
								</cfif>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57911.Çalıştır'></cfsavecontent>
								<input name="is_form_submited" id="is_form_submited" type="hidden" value="1">
								<cf_wrk_report_search_button search_function='input_control()' insert_info='#message#' button_type="1" is_excel='1'>
							</div>
						</div>
					</div>
				</div>
		</cfform>
	</cf_report_list_search_area>
</cf_report_list_search>
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
	<cfset filename="report_product_tree#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-8">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</cfif>        
<cfif isdefined('attributes.is_excel') and  attributes.is_excel eq 1>
	<cfset attributes.startrow=1>
	<cfset attributes.maxrows=get_product.recordcount>
</cfif>
<cfif isdefined("attributes.is_form_submited")>
	<cf_report_list>
		<cfif attributes.report_type eq 1>				
			<thead>
				<tr>
					<th <cfif xml_is_barcod eq 1>colspan="3"<cfelse>colspan="2"</cfif> height="20" style="text-align:center;"><cf_get_lang dictionary_id ='40161.Ana Ürün'></th>
					<th <cfif isdefined('attributes.is_price') or isdefined('attributes.is_cost') or isdefined('attributes.is_price_cat')>colspan="10"<cfelseif xml_is_barcod eq 1>colspan="7"<cfelse> colspan="6"</cfif> class="txtbold" height="20" style="text-align:center;"><cf_get_lang dictionary_id ='40162.Alt Ürünler'></th>
				</tr>
			</thead>
			<cfif isdefined("get_product") and get_product.recordcount>
				<thead>
					<tr>
						<th><cf_get_lang dictionary_id ='57518.Stok Kodu'></th>
						<cfif xml_is_barcod eq 1>
						<th><cf_get_lang dictionary_id ="57633.Barkod"></th>
						</cfif>
						<th><cf_get_lang dictionary_id ='58221.Ürün Adı'></th>
						<th class="text-center"><cf_get_lang dictionary_id ='57518.Stok Kodu'></th>
						<cfif xml_is_barcod eq 1>
						<th class="text-center"><cf_get_lang dictionary_id ="57633.Barkod"></th>
						</cfif>
						<th class="text-center"><cf_get_lang dictionary_id ='58221.Ürün Adı'></th>
						<th class="text-center"><cf_get_lang dictionary_id ='57647.Spec'></th>
						<th class="text-center"><cf_get_lang dictionary_id ='57635.Miktar'></th>
						<th class="text-center"><cf_get_lang dictionary_id ='40163.Toplam Miktar'></th>
						<th class="text-center"><cf_get_lang dictionary_id ='57636.Birim'></th>
						<cfif isdefined('attributes.is_price') or isdefined('attributes.is_cost') or isdefined('attributes.is_price_cat')>
							<cfif isdefined('attributes.is_price')>
								<th class="text-center"><cf_get_lang dictionary_id="39820.Son Alış Birim Fiyatı"></th>
								<th class="text-center"><cf_get_lang dictionary_id="57492.Toplam"> <cf_get_lang dictionary_id="58084.Fiyat"></th>
								<th><cf_get_lang dictionary_id="58474.P Birimi"></th>
								<th class="text-center"><cf_get_lang dictionary_id="57492.Toplam"> <cf_get_lang dictionary_id="58084.Fiyat"> #session.ep.money#</th>
							<cfelseif isdefined('attributes.is_price_cat')>
								<th class="text-center"><cf_get_lang dictionary_id="29398.Son"> <cf_get_lang dictionary_id="58084.Fiyat"></th>
								<th class="text-center"><cf_get_lang dictionary_id="40203.Toplam Maliyet"></th>
								<th><cf_get_lang dictionary_id="58474.P Birimi"></th>
								<th class="text-center"><cf_get_lang dictionary_id="40203.Toplam Maliyet"> #session.ep.money#</th>
							<cfelse>
								<th class="text-center"><cf_get_lang dictionary_id="58258.Maliyet"></th>
								<th class="text-center"><cf_get_lang dictionary_id="40203.Toplam Maliyet"></th>
								<th><cf_get_lang dictionary_id="58474.P Birimi"></th>
								<th class="text-center"><cf_get_lang dictionary_id="40203.Toplam Maliyet"> #session.ep.money#</th>
							</cfif>
						</cfif>
					</tr>
				</thead>
				<cfoutput query="GET_PRODUCT" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">	
					<cfscript>
						if(len(attributes.spect_main_id) and len(attributes.spect_name))
							'product_tree_list_#STOCK_ID#'=get_product_tree(STOCK_ID,attributes.spect_main_id,PRODUCT_ID);
						else
							'product_tree_list_#STOCK_ID#'=get_product_tree(STOCK_ID,0,PRODUCT_ID);
						stock_id_list='';
						spec_id_list='';
						for(c=1;c lte listlen(evaluate('product_tree_list_#STOCK_ID#'),';');c=c+8)
						{
							stock_id_list=listappend(stock_id_list,listgetat(evaluate('product_tree_list_#STOCK_ID#'),c,';'),',');
							spec_id_list=listappend(spec_id_list,listgetat(evaluate('product_tree_list_#STOCK_ID#'),c+1,';'),',');
						}
					</cfscript>
					<tbody>
						<tr>
							<td style="text-align:center;" valign="top" rowspan="<cfif listlen(product_tree_list,';') gt 8>#listlen(evaluate('product_tree_list_#STOCK_ID#'),';')/8#<cfelse>2</cfif>">#STOCK_CODE#</td>
							<cfif xml_is_barcod eq 1>
								<td  style="text-align:center;" valign="top" rowspan="<cfif listlen(product_tree_list,';') gt 8>#listlen(evaluate('product_tree_list_#STOCK_ID#'),';')/8#<cfelse>2</cfif>">#BARCOD#</td>
							</cfif>
							<td style="text-align:center;" valign="top" rowspan="<cfif listlen(product_tree_list,';') gt 8>#listlen(evaluate('product_tree_list_#STOCK_ID#'),';')/8#<cfelse>2</cfif>">#PRODUCT_NAME# #PROPERTY#</td>									
						</tr>							
						<cfif listlen(evaluate('product_tree_list_#STOCK_ID#'),';') gt 8>
							<cfloop from="9" to="#listlen(evaluate('product_tree_list_#STOCK_ID#'),';')#" step="8" index="prd_list_ind">
								<cfscript>
									amount=1;
									row_deep_level=listgetat(product_tree_list,prd_list_ind+2,';');
									'pre_amount_#row_deep_level#'=wrk_round(listgetat(product_tree_list,prd_list_ind+4,';'),8,1);//kademe miktarı
									for(i=1;i lte listgetat(product_tree_list,prd_list_ind+2,';');i=i+1)//miktar için kademe miktarları çarpılıyor
										amount=wrk_round((amount*evaluate('pre_amount_#i#')),8,1);
								</cfscript>		
								<cfquery name="GET_STOCK" dbtype="query">
									SELECT * FROM GET_STOCKS WHERE STOCK_ID=#listgetat(evaluate('product_tree_list_#STOCK_ID#'),prd_list_ind,';')#
								</cfquery>
								<tr>
									<cfif isdefined('attributes.is_price') or isdefined('attributes.is_cost') or isdefined('attributes.is_price_cat')>
										<cfif isdefined('attributes.is_price')>
											<cfquery name="GET_PRICE" dbtype="query">
												SELECT * FROM GET_PURCHASE_COST WHERE STOCK_ID=#listgetat(evaluate('product_tree_list_#STOCK_ID#'),prd_list_ind,';')#
											</cfquery>
										<cfelse>
											<cfquery name="GET_PRICE" dbtype="query">
												SELECT 
													* 
												FROM 
													GET_PURCHASE_COST WHERE 
													PRODUCT_ID=#listgetat(evaluate('product_tree_list_#STOCK_ID#'),prd_list_ind+7,';')#
													<cfif len(listgetat(evaluate('product_tree_list_#STOCK_ID#'),prd_list_ind+1,';'))>
														AND SPECT_MAIN_ID = #listgetat(evaluate('product_tree_list_#STOCK_ID#'),prd_list_ind+1,';')#
													</cfif>
											</cfquery>
										</cfif>
										<cfif GET_PRICE.recordcount and len(GET_PRICE.PRICE_OTHER)>
											<cfset row_price = GET_PRICE.PRICE_OTHER>
											<cfset row_price_system = GET_PRICE.PRICE>
											<cfif listgetat(evaluate('product_tree_list_#STOCK_ID#'),prd_list_ind+2,';')-1 eq 0><!--- ilk kırılım ise--->	
												<cfset "all_total_#GET_PRICE.OTHER_MONEY#" = evaluate("all_total_#GET_PRICE.OTHER_MONEY#")+(GET_PRICE.PRICE_OTHER*amount)>
												<cfset all_total = all_total + row_price_system*amount>
											</cfif>
										<cfelse>
											<cfset row_price = 0>
											<cfset row_price_system = 0>
										</cfif>
									</cfif>
									<td style="">#RepeatString('',listgetat(evaluate('product_tree_list_#STOCK_ID#'),prd_list_ind+2,';')-1)##GET_STOCK.STOCK_CODE#</td>                                    
									<cfif xml_is_barcod eq 1>
									<td style="">#RepeatString('',listgetat(evaluate('product_tree_list_#STOCK_ID#'),prd_list_ind+2,';')-1)##GET_STOCK.BARCOD#</td>
									</cfif>
									<td style="">#RepeatString('',listgetat(evaluate('product_tree_list_#STOCK_ID#'),prd_list_ind+2,';')-1)##GET_STOCK.PRODUCT_NAME#</td>
									<td style=""><cfif listgetat(evaluate('product_tree_list_#STOCK_ID#'),prd_list_ind+1,';') gt 0>#listgetat(evaluate('product_tree_list_#STOCK_ID#'),prd_list_ind+1,';')#</cfif></td>
									<td style="text-align:right;"><cfloop from="1" to="#row_deep_level#" index="indx">#tlformat(wrk_round(evaluate('pre_amount_#indx#'),8,1),8,0)#<cfif indx lt row_deep_level><font color="red">X</font></cfif></cfloop></td>
									<td style="text-align:right; mso-number-format:'0';">#TLFormat(amount,8,0)#</td>
									<td style="">#listgetat(evaluate('product_tree_list_#STOCK_ID#'),prd_list_ind+5,';')#</td>
									<cfif isdefined('attributes.is_price') or isdefined('attributes.is_cost') or isdefined('attributes.is_price_cat')>
										<td style="text-align:right;">#TLFormat(row_price,session.ep.our_company_info.purchase_price_round_num,0)#</td>
										<td style="text-align:right;">
											<cfif GET_PRICE.recordcount>
											<cfset "row_total_#GET_PRICE.OTHER_MONEY#" = evaluate("row_total_#GET_PRICE.OTHER_MONEY#")+(row_price*amount)>
											</cfif>#TLFormat(row_price*amount,session.ep.our_company_info.purchase_price_round_num,0)#</td>
										<td style=""><cfif GET_PRICE.recordcount and len(GET_PRICE.OTHER_MONEY)>#GET_PRICE.OTHER_MONEY#</cfif></td>
										<td style="text-align:right;">
											<cfquery name="GET_MONEY_RATE" dbtype="query">
												SELECT RATE2 FROM get_money WHERE MONEY = '#GET_PRICE.OTHER_MONEY#'												
											</cfquery>
											<cfset tl_total = len(GET_MONEY_RATE.RATE2) ? GET_MONEY_RATE.RATE2 : "1">
											<cfset row_total = row_total + (row_price_system*amount)*tl_total>
											#TLFormat((row_price_system*amount)*tl_total,session.ep.our_company_info.purchase_price_round_num,0)#
										</td>
									</cfif>
								</tr>
							</cfloop>
						<cfelse>
							<tr>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<cfif isdefined('attributes.is_price') or isdefined('attributes.is_cost') or isdefined('attributes.is_price_cat')>
									<td></td>
									<td></td>
									<td></td>
									<td></td>
								</cfif>
							</tr>
						</cfif>
						<cfif isdefined('attributes.is_price') or isdefined('attributes.is_cost') or isdefined('attributes.is_price_cat')>
							<tr>
								<td colspan="1" style="text-align:right;"><cf_get_lang dictionary_id ='40236.Ürün Toplam'></td>
								<td></td>
								<td colspan="7"></td>
								<td style="text-align:right;">
									<cfloop query="get_money">
										<cfif evaluate("row_total_#money#") gt 0>
											#tlformat(evaluate("row_total_#money#"))#<br/>
										</cfif>
									</cfloop>
								</td>
								<td>
									<cfloop query="get_money">
										<cfif evaluate("row_total_#money#") gt 0>
											#money#<br/>
										</cfif>
									</cfloop>
								</td>
								<td style="text-align:right;">
									#tlformat(row_total)#
								</td>
							</tr>
							<cfset row_total = 0>
							<cfloop query="get_money">
								<cfset "row_total_#money#" = 0>
							</cfloop>
						</cfif>
					</tbody>
				</cfoutput>
				<tfoot>
					<cfif isdefined('attributes.is_price') or isdefined('attributes.is_cost') or isdefined('attributes.is_price_cat')>
						<tr>
							<td colspan="1" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id ='39183.Sayfa Toplam'></td>
							<td></td>
							<td colspan="7"></td>
							<td class="txtbold" style="text-align:right;">
								<cfoutput query="get_money">
									<cfif evaluate("all_total_#money#") gt 0>
										#tlformat(evaluate("all_total_#money#"))#<br/>
									</cfif>
								</cfoutput>
							</td>
							<td class="txtbold">
								<cfoutput query="get_money">
									<cfif evaluate("all_total_#money#") gt 0>
										#money#<br/>
									</cfif>
								</cfoutput>
							</td>
							<td class="txtbold" style="text-align:right;">
								<cfoutput>#tlformat(all_total)#</cfoutput>
							</td>
						</tr>
					</cfif>
				</tfoot>
			<cfelse>
				<tbody>
					<tr>
						<td height="20" <cfif isdefined('attributes.is_price') or isdefined('attributes.is_cost') or isdefined('attributes.is_price_cat')>colspan="24"<cfelse>colspan="21"</cfif>>
						<cfif isdefined('attributes.is_form_submited')>
							<cf_get_lang dictionary_id='57484.Kayıt Yok'>!
						<cfelse>
							<cf_get_lang dictionary_id='57701.Filtre Ediniz'> !
						</cfif>
						</td>
					</tr>
				</tbody>		
			</cfif>			
		<cfelse>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id="57518.Stok Kodu"></th>
					<cfif xml_is_barcod eq 1>
					<th><cf_get_lang dictionary_id='57633.Barkod'></th>
					</cfif>
					<th><cf_get_lang dictionary_id="58221.Ürün Adı"></th>
					<th><cf_get_lang dictionary_id="57647.Spec"></th>
					<th><cf_get_lang dictionary_id="57635.Miktar"></th>
					<th><cf_get_lang dictionary_id="57636.Birim"></th>
					<cfif isdefined('attributes.is_cost')>
						<th width="60" style="text-align:center;"><cf_get_lang dictionary_id="58258.Maliyet"></th>
						<th style="text-align:center"><cf_get_lang dictionary_id="57489.Para Birimi"></th>
					</cfif>
					<th width="200"><cf_get_lang dictionary_id="40230.Standart Alış Fiyatı"></th>
					<th style="text-align:center"><cf_get_lang dictionary_id="57489.Para Birimi"></th>
					<cfif isdefined('attributes.is_price_cat')>
						<cfif isdefined('attributes.is_price_cat')>
							<th width="60" style="text-align:center;"><cf_get_lang dictionary_id="46996.Son Fiyat"></th>
							<th width="60" style="text-align:center;"><cf_get_lang dictionary_id="40203.Toplam Maliyet"></th>
							<th width="60"><cf_get_lang dictionary_id="58474.P Birimi"></th>
							<th width="60" style="text-align:center;"><cf_get_lang dictionary_id="40203.Toplam Maliyet"><cfoutput>#session.ep.money#</cfoutput></th>
						</cfif>
					</cfif>
				</tr>
			</thead>
			<cfif isdefined("get_product") and get_product.recordcount>
				<cfif isdefined('attributes.is_excel') and  attributes.is_excel eq 1>
					<cfset attributes.startrow=1>
					<cfset attributes.maxrows=get_product.recordcount>
				</cfif>
				<tbody>
					<cfoutput query="GET_PRODUCT" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif isdefined('attributes.is_price_cat')>
							<cfquery name="GET_PRICE" dbtype="query">
								SELECT 
									* 
								FROM 
									GET_PURCHASE_COST 
								WHERE 
									PRODUCT_ID=#product_id#
									<cfif isdefined('attributes.is_price_cat')>
										<cfif len(spect_main_id)>
											AND SPECT_MAIN_ID = #spect_main_id#
										</cfif>
									</cfif>
							</cfquery>
							<cfif GET_PRICE.recordcount and len(GET_PRICE.PRICE_OTHER)>
								<cfset row_price = GET_PRICE.PRICE_OTHER>
								<cfset row_price_system = GET_PRICE.PRICE>
								<cfset "row_total_#GET_PRICE.OTHER_MONEY#" = evaluate("row_total_#GET_PRICE.OTHER_MONEY#")+(GET_PRICE.PRICE_OTHER)>
								<cfset row_total = row_total + row_price_system>
								<cfset "all_total_#GET_PRICE.OTHER_MONEY#" = evaluate("all_total_#GET_PRICE.OTHER_MONEY#")+(GET_PRICE.PRICE_OTHER)>
								<cfset all_total = all_total + row_price_system>
							<cfelse>
								<cfset row_price = 0>
								<cfset row_price_system = 0>
							</cfif>							
						</cfif>
						<tr>
							<td style="">#STOCK_CODE#</td>
							<cfif xml_is_barcod>
							<td>#BARCOD#</td>
							</cfif>
							<td style=";width:400px;">#product_name#</td>
							<td style="">#spect_main_id#</td>
							<td style="text-align:right;;">#TLFormat(1,session.ep.our_company_info.purchase_price_round_num,0)#</td>
							<td style="">#main_unit#</td>
							<cfif isdefined('attributes.is_cost')>
								<cfif isdefined("price_other_#stock_id#")>
									<td style="text-align:right;">#tlformat(evaluate("price_other_#stock_id#"),session.ep.our_company_info.purchase_price_round_num,0)#</td>
									<td>#evaluate("price_money_#stock_id#")#</td>
								<cfelse>
									<td style="text-align:right;">#tlformat(0,session.ep.our_company_info.purchase_price_round_num,0)#</td>	
									<td>#session.ep.money#</td>	
								</cfif>
							</cfif>
							<td style="text-align:right;;">#tlformat(price,session.ep.our_company_info.purchase_price_round_num,0)#</td>
							<td style="">#money#</td>
							<cfif isdefined('attributes.is_price_cat')>
								<td style="text-align:right;">#TLFormat(row_price,session.ep.our_company_info.purchase_price_round_num,0)#</td>
								<td style="text-align:right;">#TLFormat(row_price,session.ep.our_company_info.purchase_price_round_num,0)#</td>
								<td style=""><cfif GET_PRICE.recordcount and len(GET_PRICE.OTHER_MONEY)>#GET_PRICE.OTHER_MONEY#</cfif></td>
								<td style="text-align:right;">#TLFormat(row_price_system,session.ep.our_company_info.purchase_price_round_num,0)#</td>
							</cfif>
						</tr>
						<cfif (len(attributes.spect_main_id) and len(attributes.spect_name))>
							<cfscript>writeTree(stock_id,'',0,1,attributes.spect_main_id,1);</cfscript>    
						<cfelse>
							<cfscript>writeTree(stock_id,'',0,0,0,1);</cfscript>    
						</cfif>
					
					</cfoutput>
				</tbody>
			<cfelse>
				<tbody>
					<tr>
						<td height="20" <cfif isdefined('attributes.is_cost')>colspan="9"<cfelseif xml_is_barcod eq 1> colspan="8"<cfelse>colspan="11"</cfif>>
							<cfif isdefined('attributes.is_form_submited')>
								<cf_get_lang dictionary_id='57484.Kayıt Yok'>!
							<cfelse>
								<cf_get_lang dictionary_id='57701.Filtre Ediniz '> !
							</cfif>
						</td>
					</tr>
				</tbody>
			</cfif>
		</cfif>
	</cf_report_list>
</cfif>
<cfif isdefined('attributes.totalrecords') and attributes.totalrecords gt attributes.maxrows>
	<cfset url_str = attributes.fuseaction >
    <cfif isdefined('attributes.is_form_submited')>
        <cfset url_str =  "#url_str#&is_form_submited=#attributes.is_form_submited#">
    </cfif>
    <cfif isdefined('attributes.status') and len(attributes.status)>
        <cfset url_str =  "#url_str#&status=#attributes.status#">
    </cfif>

    <cfif isdefined('attributes.cat') and len(attributes.cat)>
        <cfset url_str =  "#url_str#&cat=#attributes.cat#">
    </cfif>
    <cfif isdefined('attributes.category') and len(attributes.category)>
        <cfset url_str =  "#url_str#&category=#attributes.category#">
    </cfif>
    <cfif isdefined('attributes.marks') and len(attributes.marks)>
        <cfset url_str =  "#url_str#&marks=#attributes.marks#">
    </cfif>
    <cfif isdefined('attributes.pos_code') and len(attributes.pos_code)>
        <cfset url_str =  "#url_str#&pos_code=#attributes.pos_code#">
    </cfif>
    <cfif isdefined('attributes.is_price') and len(attributes.is_price)>
        <cfset url_str =  "#url_str#&is_price=#attributes.is_price#">
    </cfif>
    <cfif isdefined('attributes.is_cost') and len(attributes.is_cost)>
        <cfset url_str =  "#url_str#&is_cost=#attributes.is_cost#">
    </cfif>
    <cfif isdefined('attributes.is_price_cat') and len(attributes.is_price_cat)>
        <cfset url_str =  "#url_str#&is_price_cat=#attributes.is_price_cat#">
    </cfif>
    <cfif isdefined('attributes.stock_name') and len(attributes.stock_name)>
        <cfset url_str =  "#url_str#&stock_name=#attributes.stock_name#">
    </cfif>
    <cfif isdefined('attributes.product_id') and len(attributes.product_id)>
        <cfset url_str =  "#url_str#&product_id=#attributes.product_id#">
    </cfif>
    <cfif isDefined('attributes.short_code_id') and len(attributes.short_code_id)>
        <cfset url_str = '#url_str#&short_code_id=#attributes.short_code_id#'>
    </cfif>
    <cfif isdefined('attributes.stock_id') and len(attributes.stock_id)>
        <cfset url_str =  "#url_str#&stock_id=#attributes.stock_id#">
    </cfif>
    <cfif isdefined('attributes.spect_main_id') and len(attributes.spect_main_id)>
        <cfset url_str =  "#url_str#&spect_main_id=#attributes.spect_main_id#">
    </cfif>
    <cfif isdefined('attributes.spect_name') and len(attributes.spect_name)>
        <cfset url_str =  "#url_str#&spect_name=#attributes.spect_name#">
    </cfif>
    <cfif isdefined('attributes.operation_type') and len(attributes.operation_type)>
        <cfset url_str =  "#url_str#&operation_type=#attributes.operation_type#">
    </cfif>
    <cfif isdefined('attributes.report_type') and len(attributes.report_type)>
        <cfset url_str =  "#url_str#&report_type=#attributes.report_type#">
    </cfif>
    <cf_paging 
		page="#attributes.page#" 
		maxrows="#attributes.maxrows#"
		totalrecords="#attributes.totalrecords#"
		startrow="#attributes.startrow#"
		adres="#url_str#">
</cfif>
<script type="text/javascript">
	function product_control(){/*Ürün seçmeden spec seçemesin.*/
		if(document.getElementById('stock_id').value=="" || document.getElementById('stock_name').value == "" ){
			alert("<cf_get_lang dictionary_id='40658.Spec Seçmek İçin Öncelikle Ürün Seçmeniz Gerekmektedir'>");
			return false;
		}
		else
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_main_id=list_product.spect_main_id&field_name=list_product.spect_name&is_display=1&stock_id='+document.getElementById('stock_id').value,'list');
	}
	function input_control()
	{ 
		select_all('pos_code');
		if(document.list_product.is_excel.checked==false)
		{

			document.list_product.action="<cfoutput>#request.self#?fuseaction=report.detail_product_tree_report</cfoutput>";
			return true;
		}
		document.list_product.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_detail_product_tree_report</cfoutput>";
	}
	function select_all(selected_field)
	{
		var m = eval("document.list_product." + selected_field + ".length");
		for(i=0;i<m;i++)
			eval("document.list_product."+selected_field+"["+i+"].selected=true")
	}
	function remove_field(field_option_name)
	{
		field_option_name_value = eval('document.list_product.' + field_option_name);
		for (i=field_option_name_value.options.length-1;i>-1;i--)
		{
			if (field_option_name_value.options[i].selected==true)
				field_option_name_value.options.remove(i);
		}
	}
	function check_price(type)
	{
		if(type == 1 && document.list_product.is_price.checked == true)
		{
			document.list_product.is_cost.checked = false;
			document.list_product.is_price_cat.checked = false;
			document.list_product.is_vat_price.checked = false;
		}
		else if(type == 2 && document.list_product.is_cost.checked == true)
		{
			document.list_product.is_price.checked = false;
			document.list_product.is_price_cat.checked = false;
			document.list_product.is_vat_price.checked = false;
		}
		else if(type == 3 && document.list_product.is_price_cat.checked == true)
		{
			document.list_product.is_price.checked = false;
			document.list_product.is_cost.checked = false;
		}
	}
	function kontrol_type()
	{
		if(document.list_product.report_type.value == 1)
		{
			document.list_product.is_price.disabled = false;
			document.list_product.is_price_cat.disabled = false;
			document.list_product.is_vat_price.disabled = false;
			document.list_product.operation_type.disabled = true;
		}
		else
		{
			document.list_product.is_price.disabled = true;
			//document.list_product.is_price_cat.disabled = true;
			//document.list_product.is_vat_price.disabled = true;
			document.list_product.operation_type.disabled = false;
		}
	}
	kontrol_type();
</script>
