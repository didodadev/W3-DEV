<!---
    File: bank_account_diff.cfm
    Folder: AddOns/Gramoni/WoDiBa/display
    Author: Gramoni - Çağla  <cagla.kara@gramoni.com>
    Date: 2019-12-09 14:52:04 
    Controller:WodibaBankAccountsController.cfm
    Description:
        Wodiba banka hesapları ile ilgili işlemler için kullanılan ekrandır.
    History:
        
    To Do:
--->

<cfparam name="attributes.page" default=1 />
<cfparam name="attributes.startrow" default=1 />
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#' />
<cfparam name="attributes.filtertab" default='Bank' />
<cfset adres="#listgetat(attributes.fuseaction,1,'.')#.wodiba_bank_accounts&event=diff"/>
<cfif isDefined('attributes.account_id')>
	<cfset adres = '#adres#&account_id=#attributes.account_id#'>
</cfif>
    <cfscript>
        include '../cfc/Functions.cfc';
        bank_account=GetNoneWodibaBankActions(
            AccountId=attributes.account_id
        );
        bank_account_info=GetAccountInfo(
            AccountId=attributes.account_id
        );
        wdb_bank_action  = GetBankActions(
            BankaKodu=bank_account_info.BANK_CODE,
            SubeKodu=bank_account_info.BRANCH_CODE,
            HesapNo=bank_account_info.ACCOUNT_NO,
            ActionIdNull = true
        );
        attributes.startrow=((attributes.page-1)*attributes.maxrows)+1;
        attributes.endrow = attributes.startrow + attributes.maxrows - 1;
    </cfscript>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#bank_account_info.ACCOUNT_NAME# Wodiba Karşılaştırması" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cf_box_search>
			<div class="form-group" style="width:200px">
				<select name="filtertab" id="filtertab" onchange="MyFunction(this.value);">
					<option value="Bank" <cfif attributes.filtertab eq "Bank">selected</cfif>>Wodiba'da Olmayan İşlemler</option>
					<option value="WodibaBank" <cfif attributes.filtertab eq "WodibaBank">selected</cfif>>Wodiba'da Olan İşlemler</option>
				</select>
			</div>
		</cf_box_search>
		<cf_flat_list>
			<cfif attributes.filtertab eq 'Bank'>
				<cfscript>
					attributes.totalrecords  = bank_account.RecordCount;
					if(attributes.totalrecords lt attributes.endrow){
						attributes.endrow = attributes.totalrecords;
					}
				</cfscript>
				<thead >
					<tr>
						<th><cf_get_lang_main no='1165.Sıra'></th>
						<th style="padding:8px"><cf_get_lang_main no='1166.Belge Türü'></th>
						<th style="padding:8px"><cf_get_lang_main no='650.Dekont'></th>  
						<th style="padding:8px"><cf_get_lang_main no='330.Tarih'></th>
						<th ><cf_get_lang_main no='261.Tutar'></th>
					</tr>
				</thead>
				<tbody >
					<cfset degisken=0/>
					<cfoutput>
						<cfloop query="bank_account" startrow="#attributes.startrow#" endrow="#attributes.endrow#">
							<tr>
								<td>#currentrow#</td>
								<td style="padding:8px">#ACTION_TYPE#</td> 
								<td style="padding:8px">#DEKONTNO#</td>
								<td style="padding:8px" style="text-align:center">#dateFormat(TARIH,"dd.mm.YYYY")# #dateFormat(TARIH,"H:mm")#</td>
								<td style="text-align:right">#TLFormat(ACTION_VALUE)# #ACTION_CURRENCY_ID#</td>
							</tr>
						</cfloop>
						<cfloop query="bank_account" endrow="#attributes.endrow#">
								<cfset degisken=degisken+ACTION_VALUE/>
						</cfloop>
					</cfoutput>
				</tbody>
				<tfoot>
					<tr>
						<td class="txtbold" style="text-align:right;" colspan="5">
							<cf_get_lang_main no='80.Toplam'> : <cfoutput>#TLFormat(degisken)# #bank_account.ACTION_CURRENCY_ID#</cfoutput>
						</td>
					</tr>
				</tfoot>
			</cfif>

			<cfif attributes.filtertab eq 'WodibaBank'>
				<cfscript>
					attributes.totalrecords  = wdb_bank_action.RecordCount;
					if(attributes.totalrecords lt attributes.endrow){
						attributes.endrow = attributes.totalrecords;
					}
				</cfscript>
				<thead>
					<tr>
						<th><cf_get_lang_main no='1165.Sıra'></th>
						<th style="padding:8px"><cf_get_lang dictionary_id='48886.İşlem Kodu'></th>
						<th style="padding:8px"><cf_get_lang_main no='1166.Belge Türü'></th>
						<th style="padding:8px"><cf_get_lang_main no='650.Dekont'></th>  
						<th style="padding:8px"><cf_get_lang_main no='330.Tarih'></th>
						<th><cf_get_lang_main no='261.Tutar'></th>
					</tr>
				</thead>
				<tbody>
					<cfset degisken=0/>
					<cfoutput>
						<cfloop query="wdb_bank_action" startrow="#attributes.startrow#" endrow="#attributes.endrow#">
							<tr>                         
								<cfif Not Len(ISLEMKODU)>
									<cfset ISLEMKODU = 0 />
								</cfif>
								<cfif MIKTAR GT 0>
									<cfset in_out = 'IN'/>
								<cfelse>
									<cfset in_out = 'OUT' />
								</cfif>
								<cfset get_process_type = GetProcessType(BankCode=BANKAKODU, TransactionCode=ISLEMKODU, InOut=in_out) />
								<td>#currentrow#</td>
								<td style="padding:8px">#ISLEMKODU#</td>
								<td style="padding:8px">#get_process_type.PROCESS_CAT#</td>
								<td style="padding:8px">#DEKONTNO#</td>
								<td style="padding:8px" style="text-align:center">#dateFormat(TARIH,"dd.mm.YYYY")# #dateFormat(TARIH,"H:mm")#</td>
								<td style="text-align:right">#TLFormat(MIKTAR)# #DOVIZTURU#</td>
							</tr>
						</cfloop>
						<cfloop query="wdb_bank_action" endrow="#attributes.endrow#">
							<cfset degisken=degisken+MIKTAR/>
						</cfloop>
					</cfoutput>
				</tbody>
				<tfoot>
					<tr>
						<td class="txtbold" style="text-align:right;" colspan="6">
							<cf_get_lang_main no='80.Toplam'> : <cfoutput>#TLFormat(degisken)# #wdb_bank_action.DOVIZTURU#</cfoutput>
						</td>
					</tr>
				</tfoot>
			</cfif>
		</cf_flat_list>
		<cfif isDefined('attributes.filtertab')>
			<cfset adres = '#adres#&filtertab=#attributes.filtertab#&draggable=#attributes.draggable#'>
		</cfif>
		<cf_paging
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#adres#"
			isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
</div>
<script>
    function MyFunction(valuename){
	   openBoxDraggable('<cfoutput>#request.self#?fuseaction=bank.wodiba_bank_accounts&event=diff&account_id=#attributes.account_id#</cfoutput>&filtertab=' + valuename, <cfoutput>#attributes.modal_id#</cfoutput>,'medium','');
    }
</script>