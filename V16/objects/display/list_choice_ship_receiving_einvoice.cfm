<!---
    File: list_choice_ship_receiving_einvoice.cfm
    Folder: V16\objects\display\
	Controller: 
    Author: Gramoni-Mahmut Çifçi mahmut.cifci@gramoni.com
    Date: 2020-01-03 12:34:24 
    Description:
        Gelen efatura detayından irsaliye çağırmak için kullanılır.
    History:
        
    To Do:

--->

<cfif not (isdefined("attributes.company_id") and len(attributes.company_id)) and not (isdefined("attributes.consumer_id") and len(attributes.consumer_id)) and not (isdefined("attributes.employee_id") and len(attributes.employee_id))>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id ='50081.Lütfen Cari Hesap Seçiniz'>!");
		window.close();
	</script>
	<cfabort> 
</cfif>

<cfsavecontent variable="head_text"><title><cf_get_lang dictionary_id='45523.Teslim Alınan İrsaliyeler'></title></cfsavecontent>
<cfhtmlhead text="#head_text#" />

<cfparam name="attributes.kalan" default="">
<cfparam name="attributes.invoice_date" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.is_kesilmis" default="0">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.invoice_total" default="" />
<cfparam name="attributes.invoice_money" default="" />

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
			DISTINCT
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
        	SHIP.PROJECT_ID PROJECT_ID,
			SHIP.DEPARTMENT_IN AS DELIVER_STORE_ID,
			SHIP.NETTOTAL,
			SHIP.GROSSTOTAL,
			SHIP.OTHER_MONEY,
			SHIP.OTHER_MONEY_VALUE
		FROM
			#dsn2_ship#.SHIP
			LEFT JOIN #dsn_alias#.COMPANY_BRANCH CB ON CB.COMPANY_ID = SHIP.COMPANY_ID AND CB.COMPBRANCH_ID = SHIP.SHIP_ADDRESS_ID
		WHERE
			SHIP.IS_SHIP_IPTAL = 0 AND 		
			SHIP.SHIP_STATUS = 1 AND
			 SHIP.IS_WITH_SHIP =0 AND <!---faturaların kendi olusturdugu irsaliyeler gelmesin --->
			SHIP.SHIP_TYPE NOT IN (80,81,811,82,83,761) <!--- demirbas,hal ,depolararasi sevk irs ve ithal mal girisi gelmesin --->
		AND (SHIP.SHIP_ID NOT IN(select SHIP_ID from SHIP WHERE SHIP_ID IN(SELECT ROW_ORDER_ID FROM SHIP_ROW) AND PROCESS_CAT = 56))
		<cfif isdefined("islem_tipi_kontrol") and len(islem_tipi_kontrol)>
			AND SHIP.SHIP_TYPE IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#islem_tipi_kontrol#" list="yes">)
		</cfif>
		<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
			AND SHIP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
		<cfelseif  isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
			AND SHIP.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
        <cfelseif  isdefined("attributes.employee_id") and len(attributes.employee_id)>
			AND SHIP.EMPLOYEE_ID = <cfif attributes.employee_id contains '_'>#ListGetAt(attributes.employee_id,1,'_')#<cfelse>#attributes.employee_id#</cfif>
		</cfif>
		AND SHIP.PURCHASE_SALES = 0
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
			AND SHIP.DELIVER_STORE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">	
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
<cfif isdefined("attributes.invoice_total")>
	<cfset url_str = "#url_str#&invoice_total=#attributes.invoice_total#" />
</cfif>
<cfif isdefined("attributes.invoice_money")>
	<cfset url_str = "#url_str#&invoice_money=#attributes.invoice_money#" />
</cfif>

