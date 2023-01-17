<cfparam name="attributes.cash_status" default="1">
<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../query/get_cashes_list.cfm">
<cfelse>
	<cfset get_cashes.recordcount=0>
</cfif>
<cfinclude template="../query/get_money.cfm">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.cash_currency_id" default="">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_cashes.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="list_cashes" action="#request.self#?fuseaction=cash.list_cashes" method="post">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search>
				<!--- Arama --->
				<div class="form-group">
					<cfinput type="text" name="keyword" placeholder="#getLang(48,'Filtre',57460)#" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group">
					<cfinclude template="../query/get_com_branch.cfm">
					<cfquery name="GET_COM_BRANCH" datasource="#dsn#">
						SELECT
							BRANCH_NAME,BRANCH_ID
						FROM
							BRANCH
						WHERE
							COMPANY_ID=#SESSION.EP.COMPANY_ID#
						ORDER BY
							BRANCH_NAME
					</cfquery>
					<select name="BRANCH_ID" id="BRANCH_ID" style="width:150px;">
						<option value=""><cf_get_lang dictionary_id='57453.Şube'></option>
						<cfoutput query="GET_COM_BRANCH_">
							<option value="#BRANCH_ID#" <cfif isDefined('attributes.BRANCH_ID') and attributes.BRANCH_ID eq GET_COM_BRANCH_.BRANCH_ID>selected</cfif>>#BRANCH_NAME#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<select name="cash_currency_id" id="cash_currency_id">
						<option value=""><cf_get_lang dictionary_id='57489.Para Birimi'></option>
						<cfoutput query="get_money">
							<option value="#money#" <cfif attributes.cash_currency_id eq money>selected</cfif>>#money#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<select name="cash_status" id="cash_status" style="width:50px;">
						<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
						<option value="1"<cfif isDefined("attributes.cash_status") and (attributes.cash_status eq 1)> selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
						<option value="0"<cfif isDefined("attributes.cash_status") and (attributes.cash_status eq 0)> selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" onKeyUp="isNumber (this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
				<!--- Arama --->
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(1245,'Kasalar',58657)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='49775.Kasa Adı'></th>
					<th><cf_get_lang dictionary_id='49783.Döviz Kodu'></th>
					<th><cf_get_lang dictionary_id='49778.Kasa Kodu'></th>
					<th><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></th>
					<th><cf_get_lang dictionary_id='57453.Şube'></th>
					<th><cf_get_lang dictionary_id='57589.Bakiye'></th>
					<th><cf_get_lang dictionary_id='57756.Durum'></th>
					<!-- sil -->
					<th width="20" class="header_icn_none"><cfif not listfindnocase(denied_pages,'cash.form_add_cash') and (session.ep.admin eq 1 or get_module_power_user(18))>
						<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=cash.list_cashes&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></cfif>
					</th>
					<!-- sil -->
				</tr>
			</thead>
			<cfif get_cashes.recordcount>
				<tbody>
					<cfset tutar_list = "">
					<cfset money_list = "">
					<cfoutput query="get_cashes" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfset doviz_yeri = listfind(money_list,get_cashes.CASH_CURRENCY_ID,',')>
						<cfif doviz_yeri>
							<cfset tutar_list = listsetat(tutar_list,doviz_yeri,BAKIYE+listgetat(tutar_list,doviz_yeri,','),',')>
						<cfelse>
							<cfset tutar_list = listappend(tutar_list,BAKIYE,',')>
							<cfset money_list = listappend(money_list,get_cashes.CASH_CURRENCY_ID,',')>
						</cfif>
						<tr>
							<td align="center">
								<cfif not listfindnocase(denied_pages,'cash.popup_upd_cash') and (session.ep.admin eq 1 or get_module_power_user(18))>
									<a class="tableyazi" href="#request.self#?fuseaction=cash.list_cashes&event=upd&ID=#get_cashes.CASH_ID#">#get_cashes.currentrow#</a></td>
									<cfelse>
									#get_cashes.currentrow#
								</cfif>
									<td>
								<cfif not listfindnocase(denied_pages,'cash.popup_upd_cash') and (session.ep.admin eq 1 or get_module_power_user(18))>
									<a class="tableyazi" href="#request.self#?fuseaction=cash.list_cashes&event=upd&ID=#get_cashes.CASH_ID#">#get_cashes.CASH_NAME#</a>
								<cfelse>
									#get_cashes.CASH_NAME#
								</cfif>
							</td>
							<td>#get_cashes.CASH_CURRENCY_ID#</td>
							<td>#get_cashes.CASH_CODE#</td>
							<td>#get_cashes.CASH_ACC_CODE#</td>
							<td>#get_cashes.BRANCH_NAME#</td>
							<td style="text-align:right;"><cfif BAKIYE GTE 0><span style="color:black"><cfelse><span style="color:red"></cfif>#TLFormat(abs(BAKIYE))# #get_cashes.CASH_CURRENCY_ID# </span></span><cfif BAKIYE GTE 0><span style="color:black">(B)</span><cfelse><span style="color:red">(A)</span></cfif></td>
							<td><cfif CASH_STATUS eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
							<!-- sil -->  
							<td><cfif not listfindnocase(denied_pages,'cash.popup_upd_cash') and (session.ep.admin eq 1 or get_module_power_user(18))>
							<a href="#request.self#?fuseaction=cash.list_cashes&event=upd&ID=#get_cashes.CASH_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></cfif></td>
							<!-- sil -->
						</tr>
					</cfoutput>
				</tbody>
				<tfoot>
					<tr>
						<td colspan="9" class="txtbold" style="text-align:right;">
							<cf_get_lang dictionary_id='57492.Toplam'> : 
							<cfloop from="1" to="#listlen(money_list)#" index="i">
								<cfoutput>#TLFormat(abs(listgetat(tutar_list,i,',')))# #listgetat(money_list,i,',')# <cfif listgetat(tutar_list,i,',') gt 0>(B)<cfelse>(A)</cfif><cfif listlen(money_list) neq i>,</cfif></cfoutput>
							</cfloop>
						</td>
					</tr>
				</tfoot>
			<cfelse>
				<tr>
					<td colspan="9"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
				</tr>
			</cfif>
		</cf_grid_list>
		<cfset adres="cash.list_cashes" >
		<cfif isDefined('attributes.form_submitted') and len(attributes.form_submitted)>
			<cfset adres = adres&"&form_submitted="&attributes.form_submitted>
		</cfif>
		<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
			<cfset adres = adres&"&keyword="&attributes.keyword>
		</cfif>
		<cfif isDefined('attributes.branch_id') and len(attributes.branch_id)>
			<cfset adres = adres&"&branch_id="&attributes.branch_id>
		</cfif>
		<cfif isDefined('attributes.cash_currency_id') and len(attributes.cash_currency_id)>
			<cfset adres = adres&"&cash_currency_id="&attributes.cash_currency_id>
		</cfif>
		<cfif isDefined('attributes.cash_status') and len(attributes.cash_status)>
			<cfset adres = adres&"&cash_status="&attributes.cash_status>
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
</script>
