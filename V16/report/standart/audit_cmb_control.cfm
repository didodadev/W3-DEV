<!--- 
	072020 - PY
	Amaç: Cari, muhasebe ve bütçe kayıtlarının işlem tipi ve ID'sine göre belirli bir tarih aralığında raporlanması ve farkların bulunması.
 --->
<cfparam name="attributes.module_id_control" default="22">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.process_type" default="">
<cfparam name="attributes.finishdate" default="#now()#">
<cfparam name="attributes.startdate" default="#DateAdd('d',-1,attributes.finishdate)#">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.acc_code1_1" default="">
<cfparam name="attributes.acc_code2_1" default="">
<cfparam name="attributes.expense_item_id" default="">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.form_varmi")>
	<cfif len(attributes.finishdate)>
		<cf_date tarih="attributes.finishdate">
	</cfif>
	<cfif len(attributes.startdate)>
		<cf_date tarih="attributes.startdate">
	</cfif>
	<cfset auditControl    = createObject("component","V16.report.cfc.audit_cmb_control") />
	<cfset get_records = auditControl.get_records(
			finishdate :'#iif(isdefined("attributes.finishdate") and len(attributes.finishdate),"attributes.finishdate",DE(""))#',
			startdate :'#iif(isdefined("attributes.startdate") and len(attributes.startdate),"attributes.startdate",DE(""))#',
			process_type :'#iif(isdefined("attributes.process_type") and len(attributes.process_type),"attributes.process_type",DE(""))#',
			acc_code1_1 : '#IIf(IsDefined("attributes.acc_code1_1"),"attributes.acc_code1_1",DE(""))#',
			acc_code2_1 : '#IIf(IsDefined("attributes.acc_code2_1"),"attributes.acc_code2_1",DE(""))#',
			expense_item_id : '#IIf(IsDefined("attributes.expense_item_id"),"attributes.expense_item_id",DE(""))#',
			startrow :'#iif(isdefined("attributes.startrow"),"attributes.startrow",DE(""))#',
			maxrows :'#iif(isdefined("attributes.maxrows"),"attributes.maxrows",DE(""))#',
			is_excel : '#iif(isdefined("attributes.is_excel") and len(attributes.is_excel),"attributes.is_excel",DE(""))#'
		) />
<cfelse>
	<cfset get_records.recordcount = 0>
	<cfset get_records.query_count = 0>
</cfif>
<cfquery name="get_process_cat" datasource="#dsn3#">
	SELECT PROCESS_CAT,PROCESS_CAT_ID,PROCESS_TYPE FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (18,302,21,22,23,2311,2313,24,25,30,31,32,33,34,35,44,45,46,48,49,50,51,52,53,54,55,56,58,59,60,62,63,64,65,66,67,68,120,1201,1202,1203,121,122,130,131,311,254,592,531,533,534,5312,5313,555,561,591,601,690,691,241,2410,243,291,292,293,294,2931,2932,296,318)
