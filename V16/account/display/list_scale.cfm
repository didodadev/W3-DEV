<!--- Mizan Tablosu --->
<cfsetting showdebugoutput="no">
<cf_xml_page_edit fuseact="account.list_scale">
<cfinclude template="../query/get_moneys.cfm">
<cfinclude template="../query/get_branch_list.cfm">
<cfparam name="attributes.acc_code1_1" default="">
<cfparam name="attributes.acc_code2_1" default="">
<cfparam name="attributes.acc_code1_2" default="">
<cfparam name="attributes.acc_code2_2" default="">
<cfparam name="attributes.acc_code1_3" default="">
<cfparam name="attributes.acc_code2_3" default="">
<cfparam name="attributes.acc_code1_4" default="">
<cfparam name="attributes.acc_code2_4" default="">
<cfparam name="attributes.acc_code1_5" default="">
<cfparam name="attributes.acc_code2_5" default="">
<cfparam name="attributes.sub_accounts" default="0">
<cfparam name="attributes.acc_code_type" default="0">
<cfparam name="attributes.acc_branch_id" default="">
<cfparam name="attributes.acc_card_type" default="">
<cfparam name="attributes.expense_center_id" default="">
<cfparam name="attributes.expense_center_name" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.money_type_" default="">
<cfparam name="attributes.priority_type" default="">
<cfparam name="attributes.excel_getir" default="0">
<cfparam name="attributes.report_type" default="">
<cfif fuseaction contains "popup"><cfset is_popup = 1><cfelse><cfset is_popup = 0 ></cfif>
<cfif not (isdefined('attributes.date1') and isdate(attributes.date1))>
	<cfset attributes.date1 = dateformat(session.ep.period_start_date,dateformat_style)>
</cfif>
<cfif not (isdefined('attributes.date2') and isdate(attributes.date2))>
	<cfset attributes.date2 = dateformat(session.ep.period_finish_date,dateformat_style)>
</cfif>
<cfif isdate(attributes.date1) and isdate(attributes.date2)>
	<cf_date tarih="attributes.date1">
	<cf_date tarih="attributes.date2">	
</cfif>
<cfquery name="get_max_len" datasource="#dsn2#">
	SELECT MAX(len(replace(ACCOUNT_PLAN.ACCOUNT_CODE, '.', '.' + ' ')) - len(ACCOUNT_PLAN.ACCOUNT_CODE)) MAX_LEN FROM ACCOUNT_PLAN
</cfquery>
<cfif isdefined("attributes.form_varmi")>
	<cfinclude template="../query/get_scales.cfm">
	<cfparam name="attributes.totalrecords" default="#get_acc_remainder.recordcount#">
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfif not fusebox.fuseaction contains 'autoexcelpopuppage_'>
	<cfif attributes.maxrows gt 100><cfset attributes.maxrows=250></cfif>
</cfif>
<cfif isdate(attributes.date1) and isdate(attributes.date2)>
	<cfset attributes.date1 = dateformat(attributes.date1,dateformat_style)>
	<cfset attributes.date2 = dateformat(attributes.date2,dateformat_style)>
</cfif>
<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT DISTINCT
		MONEY,
		RATE2,
		RATE1 
	FROM 
		SETUP_MONEY 
	WHERE 
		MONEY_STATUS = 1
		AND PERIOD_ID = #session.ep.period_id#
