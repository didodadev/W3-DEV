<cfif isDefined("attributes.action") and len(attributes.action)>
	<cfset pageDenied = false>
	<cfif not listFindNoCase('myhome',listFirst(attributes.action,'.'),',')>
		
		<cfset application.getDeniedPages = createObject("component", "WMO.getDeniedPages") />
		<cfset application.getDeniedPages.pageAuthority(
			datasource : '#dsn#',
			employee_id : '#session.ep.userid#',
			fuseaction : '#attributes.action#',
			position_code : '#session.ep.position_code#',
			wrkflow : 1,
			pathinfo : '#request.self#?fuseaction=#attributes.action##(isdefined("attributes.action_id") and len(attributes.action_id)) ? DE("&action_id=") & attributes.action_id : ""#'
		) />
		
		<cfif StructKeyExists(application.deniedPages,attributes.action)>
			<cfif application.deniedPages['#attributes.action#']['IS_VIEW'] eq 1>
				<cfset pageDenied = true>
			</cfif>
		</cfif>

		<cfset controlObjects = application.systemObjects.workObjects('#dsn#','#session.ep.userid#','#attributes.action#')>
		<cfif (not controlObjects.recordcount) and ((not StructKeyExists(application.deniedPages,attributes.action)) or (StructKeyExists(application.deniedPages,attributes.action) and application.deniedPages['#attributes.action#']['IS_VIEW'] eq 1))>
			<cfset pageDenied = true>
		</cfif>

	</cfif>
<cfelse>
	<script>openTab(2);</script>
	<cfabort>
</cfif>

<link rel="stylesheet" type="text/css" href="/css/assets/template/message.css">

<cffunction name="getEngLetterColor">
	<cfargument name="letter" required="yes">
	<!--- ReplaceListNoCase : CF11 de mevcut değil --->
	<cfreturn "color-#trim(ReplaceList(Ucase(arguments.letter),"Ç,Ğ,İ,Ö,Ş,Ü","C,G,I,O,S,U",true))#">
</cffunction>

<!--- modüllerin our_company_id veya period_id kaydedip etmeyeceği, burada yapılan değişiklikler myhome/query/add_warning.cfm sayfasında da uygulanmalı EÖ 20100710--->
<cfset use_period_module = 'finance,cash,bank,cheque,ch,cost,budget,account,defin,fintab,invent,pos,store,stock,account,invoice,contract,executive,worknet,salesplan,credit'>
<cfset use_company_module = 'production,prod,call,sales,purchase,service,campaign,finance,cash,bank,cheque,ch,cost,budget,account,defin,fintab,invent,pos,store,stock,account,invoice,contract,executive,worknet,salesplan,credit'>

<cfset url_link = attributes.action>
<cfset url_modul = ( len( url_link ) ) ? ListFirst(Right(url_link,len(url_link)-find('action=',url_link)),'.') : ''>
<cfset upload_folder = application.systemParam.systemParam().upload_folder>

<!---- Vekalet edilen kullanıcılar için kontrol uygulanır! ---->
<cfset newPositionCode = ( isDefined("attributes.position_code") and len(attributes.position_code) ) ? attributes.position_code : session.ep.position_code>
<!---- İşlemi yapan kişinin position_id değeri alınır ---->
<cfquery name="GET_POS_ID" datasource="#DSN#">
    SELECT POSITION_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = #session.ep.position_code#