</cfquery>
<cfparam name="attributes.totalrecords" default="#get_records.query_count#">
<cfform name="form" action="" method="post">
	<input type="hidden" value="1" name="form_varmi" id="form_varmi">
	<cfsavecontent variable='title'><cf_get_lang dictionary_id='61032.cMB kontrol raporu'></cfsavecontent>
	<cf_report_list_search title="#title#">
		<cf_report_list_search_area>
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-4 col-md-6 col-xs-12">
								<div class="form-group">
									<label class="col col-12"> <cf_get_lang dictionary_id='57800.İşlem Tipi'></label>
									<div class="col col-12 col-xs-12">
										<select name="process_type" id="process_type"  multiple>
											<cfoutput query="get_process_cat">
												<option value="#PROCESS_type#" <cfif listfind(attributes.process_type,PROCESS_type,',')>selected</cfif>>#PROCESS_CAT#</option>
											</cfoutput>
										</select>
									</div>
								</div>								
							</div>
							<div class="col col-4 col-md-6 col-xs-12">
								<div class="form-group">
									<label class="col col-12"><cf_get_lang dictionary_id='58690.Tarih Aralığı'>*</label>
									<div class="col col-6">
										<div class="input-group">
											<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
											<cfinput type="text" name="startdate" value="#dateformat(attributes.startdate, dateformat_style)#" validate="#validate_style#" message="#message#" maxlength="10" required="yes">
											<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
										</div>
									</div>
									<div class="col col-6">
										<div class="input-group">
											<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
											<cfinput type="text" name="finishdate" value="#dateformat(attributes.finishdate, dateformat_style)#" validate="#validate_style#" message="#message#" maxlength="10" required="yes">
											<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span> 
										</div>
									</div>
								</div>
							</div>
							<div class="col col-4 col-md-6 col-xs-12">
								<div class="form-group">
									<div class="col col-6">
										 <div class="form-group" id="item-acc_code_1">
										 <label class="col col-12"><cf_get_lang dictionary_id ='58811.Muhasebe Kodu'></label>
											<div class="col col-12">
												<cf_wrk_multi_account_code acc_code1_1='#attributes.acc_code1_1#' acc_code2_1='#attributes.acc_code2_1#' is_multi='0'>
											</div>
										</div>
									</div>
									<div class="col col-1">
									</div>
									<div class="col col-5">
										<div class="form-group" id="item-expense_item_id">
											<label class="col col-12"><cf_get_lang dictionary_id='58551.Gider Kalemi'></label>
											<div class="col col-12">
												<cfsavecontent variable="text"><cf_get_lang dictionary_id='57734.Seçiniz'></cfsavecontent>
												<cf_wrk_budgetitem name="expense_item_id" width="170" class="txt" value="#attributes.expense_item_id#" income_expense="0" option_text="#text#">
											</div>
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
							<cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" range="1,999" validate="integer" message="#message#" maxlength="3" style="width:25px;">
							<cfelse>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" range="1,999" onKeyUp="isNumber(this)" validate="integer" message="#message#" maxlength="3" style="width:25px;">
							</cfif>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57911.Çalıştır'></cfsavecontent>
							<cf_wrk_report_search_button button_type='1' search_function='kontrol()' is_excel='1'>
						</div>
					</div>
				</div>
			</div>
		</cf_report_list_search_area>
	</cf_report_list_search>
</cfform>
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
	<cfset attributes.startrow=1>
	<cfset attributes.maxrows=get_records.recordcount>
</cfif>
<cfif isdefined("attributes.is_excel") and attributes.is_excel eq 1>
	<cfset filename="cmb_control#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
	<cfheader name="Expires" value="#GetHttpTimeString(Now())#">
	<cfcontent type="application/vnd.msexcel;charset=utf-16">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="content-type" content="text/html; charset=utf-16">
	<cfparam name="attributes.totalrecords" default="#get_records.recordcount#">
	<cfset type_ = 1>
<cfelse>
	<cfset type_ = 0>