</cfquery>
<cfset url_code = ''>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfif not fusebox.fuseaction contains 'autoexcelpopuppage_'>
			<cfform name="form" method="post" action="#request.self#?fuseaction=account.list_scale">	
				<input type="hidden" name="fintab_type" id="fintab_type" value="SCALE_TABLE">
				<input type="hidden" name="form_varmi" id="form_varmi" value="1">
					<cf_box_search>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57652.Hesap'></cfsavecontent>
						<cf_wrk_multi_account_code acc_code1_1='#attributes.acc_code1_1#' placeholder='#message# 1' acc_code2_1='#attributes.acc_code2_1#' acc_code1_2='#attributes.acc_code1_2#' acc_code2_2='#attributes.acc_code2_2#' acc_code1_3='#attributes.acc_code1_3#' acc_code2_3='#attributes.acc_code2_3#' acc_code1_4='#attributes.acc_code1_4#' acc_code2_4='#attributes.acc_code2_4#' acc_code1_5='#attributes.acc_code1_5#' acc_code2_5='#attributes.acc_code2_5#' is_multi='#is_select_multi_acc_code#' placeholder2='#message# 2'>
						<div class="form-group medium">
							<cfif isdefined('attributes.project_head') and len(attributes.project_head)>
								<cfset project_id_ = attributes.project_id>
							<cfelse>
								<cfset project_id_ = ''>
							</cfif>
							<cf_wrkproject
								project_id="#project_id_#"
								width="155"
								agreementno="1" customer="2" employee="3" priority="4" stage="5" allproject="1" formname="form"
								boxwidth="600"
								boxheight="400">
						</div>
						<div class="form-group medium">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang no ='87.Lütfen İşlem Başlangıç Tarihini Giriniz !'></cfsavecontent>
								<cfinput type="text" name="date1" id="date1" value="#attributes.date1#" required="Yes" validate="#validate_style#" message="#message#"  maxlength="10">
								<span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>
							</div>
						</div>
						<div class="form-group medium">
							<div class="input-group">
								<cfsavecontent variable="message1"><cf_get_lang no='31.Lütfen İşlem Bitiş Tarihini Giriniz !'></cfsavecontent>
								<cfinput type="text" name="date2" id="date2" value="#attributes.date2#" required="Yes" validate="#validate_style#" message="#message1#"  maxlength="10">
								<span class="input-group-addon"><cf_wrk_date_image date_field="date2"></span>
							</div>
						</div>
						<div class="form-group small">
							<select name="money" id="money" onChange="get_rate();">
								<cfoutput query="GET_MONEYS">
								<option value="#MONEY#" <cfif isdefined('attributes.money') and attributes.money eq MONEY>selected<cfelseif not isdefined('attributes.money') and MONEY eq SESSION.EP.MONEY>selected</cfif>>#MONEY#</option>
								</cfoutput>
							</select>                        
						</div>
						<div class="form-group small">
							<cfif not isdefined('attributes.rate')><cfset attributes.rate = 1></cfif>
							<cfif not isdefined('attributes.money')><cfset attributes.money = SESSION.EP.MONEY></cfif>
							<input type="hidden" name="old_money" id="old_money" value="<cfoutput>#attributes.money#</cfoutput>">
							<cfinput type="text" name="rate" id="rate" class="moneybox" value="#attributes.rate#"  onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" required="yes" >
						</div>
						<div class="form-group">
							<select name="money_type_" id="money_type_" >
								<option value="1" <cfif isDefined("attributes.money_type_") and attributes.money_type_ eq 1>selected</cfif>><cf_get_lang_main no="265.Döviz"> <cf_get_lang_main no="322.Seçiniz"></option>
								<option value="2" <cfif isDefined("attributes.money_type_") and attributes.money_type_ eq 2>selected</cfif>>2.<cf_get_lang_main no='265.Döviz'>
								<option value="3" <cfif isDefined("attributes.money_type_") and attributes.money_type_ eq 3>selected</cfif>><cf_get_lang_main no='709.Islem Dövizi'></option>
							</select>
						</div>
						<div class="form-group small">
							<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfinput type="text" name="maxrows" id="maxrows"  value="#attributes.maxrows#" validate="integer" range="1,250" required="yes" message="#message#">
						</div>
						<div class="form-group" id="item-excel_getir">
							<label><cf_get_lang_main no ='446.Excel Getir'><input name="excel_getir" id="excel_getir"  value="1" <cfif attributes.excel_getir eq 1>checked</cfif> type="checkbox"></label>
						</div>
						<cfif isdefined("attributes.form_varmi") and not listfindnocase(denied_pages,'account.popup_add_financial_table')>
							<div class="form-group">
								<!---<a href="javascript://" onClick="save_mizan_table();"><img src="/images/save.gif" title="<cf_get_lang no ='71.Mizanı Kaydet'>" alt="<cf_get_lang no ='71.Mizanı Kaydet'>"></a>--->
								<a class="ui-btn ui-btn-gray2"  onClick="save_mizan_table();"><i class="fa fa-save" title="<cf_get_lang no ='71.Mizanı Kaydet'>" alt="<cf_get_lang no ='71.Mizanı Kaydet'>"></i></a>
							</div>
						</cfif>   
						<div name="div_acc_hidden" id="div_acc_hidden"></div>
						<div class="form-group">
							<cf_wrk_search_button search_function='control_scale_detail()' button_type="3">
						</div>
					</cf_box_search>
					<cf_box_search_detail>
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
							<div class="form-group" id="item-priority_type">
								<label><cf_get_lang_main no="73.Öncelik"></label>
								<select name="priority_type" id="priority_type" >
									<option value="0"><cf_get_lang_main no="73.Öncelik"></option>
									<option value="1" <cfif attributes.priority_type eq 1>selected</cfif>><cf_get_lang_main no="1548.Rapor Tipi"> <cf_get_lang_main no="1532.Öncelikli"></option>
								</select>
							</div>
							<div class="form-group" id="item-report_type">
								<label><cf_get_lang_main no="1548.Rapor Tipi"></label>
								<select name="report_type" id="report_type" >
									<option value="0"><cf_get_lang_main no="1548.Rapor Tipi"></option>
									<option value="1" <cfif attributes.report_type eq 1>selected</cfif>><cf_get_lang_main no='160.Departman'></option>
									<option value="2" <cfif attributes.report_type eq 2>selected</cfif>><cf_get_lang_main no='41.Sube'></option>
									<option value="3" <cfif attributes.report_type eq 3>selected</cfif>><cf_get_lang_main no='4.Proje'></option>
									<option value="4" <cfif attributes.report_type eq 4>selected</cfif>><cf_get_lang_main no="573.Üst"> <cf_get_lang_main no="4.Proje"></option>
								</select>
							</div>
							<div class="form-group" id="item-sub_accounts">
								<label><cf_get_lang no ='137.Üst Hesaplar'></label>
								<select name="sub_accounts" id="sub_accounts" onChange="kontrol_report_type();" >
									<option value="0" <cfif attributes.sub_accounts eq 0>selected</cfif>><cf_get_lang no ='137.Üst Hesaplar'></option>
									<cfloop from="1" to="#get_max_len.max_len#" index="kk">
										<option value="<cfoutput>#kk#</cfoutput>" <cfif attributes.sub_accounts eq kk>selected</cfif>><cfoutput>#kk#</cfoutput>.<cf_get_lang no ='108.Alt Hesaplar'></option>
									</cfloop>
									<option value="-1" <cfif attributes.sub_accounts eq -1>selected</cfif>><cf_get_lang no ='138.Tüm Alt Hesaplar'></option>
								</select>
							</div>
							<div class="form-group" id="item-acc_code_type">
								<label><cf_get_lang_main no='1381.Tek Düzen'></label>
								<select name="acc_code_type" id="acc_code_type" >
									<option value="0" <cfif attributes.acc_code_type eq 0>selected</cfif>><cf_get_lang_main no='1381.Tek Düzen'></option>
									<option value="1" <cfif attributes.acc_code_type eq 1>selected</cfif>><cf_get_lang_main no='896.UFRS'></option>
								</select>
							</div>
						</div>
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
							<div class="form-group" id="item-acc_card_type">
								<label><cf_get_lang_main no='1344.Açılış Fişi'></label>
								<cfquery name="get_acc_card_type" datasource="#dsn3#">
									SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (10,11,12,13,14,19) ORDER BY PROCESS_TYPE
								</cfquery>
								<select multiple="multiple" name="acc_card_type" id="acc_card_type" >
									<cfoutput query="get_acc_card_type" group="process_type">
										<cfoutput>
										<option value="#process_type#-#process_cat_id#" <cfif listfind(attributes.acc_card_type,'#process_type#-#process_cat_id#',',')>selected</cfif>>#process_cat#</option>
										</cfoutput>
									</cfoutput>
								</select>
							</div>
							<div class="form-group" id="item-acc_branch_id">
								<label><cf_get_lang_main no='41.Şube'></label>
								<select multiple="multiple" name="acc_branch_id" id="acc_branch_id" >
									<optgroup label="<cf_get_lang_main no='41.Şube'>"></optgroup>
									<cfoutput query="get_branchs">
										<option value="#BRANCH_ID#" <cfif isdefined('attributes.acc_branch_id') and listfind(attributes.acc_branch_id,BRANCH_ID)>selected</cfif>>#BRANCH_NAME#</option>
									</cfoutput>
								</select>
							</div>
							<div class="form-group" id="item-is_balance_acc">
								<label><cfoutput>#getlang('account',329)#</cfoutput></label>
								<div>
									<input type="checkbox" name="is_balance_acc" id="is_balance_acc" value="1" <cfif isdefined('attributes.is_balance_acc')>checked</cfif>>
								</div>
							</div>
						</div>
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
							<div class="form-group" id="item-is_quantity">
								<label><cf_get_lang no ='265.Miktar Göster'></label>
								<div>
									<input type="checkbox" name="is_quantity" id="is_quantity" value="1" <cfif isdefined('attributes.is_quantity')>checked</cfif>>
								</div>	
							</div>
							<div class="form-group" id="item-show_main_account">
								<label><cf_get_lang no="292.Üst Hesaplar Gelmesin"></label>
								<div>
									<input type="checkbox" name="show_main_account" id="show_main_account" value="0" <cfif isdefined('attributes.show_main_account')>checked<cfelseif attributes.sub_accounts eq 0>disabled</cfif>>
								</div>
							</div>
							<div class="form-group" id="item-no_process_accounts">
								<label><cf_get_lang no="293.Hareket Görmeyenleri Getirme"></label>
								<div>
									<input type="checkbox" name="no_process_accounts" id="no_process_accounts" value="0" <cfif isdefined('attributes.no_process_accounts')>checked</cfif>>
								</div>	
							</div>
							<div class="form-group" id="item-is_bakiye">
								<label><cf_get_lang no ='140.Sadece Bakiyesi Olanlar'></label>
								<div>
									<input type="checkbox" name="is_bakiye" id="is_bakiye" value="1" <cfif isdefined('attributes.is_bakiye')>checked</cfif>>
								</div>
							</div>
						</div>
					</cf_box_search_detail>
			</cfform>
		</cfif>
	</cf_box>
<cf_box title="#getLang('account',4)#" uidrop="1" hide_table_column="1" scroll="0">
	<cfoutput>
		<cfset adres = ''>
		<cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)>
			<cfset adres = adres&'&acc_card_type=#attributes.acc_card_type#'>
		</cfif>
		<cfif isdefined('attributes.acc_branch_id') and len(attributes.acc_branch_id)>
			<cfset adres = adres&'&acc_branch_id=#attributes.acc_branch_id#'>
		</cfif>
		<cfif isdefined('attributes.priority_type') and len(attributes.priority_type)>
			<cfset adres = adres&'&priority_type=#attributes.priority_type#'>
		</cfif>
		<cfif isdefined('attributes.report_type') and len(attributes.report_type)>
			<cfset adres = adres&'&report_type=#attributes.report_type#'>
		</cfif>
		<cfif isdefined('attributes.is_quantity') and len(attributes.is_quantity)>
			<cfset adres = adres&'&is_quantity=#attributes.is_quantity#'>
		</cfif>
		<cfif isdefined('attributes.show_main_account') and len(attributes.show_main_account)>
			<cfset adres = adres&'&show_main_account=#attributes.show_main_account#'>
		</cfif>
		<cfif isdefined('attributes.sub_accounts') and len(attributes.sub_accounts)>
			<cfset adres = adres&'&sub_accounts=#attributes.sub_accounts#'>
		</cfif>
		<cfif isdefined('attributes.acc_code_type') and len(attributes.acc_code_type)>
			<cfset adres = adres&'&acc_code_type=#attributes.acc_code_type#'>
		</cfif>
		<cfif isdefined('attributes.is_bakiye') and len(attributes.is_bakiye)>
			<cfset adres = adres&'&is_bakiye=#attributes.is_bakiye#'>
		</cfif>
		<cfif isdefined('attributes.money_type_') and len(attributes.money_type_)>
			<cfset adres = adres&'&money_type_=#attributes.money_type_#'>
		</cfif>
		<cfif isdefined('attributes.money') and len(attributes.money)>
			<cfset adres = adres&'&money=#attributes.money#'>
		</cfif>
		<cfif isdefined('attributes.old_money') and len(attributes.old_money)>
			<cfset adres = adres&'&old_money=#attributes.old_money#'>
		</cfif>
		<cfif isdefined('attributes.rate') and len(attributes.rate)>
			<cfset adres = adres&'&rate=#attributes.rate#'>
		</cfif>
		<cfif isdefined('attributes.is_excel') and len(attributes.is_excel)>
			<cfset adres = adres&'&is_excel=#attributes.is_excel#'>
		</cfif>
		<cfif isdefined('attributes.pdf_aktar') and len(attributes.pdf_aktar)>
			<cfset adres = adres&'&pdf_aktar=#attributes.pdf_aktar#'>
		</cfif>
		<cfif isdefined('attributes.project_id') and len(attributes.project_id)>
			<cfset adres = adres&'&project_id=#attributes.project_id#'>
		</cfif>
		<cfif isdefined('attributes.project_head') and len(attributes.project_head)>
			<cfset adres = adres&'&project_head=#attributes.project_head#'>
		</cfif>
		<cfif isdefined('attributes.no_process_accounts') and len(attributes.no_process_accounts)>
			<cfset adres = adres&'&no_process_accounts=#attributes.no_process_accounts#'>
		</cfif>
		<cfif isdefined('attributes.date1') and len(attributes.date1)>
			<cfset adres = adres&'&date1=#attributes.date1#'>
		</cfif>
		<cfif isdefined('attributes.date2') and len(attributes.date2)>
			<cfset adres = adres&'&date2=#attributes.date2#'>
		</cfif>
		<ul class="link-list">
			<li><a href="#request.self#?fuseaction=#attributes.fuseaction#&form_varmi=1#adres#">0</a></li>
			<li><a href="#request.self#?fuseaction=#attributes.fuseaction#&keyword=1&form_varmi=1#adres#">1</a></li>
			<li><a href="#request.self#?fuseaction=#attributes.fuseaction#&keyword=2&form_varmi=1#adres#">2</a></li>
			<li><a href="#request.self#?fuseaction=#attributes.fuseaction#&keyword=3&form_varmi=1#adres#">3</a></li>
			<li><a href="#request.self#?fuseaction=#attributes.fuseaction#&keyword=4&form_varmi=1#adres#">4</a></li>
			<li><a href="#request.self#?fuseaction=#attributes.fuseaction#&keyword=5&form_varmi=1#adres#">5</a></li>
			<li><a href="#request.self#?fuseaction=#attributes.fuseaction#&keyword=6&form_varmi=1#adres#">6</a></li>
			<li><a href="#request.self#?fuseaction=#attributes.fuseaction#&keyword=7&form_varmi=1#adres#">7</a></li>
			<li><a href="#request.self#?fuseaction=#attributes.fuseaction#&keyword=8&form_varmi=1#adres#">8</a></li>
			<li><a href="#request.self#?fuseaction=#attributes.fuseaction#&keyword=9&form_varmi=1#adres#">9</a></li>
		</ul>
	</cfoutput>
