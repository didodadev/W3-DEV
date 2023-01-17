<cf_get_lang_set module_name="bank">
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.account_currency_id" default="">
	<cfparam name="attributes.branch_id" default="">
	<cfparam name="attributes.acc_type" default="">
	<cfparam name="attributes.date1" default="">
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfparam name="attributes.is_bank_type" default=1>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	<cfif isdefined("attributes.date1") and len(attributes.date1)>
		<cf_date tarih="attributes.date1">
	</cfif>
	<cfif isdefined("attributes.form_submitted")>
		<cfinclude template="../query/get_account_list.cfm">
	<cfelse>
		<cfset get_account_list.recordcount=0>
	</cfif>
	<cfif attributes.is_bank_type eq 2>
		<cfquery name="get_bank_type" datasource="#dsn#">
			SELECT BANK_TYPE_ID, BANK_TYPE, QUATA_RATE FROM SETUP_BANK_TYPE_GROUPS
		</cfquery>
	</cfif>
	<cfinclude template="../query/get_money_rate.cfm">
	<cfif attributes.is_bank_type eq 2>
		<cfparam name="attributes.totalrecords" default="#get_bank_type.recordcount#">
	<cfelse>
		<cfparam name="attributes.totalrecords" default="#get_account_list.recordcount#">
	</cfif>
	<cfif fuseaction contains "popup">
		<cfset is_popup=1>
	<cfelse>
		<cfset is_popup=0>
	</cfif>
	<cfquery name="get_bank_names" datasource="#dsn#">
		SELECT BANK_ID,BANK_NAME FROM SETUP_BANK_TYPES ORDER BY BANK_NAME
	</cfquery>
	<div class="col col-12 col-xs-12">
		<cf_box>
			<cfform name="form" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_bank_account" method="post">
				<input type="hidden" name="is_bank_account" id="is_bank_account" value="1">
				<input type="hidden" name="form_submitted" id="form_submitted" value="1">
				<cf_box_search> 
					<div class="form-group">
						<cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" style="width:100px;" placeholder="#getLang(48,'Filtre',57460)#">
					</div>
					<div class="form-group">
						<select name="account_status" id="account_status">
							<option value=""><cf_get_lang dictionary_id='30111.Durumu'></option>
							<option value="1"<cfif isDefined("attributes.account_status") and (attributes.account_status eq 1)> selected</cfif>><cf_get_lang dictionary_id ='57493.Aktif'></option>
							<option value="0"<cfif isDefined("attributes.account_status") and (attributes.account_status eq 0)> selected</cfif>><cf_get_lang dictionary_id ='57494.Pasif'></option>
						</select>
					</div>
					<div class="form-group small">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#"  onKeyUp="isNumber(this)" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
					</div>
					<div class="form-group">
						<cf_wrk_search_button button_type="4">
					</div>
				</cf_box_search>
				<cf_box_search_detail>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-acc_type">
							<label class="col col-12"><cf_get_lang dictionary_id='48681.Hesap Tipi'></label>
							<div class="col col-12">
								<select name="acc_type" id="acc_type" style="width:100px;">
									<option value=""><cfoutput>#getLang('main',322)#</cfoutput></option>
									<option value="1" <cfif isdefined('attributes.acc_type') and attributes.acc_type eq 1>Selected</cfif> ><cf_get_lang dictionary_id='29447.Kredili'></option>
									<option value="2" <cfif isdefined('attributes.acc_type') and attributes.acc_type eq 2>Selected</cfif>><cf_get_lang dictionary_id='29446.ticari'></option>
									<option value="3" <cfif isdefined('attributes.acc_type') and attributes.acc_type eq 3>Selected</cfif>><cf_get_lang dictionary_id='57798.Vadeli'></option>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-date1">
							<label class="col col-12"><cf_get_lang dictionary_id='57742.Tarih'></label>
							<div class="col col-12">
							<div class="input-group">
								<cfinput type="text" name="date1" id="date1" value="#dateformat(attributes.date1,dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10">
								<span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>
								</div>
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-bank_id">
							<label class="col col-12"><cf_get_lang dictionary_id='48695.Banka Adı'></label>
							<div class="col col-12">
								<select name="bank_id" id="bank_id" style="width:150px;">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>  
									<cfoutput query="get_bank_names">
										<option <cfif isdefined('attributes.bank_id') and attributes.bank_id eq BANK_ID>selected</cfif> value="#BANK_ID#">#bank_name#</option>
									</cfoutput>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-is_bank_type">
							<label class="col col-12"><cf_get_lang dictionary_id='36815.Grupla'></label>
							<div class="col col-12">
								<select name="is_bank_type" id="is_bank_type">
									<option <cfif isdefined('attributes.is_bank_type') and attributes.is_bank_type eq 1>selected</cfif> value="1"><cf_get_lang dictionary_id='60996.Banka Hesaplarına Göre'></option>
									<option <cfif isdefined('attributes.is_bank_type') and attributes.is_bank_type eq 2>selected</cfif> value="2"><cf_get_lang dictionary_id='34790.Banka Tipine Göre Grupla'></option>
									<option <cfif isdefined('attributes.is_bank_type') and attributes.is_bank_type eq 3>selected</cfif> value="3"><cf_get_lang dictionary_id='60997.Bankalara Göre'></option>
								</select>
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
						<div class="form-group" id="item-branch_id">
							<label class="col col-12"><cf_get_lang dictionary_id='57453.Şube'></label>
							<div class="col col-12">
								<cfinclude template="../query/get_branches.cfm">
								<select name="branch_id" id="branch_id" style="width:100px;" >
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="get_branches">
										<option <cfif isdefined('attributes.branch_id') and attributes.branch_id eq BANK_BRANCH_ID> Selected </cfif> value="#BANK_BRANCH_ID#">#BANK_BRANCH_NAME#</option>
									</cfoutput>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-is_bakiye">
							<div class="input-group x-8">
								<label class="col col-12"><cf_get_lang dictionary_id='40363.Sadece Bakiyesi Olanlar'></label>
								<div class="col col-12">
									<input type="checkbox" name="is_bakiye" id="is_bakiye" value="1" <cfif isDefined("attributes.is_bakiye") and attributes.is_bakiye eq 1>checked</cfif>>
								</div>
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
						<div class="form-group" id="item-account_currency_id">
							<label class="col col-12"><cf_get_lang dictionary_id='57489.Para Birimi'></label>
							<div class="col col-12">
								<select name="account_currency_id" id="account_currency_id">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="get_money_rate">
										<option value="#money#" <cfif attributes.account_currency_id eq money>selected</cfif>>#money#</option>
									</cfoutput>
								</select>
							</div>
						</div>
					</div>
				</cf_box_search_detail>
			</cfform>
		</cf_box>
		<cf_box title="#getLang(1590,'Banka Hesapları',59002)#" uidrop="1" hide_table_column="1">
			<cf_grid_list>
				<thead>
					<tr>
						<cfif attributes.is_bank_type eq 1> <!--- Banka Hesaplarına Göre --->
							<th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
							<th><cf_get_lang dictionary_id='48676.Son Hareket'></th>
							<th><cf_get_lang dictionary_id='48677.Hesap Adı'></th>
							<th><cf_get_lang dictionary_id='57453.Şube'></th>
							<th><cf_get_lang dictionary_id='58178.Hesap No'></th>
							<th><cf_get_lang dictionary_id='59007.IBAN Kodu'></th>
							<th><cf_get_lang dictionary_id='48681.hesap tipi'></th>
							<th><cf_get_lang dictionary_id='34102.banka tipi'></th>
							<th class="text-right"><cf_get_lang dictionary_id='57589.Bakiye'></th> 
							<th><cf_get_lang dictionary_id='58180.Borçlu'>/<cf_get_lang dictionary_id='50129.Alacaklı'></th>
							<th class="text-right"><cf_get_lang dictionary_id='48683.Kullanılabilir Bakiye'></th>
							<th><cf_get_lang dictionary_id='58180.Borçlu'>/<cf_get_lang dictionary_id='50129.Alacaklı'></th>
							<th class="text-right"><cf_get_lang dictionary_id="41984.WoDiBa Bakiye"></th>
							<th class="text-right"><cf_get_lang dictionary_id='58583.Fark'></th>
							<th><cf_get_lang dictionary_id='57489.Para birimi'></th>
							<cfif not len(attributes.date1)>			
								<th class="text-right"><cf_get_lang dictionary_id="60083.Güncel Bakiye"><cfoutput>#session.ep.money#</cfoutput></th>
							</cfif>	
							<th class="text-right"><cf_get_lang dictionary_id='58963.Kredi Limiti'></th>
							<cfif isDefined("attributes.date1") and len(attributes.date1)><th class="text-right" width="45"><cfoutput>#dateformat(attributes.date1,dateformat_style)#</cfoutput> <cf_get_lang dictionary_id='57589.Bakiye'></th></cfif>
							<th><cf_get_lang dictionary_id ='57756.Durum'></th>
							<!-- sil -->
							<th width="20" class="header_icn_none"><cfif not listfindnocase(denied_pages,'#listgetat(attributes.fuseaction,1,'.')#.form_add_bank_account') and (session.ep.admin eq 1 or get_module_power_user(19))>
								<a href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.</cfoutput>list_bank_account&event=add"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='57582.Ekle'>" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></cfif>
							</th>
							<!-- sil -->
						<cfelseif attributes.is_bank_type eq 2> <!--- Banka Tipine Göre --->
							<th width="20"></th>
							<th><cf_get_lang dictionary_id='34102.banka tipi'></th>
							<th class="text-right"><cf_get_lang dictionary_id='57589.Bakiye'></th>
							<th><cf_get_lang dictionary_id='57489.Para birimi'></th>
							<th class="text-right"><cf_get_lang dictionary_id='35580.Mevcut Oran'>%</th>
							<th class="text-right"><cf_get_lang dictionary_id='35558.Planlanan Oran'>%</th>
						<cfelseif attributes.is_bank_type eq 3>
							<th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
							<th><cf_get_lang dictionary_id='57521.Banka'></th>
							<th class="text-right"><cf_get_lang dictionary_id='58147.Sistem'> <cf_get_lang dictionary_id='57589.Bakiye'></th>
							<th class="text-right"><cf_get_lang dictionary_id='58180.Borçlu'>/<cf_get_lang dictionary_id='50129.Alacaklı'></th>
							<th><cf_get_lang dictionary_id='33046.Sistem Para Birimi'></th>
						</cfif>
					</tr>
				</thead>
				<cfset col_ = 19>
				<cfset money_list = ''>
				<cfset money_list2 = ''>
				<cfset useful_money_list = ''>
				<cfset useful_money_list2 = ''>
				<cfset system_bakiye_top= 0>
				<cfset day_currency_bakiye_total = 0>
				<cfif get_account_list.recordcount>
				<tbody>
					<cfset acc_id_list = ''>
					<cfif attributes.is_bank_type eq 1>
						<cfoutput query="get_account_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<cfif len(ACCOUNT_ID) and not listfind(acc_id_list,ACCOUNT_ID)>
								<cfset acc_id_list=listappend(acc_id_list,ACCOUNT_ID)>
							</cfif>
						</cfoutput>
						<cfif len(acc_id_list)>
							<cfset acc_id_list=listsort(acc_id_list,"numeric","ASC",",")>
							<cfif isDefined("attributes.date1") and len(attributes.date1)>
								<cfquery name="GET_DATE_ACC" datasource="#dsn2#">
									SELECT
										SUM(BORC-ALACAK) BAKIYE,
										ACCOUNT_ID
									FROM
										DAILY_ACCOUNT_REMAINDER
									WHERE
										ACCOUNT_ID IN (#acc_id_list#) AND
										ACTION_DATE <= #attributes.date1#							
									GROUP BY
										ACCOUNT_ID
									ORDER BY
										ACCOUNT_ID
								</cfquery>
								<cfset acc_id_list_date = valuelist(GET_DATE_ACC.ACCOUNT_ID)>
							</cfif>
							<cfquery name="GET_BAKIYE" datasource="#dsn2#">
								SELECT BAKIYE,TARIH,ACCOUNT_ID FROM ACCOUNT_REMAINDER_LAST WHERE ACCOUNT_ID IN (#acc_id_list#) ORDER BY ACCOUNT_ID
							</cfquery>
							<cfset acc_id_list2 = valuelist(GET_BAKIYE.ACCOUNT_ID)>
						</cfif>
						<cfoutput query="get_account_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<cfif len(get_account_list.ACCOUNT_CREDIT_LIMIT)>
								<cfset useful_bakiye=get_account_list.ACCOUNT_CREDIT_LIMIT>
							<cfelse>
								<cfset useful_bakiye=0>
							</cfif>
							<cfset bakiye_ = GET_BAKIYE.BAKIYE[listfind(acc_id_list2,ACCOUNT_ID,',')]>
							<cfif isDefined("attributes.date1") and len(attributes.date1)>
								<cfif len(GET_DATE_ACC.BAKIYE[listfind(acc_id_list_date,ACCOUNT_ID,',')])>
									<cfset bakiye_date = GET_DATE_ACC.BAKIYE[listfind(acc_id_list_date,ACCOUNT_ID,',')]>
								<cfelse>
									<cfset bakiye_date = 0>
								</cfif>
							</cfif>
							<cfif len(bakiye_)>
								<cfset useful_bakiye = bakiye_ + useful_bakiye>
								<cfelse>
								<cfset bakiye_ = 0>  
							</cfif>	 
								<cfset money = get_account_list.ACCOUNT_CURRENCY_ID>
								<cfset useful_money_ = #bakiye_#+#ACCOUNT_CREDIT_LIMIT#>
							<cfif bakiye_ gt 0>
								<cfset money_list = listappend(money_list,'#bakiye_#*#money#',',')>
								<cfset useful_money_list = listappend(useful_money_list,'#useful_money_#*#money#',',')>
								<cfelse>
								<cfset money_list = listappend(money_list,'#bakiye_#*#money#',',')>
								<cfset useful_money_list = listappend(useful_money_list,'#useful_money_#*#money#',',')>
							</cfif>
							<cfif isDefined("attributes.date1") and len(attributes.date1)>
								<cfset useful_money2_ = #bakiye_date#+#ACCOUNT_CREDIT_LIMIT#>
								<cfif bakiye_date gt 0>
									<cfset money_list2 = listappend(money_list2,'#bakiye_date#*#money#',',')>
									<cfset useful_money_list2 = listappend(useful_money_list2,'#useful_money2_#*#money#',',')>
								<cfelse>
									<cfset money_list2 = listappend(money_list2,'#bakiye_date#*#money#',',')>
									<cfset useful_money_list2 = listappend(useful_money_list2,'#useful_money2_#*#money#',',')>
								</cfif>	
							</cfif>
							<cfquery name="GET_WDB_BALANCE" datasource="#dsn#">
								SELECT BAKIYE FROM WODIBA_BANK_ACCOUNTS WHERE OUR_COMPANY_ID = #session.ep.COMPANY_ID# AND ACCOUNT_ID = #ACCOUNT_ID#
							</cfquery>
							<cfif GET_WDB_BALANCE.RecordCount And Len(GET_WDB_BALANCE.BAKIYE)>
								<cfset wdb_bakiye = GET_WDB_BALANCE.BAKIYE />
							<cfelse>
								<cfset wdb_bakiye = 0 />
							</cfif>
							<tr>
								<td>#currentrow#</td>
								<td><cfif len(GET_BAKIYE.TARIH[listfind(acc_id_list2,ACCOUNT_ID,',')])>#dateformat(GET_BAKIYE.TARIH[listfind(acc_id_list2,ACCOUNT_ID,',')],dateformat_style)#</cfif></td>
								<td>
									<cfif not listfindnocase(denied_pages,'#listgetat(attributes.fuseaction,1,'.')#.form_upd_bank_account') and (session.ep.admin eq 1 or get_module_power_user(19))>
										<a href="#request.self#?fuseaction=bank.list_bank_account&event=upd&id=#ACCOUNT_ID#" class="tableyazi">#get_account_list.ACCOUNT_NAME#</a>
									<cfelse>
										#get_account_list.ACCOUNT_NAME#
									</cfif>
								</td>
								<td width="200">#BANK_NAME# / #BANK_BRANCH_NAME#</td>
								<td>#ACCOUNT_NO#</td>
								<td>#ACCOUNT_OWNER_CUSTOMER_NO#</td>
								<td>
									<cfif ACCOUNT_TYPE eq 1>
										<cf_get_lang dictionary_id='29447.Kredili'>
									<cfelseif ACCOUNT_TYPE eq 2>
										<cf_get_lang dictionary_id='29446.Ticari'>
									<cfelse>
										<cf_get_lang dictionary_id='57798.Vadeli'>
									</cfif>
								</td>
								<td>#BANK_TYPE#</td>
								<td class="text-right"><cfif bakiye_ gt 0><span style="color:black"><cfelse><span style="color:red"></cfif>#TLFormat(ABS(bakiye_))#</span></span></td>
								<td><cfif bakiye_ gt 0><span style="color:black"><cf_get_lang dictionary_id='58180.Borçlu'></span><cfelse><span style="color:red"><cf_get_lang dictionary_id='50129.Alacaklı'></span></cfif></td>
								<td class="text-right"><cfif useful_BAKIYE gt 0><span style="color:black"><cfelse><span style="color:red"></cfif>#TLFormat(ABS(useful_bakiye))#</span></span></td>
								<td><cfif useful_BAKIYE gt 0><span style="color:black"><cf_get_lang dictionary_id='58180.Borçlu'></span><cfelse><span style="color:red"><cf_get_lang dictionary_id='50129.Alacaklı'></span></cfif></td>
								<td class="text-right"><cfif wdb_bakiye gt 0><span style="color:black"><cfelse><span style="color:red"></cfif>#TLFormat(ABS(wdb_bakiye))#</span></span></td>
								<td class="text-right">
									<cfif TLFormat(ABS(wdb_bakiye-useful_bakiye)) Neq "0,00">
										<cfif not listfindnocase(denied_pages,'#listgetat(attributes.fuseaction,1,'.')#.form_upd_bank_account') and get_module_power_user(19)>
											<a href="javascript:void(0);" onclick="openBoxDraggable('#request.self#?fuseaction=bank.wodiba_bank_accounts&event=diff&account_id=#ACCOUNT_ID#');" class="tableyazi">#TLFormat(ABS(wdb_bakiye-useful_bakiye))# <i class="fa fa-question-circle" style="color:red"></i></a>
										</cfif>
									<cfelse>
										#TLFormat(ABS(wdb_bakiye-useful_bakiye))#
									</cfif>
								</td>
								<td>&nbsp;#ACCOUNT_CURRENCY_ID#</td>
								<cfif not len(attributes.date1)>	
									<cfquery name="get_currency" datasource="#dsn2#">
										SELECT TOP 1 RATE3 FROM SETUP_MONEY WHERE MONEY = '#ACCOUNT_CURRENCY_ID#'
									</cfquery> 	 						
										<cfif len(get_currency.RATE3)> 	 						
											<cfset day_currency_bakiye = bakiye_*get_currency.RATE3> 
										<cfelse>
											<cfset day_currency_bakiye =0>
										</cfif> 
										<cfset day_currency_bakiye_total = day_currency_bakiye_total + day_currency_bakiye>	
									<td class="text-right">
										<cfif day_currency_bakiye gt 0><span style="color:black"><cfelse><span style="color:red"></cfif>#TLFormat(ABS(day_currency_bakiye))#</span></span>
									</td>
								</cfif> 
								<td class="text-right">#TLFormat(ACCOUNT_CREDIT_LIMIT)#</td>
								<cfif isDefined("attributes.date1") and len(attributes.date1)>
									<cfset col_ += 1>
									<td>#TLFormat(ABS(bakiye_date))#<cfif bakiye_date gt 0><cf_get_lang dictionary_id='58180.Borçlu'><cfelse><cf_get_lang dictionary_id='50129.Alacaklı'></cfif></td>
								</cfif>
								<td><cfif ACCOUNT_STATUS eq 1><cf_get_lang dictionary_id ='57493.Aktif'><cfelse><cf_get_lang dictionary_id ='57494.Pasif'></cfif></td>
								<!-- sil -->
								<td width="20">
									<cfif not listfindnocase(denied_pages,'#listgetat(attributes.fuseaction,1,'.')#.form_upd_bank_account') and (session.ep.admin eq 1 or get_module_power_user(19))>
										<a href="#request.self#?fuseaction=bank.list_bank_account&event=upd&id=#ACCOUNT_ID#"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
									</cfif>
								</td>
								<!-- sil -->
							</tr>
						</cfoutput>					
					<cfelseif attributes.is_bank_type eq 2>
						<cfset ara_top = 0>
						<cfset mevcut_oran_top = 0>
						<cfset planlanan_oran_top = 0>
						<cfset top_bakiye = 0>
						<cfoutput query="get_bank_type">
							<cfquery name="get_bank_with_type_list_bak" datasource="#dsn3#">
								SELECT ACCOUNTS.ACCOUNT_ID FROM
									ACCOUNTS LEFT JOIN BANK_BRANCH ON ACCOUNTS.ACCOUNT_BRANCH_ID=BANK_BRANCH.BANK_BRANCH_ID	
									LEFT JOIN #dsn_alias#.SETUP_BANK_TYPES ON SETUP_BANK_TYPES.BANK_ID = BANK_BRANCH.BANK_ID
									LEFT JOIN #dsn_alias#.SETUP_BANK_TYPE_GROUPS ON SETUP_BANK_TYPE_GROUPS.BANK_TYPE_ID = SETUP_BANK_TYPES.BANK_TYPE_GROUP_ID
								WHERE
									SETUP_BANK_TYPE_GROUPS.BANK_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_bank_type.bank_type_id#">
							</cfquery>
							<cfloop query="get_bank_with_type_list_bak">
								<cfset acc_id_list=listappend(acc_id_list,ACCOUNT_ID)>
							</cfloop>
							<cfif len(acc_id_list)>
								<cfset acc_id_list=listsort(acc_id_list,"numeric","ASC",",")>
								<cfquery name="GET_BAKIYE_TOP" datasource="#dsn2#">
									SELECT SUM(BAKIYE_SYSTEM) AS Bakiye FROM ACCOUNT_REMAINDER_LAST WHERE ACCOUNT_ID IN (#acc_id_list#)
								</cfquery>
							<cfelse>
								<cfset GET_BAKIYE_TOP.Bakiye = 0>
							</cfif>
						</cfoutput>
						<cfoutput query="get_bank_type">
							<cfset acc_id_list = ''>
							<cfquery name="get_bank_with_type_list" datasource="#dsn3#">
								SELECT
									ACCOUNTS.ACCOUNT_CURRENCY_ID,
									ACCOUNTS.ACCOUNT_ID,
									ACCOUNTS.ACCOUNT_TYPE,
									ACCOUNTS.ACCOUNT_NAME,
									ACCOUNTS.ACCOUNT_NO,
									ACCOUNTS.ACCOUNT_CREDIT_LIMIT,
									ACCOUNTS.ACCOUNT_BLOCKED_VALUE,
									BANK_BRANCH.BANK_BRANCH_ID,
									BANK_BRANCH.BANK_ID,
									BANK_BRANCH.BANK_BRANCH_NAME,
									BANK_BRANCH.BANK_NAME,
									ACCOUNTS.ACCOUNT_STATUS,
									ACCOUNTS.ACCOUNT_OWNER_CUSTOMER_NO,
									SETUP_BANK_TYPE_GROUPS.BANK_TYPE
								FROM
									ACCOUNTS LEFT JOIN BANK_BRANCH ON ACCOUNTS.ACCOUNT_BRANCH_ID=BANK_BRANCH.BANK_BRANCH_ID	
									LEFT JOIN #dsn_alias#.SETUP_BANK_TYPES ON SETUP_BANK_TYPES.BANK_ID = BANK_BRANCH.BANK_ID
									LEFT JOIN #dsn_alias#.SETUP_BANK_TYPE_GROUPS ON SETUP_BANK_TYPE_GROUPS.BANK_TYPE_ID = SETUP_BANK_TYPES.BANK_TYPE_GROUP_ID
								WHERE
									SETUP_BANK_TYPE_GROUPS.BANK_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_bank_type.bank_type_id#">
							</cfquery>
							<cfloop query="get_bank_with_type_list">
								<cfset acc_id_list=listappend(acc_id_list,ACCOUNT_ID)>
							</cfloop>
							<cfif len(acc_id_list)>
								<cfset acc_id_list=listsort(acc_id_list,"numeric","ASC",",")>
								<cfquery name="GET_BAKIYE" datasource="#dsn2#">
									SELECT SUM(BAKIYE_SYSTEM) AS Bakiye FROM ACCOUNT_REMAINDER_LAST WHERE ACCOUNT_ID IN (#acc_id_list#)
								</cfquery>
							<cfelse>
								<cfset GET_BAKIYE.Bakiye = 0>
							</cfif>
							
							<tr>
								<td align="center" id="bank_type_row#currentrow#" class="color-row" onclick="gizle_goster(bank_type_detail#currentrow#);connectAjax('#currentrow#','#BANK_TYPE_ID#');gizle_goster(bank_goster#currentrow#);gizle_goster(bank_gizle#currentrow#);">
									<img id="bank_goster#currentrow#" src="/images/listele.gif" title="<cf_get_lang dictionary_id ='58596.Göster'>">
									<img id="bank_gizle#currentrow#" src="/images/listele_down.gif" title="<cf_get_lang dictionary_id ='58628.Gizle'>" style="display:none">
								</td>
								<td>#BANK_TYPE#</td>
								<td class="text-right" class="moneybox"><cfif not len(GET_BAKIYE.Bakiye)><cfset GET_BAKIYE.Bakiye = 0></cfif><cfset ara_top = ara_top+GET_BAKIYE.Bakiye> #TLFormat(GET_BAKIYE.Bakiye)#</td>
								<td class="text-right" >#session.ep.money#</td>
								<td class="text-right"><cfset mevcut_oran_top += (GET_BAKIYE.Bakiye * 100) / GET_BAKIYE_TOP.Bakiye> #TLFormat((GET_BAKIYE.Bakiye * 100) / abs(GET_BAKIYE_TOP.Bakiye))#</td>
								<td class="text-right"><cfset planlanan_oran_top += QUATA_RATE> #TLFormat(QUATA_RATE)#</td>
							</tr>
							<!-- sil -->
							<tr id="bank_type_detail#currentrow#" class="color-list" style="display:none">
								<td colspan="25">
									<div align="left" id="DISPLAY_BANK_TYPE_INFO#currentrow#"></div>
								</td>
							</tr>
							<!-- sil -->
						</cfoutput>
					<cfelseif attributes.is_bank_type eq 3>
						<cfoutput query="GET_ACCOUNT_LIST">
							<tr>
								<td>#currentrow#</td>
								<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=finance.list_bank_types&event=upd&id=#bank_id#','wwide1');" class="tableyazi">#bank_name#</a></td>
								<td class="text-right"><cfif SYSTEM_BAKIYE gt 0><span style="color:black"><cfelse><span style="color:red"></cfif>#TLFormat(ABS(SYSTEM_BAKIYE))#</span></span><cfset system_bakiye_top = SYSTEM_BAKIYE + system_bakiye_top></td>
								<td><cfif SYSTEM_BAKIYE gt 0><span style="color:black"><cf_get_lang dictionary_id='58180.Borçlu'></span><cfelse><span style="color:red"><cf_get_lang dictionary_id='50129.Alacaklı'></span></cfif></td>
								<td class="text-right">#session.ep.money#</td>
							</tr>
						</cfoutput>
					</cfif>
				</tbody>
				<cfelse>
					<tbody>
						<tr>
							<td colspan="<cfoutput>#col_#</cfoutput>"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
						</tr>
					</tbody>    
				</cfif>
			</cf_grid_list>
			<div class="ui-info-bottom">
				<div class="col col-12 col-xs-12">
					<cfif attributes.is_bank_type eq 1>
						<div class="col col-3 col-md-6 col-xs-12">
							<label class="bold"><cf_get_lang dictionary_id='57492.Toplam'> :</label>
							<label class="moneybox" colspan="<cfoutput>#col_#</cfoutput>">							
								<cfset count = 0>
								<cfoutput query="get_money_rate">
									<cfset toplam_ara = 0>
									<cfset toplam_ara2 = 0>
										<cfloop list="#money_list#" index="i">
											<cfset tutar_ = listfirst(i,'*')>
											<cfset money_ = listlast(i,'*')>
												<cfif money_ eq money>
													<cfset toplam_ara = toplam_ara + tutar_>
												</cfif>
										</cfloop>
										<cfloop list="#money_list2#" index="i">
											<cfset tutar2_ = listfirst(i,'*')>
											<cfset money2_ = listlast(i,'*')>
												<cfif money2_ eq money>
													<cfset toplam_ara2 = toplam_ara2 + tutar2_>
												</cfif>
										</cfloop>
									<cfset count = count+2>
									<cfif isDefined("attributes.date1") and len(attributes.date1)>
										<cfif toplam_ara2 neq 0>
											#TLFormat(ABS(toplam_ara2))# #money# <cfif toplam_ara2 gt 0><cf_get_lang dictionary_id='58180.Borçlu'><cfelse><cf_get_lang dictionary_id='50129.Alacaklı'></cfif><cfif count neq get_money_rate.recordcount>,</cfif>
										</cfif>
									<cfelse>
										<cfif toplam_ara neq 0>
											#TLFormat(ABS(toplam_ara))# #money# <cfif toplam_ara gt 0><cf_get_lang dictionary_id='58180.Borçlu'><cfelse><cf_get_lang dictionary_id='50129.Alacaklı'></cfif><cfif count neq get_money_rate.recordcount>,</cfif>
										</cfif>
									</cfif>
								</cfoutput>
							</label>
						</div>
						<div class="col col-3 col-md-6 col-xs-12">
							<cfif not len(attributes.date1)>
								<cfoutput>
									<label class="bold"><cf_get_lang dictionary_id="47871.Güncel"> #session.ep.money# <cf_get_lang dictionary_id='57492.Toplam'> :</label>
									<label class="moneybox" colspan="<cfoutput>#col_#</cfoutput>">									
										#TLFormat(ABS(day_currency_bakiye_total))# <cfif day_currency_bakiye_total gt 0><cf_get_lang dictionary_id='58180.Borçlu'><cfelse><cf_get_lang dictionary_id='50129.Alacaklı'></cfif>,									
									</label>
								</cfoutput>	
							</cfif>	
						</div>
						<div class="col col-4 col-md-6 col-xs-12">
							<label class="bold"><cf_get_lang dictionary_id='48704.Kullanılabilir Toplam'> :</label>
							<label class="moneybox" colspan="<cfoutput>#col_#</cfoutput>">								
								<cfset count = 0>
								<cfoutput query="get_money_rate">
									<cfset kullan_toplam = 0>
									<cfset kullan_toplam2 = 0>
									<cfloop list="#useful_money_list#" index="i">
										<cfset kullan_tutar_ = listfirst(i,'*')>
										<cfset kullan_money_ = listlast(i,'*')>
											<cfif kullan_money_ eq money>
												<cfset kullan_toplam = kullan_toplam + kullan_tutar_>
											</cfif>
									</cfloop> 
									<cfloop list="#useful_money_list2#" index="i">
										<cfset kullan_tutar2_ = listfirst(i,'*')>
										<cfset kullan_money2_ = listlast(i,'*')>
										<cfif kullan_money2_ eq money>
											<cfset kullan_toplam2 = kullan_toplam2 + kullan_tutar2_>
										</cfif>
									</cfloop>
									<cfset count = count+2>
									<cfif isDefined("attributes.date1") and len(attributes.date1)>
										<cfif kullan_toplam2 neq 0>
											#TLFormat(ABS(kullan_toplam2))# #money# <cfif kullan_toplam2 gt 0><cf_get_lang dictionary_id='58180.Borçlu'><cfelse><cf_get_lang dictionary_id='50129.Alacaklı'></cfif><cfif count neq get_money_rate.recordcount>,</cfif>
										</cfif>
									<cfelse>
										<cfif kullan_toplam neq 0>
											#TLFormat(ABS(kullan_toplam))# #money# <cfif kullan_toplam gt 0><cf_get_lang dictionary_id='58180.Borçlu'><cfelse><cf_get_lang dictionary_id='50129.Alacaklı'></cfif><cfif count neq get_money_rate.recordcount>,</cfif>
										</cfif>
									</cfif>
								</cfoutput>  
							</label>
						</div>
					<cfelseif attributes.is_bank_type eq 2>
						<tr>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td class="txtbold"><cfoutput>#TLFormat(mevcut_oran_top)#</cfoutput> %</td>
							<td class="txtbold">
								<span style="float:left;">
								<cfoutput>#TLFormat(planlanan_oran_top)#</cfoutput> %
								</span>
								<span style="float:right;">
									<cf_get_lang dictionary_id='57492.Toplam'> :
									<cfoutput>#TLFormat(ara_top)# #session.ep.money#</cfoutput>
								</span>
							</td>
						</tr>
					</cfif>
				</div>
			</div>
			<cfset adres="bank.list_bank_account">
			<cfif isdefined ("attributes.form_submitted") and len(attributes.form_submitted)>
				<cfset adres = "#adres#&form_submitted=#attributes.form_submitted#">
			</cfif>
			<cfif isdefined("attributes.account_status")>
				<cfset adres = "#adres#&account_status=#attributes.account_status#">
			</cfif>
			<cfif isdate(attributes.date1)>
				<cfset adres = "#adres#&date1=#dateformat(attributes.date1,dateformat_style)#">
			</cfif>
			<cfif isDefined("attributes.branch_id") and len(attributes.branch_id)>
				<cfset adres = "#adres#&branch_id=#attributes.branch_id#">
			</cfif>
			<cfif isDefined("attributes.bank_id") and len(attributes.bank_id)>
				<cfset adres = "#adres#&bank_id=#attributes.bank_id#">
			</cfif>
			<cfif isDefined("attributes.account_currency_id") and len(attributes.account_currency_id)>
				<cfset adres = "#adres#&account_currency_id=#attributes.account_currency_id#">
			</cfif>
			<cfif isDefined("attributes.acc_type") and len(attributes.acc_type)>
				<cfset adres = "#adres#&acc_type=#attributes.acc_type#">
			</cfif>
			<cfif isDefined("attributes.is_bakiye") and attributes.is_bakiye eq 1>
				<cfset adres = "#adres#&is_bakiye=#attributes.is_bakiye#">
			</cfif>
			<cfif isDefined("attributes.is_bank_type")>
				<cfset adres = "#adres#&is_bank_type=#attributes.is_bank_type#">
			</cfif>
			<cf_paging 
				page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="#adres#">	
		</cf_box>
	</div>		
	<script type="text/javascript">
		document.getElementById('keyword').focus();
		function connectAjax(crtrow,bank_type_id)
		{
			var bb = '<cfoutput>#request.self#</cfoutput>?fuseaction=bank.ajax_group_bank_type_list&bank_type_id='+bank_type_id;
			AjaxPageLoad(bb,'DISPLAY_BANK_TYPE_INFO'+crtrow,1);
		}
	</script>	
	<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
	