<cfparam name="attributes.keyword" default='' />
<cfparam name="attributes.cat" default='' />
<cfparam name="attributes.page" default=1 />
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#' />
<cfparam name="attributes.totalrecords" default="#get_ship.recordcount#" />
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1 />
<cfsavecontent variable="header_"><cf_get_lang dictionary_id ='34090.İrsaliyeler'></cfsavecontent>
<cf_big_list_search title="#header_#">
	<cfform name="get_ship" action="#request.self#?fuseaction=objects.popup_list_choice_ship_receiving_einvoice&#url_str#" method="post">
		<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
		<input type="hidden" name="invoice_date" id="invoice_date" value="<cfoutput>#attributes.invoice_date#</cfoutput>">
		<cf_big_list_search_area>
			<div class="row">    
				<div class="col col-12 form-inline">
					<div class="form-group" id="item-keyword">
						<div class="input-group x-14">
							<cfinput type="text" name="keyword" style="width:80px;" value="#attributes.keyword#" placeholder="#getLang('main',48)#" maxlength="255" />
						</div>
					</div>
					<div class="form-group" id="item-start_date">
						<div class="input-group x-11">
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
						<div class="input-group x-11">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'>!</cfsavecontent>
							<cfinput type="text" name="finish_date" maxlength="10" value="#DateFormat(attributes.finish_date,dateformat_style)#" style="width:64px;" validate="#validate_style#" message="#message#">
							<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
						</div>
					</div>
					<div class="form-group" id="item-project_id">
						<div class="input-group x-12">		
							<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.project_id') and len(attributes.project_id) and len(attributes.project_head)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57416.Proje'></cfsavecontent>
							<input name="project_head" type="text" id="project_head" placeholder="<cfoutput>#message#</cfoutput>" style="width:80px;" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');"  value="<cfif len(attributes.project_id) and len(attributes.project_head)><cfoutput>#GET_PROJECT_NAME(attributes.project_id)#</cfoutput></cfif>" autocomplete="off" >  
							<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=get_ship.project_id&project_head=get_ship.project_head');"></span>                   
						</div>
					</div>
					<div class="form-group x-3_5">	
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" style="width:25px;" value="#attributes.maxrows#" validate="integer" range="1,250" message="#message#">
					</div>
					<div class="form-group">	
						<cf_wrk_search_button search_function='control_period()'>
					</div>
				</div>
			</div>
		</cf_big_list_search_area>
		<cf_big_list_search_detail_area>
			<div class="row">    
				<div class="col col-12 form-inline">
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
						<div class="input-group x-22">			
							<select name="department_id" id="department_id" style="width:150px;">
								<option selected value="0"><cf_get_lang dictionary_id ='57734.Seçiniz'>
								<cfoutput query="stores"><option value="#department_id#"<cfif isdefined('attributes.department_id') and (attributes.department_id eq STORES.department_id)>Selected</cfif>>#department_head#</cfoutput> 
							</select>
							<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined('attributes.company_id')><cfoutput>#attributes.company_id#</cfoutput></cfif>">
							<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined('attributes.consumer_id')><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
							<input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined('attributes.employee_id')><cfoutput>#attributes.employee_id#</cfoutput></cfif>">		
						</div>
					</div>	
					<div class="form-group" id="item-cat">
						<div class="input-group x-22">
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
					</div>	
					<div class="form-group" id="item-is_kesilmis">
						<div class="input-group x-8">
							<select name="is_kesilmis" id="is_kesilmis">
								<option value="0" <cfif attributes.is_kesilmis eq 0>selected</cfif>><cf_get_lang dictionary_id ='34091.Kesilmemiş'>
								<option value="1" <cfif attributes.is_kesilmis eq 1>selected</cfif>><cf_get_lang dictionary_id ='34092.Kesilmiş'>
								<option value="2" <cfif attributes.is_kesilmis eq 2>selected</cfif>><cf_get_lang dictionary_id ='58081.Hepsi'>
							</select>
						</div>
					</div>	
					<div class="form-group" id="item-ship_period">
						<div class="input-group x-6">
							<select name="ship_period" id="ship_period">
							<cfoutput query="get_period_list">
								<option value="#period_id#;#period_year#" <cfif listfirst(attributes.ship_period,';') eq period_id>selected</cfif>>#period_year#</option>
							</cfoutput>
							</select>
						</div>
					</div>
				</div>
			</div>
		</cf_big_list_search_detail_area>
	</cfform>
</cf_big_list_search>
<cfparam name="attributes.department_id" default="0" />
<cfset url_str="#url_str#&cat=#attributes.cat#&department_id=#attributes.department_id#&ship_period=#attributes.ship_period#" />
<cfif len(attributes.invoice_date)>
	<cfset url_str = "#url_str#&invoice_date=#attributes.invoice_date#" />