<cfif isdefined("attributes.form_varmi")>
<cfset setLocale("tr_TR")>
	<cfif isdefined("attributes.pdf_aktar")>
		<cfinclude template="../../objects/display/mizan_raporu_pdf.cfm">
	<cfelse>
		<cfsavecontent variable="cont">
            <!-- sil -->
            <cfif isdefined("attributes.excel_getir") and attributes.excel_getir eq 1>
    	        <cfset type_ = 1>
                <cfset attributes.maxrows = get_acc_remainder.recordcount>
            <cfelse>
	            <cfset type_ = 0>
			</cfif>
			<cfif isdefined('attributes.excel_getir') and attributes.excel_getir eq 1>
				<cfset filename="mizan#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
				<cfheader name="Expires" value="#Now()#">
				<cfcontent type="application/vnd.msexcel;charset=utf-16">
				<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
				<meta http-equiv="Content-Type" content="text/plain; charset=utf-16">
				<cfset attributes.startrow=1>
				<cfset attributes.maxrows=get_acc_remainder.recordcount>
			</cfif> 
            <cf_grid_list>
            	<thead>	
					<cfset colspan_info = 2>	
					<cfif attributes.report_type eq 1>
						<cfset colspan_info = colspan_info + 1>	
					<cfelseif attributes.report_type eq 2>
						<cfset colspan_info = colspan_info + 1>	
					<cfelseif attributes.report_type eq 3>
						<cfset colspan_info = colspan_info + 1>	
					<cfelseif attributes.report_type eq 4>
						<cfset colspan_info = colspan_info + 1>	
					</cfif>
					<cfif isdefined('attributes.is_quantity')>
						<cfset colspan_info = colspan_info + 2>	
					</cfif>
					<cfset colspan_info = colspan_info + 4>	
					<cfif isdefined('attributes.money_type_') and attributes.money_type_ eq 2>
						<cfset colspan_info = colspan_info + 4>	
					</cfif>
					<cfif isdefined('attributes.money_type_') and attributes.money_type_ eq 3>
						<cfset colspan_info = colspan_info + 5>	
					</cfif>
                    <!--- <tr>
                        <th colspan="5" nowrap="nowrap"><cfoutput>#session.ep.company_nick# - #attributes.date1# - #attributes.date2#<cf_get_lang no ='142.Dönemi'>#attributes.money#<cf_get_lang no ='141.Mizan Planı'> </cfoutput></th>
                        <th style="text-align:right"><cfoutput>#dateformat(now(),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,now()),timeformat_style)#</cfoutput></th>
                    </tr> --->
					<tr>
						<th><cfif attributes.acc_code_type eq 1><cf_get_lang no='22.UFRS Hesap Kodu'><cfelse><cf_get_lang no='37.Hesap Kodu'></cfif></th>
						<th><cfif attributes.acc_code_type eq 1><cf_get_lang no ='34.UFRS Hesap Adı'><cfelse><cf_get_lang no='38.Hesap Adı'></cfif></th>
						<cfif attributes.report_type eq 1>
							<th><cf_get_lang_main no="41.Sube">-<cf_get_lang_main no="160.Departman"></th>
						<cfelseif attributes.report_type eq 2>
							<th><cf_get_lang_main no="41.Sube"></th>
						<cfelseif attributes.report_type eq 3>
							<th><cf_get_lang_main no="4.Proje"></th>
						<cfelseif attributes.report_type eq 4>
							<th><cf_get_lang_main no="4.Proje"></th>
						</cfif>
						<cfif isdefined('attributes.is_quantity')>
							<th style="text-align:right;"><cf_get_lang_main no='175.Borç'><br><cf_get_lang_main no='223.Miktar'></th>
							<th style="text-align:right;"><cf_get_lang_main no='176.Alacak'><cf_get_lang_main no='223.Miktar'></th>
						</cfif>
						<th style="text-align:right;" width="120"><cf_get_lang_main no='175.Borç'></th>
						<th style="text-align:right;" width="120"><cf_get_lang_main no='176.Alacak'></th>
						<th style="text-align:right;" width="120"><cf_get_lang no ='179.Bakiye Borç'></th>
						<th style="text-align:right;" width="120"><cf_get_lang no ='180.Bakiye Alacak'></th>
						<cfif isdefined('attributes.money_type_') and attributes.money_type_ eq 2><!--- sistem 2.dovizi bazında mizan --->
							<cfoutput>
                                <th style="text-align:right;" width="120">#session.ep.money2# <cf_get_lang_main no='175.Borç'></th>
                                <th style="text-align:right;" width="120">#session.ep.money2# <cf_get_lang_main no='176.Alacak'></th>
                                <th style="text-align:right;" width="120">#session.ep.money2# <cf_get_lang no ='179.Bakiye Borç'></th>
                                <th style="text-align:right;" width="120">#session.ep.money2# <cf_get_lang no ='180.Bakiye Alacak'></th>
                            </cfoutput>
						</cfif>
						<cfif isdefined('attributes.money_type_') and attributes.money_type_ eq 3><!--- islem dovizi bazında mizan --->
							<th style="text-align:right;" width="120"><cf_get_lang_main no='709.İşlem Dövizi'><cf_get_lang_main no='175.Borç'></th>
							<th style="text-align:right;" width="120"><cf_get_lang_main no='709.İşlem Dövizi'><cf_get_lang_main no='176.Alacak'></th>
                            <th style="text-align:right;" width="120"><cf_get_lang_main no ='1452.Para Birimi'></th>
							<th style="text-align:right;" width="120"><cf_get_lang_main no='709.İşlem Dövizi'><cf_get_lang no ='179.Bakiye Borç'></th>
							<th style="text-align:right;" width="120"><cf_get_lang_main no='709.İşlem Dövizi'><cf_get_lang no ='180.Bakiye Alacak'></th>
						</cfif>
					</tr>
                </thead>
                <tbody>
					<cfif isdefined("attributes.form_varmi") and get_acc_remainder.recordcount>
						<cfscript>
							total_quantity_borc = 0;
							total_quantity_alacak = 0;
							total_quantity_borc_all = 0;
							total_quantity_alacak_all = 0;
							total_borc = 0;
							total_alacak = 0;
							total_bakiye = 0;
							total_borc_all = 0;
							total_alacak_all = 0;
							total_bakiye_all = 0;
							borc_bakiye_tpl = 0;
							alacak_bakiye_tpl = 0;
							total_borc2 = 0; /*total_borc2, total_alacak2, total_bakiye2 sistem 2.dovizi bazındaki tutarları gosterir*/
							total_alacak2 = 0;
							total_bakiye2 = 0;
							total_borc_all_2 = 0;
							total_alacak_all_2 = 0;
							total_bakiye_all_2 = 0;
							borc_bakiye_tpl_2 = 0;
							acc_branch_id_list='';
							alacak_bakiye_tpl_2 = 0;
							acc_dept_id_list='';
							acc_pro_id_list='';
							row_colspan_number_=2;
							if(attributes.report_type eq 1)
								row_colspan_number_=row_colspan_number_+1;
							else if(attributes.report_type eq 2)
								row_colspan_number_=row_colspan_number_+1;
							else if(attributes.report_type eq 3)
								row_colspan_number_=row_colspan_number_+1;
							else if(attributes.report_type eq 4)
								row_colspan_number_=row_colspan_number_+1;
						</cfscript>
						<cfoutput query="get_money">
							<cfset 'doviz_borc_#money#' = 0>
							<cfset 'doviz_alacak_#money#' = 0>
							<cfset 'bakiye_borc_#money#' = 0>
							<cfset 'bakiye_alacak_#money#' = 0>
							<cfset 'doviz_borc_#money#_2' = 0>
							<cfset 'doviz_alacak_#money#_2' = 0>
							<cfset 'bakiye_borc_#money#_2' = 0>
							<cfset 'bakiye_alacak_#money#_2' = 0>
						</cfoutput>
                        <cfset new_list = ''>
                        <cfset new_list_2 = ''>
						<cfset rate_ = filterNum(attributes.rate,session.ep.our_company_info.rate_round_num)>
						<!--- Bir haneli ve iki haneli üst hesaplar için ilk olarak 0 değeri atanıyor. ERU --->
						<cfloop from="0" to="99" index = "i">
							<cfset "a_#i#" = 0>
							<cfset "b_#i#" = 0>
							<cfset "b_a_#i#" = 0>
							<cfset "b_b_#i#" = 0>
						</cfloop>
						<!--- İlk hanesi ve 2. hanesi aynı olan alt hesapların bakiyeleri  üst hesaplarda toplanıyor. ERU--->
						<cfoutput query="get_acc_remainder">
							
							<cfif len(ACCOUNT_CODE) eq 3>
								<cfset c = left(ACCOUNT_CODE,1)>
								<!---<cfset "a_#c#" = evaluate("a_#c#") + ALACAK>
								<cfset "b_#c#" = evaluate("b_#c#") + BORC> --->
								<cfset "a_#c#" = precisionEvaluate(evaluate("a_#c#") + ALACAK)>
								<cfset "b_#c#" = precisionEvaluate(evaluate("b_#c#") + BORC)>
								<cfif BORC GT ALACAK>
									<cfset "b_b_#c#" = evaluate("b_b_#c#") + BAKIYE>
								<cfelseif BORC LT ALACAK>
									<cfset "b_a_#c#" = evaluate("b_a_#c#") + BAKIYE>
								</cfif>							
								<cfset d = left(ACCOUNT_CODE,2)>	
								<!---	<cfset "a_#d#" = evaluate("a_#d#") + ALACAK>
									<cfset "b_#d#" = evaluate("b_#d#") + BORC> --->
									<cfset "a_#d#" = precisionEvaluate(evaluate("a_#d#") + ALACAK)>
									<cfset "b_#d#" = precisionEvaluate(evaluate("b_#d#") + BORC)>
								<cfif BORC GT ALACAK>
									<cfset "b_b_#d#" = evaluate("b_b_#d#") + BAKIYE>	
								<cfelseif BORC LT ALACAK>
									<cfset "b_a_#d#" = evaluate("b_a_#d#") + BAKIYE>
								</cfif>
							</cfif>
						</cfoutput>
						<cfif attributes.startrow gt 1>
							<cfoutput query="get_acc_remainder" startrow="1" maxrows="#attributes.startrow-1#">								
								<cfset "is_exist_#replacelist(listfirst(account_code,'.'),' ','_')#" = 1>								
								<cfif not listFind(new_list,replacelist(listfirst(account_code,'.'),' ','_'))>
									<cfset new_list = listAppend(new_list,replacelist(listfirst(account_code,'.'),' ','_'),',')>
									<cfset url_code = '#url_code#&is_exist_#replacelist(listfirst(account_code,'.'),' ','_')#=1'>
									<cfset new_acc_code = replacelist(listfirst(account_code,'.'),' ','_')>
								</cfif>
								<cfif not isdefined("is_exist_#new_acc_code#") or listlen(ACCOUNT_CODE,'.') eq 1 or isdefined("attributes.show_main_account")>
									<cfif isdefined('attributes.is_quantity')>
										<cfset total_quantity_borc=precisionEvaluate(total_quantity_borc+QUANTITY_BORC)>
										<cfset total_quantity_alacak=precisionEvaluate(total_quantity_alacak+QUANTITY_ALACAK)>
									</cfif>
									<!--- sistem para birimi devredenleri hesaplanıyor --->
									<!---<cfset total_borc=total_borc+(BORC/attributes.rate)>---->
									<cfset total_borc=precisionEvaluate(total_borc+(BORC/attributes.rate))>
									<cfset total_alacak=precisionEvaluate(total_alacak+(ALACAK/rate_))>
									<cfset total_bakiye=precisionEvaluate(total_bakiye+(BAKIYE/rate_))>							
									<cfif BORC GT ALACAK>
										<!---<cfset borc_bakiye_tpl=borc_bakiye_tpl+abs(BAKIYE/rate_)>--->
										<cfset borc_bakiye_tpl=precisionEvaluate(borc_bakiye_tpl+abs(BAKIYE/rate_))>
									<cfelse>
										<cfset alacak_bakiye_tpl=precisionEvaluate(alacak_bakiye_tpl+abs(BAKIYE/rate_))>
									</cfif>
									<!--- sistem 2.para birimi devredenleri hesaplanıyor --->
									<cfif isdefined('attributes.money_type_') and attributes.money_type_ eq 2>
										<cfset total_borc2 = total_borc2 + BORC_2>
										<cfset total_alacak2 = total_alacak2 + ALACAK_2>
										<cfset total_bakiye2 = total_bakiye2 + BAKIYE_2>
										<cfif BORC_2 GT ALACAK_2>
											<cfset borc_bakiye_tpl_2 = borc_bakiye_tpl_2 + abs(BAKIYE_2)>
										<cfelse>
											<cfset alacak_bakiye_tpl_2 = alacak_bakiye_tpl_2 + abs(BAKIYE_2)>
										</cfif>
									<cfelseif isdefined('attributes.money_type_') and attributes.money_type_ eq 3>
										<cfset 'doviz_borc_#OTHER_CURRENCY#_2' = evaluate('doviz_borc_#OTHER_CURRENCY#_2') + OTHER_BORC>
										<cfset 'doviz_alacak_#OTHER_CURRENCY#_2' = evaluate('doviz_alacak_#OTHER_CURRENCY#_2') + OTHER_ALACAK>
										<cfif OTHER_BORC GT OTHER_ALACAK>
											<cfset 'bakiye_borc_#OTHER_CURRENCY#_2' = evaluate('bakiye_borc_#OTHER_CURRENCY#_2') + OTHER_BAKIYE>
										<cfelseif OTHER_BORC LT OTHER_ALACAK>
											<cfset 'bakiye_alacak_#OTHER_CURRENCY#_2' = evaluate('bakiye_alacak_#OTHER_CURRENCY#_2') + abs(OTHER_BAKIYE)>
										</cfif>
									</cfif>
								</cfif>
							</cfoutput>							
                            <cfoutput>
                                <tr>
                                    <td colspan="#row_colspan_number_#"> <cf_get_lang_main no='622.Devreden'>: </td>
                                <cfif isdefined('attributes.is_quantity')>
                                    <td style="text-align:right;" class="txtbold">#lsnumberFormat(total_quantity_borc,',__.00')#</td>
                                    <td style="text-align:right;" class="txtbold">#lsnumberFormat(total_quantity_alacak)#</td>
                                </cfif>
                                <td style="text-align:right;" class="txtbold">#lsnumberFormat(total_borc,',__.00')#</td>
                                <td style="text-align:right;" class="txtbold">#lsnumberFormat(total_alacak,',__.00')#</td>
                                <td style="text-align:right;" class="txtbold">#lsnumberFormat(abs(borc_bakiye_tpl),',__.00')#</td>
                                <td style="text-align:right;" class="txtbold">#lsnumberFormat(abs(alacak_bakiye_tpl),',__.00')#</td>
                                <cfif isdefined('attributes.money_type_') and attributes.money_type_ eq 2>
                                    <td style="text-align:right;" class="txtbold">#TLFormat(total_borc2)#</td>
                                    <td style="text-align:right;" class="txtbold">#TLFormat(total_alacak2)#</td>
                                    <td style="text-align:right;" class="txtbold">#TLFormat(abs(borc_bakiye_tpl_2))#</td>
                                    <td style="text-align:right;" class="txtbold">#TLFormat(abs(alacak_bakiye_tpl_2))#</td>
                                </cfif>
								<cfif isdefined('attributes.money_type_') and attributes.money_type_ eq 3>
									<td style="text-align:right;" class="txtbold">
										<cfloop query = "get_money">
											#TLFormat(evaluate('doviz_borc_#money#_2'))# #money# <br>
										</cfloop>
									</td>
									<td style="text-align:right;" class="txtbold">
										<cfloop query = "get_money">
											#TLFormat(evaluate('doviz_alacak_#money#_2'))# #money# <br>
										</cfloop>
									</td>
									<td style="text-align:right;" class="txtbold">
										&nbsp;
									</td>
									<td style="text-align:right;" class="txtbold">
										<cfloop query = "get_money">
											#TLFormat(evaluate('bakiye_alacak_#money#_2'))# #money# <br>
										</cfloop>
									</td>
									<td style="text-align:right;" class="txtbold">
										<cfloop query = "get_money">
											#TLFormat(evaluate('doviz_borc_#money#_2'))# #money# <br>
										</cfloop>
									</td>
                                </cfif>
                                </tr>
                        	</cfoutput>
						</cfif>
						<cfif len(attributes.report_type)>
							<cfoutput query="get_acc_remainder" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
								<cfif attributes.report_type eq 1 and len(department_id) and not listfind(acc_dept_id_list,department_id)>
									<cfset acc_dept_id_list=listappend(acc_dept_id_list,department_id)>
								<cfelseif attributes.report_type eq 2 and len(branch_id) and not listfind(acc_branch_id_list,branch_id)>
									<cfset acc_branch_id_list=listappend(acc_branch_id_list,branch_id)>
								<cfelseif (attributes.report_type eq 3 or attributes.report_type eq 4) and len(acc_project_id) and not listfind(acc_pro_id_list,acc_project_id)>
									<cfset acc_pro_id_list=listappend(acc_pro_id_list,acc_project_id)>
								</cfif>
							</cfoutput>
							<cfif len(acc_dept_id_list)>
								<cfquery name="get_acc_dept" datasource="#dsn#">
									SELECT
										D.DEPARTMENT_ID,
										D.DEPARTMENT_HEAD,
										B.BRANCH_NAME
									FROM
										DEPARTMENT D,
										BRANCH B
									WHERE
										D.BRANCH_ID=B.BRANCH_ID
										AND D.DEPARTMENT_ID IN (#acc_dept_id_list#)
									ORDER BY
										D.DEPARTMENT_ID
								</cfquery>
								<cfset acc_dept_id_list=listsort(valuelist(get_acc_dept.DEPARTMENT_ID),'numeric','asc')>
							<cfelseif len(acc_branch_id_list)>
								<cfif len(acc_branch_id_list)>
									<cfquery name="get_acc_dept" datasource="#dsn#">
										SELECT
											B.BRANCH_ID,
											B.BRANCH_NAME
										FROM
											BRANCH B
										WHERE
											B.BRANCH_ID IN (#acc_branch_id_list#)
										ORDER BY
											B.BRANCH_ID
									</cfquery>
									<cfset acc_branch_id_list=listsort(valuelist(get_acc_dept.BRANCH_ID),'numeric','asc')>
								</cfif>
							</cfif>
							<cfif len(acc_pro_id_list)>
								<cfquery name="get_pro_detail" datasource="#dsn#">
									SELECT
										PROJECT_ID,
										PROJECT_HEAD
									FROM
										PRO_PROJECTS               
									WHERE
										PROJECT_ID IN (#acc_pro_id_list#)
									ORDER BY 
										PROJECT_ID
								</cfquery>
								<cfset acc_pro_id_list=listsort(valuelist(get_pro_detail.PROJECT_ID),'numeric','asc')>
							</cfif>
						</cfif>
						<!--- sadece bakiyesi olan üst hesaplar ERU --->
						<cfoutput query="get_acc_remainder" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfset sonuc_ = precisionEvaluate(BORC  - ALACAK)>
						<cfif 
						(
							isdefined("attributes.is_bakiye") 
							and 
							(
								(
									(len(ACCOUNT_CODE) eq 1 or len(ACCOUNT_CODE) eq 2) AND
									(
									   evaluate("b_#left(ACCOUNT_CODE,2)#") neq 0 
									or evaluate("b_#left(ACCOUNT_CODE,1)#") neq 0 
									or evaluate("a_#left(ACCOUNT_CODE,2)#") neq 0 
									or evaluate("a_#left(ACCOUNT_CODE,1)#") neq 0 
									)
								)
									OR sonuc_ NEQ 0 
							)
						) OR not isdefined("attributes.is_bakiye")>
						<cfif 
						(
							isdefined("attributes.no_process_accounts") 
							and 
							( 
								(
									len(ACCOUNT_CODE) eq 1 AND evaluate("b_#left(ACCOUNT_CODE,1)#") neq 0 AND evaluate("a_#left(ACCOUNT_CODE,1)#") neq 0 
								)
								OR 
								(
									len(ACCOUNT_CODE) eq 2 AND evaluate("b_#left(ACCOUNT_CODE,2)#") neq 0 AND evaluate("a_#left(ACCOUNT_CODE,2)#") neq 0 
								)
							)		
								OR sonuc_ NEQ 0 
								OR (BORC NEQ 0 AND ALACAK NEQ 0)
							
						) OR not isdefined("attributes.no_process_accounts")>
							<cfset ikinci_hane_ = mid(ACCOUNT_CODE,2,1)>
							<cfset ilk_hane_ = left(ACCOUNT_CODE,1)>
						  	<cfif not Find(".",account_code) or listlen(account_code,".") eq 2><cfset str_line = 'txtbold'><cfelse><cfset str_line = ''></cfif>
							<cfset new_acc_code = filterSpecialChars(listfirst(account_code,'.'))>
							<tr>
							<td align="left" width="150" class="#str_line#" >
								<cfif type_ eq 0>
                                    <!-- sil --><cfif ListLen(account_code,".") neq 1><cfloop from="1" to="#ListLen(account_code,".")#" index="i">&nbsp;</cfloop></cfif><!-- sil -->
                                </cfif>
                                #account_code#
							</td>
							<td  align="left" nowrap class="#str_line#">
                            <cfif type_ eq 0>
                                <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=account.popup_list_scale&sub_accounts=#attributes.sub_accounts#&str_account_code=#account_code#&acc_code_type=#attributes.acc_code_type#&acc_branch_id=#attributes.acc_branch_id#&project_id=#attributes.project_id#&date1=#attributes.date1#&date2=#attributes.date2#&report_type=#attributes.report_type#&priority_type=#attributes.priority_type#&money_type_=#attributes.money_type_#','wwide');">
                                    #account_name#
                                </a>
                            <cfelse>
                            	#account_name#
                            </cfif> 
							</td>
							<cfif attributes.report_type eq 1>
								<td class="#str_line#">
									<cfif len(acc_dept_id_list) and len(department_id)>
										#get_acc_dept.BRANCH_NAME[listfind(acc_dept_id_list,department_id)]#-#get_acc_dept.DEPARTMENT_HEAD[listfind(acc_dept_id_list,department_id)]#
									</cfif>
								</td>
							<cfelseif attributes.report_type eq 2>
								<td class="#str_line#">
									<cfif len(acc_branch_id_list) and len(branch_id)>
										#get_acc_dept.BRANCH_NAME[listfind(acc_branch_id_list,branch_id)]#
									</cfif>
								</td>
							<cfelseif attributes.report_type eq 3 or attributes.report_type eq 4>
								<td class="#str_line#">
									<cfif len(acc_pro_id_list) and len(acc_project_id)>
										#get_pro_detail.PROJECT_HEAD[listfind(acc_pro_id_list,acc_project_id)]#
									</cfif>
								</td>
							</cfif>
							<cfif isdefined('attributes.is_quantity')>
								<td style="text-align:right;" class="#str_line#" format="numeric">#TLFormat(QUANTITY_BORC)#</td>
								<td style="text-align:right;" class="#str_line#" format="numeric">#TLFormat(QUANTITY_ALACAK)#</td>
							</cfif>
							<cfset BORC_ = precisionEvaluate(BORC / rate_)>
							<cfset ALACAK_ = precisionEvaluate(ALACAK / rate_)>
							<cfset BAKIYE_ = precisionEvaluate(BAKIYE / rate_)>
							<td style="text-align:right;" class="#str_line#" format="numeric">
								<cfif isdefined("ilk_hane_") and len(ACCOUNT_CODE) eq 1>	
									#lsnumberFormat((precisionEvaluate(evaluate("b_#left(ACCOUNT_CODE,1)#"))),',__.00')# 
									<cfset borc_top = precisionEvaluate(evaluate("b_#left(ACCOUNT_CODE,1)#"))>
								<cfelseif isdefined("ikinci_hane_") and len(ACCOUNT_CODE) eq 2>			
									#lsnumberFormat(precisionEvaluate(evaluate("b_#left(ACCOUNT_CODE,2)#")),',__.00')# 
									<cfset borc_top = precisionEvaluate(evaluate("b_#left(ACCOUNT_CODE,2)#"))>
								<cfelseif abs(BORC_) GT 0 >
								 #lsnumberFormat(BORC_,',__.00')# 
									<cfset borc_top = BORC_>
								<cfelse>
									<cfset borc_top = 0>
								</cfif>		
							</td>
							<td style="text-align:right;" class="#str_line#" format="numeric">
								<cfif isdefined("ilk_hane_") and len(ACCOUNT_CODE) eq 1>
									#lsnumberFormat(precisionEvaluate(evaluate("a_#left(ACCOUNT_CODE,1)#")),',__.00')# 
									<cfset alac_top = precisionEvaluate(evaluate("a_#left(ACCOUNT_CODE,1)#"))>
								<cfelseif isdefined("ikinci_hane_") and len(ACCOUNT_CODE) eq 2>			
									#lsnumberFormat(precisionEvaluate(evaluate("a_#left(ACCOUNT_CODE,2)#")),',__.00')# 
									<cfset alac_top = precisionEvaluate(evaluate("a_#left(ACCOUNT_CODE,2)#"))>
								<cfelseif abs(ALACAK_) GT 0>
									#lsnumberFormat(ALACAK_,',__.00')#
									<cfset alac_top = ALACAK_>
								<cfelse>
									<cfset alac_top = 0>
								</cfif>					
							</td>
							<cfif borc_top GT alac_top>
								<td style="text-align:right;" class="#str_line#" format="numeric">
									<cfif isdefined("ilk_hane_") and len(ACCOUNT_CODE) eq 1>
										<cfif abs(precisionEvaluate(evaluate("b_b_#left(ACCOUNT_CODE,1)#"))) gt abs(precisionEvaluate(evaluate("b_a_#left(ACCOUNT_CODE,1)#")))>
											#TLFormat(abs(precisionEvaluate(evaluate("b_b_#left(ACCOUNT_CODE,1)#")))- abs(precisionEvaluate(evaluate("b_a_#left(ACCOUNT_CODE,1)#"))))# 
										</cfif>
									<cfelseif isdefined("ikinci_hane_") and len(ACCOUNT_CODE) eq 2>	
										<cfif abs(precisionEvaluate(evaluate("b_b_#left(ACCOUNT_CODE,2)#")) gt abs(evaluate("b_a_#left(ACCOUNT_CODE,2)#")))>
											#TLFormat(abs(precisionEvaluate(evaluate("b_b_#left(ACCOUNT_CODE,2)#"))) - abs(precisionEvaluate(evaluate("b_a_#left(ACCOUNT_CODE,2)#"))))# 
										</cfif>
									<cfelseif abs(BAKIYE_) gt 0>
										#TLFormat(abs(BAKIYE_))# 
									</cfif>	
									<cfif not isdefined("is_exist_#new_acc_code#") or listlen(ACCOUNT_CODE,'.') eq 1 or isdefined("attributes.show_main_account")><cfset borc_bakiye_tpl=precisionEvaluate(borc_bakiye_tpl+abs(BAKIYE_))></cfif>
								</td>
								<td style="text-align:right;" class="#str_line#"></td>
							<cfelseif borc_top LT alac_top>
								<td style="text-align:right;" class="#str_line#"></td>				
								<td style="text-align:right;" class="#str_line#" format="numeric">
									<cfif isdefined("ilk_hane_") and len(ACCOUNT_CODE) eq 1>
										<cfif abs(precisionEvaluate(evaluate("b_a_#left(ACCOUNT_CODE,1)#"))) gt abs(evaluate("b_b_#left(ACCOUNT_CODE,1)#"))>
											#TLFormat(abs(precisionEvaluate(evaluate("b_a_#left(ACCOUNT_CODE,1)#"))) - abs(precisionEvaluate(evaluate("b_b_#left(ACCOUNT_CODE,1)#"))))# 
										</cfif>
									<cfelseif isdefined("ikinci_hane_") and len(ACCOUNT_CODE) eq 2>
										<cfif abs(precisionEvaluate(evaluate("b_a_#left(ACCOUNT_CODE,2)#"))) gt abs(evaluate("b_b_#left(ACCOUNT_CODE,2)#"))>									
											#TLFormat(abs(precisionEvaluate(evaluate("b_a_#left(ACCOUNT_CODE,2)#"))) - abs(precisionEvaluate(evaluate("b_b_#left(ACCOUNT_CODE,2)#"))))# 
										</cfif>
									<cfelseif abs(BAKIYE_) gt 0>
										#TLFormat(abs(BAKIYE_))#
									</cfif>
									<cfif not isdefined("is_exist_#new_acc_code#") or listlen(ACCOUNT_CODE,'.') eq 1 or isdefined("attributes.show_main_account")><cfset alacak_bakiye_tpl=precisionEvaluate(alacak_bakiye_tpl+abs(BAKIYE_))></cfif>
								</td>
							<cfelse>
								<td></td><td></td>
							</cfif>
							<cfif attributes.money_type_  eq 2><!--- sistem 2.dovizi bazında mizan --->
								<td nowrap style="text-align:right;" class="#str_line#" format="numeric"><cfif BORC_2 GT 0>#TLFormat(BORC_2)# #session.ep.money2#</cfif></td>				
								<td nowrap style="text-align:right;" class="#str_line#" format="numeric"><cfif ALACAK_2 GT 0>#TLFormat(ALACAK_2)# #session.ep.money2#</cfif></td>
								<cfif BORC_2 GT ALACAK_2>
									<td style="text-align:right;" class="#str_line#" format="numeric"> #TLFormat(abs(BAKIYE_2))#
										<cfif ((not isdefined("is_exist_#new_acc_code#") and len(ACCOUNT_CODE) gte 3) or (listlen(ACCOUNT_CODE,'.') eq 1 and len(ACCOUNT_CODE) eq 3) or isdefined("attributes.show_main_account")) and len(account_code) gte 3><cfset borc_bakiye_tpl_2=borc_bakiye_tpl_2+abs(BAKIYE_2)></cfif>
									</td>
									<td style="text-align:right;" class="#str_line#"></td>
								<cfelseif BORC_2 LT ALACAK_2>
									<td style="text-align:right;" class="#str_line#"></td>				
									<td style="text-align:right;" class="#str_line#" format="numeric"> #TLFormat(abs(BAKIYE_2))#
										<cfif ((not isdefined("is_exist_#new_acc_code#") and len(ACCOUNT_CODE) gte 3) or (listlen(ACCOUNT_CODE,'.') eq 1 and len(ACCOUNT_CODE) eq 3) or isdefined("attributes.show_main_account")) and len(account_code) gte 3><cfset alacak_bakiye_tpl_2=alacak_bakiye_tpl_2+abs(BAKIYE_2)></cfif>
									</td>
                                <cfelse>
                                	<td style="text-align:right;" class="#str_line#"></td>	
                                    <td style="text-align:right;" class="#str_line#"></td>	
								</cfif>
							</cfif>
							<cfif attributes.money_type_  eq 3>
								<td nowrap style="text-align:right;" class="#str_line#" format="numeric"><cfif OTHER_BORC GT 0>#TLFormat(OTHER_BORC)#</cfif></td>				
								<td nowrap style="text-align:right;" class="#str_line#" format="numeric"><cfif OTHER_ALACAK GT 0>#TLFormat(OTHER_ALACAK)#</cfif></td>
								<td class="#str_line#">#OTHER_CURRENCY#</td>
								<cfif OTHER_BORC GT OTHER_ALACAK>
									<td style="text-align:right;" class="#str_line#" format="numeric"> <cfif len(OTHER_BAKIYE)>#TLFormat(abs(OTHER_BAKIYE))#</cfif></td>
									<td style="text-align:right;" class="#str_line#"></td>
								<cfelseif OTHER_BORC LT OTHER_ALACAK>
									<td style="text-align:right;" class="#str_line#"></td>				
									<td style="text-align:right;" class="#str_line#" format="numeric"><cfif len(OTHER_BAKIYE)>#TLFormat(abs(OTHER_BAKIYE))#</cfif> </td>
                                <cfelse>
                                	<td style="text-align:right;" class="#str_line#"></td>	
                                    <td style="text-align:right;" class="#str_line#"></td>	
								</cfif>
							</cfif>
							<cfset new_acc_code = replacelist(listfirst(account_code,'.'),' ','_')>							
							<cfif not isdefined("is_exist_#new_acc_code#") or listlen(ACCOUNT_CODE,'.') eq 1 or isdefined("attributes.show_main_account")>
								<cfset total_borc_all=precisionEvaluate(total_borc_all+BORC_)>
								<cfset total_alacak_all=precisionEvaluate(total_alacak_all+ALACAK_)>
								<cfset total_bakiye_all=precisionEvaluate(total_bakiye_all+BAKIYE_)>
								<cfif isdefined('attributes.money_type_') and attributes.money_type_ eq 2>
									<cfset total_borc_all_2 = total_borc_all_2 + BORC_2>
									<cfset total_alacak_all_2 = total_alacak_all_2 + ALACAK_2>
									<cfset total_bakiye_all_2 = total_bakiye_all_2 + BAKIYE_2>
								</cfif>
								<cfif isdefined('attributes.money_type_') and attributes.money_type_ eq 3>
									<cfif len(trim(OTHER_CURRENCY))>
										<cfset 'doviz_borc_#OTHER_CURRENCY#' = evaluate('doviz_borc_#OTHER_CURRENCY#') + OTHER_BORC>
										<cfset 'doviz_alacak_#OTHER_CURRENCY#' = evaluate('doviz_alacak_#OTHER_CURRENCY#') + OTHER_ALACAK>
										<cfif OTHER_BORC GT OTHER_ALACAK>
											<cfset 'bakiye_borc_#OTHER_CURRENCY#' = evaluate('bakiye_borc_#OTHER_CURRENCY#') + OTHER_BAKIYE>
										<cfelseif OTHER_BORC LT OTHER_ALACAK>
											<cfset 'bakiye_alacak_#OTHER_CURRENCY#' = evaluate('bakiye_alacak_#OTHER_CURRENCY#') + abs(OTHER_BAKIYE)>
										</cfif>
									</cfif>
								</cfif>
								<cfif isdefined('attributes.is_quantity')>
									<cfset total_quantity_borc_all=total_quantity_borc_all+QUANTITY_BORC>
									<cfset total_quantity_alacak_all=total_quantity_alacak_all+QUANTITY_ALACAK>
								</cfif>
							</cfif>
							<cfif SUB_ACCOUNT eq 1>
						   		<cfset "is_exist_#replacelist(listfirst(account_code,'.'),' ','_')#" = 1>
							</cfif>		
                            <cfif not listFind(new_list_2,replacelist(listfirst(account_code,'.'),' ','_'))>
								<cfset new_list_2 = listAppend(new_list_2,replacelist(listfirst(account_code,'.'),' ','_'),',')>
								<cfset url_code = '#url_code#&is_exist_#replacelist(listfirst(account_code,'.'),' ','_')#=1'>
							</cfif>
							</tr>
						</cfif>
						</cfif>
						</cfoutput>						
						<cfset sayfa_=attributes.totalrecords\attributes.maxrows>
						<cfif sayfa_ neq attributes.totalrecords/attributes.maxrows>
							<cfset sayfa_=sayfa_+1>
						</cfif>
						<!----<cfif attributes.page eq sayfa_> Her sayfanın sonunda toplama işlemini getirmesi için kapatıldı.---->
							<cfscript>
								total_borc_all=precisionEvaluate(total_borc_all+total_borc);
								total_quantity_borc_all=precisionEvaluate(total_quantity_borc_all+total_quantity_borc);
								total_quantity_alacak_all=precisionEvaluate(total_quantity_alacak_all+total_quantity_alacak);
								total_alacak_all=precisionEvaluate(total_alacak_all+total_alacak);
								total_bakiye_all=precisionEvaluate(total_bakiye_all+total_bakiye);
							</cfscript>								
							<cfloop query = "get_money">
								<cfset 'doviz_borc_#money#' = evaluate('doviz_borc_#money#') + evaluate('doviz_borc_#money#_2')>
								<cfset 'doviz_alacak_#money#' = evaluate('doviz_alacak_#money#') + evaluate('doviz_alacak_#money#_2')>
								<cfset 'bakiye_borc_#money#' = evaluate('bakiye_borc_#money#') + evaluate('bakiye_borc_#money#_2')>
								<cfset 'bakiye_alacak_#money#' = evaluate('bakiye_alacak_#money#') +  evaluate('bakiye_alacak_#money#_2')>
							</cfloop>
							<cfoutput>
							<tr>
								<td colspan="#row_colspan_number_#" class="txtbold"> <cf_get_lang_main no='80.Toplam'>:</td>
								<cfif isdefined('attributes.is_quantity')>
									<td style="text-align:right;" class="txtbold">#TLFormat(wrk_round(total_quantity_borc_all))#</td>
									<td style="text-align:right;" class="txtbold">#TLFormat(wrk_round(total_quantity_alacak_all))#</td>
								</cfif>
								<td style="text-align:right;" class="txtbold">#lsnumberFormat(total_borc_all,',__.00')# <!---#TLFormat(wrk_round(total_borc_all))# ---></td>
								<td style="text-align:right;" class="txtbold">#lsnumberFormat(total_alacak_all,',__.00')#</td>
								<td style="text-align:right;" class="txtbold">#lsnumberFormat(abs(borc_bakiye_tpl),',__.00')#</td>
								<td style="text-align:right;" class="txtbold">#lsnumberFormat(abs(alacak_bakiye_tpl),',__.00')#</td>
								<cfif isdefined('attributes.money_type_') and attributes.money_type_ eq 2>
									<td style="text-align:right;" class="txtbold">#TLFormat(wrk_round(total_borc_all_2+total_borc2))#</td>
									<td style="text-align:right;" class="txtbold">#TLFormat(wrk_round(total_alacak_all_2+total_alacak2))#</td>
									<td style="text-align:right;" class="txtbold">#TLFormat(abs(wrk_round(borc_bakiye_tpl_2)))#</td>
									<td style="text-align:right;" class="txtbold">#TLFormat(abs(wrk_round(alacak_bakiye_tpl_2)))#</td>
								</cfif>
								<cfif isdefined('attributes.money_type_') and attributes.money_type_ eq 3>
									<td style="text-align:right;" class="txtbold">
										<cfloop query = "get_money">
											#TLFormat(evaluate('doviz_borc_#money#'))# #money# <br>
										</cfloop>
									</td>
									<td style="text-align:right;" class="txtbold">
										<cfloop query = "get_money">
											#TLFormat(evaluate('doviz_alacak_#money#'))# #money# <br>
										</cfloop>
									</td>
									<td style="text-align:right;" class="txtbold">&nbsp;</td>
									<td style="text-align:right;" class="txtbold">
										<cfloop query = "get_money">
											#TLFormat(evaluate('bakiye_borc_#money#'))# #money# <br>
										</cfloop>
									</td>
									<td style="text-align:right;" class="txtbold">
										<cfloop query = "get_money">
											#TLFormat(evaluate('bakiye_alacak_#money#'))# #money# <br>
										</cfloop>
									</td>
								</cfif>
							</tr>
							</cfoutput>
					 <!---- </cfif>----->
					  <cfelse>
					  <tr>
						<td colspan="10"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
					  </tr>
					</cfif>
				</tbody>
			</cf_grid_list>
		</cfsavecontent>
        <cfoutput>#cont#</cfoutput>
	</cfif>
	<cfif attributes.excel_getir eq 0>
		<cfif not fusebox.fuseaction contains 'autoexcelpopuppage_'>
		<cfform action="#request.self#?fuseaction=account.popup_add_financial_table" method="post" name="scale_sheet_table">
			<!---<cfset cont = Replace(cont,'<!-- sil -->','','')> Ilk sil fazlalik diye silindi. Alt tarafta gelen table ise js'ten dolayi display none geliyordu. content_clear'dan gecirip script ifadeleri silindi. EY20131010 --->
			<cfif cont contains '<table class="big_list" style="display:none;"'>
				<cfset cont = Replace(cont,'<table class="big_list" style="display:none;"','<table class="big_list"','')>
			</cfif>
		</cfform>
		</cfif>
	</cfif>
<cfelse>
	<cf_grid_list>
    	<tbody>
			<tr>
            	<td colspan="10"><cf_get_lang_main no='289.Filtre Ediniz'>!</td>
             </tr>
        </tbody>
	</cf_grid_list>
</cfif>
<cfif attributes.excel_getir eq 0>
<cfset adres = 'account.list_scale&#url_code#'>
<cfset adres = '#adres#&money=#attributes.money#&rate=#attributes.rate#'>
<cfset adres = '#adres#&date1=#attributes.date1#'>
<cfset adres = '#adres#&date2=#attributes.date2#'>
<cfif len(attributes.acc_code1_1)><cfset adres = "#adres#&acc_code1_1=#attributes.acc_code1_1#"></cfif>
<cfif len(attributes.acc_code2_1)><cfset adres = "#adres#&acc_code2_1=#attributes.acc_code2_1#"></cfif>
<cfif len(attributes.acc_code1_2)><cfset adres = "#adres#&acc_code1_2=#attributes.acc_code1_2#"></cfif>
<cfif len(attributes.acc_code2_2)><cfset adres = "#adres#&acc_code2_2=#attributes.acc_code2_2#"></cfif>
<cfif len(attributes.acc_code1_3)><cfset adres = "#adres#&acc_code1_3=#attributes.acc_code1_3#"></cfif>
<cfif len(attributes.acc_code2_3)><cfset adres = "#adres#&acc_code2_3=#attributes.acc_code2_3#"></cfif>
<cfif len(attributes.acc_code1_4)><cfset adres = "#adres#&acc_code1_4=#attributes.acc_code1_4#"></cfif>
<cfif len(attributes.acc_code2_4)><cfset adres = "#adres#&acc_code2_4=#attributes.acc_code2_4#"></cfif>
<cfif len(attributes.acc_code1_5)><cfset adres = "#adres#&acc_code1_5=#attributes.acc_code1_5#"></cfif>
<cfif len(attributes.acc_code2_5)><cfset adres = "#adres#&acc_code2_5=#attributes.acc_code2_5#"></cfif>
<cfif isDefined('attributes.sub_accounts')>
	<cfset adres = '#adres#&sub_accounts=#attributes.sub_accounts#'>
</cfif>
<cfif isdefined("attributes.acc_code_type")>
	<cfset adres = '#adres#&acc_code_type=#attributes.acc_code_type#'>
</cfif>
<cfif isdefined("attributes.acc_branch_id")>
	<cfset adres = '#adres#&acc_branch_id=#attributes.acc_branch_id#'>
</cfif>
<cfif isDefined('attributes.is_bakiye')>
	<cfset adres = '#adres#&is_bakiye=#attributes.is_bakiye#'>
</cfif>
<cfif isDefined('attributes.is_quantity')>
	<cfset adres = '#adres#&is_quantity=#attributes.is_quantity#'>
</cfif>
<cfif isDefined('attributes.no_process_accounts')>
	<cfset adres = '#adres#&no_process_accounts=#attributes.no_process_accounts#'>
</cfif>
<cfif isDefined('attributes.show_main_account')>
	<cfset adres = '#adres#&show_main_account=#attributes.show_main_account#'>
</cfif>
<cfif isDefined('attributes.acc_card_type') and len(attributes.acc_card_type)>
	<cfset adres = '#adres#&acc_card_type=#attributes.acc_card_type#'>
</cfif>
<cfif isDefined('attributes.project_id') and len(attributes.project_id)>
	<cfset adres = '#adres#&project_id=#attributes.project_id#'>
</cfif>
<cfif isDefined('attributes.project_head') and len(attributes.project_head)>
	<cfset adres = '#adres#&project_head=#attributes.project_head#'>
</cfif>
<cfif isDefined('attributes.money_type_') and len(attributes.money_type_)>
	<cfset adres = '#adres#&money_type_=#attributes.money_type_#'>
</cfif>
<cfif isDefined('attributes.form_varmi')>
	<cfset adres = '#adres#&form_varmi=#attributes.form_varmi#'>
</cfif>
<cfif isDefined('attributes.priority_type')>
	<cfset adres = '#adres#&priority_type=#attributes.priority_type#'>
</cfif>
<cfif isDefined('attributes.report_type')>
	<cfset adres = '#adres#&report_type=#attributes.report_type#'>
</cfif>
<cfif isDefined('attributes.is_balance_acc')>
	<cfset adres = '#adres#&is_balance_acc=#attributes.is_balance_acc#'>
</cfif>
<cf_paging page="#attributes.page#"
	maxrows="#attributes.maxrows#"
	totalrecords="#attributes.totalrecords#"
	startrow="#attributes.startrow#"
	adres="#adres#">
</cfif>
</cf_box>	
</div>
<cfif not fusebox.fuseaction contains 'autoexcelpopuppage_'>
	<script type="text/javascript">
		function kontrol_report_type()
		{
			if(document.getElementById("sub_accounts").value == 0)
				document.getElementById("show_main_account").disabled = true;
			else
				document.getElementById("show_main_account").disabled = false;
		}
		rate_list = new Array(<cfloop query=get_moneys><cfoutput>"#get_moneys.rate2#"</cfoutput><cfif not currentrow eq recordcount>,</cfif></cfloop>);
		function control_scale_detail()
		{
			if(document.getElementById("money_type_").value != 1 && document.getElementById("money_type_").value != 3 && document.getElementById("money_type_").value != 2)
				document.getElementById("money_type_").value = 1;
			if(document.getElementById("money").options[document.getElementById("money").selectedIndex].value != '<cfoutput>#session.ep.money#</cfoutput>' && document.getElementById("money_type_").value != 1)
			{
				alert("<cf_get_lang no ='143.Yeniden Değerleme Sistem Para Birimi Bazında Yapılabilir'>!");
				return false;
			}
			if(!document.getElementById("acc_code1_2")){<!---muhasebe kodu sayfaya yüüklenmeden geldiğinde attributes değerlerini alsın diye eklendi. ERU------>
				hidden_value = '';
				<cfif isdefined('attributes.acc_code1_2') and len(attributes.acc_code1_2)>
					hidden_value = hidden_value + '<input type="hidden" name="acc_code1_2" id="acc_code1_2" value="<cfoutput>#attributes.acc_code1_2#</cfoutput>">';
				</cfif>
				<cfif isdefined('attributes.acc_code2_2') and len(attributes.acc_code2_2)>
					hidden_value = hidden_value + '<input type="hidden" name="acc_code2_2" id="acc_code2_2" value="<cfoutput>#attributes.acc_code2_2#</cfoutput>">';
				</cfif>
				<cfif isdefined('attributes.acc_code1_3') and len(attributes.acc_code1_3)>
					hidden_value = hidden_value + '<input type="hidden" name="acc_code1_3" id="acc_code1_3" value="<cfoutput>#attributes.acc_code1_3#</cfoutput>">';
				</cfif>
				<cfif isdefined('attributes.acc_code2_3') and len(attributes.acc_code2_3)>
					hidden_value = hidden_value + '<input type="hidden" name="acc_code2_3" id="acc_code2_3" value="<cfoutput>#attributes.acc_code2_3#</cfoutput>">';
				</cfif>
				<cfif isdefined('attributes.acc_code1_4') and len(attributes.acc_code1_4)>
					hidden_value = hidden_value +'<input type="hidden" name="acc_code1_4" id="acc_code1_4" value="<cfoutput>#attributes.acc_code1_4#</cfoutput>">';
				</cfif>
				<cfif isdefined('attributes.acc_code2_4') and len(attributes.acc_code2_4)>
					hidden_value = hidden_value +'<input type="hidden" name="acc_code2_4" id="acc_code2_4" value="<cfoutput>#attributes.acc_code2_4#</cfoutput>">';
				</cfif>
				<cfif isdefined('attributes.acc_code1_5') and len(attributes.acc_code1_5)>
					hidden_value = hidden_value + '<input type="hidden" name="acc_code1_5" id="acc_code1_5" value="<cfoutput>#attributes.acc_code1_5#</cfoutput>">';
				</cfif>
				<cfif isdefined('attributes.acc_code2_5') and len(attributes.acc_code2_5)>
					hidden_value = hidden_value + '<input type="hidden" name="acc_code2_5" id="acc_code2_5" value="<cfoutput>#attributes.acc_code2_5#</cfoutput>">';
				</cfif>
				$('#div_acc_hidden').html(hidden_value);
			}
			if(document.form.excel_getir.checked==false)
			{
				document.form.action="<cfoutput>#request.self#</cfoutput>?fuseaction=account.list_scale";
			}
            else
            {
				document.form.action="<cfoutput>#request.self#?fuseaction=account.emptypopup_list_scale</cfoutput>";
			
            }
			
		}
		function get_rate()
		{
			document.getElementById("rate").value = commaSplit(rate_list[document.getElementById("money").selectedIndex],'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
		function save_mizan_table()
		{
			if((document.getElementById("date1").value=='') || (document.getElementById("date2").value==''))
				{
				alert("<cf_get_lang no ='197.Önce Tarihleri Seçiniz'>!");
				return false;
				}
			date1 = document.getElementById("date1").value;
			date2 = document.getElementById("date2").value;
			fintab_type_ = document.getElementById("fintab_type").value;
			openBoxDraggable('<cfoutput>#request.self#?fuseaction=account.popup_add_financial_table&draggable=1&module=#fusebox.circuit#&faction=#fusebox.fuseaction#</cfoutput>&fintab_type='+fintab_type_+'&date1='+date1+'&date2='+date2);
		}
	</script>
</cfif>