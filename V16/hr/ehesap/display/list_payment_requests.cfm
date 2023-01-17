<cf_get_lang_set module_name="ehesap">
<cf_xml_page_edit fuseact="ehesap.list_payment_requests">
<cfparam name="attributes.date1" default="01/#Month(now())#/#year(now())#">
<cfset bu_ay_sonu = DaysInMonth('#Month(now())#/01/#year(now())#')>
<cfif dateformat_style is 'dd/mm/yyyy'>
	<cfparam name="attributes.date2" default="#bu_ay_sonu#/#Month(now())#/#year(now())#">
<cfelse>
	<cfparam name="attributes.date2" default="#Month(now())#/#bu_ay_sonu#/#year(now())#">
</cfif>
<cfparam name="attributes.avans_type" default="0">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.status" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.hierarchy" default="">
<cfparam name="attributes.sayfa_toplam" default="0">
<cfparam name="attributes.comp_id" default="">
<cfparam name="attributes.money" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.filter_process" default="">
<cfscript>
	url_str = "keyword=#attributes.keyword#&status=#attributes.status#&hierarchy=#attributes.hierarchy#&branch_id=#attributes.branch_id#&avans_type=#attributes.avans_type#";
	if (isdefined('attributes.form_submit') and len(attributes.form_submit))
		url_str = "#url_str#&form_submit=#attributes.form_submit#";
	if (isdefined('attributes.comp_id') and len(attributes.comp_id))
		url_str = "#url_str#&comp_id=#attributes.comp_id#";
	if (isdefined('attributes.money') and len(attributes.money))
		url_str = "#url_str#&money=#attributes.money#";
	if (isdefined('attributes.filter_process') and len(attributes.filter_process))
		url_str = "#url_str#&filter_process=#attributes.filter_process#";	
	cmp_company = createObject("component","V16.hr.cfc.get_our_company");
	cmp_company.dsn = dsn;
	get_our_company = cmp_company.get_company();
	cmp_branches = createObject("component","V16.hr.cfc.get_branches");
</cfscript>
<cf_date tarih='attributes.date1'>
<cf_date tarih='attributes.date2'>
<cfset cmp_process = createObject('component','V16.workdata.get_process')>
<cfset get_process = cmp_process.GET_PROCESS_TYPES(faction_list : 'ehesap.list_payment_requests')>

<!--- sorgu sirayi bozmayin  --->
<!---<cfinclude template="../query/get_our_comp_and_branchs.cfm">--->
<cfquery name="GET_SPECIAL_DEFINITION" datasource="#DSN#">
	SELECT SPECIAL_DEFINITION_ID,SPECIAL_DEFINITION FROM SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 2
</cfquery>
<cfif isdefined('attributes.form_submit')>
<cfinclude template="../query/get_payment_requests.cfm">
<cfelse>
<cfset get_requests.recordcount = 0>
</cfif>
<cfif not isDefined("attributes.status")>
	<cfset attributes.status=2>
