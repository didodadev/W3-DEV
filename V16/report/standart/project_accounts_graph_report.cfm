<!---
	!!!!!!!!!!!!!!!!!!!!!!
	Sayfada query yee gonderilen liste parametrelerini cfqueryparam list icerisine almayin veya alin ama max degere gore duzenleyin
	cfqueryparamda liste elemani max 2100 alabiliyor, ancak musterilerde daha fazla deger dondugunden hataya neden oluyor FBS 20121207
	!!!!!!!!!!!!!!!!!!!!!
	
		Type	Islem
		1		Verilen Hakedisler (+)
		2		Masraf Fisleri (-)
		3		Is Gucu Maliyetleri (-)
		4		Sarf Maliyetler (-)
		5		Verilen Hizmetler (+)
		6		Alinan Hizmetler (-)
		7		Toptan Satis Faturasi (+)
		8		Satilan Malin Maliyeti (-)
		9		Sarflar (-)		// Oran
		10		Genel Masraflar (-)		//Oran
		11		Alinan Hakedisler (-)
		12		Gelir Fisleri (+)
		13		Mal Alim Faturasi (-)	//Metal Icin
		14		Bakim Fisleri (-)
 --->
<cfparam name="attributes.module_id_control" default="1">
<cfinclude template="report_authority_control.cfm">
<cfsetting showdebugoutput="no"><!--- Excel'de sorun cikartiyor diye kapatildi.. M.E.Y 20120810--->
<cf_xml_page_edit fuseact="report.project_accounts_report">
<cfparam name="attributes.period_year" default="#session.ep.period_year#,#session.ep.period_id#,#session.ep.company_id#">
<cfset new_donem_data_source = "#dsn#_#ListGetAt(attributes.period_year,1,',')#_#ListGetAt(attributes.period_year,3,',')#">
<cfset new_sirket_data_source = "#dsn#_#ListGetAt(attributes.period_year,3,',')#">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.lower_projects" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.main_project_cat" default="">
<cfparam name="attributes.status" default="">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.start_date") and len(attributes.start_date)><cf_date tarih="attributes.start_date"></cfif>
<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)><cf_date tarih="attributes.finish_date"></cfif>

<cfset get_component = createObject("component","V16.report.standart.cfc.project_accounts_graph_report") />
<cfset GET_MONEY_RATE = get_component.GET_MONEY_RATE(dsn2:new_donem_data_source)>
<cfset tahsilat_toplam = 0>
<cfset odeme_toplam = 0 >
<cfquery name="GET_PERIOD" datasource="#DSN#">
    SELECT PERIOD, PERIOD_ID, PERIOD_YEAR, OUR_COMPANY_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> ORDER BY PERIOD_YEAR DESC
</cfquery>
<cfquery name="get_main_process_cat" datasource="#dsn#">
	SELECT
		DISTINCT
		SPC.MAIN_PROCESS_CAT_ID,
		SPC.MAIN_PROCESS_CAT,
		SPC.MAIN_PROCESS_TYPE
	FROM
		SETUP_MAIN_PROCESS_CAT_ROWS AS SPCR,
		SETUP_MAIN_PROCESS_CAT_FUSENAME AS SPCF,
		EMPLOYEE_POSITIONS AS EP,
		SETUP_MAIN_PROCESS_CAT SPC
	WHERE
		SPC.MAIN_PROCESS_CAT_ID = SPCR.MAIN_PROCESS_CAT_ID AND
		SPC.MAIN_PROCESS_CAT_ID = SPCF.MAIN_PROCESS_CAT_ID AND
		SPC.MAIN_PROCESS_MODULE IN (1) AND
		SPCF.FUSE_NAME = 'project.popup_updpro' AND
		EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND
		( SPCR.MAIN_POSITION_CODE = EP.POSITION_CODE OR SPCR.MAIN_POSITION_CAT_ID = EP.POSITION_CAT_ID )
	ORDER BY
		SPC.MAIN_PROCESS_CAT
</cfquery>
<cfquery name="get_workgroups" datasource="#DSN#">
	SELECT WORKGROUP_ID, WORKGROUP_NAME FROM WORK_GROUP WHERE STATUS = 1 AND HIERARCHY IS NOT NULL ORDER BY HIERARCHY
</cfquery>
<cfset Project_List = "">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Proje İcmal Raporu','39568')#">
		<cfform name="search_form" action="#request.self#?fuseaction=report.project_accounts_report" method="post">
			<cf_box_search>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
					<div class="form-group">
						<div class="input-group">
							<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
							<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
								<cfif len(attributes.project_id)>
									<cfquery name="get_project_head" datasource="#dsn#">
										SELECT EXPECTED_BUDGET,BUDGET_CURRENCY,TARGET_START,TARGET_FINISH,PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
									</cfquery>
									<cfif session.ep.period_year gt 2008 and isdefined('get_project_head.budget_currency') and get_project_head.budget_currency is 'YTL'><cfset get_project_head.budget_currency = 'TL'></cfif>
									<cfif session.ep.period_year lt 2009 and isdefined('get_project_head.budget_currency') and get_project_head.budget_currency is 'TL'><cfset get_project_head.budget_currency = 'YTL'></cfif>
									<cfquery name="get_money" datasource="#new_donem_data_source#">
										SELECT (RATE2/RATE1) AS RATE FROM SETUP_MONEY WHERE MONEY = '#get_project_head.budget_currency#'
									</cfquery>
									<cfif not get_money.recordcount><cfset rate_info = 1><cfelse><cfset rate_info = get_money.rate></cfif>
									<cfquery name="get_money2" datasource="#new_donem_data_source#">
										SELECT (RATE2/RATE1) AS RATE FROM SETUP_MONEY WHERE MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
									</cfquery>
								</cfif>
								<div class="input-group">
									<input type="hidden" name="project_id" id="project_id" value="<cfif len(attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
									<input type="text" name="project_head" id="project_head" onChange="lower_project();" onClick="lower_project();" value="<cfif len(attributes.project_id) and len(get_project_head.project_head)><cfoutput>#get_project_head.project_head#</cfoutput></cfif>"  onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
									<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=search_form.project_id&project_head=search_form.project_head&function_name=lower_project');"></span>
								</div>
							</div>
						</div>
					</div>
					<div class="form-group">
						<div class="input-group">
							<label class="col col-12"><cf_get_lang dictionary_id='58472.Dönem'></label>
							<div class="col col-12 col-xs-12">
								<select name="period_year" id="period_year">
									<cfoutput query="get_period">
										<option value="#period_year#,#period_id#,#our_company_id#"<cfif attributes.period_year eq '#period_year#,#period_id#,#our_company_id#'> selected</cfif>>#period#</option>
									</cfoutput>
								</select>
							</div>
						</div>
					</div>
					<div class="form-group">
						<div class="input-group">
							<label class="col col-12"><cf_get_lang dictionary_id="58140.İş Grubu"></label>
							<div class="col col-12 col-xs-12">
								<select name="workgroup_id" id="workgroup_id">		
									<option value=""><cf_get_lang dictionary_id="58140.İş Grubu"></option>
									<cfoutput query="get_workgroups">
										<option value="#workgroup_id#" <cfif isdefined("attributes.workgroup_id") and workgroup_id eq attributes.workgroup_id>selected</cfif>>#workgroup_name#</option>
									</cfoutput>
								</select>
							</div>
						</div>
					</div>								
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
					<div class="form-group">					
						<div class="input-group">
							<label class="col col-12"><cf_get_lang dictionary_id='57742.Tarih'></label>
							<div class="col col-6">
								<div class="input-group col col-11">
									<input name="start_date" id="start_date" type="text" value="<cfoutput>#dateformat(attributes.start_date,dateformat_style)#</cfoutput>" validate="<cfoutput>#validate_style#</cfoutput>"> 
									<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>            
								</div>
							</div>						
							<div class="col col-6">
								<div class="input-group">
									<input name="finish_date" id="finish_date" type="text" value="<cfoutput>#dateformat(attributes.finish_date,dateformat_style)#</cfoutput>" validate="<cfoutput>#validate_style#</cfoutput>">
									<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>  
								</div>
							</div>
						</div>											
					</div>
					<div class="form-group">
						<div class="input-group">
							<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id="57756.Durum"></label>
							<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
								<select name="status" id="status">
									<option value=""><cf_get_lang dictionary_id="57708.Tümü"></option>
									<option value="1"<cfif attributes.status eq 1>selected</cfif>><cf_get_lang dictionary_id="57493.Aktif"></option>
									<option value="0"<cfif attributes.status eq 0>selected</cfif>><cf_get_lang dictionary_id="57494.Pasif"></option>
								</select>		
							</div>
						</div>
					</div>
					<div class="form-group" id="low_pro" <cfif (not len(attributes.project_head))>style="display:none"</cfif>>
						<div class="input-group">
							<br/>
							<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
								<input type="checkbox" name="lower_projects" id="lower_projects" value="1" <cfif len(attributes.lower_projects)>checked</cfif>><cf_get_lang dictionary_id ='40036.Alt Projeleri Getir'>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
					<div class="form-group" id="CatID" <cfif len(attributes.project_id) and len(attributes.project_head)>style="display:none"</cfif>>
						<div class="input-group">
							<label class="col col-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
							<div class="col col-12 col-xs-12">
								<select name="main_project_cat" id="main_project_cat" multiple>
									<cfoutput query="get_main_process_cat">
									<option value="#main_process_cat_id#" <cfif ListFind(attributes.main_project_cat,main_process_cat_id,',')>selected</cfif>>#main_process_cat#</option>
									</cfoutput>
								</select>
							</div>
						</div>
					</div>				
				</div>
			</cf_box_search>
			<div class="row ReportContentBorder">
				<div class="ReportContentFooter">
					<label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Sayi_Hatasi_Mesaj','57537')#" onKeyUp="isNumber(this)" maxlength="3">
					<input type="hidden" name="form_submit" id="form_submit" value="1">
					<cf_wrk_report_search_button search_function='control()' button_type='1' is_excel="1">
				</div>
			</div>			
		</cfform>
	</cf_box>

<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
	<cfset filename = "#createuuid()#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-8">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</cfif>
<cfquery name="check_table" datasource="#dsn#">
	IF EXISTS(SELECT * FROM tempdb.sys.tables where name='####GET_PROJECT_CAT_#session.ep.userid#')
	drop table ####GET_PROJECT_CAT_#session.ep.userid#
</cfquery>
<cfquery name="Get_Project_Cat" datasource="#dsn#">
	SELECT 
		PROJECT_ID 
	INTO ####GET_PROJECT_CAT_#session.ep.userid#
	FROM 
		PRO_PROJECTS 
	WHERE 
		<cfif ListLen(attributes.main_project_cat)>
			PROCESS_CAT IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.main_project_cat#" list="yes">)
		<cfelseif get_main_process_cat.recordcount>
			PROCESS_CAT IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#valuelist(get_main_process_cat.MAIN_PROCESS_CAT_ID)#" list="yes">)
		<cfelse>
			1=0
		</cfif>
		<cfif isdefined("attributes.workgroup_id") and len(attributes.workgroup_id)>
			AND WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.workgroup_id#">
		</cfif>
		<cfif Len(attributes.status)>
			AND PROJECT_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.status#">
		</cfif>
		
		SELECT TOP 1 * FROM ####GET_PROJECT_CAT_#session.ep.userid#
</cfquery>
<cfif Len(attributes.project_id) and Len(attributes.project_head)>
	<cfquery name="Get_Project_Id" datasource="#dsn#">
		SELECT 
			PROJECT_ID 
		FROM 
			PRO_PROJECTS 
		WHERE 
			PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
			<cfif isdefined("attributes.workgroup_id") and len(attributes.workgroup_id)>
				AND WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.workgroup_id#">
			</cfif>
			<cfif Len(attributes.status)>
				AND PROJECT_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.status#">
			</cfif>
	</cfquery>
	<cfset Project_List = Get_Project_Id.Project_Id>