</cfif>
<cfif isdefined('attributes.company_id') and len(attributes.company_id)>
	<cfset url_str = "#url_str#&company_id=#attributes.company_id#" />
</cfif>
<cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
	<cfset url_str = "#url_str#&consumer_id=#attributes.consumer_id#" />
</cfif>
<cfif isdefined('attributes.employee_id') and len(attributes.employee_id)>
	<cfset url_str = "#url_str#&employee_id=#attributes.employee_id#" />
</cfif>
<cfif isdefined('attributes.start_date') and len(attributes.start_date)>
	<cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#" />
</cfif>
<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
	<cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#" />
</cfif>
<cfif isdefined('attributes.id')>
	<cfset url_str = "#url_str#&id=#attributes.id#" />
</cfif>
<cfif isdefined('attributes.is_kesilmis')>
	<cfset url_str = "#url_str#&is_kesilmis=#attributes.is_kesilmis#" />
</cfif>
<cfif isdefined('attributes.project_id') and len(attributes.project_id) and isdefined('attributes.project_head') and len(attributes.project_head)>
	<cfset url_str = "#url_str#&project_id=#attributes.project_id#" />
</cfif>
<cfif isdefined('attributes.product_name') and len(attributes.product_name)>
	<cfset url_str = "#url_str#&product_name=#attributes.product_name#" />
</cfif>
<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#" />
</cfif>
<cfif isdefined("attributes.branch_id")>
	<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#" />
</cfif>
<cf_medium_list>
	<thead>
		<tr>
			<th width="80"><cf_get_lang dictionary_id ='58138.İrsaliye No'></th>
			<th width="85"><cf_get_lang dictionary_id ='33096.İrsaliye Tarihi'></th>
			<th><cf_get_lang dictionary_id ='57574.Şirket'></th>
			</th>
			<th class="form-title"><cf_get_lang dictionary_id='57416.Proje'></th>
			<th><cf_get_lang dictionary_id ='57800.İşlem tipi'></th>
			<th><cf_get_lang dictionary_id ='29534.Tutar'></th>
			<th>2. <cf_get_lang dictionary_id ='29534.Tutar'></th>
			<th><cf_get_lang dictionary_id ='58763.Depo'></th>
			<th width="120"><cf_get_lang dictionary_id ='58133.Fatura No'></th>	
		</tr>
	</thead>
	<tbody>
		<cfset url_action="#url_str#" />
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
			<cfset project_id_list=listsort(project_id_list,"numeric")>
			<cfif len(project_id_list)>
				<cfquery name="get_project_name" datasource="#dsn#">
					SELECT PROJECT_ID,PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_id_list#) ORDER BY PROJECT_ID
				</cfquery>
			</cfif>
			<cfset ship_id_list = listsort(ship_id_list,"numeric")>
			<cfif len(ship_id_list)>
				<cfquery name="GET_ALL_INVOICE_SHIPS" datasource="#dsn2_ship#">
					SELECT INVOICE_NUMBER,SHIP_ID FROM INVOICE_SHIPS  WHERE SHIP_PERIOD_ID = #listfirst(attributes.ship_period,';')# AND SHIP_ID IN (#ship_id_list#)
					<cfif GET_PERIOD_DSN.recordcount>
					UNION ALL SELECT INVOICE_NUMBER,SHIP_ID FROM #next_year_dsn2#.INVOICE_SHIPS  WHERE INVOICE_SHIPS.SHIP_PERIOD_ID = #listfirst(attributes.ship_period,';')# AND SHIP_ID IN (#ship_id_list#)</cfif>
				</cfquery>
			</cfif>
			<cfoutput query="get_ship" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
					<td>
					<cfif (isdefined("attributes.process_cat")) and (islem_tipi eq 71 or islem_tipi eq 76)><!--- alım iade irs. ve toptan satış iade irs. ise gönderiyoruz --->
						<cfset process_type_ = islem_tipi>
					<cfelse>
						<cfset process_type_ = ''>
					</cfif>
					<a href="javascript:void(0);" class="tableyazi" onClick="attachShipment('#SHIP_NUMBER#',#SHIP_ID#,'#GROSSTOTAL#','#OTHER_MONEY#');">#SHIP_NUMBER#</a></div>
					</td>
					<td>#dateformat(SHIP_DATE,dateformat_style)#</td>
					<cfif len(COMPANY_ID) or Len(Consumer_Id) or len(employee_id)>
						<td><cfif Len(company_id)>
								#get_all_companies.FULLNAME[listfind(company_id_list,COMPANY_ID)]#
							<cfelseif len(consumer_id)>
								#get_all_consumers.CONSUMER_NAME[listfind(consumer_id_list,CONSUMER_ID)]#&nbsp;#get_all_consumers.CONSUMER_SURNAME[listfind(consumer_id_list,CONSUMER_ID)]#
							<cfelseif len(employee_id)>
								#get_all_employees.EMPLOYEE_NAME[listfind(employee_id_list,EMPLOYEE_ID)]#&nbsp;#get_all_employees.EMPLOYEE_SURNAME[listfind(employee_id_list,EMPLOYEE_ID)]#
							</cfif>
						</td>
					</cfif>
					<td><cfif len(project_id_list)>#get_project_name.PROJECT_HEAD[listfind(project_id_list,PROJECT_ID)]#</cfif></td>
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
						<cfelseif SHIP_TYPE eq 141><cf_get_lang dictionary_id='29648.Servis Stok Çıkış Hareketi '>
						</cfif>
					</td>
					<td style="text-align:right;">#TLFormat(NETTOTAL)# #session.ep.money#</td>
					<td style="text-align:right;">#TLFormat(OTHER_MONEY_VALUE)# #OTHER_MONEY#</td>
					<td>#get_dept_name.DEPARTMENT_HEAD[listfind(dept_id_list,get_ship.DELIVER_STORE_ID,',')]#</td>
					<td>
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
					</td>
				</tr>
				<tr id="SHIP_ROW_LIST#currentrow#" style="display:none;" class="color-row">
					<td colspan="9">
						<div id="SHIP_ROW_LIST#currentrow#_"></div>
					</td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="13"><cfif isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
			</tr>
		</cfif>
	</tbody>