</cfif>
<cfinclude template="../query/get_setup_moneys.cfm">
<cfparam name="attributes.totalrecords" default="#get_requests.recordcount#">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_payment_requests" name="myform" method="post" >
			<input type="hidden" name="form_submit" id="form_submit" value="1">
			<cf_box_search>
				<div class="form-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput name="keyword" id="keyword" placeholder="#message#" value="#attributes.keyword#" style="width:100px;" maxlength="255">
				</div>
				<div class="form-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57789.Özel Kod'></cfsavecontent>
					<cfinput name="hierarchy" id="hierarchy" placeholder="#message#" value="#attributes.hierarchy#" style="width:100px;" maxlength="50">
				</div>
				<cfset attributes.date1=dateformat(attributes.date1,dateformat_style)>
				<cfset attributes.date2=dateformat(attributes.date2,dateformat_style)>
				<cfset url_str="#url_str#&date1=#attributes.date1#&date2=#attributes.date2#">
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<cfsavecontent variable="message_date"><cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!</cfsavecontent>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="date_check(myform.date1,myform.date2,'#message_date#')">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-avans_type">
						<label class="col col-12"><cf_get_lang dictionary_id ='52972.Avans Talepleri'></label>
						<div class="col col-12">
							<select name="avans_type" id="avans_type">
								<option value="0" <cfif attributes.avans_type eq 0>selected</cfif>><cf_get_lang dictionary_id ='58081.Hepsi'></option>
								<option value="1" <cfif attributes.avans_type eq 1>selected</cfif>><cf_get_lang dictionary_id ='52972.Avans Talepleri'></option>
								<option value="2" <cfif attributes.avans_type eq 2>selected</cfif>><cf_get_lang dictionary_id ='54063.Gerçek Avanslar'></option>
								<cfif is_pay_request eq 1>
									<option value="3" <cfif attributes.avans_type eq 3>selected</cfif>><cf_get_lang dictionary_id='53113.Ödemesi Yapılanlar'></option>
									<option value="4" <cfif attributes.avans_type eq 4>selected</cfif>><cf_get_lang dictionary_id='53114.Ödemesi Yapılmayanlar'></option>
								</cfif>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-date1">
						<label class="col col-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
						<div class="col col-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
								<cfinput value="#attributes.date1#" validate="#validate_style#" maxlength="10" required="Yes" message="#message#" type="text" name="date1" id="date1" style="width:65px;">
								<span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-comp_id">
						<label class="col col-12"><cf_get_lang dictionary_id='29531.Şirketler'></label>
						<div class="col col-12">
							<select name="comp_id" id="comp_id" style="width:150px;" onChange="showBranch(this.value)">
								<option value="all"><cf_get_lang dictionary_id='29531.Şirketler'></option>
								<cfoutput query="get_our_company"><option value="#comp_id#"<cfif attributes.comp_id eq comp_id>selected</cfif>>#company_name#</option></cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-date2">
						<label class="col col-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
						<div class="col col-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
								<cfinput value="#attributes.date2#" validate="#validate_style#" maxlength="10" required="Yes" message="#message#" type="text" name="date2" id="date2" style="width:65px;">
								<span class="input-group-addon"><cf_wrk_date_image date_field="date2"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-status">
						<label class="col col-12"><cf_get_lang dictionary_id='57756.Durum'></label>
						<div class="col col-12">
							<select name="status" id="status">
								<option value=""><cf_get_lang dictionary_id='57756.Durum'></option>										
								<option <cfif attributes.status eq 1 >selected</cfif> value="1"><cf_get_lang dictionary_id='53121.Kabul'></option>
								<option <cfif attributes.status eq 0 >selected</cfif> value="0"><cf_get_lang dictionary_id='57617.Red'></option>
								<option <cfif attributes.status eq 2 >selected</cfif> value="2"><cf_get_lang dictionary_id='57615.Onay Bekleyenler'></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-money">
						<label class="col col-12"><cf_get_lang dictionary_id='57489.Para Birimi'></label>
						<div class="col col-12">
							<cf_multiselect_check 
								query_name="get_moneys"  
								name="money"
								value="#attributes.money#"  
								width="147" 
								height="100"
								option_value="money"
								option_name="money">
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
					<div class="form-group" id="BRANCH_PLACE">
						<label class="col col-12"><cf_get_lang dictionary_id='57453.Şube'></label>
						<div class="col col-12">
							<select name="branch_id" id="branch_id" style="width:150px;">
								<option value="all"><cf_get_lang dictionary_id='57453.Şube'></option>
								<cfif isdefined("attributes.comp_id") and len(attributes.comp_id) and attributes.comp_id is not "all">
								<cfquery name="get_branch" datasource="#dsn#">
									SELECT * FROM BRANCH WHERE BRANCH_STATUS = 1 AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#"> ORDER BY BRANCH_NAME
								</cfquery>
								<cfoutput query="get_branch"><option value="#branch_id#"<cfif attributes.branch_id eq get_branch.branch_id>selected</cfif>>#branch_name#</option></cfoutput>
								</cfif>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-off_validate">
						<label class="col col-12"><cf_get_lang dictionary_id = "41129.Süreç/Aşama"></label>
						<div class="col col-12">
							<select name="filter_process" id="filter_process">
								<option value="" ><cf_get_lang dictionary_id ="57734.SEÇİNİZ"></option>
								<cfoutput query="get_process"> 
									<option value="#process_row_id#" <cfif isdefined("attributes.filter_process") and (process_row_id eq attributes.filter_process)>selected</cfif>><cfif Len(stage_code)>#stage_code# - </cfif>#stage#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id="52972.Avans Talepleri"></cfsavecontent>
	<cf_box title="#message#" uidrop="1" hide_table_column="1">
		<form name="form" method="post">
			<cf_grid_list>
				<input type="hidden" name="payment_ids" id="payment_ids" value=""> 
				<thead>
					<tr> 
						<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
						<th><cf_get_lang dictionary_id="54265.TC No"></th>
						<th><cf_get_lang dictionary_id ='57576.Çalışan'></th>
						<th><cf_get_lang dictionary_id ='57480.Konu'></th>
						<th><cf_get_lang dictionary_id='31578.Avans Tipi'></th>
						<th style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
						<th style="text-align:right;"><cf_get_lang dictionary_id='57489.Para Birimi'></th>
						<th><cf_get_lang dictionary_id = "41129.Süreç/Aşama"></th>
						<th><cf_get_lang dictionary_id='53042.Onay Durumu'></th>
						<th><cf_get_lang dictionary_id="45459.Ödeme Durumu"></th>
						<th><cf_get_lang dictionary_id='57742.Tarih'></th>
						<cfif listgetat(attributes.fuseaction,1,'.') is 'ehesap'>
							<!-- sil -->
							<th width="20" nowrap="nowrap" class="header_icn_none text-center">
								<a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.list_payment_requests&event=add')"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
							</th>
							<!-- sil -->
						</cfif>
						<cfif is_pay_request eq 1>
							<!-- sil -->
							<th width="20" class="header_icn_none text-center"><input type="checkbox" name="all_check" id="all_check" onclick="javascript:hepsi();"></th>
							<!-- sil -->
						</cfif>
					</tr>
				</thead>

				<tbody>
					<cfif attributes.page gt 1>
						<tr class="color-row" height="20">
							<td colspan="4"  class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id ='54170.Devir Toplam'></td>
							<td class="txtbold" style="text-align:right;"><cfoutput>#tlformat(attributes.sayfa_toplam)#</cfoutput></td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
						</tr>
					</cfif>
					<cfif get_requests.recordcount>
					<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
					<cfoutput query="get_requests" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
						<tr <cfif isdefined('STATUS') and STATUS eq ''>style="color:red;"</cfif>>
							<td>#currentrow#</td>
							<td><cf_duxi type="label" name="TC_IDENTY_NO" id="TC_IDENTY_NO" value="#tc_identy_no#" hint="TC Kimlik No" gdpr="2"></td>
							<td>#employee_name# #employee_surname#</td>
							<td>
								<cfif listgetat(attributes.fuseaction,1,'.') is 'ehesap'>
									<cfif isnumeric(STATUS)>
										<cfset MY_SEND="openBoxDraggable('#request.self#?fuseaction=ehesap.list_payment_requests&event=det&id=#ID#');">
									<cfelse>
										<cfset MY_SEND="openBoxDraggable('#request.self#?fuseaction=ehesap.list_payment_requests&event=upd&id=#id#');">
									</cfif>
									<a href="javascript://" class="tableyazi" <cfif isdefined('STATUS') and STATUS eq ''>style="color:red;"</cfif> onClick="#MY_SEND#">#SUBJECT#</a>
								<cfelse>
									#subject#
								</cfif>
							</td>
							<td>#comment_pay#</td>
							<td style="text-align:right;"><cf_duxi name='tutar' class="tableyazi" type="label" value="#TLFormat(AMOUNT)#" gdpr="7"> <cfset attributes.sayfa_toplam = attributes.sayfa_toplam + AMOUNT></td>
							<td style="text-align:center;">#money#<input type="hidden" name="money_#id#" id="money_#id#" value="#money#"></td>
							<td><cf_workcube_process type="color-status" process_stage="#PROCESS_STAGE#"></td>
							<td  style="text-align:right;">
								<cfif isdefined('STATUS') and STATUS eq 1>
								<cf_get_lang dictionary_id='58699.Onaylandı'>
								<cfelseif isdefined('STATUS') and STATUS eq 0>
								<cf_get_lang dictionary_id='57617.Reddedildi'>
								<cfelseif isdefined('STATUS') and not len(STATUS)>
								<cf_get_lang dictionary_id='57615.Onay Bekliyor'>
								</cfif>
							</td>
							<td><cfif len(action_id)><font color="green"><cf_get_lang dictionary_id="33793.Ödendi"></font><cfelse><font color="red"><cf_get_lang dictionary_id="33792.Ödenmedi"></font></cfif></td>
							<td>#dateformat(duedate,dateformat_style)#</td>
							<!-- sil -->
							<cfif listgetat(attributes.fuseaction,1,'.') is 'ehesap'>
								<td nowrap="nowrap">
									<a href="javascript://" onClick="#MY_SEND#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
									<cfif not len(action_id)>
										<!---talebe ait ödeme kaydı yok ise silinebilsin--->
										<a href="javascript://" onClick="javascript:if (confirm('<cf_get_lang dictionary_id="64656.Avans Kaydını Siliyorsunuz Emin misiniz?">')) openBoxDraggable('#request.self#?fuseaction=ehesap.emptypopup_del_payment_request&id=#id#&employee_id=#TO_EMPLOYEE_ID#'); else return false;"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>					
									</cfif>
								</td>
							</cfif>
							<cfif is_pay_request eq 1>
								<td style="text-align:center;">
									<cfif isdefined('STATUS') and STATUS eq 1> <!---sadece onaylanmis olanlari getirmesi icin --->
										<cfif not len(action_id)> <!---ödeme yada giden havale işlem kaydı yok ise secime izin ver--->
											<cfif is_view_session_company eq 1>
													<cfset get_branches = cmp_branches.get_branches_company(to_employee_id)>
													<cfset list_cmp_id = valueList(get_branches.COMPANY_ID)>
												<cfif listFind(list_cmp_id,session.ep.company_id)><!--- sadece sisteme giriş yapılmış olan şirkete ait kayıtlar seçilebilir--->
													<input type="checkbox" name="is_sec" id="is_sec" value="#id#">
												</cfif>
											<cfelse>
												<input type="checkbox" name="is_sec" id="is_sec" value="#id#">
											</cfif>
										<cfelse>
											<input type="checkbox" name="is_sec" id="is_sec" checked="checked" value="0" disabled="disabled">
										</cfif>
									<cfelse>
										<input type="checkbox" name="is_sec" id="is_sec" value="0" disabled="disabled">
									</cfif>
								</td>
							</cfif>
							<!-- sil -->
						</tr>
					</cfoutput>
				</tbody>
				<cfoutput>
					<tfoot>
						<tr>
							<td></td>
							<td></td>
							<td></td>
							<td class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id ='54171.Alt Toplam'></td>
							<td class="txtbold" style="text-align:right;"><cfoutput>#tlformat(attributes.sayfa_toplam)#</cfoutput></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
					</tfoot>
				</cfoutput>
				<cfelse>
					<tr>
						<td colspan="12"><cfif isdefined('attributes.form_submit')><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
					</tr>
				</cfif>
			</cf_grid_list>
		</form>
	</cf_box>
	<cf_box>
		<div class="ui-info-bottom flex-end">
			<cf_box_elements>
				<cfoutput>
					<cfif is_pay_request eq 1>
						<div class="form-group">
							<select name="payment_type_id" id="payment_type_id">
								<option value=""><cf_get_lang dictionary_id='58928.Ödeme Tipi'></option>
								<cfloop query="get_special_definition">
									<option value="#special_definition_id#">#get_special_definition.special_definition#</option>
								</cfloop>
							</select>
						</div>
						<div class="form-group">
							<a href="javascript://" id="btn" name="btn" onclick="pencere_ac(1)" class="ui-btn ui-btn-success"><cf_get_lang dictionary_id='57835.Giden Havale'></a>
						</div>
						<div class="form-group">
							<a href="javascript://" id="btn2" name="btn2" onclick="pencere_ac(2)" class="ui-btn ui-btn-success"><cf_get_lang dictionary_id='57847.Ödeme'></a>
						</div>
					</cfif>
				</cfoutput>
			</cf_box_elements>
		</div>
	</cf_box>
	<cfif attributes.totalrecords gt attributes.maxrows>
		<cf_paging page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="ehesap.list_payment_requests&#url_str#&sayfa_toplam=#attributes.sayfa_toplam#">
	</cfif>
