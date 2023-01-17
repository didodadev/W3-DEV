<!--- 	Sayfa, invoice ve store modullerinde faturaya irsaliye çekmek için kullanılıyor.
		is_store parametresi sayfanın store modulunden cagırıldıgını gosteriyor. Subede depo kontrolu,vs.. için kullanılıyor.
		ship_id_liste: faturaya daha önce secilmiş irsaliyelerin listesi OZDEN20070208 --->
<cfsetting showdebugoutput="yes">
<cf_xml_page_edit>
<cfif not (isdefined("attributes.company_id") and len(attributes.company_id)) and not (isdefined("attributes.consumer_id") and len(attributes.consumer_id)) and not (isdefined("attributes.employee_id") and len(attributes.employee_id))>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='50081.Lütfen Cari Hesap Seçiniz'>!");
		window.close();
	</script>
	<cfabort> 
</cfif>
<cfparam name="attributes.kalan" default="">
<cfparam name="attributes.invoice_date" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.is_kesilmis" default="0">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.ship_list_type" default="0">
<cfparam name="attributes.id" default="">
<cfparam name="attributes.branch_id" default="">

<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
<cfelse>
	<cfif isDefined("attributes.invoice_date") and Len(attributes.invoice_date)><!--- Fatura tarihi baz aliniyor --->
		<cf_date tarih = "attributes.invoice_date">
		<cfset attributes.start_date = date_add('d',-7,attributes.invoice_date)>
		<cfset attributes.invoice_date = DateFormat(attributes.invoice_date,dateformat_style)>
	<cfelse>
		<cfset attributes.start_date = date_add('d',-7,createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#'))>
	</cfif>
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
<cfelse>
	<cfif isDefined("attributes.invoice_date") and Len(attributes.invoice_date)><!--- Fatura tarihi baz aliniyor --->
		<cf_date tarih = "attributes.invoice_date">
		<cfset attributes.finish_date = attributes.invoice_date>
		<cfset attributes.invoice_date = DateFormat(attributes.invoice_date,dateformat_style)>
	<cfelse>
	<cfset attributes.finish_date = date_add('d',7,attributes.start_date)>
	</cfif>
</cfif>
<cfparam name="attributes.ship_period" default="#session.ep.period_id#;#session.ep.period_year#">
<cfscript>
	company_id_list='';
	consumer_id_list='';
	employee_id_list='';
	dept_id_list='';
	ship_id_list ='';
	stock_id_list ='';
	project_id_list ='';
	address_id_list = '';
	if(isdefined('attributes.is_store') and not len(attributes.department_id)) //subede depo kontrolu
	{
		attributes.department_id = listgetat(session.ep.user_location,1,'-');
	}
</cfscript>
<cfif attributes.id neq "purchase" and attributes.id neq "purchase_upd">
	<cfset islem_tipi = '70,71,72,78,79,88'>
<cfelse>
	<cfset islem_tipi = '73,74,75,76,77,80'>
</cfif>
<cfset islem_tipi_kontrol = ''>
<cfif isdefined("attributes.process_cat") and len(attributes.process_cat)>
	<cfquery name="get_pro_type" datasource="#dsn3#">
		SELECT PROCESS_TYPE FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID= #attributes.process_cat#
	</cfquery>
	<cfif get_pro_type.process_type eq 79>
		<cfset islem_tipi = '77'>
		<cfset islem_tipi_kontrol = '77'>
	<cfelseif get_pro_type.process_type eq 78>
		<cfset islem_tipi = '76'>
		<cfset islem_tipi_kontrol = '76'>	
	<cfelseif get_pro_type.process_type eq 75>
		<cfset islem_tipi = '72'>
		<cfset islem_tipi_kontrol = '72'>
	<cfelseif get_pro_type.process_type eq 74>
		<cfset islem_tipi = '71'>
		<cfset islem_tipi_kontrol = '71'>
	<cfelseif get_pro_type.process_type eq 73>
		<cfset islem_tipi = '70'>
		<cfset islem_tipi_kontrol = '70'>		
	</cfif>
</cfif>
<cfquery name="GET_PROCESS_CAT" datasource="#DSN3#">
	SELECT PROCESS_TYPE, PROCESS_CAT_ID, PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (#islem_tipi#) ORDER BY PROCESS_TYPE
</cfquery>
<cfif isdefined("attributes.is_form_submitted")>
	<cfquery name="GET_PERIOD_DSN" datasource="#DSN#" maxrows="1"><!--- sonraki donem kontrol ediliyor --->
		SELECT 
			PERIOD_ID,
			PERIOD_YEAR 
		FROM 
			SETUP_PERIOD 
		WHERE 
			OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
			AND PERIOD_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.ship_period,';')#">
		ORDER BY 
			PERIOD_YEAR
	</cfquery>
	<cfset dsn2_ship = '#dsn#_#listlast(attributes.ship_period,';')#_#session.ep.company_id#'>
	<cfif GET_PERIOD_DSN.recordcount>
		<cfset next_year_dsn2 = '#dsn#_#listlast(get_period_dsn.period_year,';')#_#session.ep.company_id#'>
	</cfif>
	<cfquery name="get_period_dsns" datasource="#dsn#">
		SELECT PERIOD_YEAR,OUR_COMPANY_ID,PERIOD_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	</cfquery>
	<cfquery name="GET_SHIP" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
		SELECT
		<cfif attributes.ship_list_type eq 0>
			DISTINCT
		</cfif> 
			SHIP.SHIP_ID,
			SHIP.SHIP_NUMBER,
			'' AS INVOICE_NUMBER,
			-1 AS INVOICE_ID,
			SHIP.SHIP_TYPE,
			SHIP.SHIP_DATE,
			SHIP.COMPANY_ID,
			SHIP.CONSUMER_ID,
            SHIP.EMPLOYEE_ID,
			SHIP.SHIP_ADDRESS_ID,
			CB.COMPBRANCH__NAME,
		<cfif attributes.ship_list_type eq 1>
        	SR.WRK_ROW_ID,
            SR.WRK_ROW_RELATION_ID,
			SR.SHIP_ROW_ID,
			SR.PRODUCT_ID,
			SR.STOCK_ID,
			SR.SPECT_VAR_ID,
			SR.SPECT_VAR_NAME,
			SR.AMOUNT,
			SR.PRODUCT_NAME2,
            SR.ROW_PROJECT_ID PROJECT_ID,
			S.STOCK_CODE,
			S.BARCOD,
        <cfelse>
        	SHIP.PROJECT_ID PROJECT_ID,
		</cfif>
		<cfif isdefined('attributes.from_ship')	 and attributes.from_ship eq 1>
			<cfif attributes.sale_product>
				SHIP.DEPARTMENT_IN AS DELIVER_STORE_ID
			<cfelse>
				SHIP.DELIVER_STORE_ID
			</cfif>	
		<cfelse>
			<cfif attributes.sale_product>
				SHIP.DELIVER_STORE_ID
			<cfelse>
				SHIP.DEPARTMENT_IN AS DELIVER_STORE_ID
			</cfif>	
		</cfif>
			
		FROM
			#dsn2_ship#.SHIP
			LEFT JOIN #dsn_alias#.COMPANY_BRANCH CB ON CB.COMPANY_ID = SHIP.COMPANY_ID AND CB.COMPBRANCH_ID = SHIP.SHIP_ADDRESS_ID
			<cfif attributes.ship_list_type eq 1 or (len(attributes.stock_id) and len(attributes.product_name))>
			,#dsn2_ship#.SHIP_ROW SR
			,#dsn3_alias#.STOCKS S
			</cfif>
		WHERE
			SHIP.IS_SHIP_IPTAL = 0 AND 		
			SHIP.SHIP_STATUS = 1 AND
			<cfif not isdefined("attributes.from_ship")>
			 SHIP.IS_WITH_SHIP =0 AND <!---faturaların kendi olusturdugu irsaliyeler gelmesin --->
			 </cfif>
			SHIP.SHIP_TYPE NOT IN (80,81,811,82,83,761) <!--- demirbas,hal ,depolararasi sevk irs ve ithal mal girisi gelmesin --->
		AND (SHIP.SHIP_ID NOT IN(select SHIP_ID from SHIP WHERE SHIP_ID IN(SELECT ROW_ORDER_ID FROM SHIP_ROW) AND PROCESS_CAT = 56))
		<cfif isdefined("islem_tipi_kontrol") and len(islem_tipi_kontrol)>
			AND SHIP.SHIP_TYPE IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#islem_tipi_kontrol#" list="yes">)
		</cfif>
		<cfif attributes.ship_list_type eq 1 or (len(attributes.stock_id) and len(attributes.product_name))>
			AND SHIP.SHIP_ID = SR.SHIP_ID
			AND SR.STOCK_ID=S.STOCK_ID
		</cfif>
		<cfif len(attributes.stock_id) and len(attributes.product_name)>
			AND SR.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
		</cfif>
		<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
			AND SHIP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
		<cfelseif  isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
			AND SHIP.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
        <cfelseif  isdefined("attributes.employee_id") and len(attributes.employee_id)>
			AND SHIP.EMPLOYEE_ID = <cfif attributes.employee_id contains '_'>#ListGetAt(attributes.employee_id,1,'_')#<cfelse>#attributes.employee_id#</cfif>
		</cfif>
		<cfif isdefined('attributes.from_ship')	 and attributes.from_ship eq 1>
			<cfif attributes.sale_product> <!--- konsinye irs cagrılmıssa , alış iade irs (ki bu bir satış irsdir) konsinye alış irs cekilebilmesi icin ters calısır --->
				AND SHIP.PURCHASE_SALES = 0
			<cfelse>
				AND SHIP.PURCHASE_SALES = 1
			</cfif>
		<cfelse> <!--- faturadan cagrılmıssa satış fat satış irs cekilir --->
			<cfif attributes.sale_product>
				AND SHIP.PURCHASE_SALES = 1
			<cfelse>
				AND SHIP.PURCHASE_SALES = 0
			</cfif>
		</cfif>
		
		<cfif attributes.is_kesilmis eq 0>
			AND (SHIP.SHIP_ID NOT IN (
									SELECT SHIP_ID FROM #dsn2_ship#.INVOICE_SHIPS WHERE SHIP_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(attributes.ship_period,';')#">
									<cfif GET_PERIOD_DSN.recordcount>
									UNION ALL SELECT SHIP_ID FROM #next_year_dsn2#.INVOICE_SHIPS WHERE SHIP_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(attributes.ship_period,';')#">
									</cfif> )
			<cfif isdefined('xml_dsp_all_ship_') and xml_dsp_all_ship_ eq 1><!--- tum satırı faturaya çekilerek kapatılmamış irsaliyelerde kesilmemiş  filtresiyle listelenecekse--->
				OR						
				(
					SHIP.SHIP_ID IN ( SELECT
									DISTINCT SHIP_ROW.SHIP_ID
								FROM
									#dsn2_ship#.SHIP_ROW
								WHERE
									AMOUNT > ISNULL((SELECT
														SUM(A1.AMOUNT)
													FROM
													(
														SELECT 
															INVOICE_ROW.AMOUNT
														FROM
															#dsn2_ship#.INVOICE_ROW
														WHERE
															INVOICE_ROW.WRK_ROW_RELATION_ID=SHIP_ROW.WRK_ROW_ID AND 
															INVOICE_ROW.SHIP_ID=SHIP_ROW.SHIP_ID
														<cfif GET_PERIOD_DSN.recordcount>
														UNION ALL
														SELECT 
															IR.AMOUNT
														FROM
															#next_year_dsn2#.INVOICE_ROW IR
														WHERE
															IR.WRK_ROW_RELATION_ID=SHIP_ROW.WRK_ROW_ID AND 
															IR.SHIP_ID=SHIP_ROW.SHIP_ID
														</cfif>
														UNION ALL
														<cfloop query="get_period_dsns">
														SELECT
															SUM(SHIP_AMOUNT) AS SHIP_AMOUNT
														FROM
															#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.GET_SHIP_ROW_RELATION GSRR
														WHERE
															SHIP_ID=SHIP_ROW.SHIP_ID
															AND GSRR.SHIP_WRK_ROW_ID=SHIP_ROW.WRK_ROW_ID
														<cfif currentrow neq get_period_dsns.recordcount> UNION ALL </cfif>					
													</cfloop>
													) AS A1),0)																										
										AND SHIP_ROW.SHIP_ID=SHIP.SHIP_ID )
				 )
			</cfif>	)
		<cfelseif attributes.is_kesilmis eq 1>
			AND SHIP.SHIP_ID IN (
									SELECT SHIP_ID FROM #dsn2_ship#.INVOICE_SHIPS WHERE SHIP_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(attributes.ship_period,';')#">
									<cfif GET_PERIOD_DSN.recordcount>
									UNION ALL SELECT SHIP_ID FROM #next_year_dsn2#.INVOICE_SHIPS WHERE SHIP_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(attributes.ship_period,';')#">
									</cfif> )
		</cfif>
		<cfif len(attributes.cat) and listlast(attributes.cat,'-') eq 0>
			AND SHIP.SHIP_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(attributes.cat,'-')#">
		<cfelseif len(attributes.cat) and listlast(attributes.cat,'-') neq 0>
			AND SHIP.PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.cat,'-')#">
		</cfif>
		<cfif len(attributes.project_id) and len(attributes.project_head)>
			AND SHIP.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
		</cfif>
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
			AND (SHIP.SHIP_NUMBER LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%')
		</cfif>
		<cfif isDefined("attributes.DEPARTMENT_ID") and attributes.DEPARTMENT_ID NEQ 0>
			AND
			<cfif attributes.sale_product eq 0>
				SHIP.DEPARTMENT_IN = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
			<cfelse>
				SHIP.DELIVER_STORE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
			</cfif>		
		</cfif>
		<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
			AND SHIP.SHIP_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
		<cfelseif isdate(attributes.start_date)>
			AND SHIP.SHIP_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
		<cfelseif isdate(attributes.finish_date)>
			AND SHIP.SHIP_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
		</cfif>
		<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
			AND SHIP.SHIP_ADDRESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> 
		</cfif>
		ORDER BY
			SHIP.SHIP_NUMBER ASC,
			SHIP.SHIP_DATE DESC
		<cfif attributes.ship_list_type eq 1>
        	,SR.WRK_ROW_ID
		</cfif>
	</cfquery>
<cfelse>
	<cfset get_ship.recordcount = 0>
</cfif>
<cfif isDefined("attributes.company_id") and Len(attributes.company_id)>
	<cfquery name="get_branch" datasource="#dsn#">
		SELECT COMPBRANCH__NAME,COMPBRANCH_ID FROM COMPANY_BRANCH WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
	</cfquery>
<cfelseif isDefined("attributes.consumer_id") and Len(attributes.consumer_id)>
	<cfquery name="get_branch" datasource="#dsn#">
		SELECT CONTACT_NAME COMPBRANCH__NAME,CONTACT_ID COMPBRANCH_ID FROM CONSUMER_BRANCH WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
	</cfquery>
</cfif>
<cfquery name="GET_PERIOD_LIST" datasource="#DSN#"><!--- sadece aktif donem ve bir önceki doneme ait irsaliyeler faturaya cekilebilir --->
	SELECT
		PERIOD_ID,PERIOD_YEAR 
	FROM 
		SETUP_PERIOD 
	WHERE 
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND 
		PERIOD_YEAR <= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_year#">
	ORDER BY 
		PERIOD_YEAR DESC
</cfquery>
<cfset consigment_pre_period_year=''>
<cfset url_str="">
<cfif isdefined("attributes.ship_id_liste")>
	<cfset url_str = "#url_str#&ship_id_liste=#attributes.ship_id_liste#">
</cfif>
<cfif isdefined("attributes.ship_date_liste")>
	<cfset url_str = "#url_str#&ship_date_liste=#attributes.ship_date_liste#">
</cfif>
<cfif isdefined("attributes.ship_project_liste")>
	<cfset url_str = "#url_str#&ship_project_liste=#attributes.ship_project_liste#">
</cfif>
<cfif isdefined("attributes.is_store")>
	<cfset url_str = "#url_str#&is_store=#attributes.is_store#">
</cfif>
<cfif isdefined('attributes.process_cat')>
	<cfset url_str = "#url_str#&process_cat=#attributes.process_cat#">
</cfif>
<cfif isdefined("attributes.from_ship")>
	<cfset url_str = "#url_str#&from_ship=#attributes.from_ship#">
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="header_"><cf_get_lang dictionary_id ='34090.İrsaliyeler'></cfsavecontent>
	<cf_box title="#header_#">
		<cfparam name="attributes.keyword" default=''>
		<cfparam name="attributes.cat" default=''>
		<cfparam name="attributes.page" default=1>
		<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
		<cfparam name="attributes.totalrecords" default="#get_ship.recordcount#">
		<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
		<cfform name="get_ship" action="#request.self#?fuseaction=objects.popup_list_choice_ship&sale_product=#attributes.sale_product##url_str#" method="post">
			<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
			<input type="hidden" name="invoice_date" id="invoice_date" value="<cfoutput>#attributes.invoice_date#</cfoutput>">
			<cf_box_search>
				<div class="form-group" id="item-keyword">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" style="width:80px;" value="#attributes.keyword#" placeholder="#message#" maxlength="255">
				</div>
				<cfif xml_show_branch eq 1 and not (isdefined("attributes.employee_id") and len(attributes.employee_id))>
					<div class="form-group" id="item-branch_id">
						<select name="branch_id" id="branch_id" style="width:120px;">
							<option value=""><cf_get_lang dictionary_id ='30126.Sube Seçiniz'></option>
							<cfoutput query="get_branch">
								<option value="#compbranch_id#" <cfif attributes.branch_id is compbranch_id>selected</cfif>>#compbranch__name#
							</cfoutput>		
						</select>
					</div>	
				</cfif>
				<div class="form-group" id="item-stock_id">
					<div class="input-group">
						<input type="hidden" name="stock_id" id="stock_id" <cfif len(attributes.stock_id) and len(attributes.product_name)> value="<cfoutput>#attributes.stock_id#</cfoutput>"</cfif>>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57657.Ürün'></cfsavecontent>
						<input type="text" name="product_name" id="product_name" placeholder="<cfoutput>#message#</cfoutput>" value="<cfif len(attributes.stock_id) and len(attributes.product_name)><cfoutput>#attributes.product_name#</cfoutput></cfif>" style="width:80px;">
						<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=get_ship.stock_id&field_name=get_ship.product_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&keyword='+encodeURIComponent(document.get_ship.product_name.value),'list');"></span>
					</div>
				</div>	
				<div class="form-group" id="item-project_id">
					<div class="input-group">		
						<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.project_id') and len(attributes.project_id) and len(attributes.project_head)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57416.Proje'></cfsavecontent>
						<input name="project_head" type="text" id="project_head" placeholder="<cfoutput>#message#</cfoutput>" style="width:80px;" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');"  value="<cfif len(attributes.project_id) and len(attributes.project_head)><cfoutput>#GET_PROJECT_NAME(attributes.project_id)#</cfoutput></cfif>" autocomplete="off" >  
						<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=get_ship.project_id&project_head=get_ship.project_head');"></span>                   
					</div>
				</div>	
				<div class="form-group" id="item-ship_list_type">
					<select name="ship_list_type" id="ship_list_type">
						<option value="0" <cfif attributes.ship_list_type eq 0>selected</cfif>><cf_get_lang dictionary_id='57660.Belge Bazında'>
						<option value="1" <cfif attributes.ship_list_type eq 1>selected</cfif>><cf_get_lang dictionary_id='29539.Satır Bazında'>
					</select>
				</div>	
				<div class="form-group small">	
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" style="width:25px;" value="#attributes.maxrows#" validate="integer" range="1,250" message="#message#">
				</div>
				<div class="form-group">	
					<cf_wrk_search_button search_function='control_period()' button_type='4'>
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" index="1" type="column" sort="true">
					<cfquery name="STORES" datasource="#DSN#">
						SELECT
							D.DEPARTMENT_ID,
							D.DEPARTMENT_HEAD,
							D.BRANCH_ID,
							D.IS_STORE
						FROM
							DEPARTMENT D,
							BRANCH B
						WHERE 
							D.BRANCH_ID = B.BRANCH_ID
							AND D.IS_STORE = 1
							AND D.DEPARTMENT_STATUS = 1
							AND B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
							<cfif isdefined("attributes.is_store")>
							AND B.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location, 2, '-')#">
							</cfif>
						ORDER BY
							DEPARTMENT_HEAD
					</cfquery>
					<div class="form-group" id="item-department_id">
						<select name="department_id" id="department_id" style="width:150px;">
							<option selected value="0"><cf_get_lang dictionary_id ='57734.Seçiniz'>
							<cfoutput query="stores"><option value="#department_id#"<cfif isdefined('attributes.department_id') and (attributes.department_id eq STORES.department_id)>Selected</cfif>>#department_head#</cfoutput> 
						</select>
						<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined('attributes.company_id')><cfoutput>#attributes.company_id#</cfoutput></cfif>">
						<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined('attributes.consumer_id')><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
						<input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined('attributes.employee_id')><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
						<input type="hidden" name="sale_product" id="sale_product" value="<cfoutput>#attributes.sale_product#</cfoutput>">			
					</div>	
					<div class="form-group" id="item-cat">
						<select name="cat" id="cat" style="width:180px;">
							<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
							<cfoutput query="get_process_cat" group="process_type">
								<option value="#process_type#-0" <cfif '#process_type#-0' is attributes.cat> selected</cfif>>#get_process_name(process_type)#</option>										
								<cfoutput>
								<option value="#process_type#-#process_cat_id#" <cfif attributes.cat is '#process_type#-#process_cat_id#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#process_cat#</option>
								</cfoutput>
							</cfoutput>
						</select>
					</div>	
					<div class="form-group" id="item-is_kesilmis">
						<select name="is_kesilmis" id="is_kesilmis">
							<option value="0" <cfif attributes.is_kesilmis eq 0>selected</cfif>><cf_get_lang dictionary_id ='34091.Kesilmemiş'>
							<option value="1" <cfif attributes.is_kesilmis eq 1>selected</cfif>><cf_get_lang dictionary_id ='34092.Kesilmiş'>
							<option value="2" <cfif attributes.is_kesilmis eq 2>selected</cfif>><cf_get_lang dictionary_id ='58081.Hepsi'>
						</select>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" index="2" type="column" sort="true">
					<div class="form-group" id="item-ship_period">
						<select name="ship_period" id="ship_period"><!--- <cfif isdefined('selected_ship_period') and len(selected_ship_period)>onchange="control_period(this.value,<cfoutput>#selected_ship_period#</cfoutput>);"</cfif> --->
							<cfoutput query="get_period_list">
								<option value="#period_id#;#period_year#" <cfif listfirst(attributes.ship_period,';') eq period_id>selected</cfif>>#period_year#</option>
							</cfoutput>
						</select>
					</div>	
					<div class="form-group" id="item-start_date"> 
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi Girmelisiniz'>!</cfsavecontent>
							<cfif isdefined("attributes.real_start_date_") and len(attributes.real_start_date_)>
								<cfinput type="text" name="start_date" maxlength="10" value="#attributes.real_start_date_#" style="width:64px;" validate="#validate_style#" message="#message#">
							<cfelse>
								<cfinput type="text" name="start_date" maxlength="10" value="#DateFormat(attributes.start_date,dateformat_style)#" style="width:64px;" validate="#validate_style#" message="#message#">
							</cfif>
							<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
						</div>
					</div>	
					<div class="form-group" id="item-finish_date">
						<div class="input-group">			
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'>!</cfsavecontent>
							<cfinput type="text" name="finish_date" maxlength="10" value="#DateFormat(attributes.finish_date,dateformat_style)#" style="width:64px;" validate="#validate_style#" message="#message#">
							<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
		<cfparam name="attributes.department_id" default="0">
		<cfset url_str="#url_str#&cat=#attributes.cat#&department_id=#attributes.department_id#&sale_product=#attributes.sale_product#&ship_period=#attributes.ship_period#">
		<cfif len(attributes.invoice_date)>
			<cfset url_str = "#url_str#&invoice_date=#attributes.invoice_date#">
		</cfif>
		<cfif isdefined('attributes.company_id') and len(attributes.company_id)>
			<cfset url_str = "#url_str#&company_id=#attributes.company_id#">
		</cfif>
		<cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
			<cfset url_str = "#url_str#&consumer_id=#attributes.consumer_id#">
		</cfif>
		<cfif isdefined('attributes.employee_id') and len(attributes.employee_id)>
			<cfset url_str = "#url_str#&employee_id=#attributes.employee_id#">
		</cfif>
		<cfif isdefined('attributes.start_date') and len(attributes.start_date)>
			<cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
		</cfif>
		<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
			<cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
		</cfif>
		<cfif isdefined('attributes.id')>
			<cfset url_str = "#url_str#&id=#attributes.id#">
		</cfif>
		<cfif isdefined('attributes.is_kesilmis')>
			<cfset url_str = "#url_str#&is_kesilmis=#attributes.is_kesilmis#">
		</cfif>
		<cfif isdefined('attributes.project_id') and len(attributes.project_id) and isdefined('attributes.project_head') and len(attributes.project_head)>
			<cfset url_str = "#url_str#&project_id=#attributes.project_id#">
		</cfif>
		<cfif isdefined('attributes.stock_id') and len(attributes.stock_id)>
			<cfset url_str = "#url_str#&stock_id=#attributes.stock_id#">
		</cfif>
		<cfif isdefined('attributes.product_name') and len(attributes.product_name)>
			<cfset url_str = "#url_str#&product_name=#attributes.product_name#">
		</cfif>
		<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif>
		<cfif isdefined("attributes.branch_id")>
			<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
		</cfif>
		<cf_flat_list>
			<thead>
				<tr>
					<th width="10"><cfif get_ship.recordcount><input name="is_check_all_ship" id="is_check_all_ship" align="middle" type="checkbox" value="1" onClick="check_all_ships();"></cfif></th>
					<th width="80"><cf_get_lang dictionary_id ='58138.İrsaliye No'></th>
					<th width="85"><cf_get_lang dictionary_id ='33096.İrsaliye Tarihi'></th>
					<cfif attributes.ship_list_type eq 0>
						<th><cf_get_lang dictionary_id ='57574.Şirket'></th>
						<cfif xml_show_branch eq 1><th class="form-title"><cf_get_lang dictionary_id ='57453.Şube'></th></cfif>
					<cfelse>
						<th><cf_get_lang dictionary_id='57657.Ürün'></th>
						<th><cf_get_lang dictionary_id="57518.Stok Kodu"></th>
						<th><cf_get_lang dictionary_id="39093.Ürün Barkodu"></th>
						<th><cf_get_lang dictionary_id='32724.İrsaliye Miktarı'></th>
						<th><cf_get_lang dictionary_id="39235.Faturalanan Miktar"></th>
						<th><cf_get_lang dictionary_id="34901.İade Miktarı"></th>
						<th><cf_get_lang dictionary_id="58444.Kalan"></th>
					</cfif>
					</th>
					<cfif attributes.ship_list_type eq 1 and isdefined("x_show_product_code_2") and x_show_product_code_2 eq 1><th class="form-title"><cf_get_lang dictionary_id='57789.Özel Kod'></th></cfif>
					<cfif attributes.ship_list_type eq 1 and xml_show_spect eq 1><th class="form-title"><cf_get_lang dictionary_id ='34299.Spec'></th></cfif>
					<cfif attributes.ship_list_type eq 1 and isdefined("xml_show_product_name2") and xml_show_product_name2 eq 1><th class="form-title"><cf_get_lang dictionary_id='57629.Açıklama'> 2</td></cfif>
					<cfif isdefined('xml_show_project') and xml_show_project eq 1><th class="form-title"><cf_get_lang dictionary_id='57416.Proje'></th></cfif>
					<th><cf_get_lang dictionary_id ='57773.İrsaliye'></th>
					<th><cf_get_lang dictionary_id ='58763.Depo'></th>
					<th width="120"><cf_get_lang dictionary_id ='58133.Fatura No'></th>	
				</tr>
			</thead>
			<tbody>
				<cfset url_action="#url_str#">
				<cfset url_action = "#url_str#&sale_product=#attributes.sale_product#">
				<cfif get_ship.recordcount>
					<cfoutput query="get_ship" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(get_ship.COMPANY_ID) and not listfind(company_id_list,get_ship.COMPANY_ID)>
							<cfset company_id_list=listappend(company_id_list,get_ship.COMPANY_ID)>
						<cfelseif len(get_ship.CONSUMER_ID) and not listfind(consumer_id_list,get_ship.CONSUMER_ID)>
							<cfset consumer_id_list=listappend(consumer_id_list,get_ship.CONSUMER_ID)>
						<cfelseif len(get_ship.EMPLOYEE_ID) and not listfind(employee_id_list,get_ship.EMPLOYEE_ID)>
							<cfset employee_id_list=listappend(employee_id_list,get_ship.EMPLOYEE_ID)>
						</cfif>
						<cfif len(get_ship.DELIVER_STORE_ID) and not listfind(dept_id_list,get_ship.DELIVER_STORE_ID)>
							<cfset dept_id_list=listappend(dept_id_list,get_ship.DELIVER_STORE_ID)>
						</cfif>
						<cfset ship_id_list = listappend(ship_id_list,ship_id,',')>
						<cfif attributes.ship_list_type eq 1 and len(get_ship.STOCK_ID) and not listfind(stock_id_list,get_ship.STOCK_ID)>
							<cfset stock_id_list=listappend(stock_id_list,get_ship.STOCK_ID)>
						</cfif>
						<cfif len(get_ship.PROJECT_ID) and not listfind(project_id_list,get_ship.PROJECT_ID)>
							<cfset project_id_list=listappend(project_id_list,get_ship.PROJECT_ID)>
						</cfif>
					</cfoutput>
					<cfset company_id_list = listsort(company_id_list,'numeric')>
					<cfif len(company_id_list)>
						<cfquery name="get_all_companies" datasource="#dsn#">
							SELECT COMPANY_ID, FULLNAME FROM COMPANY WHERE COMPANY_ID IN (#company_id_list#)
						</cfquery>
					</cfif>
					<cfset consumer_id_list = listsort(consumer_id_list,'numeric')>
					<cfif len(consumer_id_list)>
						<cfquery name="get_all_consumers" datasource="#dsn#">
							SELECT CONSUMER_NAME,CONSUMER_SURNAME, COMPANY FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_id_list#)
						</cfquery>
					</cfif>
					<cfset employee_id_list = listsort(employee_id_list,'numeric')>
					<cfif len(employee_id_list)>
						<cfquery name="get_all_employees" datasource="#dsn#">
							SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_id_list#)
						</cfquery>
					</cfif>
					<cfset dept_id_list=listsort(dept_id_list,"numeric")>
					<cfif len(dept_id_list)>
						<cfquery name="get_dept_name" dbtype="query">
							SELECT DEPARTMENT_HEAD FROM STORES WHERE DEPARTMENT_ID IN (#dept_id_list#) ORDER BY	DEPARTMENT_ID
						</cfquery>
					</cfif>
					<cfset stock_id_list=listsort(stock_id_list,"numeric")>
					<cfif len(stock_id_list)>
						<cfquery name="get_prod_name" datasource="#dsn3#">
							SELECT PRODUCT_NAME+PROPERTY AS PRODUCT_NAME,PRODUCT_CODE_2 FROM STOCKS WHERE STOCK_ID IN (#stock_id_list#) ORDER BY STOCK_ID
						</cfquery>
					</cfif>
					<cfset project_id_list=listsort(project_id_list,"numeric")>
					<cfif len(project_id_list)>
						<cfquery name="get_project_name" datasource="#dsn#">
							SELECT PROJECT_ID,PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_id_list#) ORDER BY PROJECT_ID
						</cfquery>
					</cfif>
					<cfset ship_id_list = listsort(ship_id_list,"numeric")>
					<cfif attributes.ship_list_type eq 0>
						<cfif len(ship_id_list)>
							<cfquery name="GET_ALL_INVOICE_SHIPS" datasource="#dsn2_ship#">
								SELECT INVOICE_NUMBER,SHIP_ID FROM INVOICE_SHIPS  WHERE SHIP_PERIOD_ID = #listfirst(attributes.ship_period,';')# AND SHIP_ID IN (#ship_id_list#)
								<cfif GET_PERIOD_DSN.recordcount>
								UNION ALL SELECT INVOICE_NUMBER,SHIP_ID FROM #next_year_dsn2#.INVOICE_SHIPS  WHERE INVOICE_SHIPS.SHIP_PERIOD_ID = #listfirst(attributes.ship_period,';')# AND SHIP_ID IN (#ship_id_list#)</cfif>
							</cfquery>
						</cfif>
					</cfif>
					<cfoutput query="get_ship" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif attributes.ship_list_type eq 1>
							<cfquery name="get_all_ship_amount" datasource="#dsn#">
								SELECT
									SUM(A1.SHIP_AMOUNT) AS SHIP_AMOUNT,
									SUM(A1.INVOICE_AMOUNT) AS INVOICE_AMOUNT,
									A1.SHIP_PERIOD,
									<!--- A1.DEFAULT_PERIOD, --->
									A1.STOCK_ID,
									A1.SPECT_VAR_ID,
									A1.SHIP_WRK_ROW_ID
								FROM
								(
								<cfloop query="get_period_dsns">
									SELECT
										SUM(SHIP_AMOUNT) AS SHIP_AMOUNT,
										SUM(INVOICE_AMOUNT) AS INVOICE_AMOUNT,
										SHIP_PERIOD,
										<!--- #get_period_dsns.period_id# DEFAULT_PERIOD, --->
										STOCK_ID,
										ISNULL((SELECT SP.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SP WHERE SP.SPECT_VAR_ID = GSRR.SPECT_VAR_ID),0) AS SPECT_VAR_ID,
										ISNULL(SHIP_WRK_ROW_ID,0) AS SHIP_WRK_ROW_ID
									FROM
										#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.GET_SHIP_ROW_RELATION GSRR
									WHERE
										SHIP_ID=#GET_SHIP.SHIP_ID#
										AND SHIP_PERIOD=<cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(attributes.ship_period,';')#">
										AND SHIP_WRK_ROW_ID = '#GET_SHIP.WRK_ROW_ID#'
									GROUP BY
										SHIP_PERIOD,
										STOCK_ID,
										SPECT_VAR_ID,
										SHIP_WRK_ROW_ID
									<cfif currentrow neq get_period_dsns.recordcount> UNION ALL </cfif>					
								</cfloop> ) AS A1
									GROUP BY
										A1.SHIP_PERIOD,
										<!--- A1.DEFAULT_PERIOD, --->
										A1.STOCK_ID,
										A1.SPECT_VAR_ID,
										A1.SHIP_WRK_ROW_ID
									ORDER BY STOCK_ID
							</cfquery>
						</cfif>
						<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
							<td align="center" width="1%">						
								<input type="Checkbox" name="_company_ship_" id="_company_ship_" value="<cfif attributes.ship_list_type eq 0>#get_ship.ship_id#<cfelse>#get_ship.SHIP_ROW_ID#</cfif>;<cfif len(get_ship.company_id) and get_ship.company_id neq 0>#get_ship.company_id#<cfelse>#get_ship.consumer_id#</cfif>-#islem_tipi#<cfif isdefined("get_ship.ship_id") and len(get_ship.ship_id) and isdefined("get_ship.ship_row_id") and len(get_ship.ship_row_id)>-#get_ship.ship_id#_#get_ship.ship_row_id#</cfif>" onClick="javascript:if(this.checked){send_selected_ship('<cfif attributes.ship_list_type eq 0>#get_ship.ship_id#<cfelse>#get_ship.SHIP_ROW_ID#</cfif>;<cfif len(get_ship.company_id) and get_ship.company_id neq 0>#get_ship.company_id#<cfelse>#get_ship.consumer_id#</cfif>',1,'#islem_tipi#'<cfif isdefined("get_ship.ship_id") and len(get_ship.ship_id) and isdefined("get_ship.ship_row_id") and len(get_ship.ship_row_id)>,'#get_ship.ship_id#_#get_ship.ship_row_id#'</cfif>);<cfif (INVOICE_ID gt 0)>alert("<cf_get_lang dictionary_id ='34104.Bu İrsaliye Daha Önce Bir Faturaya Bağlanmış'>!");</cfif>}else send_selected_ship('<cfif attributes.ship_list_type eq 0>#get_ship.ship_id#<cfelse>#get_ship.SHIP_ROW_ID#</cfif>;<cfif len(get_ship.company_id) and get_ship.company_id neq 0>#get_ship.company_id#<cfelse>#get_ship.consumer_id#</cfif>',2,'#islem_tipi#'<cfif isdefined("get_ship.ship_id") and len(get_ship.ship_id) and isdefined("get_ship.ship_row_id") and len(get_ship.ship_row_id)>,'#get_ship.ship_id#_#get_ship.ship_row_id#'</cfif>);">
							</td>
							<td>
								<cfif isdefined('attributes.ship_list_type') and attributes.ship_list_type eq 0> <!--- belge bazında --->
									<cfif (isdefined("attributes.process_cat")) and (islem_tipi eq 71 or islem_tipi eq 76)><!--- alım iade irs. ve toptan satış iade irs. ise gönderiyoruz --->
										<cfset process_type_ = islem_tipi>
									<cfelse>
										<cfset process_type_ = ''>
									</cfif>
									<a href="javascript://" class="tableyazi" onClick="gizle_goster(SHIP_ROW_LIST#currentrow#);AjaxPageLoad('#request.self#?fuseaction=objects.ajax_popup_list_choice_ship_row&xml_show_product_name2=#xml_show_product_name2#&x_show_product_code_2=#x_show_product_code_2#&xml_show_spect=#xml_show_spect#&ship_id=#SHIP_ID#&ship_period_=#attributes.ship_period#&inv_date=#attributes.invoice_date#&form_crntrow=#currentrow##url_str#&process_type=#process_type_#','SHIP_ROW_LIST#currentrow#_',1);">#SHIP_NUMBER#</a></div>
								<cfelse>
									#SHIP_NUMBER#
								</cfif>
							</td>
							<td>#dateformat(SHIP_DATE,dateformat_style)#</td>
							<cfif attributes.ship_list_type eq 0>
								<cfif len(COMPANY_ID) or Len(Consumer_Id) or len(employee_id)>
									<td><cfif Len(company_id)>
											#get_all_companies.FULLNAME[listfind(company_id_list,COMPANY_ID)]#
										<cfelseif len(consumer_id)>
											#get_all_consumers.CONSUMER_NAME[listfind(consumer_id_list,CONSUMER_ID)]#&nbsp;#get_all_consumers.CONSUMER_SURNAME[listfind(consumer_id_list,CONSUMER_ID)]#
										<cfelseif len(employee_id)>
											#get_all_employees.EMPLOYEE_NAME[listfind(employee_id_list,EMPLOYEE_ID)]#&nbsp;#get_all_employees.EMPLOYEE_SURNAME[listfind(employee_id_list,EMPLOYEE_ID)]#
										</cfif>
									</td>
									<cfif xml_show_branch eq 1><td>#compbranch__name#</td></cfif>
								</cfif>
							<cfelse>
								<td>#get_prod_name.PRODUCT_NAME[listfind(stock_id_list,get_ship.STOCK_ID)]#</td>
								<td>#STOCK_CODE#</td>
								<td>#barcod#</td>
								<td>#TLFormat(AMOUNT)#</td>
								<td>#TLFormat(get_all_ship_amount.INVOICE_AMOUNT)#</td>
								<td>#TLFormat(get_all_ship_amount.SHIP_AMOUNT)#</td>
								<td class="text-center">
								<cfset kalan=AMOUNT>
								<cfif (isdefined("attributes.process_cat")) and (islem_tipi eq 71 or islem_tipi eq 76)><!--- alım iade irs. ve toptan satış iade irs. ise kalan faturalanan miktarın taması olsun MK 011119 --->
									<cfset kalan=AMOUNT>
								<cfelse>
									<cfif isdefined('get_all_ship_amount.SHIP_AMOUNT') and len(get_all_ship_amount.SHIP_AMOUNT)>							
										<cfset kalan=AMOUNT-get_all_ship_amount.SHIP_AMOUNT>
									</cfif>
									<cfif isdefined('get_all_ship_amount.INVOICE_AMOUNT') and len(get_all_ship_amount.INVOICE_AMOUNT)>							
										<cfset kalan=AMOUNT-get_all_ship_amount.INVOICE_AMOUNT>
									</cfif>
								</cfif>	
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='38519.Miktarı Kontrol Ediniz'></cfsavecontent>					
									<input type="text" name="kalan_#SHIP_ID#_#SHIP_ROW_ID#" id="kalan_#SHIP_ID#_#SHIP_ROW_ID#" onBlur="if(filterNum(this.value,4)=='' || filterNum(this.value,4)==0)this.value=1;if(filterNum(this.value,4)>#kalan#){alert('Kalan Miktar #kalan#\'dan Fazla Olmamalıdır!');this.value=#TLFormat(kalan)#;}"
									onkeyup="return(FormatCurrency(this,event,4));" validate="float" class="moneybox" value="<cfif kalan gt 0>#TLFormat(kalan,4)#<cfelse>#TLFormat(0)#</cfif>" range="0,#AMOUNT#" style="width:100%" message="<cfoutput>#message#</cfoutput>">
								</td>
							</cfif>
							<cfif attributes.ship_list_type eq 1 and isdefined("x_show_product_code_2") and x_show_product_code_2 eq 1><td>#get_prod_name.PRODUCT_CODE_2[listfind(stock_id_list,get_ship.STOCK_ID)]#</td></cfif>
							<cfif attributes.ship_list_type eq 1 and xml_show_spect eq 1><td>#spect_var_name#</td></cfif>
							<cfif attributes.ship_list_type eq 1 and isdefined("xml_show_product_name2") and xml_show_product_name2 eq 1><td>#product_name2#</td></cfif>
							<cfif xml_show_project eq 1><td><cfif len(project_id_list)>#get_project_name.PROJECT_HEAD[listfind(project_id_list,PROJECT_ID)]#</cfif></td></cfif>
							<td>
								<cfif attributes.cat eq 70><cf_get_lang dictionary_id='34095.Parekande Satış İrsaliyesi'>
								<cfelseif SHIP_TYPE eq 71><cf_get_lang dictionary_id='58752.Toptan Satış İrsaliyesi'>
								<cfelseif SHIP_TYPE eq 72><cf_get_lang dictionary_id='58753.Konsinye Çıkış İrsaliyesi'>
								<cfelseif SHIP_TYPE eq 73><cf_get_lang dictionary_id='34099.Parekande Satış İade İrsaliyesi'>
								<cfelseif SHIP_TYPE eq 74><cf_get_lang dictionary_id='29580.Toptan Satış İade İrsaliyesi'>
								<cfelseif SHIP_TYPE eq 75><cf_get_lang dictionary_id='32588.Konsinye Çikis Iade Irsaliyesi'>
								<cfelseif SHIP_TYPE eq 76><cf_get_lang dictionary_id='29581.Mal Alım İrsaliyesi'>
								<cfelseif SHIP_TYPE eq 78><cf_get_lang dictionary_id='29584.Alım İade İrsaliyesi'>
								<cfelseif SHIP_TYPE eq 77><cf_get_lang dictionary_id='34103.Konsinye Giriş'>
								<cfelseif SHIP_TYPE eq 79><cf_get_lang dictionary_id='34097.Konsinye Giriş İade'>
								<cfelseif SHIP_TYPE eq 80><cf_get_lang dictionary_id='57823.Müstahsil Makbuzu'>
								<cfelseif SHIP_TYPE eq 88><cf_get_lang dictionary_id='29594.İhracat İrsaliyesi'>
								<cfelseif SHIP_TYPE eq 141><cf_get_lang dictionary_id='29648.Servis Stok Çıkış Hareketi'>
								</cfif>
							</td>
							<td>#get_dept_name.DEPARTMENT_HEAD[listfind(dept_id_list,get_ship.DELIVER_STORE_ID,',')]#</td>
							<cfif attributes.ship_list_type eq 1>  
								<cfquery name="GET_ALL_INVOICE_SHIPS" datasource="#dsn2_ship#">
									SELECT DISTINCT
										INVOICE.INVOICE_NUMBER 
									FROM #dsn3_alias#.GET_ALL_INVOICE_ROW  INVOICE_ROW
										JOIN INVOICE ON INVOICE.INVOICE_ID = INVOICE_ROW.INVOICE_ID
									WHERE
										INVOICE_ROW.WRK_ROW_RELATION_ID = '#GET_SHIP.WRK_ROW_ID#'
									UNION ALL
									SELECT
										INVOICE.INVOICE_NUMBER 
									FROM #dsn3_alias#.GET_ALL_INVOICE_ROW INVOICE_ROW
										JOIN INVOICE ON INVOICE.INVOICE_ID = INVOICE_ROW.INVOICE_ID
									WHERE
										INVOICE_ROW.WRK_ROW_ID = '#GET_SHIP.WRK_ROW_RELATION_ID#'
								</cfquery>
							</cfif>
							<td>
								<cfif attributes.ship_list_type eq 0>
									<cfif GET_ALL_INVOICE_SHIPS.recordcount>
										<cfquery name="GET_INV_NO" dbtype="query">
											SELECT INVOICE_NUMBER FROM GET_ALL_INVOICE_SHIPS WHERE SHIP_ID=#ship_id#
										</cfquery>
										<cfif isdefined('GET_INV_NO') and IsQuery(GET_INV_NO) and GET_INV_NO.recordcount>
											<cfloop query="GET_INV_NO">
												#invoice_number# <cfif currentrow neq  GET_INV_NO.recordcount>,</cfif>
											</cfloop>
										<cfelse>
											<cf_get_lang dictionary_id='34091.Kesilmemiş'>
										</cfif>
									</cfif>
								<cfelse>
									<cfif GET_ALL_INVOICE_SHIPS.recordcount> 
									<cfloop query="GET_ALL_INVOICE_SHIPS">
										#GET_ALL_INVOICE_SHIPS.INVOICE_NUMBER#<cfif currentrow neq  GET_ALL_INVOICE_SHIPS.recordcount>,</cfif>
										</cfloop>
									<cfelse>
											<cf_get_lang dictionary_id='34091.Kesilmemiş'>
									</cfif>
								</cfif>
							</td>
						</tr>
						<tr id="SHIP_ROW_LIST#currentrow#" style="display:none;" class="color-row">
							<td colspan="9">
								<div id="SHIP_ROW_LIST#currentrow#_"></div>
							</td>
						</tr>
					</cfoutput>
					<tr>
						<td height="20" colspan="13">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id ='34107.İrsaliye Ekle'></cfsavecontent>
							<cf_workcube_buttons is_upd='0' is_cancel='0' insert_info='#message#' insert_alert='' add_function='kontrol()'>
						</td>
					</tr>
				<cfelse>
					<tr>
						<td colspan="13"><cfif isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
					</tr>
				</cfif>
			</tbody>
		</cf_flat_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfif isdefined("attributes.ship_list_type")>
				<cfset url_str = "#url_str#&ship_list_type=#attributes.ship_list_type#">
			</cfif>	
			<cf_paging
				page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="objects.popup_list_choice_ship&id=#attributes.id#&keyword=#attributes.keyword#&is_form_submitted=1#url_str#"> 
		</cfif>
	</cf_box>
</div>
<form name="add_ship" method="post" action="">
	<input type="hidden" name="company_ship" id="company_ship" value=""><!--- bu alanlar irsaliye secildikce dolduruluyor --->
	<cfif attributes.ship_list_type eq 1>
		<input type="hidden" name="kalan" id="kalan" value="">
	</cfif>
	<cfoutput>
	<input type="hidden" name="ship_period" id="ship_period" value="#attributes.ship_period#">
	<input type="hidden" name="ship_list_type" id="ship_list_type" value="#attributes.ship_list_type#">
	<input type="hidden" name="invoice_date" id="invoice_date" value="#attributes.invoice_date#">
    <input type="hidden" name="process_type" id="process_type" value="" />
	</cfoutput>
</form>
<script type="text/javascript">
document.getElementById('keyword').focus();
function check_all_ships()
	{	
		document.getElementById("company_ship").value = '';
		var check_leng = document.getElementsByName('_company_ship_').length;
		for(ci=0;ci<check_leng;ci++)
		{
			document.getElementsByName('_company_ship_')[ci].checked = (document.getElementById('is_check_all_ship').checked)?true:false;
			send_selected_ship( list_getat(document.getElementsByName('_company_ship_')[ci].value,1,'-') ,document.getElementById('is_check_all_ship').checked, list_getat(document.getElementsByName('_company_ship_')[ci].value,2,'-') <cfif attributes.ship_list_type eq 1>, list_getat(document.getElementsByName('_company_ship_')[ci].value,3,'-')</cfif>);
		}	
	}
function send_all_ships()
	{
		document.getElementById("company_ship").value = '';
		document.getElementById("process_type").value = '';
		if(document.getElementById("kalan") != undefined)
			document.getElementById("kalan").value = '';
		var check_leng = document.getElementsByName('_company_ship_').length;
	
		for(ci=0;ci<check_leng;ci++)
		{
			var deger_1 = list_getat(document.getElementsByName('_company_ship_')[ci].value,1,'-');
			var deger_2 = list_getat(document.getElementsByName('_company_ship_')[ci].value,2,'-');
			var deger_3 = list_getat(document.getElementsByName('_company_ship_')[ci].value,3,'-');
			send_selected_ship(deger_1,document.getElementsByName('_company_ship_')[ci].checked,deger_2,deger_3);
		}
	}
function send_ship_info()
	{
		<cfif attributes.ship_list_type eq 1>send_all_ships();</cfif>
		add_ship.action = '<cfoutput>#request.self#?fuseaction=objects.popup_add_ship#url_str#&xml_multiple_ref_no=#xml_multiple_ref_no#</cfoutput>';
		add_ship.submit();
	}	
function send_selected_ship(ship_info,info_type,process_type,kalan_ship_)
	{		
		if(info_type==1)
		{
			if(add_ship.company_ship.value=='')
				add_ship.company_ship.value = ship_info;
			else
				add_ship.company_ship.value = add_ship.company_ship.value+','+ship_info;
				
			if(add_ship.process_type.value=='')
				add_ship.process_type.value = process_type;
			else
				add_ship.process_type.value = add_ship.process_type.value+','+process_type;
		<cfif attributes.ship_list_type eq 1>	
			var kalan_deger = $("#kalan_"+kalan_ship_+"").val();
			kalan_deger = filterNum(kalan_deger);
			if(add_ship.kalan.value=='')
				add_ship.kalan.value = kalan_deger;
			else 
				{  
					if(add_ship.kalan.value=='')
						add_ship.kalan.value = kalan_deger;
					else
						add_ship.kalan.value = add_ship.kalan.value+';'+kalan_deger;
				}
		</cfif>
					
		}
		else if(info_type==2)
		{
			var old_ship_info= add_ship.company_ship.value;
			add_ship.company_ship.value='';
			for (var m=0; m<=list_len(old_ship_info); m++)
			{
				if(list_getat(old_ship_info,m)!=ship_info)
				{
					if(add_ship.company_ship.value=='')
						add_ship.company_ship.value = list_getat(old_ship_info,m);
					else
						add_ship.company_ship.value = add_ship.company_ship.value+','+list_getat(old_ship_info,m);
				}
			}
		}
	}
function kontrol()
	{
		
	<cfif not isdefined('attributes.from_ship')>
		if(window.opener!=undefined && window.opener.form_basket!=undefined && window.opener.form_basket.invoice_date!=undefined && window.opener.form_basket.invoice_date.value.length)
			document.add_ship.invoice_date.value = window.opener.form_basket.invoice_date.value;
		else
		{
			alert("<cf_get_lang dictionary_id ='34105.Lütfen Fatura Ekleme Ekranına Tarih Giriniz'>!");
			return false;
		}
	</cfif>
	send_ship_info();
	//return true;
	}
function control_period(period,required_period)
	{
		if(document.get_ship.ship_period.options[document.get_ship.ship_period.selectedIndex].value!='')
		{
			var temp_period_year_=list_getat(document.get_ship.ship_period.options[document.get_ship.ship_period.selectedIndex].value,2,';')
			var temp_process_cat_=list_getat(document.get_ship.cat.options[document.get_ship.cat.selectedIndex].value,1,'-')
			if(temp_period_year_ <= '<cfoutput>#session.ep.period_year-2#</cfoutput>' && list_find('72,75,77,79',temp_process_cat_)==0)
			{
				alert(temp_period_year_ + ' Dönemi Sadece Konsinye İşlem Tipi İle Birlikte Seçilebilir.');
				return false;
			}
		}
		if(period != undefined)
		{
			temp_period = list_getat(period,1,';');
			if(required_period != '' && required_period != temp_period )
			{
				alert("<cf_get_lang dictionary_id ='34106.Faturaya Çekilecek İrsaliyelerin Dönemi Aynı Olmalıdır'>!");
				<cfoutput query="GET_PERIOD_LIST">
					if(required_period == #GET_PERIOD_LIST.PERIOD_ID#)
					{
						document.get_ship.ship_period.value = '#GET_PERIOD_LIST.PERIOD_ID#;#GET_PERIOD_LIST.PERIOD_YEAR#';
					}
				</cfoutput>
			}
		}
		return true;
	}
</script>