</cfif>
<cfif isdefined('attributes.form_submit')><!--- Bu kisim hem tekli hemde çoklu dökümde kullanildigi için form submit edildiginde çalisiyor. --->
	<cfquery name="GET_EXPENSE_SARF_COMPARE" datasource="#new_donem_data_source#"><!--- Türm sarflar ile bütçelerdeki yapilan tüm giderleri getiriyor.--->
		SELECT 
			9 TYPE,
			ISNULL(SUM(MALIYET*STOCK_OUT),0) PRICE
			<cfif len(session.ep.money2)>
				,ISNULL(SUM((MALIYET*STOCK_OUT)/STOCK_FIS_MONEY.RATE2),0) OTHER_PRICE
			<cfelse>
				,0 OTHER_PRICE
			</cfif>
		FROM 
			GET_STOCKS_ROW_COST,
			STOCK_FIS
			<cfif len(session.ep.money2)>
				,STOCK_FIS_MONEY
			</cfif>
		WHERE 
			<cfif len(session.ep.money2)>
				STOCK_FIS.FIS_ID = STOCK_FIS_MONEY.ACTION_ID AND
				STOCK_FIS_MONEY.MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#"> AND
			</cfif>
			STOCK_FIS.FIS_ID = GET_STOCKS_ROW_COST.UPD_ID AND
			STOCK_FIS.FIS_TYPE = 111 AND
            <cfif isdefined("x_is_show_from_prodution_fis") and x_is_show_from_prodution_fis eq 1>
        	    STOCK_FIS.PROD_ORDER_NUMBER IS NULL AND<!--- Üretimden oluşanlar sarflar gelince sarf maliyetini 2ye katladığı gerekçesi ile kaldırıldı --->
            </cfif>
			GET_STOCKS_ROW_COST.PROCESS_TYPE = STOCK_FIS.FIS_TYPE
	UNION ALL
		SELECT 
			10 TYPE,
			ISNULL(SUM(EXPENSE_ITEMS_ROWS.AMOUNT*ISNULL(EXPENSE_ITEMS_ROWS.QUANTITY,1)),0) AS PRICE
			<cfif len(session.ep.money2)>
				,ISNULL(SUM((EXPENSE_ITEMS_ROWS.AMOUNT*ISNULL(EXPENSE_ITEMS_ROWS.QUANTITY,1))/(#dsn_alias#.IS_ZERO(EXPENSE_ITEMS_ROWS.TOTAL_AMOUNT,1)/#dsn_alias#.IS_ZERO(OTHER_MONEY_VALUE_2,1))),0) OTHER_PRICE
			<cfelse>
				,0 OTHER_PRICE
			</cfif>
		FROM 
			EXPENSE_ITEMS_ROWS,
			EXPENSE_CENTER 
		WHERE 
			EXPENSE_CENTER.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_CENTER_ID AND
			IS_INCOME = 0 AND
			IS_GENERAL = 1
	</cfquery>
	<cfset type_list_compare = '9,10'><!--- Genel gider yansimalari için tipler --->
	<cfif get_expense_sarf_compare.recordcount>
		<cfloop query="get_expense_sarf_compare">
			<cfif type eq 9>
				<cfset sarf_genel_toplam = price>
				<cfset other_sarf_genel_toplam = other_price>
			</cfif>
			<cfif not ListFind(type_list_compare,9)>
				<cfset sarf_genel_toplam =0>
				<cfset other_sarf_genel_toplam = 0>
			</cfif><!--- Eger kayit gelmiyorsa sarflara ait,0 set ediliyor. --->
			<cfif type eq 10>
				<cfset masraffisi_genel_toplam=price>
				<cfset other_masraffisi_genel_toplam=other_price>
			</cfif>
			<cfif not ListFind(type_list_compare,10)>
				<cfset masraffisi_genel_toplam = 0>
				<cfset other_masraffisi_genel_toplam = 0>
			</cfif><!--- Eger kayit gelmiyorsa masraflar 0 set ediliyor. --->
		</cfloop>
	</cfif>
</cfif>
	<cfif Len(Project_List) and not len(attributes.lower_projects)>
		<cfquery name="Get_Time_Cost_Money2" datasource="#dsn#">
			SELECT (RATE2/RATE1) RATE2 FROM #dsn_alias#.SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND MONEY = '#session.ep.money2#'
		</cfquery>
		<cfif Get_Time_Cost_Money2.RecordCount><cfset Omv2 = Get_Time_Cost_Money2.Rate2><cfelse><cfset Omv2 = 1></cfif>
		<cfquery name="GET_ALL_PRICE" datasource="#new_donem_data_source#">
			SELECT
				TYPE,
				ISNULL(SUM(PRICE),0) PRICE,
				ISNULL(SUM(OTHER_PRICE),0) OTHER_PRICE
			FROM
			(
				SELECT
					<!--- Verilen Hakedisler --->
					1 TYPE,
					ISNULL(SUM(INVOICE_ROW.NETTOTAL),0) AS PRICE
					<cfif len(session.ep.money2)>
						,ISNULL(SUM(INVOICE_ROW.NETTOTAL/INVOICE_MONEY.RATE2),0) OTHER_PRICE
					<cfelse>
						,0 OTHER_PRICE
					</cfif>
				FROM 
					INVOICE,
					INVOICE_ROW
					<cfif len(session.ep.money2)>
						,INVOICE_MONEY
					</cfif>
				WHERE
					INVOICE.INVOICE_ID = INVOICE_ROW.INVOICE_ID AND
					<cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(INVOICE_ROW.ROW_PROJECT_ID,INVOICE.PROJECT_ID)<cfelse>ISNULL(INVOICE.PROJECT_ID,INVOICE_ROW.ROW_PROJECT_ID)</cfif> IN (#Project_List#) AND
					<cfif len(session.ep.money2)>
						INVOICE.INVOICE_ID = INVOICE_MONEY.ACTION_ID AND
						INVOICE_MONEY.MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#"> AND
					</cfif>
					INVOICE.INVOICE_CAT = 561 AND
					INVOICE.IS_IPTAL = 0
					<cfif isdefined('attributes.start_date') and len(attributes.start_date)>
						AND INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
					</cfif>
					<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
						AND INVOICE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
					</cfif>
			UNION ALL
				SELECT 
					<!--- Alinan Hakedisler --->
					11 TYPE,
					ISNULL(SUM(INVOICE_ROW.NETTOTAL),0) AS PRICE
					<cfif len(session.ep.money2)>
						,ISNULL(SUM(INVOICE_ROW.NETTOTAL/INVOICE_MONEY.RATE2),0) OTHER_PRICE
					<cfelse>
						,0 OTHER_PRICE
					</cfif>
				FROM 
					INVOICE,
					INVOICE_ROW
					<cfif len(session.ep.money2)>
						,INVOICE_MONEY
					</cfif>
				WHERE
					INVOICE.INVOICE_ID = INVOICE_ROW.INVOICE_ID AND
					<cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(INVOICE_ROW.ROW_PROJECT_ID,INVOICE.PROJECT_ID)<cfelse>ISNULL(INVOICE.PROJECT_ID,INVOICE_ROW.ROW_PROJECT_ID)</cfif> IN (#Project_List#) AND
					<cfif len(session.ep.money2)>
						INVOICE.INVOICE_ID = INVOICE_MONEY.ACTION_ID AND
						INVOICE_MONEY.MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#"> AND
					</cfif>
					INVOICE.INVOICE_CAT = 601 AND
					INVOICE.IS_IPTAL = 0
					<cfif isdefined('attributes.start_date') and len(attributes.start_date)>
						AND INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
					</cfif>
					<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
						AND INVOICE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
					</cfif>
			UNION ALL
				SELECT
					<!--- Masraf Fisleri --->
					2 TYPE,
					ISNULL(SUM(EIR.QUANTITY*EIR.AMOUNT),0) AS PRICE
					<cfif len(session.ep.money2)>
						,ISNULL(SUM((EIR.QUANTITY*EIR.AMOUNT)/#dsn_alias#.IS_ZERO((EIR.TOTAL_AMOUNT/#dsn_alias#.IS_ZERO(OTHER_MONEY_VALUE_2,1)),1)),0) OTHER_PRICE
					<cfelse>
						,0 OTHER_PRICE
					</cfif>
				FROM
					EXPENSE_ITEM_PLANS EIP,
					EXPENSE_ITEMS_ROWS EIR
				WHERE 
					EIR.INVOICE_ID IS NULL AND <!--- Faturadan otomatik oluşturulmuş olan masraflar buraya gelmesin,çünkü zaten satışlar kısmına yansıyor buraya yansımaması lazım. --->
					EIR.IS_INCOME = 0 AND
					EIP.EXPENSE_ID = EIR.EXPENSE_ID AND
					EIP.ACTION_TYPE = 120 AND <!--- Masraf Fisi Islem Tipi --->
					<cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(EIR.PROJECT_ID,EIP.PROJECT_ID)<cfelse>ISNULL(EIP.PROJECT_ID,EIR.PROJECT_ID)</cfif> IN (#Project_List#)
					<cfif isdefined('attributes.start_date') and len(attributes.start_date)>
						AND EIP.EXPENSE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
					</cfif>
					<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
						AND EIP.EXPENSE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
					</cfif>
			UNION ALL
				SELECT
					<!--- Bakim Fisleri --->
					14 TYPE,
					ISNULL(SUM(EIR.AMOUNT),0) AS PRICE
					<cfif len(session.ep.money2)>
						,ISNULL(SUM((EIR.AMOUNT)/#dsn_alias#.IS_ZERO((EIR.TOTAL_AMOUNT/#dsn_alias#.IS_ZERO(OTHER_MONEY_VALUE_2,1)),1)),0) OTHER_PRICE
					<cfelse>
						,0 OTHER_PRICE
					</cfif>
				FROM
					EXPENSE_ITEM_PLANS EIP,
					EXPENSE_ITEMS_ROWS EIR
				WHERE 
					INVOICE_ID IS NULL AND <!--- Faturadan otomatik oluşturulmuş olan masraflar buraya gelmesin,çünkü zaten satışlar kısmına yansıyor buraya yansımaması lazım. --->
					EIR.IS_INCOME = 0 AND
					EIP.EXPENSE_ID = EIR.EXPENSE_ID AND
					EIP.ACTION_TYPE = 122 AND <!--- Bakim Fisi Islem Tipi --->
					<cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(EIR.PROJECT_ID,EIP.PROJECT_ID)<cfelse>ISNULL(EIP.PROJECT_ID,EIR.PROJECT_ID)</cfif> IN (#Project_List#)
					<cfif isdefined('attributes.start_date') and len(attributes.start_date)>
						AND EIP.EXPENSE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
					</cfif>
					<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
						AND EIP.EXPENSE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
					</cfif>
			UNION ALL
				SELECT
					<!--- Gelir Fisi --->
					12 TYPE,
					ISNULL(SUM(EIR.AMOUNT),0) AS PRICE
					<cfif len(session.ep.money2)>
						,ISNULL(SUM((EIR.AMOUNT)/#dsn_alias#.IS_ZERO((EIR.TOTAL_AMOUNT/#dsn_alias#.IS_ZERO(OTHER_MONEY_VALUE_2,1)),1)),0) OTHER_PRICE
					<cfelse>
						,0 OTHER_PRICE
					</cfif>
				FROM
					EXPENSE_ITEM_PLANS EIP,
					EXPENSE_ITEMS_ROWS EIR
				WHERE 
					EIR.INVOICE_ID IS NULL AND <!--- Faturadan otomatik oluşturulmuş olan masraflar buraya gelmesin,çünkü zaten satışlar kısmına yansıyor buraya yansımaması lazım. --->
					EIR.IS_INCOME = 1 AND
					EIP.EXPENSE_ID = EIR.EXPENSE_ID AND
					EIP.ACTION_TYPE = 121 AND <!--- Gelir Fisi Islem Tipi --->
					<cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(EIR.PROJECT_ID,EIP.PROJECT_ID)<cfelse>ISNULL(EIP.PROJECT_ID,EIR.PROJECT_ID)</cfif> IN (#Project_List#)
					<cfif isdefined('attributes.start_date') and len(attributes.start_date)>
						AND EIP.EXPENSE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
					</cfif>
					<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
						AND EIP.EXPENSE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
					</cfif>	
			UNION ALL
				SELECT 
					<!--- Is Gücü Maliyetleri --->
					3 TYPE,
					ISNULL(SUM(EXPENSED_MONEY),0) EXPENSED_MONEY,
					<cfif len(session.ep.money2)>
						ISNULL(SUM(EXPENSED_MONEY/#Omv2#),0) AS OTHER_EXPENSED_MONEY
					<cfelse>
						0 OTHER_EXPENSED_MONEY
					</cfif>
				FROM
					#dsn_alias#.TIME_COST AS TIME_COST
				WHERE
					PROJECT_ID IN (#Project_List#)
					<cfif isdefined('attributes.start_date') and len(attributes.start_date)>
						AND EVENT_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
					</cfif>
					<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
						AND EVENT_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
					</cfif>
			<cfif isdefined("is_cost_of_material") and is_cost_of_material eq 1><!--- xmlde Malzeme Maliyetini Goster evet ise --->
			UNION ALL
				SELECT 
					<!--- Sarf Maliyetler --->
					4 TYPE,
					ISNULL(SUM(MALIYET*STOCK_OUT),0) AS TOPLAM_MALIYET
					<cfif len(session.ep.money2)>
						,ISNULL(SUM(MALIYET2*STOCK_OUT),0) OTHER_TOPLAM_MALIYET
					<cfelse>
						,0 OTHER_TOPLAM_MALIYET
					</cfif>
				FROM
				(
					SELECT
						ISNULL((SELECT
							TOP 1 (PURCHASE_NET_SYSTEM + PURCHASE_EXTRA_COST_SYSTEM)  
						FROM 
							GET_PRODUCT_COST_PERIOD
						WHERE
							GET_PRODUCT_COST_PERIOD.START_DATE <= STOCK_FIS.FIS_DATE
							AND GET_PRODUCT_COST_PERIOD.PRODUCT_ID = S.PRODUCT_ID
							AND ISNULL(GET_PRODUCT_COST_PERIOD.SPECT_MAIN_ID,0)=ISNULL(STOCK_FIS_ROW.SPECT_VAR_ID,0)
						ORDER BY
							GET_PRODUCT_COST_PERIOD.START_DATE DESC,
							GET_PRODUCT_COST_PERIOD.RECORD_DATE DESC,
							GET_PRODUCT_COST_PERIOD.PRODUCT_COST_ID DESC
							),0) MALIYET,
						<cfif len(session.ep.money2)>
							ISNULL((SELECT
								TOP 1 (PURCHASE_NET_SYSTEM + PURCHASE_EXTRA_COST_SYSTEM)  
							FROM 
								GET_PRODUCT_COST_PERIOD
							WHERE
								GET_PRODUCT_COST_PERIOD.START_DATE <= STOCK_FIS.FIS_DATE
								AND GET_PRODUCT_COST_PERIOD.PRODUCT_ID = S.PRODUCT_ID
								AND ISNULL(GET_PRODUCT_COST_PERIOD.SPECT_MAIN_ID,0)=ISNULL(STOCK_FIS_ROW.SPECT_VAR_ID,0)
							ORDER BY
								GET_PRODUCT_COST_PERIOD.START_DATE DESC,
								GET_PRODUCT_COST_PERIOD.RECORD_DATE DESC,
								GET_PRODUCT_COST_PERIOD.PRODUCT_COST_ID DESC
								),0)/STOCK_FIS_MONEY.RATE2 MALIYET2,
						<cfelse>
							0 MALIYET2,
						</cfif>	
						STOCK_FIS_ROW.AMOUNT STOCK_OUT
					FROM
						STOCK_FIS_ROW,
						STOCK_FIS,
						#dsn3_alias#.STOCKS S
						<cfif len(session.ep.money2)>
							,STOCK_FIS_MONEY
						</cfif>
					WHERE 
						<cfif len(session.ep.money2)>
							STOCK_FIS.FIS_ID = STOCK_FIS_MONEY.ACTION_ID AND
							STOCK_FIS_MONEY.MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#"> AND
						</cfif>
						STOCK_FIS.FIS_ID = STOCK_FIS_ROW.FIS_ID AND 
						S.STOCK_ID = STOCK_FIS_ROW.STOCK_ID AND 
						STOCK_FIS.FIS_TYPE = 111 AND
						<cfif isdefined("x_is_show_from_prodution_fis") and x_is_show_from_prodution_fis eq 1>
							STOCK_FIS.PROD_ORDER_NUMBER IS NULL AND<!--- Üretimden oluşanlar sarflar gelince sarf maliyetini 2ye katladığı gerekçesi ile kaldırıldı --->
						</cfif>
						<cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(STOCK_FIS_ROW.ROW_PROJECT_ID,STOCK_FIS.PROJECT_ID)<cfelse>STOCK_FIS.PROJECT_ID</cfif> IN (#Project_List#)
					<cfif isdefined('attributes.start_date') and len(attributes.start_date)>
						AND FIS_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
					</cfif>
					<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
						AND FIS_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
					</cfif>
				)T1
			</cfif>
			UNION ALL
				SELECT	
					<!--- Verilen Hizmetler --->
					5 TYPE,
					ISNULL(SUM(INVOICE_ROW.NETTOTAL),0) AS PRICE
					<cfif len(session.ep.money2)>
						,ISNULL(SUM(INVOICE_ROW.NETTOTAL/INVOICE_MONEY.RATE2),0) OTHER_PRICE
					<cfelse>
						,0 OTHER_PRICE
					</cfif>
				FROM 
					INVOICE,
					INVOICE_ROW
					<cfif len(session.ep.money2)>
						,INVOICE_MONEY
					</cfif>
				WHERE
					INVOICE.INVOICE_ID = INVOICE_ROW.INVOICE_ID AND
					<cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(INVOICE_ROW.ROW_PROJECT_ID,INVOICE.PROJECT_ID)<cfelse>ISNULL(INVOICE.PROJECT_ID,INVOICE_ROW.ROW_PROJECT_ID)</cfif> IN (#Project_List#) AND
					<cfif len(session.ep.money2)>
						INVOICE.INVOICE_ID = INVOICE_MONEY.ACTION_ID AND
						INVOICE_MONEY.MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#"> AND
					</cfif>
					INVOICE.INVOICE_CAT = 56 AND
					INVOICE.IS_IPTAL = 0
					<cfif isdefined('attributes.start_date') and len(attributes.start_date)>
						AND INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
					</cfif>
					<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
						AND INVOICE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
					</cfif>
			UNION ALL
				<!--- Satislar : Bu asagidaki 2li union blokta satis iade faturalarida çekiliyor ve satis faturalarindan çikariliyor. --->
				SELECT
					7 TYPE,
					ISNULL(SUM(PRICE_P)-SUM(PRICE_N),0) PRICE
					<cfif len(session.ep.money2)>
						,ISNULL(SUM(OTHER_PRICE_P)-SUM(OTHER_PRICE_N),0) OTHER_PRICE
					<cfelse>
						,0 OTHER_PRICE
					</cfif>
				FROM
				(
					SELECT 
						ISNULL(SUM(INVOICE_ROW.NETTOTAL),0) AS PRICE_P,
						0 PRICE_N
						<cfif len(session.ep.money2)>
							,ISNULL(SUM(INVOICE_ROW.NETTOTAL/INVOICE_MONEY.RATE2),0) OTHER_PRICE_P,
							0 OTHER_PRICE_N
						</cfif>
					FROM 
						INVOICE,
						INVOICE_ROW
						<cfif len(session.ep.money2)>
							,INVOICE_MONEY
						</cfif>
					WHERE
						INVOICE.INVOICE_ID = INVOICE_ROW.INVOICE_ID AND
						<cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(INVOICE_ROW.ROW_PROJECT_ID,INVOICE.PROJECT_ID)<cfelse>ISNULL(INVOICE.PROJECT_ID,INVOICE_ROW.ROW_PROJECT_ID)</cfif> IN (#Project_List#) AND
						<cfif len(session.ep.money2)>
							INVOICE.INVOICE_ID = INVOICE_MONEY.ACTION_ID AND
							INVOICE_MONEY.MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#"> AND
						</cfif>
						<!--- 53 Toptan Satis F, 531 ihracat F, 63 Alinan Fiyat Farki F --->
						INVOICE.INVOICE_CAT IN(53,531,58,5310,5311,5312,651) AND
						INVOICE.IS_IPTAL = 0
						<cfif isdefined('attributes.start_date') and len(attributes.start_date)>
							AND INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
						</cfif>
						<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
							AND INVOICE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
						</cfif>
				UNION ALL
					SELECT 
						0 PRICE_P,
						ISNULL(SUM(INVOICE_ROW.NETTOTAL),0) AS PRICE_N
						<cfif len(session.ep.money2)>
							,0 OTHER_PRICE_P,
							SUM(ISNULL(INVOICE_ROW.NETTOTAL/INVOICE_MONEY.RATE2,0)) OTHER_PRICE_N
						</cfif>
					FROM 
						INVOICE,
						INVOICE_ROW
						<cfif len(session.ep.money2)>
							,INVOICE_MONEY
						</cfif>
					WHERE
						INVOICE.INVOICE_ID = INVOICE_ROW.INVOICE_ID AND
						<cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(INVOICE_ROW.ROW_PROJECT_ID,INVOICE.PROJECT_ID)<cfelse>ISNULL(INVOICE.PROJECT_ID,INVOICE_ROW.ROW_PROJECT_ID)</cfif> IN (#Project_List#) AND
						<cfif len(session.ep.money2)>
							INVOICE.INVOICE_ID = INVOICE_MONEY.ACTION_ID AND
							INVOICE_MONEY.MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#"> AND
						</cfif>
						<!---58 Verilen Fiyat Farki Faturasi,55 Topt Sat Iade Fatura  --->
						INVOICE.INVOICE_CAT IN(55,63,5313) AND
						INVOICE.IS_IPTAL = 0
						<cfif isdefined('attributes.start_date') and len(attributes.start_date)>
							AND INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
						</cfif>
						<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
							AND INVOICE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
						</cfif>
				) T1
			UNION ALL
				SELECT 
					<!--- Alinan Hizmetler --->
					6 TYPE,
					ISNULL(SUM(INVOICE_ROW.NETTOTAL),0) AS PRICE
					<cfif len(session.ep.money2)>
						,ISNULL(SUM(INVOICE_ROW.NETTOTAL/INVOICE_MONEY.RATE2),0) OTHER_PRICE
					<cfelse>
						,0 OTHER_PRICE
					</cfif>
				FROM 
					INVOICE,
					INVOICE_ROW
					<cfif len(session.ep.money2)>
						,INVOICE_MONEY
					</cfif>
				WHERE
					INVOICE.INVOICE_ID = INVOICE_ROW.INVOICE_ID AND
					<cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(INVOICE_ROW.ROW_PROJECT_ID,INVOICE.PROJECT_ID)<cfelse>ISNULL(INVOICE.PROJECT_ID,INVOICE_ROW.ROW_PROJECT_ID)</cfif> IN (#Project_List#) AND
					<cfif len(session.ep.money2)>
						INVOICE.INVOICE_ID = INVOICE_MONEY.ACTION_ID AND
						INVOICE_MONEY.MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#"> AND
					</cfif>
					INVOICE.INVOICE_CAT IN (60) AND
						INVOICE.IS_IPTAL = 0
					<cfif isdefined('attributes.start_date') and len(attributes.start_date)>
						AND INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
					</cfif>
					<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
						AND INVOICE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
					</cfif>	
			<cfif isdefined("is_cost_of_product_sold") and is_cost_of_product_sold eq 1><!--- xmlde Satılan Malin Maliyetini Goster evet ise --->
			UNION ALL
				SELECT   
					8 TYPE,
					ISNULL((SUM(TOPLAM_MALIYET_P)- SUM(TOPLAM_MALIYET_N)),0) TOPLAM_MALIYET_
					<cfif len(session.ep.money2)>
						,ISNULL((SUM(OTHER_TOPLAM_MALIYET_P)-SUM(OTHER_TOPLAM_MALIYET_N)),0) OTHER_TOPLAM_MALIYET_
					<cfelse>
						,0 OTHER_TOPLAM_MALIYET_
					</cfif>
				FROM
				(
					SELECT 
						ISNULL(SUM(MALIYET*STOCK_OUT),0)AS TOPLAM_MALIYET_P,
						ISNULL(SUM(MALIYET*STOCK_IN),0) AS TOPLAM_MALIYET_N
						<cfif len(session.ep.money2) and session.ep.money2 is not session.ep.money> <!--- sistem 2. para br olarak sistem para birimi secilmisse SHIP_MONEY tablosuna baglanılmıyor--->
							,ISNULL(SUM((MALIYET*STOCK_OUT)/SHIP_MONEY.RATE2),0) OTHER_TOPLAM_MALIYET_P
							,ISNULL(SUM((MALIYET*STOCK_IN)/SHIP_MONEY.RATE2),0) OTHER_TOPLAM_MALIYET_N
						<cfelseif len(session.ep.money2)>
							,ISNULL(SUM(MALIYET*STOCK_OUT),0) OTHER_TOPLAM_MALIYET_P
							,ISNULL(SUM(MALIYET*STOCK_IN),0) OTHER_TOPLAM_MALIYET_N
						</cfif>
					FROM 
						GET_STOCKS_ROW_COST,
						SHIP
						<cfif len(session.ep.money2) and session.ep.money2 is not session.ep.money>
						,SHIP_MONEY					
						</cfif>					
					WHERE
						<cfif len(session.ep.money2) and session.ep.money2 is not session.ep.money>
							SHIP.SHIP_ID = SHIP_MONEY.ACTION_ID AND
							SHIP_MONEY.MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#"> AND
							SHIP.IS_WITH_SHIP = 0 AND<!---SHIP_MONEY tablosuna baglanıldıgında sadece bagımsız olarak olusturulan irsaliyeler bu blokta getiriliyor, faturadan olusturulan irsaliyeler diger blokta çekiliyor --->
						</cfif>
						SHIP.SHIP_ID=GET_STOCKS_ROW_COST.UPD_ID AND
						SHIP.SHIP_TYPE IN (71,74,88) AND <!---88:ihracat eklendi PY   71: Toptan Satis irsaliyesi (cikis) ve 74:Toptan Satis *Iade* Irsaliyesi (Giris)  ---> 
						IS_SHIP_IPTAL = 0 AND
						GET_STOCKS_ROW_COST.PROCESS_TYPE = SHIP.SHIP_TYPE AND
						SHIP.PROJECT_ID IN (#Project_List#)
						<cfif isdefined('attributes.start_date') and len(attributes.start_date)>
							AND SHIP.SHIP_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
						</cfif>
						<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
							AND SHIP.SHIP_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
						</cfif>
					 GROUP BY
						PROJECT_ID
					<cfif len(session.ep.money2) and session.ep.money2 is not session.ep.money> <!--- sistem 2. para birimi varsa faturadan olusturulan irsaliyeler bu blokta cekiliyor --->
					UNION ALL
						SELECT 
							ISNULL(SUM(MALIYET*STOCK_OUT),0)AS TOPLAM_MALIYET_P,
							ISNULL(SUM(MALIYET*STOCK_IN),0) AS TOPLAM_MALIYET_N
							,ISNULL(SUM((MALIYET*STOCK_OUT)/IM.RATE2),0) OTHER_TOPLAM_MALIYET_P
							,ISNULL(SUM((MALIYET*STOCK_IN)/IM.RATE2),0) OTHER_TOPLAM_MALIYET_N
						FROM 
							SHIP,
							INVOICE,
							INVOICE_ROW,
							INVOICE_SHIPS INV_S,
							INVOICE_MONEY IM,
							GET_STOCKS_ROW_COST GC
						WHERE
							SHIP.SHIP_ID = INV_S.SHIP_ID
							AND INVOICE.INVOICE_ID= INV_S.INVOICE_ID
							AND INVOICE.INVOICE_ID = INVOICE_ROW.INVOICE_ID
							AND INVOICE_ROW.INVOICE_ID = INV_S.INVOICE_ID
							AND INVOICE_ROW.STOCK_ID = GC.STOCK_ID
							AND SHIP.IS_WITH_SHIP = 1
							AND INV_S.SHIP_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
							AND SHIP.SHIP_ID = GC.UPD_ID
							AND SHIP.SHIP_TYPE = GC.PROCESS_TYPE
							AND SHIP.SHIP_TYPE IN (71,74,88) 
							AND INVOICE.IS_IPTAL = 0
							AND IM.ACTION_ID=INVOICE.INVOICE_ID
							AND IM.MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
							AND <cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(INVOICE_ROW.ROW_PROJECT_ID,INVOICE.PROJECT_ID)<cfelse>ISNULL(INVOICE.PROJECT_ID,INVOICE_ROW.ROW_PROJECT_ID)</cfif> IN (#Project_List#)
							<cfif isdefined('attributes.start_date') and len(attributes.start_date)>
								AND SHIP.SHIP_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
							</cfif>
							<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
								AND SHIP.SHIP_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
							</cfif>
					</cfif>
				) T2  
			</cfif>
			<!--- xmlde Alımları Goster evet ise --->
			
			UNION ALL
				SELECT	   
					13 TYPE,
					ISNULL((SUM(TOPLAM_MALIYET_P)- SUM(TOPLAM_MALIYET_N)),0) TOPLAM_MALIYET_
					<cfif len(session.ep.money2)>
						,ISNULL((SUM(OTHER_TOPLAM_MALIYET_P)-SUM(OTHER_TOPLAM_MALIYET_N)),0) OTHER_TOPLAM_MALIYET_
					<cfelse>
						,0 OTHER_TOPLAM_MALIYET_
					</cfif>
				FROM
					(
						SELECT 
							<!--- Alim faturasi --->
							ISNULL(SUM(INVOICE_ROW.NETTOTAL),0) AS TOPLAM_MALIYET_P,
							0 TOPLAM_MALIYET_N
							<cfif len(session.ep.money2)>
								,ISNULL(SUM(INVOICE_ROW.NETTOTAL/INVOICE_MONEY.RATE2),0) OTHER_TOPLAM_MALIYET_P,
								0 OTHER_TOPLAM_MALIYET_N
							</cfif>
						FROM 
							INVOICE,
							INVOICE_ROW
							<cfif len(session.ep.money2)>
								,INVOICE_MONEY
							</cfif>
						WHERE
							INVOICE.INVOICE_ID = INVOICE_ROW.INVOICE_ID AND
							<cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(INVOICE_ROW.ROW_PROJECT_ID,INVOICE.PROJECT_ID)<cfelse>ISNULL(INVOICE.PROJECT_ID,INVOICE_ROW.ROW_PROJECT_ID)</cfif> IN (#Project_List#) AND
							<cfif len(session.ep.money2)>
								INVOICE.INVOICE_ID = INVOICE_MONEY.ACTION_ID AND
								INVOICE_MONEY.MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#"> AND
							</cfif>
							INVOICE.INVOICE_CAT IN (59,591,691,68,65) AND
							INVOICE.IS_IPTAL = 0
							<cfif isdefined('attributes.start_date') and len(attributes.start_date)>
								AND INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
							</cfif>
							<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
								AND INVOICE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
							</cfif>
		
						UNION ALL
			
						SELECT 
							0 TOPLAM_MALIYET_P,
							ISNULL(SUM(INVOICE_ROW.NETTOTAL),0) AS TOPLAM_MALIYET_N
							<cfif len(session.ep.money2)>
								,0 OTHER_TOPLAM_MALIYET_P
								,ISNULL(SUM(INVOICE_ROW.NETTOTAL/INVOICE_MONEY.RATE2),0) OTHER_TOPLAM_MALIYET_N
							</cfif>
						FROM 
							INVOICE,
							INVOICE_ROW
							<cfif len(session.ep.money2)>
								,INVOICE_MONEY
							</cfif>
						WHERE
							INVOICE.INVOICE_ID = INVOICE_ROW.INVOICE_ID AND
							<cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(INVOICE_ROW.ROW_PROJECT_ID,INVOICE.PROJECT_ID)<cfelse>ISNULL(INVOICE.PROJECT_ID,INVOICE_ROW.ROW_PROJECT_ID)</cfif> IN (#Project_List#) AND
							<cfif len(session.ep.money2)>
								INVOICE.INVOICE_ID = INVOICE_MONEY.ACTION_ID AND
								INVOICE_MONEY.MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#"> AND
							</cfif>
							<!--- Alim iade faturasi --->
							INVOICE.INVOICE_CAT = 62 AND
							INVOICE.IS_IPTAL = 0
							<cfif isdefined('attributes.start_date') and len(attributes.start_date)>
								AND INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
							</cfif>
							<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
								AND INVOICE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
							</cfif>
					) T3
				
			) MAIN_QUERY
			GROUP BY
				TYPE
		</cfquery>
		<cfset type_list = ValueList(get_all_price.type)>
		<cfset price_ = 0>
		<cfset other_price_ = 0>
		<cfset genel_kar_toplam = 0>
		<cfset other_genel_kar_toplam = 0>
		<cfset hakedis = 0>
		<cfset maliyet = 0>
		<cfset proje_maliyet = 0>
		<cfset other_proje_maliyet = 0>
		<cfset alinan_hakedisler_price = 0>
		<cfset satilan_malin_maliyeti_price = 0>
		<cfset Url_Address = "">
		<cfoutput query="get_money_rate">
			<cfset "tahsilat_toplam_#money#" = 0>
			<cfset "odeme_toplam_#money#" = 0>
		</cfoutput>
		<cfoutput>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column">
				<cf_box title="#getLang('','',58085)#">
					<cf_grid_list>
						<thead>
							<tr>
								<th colspan="3" onClick="windowopen('#request.self#?fuseaction=project.projects&event=det&id=#attributes.project_id#','wide');"><cf_get_lang dictionary_id="39751.Proje Bütçesi"></th>
								<th class= "text-right">
									<cfif isdefined("get_project_head") and get_project_head.recordcount and len(get_project_head.expected_budget)>#TLFormat(get_project_head.expected_budget*rate_info)#</cfif>
								</th>
								<th>#session.ep.money#</th>
								<th class="text-right">
									<cfif isdefined("get_project_head") and get_project_head.recordcount and len(get_project_head.expected_budget) and isdefined("get_money2") and len(get_money2.rate)>
										#TLFormat((get_project_head.expected_budget*rate_info)/get_money2.rate)#
									</cfif>
								</th>
								<th>#session.ep.money2#</th>
							</tr>
						</thead>
						<tbody>
							<tr> 
								<td class="txtbold" colspan="3">
									<cfset Url_Address = "form_varmi=1&listing_type=2&cat=561&project_id=#project_id#&project_head=#project_head#"><!--- Satir Bazinda,Islem Tipi,Proje --->
									<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
										<cfset Url_Address = "#Url_Address#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
									</cfif>
									<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
										<cfset Url_Address = "#Url_Address#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
									</cfif>
									<a href="#request.self#?fuseaction=invoice.list_bill&#Url_Address#" target="_blank"><cf_get_lang dictionary_id='39543.Verilen Hakedisler'>(+)</a>
								</td>
								<cfquery name="get_hakedis" dbtype="query">
									SELECT * FROM get_all_price WHERE TYPE = 1
								</cfquery>
								<cfif get_hakedis.recordcount>
									<cfset price_ = get_hakedis.price>
									<cfset other_price_ = get_hakedis.other_price>
									<cfset genel_kar_toplam = genel_kar_toplam + get_hakedis.price>
									<cfset other_genel_kar_toplam = other_genel_kar_toplam + get_hakedis.other_price>
									<cfset hakedis = hakedis + get_hakedis.price>
								<cfelse>
									<cfset price_ = 0>
									<cfset other_price_ = 0>
								</cfif>
								<td class="txtbold text-right">#TLFormat(price_)#</td>
								<td class="txtbold">#session.ep.money#</td>
								<td class="txtbold text-right">#TLFormat(other_price_)#</td>
								<td class="txtbold">#session.ep.money2#</td>
							</tr>
							<tr> 
								<td class="txtbold" colspan="3">
									<cfset Url_Address = "form_varmi=1&listing_type=2&cat=56&project_id=#project_id#&project_head=#project_head#"><!--- Satir Bazinda,Islem Tipi,Proje --->
									<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
										<cfset Url_Address = "#Url_Address#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
									</cfif>
									<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
										<cfset Url_Address = "#Url_Address#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
									</cfif>
									<a href="#request.self#?fuseaction=invoice.list_bill&#Url_Address#" target="_blank"><cf_get_lang dictionary_id='39544.Verilen Hizmetler'>(+)</a>
								</td>
								<cfquery name="get_hizmet" dbtype="query">
									SELECT * FROM get_all_price WHERE TYPE = 5
								</cfquery>
								<cfif get_hizmet.recordcount>
									<cfset price_ = get_hizmet.price>
									<cfset other_price_ = get_hizmet.other_price>
									<cfset genel_kar_toplam = genel_kar_toplam + get_hizmet.price>
									<cfset other_genel_kar_toplam = other_genel_kar_toplam + get_hizmet.other_price>
									<cfset hakedis = hakedis + get_hizmet.price>
								<cfelse>
									<cfset price_ = 0>
									<cfset other_price_ = 0>
								</cfif>
								<td class="txtbold text-right">#TLFormat(price_)#</td>
								<td class="txtbold">#session.ep.money#</td>
								<td width="140" class="txtbold text-right">#TLFormat(other_price_)#</td>
								<td class="txtbold">#session.ep.money2#</td>
							</tr>
							<tr height="20" class="color-row"> 
								<td class="txtbold" colspan="3">
									<cfset Url_Address = "form_varmi=1&listing_type=2&cat=1&project_id=#project_id#&project_head=#project_head#"><!--- Satir Bazinda,Islem Tipi,Proje --->
									<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
										<cfset Url_Address = "#Url_Address#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
									</cfif>
									<cfif isdefined("attributes.finish_date") and len(attributes.start_date)>
										<cfset Url_Address = "#Url_Address#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
									</cfif>
									<a href="#request.self#?fuseaction=invoice.list_bill&#Url_Address#" target="_blank"><cf_get_lang dictionary_id='39545.Satışlar'>(+)</a>
								</td>
								<cfquery name="get_satis" dbtype="query">
									SELECT * FROM get_all_price WHERE TYPE = 7
								</cfquery>
								<cfif get_satis.recordcount>
									<cfset price_ = get_satis.price>
									<cfset other_price_ = get_satis.other_price>
									<cfset genel_kar_toplam = genel_kar_toplam + get_satis.price>
									<cfset other_genel_kar_toplam = other_genel_kar_toplam + get_satis.other_price>
									<cfset hakedis = hakedis + get_satis.price>
								<cfelse>
									<cfset price_ = 0>
									<cfset other_price_ = 0>
								</cfif>
								<td class="txtbold text-right">#TLFormat(price_)#</td>
								<td class="txtbold">#session.ep.money#</td>
								<td width="140" class="txtbold text-right">#TLFormat(other_price_)#</td>
								<td class="txtbold">#session.ep.money2#</td>
							</tr>
							<tr height="20" class="color-row"> 
								<td class="txtbold" colspan="3">
									<cfset Url_Address = "form_submitted=1&listing_type=2&expense_action_type=121&project_id=#project_id#&project_head=#project_head#"><!--- Satir Bazinda,Islem Tipi,Proje --->
									<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
										<cfset Url_Address = "#Url_Address#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
									</cfif>
									<cfif isdefined("attributes.finish_date") and len(attributes.start_date)>
										<cfset Url_Address = "#Url_Address#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
									</cfif>
									<a href="#request.self#?fuseaction=cost.list_expense_income&#Url_Address#" target="_blank"><cf_get_lang dictionary_id='58089.Gelirler'>(+)</a>
								</td>
								<cfquery name="get_gelir" dbtype="query">
									SELECT * FROM get_all_price WHERE TYPE = 12
								</cfquery>
								<cfif get_gelir.recordcount>
									<cfset price_ = get_gelir.price>
									<cfset other_price_ = get_gelir.other_price>
									<cfset genel_kar_toplam = genel_kar_toplam + get_gelir.price>
									<cfset other_genel_kar_toplam = other_genel_kar_toplam + get_gelir.other_price>
									<cfset hakedis = hakedis + get_gelir.price>
								<cfelse>
									<cfset price_ = 0>
									<cfset other_price_ = 0>
								</cfif>
								<td class="txtbold text-right">#TLFormat(price_)#</td>
								<td class="txtbold">#session.ep.money#</td>
								<td width="140" class="txtbold text-right">#TLFormat(other_price_)#</td>
								<td class="txtbold">#session.ep.money2#</td>
							</tr>
							<tr  height="20" class="color-row">	
								<td class="txtbold" colspan="3">
									<cfset Url_Address = "form_varmi=1&listing_type=2&cat=601&project_id=#project_id#&project_head=#project_head#"><!--- Satir Bazinda,Islem Tipi,Proje --->
									<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
										<cfset Url_Address = "#Url_Address#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
									</cfif>
									<cfif isdefined("attributes.finish_date") and len(attributes.start_date)>
										<cfset Url_Address = "#Url_Address#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
									</cfif>
									<a href="#request.self#?fuseaction=invoice.list_bill&#Url_Address#" target="_blank"><cf_get_lang dictionary_id='39546.Alinan Hakedisler'>(-)</a>
								</td>
								<cfquery name="get_al_hak" dbtype="query">
									SELECT * FROM get_all_price WHERE TYPE = 11
								</cfquery>
								<cfif get_al_hak.recordcount>
									<cfset price_ = get_al_hak.price>
									<cfset other_price_ = get_al_hak.other_price>
									<cfset genel_kar_toplam = genel_kar_toplam - get_al_hak.price>
									<cfset other_genel_kar_toplam = other_genel_kar_toplam - get_al_hak.other_price>
									<cfset maliyet = maliyet + get_al_hak.price>
									<cfset alinan_hakedisler_price = get_al_hak.price>
								<cfelse>
									<cfset price_ = 0>
									<cfset other_price_ = 0>
								</cfif>
								<td class="txtbold text-right">#TLFormat(price_)#</td>
								<td class="txtbold">#session.ep.money#</td>
								<td width="140" class="txtbold text-right">#TLFormat(other_price_)#</td>
								<td class="txtbold">#session.ep.money2#</td>
							</tr>
							<tr height="20" class="color-row">	
								<td class="txtbold" colspan="3">
									<cfset Url_Address = "form_varmi=1&listing_type=2&cat=60&project_id=#project_id#&project_head=#project_head#"><!--- Satir Bazinda,Islem Tipi,Proje --->
									<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
										<cfset Url_Address = "#Url_Address#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
									</cfif>
									<cfif isdefined("attributes.finish_date") and len(attributes.start_date)>
										<cfset Url_Address = "#Url_Address#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
									</cfif>
									<a href="#request.self#?fuseaction=invoice.list_bill&#Url_Address#" target="_blank"><cf_get_lang dictionary_id='39547.Alinan Hizmetler'>(-)</a>
								</td>
								<cfquery name="get_al_hizm" dbtype="query">
									SELECT * FROM get_all_price WHERE TYPE = 6
								</cfquery>
								<cfif get_al_hizm.recordcount>
									<cfset price_ = get_al_hizm.price>
									<cfset other_price_ = get_al_hizm.other_price>
									<cfset genel_kar_toplam = genel_kar_toplam - get_al_hizm.price>
									<cfset other_genel_kar_toplam = other_genel_kar_toplam - get_al_hizm.other_price>
									<cfset maliyet = maliyet + get_al_hizm.price>
									<cfset alinan_hakedisler_price = get_al_hizm.price>
								<cfelse>
									<cfset price_ = 0>
									<cfset other_price_ = 0>
								</cfif>
								<td class="txtbold text-right">#TLFormat(price_)#</td>
								<td class="txtbold">#session.ep.money#</td>
								<td width="140" class="txtbold text-right">#TLFormat(other_price_)#</td>
								<td class="txtbold">#session.ep.money2#</td>
							</tr>
							<tr height="20" class="color-row">	
								<td class="txtbold" colspan="3">
									<cfset Url_Address = "is_submit=1&listing_type=2&cat=60&project_id=#project_id#&start_date=01/01/#session.ep.period_year#&finish_date=#dateformat(now(),dateformat_style)#"><!--- Satir Bazinda,Islem Tipi,Proje,Baslangic Tarihi, Bitis Tarihi --->
									<a href="#request.self#?fuseaction=report.time_cost_report&#Url_Address#" target="_blank"><cf_get_lang dictionary_id='39548.Is Gücü Maliyetleri'>(-)</a>
								</td>
								<cfquery name="get_work_cost" dbtype="query">
									SELECT * FROM get_all_price WHERE TYPE = 3
								</cfquery>
								<cfif get_work_cost.recordcount>
									<cfset price_ = get_work_cost.price>
									<cfset other_price_ = get_work_cost.other_price>
									<cfset genel_kar_toplam = genel_kar_toplam - get_work_cost.price>
									<cfset other_genel_kar_toplam = other_genel_kar_toplam - get_work_cost.other_price>
									<cfset maliyet = maliyet + get_work_cost.price>
									<cfset alinan_hakedisler_price = get_work_cost.price>
								<cfelse>
									<cfset price_ = 0>
									<cfset other_price_ = 0>
								</cfif>
								<td class="txtbold text-right">#TLFormat(price_)#</td>
								<td class="txtbold">#session.ep.money#</td>
								<td width="140" class="txtbold text-right">#TLFormat(other_price_)#<!--- <cfif len(session.ep.money2) and isdefined("get_money2") and len(get_money2.rate)>#TLFormat(get_work_cost.price/get_money2.rate)#<cfelse>#TLFormat(0)#</cfif> ---></td>
								<td class="txtbold">#session.ep.money2#</td>
							</tr>
							<cfif isdefined("is_cost_of_material") and is_cost_of_material eq 1><!--- xmlde Malzeme Maliyetini Goster evet ise --->
								<tr height="20" class="color-row">	
									<td class="txtbold" colspan="3">
										<cfset Url_Address = "is_form_submitted=1&report_type=7&display_cost=1&project_head=#get_project_head.project_head#&project_id=#project_id#&date=01/01/#session.ep.period_year#&date2=31/12/#session.ep.period_year#&process_type_detail=0-111&cost_money=TL"><!--- Satir Bazinda,Islem Tipi,Proje,Baslangic Tarihi, Bitis Tarihi --->
										<a href="#request.self#?fuseaction=report.stock_analyse&#Url_Address#" target="_blank"><cf_get_lang dictionary_id='39549.Malzeme Maliyetleri'>(-)</a>
									</td>
									<cfquery name="get_metarial_cost" dbtype="query">
										SELECT * FROM get_all_price WHERE TYPE = 4
									</cfquery>
									<cfif get_metarial_cost.recordcount>
										<cfset price_ = get_metarial_cost.price>
										<cfset other_price_ = get_metarial_cost.other_price>
										<cfset genel_kar_toplam = genel_kar_toplam - get_metarial_cost.price>
										<cfset other_genel_kar_toplam = other_genel_kar_toplam - get_metarial_cost.other_price>
										<cfset proje_maliyet = get_metarial_cost.price>
										<cfset other_proje_maliyet = get_metarial_cost.other_price>
										<cfset maliyet = maliyet + get_metarial_cost.price>
									<cfelse>
										<cfset price_ = 0>
										<cfset other_price_ = 0>
									</cfif>
									<td class="txtbold text-right">#TLFormat(price_)#</td>
									<td class="txtbold">#session.ep.money#</td>
									<td width="140" class="txtbold text-right">#TLFormat(other_price_)#<!--- <cfif get_metarial_cost.recordcount>#TLFormat(get_metarial_cost.other_price)#<cfelse>#TLFormat(0)#</cfif> ---></td>
									<td class="txtbold">#session.ep.money2#</td>
								</tr>
							</cfif>
							<cfif isdefined("is_cost_of_product_sold") and is_cost_of_product_sold eq 1><!--- xmlde Satılan Malin Maliyetini Goster evet ise --->
								<tr height="20" class="color-row">	
									<td class="txtbold" colspan="3">
									<cfquery name="GET_PROCESS_CAT" datasource="#DSN3#">
										SELECT PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (50,52,53,531,532,56,58,62,561,54,55,51,63,48,49) ORDER BY PROCESS_CAT
									</cfquery>
									<cfset process_cat_list = valuelist(GET_PROCESS_CAT.PROCESS_CAT_ID)>
									<cfset Url_Address = "form_submitted=1&report_type=19&is_cost_price=1&project_head=#get_project_head.project_head#&project_id=#project_id#&date1=01/01/#session.ep.period_year#&date2=31/12/#session.ep.period_year#&process_type_=#process_cat_list#&process_type_select=#process_cat_list#"><!--- Satir Bazinda,Islem Tipi,Proje,Baslangic Tarihi, Bitis Tarihi --->
									<a href="#request.self#?fuseaction=report.sale_analyse_report&#Url_Address#" target="_blank"><cf_get_lang dictionary_id='39550.Satılan Malın Maliyeti'>(-)</a>
									</td>
									<cfif len(attributes.start_date)>
										<cfset my_startdate = dateformat(attributes.start_date,dateformat_style)>
									<cfelse>
										<cfset my_startdate = createodbcdatetime('#session.ep.period_year#-#month(now())#-1')>
									</cfif>
									<cfif len(attributes.finish_date)>
										<cfset my_finishdate = dateformat(attributes.finish_date,dateformat_style)>
									<cfelse>
										<cfset my_finishdate = now()>
									</cfif>
									<cfquery name="get_prod_sold" dbtype="query">
										SELECT * FROM get_all_price WHERE TYPE = 8
									</cfquery>
									<cfif get_prod_sold.recordcount>
										<cfset price_ = get_prod_sold.price>
										<cfset other_price_ = get_prod_sold.other_price>
										<cfset genel_kar_toplam = genel_kar_toplam - get_prod_sold.price>
										<cfset other_genel_kar_toplam = other_genel_kar_toplam - get_prod_sold.other_price>
										<cfset maliyet = maliyet + get_prod_sold.price>
										<cfset satilan_malin_maliyeti_price = get_prod_sold.price>
									<cfelse>
										<cfset price_ = 0>
										<cfset other_price_ = 0>
									</cfif>
									<td class="txtbold text-right">#TLFormat(price_)#</td>
									<td class="txtbold">#session.ep.money#</td>
									<td width="140" class="txtbold text-right">#TLFormat(other_price_)#<!--- <cfif get_prod_sold.recordcount>#TLFormat(get_prod_sold.other_price)#<cfelse>#TLFormat(0)#</cfif> ---></td>
									<td class="txtbold">#session.ep.money2#</td>
								</tr>
							</cfif>
							
								<tr height="20" class="color-row">	
									<td class="txtbold" colspan="3">
										<cfset Url_Address = "form_varmi=1&listing_type=2&cat=0&project_id=#project_id#&project_head=#project_head#"><!--- Satir Bazinda,Islem Tipi,Proje --->
										<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
											<cfset Url_Address = "#Url_Address#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
										</cfif>
										<cfif isdefined("attributes.finish_date") and len(attributes.start_date)>
											<cfset Url_Address = "#Url_Address#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
										</cfif>
										<a href="#request.self#?fuseaction=invoice.list_bill&#Url_Address#" target="_blank"><cf_get_lang dictionary_id='38770.Alimlar'>(-)</a>
									</td>
									<cfquery name="get_cost_price" dbtype="query">
										SELECT * FROM get_all_price WHERE TYPE = 13
									</cfquery>
									<cfif get_cost_price.recordcount>
										<cfset price_ = get_cost_price.price>
										<cfset other_price_ = get_cost_price.other_price>
										<cfif isdefined("is_purchases") and is_purchases eq 1><!--- Alimlari Goster --->
											<cfset genel_kar_toplam = genel_kar_toplam - get_cost_price.price>
											<cfset other_genel_kar_toplam = other_genel_kar_toplam - get_cost_price.other_price>
											<cfset maliyet = maliyet + get_cost_price.price>
											<cfset satilan_malin_maliyeti_price = get_cost_price.price>
										</cfif>
									<cfelse>
										<cfset price_ = 0>
										<cfset other_price_ = 0>
									</cfif>
									<td class="txtbold text-right">#TLFormat(price_)#</td>
									<td class="txtbold">#session.ep.money#</td>
									<td width="140" class="txtbold text-right">#TLFormat(other_price_)#</td>
									<td class="txtbold">#session.ep.money2#</td>
								</tr>
							<!--- Masraflar --->
							<tr height="20" class="color-row">	
								<td class="txtbold" colspan="3">
									<cfset Url_Address = "form_submitted=1&listing_type=2&expense_action_type=120&project_id=#project_id#&project_head=#project_head#"><!--- Satir Bazinda,Islem Tipi,Proje --->
									<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
										<cfset Url_Address = "#Url_Address#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
									</cfif>
									<cfif isdefined("attributes.finish_date") and len(attributes.start_date)>
										<cfset Url_Address = "#Url_Address#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
									</cfif>
									<a href="#request.self#?fuseaction=cost.list_expense_income&#Url_Address#" target="_blank"><cf_get_lang dictionary_id='39551.Masraflar'>(-)</a>
								</td>
								<cfquery name="get_exp" dbtype="query">
									SELECT * FROM get_all_price WHERE TYPE = 2
								</cfquery>
								<cfif get_exp.recordcount>
									<cfset price_ = get_exp.price>
									<cfset other_price_ = get_exp.other_price>
									<cfset genel_kar_toplam = genel_kar_toplam - get_exp.price>
									<cfset other_genel_kar_toplam = other_genel_kar_toplam - get_exp.other_price>
									<cfset maliyet = maliyet + get_exp.price>
									<cfset masraflar_price = get_exp.price>
								<cfelse>
									<cfset price_ = 0>
									<cfset other_price_ = 0>
								</cfif>
								<td class="txtbold text-right">#TLFormat(price_)#</td>
								<td class="txtbold">#session.ep.money#</td>
								<td width="140" class="txtbold text-right">#TLFormat(other_price_)#</td>
								<td class="txtbold">#session.ep.money2#</td>
							</tr>
							<!--- Bakimlar --->
							<tr height="20" class="color-row">	
								<td class="txtbold" colspan="3">
									<cfset Url_Address = "form_submitted=1&listing_type=2&expense_action_type=122&project_id=#project_id#&project_head=#project_head#"><!--- Satir Bazinda,Islem Tipi,Proje --->
									<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
										<cfset Url_Address = "#Url_Address#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
									</cfif>
									<cfif isdefined("attributes.finish_date") and len(attributes.start_date)>
										<cfset Url_Address = "#Url_Address#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
									</cfif>
									<a href="#request.self#?fuseaction=cost.list_expense_income&#Url_Address#" target="_blank"><cf_get_lang dictionary_id='40691.Bakımlar'>(-)</a>
								</td>
								<cfquery name="get_itm" dbtype="query">
									SELECT * FROM get_all_price WHERE TYPE = 14
								</cfquery>
								<cfif get_itm.recordcount>
									<cfset price_ = get_itm.price>
									<cfset other_price_ = get_itm.other_price>
									<cfset genel_kar_toplam = genel_kar_toplam - get_itm.price>
									<cfset other_genel_kar_toplam = other_genel_kar_toplam - get_itm.other_price>
									<cfset maliyet = maliyet + get_itm.price>
									<cfset masraflar_price = get_itm.price>
								<cfelse>
									<cfset price_ = 0>
									<cfset other_price_ = 0>
								</cfif>
								<td class="txtbold text-right">#TLFormat(price_)#</td>
								<td class="txtbold">#session.ep.money#</td>
								<td width="140" class="txtbold text-right">#TLFormat(other_price_)#</td>
								<td class="txtbold">#session.ep.money2#</td>
							</tr>
							<cfif isdefined("xml_show_general_expense_effect") and xml_show_general_expense_effect eq 1><!--- Genel Gider Yansimalari Gelmesin / Kar Zarar Hesabina Katilmasin --->
								<tr height="20" class="color-row">	
									<td class="txtbold" colspan="3"><cf_get_lang dictionary_id='39552.Genel Gider Yansimasi'>(-)</td>
									<td class="txtbold text-right">
										<cfif sarf_genel_toplam gt 0>#TLFormat(((proje_maliyet*masraffisi_genel_toplam)/sarf_genel_toplam))#<cfelse>#TLFormat(0)#</cfif>
									</td>
									<td class="txtbold"><cfif sarf_genel_toplam gt 0>#session.ep.money#<cfelse>#session.ep.money#</cfif></td>
									<cfif sarf_genel_toplam gt 0>
										<cfset genel_kar_toplam = genel_kar_toplam - ((proje_maliyet*masraffisi_genel_toplam)/sarf_genel_toplam)>
										<cfset maliyet = maliyet + ((proje_maliyet*masraffisi_genel_toplam)/sarf_genel_toplam)>
									</cfif>
									<td width="140" class="txtbold text-right"><cfif other_sarf_genel_toplam gt 0>#TLFormat((other_proje_maliyet*other_masraffisi_genel_toplam)/other_sarf_genel_toplam)#<cfelse>#TLFormat(0)#</cfif></td>
									<td class="txtbold">#session.ep.money2#</td>
								</tr>
							</cfif>
							<tr height="20" class="color-row"> 
								<td class="txtbold" colspan="3"><cf_get_lang dictionary_id='39553.Kar'>/<cf_get_lang dictionary_id='39554.Zarar'></td>
								<td class="txtbold text-right">#Tlformat(genel_kar_toplam)#</td>
								<td class="txtbold">#session.ep.money#</td>
								<td width="140" class="txtbold text-right">#TLFormat(other_genel_kar_toplam)#</td>
								<td class="txtbold">#session.ep.money2#</td>
							</tr>
						</tbody>
					</cf_grid_list>
					<cfif get_expense_sarf_compare.recordcount>
						<cf_grid_list>
							<thead>
								<tr>
									<th><cf_get_lang dictionary_id='39555.Genel Gider Yansimalari'></th>
									<th class="text-right"><cf_get_lang dictionary_id='39556.Dönem Toplami'></th>
									<th><cf_get_lang dictionary_id='58474.Birim'></th>
									<th class="text-right" nowrap="nowrap"><cf_get_lang dictionary_id='39557.Yansima Tutari'></th>
									<th>#session.ep.money#</th>
									<th class="text-right" nowrap="nowrap"><cf_get_lang dictionary_id='39557.Yansima Tutari'></th>
									<th>#session.ep.money2#</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td class="txtbold"><cf_get_lang dictionary_id='39558.Dönem Toplam Sarf'></td>
									<td width="120" class="txtbold text-right">
										#Tlformat(sarf_genel_toplam)#<br />
										#Tlformat(other_sarf_genel_toplam)#
									</td>
									<td class="txtbold">#session.ep.money# <br />#session.ep.money2#</td>
									<td width="120" class="txtbold text-right">#TLFormat(proje_maliyet)#</td>
									<td class="txtbold">#session.ep.money#</td>
									<td width="140" class="txtbold text-right">#TLFormat(other_proje_maliyet)#</td>
									<td class="txtbold">#session.ep.money2#</td>
								</tr>
								<tr>
									<td class="txtbold"><cf_get_lang dictionary_id='39559.Dönem Genel Gider Toplami'></td>					
									<td class="txtbold text-right">
										#TLFormat(masraffisi_genel_toplam)#<br />
										#TLFormat(other_masraffisi_genel_toplam)#
									</td>
									<td class="txtbold">#session.ep.money# <br />#session.ep.money2#</td>
									<td class="txtbold text-right">
										<cfif sarf_genel_toplam gt 0>
											#TLFormat((proje_maliyet*masraffisi_genel_toplam)/sarf_genel_toplam)#
										<cfelse>
											#Tlformat(0)#
										</cfif>
									</td>
									<td class="txtbold">#session.ep.money#</td>
									<td width="140" class="txtbold text-right">
										<cfif other_sarf_genel_toplam gt 0>
											#TLFormat((other_proje_maliyet*other_masraffisi_genel_toplam)/other_sarf_genel_toplam)#
										<cfelse>
											#TLFormat(0)#
										</cfif>
									</td>
									<td class="txtbold">#session.ep.money2#</td>
								</tr>
							</tbody>
						</cf_grid_list>
					</cfif>
				</cf_box> 	
				
				<cf_box title="#getLang('','',57845)# #getLang('','',57847)#">
					<cf_grid_list>
						<thead>
							<tr>
								<th><cf_get_lang dictionary_id='61806.İşlem Tipi'></th>
								<th>#getLang('','',57845)#</th>
								<th><cf_get_lang dictionary_id='58474.Birim'></th>
								<th>#getLang('','',57847)#</th>
								<th><cf_get_lang dictionary_id='58474.Birim'></th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<cfset get_bank_odeme = get_component.get_project_accounts(from_to_id:1,project_id: Project_List,codes:"25,29,120,242,244,291,1044,1054,555",type:"1",dsn2:new_donem_data_source,start_date:attributes.start_date,finish_date:attributes.finish_date)>
								<cfset get_bank_tahsilat = get_component.get_project_accounts(from_to_id:0,project_id: Project_List,codes:"24,104,121,240,241,292,1043,1053,555",type:"1",dsn2:new_donem_data_source,start_date:attributes.start_date,finish_date:attributes.finish_date)>
								
								<td><cf_get_lang dictionary_id='58896.Banka İşlemleri'></td>
								<td class="text-right">
									<cfif len(get_bank_tahsilat.TOTAL_VALUE)>
										#TLFORMAT(get_bank_tahsilat.TOTAL_VALUE)#
										<cfset "tahsilat_toplam_#get_bank_tahsilat.action_currency_id#" = evaluate("tahsilat_toplam_#get_bank_tahsilat.action_currency_id#")+get_bank_tahsilat.TOTAL_VALUE>
									<cfelse>
										#TLFORMAT(0)#
									</cfif>
								</td>
								<td>#len(get_bank_tahsilat.ACTION_CURRENCY_ID) ? get_bank_tahsilat.ACTION_CURRENCY_ID : session.ep.money#</td>
								<td class="text-right">
									<cfif len(get_bank_odeme.TOTAL_VALUE)>
										#TLFORMAT(get_bank_odeme.TOTAL_VALUE)#
										<cfset "odeme_toplam_#get_bank_odeme.action_currency_id#" = evaluate("odeme_toplam_#get_bank_odeme.action_currency_id#")+get_bank_odeme.TOTAL_VALUE>
									<cfelse>
										#TLFORMAT(0)#
									</cfif>
								</td>
								<td>#len(get_bank_odeme.ACTION_CURRENCY_ID) ? get_bank_odeme.ACTION_CURRENCY_ID : session.ep.money#</td>
							</tr>
							<tr>
								<cfset get_kasa_odeme = get_component.get_project_accounts(from_to_id:1,project_id: Project_List,codes:"32,1041,1051,555",type:"2",dsn2:new_donem_data_source,start_date:attributes.start_date,finish_date:attributes.finish_date)>
								<cfset get_kasa_tahsilat = get_component.get_project_accounts(from_to_id:0,project_id: Project_List,codes:"31,35,1040,1050,555",type:"2",dsn2:new_donem_data_source,start_date:attributes.start_date,finish_date:attributes.finish_date)>
								<td><cf_get_lang dictionary_id='58897.Kasa İşlemleri'></td>
								<td class="text-right">
									<cfif len(get_kasa_tahsilat.TOTAL_VALUE)>
										#TLFORMAT(get_kasa_tahsilat.TOTAL_VALUE)#
										<cfset "tahsilat_toplam_#get_kasa_tahsilat.action_currency_id#" = evaluate("tahsilat_toplam_#get_kasa_tahsilat.action_currency_id#")+get_kasa_tahsilat.TOTAL_VALUE>
									<cfelse>
										#TLFORMAT(0)#
									</cfif>
								</td>
								<td>#len(get_kasa_tahsilat.ACTION_CURRENCY_ID) ? get_kasa_tahsilat.ACTION_CURRENCY_ID : session.ep.money#</td>
								<td class="text-right">
									<cfif len(get_kasa_odeme.TOTAL_VALUE)>
										#TLFORMAT(get_kasa_odeme.TOTAL_VALUE)#
										<cfset "odeme_toplam_#get_kasa_odeme.action_currency_id#" = evaluate("odeme_toplam_#get_kasa_odeme.action_currency_id#")+get_kasa_odeme.TOTAL_VALUE>
									<cfelse>
										#TLFORMAT(0)#
									</cfif>
								</td>
								<td>#len(get_kasa_odeme.ACTION_CURRENCY_ID) ? get_kasa_odeme.ACTION_CURRENCY_ID : session.ep.money#</td>
							</tr>
							<tr>
								<cfset get_cari_odeme = get_component.get_project_accounts(alacakli_project:1,project_id: Project_List,codes:"131,43,555",type:"3",dsn2:new_donem_data_source,start_date:attributes.start_date,finish_date:attributes.finish_date)>
								<cfset get_cari_tahsilat = get_component.get_project_accounts(alacakli_project:0,project_id: Project_List,codes:"41,42,43,555",type:"3",dsn2:new_donem_data_source,start_date:attributes.start_date,finish_date:attributes.finish_date)>
								
								<td><cf_get_lang dictionary_id='38356.Cari Virman İşlemleri'></td>
								<td class="text-right">
									<cfif len(get_cari_tahsilat.TOTAL_VALUE)>
										#TLFORMAT(get_cari_tahsilat.TOTAL_VALUE)#
										<cfset "tahsilat_toplam_#get_cari_tahsilat.action_currency_id#" = evaluate("tahsilat_toplam_#get_cari_tahsilat.action_currency_id#")+get_cari_tahsilat.TOTAL_VALUE>
									<cfelse>
										#TLFORMAT(0)#
									</cfif>
								</td>
								<td>#len(get_cari_tahsilat.ACTION_CURRENCY_ID) ? get_cari_tahsilat.ACTION_CURRENCY_ID : session.ep.money#</td>
								<td class="text-right">
									<cfif len(get_cari_odeme.TOTAL_VALUE)>
										#TLFORMAT(get_cari_odeme.TOTAL_VALUE)#
										<cfset "odeme_toplam_#get_cari_odeme.action_currency_id#" = evaluate("odeme_toplam_#get_cari_odeme.action_currency_id#")+get_cari_odeme.TOTAL_VALUE>
									<cfelse>
										#TLFORMAT(0)#
									</cfif>
								</td>
								<td>#len(get_cari_odeme.ACTION_CURRENCY_ID) ? get_cari_odeme.ACTION_CURRENCY_ID : session.ep.money#</td>
							</tr>
							<tr>
								<cfset get_cek_odeme = get_component.get_project_accounts(project_id: Project_List,codes:"91,95,94",type:"4",dsn2:new_donem_data_source,start_date:attributes.start_date,finish_date:attributes.finish_date)>
								<cfset get_cek_tahsilat = get_component.get_project_accounts(project_id: Project_List,codes:"90,94,95",type:"4",dsn2:new_donem_data_source,start_date:attributes.start_date,finish_date:attributes.finish_date)>

								<td><cf_get_lang dictionary_id='57852.Çek Giriş Bordrosu'></td>
								<td class="text-right">
									<cfif len(get_cek_tahsilat.TOTAL_VALUE)>
										#TLFORMAT(get_cek_tahsilat.TOTAL_VALUE)#
										<cfset "tahsilat_toplam_#get_cek_tahsilat.action_currency_id#" = evaluate("tahsilat_toplam_#get_cek_tahsilat.action_currency_id#")+get_cek_tahsilat.TOTAL_VALUE>
									<cfelse>
										#TLFORMAT(0)#
									</cfif>
								</td>
								<td>#len(get_cek_tahsilat.ACTION_CURRENCY_ID) ? get_cek_tahsilat.ACTION_CURRENCY_ID : session.ep.money#</td>
								<td class="text-right">
									<cfif len(get_cek_odeme.TOTAL_VALUE)>
										#TLFORMAT(get_cek_odeme.TOTAL_VALUE)#
										<cfset "odeme_toplam_#get_cek_odeme.action_currency_id#" = evaluate("odeme_toplam_#get_cek_odeme.action_currency_id#")+get_cek_odeme.TOTAL_VALUE>
									<cfelse>
										#TLFORMAT(0)#
									</cfif>
								</td>
								<td>#len(get_cek_odeme.ACTION_CURRENCY_ID) ? get_cek_odeme.ACTION_CURRENCY_ID : session.ep.money#</td>
							</tr>
							<tr>
								<cfset get_senet_odeme = get_component.get_project_accounts(project_id: Project_List,codes:"98,108,101",type:"5",dsn2:new_donem_data_source,start_date:attributes.start_date,finish_date:attributes.finish_date)>
								<cfset get_senet_tahsilat = get_component.get_project_accounts(project_id: Project_List,codes:"97,108",type:"5",dsn2:new_donem_data_source,start_date:attributes.start_date,finish_date:attributes.finish_date)>

								<td><cf_get_lang dictionary_id='58010.Senet Giriş Bordrosu'></td>
								<td class="text-right">
									<cfif len(get_senet_tahsilat.TOTAL_VALUE)>
										#TLFORMAT(get_senet_tahsilat.TOTAL_VALUE)#
										<cfset "tahsilat_toplam_#get_senet_tahsilat.action_currency_id#" = evaluate("tahsilat_toplam_#get_senet_tahsilat.action_currency_id#")+get_senet_tahsilat.TOTAL_VALUE>
									<cfelse>
										#TLFORMAT(0)#
									</cfif>
								</td>
								<td>#len(get_senet_tahsilat.ACTION_CURRENCY_ID) ? get_senet_tahsilat.ACTION_CURRENCY_ID : session.ep.money#</td>
								<td class="text-right">
									<cfif len(get_senet_odeme.TOTAL_VALUE)>
										#TLFORMAT(get_senet_odeme.TOTAL_VALUE)#
										<cfset "odeme_toplam_#get_senet_odeme.action_currency_id#" = evaluate("odeme_toplam_#get_senet_odeme.action_currency_id#")+get_senet_odeme.TOTAL_VALUE>
									<cfelse>
										#TLFORMAT(0)#
									</cfif>
								</td>
								<td>#len(get_senet_odeme.ACTION_CURRENCY_ID) ? get_senet_odeme.ACTION_CURRENCY_ID : session.ep.money#</td>
							</tr>
							<tr>
								<cfset get_kredi_odeme = get_component.get_project_accounts(project_id: Project_List,codes:"291",type:"6",dsn2:new_donem_data_source,start_date:attributes.start_date,finish_date:attributes.finish_date)>
								<cfset get_kredi_tahsilat = get_component.get_project_accounts(project_id: Project_List,codes:"292,241,2410",type:"6",dsn2:new_donem_data_source,start_date:attributes.start_date,finish_date:attributes.finish_date)>

								<td><cf_get_lang dictionary_id='30101.Kredi Kartı Tahsilatları'></td>
								<td class="text-right">
									<cfif len(get_kredi_tahsilat.TOTAL_VALUE)>
										#TLFORMAT(get_kredi_tahsilat.TOTAL_VALUE)#
										<cfset "tahsilat_toplam_#get_kredi_tahsilat.action_currency_id#" = evaluate("tahsilat_toplam_#get_kredi_tahsilat.action_currency_id#")+get_kredi_tahsilat.TOTAL_VALUE>
									<cfelse>
										#TLFORMAT(0)#
									</cfif>
								</td>
								<td>#len(get_kredi_tahsilat.ACTION_CURRENCY_ID) ? get_kredi_tahsilat.ACTION_CURRENCY_ID : session.ep.money#</td>
								<td class="text-right">
									<cfif len(get_kredi_odeme.TOTAL_VALUE)>
										#TLFORMAT(get_kredi_odeme.TOTAL_VALUE)#
										<cfset "odeme_toplam_#get_kredi_odeme.action_currency_id#" = evaluate("odeme_toplam_#get_kredi_odeme.action_currency_id#")+get_kredi_odeme.TOTAL_VALUE>
									<cfelse>
										#TLFORMAT(0)#
									</cfif>
								</td>
								<td>#len(get_kredi_odeme.ACTION_CURRENCY_ID) ? get_kredi_odeme.ACTION_CURRENCY_ID : session.ep.money#</td>
							</tr>
							<tr>
								<cfset get_teminat_odeme = get_component.get_project_accounts(project_id: Project_List,codes:"301",type:"7",dsn2:new_donem_data_source,start_date:attributes.start_date,finish_date:attributes.finish_date)>
								<cfset get_teminat_tahsilat = get_component.get_project_accounts(project_id: Project_List,codes:"300",type:"7",dsn2:new_donem_data_source,start_date:attributes.start_date,finish_date:attributes.finish_date)>

								<td><cf_get_lang dictionary_id='57676.Teminatlar'></td>
								<td class="text-right">
									<cfif len(get_teminat_tahsilat.TOTAL_VALUE)>
										#TLFORMAT(get_teminat_tahsilat.TOTAL_VALUE)#
										<cfset "tahsilat_toplam_#get_teminat_tahsilat.action_currency_id#" = evaluate("tahsilat_toplam_#get_teminat_tahsilat.action_currency_id#")+get_teminat_tahsilat.TOTAL_VALUE>
									<cfelse>
										#TLFORMAT(0)#
									</cfif>
								</td>
								<td>#len(get_teminat_tahsilat.ACTION_CURRENCY_ID) ? get_teminat_tahsilat.ACTION_CURRENCY_ID : session.ep.money#</td>
								<td class="text-right">
									<cfif len(get_teminat_odeme.TOTAL_VALUE)>
										#TLFORMAT(get_teminat_odeme.TOTAL_VALUE)#
										<cfset "odeme_toplam_#get_teminat_odeme.action_currency_id#" = evaluate("odeme_toplam_#get_teminat_odeme.action_currency_id#")+get_teminat_odeme.TOTAL_VALUE>
									<cfelse>
										#TLFORMAT(0)#
									</cfif>
								</td>
								<td>#len(get_teminat_odeme.ACTION_CURRENCY_ID) ? get_teminat_odeme.ACTION_CURRENCY_ID : session.ep.money#</td>
							</tr>
						</tbody>
						<tfoot>
                            <tr>
                                <td class="formbold" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'></td>
								<td class="text-right">
									<cfloop query="get_money_rate">
										<cfif evaluate('tahsilat_toplam_#money#') gt 0>
											#Tlformat(evaluate('tahsilat_toplam_#money#'))#
											<cfset tahsilat_toplam = evaluate('tahsilat_toplam_#money#')>
										</cfif>
									</cfloop>
								</td>
								<td>
									<cfloop query="get_money_rate">
										<cfif evaluate('tahsilat_toplam_#money#') gt 0>
											#money#
										</cfif>
									</cfloop>
								</td>
								<td class="text-right">
									<cfloop query="get_money_rate">
										<cfif evaluate('odeme_toplam_#money#') gt 0>
											#Tlformat(evaluate('odeme_toplam_#money#'))#
											<cfset odeme_toplam = evaluate('odeme_toplam_#money#')>
										</cfif>
									</cfloop>
								</td>
								<td>
									<cfloop query="get_money_rate">
										<cfif evaluate('odeme_toplam_#money#') gt 0>
											#money#
										</cfif>
									</cfloop>
								</td>
                            </tr>
                        </tfoot>
					</cf_grid_list>
				</cf_box> 			
			</div>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="2" type="column">
				<cf_box title="#getLang('','Kar-Zarar','63211')#">
					<cfset toplu_kar_zarar = hakedis - maliyet>
					<script src="JS/Chart.min.js"></script>
						<canvas id="myChart"></canvas>
						<script>
							var ctx = document.getElementById("myChart");
							var myChart = new Chart(ctx, {
								type: 'bar',
								data: {
									labels: ["<cf_get_lang dictionary_id='39561.Toplam Satislar'>","<cf_get_lang dictionary_id='58258.Maliyet'>","<cf_get_lang dictionary_id='39553.Kar'>/<cf_get_lang dictionary_id='39554.Zarar'>"],
									datasets: [{
										label: ['<cf_get_lang dictionary_id='39568.Proje Icmal Raporu'>'],
										data: [<cfoutput>#wrk_round(hakedis,2)#</cfoutput>,<cfoutput>#wrk_round(maliyet,2)#</cfoutput>,<cfoutput>#wrk_round(toplu_kar_zarar,2)#</cfoutput>],
										backgroundColor: [<cfloop from="1" to="3" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
										borderWidth: 0
									} 
									]
								},
								options: {
									scales: {
										yAxes: [{
											ticks: {
												beginAtZero:true
											}
										}]
									}
								}
							});
					</script>
				</cf_box> 				 
				<cf_box title="#getLang('','Nakit Dengesi','813')#">						
					<p class="phead"><cf_get_lang dictionary_id ='57845.TAHSİLAT'>/<cf_get_lang dictionary_id ='57847.ÖDEME'><cf_get_lang dictionary_id ='58583.FARK '>: #TLFormat(tahsilat_toplam - odeme_toplam)#</p>
					<p class="phead"><cf_get_lang dictionary_id ='57845.TAHSİLAT'>/<cf_get_lang dictionary_id ='57847.ÖDEME'><cf_get_lang dictionary_id ='58671.ORANI'> : % <cfif odeme_toplam gt 0>#TLFormat(tahsilat_toplam/odeme_toplam*100)#<cfelse>0</cfif></p>
						<script src="JS/Chart.min.js"></script>
						<canvas id="myGraf" style="height:10%;"></canvas>
					<script>
						var ctx = document.getElementById('myGraf');
						var myGraf = new Chart(ctx, {
							type: 'horizontalBar',
							data: {
									labels: ["<cf_get_lang dictionary_id ='39894.Toplam Tahsilat'>","<cf_get_lang dictionary_id ='39895.Toplam Ödeme'>"],
									datasets: [{
									label: ['<cf_get_lang dictionary_id='39568.Proje Icmal Raporu'>'],
									backgroundColor: [<cfloop from="1" to="2" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
									data: [<cfoutput>#tahsilat_toplam#</cfoutput>,<cfoutput>#odeme_toplam#</cfoutput>],
										}]
									},
							options: {}
						});
					</script> 							
				</cf_box>
				<cf_box title="#getLang('','Süre','29513')#">					
					<cfset totalMinutes_est  = datediff('n',get_project_head.target_start,get_project_head.target_finish)>
					<cfset estimated_time = ((totalMinutes_est)/60)>

					<cfset totalMinutes_exp  = datediff('n',get_project_head.target_start,now())>
					<cfset expensed_time = ((totalMinutes_exp)/60)>

					<!--- <p class="phead">
						<cfset days=abs(datediff("d",get_project_head.TARGET_FINISH,get_project_head.TARGET_START))><cfoutput>#days+1# gün</cfoutput>
					</p> --->
					<script src="JS/Chart.min.js"></script>
						<canvas id="Chart1"></canvas>
						<script>
							var ctx = document.getElementById("Chart1");
							var Chart1 = new Chart(ctx, {
								type: 'bar',
								data: {
									labels: ["<cf_get_lang dictionary_id='38143.Öngörülen'> <cf_get_lang dictionary_id='41697'>","<cf_get_lang dictionary_id='38148.Harcanan Zaman'>"],
									datasets: [{
										label: ['<cf_get_lang dictionary_id='39568.Proje Icmal Raporu'>'],
										data: [<cfoutput>#estimated_time#</cfoutput>,<cfoutput>#expensed_time#</cfoutput>],
										backgroundColor: [<cfloop from="1" to="2" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
										borderWidth: 0
									} 
									]
								},
								options: {
									scales: {
										yAxes: [{
											ticks: {
												beginAtZero:true
											}
										}]
									}
								}
							});
					</script>	
							
				</cf_box>
				<cf_box title="#getLang('','İş Özeti','38279')#">
					<div class="col col-4 col-xs-12" align="center">						
						<p class="phead"><cf_get_lang dictionary_id ='58515.Aktif/Pasif'> <cf_get_lang dictionary_id ='58020.İşler'></p>
							
						<cfset worksAct_count = get_component.get_works(project_id: Project_List,active_passive:"1")>
						<cfset worksPas_count = get_component.get_works(project_id: Project_List,active_passive:"0")>
						<cfset active = listlen(valuelist(worksAct_count.WORK_COUNT))>
						<cfset passive = listlen(valuelist(worksPas_count.WORK_COUNT))>
						<canvas id="myChart9" style="height:100%;"></canvas>
						<script>
							var ctx = document.getElementById('myChart9');
							var myChart9 = new Chart(ctx, {
								type: 'doughnut',
								data: {
										labels: ["<cf_get_lang dictionary_id ='57493.Aktif'>","<cf_get_lang dictionary_id ='57494.Pasif'>"],
										datasets: [{
										label: "<cfoutput>#getLang('call',87)#</cfoutput>",
										backgroundColor: [<cfloop from="1" to="2" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
										data: [<cfoutput>#active#,#passive#</cfoutput>],
											}]
										},
								options: {
									legend: {
										display: false
									}
								}
							});
						</script>								
					</div>
					<div class="col col-4 col-xs-12" align="center">
						<p class="phead"><cf_get_lang dictionary_id ='40177.Kategorilere'> <cf_get_lang dictionary_id ='58020.İşler'></p>
							<cfset workCat_count = get_component.get_works(project_id: Project_List,cat_works:"1")>
							<cfloop query="workCat_count">
								<cfset 'item_#currentrow#' = "#WORK_CAT#">
								<cfset 'value_#currentrow#' = "#WORK_COUNT#">
							</cfloop>
							<canvas id="myChart7" style="height:100%;"></canvas>
							<script>
								var ctx = document.getElementById('myChart7');
								var myChart7 = new Chart(ctx, {
									type: 'doughnut',
									data: {
											labels: [<cfloop from="1" to="#workCat_count.recordcount#" index="jj">
													<cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
											datasets: [{
											label: "<cfoutput>#getLang('call',87)#</cfoutput>",
											backgroundColor: [<cfloop from="1" to="#workCat_count.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
											data: [<cfloop from="1" to="#workCat_count.recordcount#" index="jj"><cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
												}]
											},
									options: {
										legend: {
											display: false
										}
									}
								});
							</script>
					</div>
					<div class="col col-4 col-xs-12" align="center">
						<p class="phead"><cf_get_lang dictionary_id ='40176.Aşamalara Göre'> <cf_get_lang dictionary_id ='58020.İşler'></p>
						<cfset worksStage_count = get_component.get_works(project_id: Project_List,stage_works:"1")>
						<cfloop query="worksStage_count">
							<cfset 'item_#currentrow#' = "#STAGE#">
							<cfset 'value_#currentrow#' = "#WORK_COUNT#">
						</cfloop>
						<canvas id="myChart8" style="height:100%;"></canvas>
						<script>
							var ctx = document.getElementById('myChart8');
							var myChart8 = new Chart(ctx, {
								type: 'doughnut',
								data: {
										labels: [<cfloop from="1" to="#worksStage_count.recordcount#" index="jj">
												<cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
										datasets: [{
										label: "<cfoutput>#getLang('call',87)#</cfoutput>",
										backgroundColor: [<cfloop from="1" to="#worksStage_count.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
										data: [<cfloop from="1" to="#worksStage_count.recordcount#" index="jj"><cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
											}]
										},
								options: {
									legend: {
										display: false
									}
								}
							});
						</script>
					</div>
				</cf_box> 
			</div>  
		</cfoutput>
	<cfelseif isdefined('attributes.form_submit')>
		<cfif isdefined('attributes.lower_projects') and len(attributes.lower_projects)>
			<cfquery name="GET_LOWER_PROJECTS" datasource="#DSN#">
				SELECT 
					PROJECT_ID,
					RELATED_PROJECT_ID,
					TARGET_START,
					TARGET_FINISH
				FROM 
					PRO_PROJECTS 
				WHERE 
					(
						PROJECT_ID = #attributes.project_id# OR 
						RELATED_PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
					)
					<cfif Len(attributes.main_project_cat)>
						AND PROCESS_CAT IN (#attributes.main_project_cat#)
					</cfif>
					<cfif isdefined('attributes.start_date') and len(attributes.start_date)>
						AND TARGET_START >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
					</cfif>
					<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
						AND TARGET_FINISH <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
					</cfif>
					<cfif Len(attributes.status)>
						AND PROJECT_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.status#">
					</cfif>
			</cfquery>
			
			<!--- Eger alt projeleri görüntülemek isteniyorsa project_id yi çokluyoruz yani alt projelerin id'leri ile birlestiriyoruz. --->
			<cfif get_lower_projects.recordcount and len(get_lower_projects.related_project_id) or len(get_lower_projects.project_id)>
				<cfset attributes.project_id = ListAppend(attributes.project_id,ValueList(get_lower_projects.related_project_id,','),',')>
				<cfset attributes.project_id = ListAppend(attributes.project_id,ValueList(get_lower_projects.project_id,','),',')>
				<cfset attributes.project_id = ListDeleteduplicates(attributes.project_id)>
			</cfif>
		</cfif>
		<cfquery name="GET_PROJECT_ALL_RECORDS" datasource="#new_donem_data_source#">
			SELECT
				TYPE,
				SUM(PRICE) PRICE,
				PP.PROJECT_ID,
				PP.PROJECT_HEAD
			FROM
				(
					SELECT 
						1 TYPE,
						ISNULL(SUM(IR.NETTOTAL),0) PRICE,
						<cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(IR.ROW_PROJECT_ID,I.PROJECT_ID)<cfelse>ISNULL(I.PROJECT_ID,IR.ROW_PROJECT_ID)</cfif> PROJECT_ID
					FROM 
						INVOICE I,
						INVOICE_ROW IR
					WHERE
						I.INVOICE_ID = IR.INVOICE_ID AND
						I.INVOICE_CAT = 561 AND
						I.IS_IPTAL = 0
						<cfif isdefined('attributes.project_id') and len(attributes.project_id)>
							AND <cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(IR.ROW_PROJECT_ID,I.PROJECT_ID)<cfelse>ISNULL(I.PROJECT_ID,IR.ROW_PROJECT_ID)</cfif> IN (#attributes.project_id#)
						</cfif>
						<cfif Get_Project_Cat.recordcount >
							AND <cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(IR.ROW_PROJECT_ID,I.PROJECT_ID)<cfelse>ISNULL(I.PROJECT_ID,IR.ROW_PROJECT_ID)</cfif> IN (SELECT PROJECT_ID FROM ####GET_PROJECT_CAT_#session.ep.userid#)
						</cfif>
						<cfif isdefined('attributes.start_date') and len(attributes.start_date)>
							AND I.INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
						</cfif>
						<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
							AND I.INVOICE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
						</cfif>
					GROUP BY
						<cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(IR.ROW_PROJECT_ID,I.PROJECT_ID)<cfelse>ISNULL(I.PROJECT_ID,IR.ROW_PROJECT_ID)</cfif>
		
					UNION ALL
		
					SELECT 
						11 TYPE,
						ISNULL(SUM(IR.NETTOTAL),0) PRICE,
						<cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(IR.ROW_PROJECT_ID,I.PROJECT_ID)<cfelse>ISNULL(I.PROJECT_ID,IR.ROW_PROJECT_ID)</cfif> PROJECT_ID
					FROM 
						INVOICE I,
						INVOICE_ROW IR
					WHERE
						I.INVOICE_ID = IR.INVOICE_ID AND
						I.INVOICE_CAT = 601 AND
						I.IS_IPTAL = 0
						<cfif isdefined('attributes.project_id') and len(attributes.project_id)>
							AND <cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(IR.ROW_PROJECT_ID,I.PROJECT_ID)<cfelse>ISNULL(I.PROJECT_ID,IR.ROW_PROJECT_ID)</cfif> IN (#attributes.project_id#)
						</cfif>
						<cfif Get_Project_Cat.recordcount >
							AND <cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(IR.ROW_PROJECT_ID,I.PROJECT_ID)<cfelse>ISNULL(I.PROJECT_ID,IR.ROW_PROJECT_ID)</cfif> IN (SELECT PROJECT_ID FROM ####GET_PROJECT_CAT_#session.ep.userid#)
						</cfif>
						<cfif isdefined('attributes.start_date') and len(attributes.start_date)>
							AND I.INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
						</cfif>
						<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
							AND I.INVOICE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
						</cfif>
					GROUP BY
						<cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(IR.ROW_PROJECT_ID,I.PROJECT_ID)<cfelse>ISNULL(I.PROJECT_ID,IR.ROW_PROJECT_ID)</cfif>
			
					UNION ALL
			
					SELECT
						<!--- Masraf Fisleri --->
						2 TYPE,
						ISNULL(SUM(EIR.AMOUNT*ISNULL(EIR.QUANTITY,1)),0) AS PRICE,
						<cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(EIR.PROJECT_ID,EIP.PROJECT_ID)<cfelse>ISNULL(EIP.PROJECT_ID,EIR.PROJECT_ID)</cfif> PROJECT_ID
					FROM
						EXPENSE_ITEM_PLANS EIP,
						EXPENSE_ITEMS_ROWS EIR
					WHERE 
						EIP.EXPENSE_ID = EIR.EXPENSE_ID AND
						EIP.ACTION_TYPE = 120 AND <!--- Masraf Fisi Islem Tipi --->
						EIR.INVOICE_ID IS NULL AND <!--- Faturadan otomatik oluşturulmuş olan masraflar buraya gelmesin,çünkü zaten satışlar kısmına yansıyor buraya yansımaması lazım. --->
						EIR.IS_INCOME = 0
						<cfif len(attributes.project_id)>
							AND <cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(EIR.PROJECT_ID,EIP.PROJECT_ID)<cfelse>ISNULL(EIP.PROJECT_ID,EIR.PROJECT_ID)</cfif> IN (#attributes.project_id#)
						</cfif>
						<cfif Get_Project_Cat.recordcount >
							AND <cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(EIR.PROJECT_ID,EIP.PROJECT_ID)<cfelse>ISNULL(EIP.PROJECT_ID,EIR.PROJECT_ID)</cfif> IN (SELECT PROJECT_ID FROM ####GET_PROJECT_CAT_#session.ep.userid#)
						</cfif>
						<cfif isdefined('attributes.start_date') and len(attributes.start_date)>
							AND EIP.EXPENSE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
						</cfif>
						<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
							AND EIP.EXPENSE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
						</cfif>
					GROUP BY
						<cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(EIR.PROJECT_ID,EIP.PROJECT_ID)<cfelse>ISNULL(EIP.PROJECT_ID,EIR.PROJECT_ID)</cfif>
						
					UNION ALL
					
					SELECT
						<!--- Bakim Fisleri --->
						14 TYPE,
						ISNULL(SUM(EIR.AMOUNT*ISNULL(EIR.QUANTITY,1)),0) AS PRICE,
						<cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(EIR.PROJECT_ID,EIP.PROJECT_ID)<cfelse>ISNULL(EIP.PROJECT_ID,EIR.PROJECT_ID)</cfif> PROJECT_ID
					FROM
						EXPENSE_ITEM_PLANS EIP,
						EXPENSE_ITEMS_ROWS EIR
						<!--- ,EXPENSE_ITEMS EI --->
					WHERE
						EIP.EXPENSE_ID = EIR.EXPENSE_ID AND
						<!--- EI.EXPENSE_ITEM_ID = EIR.EXPENSE_ITEM_ID AND --->
						EIP.ACTION_TYPE = 122 AND <!--- Bakim Fisi Islem Tipi --->
						EIR.INVOICE_ID IS NULL AND <!--- Faturadan otomatik oluşturulmuş olan masraflar buraya gelmesin,çünkü zaten satışlar kısmına yansıyor buraya yansımaması lazım. --->
						EIR.IS_INCOME = 0
						<cfif isdefined('attributes.project_id') and len(attributes.project_id)>
							AND <cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(EIR.PROJECT_ID,EIP.PROJECT_ID)<cfelse>ISNULL(EIP.PROJECT_ID,EIR.PROJECT_ID)</cfif> IN (#attributes.project_id#)
						</cfif>
						<cfif Get_Project_Cat.recordcount>
							AND <cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(EIR.PROJECT_ID,EIP.PROJECT_ID)<cfelse>ISNULL(EIP.PROJECT_ID,EIR.PROJECT_ID)</cfif> IN (SELECT PROJECT_ID FROM ####GET_PROJECT_CAT_#session.ep.userid#)
						</cfif>
						<cfif isdefined('attributes.start_date') and len(attributes.start_date)>
							AND EIP.EXPENSE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
						</cfif>
						<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
							AND EIP.EXPENSE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
						</cfif>
					GROUP BY
						<cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(EIR.PROJECT_ID,EIP.PROJECT_ID)<cfelse>ISNULL(EIP.PROJECT_ID,EIR.PROJECT_ID)</cfif>
			
					UNION ALL
			
					SELECT
						<!--- Gelir Fisleri --->
						12 TYPE,
						ISNULL(SUM(EIR.AMOUNT*ISNULL(EIR.QUANTITY,1)),0) AS PRICE,
						<cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(EIR.PROJECT_ID,EIP.PROJECT_ID)<cfelse>ISNULL(EIP.PROJECT_ID,EIR.PROJECT_ID)</cfif> PROJECT_ID
					FROM 
						EXPENSE_ITEM_PLANS EIP,
						EXPENSE_ITEMS_ROWS EIR
						<!--- ,EXPENSE_ITEMS EI --->
					WHERE
						EIP.EXPENSE_ID = EIR.EXPENSE_ID AND
						<!--- EI.EXPENSE_ITEM_ID = EIR.EXPENSE_ITEM_ID AND --->
						EIP.ACTION_TYPE = 121 AND <!--- Gelir Fisi Islem Tipi --->
						EIR.INVOICE_ID IS NULL AND <!--- Faturadan otomatik oluşturulmuş olan masraflar buraya gelmesin,çünkü zaten satışlar kısmına yansıyor buraya yansımaması lazım. --->
						EIR.IS_INCOME = 1
						<cfif len(attributes.project_id)>
							AND <cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(EIR.PROJECT_ID,EIP.PROJECT_ID)<cfelse>ISNULL(EIP.PROJECT_ID,EIR.PROJECT_ID)</cfif> IN (#attributes.project_id#)
						</cfif>
						<cfif Get_Project_Cat.recordcount>
							AND <cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(EIR.PROJECT_ID,EIP.PROJECT_ID)<cfelse>ISNULL(EIP.PROJECT_ID,EIR.PROJECT_ID)</cfif> IN (SELECT PROJECT_ID FROM ####GET_PROJECT_CAT_#session.ep.userid#)
						</cfif>
						<cfif isdefined('attributes.start_date') and len(attributes.start_date)>
							AND EIP.EXPENSE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
						</cfif>
						<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
							AND EIP.EXPENSE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
						</cfif>
					GROUP BY
						<cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(EIR.PROJECT_ID,EIP.PROJECT_ID)<cfelse>ISNULL(EIP.PROJECT_ID,EIR.PROJECT_ID)</cfif>
			
					UNION ALL		
			
					SELECT 
						3 TYPE,
						ISNULL(SUM(EXPENSED_MONEY),0) EXPENSED_MONEY,
						PROJECT_ID
					FROM
						#dsn_alias#.TIME_COST as TIME_COST
					WHERE
						PROJECT_ID IS NOT NULL
						<cfif isdefined('attributes.project_id') and len(attributes.project_id)>
							AND PROJECT_ID IN (#attributes.project_id#)
						</cfif>
						<cfif Get_Project_Cat.recordcount>
							AND PROJECT_ID IN (SELECT PROJECT_ID FROM ####GET_PROJECT_CAT_#session.ep.userid#)
						</cfif>
						<cfif isdefined('attributes.start_date') and len(attributes.start_date)>
							AND EVENT_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
						</cfif>
						<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
							AND EVENT_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
						</cfif>
					GROUP BY
						PROJECT_ID
		
				<cfif isdefined("is_cost_of_material") and is_cost_of_material eq 1><!--- xmlde Malzeme Maliyetini Goster evet ise --->
					UNION ALL
					SELECT 
						4 TYPE,
						ISNULL(SUM(MALIYET*STOCK_OUT),0) AS TOPLAM_MALIYET,
						PROJECT_ID
					FROM
					( 
						SELECT
							ISNULL((SELECT
								TOP 1 (PURCHASE_NET_SYSTEM + PURCHASE_EXTRA_COST_SYSTEM)  
							FROM 
								GET_PRODUCT_COST_PERIOD
							WHERE
								GET_PRODUCT_COST_PERIOD.START_DATE <= STOCK_FIS.FIS_DATE
								AND GET_PRODUCT_COST_PERIOD.PRODUCT_ID = S.PRODUCT_ID
								AND ISNULL(GET_PRODUCT_COST_PERIOD.SPECT_MAIN_ID,0)=ISNULL(STOCK_FIS_ROW.SPECT_VAR_ID,0)
							ORDER BY
								GET_PRODUCT_COST_PERIOD.START_DATE DESC,
								GET_PRODUCT_COST_PERIOD.RECORD_DATE DESC,
								GET_PRODUCT_COST_PERIOD.PRODUCT_COST_ID DESC
								),0) MALIYET,
							STOCK_FIS_ROW.AMOUNT STOCK_OUT,
							<cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(STOCK_FIS_ROW.ROW_PROJECT_ID,STOCK_FIS.PROJECT_ID)<cfelse>STOCK_FIS.PROJECT_ID</cfif> PROJECT_ID
						FROM
							STOCK_FIS_ROW,
							STOCK_FIS,
							#dsn3_alias#.STOCKS S
						WHERE 
							STOCK_FIS.FIS_ID = STOCK_FIS_ROW.FIS_ID AND 
							S.STOCK_ID = STOCK_FIS_ROW.STOCK_ID AND 
							STOCK_FIS.FIS_TYPE = 111
							<cfif isdefined("x_is_show_from_prodution_fis") and x_is_show_from_prodution_fis eq 1>
								AND STOCK_FIS.PROD_ORDER_NUMBER IS NULL <!--- Üretimden oluşanlar sarflar gelince sarf maliyetini 2ye katladığı gerekçesi ile kaldırıldı --->
							</cfif>
							<cfif Get_Project_Cat.recordcount>
								AND <cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(STOCK_FIS_ROW.ROW_PROJECT_ID,STOCK_FIS.PROJECT_ID)<cfelse>STOCK_FIS.PROJECT_ID</cfif> IN (SELECT PROJECT_ID FROM ####GET_PROJECT_CAT_#session.ep.userid#)
							</cfif>
							AND <cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(STOCK_FIS_ROW.ROW_PROJECT_ID,STOCK_FIS.PROJECT_ID)<cfelse>STOCK_FIS.PROJECT_ID</cfif> IS NOT NULL
							<cfif isdefined('attributes.start_date') and len(attributes.start_date)>
								AND FIS_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
							</cfif>
							<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
								AND FIS_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
							</cfif>
					)T1
					GROUP BY
						PROJECT_ID
				</cfif>
		
					UNION ALL
		
					SELECT 
						5 TYPE,
						ISNULL(SUM(IR.NETTOTAL),0) PRICE,
						<cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(IR.ROW_PROJECT_ID,I.PROJECT_ID)<cfelse>ISNULL(I.PROJECT_ID,IR.ROW_PROJECT_ID)</cfif> PROJECT_ID
					FROM 
						INVOICE I,
						INVOICE_ROW IR
					WHERE
						I.INVOICE_ID = IR.INVOICE_ID AND
						I.INVOICE_CAT = 56 AND
						I.IS_IPTAL = 0
						<cfif isdefined('attributes.project_id') and len(attributes.project_id)>
							AND <cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(IR.ROW_PROJECT_ID,I.PROJECT_ID)<cfelse>ISNULL(I.PROJECT_ID,IR.ROW_PROJECT_ID)</cfif> IN (#attributes.project_id#)
						</cfif>
						<cfif Get_Project_Cat.recordcount>
							AND <cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(IR.ROW_PROJECT_ID,I.PROJECT_ID)<cfelse>ISNULL(I.PROJECT_ID,IR.ROW_PROJECT_ID)</cfif> IN (SELECT PROJECT_ID FROM ####GET_PROJECT_CAT_#session.ep.userid#)
						</cfif>
						<cfif isdefined('attributes.start_date') and len(attributes.start_date)>
							AND I.INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
						</cfif>
						<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
							AND I.INVOICE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
						</cfif>
					GROUP BY
						<cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(IR.ROW_PROJECT_ID,I.PROJECT_ID)<cfelse>ISNULL(I.PROJECT_ID,IR.ROW_PROJECT_ID)</cfif>
			
					UNION ALL
					
					SELECT
						7 TYPE,
						ISNULL(SUM(PRICE_P)-SUM(PRICE_N),0) PRICE,
						PROJECT_ID
					FROM
					(
						SELECT 
							SUM(ISNULL(IR.NETTOTAL,0)) AS PRICE_P,
							0 PRICE_N,
							<cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(IR.ROW_PROJECT_ID,I.PROJECT_ID)<cfelse>ISNULL(I.PROJECT_ID,IR.ROW_PROJECT_ID)</cfif> PROJECT_ID
						FROM 
							INVOICE I,
							INVOICE_ROW IR
						WHERE
							I.INVOICE_ID = IR.INVOICE_ID AND
							I.INVOICE_CAT IN(53,531,58) AND
							I.IS_IPTAL = 0
							<cfif isdefined('attributes.project_id') and len(attributes.project_id)>
								AND <cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(IR.ROW_PROJECT_ID,I.PROJECT_ID)<cfelse>ISNULL(I.PROJECT_ID,IR.ROW_PROJECT_ID)</cfif> IN (#attributes.project_id#)
							</cfif>
							<cfif Get_Project_Cat.recordcount >
								AND <cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(IR.ROW_PROJECT_ID,I.PROJECT_ID)<cfelse>ISNULL(I.PROJECT_ID,IR.ROW_PROJECT_ID)</cfif> IN (SELECT PROJECT_ID FROM ####GET_PROJECT_CAT_#session.ep.userid#)
							</cfif>
							<cfif isdefined('attributes.start_date') and len(attributes.start_date)>
								AND I.INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
							</cfif>
							<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
								AND I.INVOICE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
							</cfif>
						GROUP BY
							<cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(IR.ROW_PROJECT_ID,I.PROJECT_ID)<cfelse>ISNULL(I.PROJECT_ID,IR.ROW_PROJECT_ID)</cfif>
					UNION ALL
						SELECT 
							0 PRICE_P,
							SUM(ISNULL(IR.NETTOTAL,0)) AS PRICE_N,
							<cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(IR.ROW_PROJECT_ID,I.PROJECT_ID)<cfelse>ISNULL(I.PROJECT_ID,IR.ROW_PROJECT_ID)</cfif> PROJECT_ID
						FROM 
							INVOICE I,
							INVOICE_ROW IR
						WHERE
							I.INVOICE_ID = IR.INVOICE_ID AND
							<!---58 Verilen Fiyat Farki Faturasi,55 Topt Sat Iade Fatura  --->
							I.INVOICE_CAT IN(55,63) AND
							I.IS_IPTAL = 0
							<cfif isdefined('attributes.project_id') and len(attributes.project_id)>
								AND <cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(IR.ROW_PROJECT_ID,I.PROJECT_ID)<cfelse>ISNULL(I.PROJECT_ID,IR.ROW_PROJECT_ID)</cfif> IN (#attributes.project_id#)
							</cfif>
							<cfif Get_Project_Cat.recordcount >
								AND <cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(IR.ROW_PROJECT_ID,I.PROJECT_ID)<cfelse>ISNULL(I.PROJECT_ID,IR.ROW_PROJECT_ID)</cfif> IN (SELECT PROJECT_ID FROM ####GET_PROJECT_CAT_#session.ep.userid#)
							</cfif>
							<cfif isdefined('attributes.start_date') and len(attributes.start_date)>
								AND I.INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
							</cfif>
							<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
								AND I.INVOICE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
							</cfif>
						GROUP BY
							<cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(IR.ROW_PROJECT_ID,I.PROJECT_ID)<cfelse>ISNULL(I.PROJECT_ID,IR.ROW_PROJECT_ID)</cfif>
					) T1
					GROUP BY
						PROJECT_ID
						
					UNION ALL
				
					SELECT 
						6 TYPE,
						ISNULL(SUM(IR.NETTOTAL),0) PRICE,
						<cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(IR.ROW_PROJECT_ID,I.PROJECT_ID)<cfelse>ISNULL(I.PROJECT_ID,IR.ROW_PROJECT_ID)</cfif> PROJECT_ID
					FROM 
						INVOICE I,
						INVOICE_ROW IR
					WHERE
						I.INVOICE_ID = IR.INVOICE_ID AND
						I.INVOICE_CAT IN (60) AND
						I.IS_IPTAL = 0
						<cfif isdefined('attributes.project_id') and len(attributes.project_id)>
							AND <cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(IR.ROW_PROJECT_ID,I.PROJECT_ID)<cfelse>ISNULL(I.PROJECT_ID,IR.ROW_PROJECT_ID)</cfif> IN (#attributes.project_id#)
						</cfif>
						<cfif Get_Project_Cat.recordcount>
							AND <cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(IR.ROW_PROJECT_ID,I.PROJECT_ID)<cfelse>ISNULL(I.PROJECT_ID,IR.ROW_PROJECT_ID)</cfif> IN (SELECT PROJECT_ID FROM ####GET_PROJECT_CAT_#session.ep.userid#)
						</cfif>
						<cfif isdefined('attributes.start_date') and len(attributes.start_date)>
							AND I.INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
						</cfif>
						<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
							AND I.INVOICE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
						</cfif>
					GROUP BY
						<cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(IR.ROW_PROJECT_ID,I.PROJECT_ID)<cfelse>ISNULL(I.PROJECT_ID,IR.ROW_PROJECT_ID)</cfif>
				
				<cfif isdefined("is_cost_of_product_sold") and is_cost_of_product_sold eq 1><!--- xmlde Satılan Malin Maliyetini Goster evet ise --->
					UNION ALL
		
					SELECT   
						8 TYPE,
						ISNULL((SUM(TOPLAM_MALIYET_P)- SUM(TOPLAM_MALIYET_N)),0) TOPLAM_MALIYET_,
						PROJECT_ID
					FROM
						(
						SELECT 
							ISNULL(SUM(MALIYET*STOCK_OUT),0)AS TOPLAM_MALIYET_P,
							0 TOPLAM_MALIYET_N,
							PROJECT_ID
						FROM 
							GET_STOCKS_ROW_COST,
							SHIP
							<cfif len(session.ep.money2) and session.ep.money2 is not session.ep.money>
								,SHIP_MONEY					
							</cfif>		
						WHERE 
							<!--- Toptan Satis Irsaliyesi (Cikis) --->
							SHIP.SHIP_ID = GET_STOCKS_ROW_COST.UPD_ID AND
							SHIP.SHIP_TYPE = 71 AND
							IS_SHIP_IPTAL = 0 AND 
							<cfif len(session.ep.money2) and session.ep.money2 is not session.ep.money>
								SHIP.SHIP_ID = SHIP_MONEY.ACTION_ID AND
								SHIP_MONEY.MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#"> AND
								SHIP.IS_WITH_SHIP = 0 AND<!---SHIP_MONEY tablosuna baglanıldıgında sadece bagımsız olarak olusturulan irsaliyeler bu blokta getiriliyor, faturadan olusturulan irsaliyeler diger blokta çekiliyor --->
							</cfif>
							GET_STOCKS_ROW_COST.PROCESS_TYPE=SHIP.SHIP_TYPE
							<cfif isdefined('attributes.project_id') and len(attributes.project_id)>
								AND SHIP.PROJECT_ID IN (#attributes.project_id#)
							</cfif>
							<cfif Get_Project_Cat.recordcount>
								AND SHIP.PROJECT_ID IN (SELECT PROJECT_ID FROM ####GET_PROJECT_CAT_#session.ep.userid#)
							</cfif>
							<cfif isdefined('attributes.start_date') and len(attributes.start_date)>
								AND SHIP.SHIP_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
							</cfif>
							<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
								AND SHIP.SHIP_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
							</cfif>
						GROUP BY
							PROJECT_ID
					<cfif len(session.ep.money2) and session.ep.money2 is not session.ep.money> <!--- sistem 2. para birimi varsa faturadan olusturulan irsaliyeler bu blokta cekiliyor --->
						UNION ALL
							SELECT 
								ISNULL(SUM(MALIYET*STOCK_OUT),0)AS TOPLAM_MALIYET_P,
								ISNULL(SUM(MALIYET*STOCK_IN),0) AS TOPLAM_MALIYET_N,
								INVOICE.PROJECT_ID
							FROM 
								SHIP,
								INVOICE,
								INVOICE_ROW,
								INVOICE_SHIPS INV_S,
								INVOICE_MONEY IM,
								GET_STOCKS_ROW_COST GC
							WHERE
								SHIP.SHIP_ID = INV_S.SHIP_ID
								AND INVOICE.INVOICE_ID= INV_S.INVOICE_ID
								AND INVOICE.INVOICE_ID = INVOICE_ROW.INVOICE_ID
								AND INVOICE_ROW.INVOICE_ID = INV_S.INVOICE_ID
								AND INVOICE_ROW.STOCK_ID = GC.STOCK_ID
								AND SHIP.IS_WITH_SHIP = 1
								AND INV_S.SHIP_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
								AND SHIP.IS_WITH_SHIP = 1
								AND SHIP.SHIP_ID = GC.UPD_ID
								AND SHIP.SHIP_TYPE = GC.PROCESS_TYPE
								AND SHIP.SHIP_TYPE IN (71,74,88) 
								AND INVOICE.IS_IPTAL = 0
								AND IM.ACTION_ID=INVOICE.INVOICE_ID
								AND IM.MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
								<cfif isdefined('attributes.project_id') and len(attributes.project_id)>
									AND <cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(INVOICE_ROW.ROW_PROJECT_ID,INVOICE.PROJECT_ID)<cfelse>ISNULL(INVOICE.PROJECT_ID,INVOICE_ROW.ROW_PROJECT_ID)</cfif> IN (#attributes.project_id#)
								</cfif>
								<cfif Get_Project_Cat.recordcount>
									AND <cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(INVOICE_ROW.ROW_PROJECT_ID,INVOICE.PROJECT_ID)<cfelse>ISNULL(INVOICE.PROJECT_ID,INVOICE_ROW.ROW_PROJECT_ID)</cfif> IN (SELECT PROJECT_ID FROM ####GET_PROJECT_CAT_#session.ep.userid#)
								</cfif>
								<cfif isdefined('attributes.start_date') and len(attributes.start_date)>
									AND SHIP.SHIP_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
								</cfif>
								<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
									AND SHIP.SHIP_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
								</cfif>
							GROUP BY
								INVOICE.PROJECT_ID
					</cfif>	
					) T2  
					GROUP BY
						PROJECT_ID  
				</cfif>
				<!--- xmlde Alımları Goster evet ise --->
				
					UNION ALL
					SELECT	   
						13 TYPE,
						ISNULL((SUM(TOPLAM_MALIYET_P)- SUM(TOPLAM_MALIYET_N)),0) TOPLAM_MALIYET_,
						PROJECT_ID
					FROM
						(
							SELECT 
								<!--- Alim faturasi --->
								ISNULL(SUM(IR.NETTOTAL),0) TOPLAM_MALIYET_P,
								0 TOPLAM_MALIYET_N,
								<cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(IR.ROW_PROJECT_ID,I.PROJECT_ID)<cfelse>ISNULL(I.PROJECT_ID,IR.ROW_PROJECT_ID)</cfif> PROJECT_ID
							FROM 
								INVOICE I,
								INVOICE_ROW IR
							WHERE
								I.INVOICE_ID = IR.INVOICE_ID AND
								I.INVOICE_CAT  IN (59,591,691,68,65,661) AND
								I.IS_IPTAL = 0
								<cfif isdefined('attributes.project_id') and len(attributes.project_id)>
									AND <cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(IR.ROW_PROJECT_ID,I.PROJECT_ID)<cfelse>ISNULL(I.PROJECT_ID,IR.ROW_PROJECT_ID)</cfif> IN (#attributes.project_id#)
								</cfif>
								<cfif Get_Project_Cat.recordcount>
									AND <cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(IR.ROW_PROJECT_ID,I.PROJECT_ID)<cfelse>ISNULL(I.PROJECT_ID,IR.ROW_PROJECT_ID)</cfif> IN (SELECT PROJECT_ID FROM ####GET_PROJECT_CAT_#session.ep.userid#)
								</cfif>
								<cfif isdefined('attributes.start_date') and len(attributes.start_date)>
									AND I.INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
								</cfif>
								<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
									AND I.INVOICE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
								</cfif>
							GROUP BY
								<cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(IR.ROW_PROJECT_ID,I.PROJECT_ID)<cfelse>ISNULL(I.PROJECT_ID,IR.ROW_PROJECT_ID)</cfif>
				
							UNION ALL
				
							SELECT 
								0 TOPLAM_MALIYET_P,
								ISNULL(SUM(IR.NETTOTAL),0) TOPLAM_MALIYET_N,
								<cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(IR.ROW_PROJECT_ID,I.PROJECT_ID)<cfelse>ISNULL(I.PROJECT_ID,IR.ROW_PROJECT_ID)</cfif> PROJECT_ID
							FROM 
								INVOICE I,
								INVOICE_ROW IR
							WHERE
								I.INVOICE_ID = IR.INVOICE_ID AND
								<!--- Alim iade faturasi --->
								I.INVOICE_CAT = 62 AND
								I.IS_IPTAL = 0
								<cfif isdefined('attributes.project_id') and len(attributes.project_id)>
									AND <cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(IR.ROW_PROJECT_ID,I.PROJECT_ID)<cfelse>ISNULL(I.PROJECT_ID,IR.ROW_PROJECT_ID)</cfif> IN (#attributes.project_id#)
								</cfif>
								<cfif Get_Project_Cat.recordcount>
									AND <cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(IR.ROW_PROJECT_ID,I.PROJECT_ID)<cfelse>ISNULL(I.PROJECT_ID,IR.ROW_PROJECT_ID)</cfif> IN (SELECT PROJECT_ID FROM ####GET_PROJECT_CAT_#session.ep.userid#)
								</cfif>
								<cfif isdefined('attributes.start_date') and len(attributes.start_date)>
									AND I.INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
								</cfif>
								<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
									AND I.INVOICE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
								</cfif>
							GROUP BY
								<cfif isdefined("x_is_priority_row_project") and x_is_priority_row_project eq 1>ISNULL(IR.ROW_PROJECT_ID,I.PROJECT_ID)<cfelse>ISNULL(I.PROJECT_ID,IR.ROW_PROJECT_ID)</cfif>
					) T3 
				GROUP BY
					PROJECT_ID
			
			) MAIN_QUERY,
			#dsn_alias#.PRO_PROJECTS PP
			WHERE
				PP.PROJECT_ID = MAIN_QUERY.PROJECT_ID
				<cfif isdefined("attributes.workgroup_id") and len(attributes.workgroup_id)>
					AND PP.WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.workgroup_id#">
				</cfif>
				<cfif Len(attributes.status)>
					AND PP.PROJECT_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.status#">
				</cfif>
			GROUP BY
				TYPE,
				PP.PROJECT_ID,
				PP.PROJECT_HEAD
		</cfquery>
		
		<cfset all_projects = listsort(listdeleteduplicates(valuelist(get_project_all_records.project_id,",")),'numeric','asc',',') >
		<cfset all_types =  '1,2,3,4,5,6,7,8,11,12,13,14'><!--- Union blokta dönen type'ler,eger yeni bi sey eklenirse union bloga burayada eklenmesi gerekiyor. --->
		<cfparam name="attributes.totalrecords" default="#Listlen(all_projects)#">
		<cfloop query="get_project_all_records" ><!--- Gelen proje bilgilerinin price'lari type ve projesine göre set ediliyor.Yani burda sadece kayit dönen degerler set ediliyor--->
			<cfset 'T#TYPE#_P#project_id#' = price>
			<cfset 'project_head_#project_id#' = project_head>
			<cfset 'genel_kar_toplam_#project_id#' = 0><!--- Projelerin ayri ayri genel toplamlari öncelikle 0 set ediliyor. --->
		
		</cfloop>
		<cfloop list="#all_types#" index="tt"><!--- Toplamlarda kullanilmak için set edilmemis yani kayit olmayan proje'lerin degerleri 0 olarak set ediliyor. --->
			<cfloop list="#all_projects#" index="pp">
				<cfif not isdefined('T#tt#_P#pp#')><cfset 'T#tt#_P#pp#' = 0></cfif><!--- <cfloop query="get_project_all_records"> döndürülürken deger gelmeeyen yada bos gelen degerler 0 set ediliyor.(Maliyet tablolarindan bazen deger gelmiyor onun için) --->
				<cfif ListFind("1,5,7,12",tt,",")><!--- 1,5,7,12 TYPE (+) olanlar yani genel kar toplamin pozitif degerleri --->
					<cfset 'genel_kar_toplam_#pp#' = evaluate("genel_kar_toplam_#pp#") + evaluate("T#tt#_P#pp#")>
				<cfelse><!--- Diger durumlarda da genel kar'dan negatif degerli TYPE'ler çikartiliyor. --->
					<cfif ListFind("4",tt,",")><!--- TYPE 4 ise proje maliyeti sarflara esitleniyor. --->
						<cfset 'proje_maliyet_#pp#' = evaluate("T#tt#_P#pp#") >
					</cfif>
					<cfset 'genel_kar_toplam_#pp#' = evaluate("genel_kar_toplam_#pp#") - evaluate("T#tt#_P#pp#")>
				</cfif>
			</cfloop>
		</cfloop>
		<cf_report_list>	
			<thead>
				<tr>
					<th nowrap><cf_get_lang dictionary_id='57487.No'></th>
					<th nowrap width="160px"><cf_get_lang dictionary_id='58015.Projeler'></th>
					<th nowrap><cf_get_lang dictionary_id='64905.Küm.'> <cf_get_lang dictionary_id='39553.Kar'>/<cf_get_lang dictionary_id='39554.Zarar'></th>
					<th nowrap><cf_get_lang dictionary_id='58474.Birim'></th>
					<th nowrap><cf_get_lang dictionary_id='39543.Verilen Hakedisler'>(+)</th>
					<th class="text-center" nowrap><cf_get_lang dictionary_id='58474.Birim'></th>
					<th nowrap><cf_get_lang dictionary_id='39544.Verilen Hizmetler'>(+)</th>
					<th class="text-center" nowrap><cf_get_lang dictionary_id='58474.Birim'></th>
					<th nowrap><cf_get_lang dictionary_id='39545.Satışlar'>(+)</th>
					<th class="text-center" nowrap><cf_get_lang dictionary_id='58474.Birim'></th>
					<th nowrap><cf_get_lang dictionary_id='58089.Gelirler'>(+)</th>
					<th class="text-center" nowrap><cf_get_lang dictionary_id='58474.Birim'></th>
					<th nowrap><cf_get_lang dictionary_id='39546.Alinan Hakedisler'>(-)</th>
					<th class="text-center" nowrap><cf_get_lang dictionary_id='58474.Birim'></th>
					<th nowrap><cf_get_lang dictionary_id='39547.Alinan Hizmetler'>(-)</th>
					<th class="text-center" nowrap><cf_get_lang dictionary_id='58474.Birim'></th>
					<th nowrap><cf_get_lang dictionary_id='39548.Is Gücü Maliyetleri'>(-)</th>
					<th class="text-center" nowrap><cf_get_lang dictionary_id='58474.Birim'></th>
					<cfif isdefined("is_cost_of_material") and is_cost_of_material eq 1><!--- xmlde Malzeme Maliyetini Goster evet ise --->
						<th nowrap><cf_get_lang dictionary_id='39549.Malzeme Maliyetleri'>(-)</th>
						<th class="text-center" nowrap><cf_get_lang dictionary_id='58474.Birim'></th>
					</cfif>
					<cfif isdefined("is_cost_of_product_sold") and is_cost_of_product_sold eq 1><!--- xmlde Satılan Malin Maliyetini Goster evet ise --->
						<th nowrap><cf_get_lang dictionary_id='39550.Satilan Malin Maliyeti'>(-)</th>
						<th class="text-center" nowrap><cf_get_lang dictionary_id='58474.Birim'></th>
					</cfif>
				
						<th nowrap><cf_get_lang dictionary_id ='38770.Alımlar'>(-)</th>
						<th class="text-center" nowrap><cf_get_lang dictionary_id='58474.Birim'></th>
					
					<th nowrap><cf_get_lang dictionary_id='39551.Masraflar'>(-)</th>
					<th class="text-center" nowrap><cf_get_lang dictionary_id='58474.Birim'></th>
					<th nowrap><cf_get_lang dictionary_id='40691.Bakımlar'>(-)</th>
					<th class="text-center" nowrap><cf_get_lang dictionary_id='58474.Birim'></th>
					<cfif isdefined("xml_show_general_expense_effect") and xml_show_general_expense_effect eq 1><!--- Genel Gider Yansimalari Gelmesin / Kar Zarar Hesabina Katilmasin --->
						<th nowrap><cf_get_lang dictionary_id='39552.Genel Gider Yansimasi'>(-)</th>
						<th class="text-center" nowrap><cf_get_lang dictionary_id='58474.Birim'></th>
					</cfif>
				</tr>
			</thead>
        	<tbody>
				<cfset sayac=attributes.startrow>
				<cfset counter = 0>
				<cfset toplam_verilen_hakedisler = 0>
				<cfset toplam_verilen_hizmetler = 0>
				<cfset toplam_satislar = 0>
				<cfset toplam_gelirler = 0>
				<cfset toplam_alinan_hakedisler = 0>
				<cfset toplam_alinan_hizmetler = 0>
				<cfset toplam_isgucu_maliyetleri = 0>
				<cfset toplam_malzeme_maliyetleri = 0>
				<cfset toplam_satilan_malin_maliyeti = 0>
				<cfset toplam_alimlar = 0>
				<cfset toplam_masraflar = 0>
				<cfset toplam_bakimlar = 0>
				<cfset toplam_genel_gider_yansimasi = 0>
				<cfset toplam_kar_zarar = 0>
				
				<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
					<cfset attributes.startrow=1>
					<cfset attributes.maxrows=GET_PROJECT_ALL_RECORDS.recordcount>
				</cfif>
				<cfloop list="#all_projects#" index="pp">
					 <cfset counter++>
					 <cfoutput>
					 <cfif isdefined('project_head_#pp#') and attributes.maxrows gte counter>
					 	<tr title="#evaluate('project_head_#pp#')#">
						<td>#sayac#</td>
						<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
							<td> #evaluate("project_head_#pp#")#</td>
						<cfelse>
							<td nowrap="nowrap"><a href="#request.self#?fuseaction=report.project_accounts_report&form_submit=1&project_id=#pp#&project_head=1" class="tableyazi">#(evaluate("project_head_#pp#"))#</a></td><!--- Projeler --->
						</cfif>
						<cfif isdefined("xml_show_general_expense_effect") and xml_show_general_expense_effect eq 1><!--- Genel Gider Yansimalari Gelmesin / Kar Zarar Hesabina Katilmasin --->
							<cfif sarf_genel_toplam gt 0>
								<cfset toplam_kar_zarar = toplam_kar_zarar + evaluate("genel_kar_toplam_#pp#")-((evaluate("proje_maliyet_#pp#")*masraffisi_genel_toplam)/sarf_genel_toplam)>
							<cfelse>
								<cfset toplam_kar_zarar = toplam_kar_zarar + evaluate("genel_kar_toplam_#pp#")>
							</cfif>
						<cfelse>
							<cfset toplam_kar_zarar = toplam_kar_zarar + evaluate("genel_kar_toplam_#pp#")>
						</cfif>
						<td nowrap="nowrap" class="text-right">#Tlformat(toplam_kar_zarar,2)#</td>
						<td>#session.ep.money#</td>
						<td nowrap="nowrap" class="text-right">#Tlformat(evaluate("T1_P#pp#"),2)#<cfset toplam_verilen_hakedisler = toplam_verilen_hakedisler + evaluate("T1_P#pp#")></td><!--- Verilen Hakedisler (+)--->
						<td>#session.ep.money#</td>
						<td nowrap="nowrap" class="text-right">#Tlformat(evaluate("T5_P#pp#"),2)#<cfset toplam_verilen_hizmetler = toplam_verilen_hizmetler + evaluate("T5_P#pp#")></td><!--- Verilen Hizmetler(+) --->
						<td>#session.ep.money#</td>
						<td nowrap="nowrap" class="text-right">#Tlformat(evaluate("T7_P#pp#"),2)#<cfset toplam_satislar = toplam_satislar + evaluate("T7_P#pp#")></td><!--- Satislar(+) --->
						<td>#session.ep.money#</td>
						<td nowrap="nowrap" class="text-right">#Tlformat(evaluate("T12_P#pp#"),2)#<cfset toplam_gelirler = toplam_gelirler + evaluate("T12_P#pp#")></td><!--- Gelirler(+) --->
						<td>#session.ep.money#</td>
						<td nowrap="nowrap" class="text-right">#Tlformat(evaluate("T11_P#pp#"),2)#<cfset toplam_alinan_hakedisler = toplam_alinan_hakedisler + evaluate("T11_P#pp#")></td><!--- Alinan Hakedisler(-) --->
						<td>#session.ep.money#</td>
						<td nowrap="nowrap" class="text-right">#Tlformat(evaluate("T6_P#pp#"),2)#<cfset toplam_alinan_hizmetler = toplam_alinan_hizmetler + evaluate("T6_P#pp#")></td><!--- Alinan Hizmetler(-) --->
						<td>#session.ep.money#</td>
						<td nowrap="nowrap" class="text-right">#Tlformat(evaluate("T3_P#pp#"),2)#<cfset toplam_isgucu_maliyetleri = toplam_isgucu_maliyetleri + evaluate("T3_P#pp#")></td><!--- Is Gücü Maliyetleri(-) --->
						<td>#session.ep.money#</td>
						<cfif isdefined("is_cost_of_material") and is_cost_of_material eq 1><!--- xmlde Malzeme Maliyetini Goster evet ise --->
							<td nowrap="nowrap" class="text-right">#Tlformat(evaluate("T4_P#pp#"),2)#<cfset toplam_malzeme_maliyetleri = toplam_malzeme_maliyetleri + evaluate("T4_P#pp#")></td><!--- Malzeme Maliyetleri(-) --->
							<td>#session.ep.money#</td>
						</cfif>
						<cfif isdefined("is_cost_of_product_sold") and is_cost_of_product_sold eq 1><!--- xmlde Satılan Malin Maliyetini Goster evet ise --->
							<td nowrap="nowrap" class="text-right">#Tlformat(evaluate("T8_P#pp#"),2)#<cfset toplam_satilan_malin_maliyeti = toplam_satilan_malin_maliyeti + evaluate("T8_P#pp#")></td><!--- Satilan Malin Maliyeti(-) --->
							<td>#session.ep.money#</td>
						</cfif>						
						<td nowrap="nowrap" class="text-right">#Tlformat(evaluate("T13_P#pp#"),2)#<cfset toplam_alimlar = toplam_alimlar + evaluate("T13_P#pp#")></td><!--- Satilan Malin Maliyeti(-) --->
						<td>#session.ep.money#</td>						
						<td nowrap="nowrap" class="text-right">#Tlformat(evaluate("T2_P#pp#"),2)#<cfset toplam_masraflar = toplam_masraflar + evaluate("T2_P#pp#")></td><!--- Masraflar(-) --->
						<td>#session.ep.money#</td>
						<td nowrap="nowrap" class="text-right">#Tlformat(evaluate("T14_P#pp#"),2)#<cfset toplam_bakimlar = toplam_bakimlar + evaluate("T14_P#pp#")></td><!--- Bakimlar(-) --->
						<td>#session.ep.money#</td>
						<cfif isdefined("xml_show_general_expense_effect") and xml_show_general_expense_effect eq 1><!--- Genel Gider Yansimalari Gelmesin / Kar Zarar Hesabina Katilmasin --->
							<td nowrap="nowrap" class="text-right">
								<cfif sarf_genel_toplam gt 0>
									#Tlformat(((evaluate("proje_maliyet_#pp#")*masraffisi_genel_toplam)/sarf_genel_toplam),2)#
									<cfset toplam_genel_gider_yansimasi = toplam_genel_gider_yansimasi + ((evaluate("proje_maliyet_#pp#")*masraffisi_genel_toplam)/sarf_genel_toplam)>
								<cfelse>
									#TLFormat(0,2)#
								</cfif>
							</td>
							<td>#session.ep.money#</td>
						</cfif>
						</tr>	
					 </cfif>
					</cfoutput>
					<cfset sayac=sayac+1>
				</cfloop>
				<cfset toplu_hakedis = toplam_verilen_hakedisler + toplam_verilen_hizmetler + toplam_satislar + toplam_gelirler>
				<cfset toplu_maliyet = toplam_alinan_hakedisler + toplam_alinan_hizmetler + toplam_isgucu_maliyetleri + toplam_malzeme_maliyetleri + toplam_satilan_malin_maliyeti + toplam_masraflar + toplam_bakimlar + toplam_genel_gider_yansimasi>
				<cfset toplu_genel_kar_zarar = toplu_hakedis - toplu_maliyet>
				<cfoutput>
					<tr class="total">
						<td colspan="2" class="txtbold text-center"><cf_get_lang dictionary_id ='40035.Genel Toplamlar'></td>
						<td nowrap="nowrap" class="text-right">#Tlformat(toplam_kar_zarar,2)# </td>
						<td>#session.ep.money#</td>
						<td nowrap="nowrap" class="text-right">#Tlformat(toplam_verilen_hakedisler,2)#</td>
						<td>#session.ep.money#</td>
						<td nowrap="nowrap" class="text-right">#Tlformat(toplam_verilen_hizmetler,2)#</td>
						<td>#session.ep.money#</td>
						<td nowrap="nowrap" class="text-right">#Tlformat(toplam_satislar,2)#</td>
						<td>#session.ep.money#</td>
						<td nowrap="nowrap" class="text-right">#Tlformat(toplam_gelirler,2)#</td>
						<td>#session.ep.money#</td>
						<td nowrap="nowrap" class="text-right">#Tlformat(toplam_alinan_hakedisler,2)#</td>
						<td>#session.ep.money#</td>
						<td nowrap="nowrap" class="text-right">#Tlformat(toplam_alinan_hizmetler,2)# </td>
						<td>#session.ep.money#</td>
						<td nowrap="nowrap" class="text-right">#Tlformat(toplam_isgucu_maliyetleri,2)#</td>
						<td>#session.ep.money#</td>
						<cfif isdefined("is_cost_of_material") and is_cost_of_material eq 1><!--- xmlde Malzeme Maliyetini Goster evet ise --->
							<td nowrap="nowrap" class="text-right">#Tlformat(toplam_malzeme_maliyetleri,2)#</td>
							<td>#session.ep.money#</td>
						</cfif>
						<cfif isdefined("is_cost_of_product_sold") and is_cost_of_product_sold eq 1><!--- Satilan Malin Maliyetini Goster --->
							<td nowrap="nowrap" class="text-right">#Tlformat(toplam_satilan_malin_maliyeti,2)#</td>
							<td>#session.ep.money#</td>
						</cfif>						
						<td nowrap="nowrap" class="text-right">#Tlformat(toplam_alimlar,2)#</td>
						<td>#session.ep.money#</td>						
						<td nowrap="nowrap" class="text-right">#Tlformat(toplam_masraflar,2)#</td>
						<td>#session.ep.money#</td>
						<td nowrap="nowrap" class="text-right">#Tlformat(toplam_bakimlar,2)#</td>
						<td>#session.ep.money#</td>
						<cfif isdefined("xml_show_general_expense_effect") and xml_show_general_expense_effect eq 1><!--- Genel Gider Yansimalari Gelmesin / Kar Zarar Hesabina Katilmasin --->
							<td nowrap="nowrap" class="text-right">#Tlformat(toplam_genel_gider_yansimasi,2)#</td>
							<td>#session.ep.money#</td>
						</cfif>
					</tr>
				</cfoutput>				
			</tbody>			
			<tbody>
				<cfif len(all_projects)>
					<tbody>
						<tr>
							<td colspan="7">
								<script src="JS/Chart.min.js"></script>
								<canvas id="myChart2"></canvas>
								<script>
									var ctx2 = document.getElementById("myChart2");
									var myBarChart2 = new Chart(ctx2, {
										type: 'horizontalBar',
										data: {
											labels: ["<cf_get_lang dictionary_id='39553.Kar'>/<cf_get_lang dictionary_id='39554.Zarar'>","<cf_get_lang dictionary_id='58258.Maliyet'>","<cf_get_lang dictionary_id='39561.Toplam Satislar'>"],
											datasets: [{
												label: ["<cf_get_lang dictionary_id='39568.Proje Icmal Raporu'>"],
												data: [<cfoutput>#wrk_round(toplu_genel_kar_zarar,2)#</cfoutput>,<cfoutput>#wrk_round(toplu_maliyet,2)#</cfoutput>,<cfoutput>#wrk_round(toplu_hakedis,2)#</cfoutput>],
												backgroundColor: ['rgba(255, 99, 132, 0.2)','rgba(54, 162, 235, 0.2)','rgba(255, 206, 86, 0.2)'],
												borderColor: ['rgba(255,99,132,1)','rgba(54, 162, 235, 1)','rgba(255, 206, 86, 1)'],
												borderWidth: 1
											}]
										},
										options: {
											scales: {
												yAxes: [{
													ticks: {
														beginAtZero:true
													}
												}]
											}
										}
									});
								</script>
							</td>
						</tr>
					</tbody>
				</cfif>	
			</tbody>		
		</cf_report_list>
	</div>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset url_str = "">
			<cfif len(attributes.project_id)>
				<cfset url_str = "#url_str#&project_id=#attributes.project_id#">
			</cfif>
			<cfif len(attributes.project_head)>
				<cfset url_str = "#url_str#&project_head=#attributes.project_head#">
			</cfif>
			<cfif len(attributes.form_submit)>
				<cfset url_str = "#url_str#&form_submit=#attributes.form_submit#">
			</cfif>
			<cfif len(attributes.main_project_cat)>
				<cfset url_str = "#url_str#&main_project_cat=#attributes.main_project_cat#">
			</cfif>
			<cfif len(attributes.status)>
				<cfset url_str = "#url_str#&status=#attributes.status#">
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
</cfif>
<script type="text/javascript">
	function lower_project()
	{			
		if (document.search_form.project_id.value != "" && document.search_form.project_head.value != "")
			{
				goster(low_pro);
				gizle(CatID);
			}
			
		else
		{
			gizle(low_pro);
			document.search_form.lower_projects.checked = false;
			goster(CatID);
		}
		
	}
	function control()
	{	if(!date_check(search_form.start_date,search_form.finish_date,"<cf_get_lang dictionary_id ='40310.Başlama Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!")){
			return false;
		}
		if(document.search_form.is_excel.checked==false)
			{
				document.search_form.action="<cfoutput>#request.self#</cfoutput>?fuseaction=report.project_accounts_report"
				return true;
			}
		else
		{
			document.search_form.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_project_accounts_report</cfoutput>"
		}
		if (document.search_form.project_head.value == "") 
			document.search_form.project_id.value="";
		lower_project();
	}
</script>