</div>

<script type="text/javascript">
	document.getElementById('keyword').focus();
	function pencere_ac(deger)
	{ 
		var sayac = 0;
		var money_control = 1;  
		var money_temp = '';
		<cfif get_requests.recordcount>
			<cfif get_requests.recordcount gt 1>
				if(form.is_sec != undefined)
				{
					for(i=0;i<form.is_sec.length;i++) 
					{
						if(form.is_sec[i] != undefined && document.form.is_sec[i].disabled != true && form.is_sec[i].checked == true)
						{
							sayac ++;
							if(document.getElementById('payment_ids').value.length==0) ayirac=''; else ayirac=',';
							document.getElementById('payment_ids').value=document.getElementById('payment_ids').value+ayirac+document.form.is_sec[i].value;
							if (money_temp == '')
								money_temp = $('#money_'+document.form.is_sec[i].value).val();
							if (money_temp.length && money_temp != $('#money_'+document.form.is_sec[i].value).val())
								money_control = 0;
						}
					}
				}
				else if(document.form.is_sec.value != undefined && document.form.is_sec.value != 0 && document.form.is_sec.disabled != true)
				{
					sayac ++;
					document.getElementById('payment_ids').value = document.form.is_sec.value;
				}
			<cfelse>
				if(document.form.is_sec.value != undefined && document.form.is_sec.value != 0 && document.form.is_sec.disabled != true)
				{
					sayac ++;
					document.getElementById('payment_ids').value = document.form.is_sec.value;
				}
			</cfif>
			if (money_control == 0)
			{
				alert("<cf_get_lang dictionary_id='54615.Seçtiğiniz satırların para birimi aynı olmalıdır'>. <cf_get_lang dictionary_id='33877.Lütfen kontrol ediniz !'>");
				return false;
			}
			else if(sayac == 0)
			{
				alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57692.İşlem'>");
				return false;
			}
			else{
			windowopen('','wide','select_list_window');
			if(deger == 1)
			{
				form.action='<cfoutput>#request.self#?fuseaction=bank.form_add_gidenh&event=addMulti</cfoutput>';
			}
			else if (deger == 2)
			{
				form.action='<cfoutput>#request.self#?fuseaction=cash.form_add_cash_payment&event=addMulti</cfoutput>';
			}
			form.target='select_list_window';
			form.submit();
			document.getElementById('payment_ids').value='';
			}
		</cfif>
	}
	function hepsi()
	{
		if (document.getElementById('all_check').checked)
			{
		<cfif get_requests.recordcount gt 1>	
			for(i=0;i<form.is_sec.length;i++) 
			{
				form.is_sec[i].checked = true;
			}
		<cfelseif get_requests.recordcount eq 1>
			form.is_sec.checked = true;
		</cfif>
			}
		else
			{
		<cfif get_requests.recordcount gt 1>	
			for(i=0;i<form.is_sec.length;i++) 
			{
				form.is_sec[i].checked = false;
			}
		<cfelseif get_requests.recordcount eq 1>
			form.is_sec.checked = false;
		</cfif>
			}
	}
	function showBranch(comp_id)	
	{
		var comp_id = document.myform.comp_id.value;
		if (comp_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&comp_id="+comp_id+"&is_department=0";
			AjaxPageLoad(send_address,'BRANCH_PLACE',1,'<cf_get_lang dictionary_id="55769.İlişkili Şubeler">');
		}
	}
</script>
<cf_get_lang_set module_name="#listgetat(attributes.fuseaction,1,'.')#">