<cfparam name="attributes.module_id_control" default="20,11">
<cfinclude template="report_authority_control.cfm">
<!--- Bu Rapor Kategori Bazında Ürün Cirolarını satis faturalari ve kasa satislarindan verir... --->
<cfparam name="attributes.startdate" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.finishdate" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.procat" default="">
<cfparam name="attributes.hier" default="">
<cfparam name="attributes.branch" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.graph_type_stock" default="pie">
<cfparam name="attributes.graph_type" default="pie">
<cfparam name="attributes.consumer_id_" default="">
<cfparam name="attributes.company_id_" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.is_money2" default="">
<cfparam name="attributes.is_cost" default="">
<cfparam name="attributes.member_cat_type" default="">
<cfparam name="attributes.pos_code" default="">
<cfparam name="attributes.pos_code_text" default="">
<cf_date tarih='attributes.finishdate'>
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1> 
<cf_date tarih='attributes.startdate'>
<cfquery name="GET_COMPANY_CAT" datasource="#DSN#">
	SELECT DISTINCT	
		COMPANYCAT_ID,
		COMPANYCAT
	FROM
		GET_MY_COMPANYCAT
	WHERE
		EMPLOYEE_ID = #session.ep.userid# AND
		OUR_COMPANY_ID = #session.ep.company_id#
	ORDER BY
		COMPANYCAT
</cfquery>
<cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
	SELECT DISTINCT	
		CONSCAT_ID,
		CONSCAT,
		HIERARCHY
	FROM
		GET_MY_CONSUMERCAT
	WHERE
		EMPLOYEE_ID = #session.ep.userid# AND
		OUR_COMPANY_ID = #session.ep.company_id#
	ORDER BY
		HIERARCHY		
</cfquery>
<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH WHERE BRANCH_STATUS = 1 AND COMPANY_ID = #session.ep.company_id# AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
</cfquery>
<cfset department_list = "">
<cfquery name="GET_DEP" datasource="#DSN#">
	SELECT
		DEPARTMENT_ID
	FROM
		DEPARTMENT
	WHERE
	<cfif len(attributes.branch)>
		BRANCH_ID = #attributes.branch#
	<cfelse>
		BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
	</cfif>
