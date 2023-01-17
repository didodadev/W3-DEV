<cfsetting showdebugoutput="yes">
<cf_xml_page_edit fuseact="invent.list_actions">
<cfparam name="attributes.belge_no" default="">
<cfparam name="attributes.cat" default="">
<cfparam name="attributes.ch_company_id" default="">
<cfparam name="attributes.ch_consumer_id" default="">
<cfparam name="attributes.ch_company" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.location_id" default="">
<cfparam name="attributes.branch_id1" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.department_name" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.subscription_id" default="">
<cfparam name="attributes.subscription_no" default="">
<cfparam name="attributes.efatura_type" default="">
<cfparam name="attributes.branch_id" default="">
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
<cfelseif session.ep.our_company_info.UNCONDITIONAL_LIST>
	<cfset attributes.start_date = ''>
<cfelse>
	<cfset attributes.start_date = date_add('d',-7,wrk_get_today())>
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
<cfelseif session.ep.our_company_info.UNCONDITIONAL_LIST>
	<cfset attributes.finish_date = ''>
<cfelse>
	<cfset attributes.finish_date = date_add('d',7,attributes.start_date)>
</cfif>
<cfif isdefined("attributes.form_varmi")>
	<cfif (len(attributes.cat) and listFind("65,66,82,83",attributes.cat)) or not len(attributes.cat)>
		<cfquery name="GET_ACTIONS" datasource="#dsn2#">
			<cfif (len(attributes.cat) and listFind("65,66",attributes.cat)) or not len(attributes.cat)>
				SELECT
					INVOICE.INVOICE_ID AS ACTION_ID,
					INVOICE.INVOICE_NUMBER AS PAPER_NUMBER,
					INVOICE.INVOICE_CAT AS PROCESS_TYPE,
					INVOICE.INVOICE_DATE AS PROCESS_DATE,
					INVOICE.NETTOTAL AS TUTAR,
					INVOICE.OTHER_MONEY_VALUE AS TUTAR_DOVIZ,
					INVOICE.OTHER_MONEY,
					INVOICE.RECORD_DATE,
                    B.BRANCH_NAME ,
					INVOICE.RECORD_EMP
				FROM
					INVOICE
                    LEFT JOIN #dsn_alias#.DEPARTMENT D  ON INVOICE.DEPARTMENT_ID = D.DEPARTMENT_ID
                    LEFT JOIN #dsn_alias#.BRANCH B ON D.BRANCH_ID = B.BRANCH_ID
				WHERE
                	INVOICE_CAT IN (65,66)
				<cfif len(attributes.cat)>
					AND INVOICE_CAT = #attributes.cat#
				</cfif>
				<cfif len(attributes.belge_no)>
					AND (INVOICE_NUMBER LIKE '<cfif len(attributes.belge_no) gt 3>%</cfif>#attributes.belge_no#%' COLLATE SQL_Latin1_General_CP1_CI_AI)
				</cfif>
				<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
					AND INVOICE_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
				<cfelseif isdate(attributes.start_date)>
					AND INVOICE_DATE >= #attributes.start_date#
				<cfelseif isdate(attributes.finish_date)>
					AND INVOICE_DATE <= #attributes.finish_date#
				</cfif>
                <cfif len(attributes.branch_id1)>
                	AND B.BRANCH_ID=#attributes.branch_id1#
                </cfif>
				<cfif len(attributes.ch_company_id) and len(attributes.ch_company)>
					AND INVOICE.COMPANY_ID = #attributes.ch_company_id#
				</cfif>
				<cfif len(attributes.ch_consumer_id) and len(attributes.ch_company)>
					AND CONSUMER_ID = #attributes.ch_consumer_id#
				</cfif>
				<cfif len(attributes.project_id) and len(attributes.project_head)>
					AND PROJECT_ID = #attributes.project_id#
				</cfif>
				<cfif len(attributes.department_id) and len(attributes.department_name)>
					AND (INVOICE.DEPARTMENT_ID = #attributes.department_id#
					AND DEPARTMENT_LOCATION=#attributes.location_id#)
				</cfif>
				<cfif len(attributes.employee_id) and len(attributes.employee_name)>
					AND SALE_EMP = #attributes.employee_id#
				</cfif>
			</cfif>
			<cfif not len(attributes.cat) and not len(attributes.efatura_type)>
			UNION ALL
			</cfif>
			<cfif (len(attributes.cat) and listFind("82,83",attributes.cat)) or not len(attributes.cat)>		
				SELECT
					SHIP.SHIP_ID AS ACTION_ID,
					SHIP.SHIP_NUMBER AS PAPER_NUMBER,
					SHIP.SHIP_TYPE AS PROCESS_TYPE,
					SHIP.SHIP_DATE AS PROCESS_DATE,
					SHIP.NETTOTAL AS TUTAR,
					SHIP.OTHER_MONEY_VALUE AS TUTAR_DOVIZ,
					SHIP.OTHER_MONEY,
					SHIP.RECORD_DATE,
                    B.BRANCH_NAME,
					SHIP.RECORD_EMP
				FROM
					SHIP
                    LEFT JOIN #dsn_alias#.DEPARTMENT D  ON ISNULL(SHIP.DELIVER_STORE_ID,SHIP.LOCATION_IN) = D.DEPARTMENT_ID 
                    LEFT JOIN #dsn_alias#.BRANCH B ON D.BRANCH_ID = B.BRANCH_ID
                    
				WHERE
					SHIP_TYPE IN (82,83)
				<cfif len(attributes.cat)>
					AND SHIP_TYPE = #attributes.cat#
				</cfif>
				<cfif len(attributes.belge_no)>
					AND (SHIP_NUMBER LIKE '<cfif len(attributes.belge_no) gt 3>%</cfif>#attributes.belge_no#%' COLLATE SQL_Latin1_General_CP1_CI_AI)
				</cfif>
				<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
					AND SHIP_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
				<cfelseif isdate(attributes.start_date)>
					AND SHIP_DATE >= #attributes.start_date#
				<cfelseif isdate(attributes.finish_date)>
					AND SHIP_DATE <= #attributes.finish_date#
				</cfif>
				<cfif len(attributes.ch_company_id) and len(attributes.ch_company)>
					AND SHIP.COMPANY_ID = #attributes.ch_company_id#
				</cfif>
				<cfif len(attributes.ch_consumer_id) and len(attributes.ch_company)>
					AND CONSUMER_ID = #attributes.ch_consumer_id#
				</cfif>
                 <cfif len(attributes.branch_id1)>
                	AND B.BRANCH_ID=#attributes.branch_id1#
                </cfif>
				<cfif len(attributes.project_id) and len(attributes.project_head)>
					AND PROJECT_ID = #attributes.project_id#
				</cfif>
				<cfif len(attributes.department_id) and len(attributes.department_name)>
					AND (SHIP.DEPARTMENT_IN = #attributes.department_id#
					AND LOCATION_IN = #attributes.location_id#)
				</cfif>
				<cfif len(attributes.employee_id) and len(attributes.employee_name)>
					AND SALE_EMP = #attributes.employee_id#
				</cfif>
			</cfif>
			</cfquery>
		</cfif>
		<cfif ((len(attributes.cat) and listFind("118,1182",attributes.cat)) or not len(attributes.cat)) and not len(attributes.ch_company)>		
			<cfquery name="get_ships" datasource="#dsn2#">
				SELECT
					S.FIS_ID AS ACTION_ID,
					S.FIS_NUMBER AS PAPER_NUMBER,
					S.FIS_TYPE AS PROCESS_TYPE,
					S.FIS_DATE AS PROCESS_DATE,
					SUM(SR.NET_TOTAL) AS TUTAR,
					SUM(SR.NET_TOTAL/SM.RATE2) AS TUTAR_DOVIZ,
					SM.MONEY_TYPE AS OTHER_MONEY,
					S.RECORD_DATE,
                    B.BRANCH_NAME,
					S.RECORD_EMP
				FROM
					STOCK_FIS S
					LEFT JOIN STOCK_FIS_ROW SR ON S.FIS_ID = SR.FIS_ID
					LEFT JOIN STOCK_FIS_MONEY SM ON S.FIS_ID = SM.ACTION_ID AND SM.IS_SELECTED = 1
                    LEFT JOIN #dsn_alias#.DEPARTMENT D  ON S.DEPARTMENT_IN = D.DEPARTMENT_ID OR S.DEPARTMENT_OUT = D.DEPARTMENT_ID
                    LEFT JOIN #dsn_alias#.BRANCH B ON D.BRANCH_ID = B.BRANCH_ID
                WHERE
					S.FIS_TYPE IN (118,1182)
				<cfif len(attributes.cat)>
					AND S.FIS_TYPE = #attributes.cat#
				</cfif>
				<cfif len(attributes.belge_no)>
					AND (S.FIS_NUMBER LIKE '<cfif len(attributes.belge_no) gt 3>%</cfif>#attributes.belge_no#%' COLLATE SQL_Latin1_General_CP1_CI_AI 
					OR S.REF_NO LIKE '%#attributes.belge_no#%' COLLATE SQL_Latin1_General_CP1_CI_AI) 
				</cfif>
                 <cfif len(attributes.branch_id1)>
                	AND B.BRANCH_ID=#attributes.branch_id1#
                </cfif>
				<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
					AND S.FIS_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
				<cfelseif isdate(attributes.start_date)>
					AND S.FIS_DATE >= #attributes.start_date#
				<cfelseif isdate(attributes.finish_date)>
					AND S.FIS_DATE <= #attributes.finish_date#
				</cfif>
				<cfif len(attributes.project_id) and len(attributes.project_head)>
					AND S.PROJECT_ID = #attributes.project_id#
				</cfif>
				<cfif len(attributes.employee_id) and len(attributes.employee_name)>
					AND S.EMPLOYEE_ID = #attributes.employee_id#
				</cfif>
				<cfif len(attributes.subscription_id) and len(attributes.subscription_no)>
					AND S.SUBSCRIPTION_ID = #attributes.subscription_id#
				</cfif>
				<cfif len(attributes.department_id) and len(attributes.department_name)>
					AND (S.DEPARTMENT_OUT = #attributes.department_id# 
					AND S.LOCATION_OUT = #attributes.location_id#)
				</cfif>
				GROUP BY
					S.FIS_ID,
					S.FIS_NUMBER,
					S.FIS_TYPE,
					S.FIS_DATE,
					S.RECORD_DATE,
					S.RECORD_EMP,
                    B.BRANCH_NAME,
					SM.MONEY_TYPE
			</cfquery>	
			</cfif>
            
			<cfquery name="get_all_actions" dbtype="query">
			<cfif (len(attributes.cat) and listFind("65,66,82,83",attributes.cat)) or not len(attributes.cat)>
					SELECT  	
						ACTION_ID,
						PAPER_NUMBER,
						PROCESS_TYPE,
						PROCESS_DATE,
						SUM(TUTAR) AS TUTAR,
						SUM(TUTAR_DOVIZ) AS TUTAR_DOVIZ,
						OTHER_MONEY,
                        BRANCH_NAME,
						RECORD_DATE,
						RECORD_EMP
					FROM  
						GET_ACTIONS
					<cfif len(attributes.subscription_id) and len(attributes.subscription_no)>
						WHERE 1=0
					</cfif> 
					GROUP BY 
						ACTION_ID,
						PAPER_NUMBER,
						PROCESS_TYPE,
						PROCESS_DATE,
						OTHER_MONEY,
						RECORD_DATE,
                        BRANCH_NAME,
						RECORD_EMP
				</cfif>
				<cfif not len(attributes.cat) and not len(attributes.ch_company)>
				UNION ALL
				</cfif>
				<cfif (len(attributes.cat) and listFind("118,1182",attributes.cat)) or (not len(attributes.cat) and not len(attributes.ch_company)) and not len(attributes.efatura_type)>	
				
					SELECT  
						ACTION_ID,
						PAPER_NUMBER,
						PROCESS_TYPE,
						PROCESS_DATE,
						SUM(TUTAR) AS TUTAR,
						SUM(TUTAR_DOVIZ) AS TUTAR_DOVIZ,
						OTHER_MONEY,
                        BRANCH_NAME,
						RECORD_DATE,
						RECORD_EMP
					FROM 
						GET_SHIPS 
					GROUP BY 
						ACTION_ID,
						PAPER_NUMBER,
						PROCESS_TYPE,
						PROCESS_DATE,
						OTHER_MONEY,
						RECORD_DATE,
                        BRANCH_NAME,
						RECORD_EMP
				</cfif>
					ORDER BY PROCESS_DATE DESC		
			</cfquery>
		<cfparam name="attributes.totalrecords" default="#get_all_actions.recordcount#">
	<cfelse>
		<cfparam name="attributes.totalrecords" default="0">	
</cfif>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1 >

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box> 
		<cfform name="form" action="#request.self#?fuseaction=invent.list_actions" method="post">
			<input name="form_varmi" id="form_varmi" value="1" type="hidden">
			<cf_box_search> 
				<div class="form-group">
					<cfinput type="text" name="belge_no" maxlength="50" placeholder="#getLang(87,'Belge/referans no',56980)#" value="#attributes.belge_no#">
				</div>
				<div class="form-group">
					<select name="cat" id="cat">
						<option selected value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
						<option value="65" <cfif attributes.cat eq "65">selected</cfif>><cf_get_lang dictionary_id='29574.Demirbaş Alış Faturası'></option>
						<option value="66" <cfif attributes.cat eq "66">selected</cfif>><cf_get_lang dictionary_id='29575.Demirbaş Satış Faturası'></option>
						<option value="82" <cfif attributes.cat eq "82">selected</cfif>><cf_get_lang dictionary_id='29589.Demirbaş Alım İrsaliyesi'></option>
						<option value="83" <cfif attributes.cat eq "83">selected</cfif>><cf_get_lang dictionary_id='29590.Demirbaş Satış İrsaliyesi'></option>
						<option value="118" <cfif attributes.cat eq "118">selected</cfif>><cf_get_lang dictionary_id='29635.Demirbaş Stok Fişi'></option>
						<option value="1182" <cfif attributes.cat eq "1182">selected</cfif>><cf_get_lang dictionary_id="29637.Demirbaş Stok İade Fişi"></option>
					</select>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfinput type="text" name="start_date" value="#dateformat(attributes.start_date, dateformat_style)#" placeholder="#getLang('','Başlangıç Tarihi',58053)#" validate="#validate_style#" maxlength="10">
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date, dateformat_style)#" placeholder="#getLang('','Bitiş Tarihi',57700)#" validate="#validate_style#" maxlength="10">
						<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
					</div>
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" onKeyUp="isNumber(this)" maxlength="3" value="#attributes.maxrows#" validate="integer" range="1,250" required="yes" message="#getLang('','Kayıt Sayısı Hatalı',57537)#">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-ch_company">
						<label class="col col-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="ch_consumer_id" id="ch_consumer_id"  value="<cfif len(attributes.ch_consumer_id)><cfoutput>#attributes.ch_consumer_id#</cfoutput></cfif>">
								<input type="hidden" name="ch_company_id" id="ch_company_id"  value="<cfif len(attributes.ch_company_id)><cfoutput>#attributes.ch_company_id#</cfoutput></cfif>">
								<cfinput type="text" name="ch_company" id="ch_company" value="#attributes.ch_company#" onFocus="AutoComplete_Create('ch_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',0,0,0','CONSUMER_ID,COMPANY_ID','ch_consumer_id,ch_company_id','','3','250');" autocomplete="off">
								<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3&field_comp_id=form.ch_company_id&field_member_name=form.ch_company&field_name=form.ch_company&field_consumer=form.ch_consumer_id</cfoutput>&keyword='+encodeURIComponent(document.form.ch_company.value))"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-project">
						<label class="col col-12"><cf_get_lang dictionary_id='57416.Proje'></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="project_id" id="project_id" value="<cfif len(attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
								<cfinput type="text" name="project_head" id="project_head" value="#attributes.project_head#" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
								<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57416.Proje'>" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=form.project_id&project_head=form.project_head')"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-department_name">
						<label class="col col-12"><cf_get_lang dictionary_id='58763.Depo'></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="department_id" id="department_id"  value="<cfif len(attributes.department_id)><cfoutput>#attributes.department_id#</cfoutput></cfif>">
								<input type="hidden" name="location_id" id="location_id" value="<cfif len(attributes.location_id)><cfoutput>#attributes.location_id#</cfoutput></cfif>">
								<input type="hidden" name="branch_id" id="branch_id" value="<cfif len(attributes.branch_id)><cfoutput>#attributes.branch_id#</cfoutput></cfif>">
								<cfinput type="text" name="department_name" id="department_name" value="#attributes.department_name#" onFocus="AutoComplete_Create('department_name','DEPARTMENT_HEAD,COMMENT','DEPARTMENT_NAME','get_department_location','','DEPARTMENT_ID,LOCATION_ID,BRANCH_ID','department_id,location_id,branch_id','','3','200');" autocomplete="off">
								<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='58763.Depo'>" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_stores_locations&form_name=form&field_location_id=location_id&field_name=department_name&field_id=department_id&branch_id=branch_id&is_no_sale=1</cfoutput>');"></span>
							</div>
						</div>
					</div>
					<cfif xml_is_branch eq 1>	
						<div class="form-group" id="item-branch_id">
							<label class="col col-12"><cf_get_lang dictionary_id='57453.Şube'></label>
							<div class="col col-12">
								<cf_wrkDepartmentBranch fieldId='branch_id1' selected_value='#attributes.branch_id1#' is_branch='1' width='150' is_deny_control='0'>
							</div>
						</div>
					</cfif>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-employee_name">
						<label class="col col-12"><cf_get_lang dictionary_id='38579.Satın/Teslim Alan'></label>
						<div class="input-group">
							<input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined('attributes.employee_id') and len(attributes.employee_id) and isdefined('attributes.employee_name') and len(attributes.employee_name)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
							<input type="text" name="employee_name" id="employee_name" value="<cfif isdefined('attributes.employee_id') and len(attributes.employee_id) and isdefined('attributes.employee_name') and len(attributes.employee_name)><cfoutput>#attributes.employee_name#</cfoutput></cfif>" onfocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','130');" autocomplete="off">	
							<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='38579.Satın/Teslim Alan'>" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=form.employee_id&field_name=form.employee_name&select_list=1');"></span>
						</div>
					</div>
					<div class="form-group" id="item-subscription_no">
						<label class="col col-12"><cf_get_lang dictionary_id='59774.Sistem No'></label>
						<div class="input-group">
							<input type="hidden" name="subscription_id" id="subscription_id" value="<cfif len(attributes.subscription_id)><cfoutput>#attributes.subscription_id#</cfoutput></cfif>">
							<cfinput type="text" name="subscription_no" id="subscription_no" value="#attributes.subscription_no#" onFocus="AutoComplete_Create('subscription_no','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO','get_subscription','2','SUBSCRIPTION_ID','subscription_id','','2','100');" autocomplete="off">
							<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='59774.Sistem No'>" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_subscription&field_id=form.subscription_id&field_no=form.subscription_no'</cfoutput>);"></span>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>

	<cfsavecontent variable="message"><cf_get_lang dictionary_id="56972.Demirbaş Hareketleri"></cfsavecontent>
	<cf_box title="#message#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<cfif xml_is_branch eq 1>	
						<th><cf_get_lang dictionary_id='57453.Şube'></th> 	
					</cfif>
					<th><cf_get_lang dictionary_id='57880.Belge No'></th>
					<th><cf_get_lang dictionary_id='58533.Belge Tipi'></th>
					<th><cf_get_lang dictionary_id='57879.İşlem Tarihi'></th>
					<th><cf_get_lang dictionary_id ='57673.Tutar'></th>
					<th><cf_get_lang dictionary_id ='58056.Döviz Tutar'></th>
					<th><cf_get_lang dictionary_id='57742.Tarih'></th>
					<th><cf_get_lang dictionary_id='57483.Kayıt'></th>
					<th width="20" class="header_icn_none text-center"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></th>
				</tr>
			</thead>
			<tbody>
				<cfif isdefined("attributes.form_varmi") and get_all_actions.recordcount>
					<cfquery name="get_money" datasource="#dsn2#">
						SELECT 
							MONEY,
							RATE2, 
							PERIOD_ID, 
							COMPANY_ID, 
							RECORD_DATE, 
							RECORD_EMP, 
							RECORD_IP, 
							UPDATE_DATE, 
							UPDATE_EMP, 
							UPDATE_IP
						FROM 
							SETUP_MONEY
					</cfquery>
					<cfset sistem_toplam = 0>
					<cfoutput query="get_money">
						<cfset 'toplam_#money#' = 0>
					</cfoutput>
					<cfset employee_id_list=''>
					<cfoutput query="get_all_actions" startrow="#attributes.startrow#" maxrows="#attributes.maxrowS#">
						<cfif len(RECORD_EMP) and not listfind(employee_id_list,RECORD_EMP)>
							<cfset employee_id_list=listappend(employee_id_list,RECORD_EMP)>
						</cfif>
					</cfoutput>
					<cfif listlen(employee_id_list)>
						<cfset employee_id_list=listsort(employee_id_list,"numeric","ASC",",")>
						<cfquery name="GET_EMPLOYEE_DETAIL" datasource="#DSN#">
							SELECT
								EMPLOYEE_NAME,
								EMPLOYEE_SURNAME,
								EMPLOYEE_ID
							FROM
								EMPLOYEES
							WHERE
								EMPLOYEE_ID IN (#employee_id_list#)
							ORDER BY
								EMPLOYEE_ID
						</cfquery>
					</cfif>
					<cfif attributes.page neq 1>
						<cfoutput query="get_all_actions" startrow="1" maxrows="#attributes.startrow-1#">
							<cfif len(TUTAR)>
								<cfset sistem_toplam = sistem_toplam + TUTAR>
							</cfif>
							<cfif len(TUTAR_DOVIZ)>
								<cfset 'toplam_#other_money#' = evaluate('toplam_#other_money#') +TUTAR_DOVIZ>
							</cfif>
						</cfoutput>	
					</cfif>		
					<cfoutput query="get_all_actions" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<cfif xml_is_branch eq 1>	
								<td>#branch_name#</td> 	
							</cfif>
							<td>
								<cfif PROCESS_TYPE eq 65>
									<a href="#request.self#?fuseaction=invent.add_invent_purchase&event=upd&invoice_id=#ACTION_ID#" class="tableyazi">#PAPER_NUMBER#</a>
								<cfset link_str="#request.self#?fuseaction=invent.add_invent_purchase&event=upd&invoice_id=#ACTION_ID#" >
								<cfelseif PROCESS_TYPE eq 66>
									<a href="#request.self#?fuseaction=invent.add_invent_sale&event=upd&invoice_id=#ACTION_ID#" class="tableyazi">#PAPER_NUMBER#</a>
								<cfset link_str="#request.self#?fuseaction=invent.add_invent_sale&event=upd&invoice_id=#ACTION_ID#" >
								<cfelseif PROCESS_TYPE eq 82>
									<a href="#request.self#?fuseaction=invent.add_invent_purchase&event=upd&ship_id=#ACTION_ID#" class="tableyazi">#PAPER_NUMBER#</a>
								<cfset link_str="#request.self#?fuseaction=invent.add_invent_purchase&event=upd&ship_id=#ACTION_ID#">
								<cfelseif PROCESS_TYPE eq 83>
									<a href="#request.self#?fuseaction=invent.add_invent_sale&event=upd&ship_id=#ACTION_ID#" class="tableyazi">#PAPER_NUMBER#</a>
								<cfset link_str="#request.self#?fuseaction=invent.add_invent_sale&event=upd&ship_id=#ACTION_ID#">
								<cfelseif PROCESS_TYPE eq 118>
									<a href="#request.self#?fuseaction=invent.add_invent_stock_fis&event=upd&fis_id=#ACTION_ID#" class="tableyazi">#PAPER_NUMBER#</a>
								<cfset link_str="#request.self#?fuseaction=invent.add_invent_stock_fis&event=upd&fis_id=#ACTION_ID#">
								<cfelseif PROCESS_TYPE eq 1182>
									<a href="#request.self#?fuseaction=invent.add_invent_stock_fis_return&event=upd&fis_id=#ACTION_ID#" class="tableyazi">#PAPER_NUMBER#</a>
								<cfset link_str="#request.self#?fuseaction=invent.add_invent_stock_fis_return&event=upd&fis_id=#ACTION_ID#">
								</cfif>
							</td>
							<td><a href="#link_str#" class="tableyazi">#get_process_name(PROCESS_TYPE)#</a></td>
							<td>#dateformat(PROCESS_DATE,dateformat_style)#</td>
							<td class="text-right">#tlformat(TUTAR)# #session.ep.money#</td>
							<td class="text-right">#tlformat(TUTAR_DOVIZ)# #OTHER_MONEY#</td>
								<cfif len(TUTAR)>
									<cfset sistem_toplam = sistem_toplam + TUTAR>
								</cfif>
								<cfif len(TUTAR_DOVIZ)>
									<cfset 'toplam_#other_money#' = evaluate('toplam_#other_money#') +TUTAR_DOVIZ>
								</cfif>
							<td>#dateformat(RECORD_DATE,dateformat_style)#</td>
							<td>
								#get_employee_detail.employee_name[listfind(employee_id_list,RECORD_EMP,',')]#&nbsp;
								#get_employee_detail.employee_surname[listfind(employee_id_list,RECORD_EMP,',')]#
					</td>
							<td align="center">
								<a href="#link_str#" class="tableyazi"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
							</td>
						</tr>
					</cfoutput>
					</tbody>
					<tfoot>
						<tr colspan="9">
							<td colspan="5" class="txtbold text-right"><cf_get_lang dictionary_id ='57492.Toplam'></td>
							<td class="txtbold text-right"><cfoutput>#tlformat(sistem_toplam)# #session.ep.money#</cfoutput></td>
							<td class="txtbold text-right">
								<cfoutput query="get_money">
									<cfif evaluate('toplam_#money#') gt 0>
										#Tlformat(evaluate('toplam_#money#'))# #money#<br/>
									</cfif>
								</cfoutput>
							</td>
							<td></td>
							<td></td>
						</tr>
					</tfoot>
				<cfelse>
					<tr>
						<td colspan="9"><cfif isdefined("attributes.form_varmi")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
					</tr>
				</cfif>
		</cf_grid_list>
	
	  	<cfset adres="invent.list_actions">
        <cfif isDefined('attributes.cat') and len(attributes.cat)>
			<cfset adres = "#adres#&cat=#attributes.cat#">
		</cfif>
        <cfif len(attributes.branch_id)>
			<cfset adres = "#adres#&branch_id=#attributes.branch_id#" >
        </cfif>
		<cfif len(attributes.belge_no)>
			<cfset adres = "#adres#&belge_no=#attributes.belge_no#" >
        </cfif>
		<cfif len(attributes.ch_company)>
			<cfset adres = "#adres#&ch_company=#attributes.ch_company#" >
        </cfif>
		<cfif len(attributes.ch_company_id)>
			<cfset adres = "#adres#&ch_company_id=#attributes.ch_company_id#" >
        </cfif>
		<cfif len(attributes.ch_consumer_id)>
			<cfset adres = "#adres#&ch_consumer_id=#attributes.ch_consumer_id#" >
        </cfif>
		<cfif len(attributes.project_head)>
			<cfset adres = "#adres#&project_head=#attributes.project_head#" >
        </cfif>
		<cfif len(attributes.department_name)>
			<cfset adres = "#adres#&department_name=#attributes.department_name#" >
        </cfif>
		<cfif len(attributes.employee_name)>
			<cfset adres = "#adres#&employee_name=#attributes.employee_name#" >
        </cfif>
		<cfif len(attributes.employee_id)>
			<cfset adres = "#adres#&employee_id=#attributes.employee_id#" >
        </cfif>
		<cfif len(attributes.subscription_no)>
			<cfset adres = "#adres#&subscription_no=#attributes.subscription_no#" >
        </cfif>
		<cfif len(attributes.subscription_id)>
			<cfset adres = "#adres#&subscription_id=#attributes.subscription_id#" >
        </cfif>
        <cfif isDefined('attributes.oby') and len(attributes.oby) >
			<cfset adres = "#adres#&oby=#attributes.oby#" >
        </cfif>
		<cfif isdate(attributes.start_date)>
			<cfset adres = "#adres#&start_date=#dateformat(attributes.start_date,dateformat_style)#" >
		</cfif>
		<cfif isdate(attributes.finish_date)>
			<cfset adres = "#adres#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#" >
		</cfif>
		<cfif isdefined("attributes.form_varmi") and len (attributes.form_varmi)>
			<cfset adres = "#adres#&form_varmi=#attributes.form_varmi#" >
		</cfif>
        <cf_paging page="#attributes.page#" 
            maxrows="#attributes.maxrows#" 
            totalrecords="#attributes.totalrecords#" 
            startrow="#attributes.startrow#" 
			adres="#adres#">
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('belge_no').focus();
</script>
