<!---Bu sayfa attributes.str_account_code olmadan calismaz!!!--->
<!---Select  ifadeleri ile ilgili çalışma yapıldı. Egemen Ateş 16.07.2012 --->
<cfparam name="attributes.str_account_code" default="">
<cfparam name="attributes.acc_code_type" default="0">
<cfparam name="attributes.acc_branch_id" default="">
<cfparam name="attributes.acc_card_type" default="">
<cfparam name="attributes.priority_type" default="">
<cfparam name="attributes.report_type" default="">
<cfquery name="get_account_plan" datasource="#DSN2#">
	SELECT 
		SUB_ACCOUNT,
		ACCOUNT_CODE 
	FROM
		ACCOUNT_PLAN
	WHERE
		ACCOUNT_CODE= '#attributes.str_account_code#'
		OR ACCOUNT_CODE= '#attributes.str_account_code#.%'
</cfquery>
<cfquery name="get_max_len" datasource="#dsn2#">
	SELECT MAX(len(replace(ACCOUNT_PLAN.ACCOUNT_CODE, '.', '.' + ' ')) - len(ACCOUNT_PLAN.ACCOUNT_CODE)) MAX_LEN FROM ACCOUNT_PLAN
</cfquery>
<cfinclude template="../query/get_moneys.cfm">
<cfinclude template="../query/get_branch_list.cfm">
<cfif not isdefined('attributes.date1') or not isdate(attributes.date1)>
	<cfset date1="01/01/#session.ep.period_year#">
<cfelse>
	<cf_date tarih="attributes.date1">
	<cfset date1=dateformat(attributes.date1,dateformat_style)>
</cfif> 
<cfif not isdefined('attributes.date2') or  not isdate(attributes.date2)>
	<cfset date2="31/12/#session.ep.period_year#">
<cfelse>
	<cf_date tarih="attributes.date2">
	<cfset date2=dateformat(attributes.date2,dateformat_style)>