</cf_medium_list>
<cfif attributes.totalrecords gt attributes.maxrows>
	<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center" height="35">
		<tr> 
			<td><cf_pages 
					page="#attributes.page#" 
					maxrows="#attributes.maxrows#" 
					totalrecords="#attributes.totalrecords#" 
					startrow="#attributes.startrow#" 
					adres="objects.popup_list_choice_ship_receiving_einvoice&id=#attributes.id#&keyword=#attributes.keyword#&is_form_submitted=1#url_str#"> 
			</td> 
			<!-- sil -->
			<td  style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
			<!-- sil -->
		</tr>
	</table>
</cfif>

<script type="text/javascript">
	$('#keyword').select();
	var SessionMoney = "<cfoutput>#session.ep.money#</cfoutput>";

	function attachShipment(ship_no, ship_id, ship_amount, ship_money) {
		if( ship_money == '' || SessionMoney == ship_money ){
			if (ship_amount != <cfoutput>#attributes.invoice_total#</cfoutput>) {
				alert("<cf_get_lang dictionary_id='60080.Gelen e-Fatura tutarı ile seçmiş olduğunuz irsaliye net tutarları eşit değil'>!\n\n <cf_get_lang dictionary_id='60081.Gelen e-Fatura Net Tutarı'> <cfoutput>#attributes.invoice_total# #attributes.invoice_money#</cfoutput>\n" + ship_no + "<cf_get_lang dictionary_id='60082.Numaralı İrsaliye Net Tutarı'>:" + ship_amount +' ' + ship_money);
			}
		}
		window.opener.form_basket.ship_id.value = ship_id;
		window.opener.form_basket.ship_amount.value = ship_amount;
		window.opener.form_basket.ship_no.value = ship_no;
		window.close();
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
					alert("<cf_get_lang dictionary_id='34106.Faturaya Çekilecek İrsaliyelerin Dönemi Aynı Olmalıdır'>!");
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

	$(document).keydown(function(e){
        // ESCAPE key pressed
        if (e.keyCode == 27) {
            window.close();
        }
    });
</script>