</cfquery>
<cfset extertalWoList = attributes.action>
<cfif isdefined('attributes.action_id') and len(attributes.action_id) and attributes.action neq 'purchase.list_purchasedemand'>
	<cfquery name="getExternalWo" datasource="#dsn#">
		SELECT EXTERNAL_FUSEACTION FROM WRK_OBJECTS WHERE FULL_FUSEACTION = <cfqueryparam value="#attributes.action#" cfsqltype="cf_sql_nvarchar">
	</cfquery>
	<cfif getExternalWo.recordCount and len(getExternalWo.EXTERNAL_FUSEACTION)>  <!---EXTERNAL_FUSEACTION değeri null ise hataya düşüyordu, kontrol eklendi  --->
		<cfset extertalWoList = listAppend(extertalWoList,#getExternalWo.EXTERNAL_FUSEACTION#)>
	</cfif>
<cfelse>
	<cfset getExternalWo.recordCount = 0 />
</cfif>

<cfquery name="GET_WARNINGS" datasource="#DSN#">
	SELECT
		PW.WARNING_HEAD,
		PW.SETUP_WARNING_ID,
		PW.WARNING_DESCRIPTION,
		PW.ACTION_ID,
		PW.URL_LINK,
		convert(varchar, PW.RECORD_DATE, 101) AS RECORD_DATE,
		convert(varchar, PW.LAST_RESPONSE_DATE, 101) AS LAST_RESPONSE_DATE,
		PW.CONFIRM_RESULT,
		PW.IS_AGAIN,
		PW.IS_SUPPORT,
		PW.IS_CANCEL,
		PW.IS_REFUSE,
		PW.IS_CONFIRM,
		0 AS TYPE,
		ISNULL(PW.COMMENT_REQUEST,0) AS COMMENT_REQUEST,
		PW.ACTION_TABLE,
		PW.ACTION_COLUMN,
		PW.ACTION_STAGE_ID,
		PW.IS_MANUEL_NOTIFICATION,
		PW.ACCESS_CODE AS WSR_CODE,
		PTR.LINE_NUMBER,
		PTR.STAGE,
		MAX(W_ID) AS WARNING_ID,
		MAX(PARENT_ID) AS PARENT_ID,
		ISNULL(CAST(MAX(CAST(PT.IS_STAGE_MANUEL_CHANGE AS INT)) AS BIT),0) AS IS_STAGE_MANUEL_CHANGE,
		MAX(PT.PROCESS_ID) AS PROCESS_ID,
		GP.GENERAL_PAPER_ID,
		GP.ACTION_LIST_ID,
		PW.OUR_COMPANY_ID
	FROM 
		PAGE_WARNINGS AS PW
		LEFT JOIN PROCESS_TYPE_ROWS AS PTR ON PW.ACTION_STAGE_ID = PTR.PROCESS_ROW_ID
		LEFT JOIN PROCESS_TYPE AS PT ON PTR.PROCESS_ID = PT.PROCESS_ID
		LEFT JOIN GENERAL_PAPER AS GP ON PW.GENERAL_PAPER_ID = GP.GENERAL_PAPER_ID
	WHERE	
		PW.IS_PARENT=1 
		<cfif find('.upd_internaldemand',url_link) or find('.upd_purchasedemand',url_link)>
			AND (
				<cfif find('myhome.',url_link)>
					PW.URL_LINK  LIKE '#request.self#?fuseaction=#Replace(url_link,'myhome','correspondence')#' OR PW.URL_LINK LIKE '#request.self#?fuseaction=#Replace(url_link,'myhome','correspondence')#&%' OR
					PW.URL_LINK  LIKE '#request.self#?fuseaction=#Replace(url_link,'myhome','purchase')#' OR PW.URL_LINK LIKE '#request.self#?fuseaction=#Replace(url_link,'myhome','purchase')#&%' OR
				<cfelseif find('correspondence.',url_link)>
					PW.URL_LINK  LIKE '#request.self#?fuseaction=#Replace(url_link,'correspondence','myhome')#' OR PW.URL_LINK LIKE '#request.self#?fuseaction=#Replace(url_link,'correspondence','myhome')#&%' OR
					PW.URL_LINK  LIKE '#request.self#?fuseaction=#Replace(url_link,'correspondence','purchase')#' OR PW.URL_LINK LIKE '#request.self#?fuseaction=#Replace(url_link,'correspondence','purchase')#&%' OR
				<cfelseif find('purchase.',url_link)>
					PW.URL_LINK  LIKE '#request.self#?fuseaction=#Replace(url_link,'purchase','correspondence')#' OR PW.URL_LINK LIKE '#request.self#?fuseaction=#Replace(url_link,'purchase','correspondence')#&%' OR
					PW.URL_LINK  LIKE '#request.self#?fuseaction=#Replace(url_link,'purchase','myhome')#' OR PW.URL_LINK LIKE '#request.self#?fuseaction=#Replace(url_link,'purchase','myhome')#&%' OR
				</cfif>
				PW.URL_LINK LIKE '#request.self#?fuseaction=#url_link#' OR PW.URL_LINK LIKE '#request.self#?fuseaction=#url_link#&%'
				)
		<cfelseif listLen(extertalWoList) and not isdefined("attributes.is_content") and not isdefined("attributes.is_payment")>
			AND 
			(
				<cfset i = 1>
				<cfloop list="#extertalWoList#" index="value">
					PW.URL_LINK LIKE '%#value#%' <cfif listLen( extertalWoList ) neq i> OR </cfif>
					<cfset i++>
				</cfloop>
			)
		</cfif>
		<cfif isdefined("attributes.is_content")><!--- FB 20071008 literaturdeki dokuman taleplerinin de icerikte goruntulenmesi icin is_content add_optionstan gelecek --->
			AND (	PW.URL_LINK  LIKE '#request.self#?fuseaction=#url_link#' OR PW.URL_LINK  LIKE '#request.self#?fuseaction=#url_link#&%' OR
					PW.URL_LINK LIKE '#request.self#?fuseaction=rule.dsp_rule&cntid=#url.action_id#')
			AND IS_CONTENT = 1
		</cfif>
		<cfif isdefined("attributes.is_payment")><!--- FB 20071008 literaturdeki dokuman taleplerinin de icerikte goruntulenmesi icin is_content add_optionstan gelecek --->
			AND 
			(	
				PW.URL_LINK  LIKE '#request.self#?fuseaction=#url_link#' OR PW.URL_LINK  LIKE '#request.self#?fuseaction=#url_link#&%' OR
				PW.URL_LINK LIKE '#request.self#?fuseaction=correspondence.upd_payment_actions&closed_id=#url.action_id#&%'
			)
		</cfif>
		<cfif listfind(use_company_module,url_modul,',')>
			AND PW.OUR_COMPANY_ID = #session.ep.company_id#
		</cfif>
		<cfif listfind(use_period_module,url_modul,',')>
			AND PW.PERIOD_ID = #session.ep.period_id#
		</cfif>
		<cfif isdefined('attributes.action_id') and len(attributes.action_id)>
			AND
			(
				PW.ACTION_ID = <cfqueryparam value = "#attributes.action_id#" CFSQLType = "cf_sql_integer">
				OR
				<cfqueryparam value = "#attributes.action_id#" CFSQLType = "cf_sql_integer"> IN(SELECT * FROM #dsn#.fnSplit((SELECT TOP 1 ACTION_LIST_ID FROM #dsn#.GENERAL_PAPER WHERE GENERAL_PAPER_ID = PW.GENERAL_PAPER_ID), ','))
			)
		<cfelseif IsDefined("attributes.parent_id") and len(attributes.parent_id)>
			AND PARENT_ID = <cfqueryparam value = "#attributes.parent_id#" CFSQLType = "cf_sql_integer">
		</cfif>
		<cfif isdefined('attributes.gp_id') and len(attributes.gp_id)>
			AND 
			(
				GP.GENERAL_PAPER_ID = <cfqueryparam value = "#attributes.gp_id#" CFSQLType = "cf_sql_integer">
				OR
				GP.GENERAL_PAPER_PARENT_ID = <cfqueryparam value = "#attributes.gp_id#" CFSQLType = "cf_sql_integer">
			)
		</cfif>
	GROUP BY 
		PW.WARNING_HEAD,
		PW.SETUP_WARNING_ID,
		PW.WARNING_DESCRIPTION,
		PW.URL_LINK,
		PW.ACTION_ID,
		convert(varchar, PW.RECORD_DATE, 101),
		convert(varchar, PW.LAST_RESPONSE_DATE, 101),
		PW.CONFIRM_RESULT,
		PW.IS_AGAIN,
		PW.IS_SUPPORT,
		PW.IS_CANCEL,
		PW.IS_REFUSE,
		PW.IS_CONFIRM,
		PW.ACTION_TABLE,
		PW.ACTION_COLUMN,
		PW.ACTION_STAGE_ID,
		PW.IS_MANUEL_NOTIFICATION,
		PW.ACCESS_CODE,
		PTR.LINE_NUMBER,
		PTR.STAGE,
		GP.GENERAL_PAPER_ID,
		GP.ACTION_LIST_ID,
		PW.COMMENT_REQUEST,
		PW.OUR_COMPANY_ID
	ORDER BY 
		WARNING_ID ASC
</cfquery>

<cfif get_warnings.recordcount>
	<cfset position_list = employee_list = partner_list = consumer_list = period_list = company_list = sender_position_list = to_pos_code = allStage = "">

	<cfquery name="GET_ALL_WARNINGS" datasource="#dsn#">
		SELECT POSITION_CODE, SENDER_POSITION_CODE, RECORD_EMP, RECORD_PAR, RECORD_CON, PERIOD_ID, OUR_COMPANY_ID, ACTION_STAGE_ID 
		FROM PAGE_WARNINGS 
		WHERE 
			1 = 1
			<cfif isdefined('attributes.action_id') and len(attributes.action_id)>
				AND ACTION_TABLE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#get_warnings.ACTION_TABLE#">
				AND(
					ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_warnings.ACTION_ID#">
					OR
					<cfqueryparam value = "#attributes.action_id#" CFSQLType = "cf_sql_integer"> IN(SELECT * FROM #dsn#.fnSplit((SELECT TOP 1 ACTION_LIST_ID FROM #dsn#.GENERAL_PAPER WHERE GENERAL_PAPER_ID = PAGE_WARNINGS.GENERAL_PAPER_ID), ','))
				)
			<cfelse>
				AND URL_LINK LIKE '%#extertalWoList#%'
				AND PARENT_ID = <cfqueryparam value = "#attributes.parent_id#" CFSQLType = "cf_sql_integer">
			</cfif>
			<cfif listfind(use_company_module,url_modul,',')>
			AND OUR_COMPANY_ID = #session.ep.company_id#
			</cfif>
			<cfif listfind(use_period_module,url_modul,',')>
			AND PERIOD_ID = #session.ep.period_id#
			</cfif>
		GROUP BY POSITION_CODE, SENDER_POSITION_CODE, RECORD_EMP, RECORD_PAR, RECORD_CON, PERIOD_ID, OUR_COMPANY_ID, ACTION_STAGE_ID
		ORDER BY CASE POSITION_CODE
		WHEN #newPositionCode# THEN 1
		ELSE 2 END
	</cfquery>

	<cfoutput query="GET_ALL_WARNINGS">

		<cfif len(position_code) and not listfind(position_list,position_code)>
			<cfset position_list=listappend(position_list,position_code)>
			<cfif not listfind(to_pos_code,position_code) and position_code neq newPositionCode>
				<cfset to_pos_code=listappend(to_pos_code,position_code)>
			</cfif>
		</cfif>
		<cfif len(record_emp) and not listfind(employee_list,record_emp)>
			<cfset employee_list=listappend(employee_list,record_emp)>
		</cfif>
		<cfif len(record_par) and not listfind(partner_list,record_par)>
			<cfset partner_list=listappend(partner_list,record_par)>
		</cfif>
		<cfif len(record_con) and not listfind(consumer_list,record_con)>
			<cfset consumer_list=listappend(consumer_list,record_con)>
		</cfif>
		<cfif len(period_id) and not listfind(period_list,period_id)>
			<cfset period_list=listappend(period_list,period_id)>
		</cfif>
		<cfif len(our_company_id) and not listfind(company_list,our_company_id)>
			<cfset company_list=listappend(company_list,our_company_id)>
		</cfif>
		<cfif len(sender_position_code) and not listfind(sender_position_list,sender_position_code)>
			<cfset sender_position_list=listappend(sender_position_list,sender_position_code)>
			<cfif not listfind(to_pos_code,sender_position_code) and sender_position_code neq newPositionCode>
				<cfset to_pos_code=listappend(to_pos_code,sender_position_code)>
			</cfif>
		</cfif>
		<cfif isdefined('attributes.action_id') and len(attributes.action_id) and len(ACTION_STAGE_ID) and not listfind(allStage,ACTION_STAGE_ID)>
			<cfset allStage = listappend(allStage, ACTION_STAGE_ID)>
		</cfif>

	</cfoutput>

	<!--- Admin kullanıcılar hariç, myhome modülünde sadece süreçte olanlar görüntüleme yapabilir! --->
	<cfif session.ep.admin neq 1 and pageDenied>
		<cfif listContains(position_list, newPositionCode) eq 0 and listContains(sender_position_list, newPositionCode) eq 0>
			<script>
				alert("<cf_get_lang dictionary_id='60109.Bu modülün süreç akışını görüntülemeye yetkiniz yok'>!");
				openTab(2);
			</script>
			<cfabort>
		</cfif>
	</cfif>

	<!--- Süreç Aşamalarından print şablonunu getir --->
	<cfif len( allStage )>
		<cfquery name = "GET_PRINT_TAMPLATE" datasource = "#DSN#">
			SELECT
				PTR.TEMPLATE_PRINT_ID,
				SPF.TEMPLATE_FILE,
				SPF.NAME,
				SPF.IS_STANDART
			FROM
				PROCESS_TYPE_ROWS PTR
				LEFT JOIN #DSN3#.SETUP_PRINT_FILES SPF ON PTR.TEMPLATE_PRINT_ID = SPF.FORM_ID
			WHERE
				PTR.PROCESS_ROW_ID IN (#allStage#)
				AND PTR.TEMPLATE_PRINT_ID IS NOT NULL
		</cfquery>
	<cfelse>
		<cfset GET_PRINT_TAMPLATE.recordCount = 0>
	</cfif>

	<cfif len(position_list)>
		<cfset position_list=listsort(position_list,"numeric","ASC",",")>
		<cfquery name="get_positions" datasource="#dsn#">
			SELECT EP.EMPLOYEE_NAME, EP.EMPLOYEE_SURNAME, E.PHOTO, E.EMPLOYEE_ID FROM EMPLOYEE_POSITIONS AS EP JOIN EMPLOYEES AS E ON EP.EMPLOYEE_ID = E.EMPLOYEE_ID WHERE POSITION_CODE IN (#position_list#) ORDER BY POSITION_CODE
		</cfquery>
	</cfif>
	<cfif len(employee_list)>
		<cfset employee_list=listsort(employee_list,"numeric","ASC",",")>
		<cfquery name="get_employees" datasource="#dsn#">
			SELECT EMPLOYEE_ID, EMPLOYEE_NAME, EMPLOYEE_SURNAME, PHOTO FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_list#) ORDER BY EMPLOYEE_ID
		</cfquery>
	</cfif>
	<cfif len(partner_list)>
		<cfset partner_list=listsort(partner_list,"numeric","ASC",",")>
		<cfquery name="GET_PARTNERS" datasource="#DSN#">
			SELECT PARTNER_ID, COMPANY_PARTNER_NAME, COMPANY_PARTNER_SURNAME, PHOTO FROM COMPANY_PARTNER WHERE PARTNER_ID IN (#partner_list#) ORDER BY PARTNER_ID
		</cfquery>
	</cfif>
	<cfif len(consumer_list)>
		<cfset consumer_list=listsort(consumer_list,"numeric","ASC",",")>
		<cfquery name="GET_CONSUMERS" datasource="#DSN#">
			SELECT CONSUMER_ID, CONSUMER_NAME, CONSUMER_SURNAME, PICTURE FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_list#) ORDER BY CONSUMER_ID
		</cfquery>
	</cfif>
	<cfif len(period_list)>
		<cfquery name="get_period" datasource="#dsn#">
			SELECT PERIOD_ID, PERIOD, PERIOD_YEAR, OUR_COMPANY_ID FROM SETUP_PERIOD WHERE PERIOD_ID IN (#period_list#) ORDER BY PERIOD_ID
		</cfquery>
		<cfset period_list = listsort(listdeleteduplicates(valuelist(get_period.period_id,',')),'numeric','ASC',',')>
	</cfif>
	<cfif len(company_list)>
		<cfquery name="get_company" datasource="#dsn#">
			SELECT COMP_ID, COMPANY_NAME FROM OUR_COMPANY WHERE COMP_ID IN (#company_list#) ORDER BY COMP_ID
		</cfquery>
		<cfset company_list = listsort(listdeleteduplicates(valuelist(get_company.comp_id,',')),'numeric','ASC',',')>
	</cfif>

	<cfif isdefined("get_period.period_id") and len(get_period.period_id)>
		<cfset period = #get_period.period[listfind(period_list,get_period.period_id,',')]#>
	<cfelseif isdefined("get_company.comp_id") and len(get_company.comp_id)>
		<cfset period = #get_company.company_name[listfind(company_list,get_company.comp_id,',')]#>					
	</cfif>

	<cfset comp_control = ListFind(use_company_module,url_modul) ? true : false />
	<cfset per_control = ListFind(use_period_module,url_modul) ? true : false />
	<cfset Our_Company_Id_ = get_company.comp_id?:''>
	<cfset Period_Id_ = get_period.period_id?:''>
	

	<cfif isdefined('attributes.action_id')>
		<cfset getActionInfo = createObject("component","cfc.getActionInfo")>
		<cfset actionInfo = getActionInfo.get(action_table:get_warnings.action_table)>
		<cfif structCount( actionInfo )>
			<cfif not len(get_warnings.GENERAL_PAPER_ID)>
				<cfif actionInfo.action_db_type eq 'main' or actionInfo.action_db_type eq 'product' or not isdefined("get_period.period_id")>
					<cfset datasourceAlias = actionInfo.action_db />
				<cfelseif (actionInfo.action_db_type eq 'period')>
					<cfset datasourceAlias = "#dsn#_#get_period.period_year#_#get_period.our_company_id#" />
				<cfelseif (actionInfo.action_db_type eq 'company')>
					<cfset datasourceAlias = "#dsn#_#get_period.our_company_id#" />
				</cfif>
				<cfquery name = "getActionRecord" datasource = "#datasourceAlias#">
					SELECT #get_warnings.ACTION_COLUMN# FROM #get_warnings.ACTION_TABLE#
					WHERE #get_warnings.ACTION_COLUMN# = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_warnings.ACTION_ID#">
				</cfquery>
				<cfset actionRecordStatus = getActionRecord.recordCount ? true : false />
			<cfelse>
				<cfset actionRecordStatus = true />
			</cfif>
		<cfelse>
			<cfset actionRecordStatus = false />
		</cfif>
	<cfelse>
		<cfset actionRecordStatus = true />
	</cfif>

	<cfif actionRecordStatus>
		<div class="page">
			<div class="page-title">
				<cfoutput>#isdefined('period') ? period & '/' : ''#<b>#get_warnings.warning_description#</b> / #getLang('','Belge Tarihi','48087')# : #dateformat(get_warnings.record_date,dateformat_style)#</cfoutput>
				<a href="javascript://" onclick="openTab(2,'','',true)" class="pull-right ui-btn ui-btn-gray2 margin-left-5"><i class="fa fa-arrow-left"></i></a>
				<cfset firstLink = ( len( get_warnings.GENERAL_PAPER_ID ) ) ? "#get_warnings.url_link#&gp_id=#get_warnings.GENERAL_PAPER_ID#" : get_warnings.url_link>
				<cfset firstLink_ = ( len( get_warnings.ACTION_LIST_ID ) ) ? "#firstLink#&action_list_id=#get_warnings.ACTION_LIST_ID#" : firstLink>
				<cfset url_link_flow = "#firstLink_#&wrkflow=1#len(get_warnings.WSR_CODE) ? '&wsr_code=' & get_warnings.WSR_CODE : ''#">
				<cfset oldFuseaction = ReplaceNoCase(ListFirst(ListLast( url_link_flow, "?"),"&"),"fuseaction=","")>
				<cfset newUrlLink = ReplaceNoCase(url_link_flow, oldFuseaction, attributes.action )>
				<a href="javascript://" onclick="warning_redirect('<cfoutput>#url_link_flow#</cfoutput>',{ comp_control: <cfoutput>#comp_control#</cfoutput>, comp_id: '<cfoutput>#Our_Company_Id_#</cfoutput>', per_control: <cfoutput>#per_control#</cfoutput>, per_id: '<cfoutput>#Period_Id_#</cfoutput>' })" class="pull-right ui-btn ui-btn-gray"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='48799.Kaynak'> <cf_get_lang dictionary_id ='57468.Belge'>"></i></a>
			</div>
			<div class="col col-5 col-xs-12" style="heigth:100%;">
				<cf_box title="#getLang('','Önizleme','59807')#" collapsable="0" closable="0">
					<div class="scroll">	
						<div id="preview_content">
							<cfif GET_PRINT_TAMPLATE.recordCount and ((GET_PRINT_TAMPLATE.is_standart eq 1 and fileExists("#download_folder##GET_PRINT_TAMPLATE.template_file#")) or fileExists("#upload_folder#settings/#GET_PRINT_TAMPLATE.template_file#"))>
								<cfparam name="attributes.IID" default="#attributes.action_id#">
								<style>
									#template-preview{overflow-y:hidden;}
									#template-preview > table{
										width:100% !important;
										height:auto !important;
									}
								</style>
								<div id="template-preview">
									<cfif GET_PRINT_TAMPLATE.is_standart eq 1>
										<cfinclude template="/#GET_PRINT_TAMPLATE.template_file#">
									<cfelse>
										<cfinclude template="#file_web_path#settings/#GET_PRINT_TAMPLATE.template_file#">
									</cfif>
								</div>
								<div style="display:none;" id="template-preview2">
									<div class="preview-btn">
										<a title="Küçült" onclick="$('div#template-preview2').removeClass('template-preview-zoom')"><i class="fa fa-expand"></i></a>
									</div>
									<cfif GET_PRINT_TAMPLATE.is_standart eq 1>
										<cfinclude template="/#GET_PRINT_TAMPLATE.template_file#">
									<cfelse>
										<cfinclude template="#file_web_path#settings/#GET_PRINT_TAMPLATE.template_file#">
									</cfif>
								</div>
							<cfelse>
								<div style="text-align:center;padding:10px 0;">
									<h4><cf_get_lang dictionary_id='60110.Önizleme Yapılamıyor'>!</h4> 
									<h5><cf_get_lang dictionary_id='60111.Aşamaya Şablon Seçilmemiş'>!</h5>
								</div>
							</cfif>
						</div>
					</div>
				</cf_box>							
			</div>
			<div class="col col-7 col-xs-12">				
				<cf_box>
					<div class="scroll">
						<table class="ajax_list" id="workflow_detail">
							<thead>
								<th><cf_get_lang dictionary_id='58054.Süreç - Aşama'></th>
								<th><cf_get_lang dictionary_id='30883.Bildirimler'></th>
								<th>
									<div class="item-send">
										<span>
											<small title="<cf_get_lang dictionary_id='32571.Gönderen'>">
												<cfsavecontent variable="title"><cf_get_lang dictionary_id='32571.Gönderen'></cfsavecontent>
												<cfoutput>#Left(title, 1)#</cfoutput>
											</small>
										</span>
										<div class="smal-icon"><i class="fa fa-arrow-right"></i></div>
										<span>
											<small title="<cf_get_lang dictionary_id='64077.Alan'>">
												<cfsavecontent variable="title"><cf_get_lang dictionary_id='64077.Alan'></cfsavecontent>
												<cfoutput>#Left(title, 1)#</cfoutput>
											</small>
										</span>
										<div class="smal-icon"><i class="fa fa-arrow-right"></i></div>
										<span>
											<small title="<cf_get_lang dictionary_id='31756.Bilgi Verilen'>">
												<cfsavecontent variable="title"><cf_get_lang dictionary_id='31756.Bilgi Verilen'></cfsavecontent>
												<cfoutput>#Left(title, 1)#</cfoutput>
											</small>
										</span>
									</div>
								</th>
								<th><cf_get_lang dictionary_id='57500.Onay'></th>
								<th><cf_get_lang dictionary_id='58654.Cevap'></th>
								<th style="width:20px;"><i title="<cf_get_lang dictionary_id='29513.Süre'>" class="icon-time"></i></th>
							</thead>
							<tbody>
								<cfoutput query="get_warnings">
									<cfquery name="GET_W_ID" datasource="#dsn#">
										SELECT 
											PW.W_ID,
											PW.POSITION_CODE,
											PW.RECORD_EMP,
											PW.RECORD_PAR,
											PW.RECORD_CON,
											PW.IS_MANDATE,
											PW.IS_NOTIFICATION,
											PW.OUR_COMPANY_ID,
											PW.PERIOD_ID,
											PWA.WARNING_ID AS PWA_WARNING_ID,
											PWA.IS_CONFIRM AS PWA_IS_CONFIRM, 
											PWA.IS_AGAIN AS PWA_IS_AGAIN,
											PWA.IS_SUPPORT AS PWA_IS_SUPPORT,
											PWA.IS_CANCEL AS PWA_IS_CANCEL,
											PWA.IS_REFUSE AS PWA_IS_REFUSE,
											PWA.RECORD_DATE AS PWA_RECORD_DATE,
											PWA.WARNING_DESCRIPTION,
											CONCAT( EMPS.EMPLOYEE_NAME, ' ', EMPS.EMPLOYEE_SURNAME ) AS PWA_USERNAME,  
											ISNULL(PTR.IS_REQUIRED_PREVIEW,0) IS_REQUIRED_PREVIEW,
											ISNULL(PTR.IS_REQUIRED_ACTION_LINK,0) IS_REQUIRED_ACTION_LINK,
											ISNULL(PW.IS_CONFIRM_COMMENT_REQUIRED,0) AS IS_CONFIRM_COMMENT_REQUIRED,
											ISNULL(PW.IS_REFUSE_COMMENT_REQUIRED,0) AS IS_REFUSE_COMMENT_REQUIRED,
											ISNULL(PW.IS_AGAIN_COMMENT_REQUIRED,0) AS IS_AGAIN_COMMENT_REQUIRED,
											ISNULL(PW.IS_SUPPORT_COMMENT_REQUIRED,0) AS IS_SUPPORT_COMMENT_REQUIRED,
											ISNULL(PW.IS_CANCEL_COMMENT_REQUIRED,0) AS IS_CANCEL_COMMENT_REQUIRED
										FROM 
											PAGE_WARNINGS AS PW
											LEFT JOIN PROCESS_TYPE_ROWS AS PTR ON PW.ACTION_STAGE_ID = PTR.PROCESS_ROW_ID
											LEFT JOIN PAGE_WARNINGS_ACTIONS AS PWA ON PW.W_ID = PWA.WARNING_ID
											LEFT JOIN EMPLOYEES AS EMPS ON PWA.RECORD_EMP = EMPS.EMPLOYEE_ID
											LEFT JOIN GENERAL_PAPER AS GP ON PW.GENERAL_PAPER_ID = GP.GENERAL_PAPER_ID
										WHERE PW.W_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#WARNING_ID#">
									</cfquery>
									<cfif GET_W_ID.recordcount>
										<tr>
											<td>
												<div class="item-message">
													<div class="desktop other-message other-messsage-bold">#STAGE#</div>
													<div class="mobil other-message other-messsage-bold color-#Left(Trim(stage), 1)#">#STAGE#</div>
													<div class="other-message">#( len(GET_W_ID.WARNING_DESCRIPTION) ) ? GET_W_ID.WARNING_DESCRIPTION : WARNING_DESCRIPTION#</div>
												</div>
											</td>
											<td>
												<div class="item-date centered">#dateformat(LAST_RESPONSE_DATE,dateformat_style)#</div>
											</td>
											<td>
												<div class="item-send">
												<cfif len(GET_W_ID.RECORD_EMP)>
													<cfif len(get_employees.photo[listfind(employee_list,GET_W_ID.RECORD_EMP,',')]) and FileExists("#upload_folder#hr\#get_employees.photo[listfind(employee_list,GET_W_ID.RECORD_EMP,',')]#")>
														<div class="senderPerson">
															#(Len(GET_W_ID.IS_MANDATE) and GET_W_ID.IS_MANDATE eq 1 ) ? "<b style='margin:0 6px 0 -16px;'>V</b>" : ""#
															<img class="img-circle" width="30" height="30" src="../documents/hr/#get_employees.photo[listfind(employee_list,GET_W_ID.RECORD_EMP,',')]#"/>
															<div class="custom-tlt">#(Len(GET_W_ID.IS_MANDATE) and GET_W_ID.IS_MANDATE eq 1 ) ? "Vekaleten : " : ""##get_employees.employee_name[listfind(employee_list,GET_W_ID.RECORD_EMP,',')]# #get_employees.employee_surname[listfind(employee_list,GET_W_ID.RECORD_EMP,',')]#</div>
														</div>
													<cfelse>
														<span class="#getEngLetterColor(Left(get_employees.employee_name[listfind(employee_list,GET_W_ID.RECORD_EMP,',')], 1))#" style="height:30px;width:30px;">
															#(Len(GET_W_ID.IS_MANDATE) and GET_W_ID.IS_MANDATE eq 1 ) ? "<b style='margin:0 6px 0 -16px;'>V</b>" : ""#
															<small>#Left(get_employees.employee_name[listfind(employee_list,GET_W_ID.RECORD_EMP,',')], 1)##Left(get_employees.employee_surname[listfind(employee_list,GET_W_ID.RECORD_EMP,',')], 1)#</small>
															<div class="custom-tlt">#(Len(GET_W_ID.IS_MANDATE) and GET_W_ID.IS_MANDATE eq 1) ? "Vekaleten : " : ""##get_employees.employee_name[listfind(employee_list,GET_W_ID.RECORD_EMP,',')]# #get_employees.employee_surname[listfind(employee_list,GET_W_ID.RECORD_EMP,',')]#</div>
														</span>
													</cfif>
												<cfelseif len(GET_W_ID.RECORD_PAR)>
													<cfif len(get_partners.photo[listfind(partner_list,GET_W_ID.RECORD_PAR,',')]) and FileExists("#upload_folder#hr/#get_partners.photo[listfind(partner_list,GET_W_ID.RECORD_PAR,',')]#")>
														<div class="senderPerson">
															#(Len(GET_W_ID.IS_MANDATE) and GET_W_ID.IS_MANDATE eq 1 ) ? "<b style='margin:0 6px 0 -16px;'>V</b>" : ""#
															<img class="img-circle" width="30" height="30" src="#upload_folder#hr/#get_partners.photo[listfind(partner_list,GET_W_ID.RECORD_PAR,',')]#"/>
															<div class="custom-tlt">#(Len(GET_W_ID.IS_MANDATE) and GET_W_ID.IS_MANDATE eq 1) ? "Vekaleten : " : ""##get_partners.company_partner_name[listfind(partner_list,GET_W_ID.RECORD_PAR,',')]# #get_partners.company_partner_surname[listfind(partner_list,GET_W_ID.RECORD_PAR,',')]#</div>	
														</div>
													<cfelse>
														<span class="#getEngLetterColor(Left(get_partners.company_partner_name[listfind(partner_list,GET_W_ID.RECORD_PAR,',')], 1))#">
															#(Len(GET_W_ID.IS_MANDATE) and GET_W_ID.IS_MANDATE eq 1 ) ? "<b style='margin:0 6px 0 -16px;'>V</b>" : ""#
															<small>#Left(get_partners.company_partner_name[listfind(partner_list,GET_W_ID.RECORD_PAR,',')], 1)##Left(get_partners.company_partner_surname[listfind(partner_list,GET_W_ID.RECORD_PAR,',')], 1)#</small>
														</span>
													</cfif>
												<cfelseif len(GET_W_ID.RECORD_CON)>
													<cfif len(get_consumers.picture[listfind(consumer_list,GET_W_ID.RECORD_CON,',')]) and FileExists("#upload_folder#hr/#get_consumers.picture[listfind(consumer_list,GET_W_ID.RECORD_CON,',')]#")>
														<div class="senderPerson">
															#(Len(GET_W_ID.IS_MANDATE) and GET_W_ID.IS_MANDATE eq 1 ) ? "<b style='margin:0 6px 0 -16px;'>V</b>" : ""#
															<img class="img-circle" width="30" height="30" src="#upload_folder#hr/#get_consumers.picture[listfind(consumer_list,GET_W_ID.RECORD_CON,',')]#"/>
														</div>
													<cfelse>
														<span class="#getEngLetterColor(Left(get_consumers.consumer_name[listfind(consumer_list,GET_W_ID.RECORD_CON,',')], 1))#">
															#(Len(GET_W_ID.IS_MANDATE) and GET_W_ID.IS_MANDATE eq 1 ) ? "<b style='margin:0 6px 0 -16px;'>V</b>" : ""#
															<small>#Left(get_consumers.consumer_name[listfind(consumer_list,GET_W_ID.RECORD_CON,',')], 1)##Left(get_consumers.consumer_surname[listfind(consumer_list,GET_W_ID.RECORD_CON,',')], 1)#</small>
														</span>
													</cfif>
												</cfif>
												<div class="smal-icon"><i class="fa fa-arrow-right"></i></div>
												<cfif get_all_warnings.recordCount>
													<cfquery name = "GET_ALL_WARNINGS_POSITIONS" dbtype="query">
														SELECT POSITION_CODE FROM GET_ALL_WARNINGS 
														WHERE 1 = 1
														<cfif isdefined("action_id") and len(action_id)>
														AND ACTION_STAGE_ID = #ACTION_STAGE_ID# 
														</cfif>
														GROUP BY POSITION_CODE
													</cfquery>
													<cfset i = 1>
													<cfif GET_ALL_WARNINGS_POSITIONS.recordCount>
														<cfloop query="GET_ALL_WARNINGS_POSITIONS">
															<cfif i lte 2>
																<cfif len(get_positions.photo[listfind(position_list,position_code,',')]) and FileExists("#upload_folder#hr\#get_positions.photo[listfind(position_list,POSITION_CODE,',')]#")>
																	<div class="senderPerson">
																		<img class="img-circle" width="30" height="30" src="../documents/hr/#get_positions.photo[listfind(position_list,POSITION_CODE,',')]#"/>
																		<div class="custom-tlt">#get_positions.employee_name[listfind(position_list,POSITION_CODE,',')]# #get_positions.employee_surname[listfind(position_list,POSITION_CODE,',')]#</div>
																	</div>
																<cfelse>
																	<span style="height:30px;width:30px;" class="#getEngLetterColor(Left(get_positions.employee_name[listfind(position_list,POSITION_CODE,',')], 1))#">
																		<small>#Left(get_positions.employee_name[listfind(position_list,POSITION_CODE,',')], 1)##Left(get_positions.employee_surname[listfind(position_list,POSITION_CODE,',')], 1)#</small>
																		<div class="custom-tlt">#get_positions.employee_name[listfind(position_list,POSITION_CODE,',')]# #get_positions.employee_surname[listfind(position_list,POSITION_CODE,',')]#</div>
																	</span>
																</cfif>
															<cfelseif GET_ALL_WARNINGS_POSITIONS.recordcount gt 2>
																<cfif i eq 3>
																	<span title="<cf_get_lang dictionary_id='58156.Diğer'>" class="item-send-all" style="cursor:pointer;">
																		<i class="fa fa-plus"></i>
																		<div class="other-send" style="z-index: 999; box-shadow: 0 0 1px;">
																</cfif>
																	<li>#get_positions.employee_name[listfind(position_list,POSITION_CODE,',')]# #get_positions.employee_surname[listfind(position_list,POSITION_CODE,',')]#</li>
																<cfif i eq GET_ALL_WARNINGS_POSITIONS.recordcount>
																		</div>
																	</span>
																</cfif>
															</cfif>
															<cfset i++>
														</cfloop>
													</cfif>
												</cfif>
												</div>
											</td>
											<td>
												<div class="item-act centered">
													<!---
														Süreç aşamasında 
															Onay iste seçilmişse ve belge kaydı sonrasında uyarı olarak kaydedilmişse,
															Süreç aşamasında Belge detayını görmek zorunlu olsun seçilmemişse
													--->
													<cfif GET_W_ID.IS_REQUIRED_ACTION_LINK eq 0>
														<cfif type eq 0>
															<cfsavecontent variable="message"><cf_get_lang dictionary_id='31762.Yapmakta olduğunuz bu işlem şirketinizi ve sizi bağlayacak konular içerebilir'>\n<cf_get_lang dictionary_id='31761.Devam etmek istediğinize emin misiniz'>?</cfsavecontent>
															<cfif is_confirm eq 1>
																<cfif not len(GET_W_ID.PWA_WARNING_ID) and newPositionCode eq GET_W_ID.POSITION_CODE and GET_W_ID.IS_NOTIFICATION neq 1>
																	<span class="popover fa fa-2x fa-thumbs-o-up noAction" onclick="actionClick(this,'valid',#GET_W_ID.W_ID#,#GET_W_ID.IS_CONFIRM_COMMENT_REQUIRED#,'#GET_W_ID.OUR_COMPANY_ID#','#GET_W_ID.PERIOD_ID#')">
																		<div class="custom-tlt"><cf_get_lang dictionary_id ='58475.Onayla'></div>
																	</span>
																<cfelseif len(GET_W_ID.PWA_IS_CONFIRM)>
																	<span class="popover fa fa-2x fa-thumbs-o-up #iif((GET_W_ID.PWA_IS_CONFIRM eq 0), DE('passiveAction'), DE('activeAction'))#">
																		<div class="custom-tlt"><cf_get_lang dictionary_id ='58699.Onaylandı'></div>
																	</span>
																<cfelse>
																	<span class="fa fa-2x fa-thumbs-o-up"></span>
																</cfif>
															</cfif>
															<cfif is_refuse eq 1>
																<cfif not len(GET_W_ID.PWA_WARNING_ID) and newPositionCode eq GET_W_ID.POSITION_CODE and GET_W_ID.IS_NOTIFICATION neq 1>
																	<span class="popover fa fa-2x fa-thumbs-o-down ml-1 noAction" onclick="actionClick(this,'refusal',#GET_W_ID.W_ID#,#GET_W_ID.IS_REFUSE_COMMENT_REQUIRED#,'#GET_W_ID.OUR_COMPANY_ID#','#GET_W_ID.PERIOD_ID#')">
																		<div class="custom-tlt"><cf_get_lang dictionary_id='58461.Reddet'></div>
																	</span>
																<cfelseif len(GET_W_ID.PWA_IS_REFUSE)>
																	<span class="popover fa fa-2x fa-thumbs-o-down ml-1 #iif((GET_W_ID.PWA_IS_REFUSE eq 0), DE('passiveAction'), DE('activeAction'))#">
																		<div class="custom-tlt"><cf_get_lang dictionary_id='57617.Reddedildi'></div>
																	</span>
																<cfelse>
																	<span class="fa fa-2x fa-thumbs-o-down ml-1"></span>
																</cfif>
															</cfif>
															<cfif is_again eq 1>
																<cfif not len(GET_W_ID.PWA_WARNING_ID) and newPositionCode eq GET_W_ID.POSITION_CODE and GET_W_ID.IS_NOTIFICATION neq 1>
																	<span class="popover fa fa-2x fa-rotate-right ml-1 noAction" onclick="actionClick(this,'again',#GET_W_ID.W_ID#,#GET_W_ID.IS_AGAIN_COMMENT_REQUIRED#,'#GET_W_ID.OUR_COMPANY_ID#','#GET_W_ID.PERIOD_ID#')">
																		<div class="custom-tlt"><cf_get_lang dictionary_id='57214.Tekrar Yap'></div>
																	</span>
																<cfelseif len(GET_W_ID.PWA_IS_AGAIN)>
																	<span class="popover fa fa-2x fa-rotate-right ml-1 #iif((GET_W_ID.PWA_IS_AGAIN eq 0), DE('passiveAction'), DE('activeAction'))#">
																		<div class="custom-tlt"><cf_get_lang dictionary_id='60112.Tekrar yapılması istendi'></div>
																	</span>
																<cfelse>
																	<span class="fa fa-2x fa-rotate-right ml-1"></span>
																</cfif>
															</cfif>
															<cfif is_support eq 1>
																<cfif not len(GET_W_ID.PWA_WARNING_ID) and newPositionCode eq GET_W_ID.POSITION_CODE and GET_W_ID.IS_NOTIFICATION neq 1>
																	<span class="popover fa fa-2x fa-support ml-1 noAction" onclick="actionClick(this,'support',#GET_W_ID.W_ID#,#GET_W_ID.IS_SUPPORT_COMMENT_REQUIRED#,'#GET_W_ID.OUR_COMPANY_ID#','#GET_W_ID.PERIOD_ID#')">
																		<div class="custom-tlt"><cf_get_lang dictionary_id='57218.Başkasına Gönder'> / <cf_get_lang dictionary_id='57226.Destek Al'></div>
																	</span>
																<cfelseif len(GET_W_ID.PWA_IS_SUPPORT)>
																	<span class="popover fa fa-2x fa-support ml-1 #iif((GET_W_ID.PWA_IS_SUPPORT eq 0), DE('passiveAction'), DE('activeAction'))#">
																		<div class="custom-tlt"><cf_get_lang dictionary_id='60113.Destek alınması istendi'></div>
																	</span>
																<cfelse>
																	<span class="fa fa-2x fa-support ml-1"></span>
																</cfif>
															</cfif>
															<cfif is_cancel eq 1>
																<cfif not len(GET_W_ID.PWA_WARNING_ID) and newPositionCode eq GET_W_ID.POSITION_CODE and GET_W_ID.IS_NOTIFICATION neq 1>
																	<span class="popover fa fa-2x fa-cut ml-1 noAction" onclick="actionClick(this,'cancel',#GET_W_ID.W_ID#,#GET_W_ID.IS_CANCEL_COMMENT_REQUIRED#,'#GET_W_ID.OUR_COMPANY_ID#','#GET_W_ID.PERIOD_ID#')">
																		<div class="custom-tlt"><cf_get_lang dictionary_id='58506.İptal'></div>
																	</span>
																<cfelseif len(GET_W_ID.PWA_IS_CANCEL)>
																	<span class="popover fa fa-2x fa-cut ml-1 #iif((GET_W_ID.PWA_IS_CANCEL eq 0), DE('passiveAction'), DE('activeAction'))#">
																		<div class="custom-tlt"><cf_get_lang dictionary_id='59190.İptal Edildi'></div>
																	</span>
																<cfelse>
																	<span class="fa fa-2x fa-cut ml-1"></span>
																</cfif>
															</cfif>
														</cfif>
														<cfif COMMENT_REQUEST eq 1>
															<cfif not len(GET_W_ID.PWA_WARNING_ID) and newPositionCode eq GET_W_ID.POSITION_CODE and GET_W_ID.IS_NOTIFICATION neq 1>
																<span class="popover fa fa-2x fa-comment-o ml-2 noAction" onclick="actionClick(this,'comment',#GET_W_ID.W_ID#,1,'#GET_W_ID.OUR_COMPANY_ID#','#GET_W_ID.PERIOD_ID#')">
																	<div class="custom-tlt"><cf_get_lang dictionary_id='32970.Yorum Yap'></div>
																</span>
															<cfelse>
																<span class="popover fa fa-2x fa-comment-o ml-2"></span>
															</cfif>
														</cfif>
													</cfif>
												</div>
											</td>
											<td>
												<div class="item-message">
													<cfif len( GET_W_ID.PWA_USERNAME ) and len(GET_W_ID.PWA_RECORD_DATE)>
														<div class="other-message other-messsage-bold">#GET_W_ID.PWA_USERNAME#</div>
														<div class="other-message">#dateformat(GET_W_ID.PWA_RECORD_DATE,dateformat_style)# #TimeFormat(date_add("h",session.ep.time_zone,GET_W_ID.PWA_RECORD_DATE),timeformat_style)#</div>
													</cfif>
												</div>
											</td>
											<td>
												<div class="item-cl">
													<span class="popover icon-time">
														<div class="custom-tlt"><cfif len(LAST_RESPONSE_DATE)><cfset fark3 = datediff('H',RECORD_DATE,last_response_date)> #fark3# <cf_get_lang dictionary_id='57491.Saat'><cfelse>-</cfif></div>
													</span>
												</div>
											</td>
										</tr>
									</cfif>
								</cfoutput>
							</tbody>
						</table>
					</div>
					<cfif GET_WARNINGS.IS_STAGE_MANUEL_CHANGE eq 1>
						<cfform action="#request.self#?fuseaction=myhome.emptypopup_dsp_upd_warning" name="form_change_process_stage" method="post">
						<cfinput type="hidden" name="warning_mode" value="change_process_stage">
						<cfinput type="hidden" name="action_table" value="#GET_WARNINGS.ACTION_TABLE#">
						<cfinput type="hidden" name="action_column" value="#GET_WARNINGS.ACTION_COLUMN#">
						<cfinput type="hidden" name="action_id" value="#GET_WARNINGS.ACTION_ID#">
						<cfinput type="hidden" name="fusact" value="#attributes.action#">
						<div class="content-flex">
							<div class="content-item">
								<div class="item-new-stage" id="showNewStageArea" style="cursor:pointer;"><i class="pull-left fa fa-pencil"></i><cf_get_lang dictionary_id='60114.Süreç - Aşama oluşturmak için tıklayınız'>.</div>
							</div>
							<div class="content-sub-item ui-form-list ui-form-block" id="newStageArea">
								<div class="sub-item">
									<div class="form-group col col-12">
										<label><cf_get_lang dictionary_id='36199.Açıklama'>*</label>
										<div>
											<textarea name="warning_description" id="warning_description" maxlength="1000" required></textarea>
										</div>
									</div>
								</div>
								<div class="sub-item">
									<div class="form-group col col-4 col-md-4 col-sm-4 col-xs-12">
										<label><cf_get_lang dictionary_id='60116.Checker'>*</label>
										<div class="input-group">
											<input type="hidden" name="position_code" id="position_code" value="">
											<input type="hidden" name="employee_id" id="employee_id" value="">
											<input type="text" name="employee_name" id="employee_name" onfocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID,POSITION_CODE','employee_id,position_code','3','135');" required>
											<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=form_change_process_stage.employee_name&field_emp_id=form_change_process_stage.employee_id&field_code=form_change_process_stage.position_code&select_list=1','list');"></span>
										</div>
									</div>
								</div>
								<div class="sub-item">	
									<div class="form-group col col-4 col-md-4 col-sm-4 col-xs-12">
										<label><cf_get_lang dictionary_id='57482.Aşama'>*</label>
										<div>
											<cfset lastStage = ( len(allStage) ) ? ((listLen(allStage) gt 1 ) ? listLast(allStage) : allStage) : "">
											<cf_workcube_process is_upd='0' select_value='#lastStage#' process_cat_width='188' is_detail='1' fusepath="#attributes.action#">
										</div>
									</div>
								</div>
								<div class="sub-item">
									<div class="form-group col col-2 col-md-3 col-sm-3 col-xs-12">
										<div id="messageArea" style="display:none;"></div>
										<input type="submit" class="ui-btn ui-btn-success" value="<cf_get_lang dictionary_id='57461.Kaydet'>">
									</div>
								</div>
							</div>
						</div>
					</cfform>
					</cfif>
				</cf_box>
				<cf_box title="#getLang('','Yorumlar','58185')#" closable="0" collapsed="1">
					<div class="message-content" id="warning_comment">
						<cfinclude template="../../myhome/display/dsp_warning.cfm">
					</div>
				</cf_box>
				<cfif len( GET_WARNINGS.ACTION_COLUMN )>
					<cfset relationPaperList = "OPP_ID,OFFER_ID,ORDER_ID,P_ORDER_ID,SHIP_ID,INVOICE_ID,PR_ORDER_ID,FIS_ID,SHIP_RESULT_ID,INTERNAL_ID" />
					<cfset relationCostSpendList = "CLOSED_ID" />
					<cfif listFindNoCase(relationPaperList, GET_WARNINGS.ACTION_COLUMN) or listFindNoCase(relationCostSpendList, GET_WARNINGS.ACTION_COLUMN)>
						<cfset viewType = ( listFindNoCase(relationPaperList, GET_WARNINGS.ACTION_COLUMN) ) ? "paper" : "cari" />
						<cf_box title="#getLang('','Bağlantılı İşlemler',60115)#" box_page="#request.self#?fuseaction=objects.emptypopup_ajax_dsp_relation_papers&action_id=#get_warnings.ACTION_ID#&action_type=#get_warnings.ACTION_COLUMN#&view_type=#viewType#"></cf_box>
						<cf_box title="#getLang('','Belgeler',57568)#" box_page="V16/objects/display/get_asset_by_action_section.cfm?action_id=#get_warnings.ACTION_ID#&action_section=#get_warnings.ACTION_COLUMN#&our_company_id=#get_warnings.OUR_COMPANY_ID#"></cf_box>
						<cf_get_workcube_note company_id="#session.ep.company_id#" action_section='#get_warnings.ACTION_COLUMN#' action_id='#get_warnings.ACTION_ID#' design_id='1' style="1">
					</cfif>
				</cfif>
			</div>
		</div>
	<cfelse>

		<cfquery name="upd_page_warnings" datasource="#dsn#">
			UPDATE PAGE_WARNINGS SET IS_ACTIVE = 0 WHERE W_ID = #get_warnings.WARNING_ID#
		</cfquery>

		<script>setWarningCounts( window.warningCounter.chatCounter, window.warningCounter.warningCounter - 1, 'WorkFlow' );</script>

		<div class="text-center" style="margin-top:100px;">
			<h3><cf_get_lang dictionary_id = '58486.Kayıt Bulunamadı'>!</h3>
			<h4><cf_get_lang dictionary_id = '60877.Bu kayıt silinmiş olabilir, kaydın tüm bildirimlerini sizin yerinize pasife aldık'>!</h4>
			<h4><cf_get_lang dictionary_id = '60878.Geri ikonuna tıklayarak Workflow listesine dönebilirsiniz'>.</h4>
			<a href="javascript://" onclick="openTab(2,'','',true)" style="float:none;" class="float-none ui-wrk-btn ui-wrk-btn-extra"><i class="fa fa-arrow-left"></i></a>
		</div>

	</cfif>
<cfelse>

	<cfif isDefined("attributes.action_id") and len(attributes.action_id) and isDefined("attributes.action_name") and len(attributes.action_name) >
		<cfset relationPaperList = "OPP_ID,OFFER_ID,ORDER_ID,P_ORDER_ID,SHIP_ID,INVOICE_ID,PR_ORDER_ID,FIS_ID,SHIP_RESULT_ID,INTERNAL_ID" />
		<cfset relationCostSpendList = "CLOSED_ID" />
		<cfif listFindNoCase(relationPaperList, uCase(attributes.action_name)) or listFindNoCase(relationCostSpendList,uCase(attributes.action_name))>
			<cfset viewType = ( listFindNoCase(relationPaperList, uCase(attributes.action_name)) ) ? "paper" : "cari" />
			<cf_box title="#getLang('','Bağlantılı İşlemler',60115)#" box_page="#request.self#?fuseaction=objects.emptypopup_ajax_dsp_relation_papers&action_id=#attributes.action_id#&action_type=#uCase(attributes.action_name)#&view_type=#viewType#"></cf_box>
			<cf_box title="#getLang('','Belgeler',57568)#" box_page="V16/objects/display/get_asset_by_action_section.cfm?action_id=#attributes.action_id#&action_section=#uCase(attributes.action_name)#&our_company_id=#session.ep.company_id#"></cf_box>
			<cf_get_workcube_note company_id="#session.ep.company_id#" action_section='#uCase(attributes.action_name)#' action_id='#attributes.action_id#' design_id='1' style="1">
		</cfif>
	<cfelse>
		<div class="container cl-12">
			<p class="lead"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</p>
		</div>
	</cfif>

</cfif>
<script src="/css/assets/template/w3-assets/js/bootstrap.js"></script>
<script src="/JS/assets/plugins/menuDesigner/popper.min.js"></script>
<script>
	$(function () {

		var elem = $('table.ajax_list'), id, elem_tr = [];
	    if(elem.length > 0){
		    $.each(elem, function(i){
			    id = elem.eq(i).attr("id");
			    $.each(elem.eq(i).find('tbody tr'), function(i){
				    if($(this).find('td').length == 1){
					    $(this).hide();
				    }
				    else{
					    for(var k=0; k<$(this).parents('table').find('thead th').length; k++){
						    if($(this).parents('table').find('thead th').eq(k).html() != undefined && $(this).find('td').eq(k).html() != undefined){
							    elem_tr.push({"id":id, "indis":k, "th":$(this).parents('table').find('thead th').eq(k).html(), "td":$(this).find('td').eq(k).html()});
						    }
					    }  
				    }
			    });  
			    if($(window).width() < 568){
				    var newTable = $('<table id="mobil'+id+'" class="ajax_list"></table>');
				    elem.eq(i).before(newTable);
				    /*elem.eq(i).parent().prepend('<ul class="ui-icon-list flex-right"><li><a id="standart_design" href="javascript://"><i class="fa fa-laptop"></i></a></li><li><a id="mobil_design" href="javascript://"><i class="fa fa-tablet"></i></a></li></ul>'); */
			    }
		    })
		    if($(window).width() < 568){
			    $.each(elem_tr, function(i){
				    var seperator = $('#'+this.id).find('thead th').length;
				    if(i != 0 && this.indis === 0){
					    $('#mobil'+this.id).append('<tr class="ui-line-bg"><td colspan="'+ seperator +'"></td></tr>');
					    $('#mobil'+this.id).append('<tr class="ui-line"><td colspan="'+ seperator +'"></td></tr>');
					    $('#mobil'+this.id).append('<tr class="ui-line-bg"><td colspan="'+ seperator +'"></td></tr>');
					    $('#mobil'+this.id).append('<tr indis="'+this.indis+'"><td style="background-color:#f9f9f9;">'+ this.th +'</td><td>'+ this.td +'</td></tr>');
				    }
				    else{
					    $('#mobil'+this.id).append('<tr indis="'+this.indis+'"><td style="background-color:#f9f9f9;">'+ this.th +'</td><td>'+ this.td +'</td></tr>');
				    }
				
			    });
		    }
	    }
		
		$('[data-toggle="tooltip"]').tooltip();
		$("li").css("list-style", "none");
		//$(document).prop("title","<cf_get_lang dictionary_id='32509.Süreçler'>");
		$('td span, td div.senderPerson').hover(function(){
			$(this).find('.custom-tlt').stop().fadeToggle();
		});
		$('.item-send-all').click(function(){
			$(this).toggleClass("item-send-all-open");
			$(this).find('.other-send').stop().fadeToggle();
		})

		$("#showNewStageArea").click(function() {
			$("#newStageArea").toggle();
		});
		
	})

	function connectAjax(el,row,w_id){
		if($(el).hasClass("openn")){
			$("#warning_comment"+row+"").hide();
			$(el).removeClass("openn").addClass("closee");
		}else{
			$("#warning_comment"+row+"").show();
			var url = '<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.popup_dsp_warning&warning_id='+w_id+'&warning_is_active=0';
			AjaxPageLoad(url,'warning_comment'+row,1);
			$(el).removeClass("closee").addClass("openn");
		}
	}

	$("form[name = form_change_process_stage]").submit(function(){

		if( 
			$.trim( $("#process_stage").val() ) != '' 
			&& $.trim( $("#warning_description").val() ) != ''
			&& $.trim( $("#position_code").val() ) != ''
			&& $.trim( $("#employee_id").val() ) != ''
			&& $.trim( $("#employee_name").val() ) != ''
		){

			if(AjaxFormSubmit("form_change_process_stage","messageArea")) location.reload();
			else alert("<cf_get_lang dictionary_id = '52126.Bir hata oluştu'>");

		}else alert("<cf_get_lang dictionary_id = '29722.Lütfen Zorunlu Alanları Doldurunuz'>");
		return false;

	});

	function controlPerComp( perCompControlSettings ){

        if(( perCompControlSettings.comp_control && perCompControlSettings.comp_id != '' && perCompControlSettings.comp_id != <cfoutput>#session.ep.company_id#</cfoutput>) || ( perCompControlSettings.per_control && perCompControlSettings.per_id != '' && perCompControlSettings.per_id != <cfoutput>#session.ep.period_id#</cfoutput>))   
		{
            $('.ui-cfmodal__alert .required_list li').remove();
            $('.ui-cfmodal__alert .ui-form-list-btn').remove();
            $('.ui-cfmodal__alert .required_list').append('<h4><cfoutput>#getLang("","Bu kayıt aşağıdaki sebeplerden dolayı görüntülenemiyor olabilir",62753)#</cfoutput></h4>');
			$('.ui-cfmodal__alert .required_list').append('<li><cfoutput>#getLang("","Bu işlem oturum açtığınız şirket ya da dönemde değil",62369)#</cfoutput></li>');
            if( perCompControlSettings.cmpName != '' ) $('.ui-cfmodal__alert .required_list').append('<li><cfoutput>#getLang("","İşlem yapılmak istenen Şirket-Dönem",62371)#</cfoutput> : '+perCompControlSettings.cmpName+'</li>');
            $('.ui-cfmodal__alert .required_list').append('<li><cfoutput>#getLang("","Aktif Oturum Şirketi-Dönem",62370)#</cfoutput> : <cfoutput>#session.ep.company# #session.ep.period_year#</cfoutput></li>');
            $('.ui-cfmodal__alert .required_list').append('<div class="ui-form-list-btn"><a href="javascript://" class="ui-btn ui-btn-success mt-3" onclick="changePerComp(\''+ per_id +'\');"><cfoutput>#getLang('','Değiştir',47334)#</cfoutput></a></div>');
            $('.ui-cfmodal__alert').fadeIn();
            return false;
		}
        return true;

    }

	function actionClick( el, type, id, commentRequired, perCompControlSettings) {
        
        perCompControlSettings.cmpName = "<cfoutput>#period?:''#</cfoutput>";
		if(controlPerComp( perCompControlSettings )){
            if(!$(el).closest("tr").next("tr").hasClass('actionNoteArea')) $(el).closest("tr").after("<tr class='actionNoteArea' style='border-color:#44b6ae;'><td colspan='8'><div id='actionNoteArea_"+id+"' style='padding:10px 0;'></div></td></tr>").css({ "border-color":"#44b6ae" });
			var mandatePositionCode = '<cfoutput>#newPositionCode neq session.ep.position_code ? newPositionCode : ''#</cfoutput>';
			AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.popup_list_warning&mode=getactionnote&fuseaction_=<cfoutput>#attributes.fuseaction#</cfoutput>&type='+type+'&id='+id+'&comment_required='+commentRequired+'&mandate_position_code='+mandatePositionCode+'&reload=1','actionNoteArea_'+id+'');
			return false;
        }
	}

	function warning_redirect(url,perCompControlSettings)
	{
        perCompControlSettings.cmpName = "<cfoutput>#period?:''#</cfoutput>";
		if(controlPerComp( perCompControlSettings )) window.open(url,"_blank");
	}
	
	function changePerComp(id) {
        AjaxPageLoad('<cfoutput>#request.self#?fuseaction=myhome.emptypopup_settings_process&id=acc_period&employee_idMngPeriod=#session.ep.userid#&moneyFormat=#session.ep.moneyformat_style#&position_idMngPeriod=#GET_POS_ID.POSITION_ID#</cfoutput>&user_period_idMngPeriod='+id,'mysettings_period_header',1);
    }
</script>