</cfif>
<cfparam name="attributes.sub_accounts" default="4"> <!--- tüm alt hesapların listelenmesini saglar. burdaki deger list_scale.cfm sayfasında sub_accounts selectbox ı ile ortaktır. --->
<cfparam name="attributes.expense_center_id" default="">
<cfinclude template="../query/get_scales.cfm">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_acc_remainder.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_box title="#getLang('account',4)#" uidrop="1">
	<cfform name="form" action="#request.self#?fuseaction=account.popup_list_scale" method="post">
		<cf_box_search>
				<div class="form-group" id="item-project_id_">
					<div class="input-group">
						<cfif isdefined('attributes.project_head') and len(attributes.project_head)>
							<cfset project_id_ = attributes.project_id>
						<cfelse>
							<cfset project_id_ = ''>
						</cfif>
						<cf_wrkProject
							project_Id="#project_id_#"
							width="110"
							AgreementNo="1" Customer="2" Employee="3" Priority="4" Stage="5"
							boxwidth="600"
							boxheight="400">
					</div>
				</div>  
				<div class="form-group" id="item-str_account_code">
					<div class="input-group">
					<cfinput value="#date1#" required="Yes" message="#getLang('','Lütfen İşlem Başlangıç Tarihini Giriniz !',47349)#" type="text" name="date1">
					<span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>
					<input type="hidden" name="str_account_code" id="str_account_code" value="<cfoutput>#attributes.str_account_code#</cfoutput>">
				</div>
			</div> 
				<div class="form-group" id="item-str_account_code">
					<div class="input-group">
					<cfinput value="#date2#" required="Yes" message="#getLang('','Lütfen İşlem Bitiş Tarihini Giriniz !',47293)#" type="text" name="date2">
					<span class="input-group-addon"><cf_wrk_date_image date_field="date2"></span>
				</div>
			</div> 
			<div class="form-group" id="item-money">
				<label><cf_get_lang dictionary_id ='57648.Kur'></label>
				<select name="money" id="money" onChange="get_rate();">
					<cfoutput query="GET_MONEYS">
						<option value="#MONEY#" <cfif isdefined('attributes.money') and attributes.money eq MONEY>selected<cfelseif not isdefined('attributes.money') and MONEY eq SESSION.EP.MONEY>selected</cfif>>#MONEY#</option>
					</cfoutput>
				</select>
			</div>
			<div class="form-group" id="item-old_money"> 
				<cfif not isdefined('attributes.rate')><cfset attributes.rate = 1></cfif>
				<cfif not isdefined('attributes.money')><cfset attributes.money = SESSION.EP.MONEY></cfif>
				<input type="hidden" name="old_money" id="old_money" value="<cfoutput>#attributes.money#</cfoutput>">
				<cfinput type="text" name="rate" id="rate" class="moneybox" value="#TLFormat(attributes.rate,session.ep.our_company_info.rate_round_num)#" range="1," onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" message="Kur Bilgisi olarak Sayısal Değer Giriniz!" required="yes">
			</div>
			<div class="form-group" id="item-money_type_"> 
				<select name="money_type_" id="money_type_">
					<option value="1" <cfif isDefined("attributes.money_type_") and attributes.money_type_ eq 1>selected</cfif>><cf_get_lang dictionary_id="57677.Döviz"> <cf_get_lang dictionary_id="57734.Seçiniz"></option>
					<option value="2" <cfif isDefined("attributes.money_type_") and attributes.money_type_ eq 2>selected</cfif>>2.<cf_get_lang dictionary_id='57677.Döviz'>
					<option value="3" <cfif isDefined("attributes.money_type_") and attributes.money_type_ eq 3>selected</cfif>><cf_get_lang dictionary_id='58121.Islem Dövizi'></option>
				</select>
			</div> 
			<div class="form-group small">
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
			</div>
			<div class="form-group">
				<cf_wrk_search_button button_type="4" search_function='control_scale_detail()'>
				<!--- <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'> --->
			</div>
		</cf_box_search>
		<cf_box_search_detail>
			<input  type="hidden" name="form_varmi" id="form_varmi" value="1">
			<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group" id="item-is_quantity">
					<label><cf_get_lang dictionary_id ='47527.Miktar Göster'><input type="checkbox" name="is_quantity" id="is_quantity" value="1" <cfif isdefined('attributes.is_quantity')>checked</cfif>></label>
				</div>
				<div class="form-group" id="item-show_main_account">
					<label><cf_get_lang dictionary_id="47554.Üst Hesaplar Gelmesin"><input type="checkbox" name="show_main_account" id="show_main_account" value="0" <cfif isdefined('attributes.show_main_account')>checked<cfelseif attributes.sub_accounts eq 0>disabled</cfif>></label>
				</div>
				<div class="form-group" id="item-no_process_accounts">
					<label><cf_get_lang dictionary_id="47555.Hareket Görmeyenleri Getirme"><input type="checkbox" name="no_process_accounts" id="no_process_accounts" value="0" <cfif isdefined('attributes.no_process_accounts')>checked</cfif>></label>
				</div>
				<div class="form-group" id="item-is_bakiye">
					<label><cf_get_lang dictionary_id ='47402.Sadece Bakiyesi Olanlar'><input type="checkbox" name="is_bakiye" id="is_bakiye" value="1" <cfif isdefined('attributes.is_bakiye')>checked</cfif>></label>
				</div>
			</div>
			<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
				<div class="form-group" id="item-priority_type">
					<div class="col col-12">
						<select name="priority_type" id="priority_type" >
							<option value="0"><cf_get_lang dictionary_id="57485.Öncelik"></option>
							<option value="1" <cfif attributes.priority_type eq 1>selected</cfif>><cf_get_lang dictionary_id="58960.Rapor Tipi"> <cf_get_lang dictionary_id="58944.Öncelikli"></option>
						</select>
					</div>
						
				</div>
				<div class="form-group" id="item-report_type">
					<div class="col col-12">
						<select name="report_type" id="report_type" >
							<option value="0"><cf_get_lang dictionary_id="58960.Rapor Tipi"></option>
							<option value="1" <cfif attributes.report_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57572.Departman'></option>
							<option value="2" <cfif attributes.report_type eq 2>selected</cfif>><cf_get_lang dictionary_id='57453.Sube'></option>
							<option value="3" <cfif attributes.report_type eq 3>selected</cfif>><cf_get_lang dictionary_id='57416.Proje'></option>
							<option value="4" <cfif attributes.report_type eq 4>selected</cfif>><cf_get_lang dictionary_id="57985.Üst"> <cf_get_lang dictionary_id="57416.Proje"></option>
						</select>
					</div>
						
				</div>
				<div class="form-group" id="item-sub_accounts">
					<div class="col col-12">
						<select name="sub_accounts" id="sub_accounts" onChange="kontrol_report_type();" >
							<option value="0" <cfif attributes.sub_accounts eq 0>selected</cfif>><cf_get_lang dictionary_id ='47399.Üst Hesaplar'></option>
							<cfloop from="1" to="#get_max_len.max_len#" index="kk">
								<option value="<cfoutput>#kk#</cfoutput>" <cfif attributes.sub_accounts eq kk>selected</cfif>><cfoutput>#kk#</cfoutput>.<cf_get_lang dictionary_id ='47370.Alt Hesaplar'></option>
							</cfloop>
							<option value="-1" <cfif attributes.sub_accounts eq -1>selected</cfif>><cf_get_lang dictionary_id ='47400.Tüm Alt Hesaplar'></option>
						</select>
					</div>
						
				</div>
				<div class="form-group" id="item-acc_code_type">
					<div class="col col-12">
						<select name="acc_code_type" id="acc_code_type" >
							<option value="0" <cfif attributes.acc_code_type eq 0>selected</cfif>><cf_get_lang dictionary_id='58793.Tek Düzen'></option>
							<option value="1" <cfif attributes.acc_code_type eq 1>selected</cfif>><cf_get_lang dictionary_id='58308.UFRS'></option>
						</select>
					</div>
						
				</div>
			</div>
			<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
				<div class="form-group" id="item-acc_card_type">
					<label class="col col-12"><cf_get_lang dictionary_id='58756.Açılış Fişi'></label>
					<div class="col col-12">
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
						
				</div>
			</div>
			<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
				<div class="form-group" id="item-acc_branch_id">
					<label class="col col-12"><cf_get_lang dictionary_id='57453.Şube'></label>
					<div class="col col-12">
						<select multiple="multiple" name="acc_branch_id" id="acc_branch_id" >
							<optgroup label="<cf_get_lang dictionary_id='57453.Şube'>"></optgroup>
							<cfoutput query="get_branchs">
								<option value="#BRANCH_ID#" <cfif isdefined('attributes.acc_branch_id') and listfind(attributes.acc_branch_id,BRANCH_ID)>selected</cfif>>#BRANCH_NAME#</option>
							</cfoutput>
						</select>
					</div>
				</div>
			</div>
		</cf_box_search_detail>
	</cfform>
	<!-- sil -->
	<cf_grid_list>
		<thead>
			<tr>
				<cfset row_colspan_number_ = 2>
				<th><cfif attributes.acc_code_type eq 1><cf_get_lang dictionary_id='47284.UFRS Hesap Kodu'><cfelse><cf_get_lang dictionary_id='47299.Hesap Kodu'></cfif></th>
				<th><cfif attributes.acc_code_type eq 1><cf_get_lang dictionary_id ='47296.UFRS Hesap Adı'><cfelse><cf_get_lang dictionary_id='47300.Hesap Adı'></cfif></th>
				<cfif attributes.report_type eq 1>
					<th><cf_get_lang dictionary_id="57453.Sube">-<cf_get_lang dictionary_id="57572.Departman"></th>
					<cfset row_colspan_number_ = row_colspan_number_+1>
				<cfelseif attributes.report_type eq 2>
					<th><cf_get_lang dictionary_id="57453.Sube"></th>
					<cfset row_colspan_number_ = row_colspan_number_+1>
				<cfelseif attributes.report_type eq 3>
					<th><cf_get_lang dictionary_id="57416.Proje"></th>
					<cfset row_colspan_number_ = row_colspan_number_+1>
				<cfelseif attributes.report_type eq 4>
					<th><cf_get_lang dictionary_id="57416.Proje"></th>
					<cfset row_colspan_number_ = row_colspan_number_+1>
				</cfif>
				<cfif isdefined('attributes.money_type_') and attributes.money_type_ eq 1>
					<th class="text-right"><cf_get_lang dictionary_id='57587.Borç'></th>
					<th class="text-right"><cf_get_lang dictionary_id='57588.Alacak'></th>
					<th class="text-right" ><cf_get_lang dictionary_id ='47441.Bakiye Borç'></th>
					<th class="text-right"><cf_get_lang dictionary_id ='47442.Bakiye Alacak'></th>
				</cfif>
				<cfif isdefined('attributes.money_type_') and attributes.money_type_ eq 2>
					<cfoutput>
						<th class="text-right">#session.ep.money2# <cf_get_lang dictionary_id='57587.Borç'></th>
						<th class="text-right">#session.ep.money2# <cf_get_lang dictionary_id='57588.Alacak'></th>
						<th class="text-right">#session.ep.money2# <cf_get_lang dictionary_id ='47441.Bakiye Borç'></th>
						<th class="text-right">#session.ep.money2# <cf_get_lang dictionary_id ='47442.Bakiye Alacak'></th>
					</cfoutput>
				</cfif>
				<cfif isdefined('attributes.money_type_') and attributes.money_type_ eq 3>
					<th class="text-right"><cf_get_lang dictionary_id='58121.İşlem Dövizi'><cf_get_lang dictionary_id='57587.Borç'></th>
					<th class="text-right"><cf_get_lang dictionary_id='58121.İşlem Dövizi'><cf_get_lang dictionary_id='57588.Alacak'></th>
					<th class="text-right"><cf_get_lang dictionary_id='58121.İşlem Dövizi'><cf_get_lang dictionary_id ='47441.Bakiye Borç'></th>
					<th class="text-right"><cf_get_lang dictionary_id='58121.İşlem Dövizi'><cf_get_lang dictionary_id ='47442.Bakiye Alacak'></th>
				</cfif>
				<!-- sil --><th width="15"></th><!-- sil -->
			</tr>
		</thead>
			<cfif get_acc_remainder.recordcount>
				<cfscript>
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
					alacak_bakiye_tpl_2 = 0;
					acc_dept_id_list='';
					acc_branch_id_list='';
					acc_pro_id_list='';
				</cfscript>
				<cfif attributes.startrow gt 1>
					<cfoutput query="get_acc_remainder" startrow="1" maxrows="#attributes.startrow-1#">
						<cfif listlen(ACCOUNT_CODE,'.') eq 1 >
							<cfif (isdefined('attributes.is_system_money') and attributes.is_system_money eq 1) or not isdefined('attributes.form_varmi')>
								<cfset total_borc=total_borc+(BORC/attributes.rate)>
								<cfset total_alacak=total_alacak+(ALACAK/attributes.rate)>
								<cfset total_bakiye=total_bakiye+(BAKIYE/attributes.rate)>
								<cfif BORC gt ALACAK>
									<cfset borc_bakiye_tpl=borc_bakiye_tpl+abs(BAKIYE/attributes.rate)>
								<cfelse>
									<cfset alacak_bakiye_tpl=alacak_bakiye_tpl+abs(BAKIYE/attributes.rate)>
								</cfif>
							</cfif>
							<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
								<cfset total_borc2 = total_borc2 + BORC_2>
								<cfset total_alacak2 = total_alacak2 + ALACAK_2>
								<cfset total_bakiye2 = total_bakiye2 + BAKIYE_2>
								<cfif BORC_2 GT ALACAK_2>
									<cfset borc_bakiye_tpl_2 = borc_bakiye_tpl_2 + abs(BAKIYE_2)>
								<cfelse>
									<cfset alacak_bakiye_tpl_2 = alacak_bakiye_tpl_2 + abs(BAKIYE_2)>
								</cfif>
							</cfif>
						</cfif>
					</cfoutput>
				</cfif>
				<cfif attributes.startrow gt 1>
					<cfoutput>
					<tbody>
						<tr>
							<td colspan="#row_colspan_number_#"> <cf_get_lang dictionary_id='58034.Devreden'>: </td>
							<cfif isdefined('attributes.money_type_') and attributes.money_type_ eq 1>
								<td class="text-bold text-right">&nbsp;#TLFormat(total_borc)# #attributes.money#</td>
								<td class="text-bold text-right">&nbsp;#TLFormat(total_alacak)# #attributes.money#</td>
								<td class="text-bold text-right">&nbsp;#TLFormat(abs(borc_bakiye_tpl))# #attributes.money#</td>
								<td class="text-bold text-right">&nbsp;#TLFormat(abs(alacak_bakiye_tpl))# #attributes.money#</td>
							</cfif>
							<cfif isdefined('attributes.money_type_') and attributes.money_type_ eq 2>
								<td class="text-bold text-right">#TLFormat(total_borc2)#</td>
								<td class="text-bold text-right">#TLFormat(total_alacak2)#</td>
								<td class="text-bold text-right">#TLFormat(abs(borc_bakiye_tpl_2))#</td>
								<td class="text-bold text-right">#TLFormat(abs(alacak_bakiye_tpl_2))#</td>
							</cfif>
							<cfif isdefined('attributes.money_type_') and attributes.money_type_ eq 3>
								<td class="text-bold text-right">&nbsp;</td>
								<td class="text-bold text-right">&nbsp;</td>
								<td class="text-bold text-right">&nbsp;</td>
								<td class="text-bold text-right">&nbsp;</td>
							</cfif>
							<!-- sil --><td width="15"></td><!-- sil -->
						</tr>
					</tbody>
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
				<cfoutput query="get_acc_remainder" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tbody>
					<tr>
						<td <cfif not Find(".",account_code)>class="txtbold"</cfif>>
						<cfif ListLen(account_code,".") neq 1>
							<cfloop from="1" to="#ListLen(account_code,".")#" index="i">&nbsp;</cfloop>
						</cfif>
						#account_code#
						</td>
						<td <cfif not Find(".",account_code)>class="txtbold"</cfif>>#account_name#</td>
						<cfif attributes.report_type eq 1>
							<td>
								<cfif len(acc_dept_id_list) and len(department_id)>
									#get_acc_dept.BRANCH_NAME[listfind(acc_dept_id_list,department_id)]#-#get_acc_dept.DEPARTMENT_HEAD[listfind(acc_dept_id_list,department_id)]#
								</cfif>
							</td>
						<cfelseif attributes.report_type eq 2>
							<td>
								<cfif len(acc_branch_id_list) and len(branch_id)>
									#get_acc_dept.BRANCH_NAME[listfind(acc_branch_id_list,branch_id)]#
								</cfif>
							</td>
						<cfelseif attributes.report_type eq 3 or attributes.report_type eq 4>
							<td>
								<cfif len(acc_pro_id_list) and len(acc_project_id)>
									#get_pro_detail.PROJECT_HEAD[listfind(acc_pro_id_list,acc_project_id)]#
								</cfif>
							</td>
						</cfif>
						<cfif isdefined('attributes.money_type_') and attributes.money_type_ eq 1>
							<cfset BORC_=BORC/attributes.rate>
							<cfset ALACAK_=ALACAK/attributes.rate>
							<cfset BAKIYE_=BAKIYE/attributes.rate>
							<td class="text-right">&nbsp;#TLFormat(BORC_)# #attributes.money#</td>
							<td class="text-right">&nbsp;#TLFormat(ALACAK_)# #attributes.money#</td>
							<td class="text-right">&nbsp;
							<cfif BORC GT ALACAK>
								#TLFormat(abs(BAKIYE_))# #attributes.money#
								<cfif listlen(ACCOUNT_CODE,'.') eq 1><cfset borc_bakiye_tpl=borc_bakiye_tpl+abs(BAKIYE_)></cfif>
							</cfif>
							</td>
							<td class="text-right">&nbsp;
							<cfif BORC LT ALACAK>
								#TLFormat(abs(BAKIYE_))# #attributes.money#
								<cfif listlen(ACCOUNT_CODE,'.') eq 1><cfset alacak_bakiye_tpl=alacak_bakiye_tpl+abs(BAKIYE_)></cfif> 
							</cfif>
							</td>
						</cfif>
						<cfif isdefined('attributes.money_type_') and attributes.money_type_ eq 2>
							<td class="text-right">#TLFormat(BORC_2)# #session.ep.money2#</td>				
							<td class="text-right">#TLFormat(ALACAK_2)# #session.ep.money2#</td>
							<cfif BORC_2 GT ALACAK_2>
								<td class="text-right"> #TLFormat(abs(BAKIYE_2))#
									<cfif listlen(ACCOUNT_CODE,'.') eq 1><cfset borc_bakiye_tpl_2=borc_bakiye_tpl_2+abs(BAKIYE_2)></cfif>
								</td>
								<td class="text-right"></td>
							<cfelse>
								<td class="text-right"></td>				
								<td class="text-right"> #TLFormat(abs(BAKIYE_2))#
								<cfif listlen(ACCOUNT_CODE,'.') eq 1><cfset alacak_bakiye_tpl_2=alacak_bakiye_tpl_2+abs(BAKIYE_2)></cfif>
								</td>
							</cfif>
						</cfif>
						<cfif isdefined('attributes.money_type_') and attributes.money_type_ eq 3>
							<td class="text-right">#TLFormat(OTHER_BORC)# #OTHER_CURRENCY#</td>				
							<td class="text-right">#TLFormat(OTHER_ALACAK)# #OTHER_CURRENCY#</td>
							<cfif OTHER_BORC GT OTHER_ALACAK>
								<td class="text-right"> <cfif len(OTHER_BAKIYE)>#TLFormat(abs(OTHER_BAKIYE))#</cfif></td>
								<td class="text-right"></td>
							<cfelse>
								<td class="text-right" ></td>				
								<td class="text-right"><cfif len(OTHER_BAKIYE)>#TLFormat(abs(OTHER_BAKIYE))#</cfif> </td>
							</cfif>
						</cfif>	
						<cfif listlen(ACCOUNT_CODE,'.') eq 1>
						<cfif isdefined('attributes.money_type_') and attributes.money_type_ eq 1>
							<cfset total_borc_all=total_borc_all+BORC_>
							<cfset total_alacak_all=total_alacak_all+ALACAK_>
							<cfset total_bakiye_all=total_bakiye_all+BAKIYE_>
						</cfif>
						<cfif isdefined('attributes.money_type_') and attributes.money_type_ eq 2>
							<cfset total_borc_all_2 = total_borc_all_2 + BORC_2>
							<cfset total_alacak_all_2 = total_alacak_all_2 + ALACAK_2>
							<cfset total_bakiye_all_2 = total_bakiye_all_2 + BAKIYE_2>
						</cfif>
						</cfif>
						</td>
						<!-- sil -->
						<td width="15">
						<cfquery name="get_r" dbtype="query">
							SELECT SUB_ACCOUNT FROM get_account_plan WHERE ACCOUNT_CODE ='#account_code#'
						</cfquery>
						<cfif get_r.SUB_ACCOUNT neq 1>
							<cfif isdefined("attributes.date1") and isdefined("attributes.date2")>
								<a href="javascript:windowopen('#request.self#?fuseaction=account.popup_list_account_plan_rows&code=#account_code#&acc_code_type=#attributes.acc_code_type#&acc_branch_id=#attributes.acc_branch_id#&startdate=#dateformat(attributes.date1,dateformat_style)#&finishdate=#dateformat(attributes.date2,dateformat_style)#','list_horizantal');"><i class="fa fa-bar-chart" alt="<cf_get_lang dictionary_id='47370.Alt Hesaplar'>" title="<cf_get_lang dictionary_id='47370.Alt Hesaplar'>"></i></a>
							<cfelse>
								<a href="javascript:windowopen('#request.self#?fuseaction=account.popup_list_account_plan_rows&code=#account_code#&acc_code_type=#attributes.acc_code_type#&acc_branch_id=#attributes.acc_branch_id#','list_horizantal');"><i class="fa fa-bar-chart" alt="<cf_get_lang dictionary_id='47370.Alt Hesaplar'>" title="<cf_get_lang dictionary_id='47370.Alt Hesaplar'>"></i></a>
							</cfif>
						</cfif>
						</td>
						<!-- sil -->
					</tr>
				</tbody>
				</cfoutput>
				<cfset sayfa_ = attributes.totalrecords/attributes.maxrows>
				<cfif sayfa_ contains ".">
					<cfset sayfa_ = int(sayfa_)+1>
				</cfif>
				<cfif attributes.page eq sayfa_>
					<cfset total_borc_all = total_borc_all+total_borc>
					<cfset total_alacak_all = total_alacak_all+total_alacak>
					<cfset total_bakiye_all = total_bakiye_all+total_bakiye>
					<tfoot>
						<tr>
							<cfoutput>
							<td colspan="#row_colspan_number_#" class="textbold"> <cf_get_lang dictionary_id='57492.Toplam'>:</td>
							<cfif isdefined('attributes.money_type_') and attributes.money_type_ eq 1>
								<td class="text-bold text-right">#TLFormat(total_borc_all)# #attributes.money#</td>
								<td class="text-bold text-right">#TLFormat(total_alacak_all)# #attributes.money#</td>
								<td class="text-bold text-right">#TLFormat(abs(borc_bakiye_tpl))# #attributes.money#</td>
								<td class="text-bold text-right">#TLFormat(abs(alacak_bakiye_tpl))# #attributes.money#</td>
							</cfif>
							<cfif isdefined('attributes.money_type_') and attributes.money_type_ eq 2>
								<td class="text-bold text-right">#TLFormat(wrk_round(total_borc_all_2))#</td>
								<td class="text-bold text-right">#TLFormat(wrk_round(total_alacak_all_2))#</td>
								<td class="text-bold text-right">#TLFormat(abs(wrk_round(borc_bakiye_tpl_2)))#</td>
								<td class="text-bold text-right">#TLFormat(abs(wrk_round(alacak_bakiye_tpl_2)))#</td>
							</cfif>
							<cfif isdefined('attributes.money_type_') and attributes.money_type_ eq 3>
								<td colspan="4" class="text-bold text-right">&nbsp;</td>
							</cfif>
							</cfoutput>
							<!-- sil --><td></td><!-- sil -->
						</tr>
					</tfoot>
				</cfif>
			<cfelse>
			<tbody>
				<tr>
					<td colspan="7"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
				</tr>
			</tbody>
			</cfif>
		</tbody>
	</cf_grid_list>
	<!-- sil -->
	<cfset adres = 'account.popup_list_scale&str_account_code=#attributes.str_account_code#'>
	<cfset adres = '#adres#&money=#attributes.money#&rate=#attributes.rate#'>
	<cfset adres = '#adres#&date1=#date1#'>
	<cfset adres = '#adres#&date2=#date2#'>
	<cfif isDefined('attributes.sub_accounts')>
		<cfset adres = '#adres#&sub_accounts=#attributes.sub_accounts#'>
	</cfif>
	<cfif isDefined('attributes.other_money_based')>
		<cfset adres = '#adres#&other_money_based=#attributes.other_money_based#'>
	</cfif>
	<cfif isDefined('attributes.acc_code_type')>
		<cfset adres = '#adres#&acc_code_type=#attributes.acc_code_type#'>
	</cfif>
	<cfif isDefined('attributes.acc_branch_id')>
		<cfset adres = '#adres#&acc_branch_id=#attributes.acc_branch_id#'>
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
	<cf_paging 
		page="#attributes.page#"
		maxrows="#attributes.maxrows#"
		totalrecords="#attributes.totalrecords#"
		startrow="#attributes.startrow#"
		adres="#adres#">