</cfif>
<!---
<pre><cfdump var="#get_records#">
--->
<cfif isdefined("attributes.form_varmi")>
	<cf_report_list>
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id='57487.No'></th>
				<th><cf_get_lang dictionary_id='58772.İşlem No'></th>
				<th><cf_get_lang dictionary_id='57800.İşlem Tipi'></th>
				<th width="150"><cf_get_lang dictionary_id='57447.Muhasebe'></th>
				<th width="150"><cf_get_lang dictionary_id='57559.Bütçe'></th>
				<th width="150"><cf_get_lang dictionary_id='58061.Cari'></th>
				<th width="150"><cf_get_lang dictionary_id='57489.Para Birimi'></th>
			</tr>
		</thead>
		<cfif get_records.recordcount>
			<tbody>
				<cfoutput query="get_records">
				<tr>
					<td style="width:50px;" align="center">#RowNum#</td>
					<td align="center">
					<cfif len(paper_no)>#paper_no#
					<cfelseif ACTION_TYPE eq 120 OR ACTION_TYPE eq 121>
						<cfquery name="get_" datasource="#dsn2#">
							SELECT PAPER_NO FROM EXPENSE_ITEM_PLANS
						</cfquery>
						<cfif get_.recordcount>
							#get_.PAPER_NO#
						</cfif>	
					</cfif>
					</td>	
					<td>#get_process_name(action_type)#</td>
					<td style="text-align:right;">
						<cfif type_ eq 0>
							<cfif muhasebe neq 0>
								<a target="blank" href="#request.self#?fuseaction=account.list_cards&FORM_VARMI=1&belge_no=#paper_no#">#tlformat(muhasebe)#</a>
							<cfelse>
								#tlformat(0)#
							</cfif>
						<cfelse>
							#tlformat(muhasebe)#
						</cfif>
					</td>
					<td style="text-align:right;">
						<cfif type_ eq 0>
							<cfif butce neq 0>
								<cfif is_income eq 0>
									<a target="blank" href="#request.self#?fuseaction=cost.list_expense_management&is_form_submitted=1&KEYWORD=#paper_no#">#tlformat(butce)#</a>
								<cfelse>
									<a target="blank" href="#request.self#?fuseaction=budget.budget_income_summery&form_submitted=1&KEYWORD=#paper_no#">#tlformat(butce)#</a>
								</cfif>
							<cfelse>
								#tlformat(0)#
							</cfif>
						<cfelse>
							#tlformat(butce)#
						</cfif>
					</td>
					<td style="text-align:right;">
						<cfif type_ eq 0>
							<cfif cari neq 0>
								<a target="blank" href="#request.self#?fuseaction=ch.list_caris&FORM_VARMI=1&KEYWORD=#paper_no#">#tlformat(cari)#</a>
							<cfelse>
								#tlformat(0)#
							</cfif>
						<cfelse>
							#tlformat(cari)#
						</cfif>
					</td>
					
					<td></td>
				</tr>
				</cfoutput>
			</tbody>
		</cfif>
	</cf_report_list>
</cfif>
<cfif not (isdefined('attributes.is_excel') and listfind('1,2',attributes.is_excel,','))>
	<cfset adres = "">
	<cfif get_records.recordcount and (attributes.maxrows lt attributes.totalrecords)>
		<cfset adres = "#attributes.fuseaction#&form_varmi=1">	
		<cfif isDefined("attributes.startdate") and len(attributes.startdate)>
			<cfset adres = "#adres#&startdate=#dateformat(attributes.startdate, dateformat_style)#">
		</cfif>
		<cfif isDefined("attributes.finishdate") and len(attributes.finishdate)>
			<cfset adres = "#adres#&finishdate=#dateformat(attributes.finishdate, dateformat_style)#">
		</cfif>
		<cfif isDefined("attributes.process_type") and len(attributes.process_type)>
			<cfset adres = "#adres#&process_type=#attributes.process_type#">
		</cfif>
		<cfif len(attributes.acc_code1_1)>
			<cfset adres = "#adres#&acc_code1_1=#attributes.acc_code1_1#">
		</cfif>
		<cfif len(attributes.acc_code2_1)>
			<cfset adres = "#adres#&acc_code2_1=#attributes.acc_code2_1#">
		</cfif>
		<cfif len(attributes.expense_item_id)>
			<cfset adres = "#adres#&expense_item_id=#attributes.expense_item_id#">
		</cfif>
		<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#adres#">
	</cfif>
</cfif>
<script type="text/javascript">
	function kontrol()
	{
		if ((document.form.startdate.value != '') && (document.form.finishdate.value != '') &&
		!date_check(form.startdate,form.finishdate,"<cf_get_lang dictionary_id='39814.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
				return false;
		if(document.form.is_excel.checked==false)
		{
			document.form.action="<cfoutput>#request.self#?fuseaction=report.audit_cmb_control</cfoutput>";
			return true;
		
		}
		else
		{
			document.form.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_audit_cmb_control</cfoutput>";
		}
	}
</script>
<cfsetting showdebugoutput="yes">