</cfquery>
<cfset department_list = ValueList(get_dep.department_id)>
<cfif isdefined("form_varmi")>
	<cfquery name="GET_PRODUCT_CAT_MAIN" datasource="#DSN3#">
		SELECT HIERARCHY, PRODUCT_CATID, PRODUCT_CAT FROM PRODUCT_CAT
	</cfquery>
	<cfquery name="GET_PRODUCT_CAT_2" dbtype="query">
		SELECT 
			* 
		FROM 
			GET_PRODUCT_CAT_MAIN 
		WHERE 
		<cfif not len(attributes.hier)>
			HIERARCHY NOT LIKE '%.%'
		<cfelse>
			HIERARCHY LIKE '#attributes.hier#.%' AND HIERARCHY LIKE '%.%'
		</cfif>	
		ORDER BY
			HIERARCHY ASC
	</cfquery>
	<cfset get_product_cat_3 = QueryNew("HIERARCHY,PRODUCT_CATID,PRODUCT_CAT,LISTE")>
	<cfset ROW_OF_QUERY = 0 >
	<cfoutput query="get_product_cat_2">
		<cfscript>
			ROW_OF_QUERY = ROW_OF_QUERY + 1;
			QueryAddRow(get_product_cat_3,1);
			QuerySetCell(get_product_cat_3,"HIERARCHY","a#LEFT(HIERARCHY,LEN(HIERARCHY))#",ROW_OF_QUERY);
			QuerySetCell(get_product_cat_3,"PRODUCT_CATID","#PRODUCT_CATID#",ROW_OF_QUERY);
			QuerySetCell(get_product_cat_3,"PRODUCT_CAT","#PRODUCT_CAT#",ROW_OF_QUERY);
			QuerySetCell(get_product_cat_3,"LISTE","#ListLen(HIERARCHY,'.')#",ROW_OF_QUERY);
		</cfscript>
	</cfoutput>
	<cfquery name="MIN_LEN" dbtype="query">
		SELECT MIN(LISTE) MIN_UZUNLUK FROM get_product_cat_3 
	</cfquery>
	<cfif min_len.recordcount>
		<cfquery name="GET_PRODUCT_CAT" dbtype="query">
			SELECT 
        	    * 
            FROM 
    	        GET_PRODUCT_CAT_3 
            WHERE 
	            LISTE = #min_len.min_uzunluk# 
            ORDER BY 
            	HIERARCHY
		</cfquery>
	<cfelse>
		<cfquery name="GET_PRODUCT_CAT" dbtype="query">
			SELECT * FROM GET_PRODUCT_CAT_3 ORDER BY HIERARCHY
		</cfquery>
	</cfif>
	<cfset krmsl_uye = ''>
	<cfset brysl_uye = ''>
	<cfif listlen(attributes.member_cat_type)>
		<cfset uzunluk=listlen(attributes.member_cat_type)>
		<cfloop from="1" to="#uzunluk#" index="katyp">
			<cfset kat_list = listgetat(attributes.member_cat_type,katyp,',')>
			<cfif listlen(kat_list) and listfirst(kat_list,'-') eq 1>
				<cfset krmsl_uye = listappend(krmsl_uye,kat_list)>
			<cfelseif listlen(kat_list) and listfirst(kat_list,'-') eq 2>
				<cfset brysl_uye = listappend(brysl_uye,kat_list)>
			</cfif>
		</cfloop>
	</cfif>
	<cfquery name="GET_TOTAL_SALE1" datasource="#DSN2#">
		SELECT
			IR.AMOUNT AS TOTAL_STOCK,
			I.COMPANY_ID COMPANY_ID,
			<cfif attributes.is_money2 eq 1>
				<cfif isdefined("attributes.is_kdv")>
					((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL + (((((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1))*IR.NETTOTAL*IR.TAX)/100)*ISNULL(I.TEVKIFAT_ORAN/100,1))) - (IR.NETTOTAL * ISNULL(I.STOPAJ_ORAN/100,0))) AS TOTAL,
					((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL + (((((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1))*IR.NETTOTAL*IR.TAX)/100)*ISNULL(I.TEVKIFAT_ORAN/100,1))) - (IR.NETTOTAL * ISNULL(I.STOPAJ_ORAN/100,0)))/ IM.RATE2 AS TOTAL_DOVIZ,
				<cfelse>
					((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL) AS TOTAL,
					((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)/IM.RATE2 AS TOTAL_DOVIZ,
				</cfif>
			<cfelse>
				<cfif isdefined("attributes.is_kdv")>
					((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL + (((((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1))*IR.NETTOTAL*IR.TAX)/100)*ISNULL(I.TEVKIFAT_ORAN/100,1))) - (IR.NETTOTAL * ISNULL(I.STOPAJ_ORAN/100,0))) AS TOTAL,
				<cfelse>
					((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL) AS TOTAL,
				</cfif>
			</cfif>
			<cfif attributes.is_cost eq 1>
				ISNULL((
						SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_SYSTEM_ALL+PURCHASE_EXTRA_COST_SYSTEM
						)+ISNULL(PROM_COST,0)
					FROM 
						#dsn3_alias#.PRODUCT_COST PRODUCT_COST
					WHERE 
						PRODUCT_COST.PRODUCT_ID=IR.PRODUCT_ID AND
						ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL((SELECT SPECTS.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID=IR.SPECT_VAR_ID),0) AND
						PRODUCT_COST.START_DATE <= I.INVOICE_DATE
					ORDER BY
						PRODUCT_COST.START_DATE DESC,
						PRODUCT_COST.RECORD_DATE DESC,
						PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
					),0) AS TOTAL_COST,
			</cfif>
			<cfif attributes.is_money2 eq 1 and attributes.is_cost eq 1>
				ISNULL((
						SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_SYSTEM_2_ALL+PURCHASE_EXTRA_COST_SYSTEM_2
						)+ISNULL(PROM_COST,0)
					FROM 
						#dsn3_alias#.PRODUCT_COST PRODUCT_COST
					WHERE 
						PRODUCT_COST.PRODUCT_ID=IR.PRODUCT_ID AND
						ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL((SELECT SPECTS.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID=IR.SPECT_VAR_ID),0) AND
						PRODUCT_COST.START_DATE <= I.INVOICE_DATE
					ORDER BY
						PRODUCT_COST.START_DATE DESC,
						PRODUCT_COST.RECORD_DATE DESC,
						PRODUCT_COST.PURCHASE_NET_SYSTEM_2 DESC
					),0) AS TOTAL_COST_2,
			</cfif>
			I.PURCHASE_SALES,
			IR.PRODUCT_ID
		FROM
			INVOICE I,
			INVOICE_ROW IR
			<cfif attributes.is_money2 eq 1>
				,INVOICE_MONEY IM
			</cfif>
		WHERE
			I.INVOICE_ID = IR.INVOICE_ID AND
			I.INVOICE_CAT  IN (50,52,53,531,532,56,58,561,54,55,51,63,48) AND
			I.IS_IPTAL = 0 AND
			I.NETTOTAL > 0 AND
			(I.INVOICE_DATE BETWEEN #attributes.startdate# AND #attributes.finishdate#) AND
			<cfif attributes.is_money2 eq 1>
				IM.ACTION_ID = I.INVOICE_ID AND
				IM.MONEY_TYPE = '#session.ep.money2#' AND
			</cfif>
			<cfif len(department_list)>
				(I.DEPARTMENT_ID IN (#department_list#))AND	
			</cfif>
			<cfif isdefined("krmsl_uye") and listlen(krmsl_uye)>
				I.COMPANY_ID IN
				(
				SELECT 
					C.COMPANY_ID 
				FROM 
					#dsn_alias#.COMPANY C,
					#dsn_alias#.COMPANY_CAT CAT 
				WHERE 
					C.COMPANYCAT_ID = CAT.COMPANYCAT_ID AND 
					(
					  <cfloop list="#krmsl_uye#" delimiters="," index="comp_i">
						  (CAT.COMPANYCAT_ID = #listlast(comp_i,'-')#)
						  <cfif comp_i neq listlast(krmsl_uye,',') and listlen(krmsl_uye,',') gte 1> OR</cfif>
					  </cfloop>  
					)
				)AND 
			<cfelseif isdefined("brysl_uye") and listlen(brysl_uye)>
				I.CONSUMER_ID IN
					(
					SELECT 
						C.CONSUMER_ID 
					FROM 
						#dsn_alias#.CONSUMER C,
						#dsn_alias#.CONSUMER_CAT CAT 
					WHERE 
						C.CONSUMER_CAT_ID = CAT.CONSCAT_ID AND
						(
							<cfloop list="#brysl_uye#" delimiters="," index="cons_j">
								(CAT.CONSCAT_ID = #listlast(cons_j,'-')#)
								<cfif cons_j neq listlast(brysl_uye,',') and listlen(brysl_uye,',') gte 1> OR</cfif>
							</cfloop>  
						) 
					)AND 
			</cfif>
		<cfif len(attributes.member_name) and len(attributes.company_id_)>
			I.COMPANY_ID = #attributes.company_id_# AND 
		</cfif>
		<cfif len(attributes.member_name) and len(attributes.consumer_id_)>
			I.CONSUMER_ID = #attributes.consumer_id_# AND 
		</cfif>
		<cfif len(trim(attributes.pos_code_text)) and len(attributes.pos_code)>
			I.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = #attributes.pos_code# AND IS_MASTER = 1 AND OUR_COMPANY_ID= #session.ep.company_id#) AND
		</cfif>
			I.PURCHASE_SALES = 1
	</cfquery>
	<cfquery name="GET_TOTAL_SALE2" datasource="#DSN2#">
		SELECT
			(IR.AMOUNT) AS TOTAL_STOCK,
			I.COMPANY_ID COMPANY_ID,
			<cfif attributes.is_money2 eq 1>
				<cfif isdefined("attributes.is_kdv")>
					(IR.GROSSTOTAL-IR.DISCOUNTTOTAL) AS TOTAL,
					0 AS TOTAL_DOVIZ,
				<cfelse>
					(IR.NETTOTAL) AS TOTAL,
					0 AS TOTAL_DOVIZ,
				</cfif>
			<cfelse>
				<cfif isdefined("attributes.is_kdv")>
					(IR.GROSSTOTAL-IR.DISCOUNTTOTAL) AS TOTAL,
				<cfelse>
					(IR.NETTOTAL) AS TOTAL,
				</cfif>
			</cfif>
			<cfif attributes.is_cost eq 1>
				ISNULL(
					(SELECT TOP 1 
						IR.AMOUNT*(PURCHASE_NET_SYSTEM_ALL+PURCHASE_EXTRA_COST_SYSTEM)
					FROM 
						#dsn3_alias#.PRODUCT_COST PRODUCT_COST
					WHERE 
						PRODUCT_COST.PRODUCT_ID=IR.PRODUCT_ID AND
						PRODUCT_COST.START_DATE <= I.INVOICE_DATE
					ORDER BY
						PRODUCT_COST.START_DATE DESC,
						PRODUCT_COST.RECORD_DATE DESC,
						PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
					),0) AS TOTAL_COST,
			</cfif>
			<cfif attributes.is_money2 eq 1 and attributes.is_cost eq 1>
				ISNULL(
					(SELECT TOP 1 
						IR.AMOUNT*(PURCHASE_NET_ALL+PURCHASE_EXTRA_COST)
					FROM 
						#dsn3_alias#.PRODUCT_COST PRODUCT_COST
					WHERE 
						PRODUCT_COST.PRODUCT_ID=IR.PRODUCT_ID AND
						PRODUCT_COST.START_DATE <= I.INVOICE_DATE
					ORDER BY
						PRODUCT_COST.START_DATE DESC,
						PRODUCT_COST.RECORD_DATE DESC,
						PRODUCT_COST.PURCHASE_NET_SYSTEM_2 DESC
					),0) AS TOTAL_COST_2,
			</cfif>
			I.PURCHASE_SALES,
			IR.PRODUCT_ID
		FROM
			INVOICE I,
			INVOICE_ROW_POS IR
		WHERE
			I.INVOICE_ID=IR.INVOICE_ID AND
			(I.INVOICE_DATE BETWEEN #attributes.startdate# AND #attributes.finishdate#) AND
			<cfif len(department_list)>
				(I.DEPARTMENT_ID IN (#department_list#)) AND	
			</cfif>
			<cfif isdefined("krmsl_uye") and listlen(krmsl_uye)>
				I.COMPANY_ID IN
				(
				SELECT 
					C.COMPANY_ID 
				FROM 
					#dsn_alias#.COMPANY C,
					#dsn_alias#.COMPANY_CAT CAT 
				WHERE 
					C.COMPANYCAT_ID = CAT.COMPANYCAT_ID AND 
					(
					  <cfloop list="#krmsl_uye#" delimiters="," index="comp_i">
						  (CAT.COMPANYCAT_ID = #listlast(comp_i,'-')#)
						  <cfif comp_i neq listlast(krmsl_uye,',') and listlen(krmsl_uye,',') gte 1> OR</cfif>
					  </cfloop>  
					)
				)AND 
			<cfelseif isdefined("brysl_uye") and listlen(brysl_uye)>
				I.CONSUMER_ID IN
					(
					SELECT 
						C.CONSUMER_ID 
					FROM 
						#dsn_alias#.CONSUMER C,
						#dsn_alias#.CONSUMER_CAT CAT 
					WHERE 
						C.CONSUMER_CAT_ID = CAT.CONSCAT_ID AND
						(
							<cfloop list="#brysl_uye#" delimiters="," index="cons_j">
								(CAT.CONSCAT_ID = #listlast(cons_j,'-')#)
								<cfif cons_j neq listlast(brysl_uye,',') and listlen(brysl_uye,',') gte 1> OR</cfif>
							</cfloop>  
						) 
					)AND 
			</cfif>
			<cfif len(attributes.member_name) and len(attributes.company_id_)>
				I.COMPANY_ID = #attributes.company_id_# AND 
			</cfif>
			<cfif len(attributes.member_name) and len(attributes.consumer_id_)>
				I.CONSUMER_ID = #attributes.consumer_id_# AND 
			</cfif>
			<cfif len(trim(attributes.pos_code_text)) and len(attributes.pos_code)>
				I.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = #attributes.pos_code# AND IS_MASTER = 1 AND OUR_COMPANY_ID= #session.ep.company_id#) AND
			</cfif>
			I.PURCHASE_SALES = 1
	</cfquery>
	<cfquery name="GET_PRODUCTS" datasource="#DSN3#">
		SELECT
			P.PRODUCT_ID,
			PC.HIERARCHY,
			PC.PRODUCT_CATID
		FROM
			#dsn3_alias#.PRODUCT_CAT PC,
			#dsn3_alias#.PRODUCT P
		WHERE
			P.PRODUCT_CATID = PC.PRODUCT_CATID
		<cfif len(attributes.hier)>
			AND HIERARCHY LIKE '#attributes.hier#%'
			AND HIERARCHY LIKE '%.%'
		</cfif>
		<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company") and len(attributes.company)>
			AND P.COMPANY_ID = #attributes.company_id#
		</cfif>
		GROUP  BY
			P.PRODUCT_ID,
			PC.PRODUCT_CATID,
			PC.HIERARCHY
	</cfquery>
	<cfquery name="GET_TOTAL_SALE3" dbtype="query">
		SELECT
			GET_TOTAL_SALE1.TOTAL_STOCK,
			GET_TOTAL_SALE1.TOTAL,
			GET_TOTAL_SALE1.COMPANY_ID,
			<cfif attributes.is_money2 eq 1>
				GET_TOTAL_SALE1.TOTAL_DOVIZ,
			</cfif>
			<cfif attributes.is_cost eq 1>
				GET_TOTAL_SALE1.TOTAL_COST,
			</cfif>
			<cfif attributes.is_money2 eq 1 and attributes.is_cost eq 1>
				GET_TOTAL_SALE1.TOTAL_COST_2,
			</cfif>
			GET_TOTAL_SALE1.PURCHASE_SALES,
			GET_TOTAL_SALE1.PRODUCT_ID,
			GET_PRODUCTS.HIERARCHY,
			GET_PRODUCTS.PRODUCT_CATID
		FROM 
			GET_TOTAL_SALE1,
			GET_PRODUCTS
		WHERE
			GET_PRODUCTS.PRODUCT_ID = GET_TOTAL_SALE1.PRODUCT_ID
	UNION ALL
		SELECT
			GET_TOTAL_SALE2.TOTAL_STOCK,
			GET_TOTAL_SALE2.TOTAL,
			GET_TOTAL_SALE2.COMPANY_ID,
			<cfif attributes.is_money2 eq 1>
				GET_TOTAL_SALE2.TOTAL_DOVIZ,
			</cfif>
			<cfif attributes.is_cost eq 1>
				GET_TOTAL_SALE2.TOTAL_COST,
			</cfif>
			<cfif attributes.is_money2 eq 1 and attributes.is_cost eq 1>
				GET_TOTAL_SALE2.TOTAL_COST_2,
			</cfif>
			GET_TOTAL_SALE2.PURCHASE_SALES,
			GET_TOTAL_SALE2.PRODUCT_ID,
			GET_PRODUCTS.HIERARCHY,
			GET_PRODUCTS.PRODUCT_CATID
		FROM 
			GET_TOTAL_SALE2,
			GET_PRODUCTS
		WHERE
			GET_PRODUCTS.PRODUCT_ID = GET_TOTAL_SALE2.PRODUCT_ID
	</cfquery>
	<cfquery name="GET_TOTAL_SALE" dbtype="query">
		SELECT
			SUM(TOTAL_STOCK) AS TOTAL_STOCK,
			SUM(TOTAL) AS TOTAL,
			<cfif attributes.is_money2 eq 1>
				SUM(TOTAL_DOVIZ) AS TOTAL_DOVIZ,
			</cfif>
			<cfif attributes.is_cost eq 1>
				SUM(TOTAL_COST) AS TOTAL_COST,
			</cfif>
			<cfif attributes.is_money2 eq 1 and attributes.is_cost eq 1>
				SUM(TOTAL_COST_2) AS TOTAL_COST_2,
			</cfif>
			HIERARCHY,
			PRODUCT_CATID,
			PURCHASE_SALES
		FROM 
			GET_TOTAL_SALE3
		GROUP BY
			PURCHASE_SALES,
			PRODUCT_CATID,
			HIERARCHY		
	</cfquery>
</cfif>
<cfset my_stock_array = ArrayNew(2)>
<cfset pre_cat = "">
<cfset sayac = 0>
<cfif len(attributes.hier)>
	<cfset lookup_hier = listlen(attributes.hier,".")>
</cfif>
<cfset my_area_array = ArrayNew(2)>
<cfset my_purchase_array = ArrayNew(2)>
<cfset sayac = 0>
<cfsavecontent variable="title"><cf_get_lang dictionary_id='39636.Kategori Bazında Satış Analiz Raporu'></cfsavecontent>
<cf_report_list_search id="search" title="#title#">
	<cf_report_list_search_area>
		<cfform name="report_special" action="#request.self#?fuseaction=report.category_base_sale_analyse_report" method="post">
				<div class="row">
					<div class="col col-12 col-xs-12">
						<div class="row formContent">
							<div class="row" type="row">
								<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
									<div class="col col-12 col-xs-12">
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58609.Üye Kategorisi'></label>
											<div class="col col-12 col-xs-12">
												<select name="member_cat_type" id="member_cat_type" style="height:65px;" multiple>
													<optgroup label="<cf_get_lang dictionary_id='58039.Kurumsal Üye Kategorileri'>">
														<cfoutput query="get_company_cat">
															<option value="1-#COMPANYCAT_ID#" <cfif listfind(attributes.member_cat_type,'1-#COMPANYCAT_ID#',',')>selected</cfif>>&nbsp;&nbsp;#COMPANYCAT#</option>
														</cfoutput>						
													</optgroup>
													<optgroup label="<cf_get_lang dictionary_id='58040.Bireysel Üye Kategorileri'>">
														<cfoutput query="get_consumer_cat">
															<option value="2-#CONSCAT_ID#" <cfif listfind(attributes.member_cat_type,'2-#CONSCAT_ID#',',')>selected</cfif>>&nbsp;&nbsp;#CONSCAT#</option>
														</cfoutput>						
													</optgroup>
												</select>		
											</div>
										</div>
									</div>
								</div>
								<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
									<div class="col col-12 col-xs-12">
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='29533.Tedarikçi'></label>
												<div class="col col-12 col-xs-12">
													<div class="input-group">
														<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isDefined("attributes.company") and len(attributes.company)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
														<input type="text" name="company" id="company" style="width:135px;" value="<cfif isdefined("attributes.company_id") and isDefined("attributes.company") and len(attributes.company_id) and len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','company_id','','3','150');">
														<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=report_special.company&field_comp_id=report_special.company_id&select_list=2&keyword='+encodeURIComponent(document.report_special.company.value),'list');"></span>
													</div>
												</div>									
										</div>
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="58795.Müşteri Temsilcisi"></label>
											<div class="col col-12 col-xs-12">
												<div class="input-group">
													<input type="hidden" name="pos_code" id="pos_code" value="<cfif len(attributes.pos_code_text) and len(attributes.pos_code)><cfoutput>#attributes.pos_code#</cfoutput></cfif>">
													<input type="Text" name="pos_code_text" id="pos_code_text" style="width:135px;" value="<cfif len(attributes.pos_code_text) and len(attributes.pos_code)><cfoutput>#get_emp_info(attributes.pos_code,1,0)#</cfoutput></cfif>" onfocus="AutoComplete_Create('pos_code_text','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE','pos_code','','3','130');" autocomplete="off">
													<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=report_special.pos_code&field_name=report_special.pos_code_text&select_list=1,9<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','list')"></span>
												</div>
											</div>									
										</div>
									</div>
								</div>
								<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
									<div class="col col-12 col-xs-12">
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="57457.Müşteri"></label>
												<div class="col col-12 col-xs-12">
													<div class="input-group">
														<input type="hidden" name="consumer_id_" id="consumer_id_" value="<cfoutput>#attributes.consumer_id_#</cfoutput>">
														<input type="hidden" name="company_id_"  id="company_id_" value="<cfoutput>#attributes.company_id_#</cfoutput>">
														<input type="hidden" name="member_type" id="member_type" value="<cfoutput>#attributes.member_type#</cfoutput>">
														<input type="text"   name="member_name" id="member_name" style="width:135px;"  value="<cfoutput>#attributes.member_name#</cfoutput>" onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','COMPANY_ID,CONSUMER_ID,MEMBER_TYPE','company_id_,consumer_id_,member_type','','3','250');" autocomplete="off">
														<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_consumer=report_special.consumer_id_&field_comp_id=report_special.company_id_&field_member_name=report_special.member_name&field_type=report_special.member_type&select_list=7,8&keyword='+encodeURIComponent(document.report_special.member_name.value),'list');"></span>		
													</div>
												</div>									
										</div>
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58690.Tarih Aralığı'>*</label>
												<div class="col col-6">
													<div class="input-group">
														<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
														<cfinput type="text" name="startdate" id="startdate" maxlength="10" value="#dateformat(attributes.startdate,dateformat_style)#" message="#message#" required="yes">
														<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
													</div>
												</div>
												<div class="col col-6">
													<div class="input-group">
														<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
														<cfinput type="text" name="finishdate" id="finishdate" maxlength="10" value="#dateformat(attributes.finishdate,dateformat_style)#" message="#message#" required="yes">
														<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
													</div>
												</div>
										</div>
									</div>
								</div>
								<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
									<div class="col col-12 col-xs-12">
										<div class="form-group">
											<label class="col col-12 col-xs-12"></label><br/>
											<div class="col col-6">
												<input type="hidden" name="hier" id="hier" value="">
												<input type="hidden" name="procat" id="procat" value="">
												<select name="branch" id="branch" class="formthin">
													<option value="" selected><cf_get_lang dictionary_id='57453.Şube'>
													<cfoutput  query="get_branch">
														<option value="#branch_id#"<cfif  attributes.branch eq branch_id > selected</cfif>>#branch_name#</option>
													</cfoutput>
												</select>
											</div>
											<div class="col col-6">
												<select name="graph_type_stock" id="graph_type_stock">
													<option value="pie" <cfif attributes.graph_type_stock eq "pie">selected</cfif>><cf_get_lang dictionary_id ='57668.Pay'></option>
													<option value="bar" <cfif attributes.graph_type_stock eq "bar">selected</cfif>><cf_get_lang dictionary_id ='57663.Bar'></option>
													<option value="line" <cfif attributes.graph_type_stock eq "line">selected</cfif>>Line</option>
													<option value="pyramid" <cfif attributes.graph_type_stock eq "pyramid">selected</cfif>><cf_get_lang dictionary_id ='58655.Piramit'></option>
													<option value="area" <cfif attributes.graph_type_stock eq "area">selected</cfif>><cf_get_lang dictionary_id ='57662.Alan'></option>
													<option value="cone" <cfif attributes.graph_type_stock eq "cone">selected</cfif>><cf_get_lang dictionary_id ='57664.Koni'></option>
													<option value="curve" <cfif attributes.graph_type_stock eq "curve">selected</cfif>><cf_get_lang dictionary_id ='57665.Eğri'></option>
													<option value="cylinder" <cfif attributes.graph_type_stock eq "cylinder">selected</cfif>><cf_get_lang dictionary_id ='57666.Silindir'></option>
													<option value="step" <cfif attributes.graph_type_stock eq "step">selected</cfif>><cf_get_lang dictionary_id ='57667.Cizgi'></option>
													<option value="scatter" <cfif attributes.graph_type_stock eq "scatter">selected</cfif>><cf_get_lang dictionary_id ='58656.Nokta'></option>
												</select>
											</div>
										</div>	
										<div class="form-group">
											<div class="col col-12 col-xs-12">
												<label class="col col-12"><cf_get_lang dictionary_id='39059.KDV Dahil'><input type="checkbox" name="is_kdv" id="is_kdv" value="1" <cfif isdefined("attributes.is_kdv")>checked</cfif>></label>
												<label class="col col-12"><cf_get_lang dictionary_id='58596.Göster'><cfif isdefined("session.ep.money2") and len(session.ep.money2)>
												<input name="is_money2" id="is_money2" value="1" type="checkbox" <cfif attributes.is_money2 eq 1>checked</cfif>><cfoutput>#session.ep.money2#</cfoutput></cfif></label>
												<label class="col col-12"><cf_get_lang dictionary_id='58596.Göster'><input name="is_cost" id="is_cost" value="1" type="checkbox" <cfif attributes.is_cost eq 1>checked</cfif>><cf_get_lang dictionary_id='58258.Maliyet'> </label>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="row ReportContentBorder">
							<div class="ReportContentFooter">
							 	<label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" onKeyUp="isNumber(this)" maxlength="3" style="width:25px;">							
								<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57911.Çalıştır'></cfsavecontent>
								<input name="form_varmi" id="form_varmi" type="hidden" value="1">
								<cf_wrk_report_search_button search_function='kontrol_tarih()'  insert_info='#message#' button_type='1' is_excel='1'>
							</div>
						</div>
					</div>
				</div>
		</cfform>
	</cf_report_list_search_area>
</cf_report_list_search>

<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
	<cfset filename="category_base_sale_analyse_report#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-8">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</cfif>   	
<cfif isdefined("form_varmi")>
    <cfset str_hier=listlen(attributes.hier,".")>
    <cfset sum_of_total=0>
    <cfset sum_of_total_stock=0>
    <cfset sum_of_total_omv = 0>
    <cfset sum_of_total_cost = 0>
    <cfset sum_of_total_cost_2 = 0> 
	<cfoutput query="get_product_cat">
		<cfset new_hier=mid(hierarchy,2,len(hierarchy))>
        <cfquery name="get_all" dbtype="query">
            SELECT 
                SUM(TOTAL) TOTAL,
                <cfif attributes.is_money2 eq 1>
                    SUM(TOTAL_DOVIZ) TOTAL_DOVIZ,
                </cfif>
                <cfif attributes.is_cost eq 1>
                    SUM(TOTAL_COST) AS TOTAL_COST,
                </cfif>
                <cfif attributes.is_money2 eq 1 and attributes.is_cost eq 1>
                    SUM(TOTAL_COST_2) AS TOTAL_COST_2,
                </cfif>
                SUM(TOTAL_STOCK) TOTAL_STOCK 
            FROM 
                GET_TOTAL_SALE 
            WHERE 
                HIERARCHY LIKE '#new_hier#.%' OR HIERARCHY ='#new_hier#'
        </cfquery>
        <cfif get_all.recordcount and len(get_all.total)>
            <cfset sum_of_total = sum_of_total + get_all.total>
        </cfif>
        <cfif attributes.is_money2 eq 1 and get_all.recordcount and len(get_all.total_doviz)>
            <cfset sum_of_total_omv = sum_of_total_omv + get_all.total_doviz>
        </cfif>
        <cfif attributes.is_cost eq 1 and get_all.recordcount and len(get_all.total_cost)>
            <cfset sum_of_total_cost = sum_of_total_cost + get_all.total_cost>
        </cfif>
        <cfif (attributes.is_money2 eq 1 and attributes.is_cost eq 1) and get_all.recordcount and len(get_all.total_cost_2)>
            <cfset sum_of_total_cost_2 = sum_of_total_cost_2 + get_all.total_cost_2>
        </cfif>
        <cfif get_all.recordcount and len(get_all.total_stock)>
            <cfset sum_of_total_stock = sum_of_total_stock + get_all.total_stock>
        </cfif>
	</cfoutput>
    <cf_report_list>
            <thead>
                <tr>
                    <cfset cols_ = 7>
                    <cfif attributes.is_money2 eq 1><cfset cols_ = cols_ + 2></cfif>
                    <cfif attributes.is_cost eq 1><cfset cols_ = cols_ + 3></cfif>
                    <cfif attributes.is_money2 eq 1 and attributes.is_cost eq 1><cfset cols_ = cols_ + 3></cfif>
                    <th colspan="<cfoutput>#cols_#</cfoutput>" class="txtbold">
                        <cf_get_lang dictionary_id ='30010.Ciro'>
                        <cfif len(attributes.procat)>
                            <cfquery name="GET_PNAME" dbtype="query">
                                SELECT * FROM GET_PRODUCT_CAT_MAIN WHERE PRODUCT_CATID = #attributes.procat#
                            </cfquery>
                            <cfoutput>#(get_pname.product_cat)#</cfoutput>
                        </cfif>
                    </th>
                </tr>
                <tr>
                    <th><cf_get_lang dictionary_id='57487.No'></th>
                    <th><cf_get_lang dictionary_id='58585.Kod'></th>
                    <th><cf_get_lang dictionary_id='57486.Kategori'></th>
                    <th><cf_get_lang dictionary_id='58456.Oran'></th>
                    <th><cf_get_lang dictionary_id='57635.Miktar'></th>
                    <th><cf_get_lang dictionary_id='57673.Tutar'></th>
                    <th><cf_get_lang dictionary_id='58474.Birim'></th>
                    <cfif attributes.is_money2 eq 1>
                        <th> <cf_get_lang dictionary_id='39656.Döviz Tutar'></th>
                        <th><cf_get_lang dictionary_id='58474.Birim'></th>
                    </cfif>
                    <cfif attributes.is_cost eq 1>
                        <th><cf_get_lang dictionary_id='58258.Maliyet'></th>
                        <th><cf_get_lang dictionary_id='58474.Birim'></th>
                        <th><cf_get_lang dictionary_id='39408.Karlılık'></th>
                    </cfif>
                    <cfif attributes.is_money2 eq 1 and attributes.is_cost eq 1>
                        <th><cf_get_lang dictionary_id='58258.Maliyet'> <cfoutput>#session.ep.money2#</cfoutput></th>
                        <th><cf_get_lang dictionary_id='58474.Birim'></th>
                        <th><cf_get_lang dictionary_id='39408.Karlılık'> <cfoutput>#session.ep.money2#</cfoutput></th>
                    </cfif>
                </tr>
            </thead>
            <tbody>
                <cfoutput query="get_product_cat" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <cfset new_hier=mid(hierarchy,2,len(hierarchy))>
                    <cfquery name="get_all" dbtype="query">
                        SELECT 
                            SUM(TOTAL) TOTAL,
                            <cfif attributes.is_money2 eq 1>
                                SUM(TOTAL_DOVIZ) TOTAL_DOVIZ,
                            </cfif>
                            <cfif attributes.is_cost eq 1>
                                SUM(TOTAL_COST) AS TOTAL_COST,
                            </cfif>
                            <cfif attributes.is_money2 eq 1 and attributes.is_cost eq 1>
                                SUM(TOTAL_COST_2) AS TOTAL_COST_2,
                            </cfif>
                            SUM(TOTAL_STOCK) TOTAL_STOCK 
                        FROM 
                            GET_TOTAL_SALE 
                        WHERE 
                            HIERARCHY LIKE '#new_hier#.%' OR HIERARCHY ='#new_hier#'
                    </cfquery>
                    <tr>
                        <td>#currentrow#</td>
                        <td>#new_hier#</td>
                        <td>
                            <cfquery name="GET_SUB" dbtype="query">
                                SELECT PRODUCT_CATID FROM GET_PRODUCT_CAT_MAIN WHERE HIERARCHY LIKE '#new_hier#.%'
                            </cfquery>
                            <cfif get_sub.recordcount>
                                <!-- sil --><a onclick="javascript:sayfa_ac('#product_catid#','#new_hier#');" style="cursor:pointer;"><!-- sil -->#product_cat#<!-- sil --></a><!-- sil -->
                            <cfelse>
                                <cfset sale_analyse_url = "&date1=#dateformat(attributes.startdate,dateformat_style)#&date2=#dateformat(attributes.finishdate,dateformat_style)#">
                                <cfif Len(attributes.company_id) and Len(attributes.company)><cfset sale_analyse_url =  "#sale_analyse_url#&sup_company_id=#attributes.company_id#&sup_company=#UrlEncodedFormat(attributes.company)#"></cfif>
                                <cfif isdefined("attributes.is_kdv")><cfset sale_analyse_url =  "#sale_analyse_url#&is_kdv=#attributes.is_kdv#"></cfif>
                                <cfset sale_analyse_url =  "#sale_analyse_url#&product_cat=#UrlEncodedFormat(product_cat)#&search_product_catid=#new_hier#">
                                <!-- sil --><a href="#request.self#?fuseaction=#fusebox.circuit#.sale_analyse_report&form_submitted=1&is_from_report=1#sale_analyse_url#" target="_blank"><!-- sil -->#product_cat#<!-- sil --></a><!-- sil -->
                            </cfif>
                        </td>
                        <td>%<cfif get_all.recordcount and sum_of_total neq 0>#TLFormat(evaluate((get_all.total/sum_of_total)*100),"__.__")#<cfelse>#TLFormat(0,"__.__")#</cfif></td>
                        <td><cfif get_all.recordcount>#TLFormat(get_all.total_stock)#</cfif></td>
                        <td><cfif get_all.recordcount>#TLFormat(get_all.total)# </cfif></td>
                        <td>&nbsp;#session.ep.money#</td>
                        <cfif attributes.is_money2 eq 1>
                            <td><cfif get_all.recordcount>#TLFormat(get_all.total_doviz)# </cfif></td>
                            <td>&nbsp;#session.ep.money2#</td>
                        </cfif>
                        <cfif attributes.is_cost eq 1>
                            <td><cfif get_all.recordcount>#TLFormat(get_all.total_cost)# </cfif></td>
                            <td>&nbsp;#session.ep.money#</td>
                            <td>
                                <cfif get_all.recordcount and get_all.total neq 0>
                                    #tlformat(1-(get_all.total_cost/get_all.total))#
                                <cfelse>
                                    1
                                </cfif>
                            </td>
                        </cfif>
                        <cfif attributes.is_money2 eq 1 and attributes.is_cost eq 1>
                            <td><cfif get_all.recordcount>#TLFormat(get_all.total_cost_2)# </cfif></td>
                            <td>&nbsp;#session.ep.money2#</td>
                            <td>
                                <cfif get_all.recordcount and get_all.total_doviz neq 0>
                                    #tlformat(1-(get_all.total_cost_2/get_all.total_doviz))#
                                <cfelse>
                                    1
                                </cfif>
                            </td>
                        </cfif>
                    </tr>
                </cfoutput>
            </tbody>
            <tfoot>
                <tr>
                    <td colspan="3"></td>
                    <td class="txtbold"><cf_get_lang dictionary_id='57492.Toplam'></td>
                    <td style="text-align:right;"><cfoutput>#TLFormat(sum_of_total_stock)#</cfoutput></td>
                    <td style="text-align:right;"><cfoutput>#TLFormat(sum_of_total)# </cfoutput> </td>
                    <td>&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
                    <cfif attributes.is_money2 eq 1>								
                        <td style="text-align:right;"><cfoutput>#TLFormat(sum_of_total_omv)# </cfoutput> </td>
                        <td>&nbsp;<cfoutput>#session.ep.money2#</cfoutput></td>
                    </cfif>
                    <cfif attributes.is_cost eq 1>
                        <td style="text-align:right;"><cfoutput>#TLFormat(sum_of_total_cost)# </cfoutput> </td>
                        <td>&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
                        <td style="text-align:right;">
                            <cfif sum_of_total neq 0>
                                <cfoutput>#tlformat(1-(sum_of_total_cost/sum_of_total))#</cfoutput>
                            <cfelse>
                                1
                            </cfif>
                        </td>
                    </cfif>
                    <cfif attributes.is_money2 eq 1 and attributes.is_cost eq 1>
                        <td style="text-align:right;"><cfoutput>#TLFormat(sum_of_total_cost_2)# </cfoutput> </td>
                        <td>&nbsp;<cfoutput>#session.ep.money2#</cfoutput></td>
                        <td style="text-align:right;">
                            <cfif sum_of_total_omv neq 0>
                                <cfoutput>#tlformat(1-(sum_of_total_cost_2/sum_of_total_omv))#</cfoutput>
                            <cfelse>
                                1
                            </cfif>
                        </td>
                    </cfif>
                </tr>					
            </tfoot>
    </cf_report_list>
<cfparam name="attributes.totalrecords" default='#get_product_cat.recordcount#'> 
<cfif attributes.totalrecords gt attributes.maxrows>
	<cfset url_str = "">
	<cfif isdefined("attributes.form_varmi") and len(attributes.form_varmi)>
		<cfset url_str = "#url_str#&form_varmi=#attributes.form_varmi#">
	</cfif>
	<cfif isdefined("attributes.hier") and len(attributes.hier)>
		<cfset url_str = "#url_str#&hier=#attributes.hier#">
	</cfif>
	<cfif isdefined("attributes.branch") and len(attributes.branch)>
		<cfset url_str = "#url_str#&branch=#attributes.branch#">
	</cfif>
	<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
		<cfset url_str = "#url_str#&company_id=#attributes.company_id#">
	</cfif>
	<cfif isdefined("attributes.consumer_id_") and len(attributes.consumer_id_)>
		<cfset url_str = "#url_str#&consumer_id_=#attributes.consumer_id_#">
	</cfif>
	<cfif isdefined("attributes.company_id_") and len(attributes.company_id_)>
		<cfset url_str = "#url_str#&company_id_=#attributes.company_id_#">
	</cfif>
	<cfif isdefined("attributes.graph_type_stock") and len(attributes.graph_type_stock)>
		<cfset url_str = "#url_str#&graph_type_stock=#attributes.graph_type_stock#">
	</cfif>
	<cfif isdefined("attributes.graph_type") and len(attributes.graph_type)>
		<cfset url_str = "#url_str#&graph_type=#attributes.graph_type#">
	</cfif>
	<cfif isdefined("attributes.member_name") and len(attributes.member_name)>
		<cfset url_str = "#url_str#&member_name=#attributes.member_name#">
	</cfif>
	<cfif isdefined("attributes.is_money2") and len(attributes.is_money2)>
		<cfset url_str = "#url_str#&is_money2=#attributes.is_money2#">
	</cfif>
	<cfif isdefined("attributes.is_cost") and len(attributes.is_cost)>
		<cfset url_str = "#url_str#&is_cost=#attributes.is_cost#">
	</cfif>
	<cfif isdefined("attributes.member_cat_type") and len(attributes.member_cat_type)>
		<cfset url_str = "#url_str#&member_cat_type=#attributes.member_cat_type#">
	</cfif>
	<cfif isdefined("attributes.pos_code") and len(attributes.pos_code)>
		<cfset url_str = "#url_str#&pos_code=#attributes.pos_code#">
	</cfif>
	<cfif isdefined("attributes.pos_code_text") and len(attributes.pos_code_text)>
		<cfset url_str = "#url_str#&pos_code_text=#attributes.pos_code_text#">
	</cfif>
	<cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>
		<cfset url_str = '#url_str#&startdate=#dateformat(attributes.startdate,dateformat_style)#'>
	</cfif>
	<cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
		<cfset url_str = '#url_str#&finishdate=#dateformat(attributes.finishdate,dateformat_style)#'>
	</cfif>
		<cf_paging page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#attributes.fuseaction#&#url_str#"> 			
</cfif>

<cfif isdefined("attributes.form_varmi") and isdefined('get_total_sale.recordcount') and get_total_sale.recordcount>
	<tr class="nohover">
		<cfset colorlist="d099ff,6666cc,33cc33,cc6600,ff6600,ffcc00,ff66ff,999933,cccc99,996699,339999,ccff66,ccccff,6699ff">
		<cfchart format="jpg" chartwidth="350" chartheight="350" fontsize="10"
			labelformat="number" show3d="yes"
			xaxistitle="Miktar"	yaxistitle="Ürün Kategori"
			tipbgcolor="0099FF"	font="Arial">
			<cfchartseries type="#attributes.graph_type_stock#" paintstyle="plain" colorlist="#colorlist#">								
				<cfoutput query="get_product_cat">
					<cfset new_hier = mid(hierarchy,2,len(hierarchy))>
					<cfquery name="GET_ALL" dbtype="query">
						SELECT 
							SUM(TOTAL) TOTAL, 
							<cfif attributes.is_money2 eq 1>
								SUM(TOTAL_DOVIZ) TOTAL_DOVIZ,
							</cfif>
							<cfif attributes.is_cost eq 1>
								SUM(TOTAL_COST) AS TOTAL_COST,
							</cfif>
							<cfif attributes.is_money2 eq 1 and attributes.is_cost eq 1>
								SUM(TOTAL_COST_2) AS TOTAL_COST_2,
							</cfif>
							SUM(TOTAL_STOCK) TOTAL_STOCK 
						FROM 
							GET_TOTAL_SALE 
						WHERE 
							HIERARCHY LIKE '#new_hier#.%' OR HIERARCHY ='#new_hier#'
					</cfquery>
					<cfif get_all.recordcount and len(get_all.total)>
						<cfchartdata item="#product_cat#" value="#get_all.total#">
					</cfif>
				</cfoutput>							
			</cfchartseries>
		</cfchart>
	</tr>       
</cfif> 
</cfif>
<script type="text/javascript">
	function sayfa_ac(x,y)
	{
		document.report_special.procat.value=x;	
		document.report_special.hier.value=y;
		document.report_special.submit();
	}
	function kontrol_tarih()
	{		 
		report_special.startdate.value = fix_date_value(report_special.startdate.value);
		report_special.finishdate.value = fix_date_value(report_special.finishdate.value);
		if(!date_check(report_special.startdate,report_special.finishdate,"<cf_get_lang dictionary_id ='40310.Başlama Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!")){
			return false;
		}
		if(document.report_special.is_excel.checked==false)
			{
				document.report_special.action="<cfoutput>#request.self#</cfoutput>?fuseaction=report.category_base_sale_analyse_report"
				return true;
			}
		else
				document.report_special.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_category_base_sale_analyse_report</cfoutput>"

	}
</script>