</cf_box>
<script type="text/javascript">
	function kontrol_report_type()
	{
		if(document.getElementById("sub_accounts").value == 0)
		{
			document.getElementById("no_process_accounts").disabled = false;
			document.getElementById("show_main_account").disabled = true;
		}
		else
		{
			document.getElementById("no_process_accounts").disabled = true;
			document.getElementById("show_main_account").disabled = false;
		}
	}
	rate_list = new Array(<cfloop query=get_moneys><cfoutput>"#get_moneys.rate2#"</cfoutput><cfif not currentrow eq recordcount>,</cfif></cfloop>);
	function control_scale_detail()
	{
		if(document.getElementById("money_type_").value != 1 && document.getElementById("money_type_").value != 3 && document.getElementById("money_type_").value != 2)
			document.getElementById("money_type_").value = 1;
		if(document.getElementById("money").options[document.getElementById("money").selectedIndex].value != '<cfoutput>#session.ep.money#</cfoutput>' && document.getElementById("money_type_").value != 1)
		{
			alert("<cf_get_lang dictionary_id ='47405.Yeniden Değerleme Sistem Para Birimi Bazında Yapılabilir'>!");
			return false;
		}
		unformat_fields();
		return true;
	}
	function unformat_fields()
	{
		document.getElementById("rate").value = filterNum(document.getElementById("rate").value,"<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>");
		return true;
	}
	function get_rate()
	{
		document.getElementById("rate").value = commaSplit(rate_list[document.getElementById("money").selectedIndex],'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	}
</script>