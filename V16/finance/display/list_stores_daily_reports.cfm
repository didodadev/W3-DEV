<cf_get_lang_set module_name="finance"><!--- sayfanin en altinda kapanisi var --->
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.branch_id" default=''>
<cfparam name="attributes.is_submitted" default="">
<cfif isdefined("attributes.search_date") and isdate(attributes.search_date)>
	<cf_date tarih=attributes.search_date>
<cfelse>
	<cfset attributes.search_date = date_add('d',-1,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#')) >
</cfif>
<cfif isdefined("attributes.search_date_1") and isdate(attributes.search_date_1)>
	<cf_date tarih=attributes.search_date_1>
<cfelse>
	<cfset attributes.search_date_1 = createodbcdatetime('#year(now())#-#month(now())#-#day(now())#')>
</cfif>
<cfif len(attributes.is_submitted)>
	<cfquery name="GET_STORE_DAILY_REPORT" datasource="#DSN2#">
		SELECT 
			STORE_REPORT.*,
			BRANCH.BRANCH_ID,
			BRANCH.BRANCH_NAME
		FROM 
			STORE_REPORT,
			#dsn_alias#.BRANCH AS BRANCH
		WHERE 
			STORE_REPORT.BRANCH_ID = BRANCH.BRANCH_ID
			<cfif len(attributes.keyword)>AND BRANCH.BRANCH_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"></cfif>
			<cfif isdate(attributes.search_date)>AND STORE_REPORT.STORE_REPORT_DATE >= #attributes.search_date#</cfif>
			<cfif isdate(attributes.search_date_1)>AND STORE_REPORT.STORE_REPORT_DATE < #date_add("d", 1, attributes.search_date_1)#</cfif>
			<cfif len(attributes.branch_id)>AND STORE_REPORT.BRANCH_ID = #attributes.branch_id#</cfif>
			<cfif session.ep.isBranchAuthorization>AND STORE_REPORT.BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#</cfif>
		ORDER BY 
			STORE_REPORT.STORE_REPORT_DATE
	</cfquery>
<cfelse>
	<cfset get_store_daily_report.recordcount=0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_store_daily_report.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="form" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_stores_daily_reports" method="post">
			<input type="hidden" name="is_submitted" id="is_submitted" value="1">
			<cf_box_search plus="0" more="0">
				<div class="form-group">
					<cfinput type="text" name="keyword" maxlength="50" value="#attributes.keyword#" placeholder="#getLang('','Filtre',57460)#">
				</div>
				<div class="form-group">
					<cfquery name="get_branches" datasource="#dsn#">
						SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH <cfif session.ep.isBranchAuthorization>WHERE BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#</cfif> ORDER BY BRANCH_NAME
					</cfquery>
					<select name="branch_id" id="branch_id">
						<option value=""><cf_get_lang dictionary_id='57453.Şube'></option>
						<cfoutput query="get_branches">
							<option value="#branch_id#" <cfif attributes.branch_id eq branch_id>selected</cfif>>#branch_name#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfinput type="text" name="search_date" value="#dateformat(attributes.search_date,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#getLang('','Lütfen Tarih Giriniz',58503)#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="search_date"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfinput type="text" name="search_date_1" value="#dateformat(attributes.search_date_1,dateformat_style)#" maxlength="10" validate="#validate_style#" message="">
						<span class="input-group-addon"><cf_wrk_date_image date_field="search_date_1"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group small">
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',43958)#" maxlength="3">
					</div>
				</div>
				<div class="form-group">
					<cf_wrk_search_button search_function="kontrol()" button_type="4">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
				<div class="form-group">
					<cfif session.ep.isBranchAuthorization>
						<a class="ui-btn ui-btn-gray" href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.list_stores_daily_reports&event=addSub"><i class="fa fa-plus" alt="" title="<cf_get_lang dictionary_id='44630.Ekle'>"></i></a>
					<cfelse>
						<a class="ui-btn ui-btn-gray" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.list_stores_daily_reports&event=add&field_id=get_store_ids.store_ids');"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='44630.Ekle'>" title="<cf_get_lang dictionary_id='44630.Ekle'>"></i></a>
					</cfif>
                </div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang('','Şube Finansal Günlük Durum Raporu',54611)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='57453.Şube'></th>
					<th><cf_get_lang dictionary_id='57742.Tarih'></th>
					<th style="text-align:right;"><cf_get_lang dictionary_id='54585.Nakit Satış'></th>
					<th style="text-align:right;"><cf_get_lang dictionary_id='54586.Kredili Satış'></th>
					<th style="text-align:right;"><cf_get_lang dictionary_id='37285.Toplam Satış'></th>
					<th style="text-align:right;"><cf_get_lang dictionary_id='58658.Ödemeler'></th>
					<th style="text-align:right;"><cf_get_lang dictionary_id='58089.Gelirler'></th>
					<th style="text-align:right;"><cf_get_lang dictionary_id='54607.Bankaya Yatan'></th>
					<th style="text-align:right;"><cf_get_lang dictionary_id='58438.Z Raporu'></th>
					<th style="text-align:right;"><cf_get_lang dictionary_id='58034.Devreden'></th>
					<!-- sil -->
					<th width="20" class="header_icn_none">
						<cfif session.ep.isBranchAuthorization>
							<a href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.list_stores_daily_reports&event=addSub"><i class="fa fa-plus" alt="" title="<cf_get_lang dictionary_id='44630.Ekle'>"></i></a>
						<cfelse>
							<a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.list_stores_daily_reports&event=add&field_id=get_store_ids.store_ids');"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='44630.Ekle'>" title="<cf_get_lang dictionary_id='44630.Ekle'>"></i></a>
						</cfif>
					</th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_store_daily_report.recordcount>
					<cfscript>
						toplam_1=0;
						toplam_2=0;
						toplam_3=0;
						toplam_4=0;
						toplam_5=0;
						toplam_6=0;
						toplam_7=0;
						toplam_8=0;
						report_id_list='';
						report_cheque_list=''; /*kasa raporlarından, CHEQUE_PRINTS tablosunda kaydı olanların listesini tutar*/
						store_pos_cash_list=''; /*kasa raporlarından, STORE_POS_CASH tablosunda kaydı olanların listesini tutar*/
						store_income_reports=''; /*kasa raporlarından, STORE_INCOME tablosunda kaydı olanların listesini tutar*/
						store_expense_reports=''; /*kasa raporlarından, STORE_EXPENSE tablosunda kaydı olanların listesini tutar*/
						daily_store_report=''; /*kasa raporlarından, STORE_REPORT tablosunda kaydı olanların listesini tutar*/
					</cfscript>
					<cfoutput query="get_store_daily_report" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfset report_id_list=listappend(report_id_list,get_store_daily_report.store_report_id)>
					</cfoutput>
					<cfset report_id_list=listsort(report_id_list,"numeric","desc",",")>
					
					<cfif listlen(report_id_list)>
						<cfquery name="GET_CHEQUE_ALL" datasource="#dsn#">
							SELECT
								SUM(CHEQUE_PRINTS.MONEY*(SETUP_MONEY.RATE2/SETUP_MONEY.RATE1)) AS CHEQUE_AMOUNT,
								CHEQUE_PRINTS_ROWS.DAILY_REPORT_ID
							FROM
								CHEQUE_PRINTS,
								CHEQUE_PRINTS_ROWS,
								SETUP_MONEY
							WHERE
								CHEQUE_PRINTS.CHEQUE_ID = CHEQUE_PRINTS_ROWS.CHEQUE_PRINT_ID AND
								SETUP_MONEY.MONEY = CHEQUE_PRINTS.MONEY_TYPE AND
								SETUP_MONEY.PERIOD_ID = #SESSION.EP.PERIOD_ID# AND
								CHEQUE_PRINTS_ROWS.DAILY_REPORT_ID IN (#report_id_list#) AND
								CHEQUE_PRINTS_ROWS.PERIOD_YEAR = #session.ep.period_year# AND
								CHEQUE_PRINTS_ROWS.COMPANY_ID = #session.ep.company_id#
							GROUP BY
								CHEQUE_PRINTS_ROWS.DAILY_REPORT_ID
							ORDER BY 
								CHEQUE_PRINTS_ROWS.DAILY_REPORT_ID DESC
						</cfquery>
						<cfset report_cheque_list=valuelist(GET_CHEQUE_ALL.DAILY_REPORT_ID,',')>
				
						<cfquery name="GET_GIRISLER_ALL" datasource="#dsn2#">
							SELECT
								SUM(TOTAL*(SETUP_MONEY.RATE2/SETUP_MONEY.RATE1)) AS STORE_INCOME_TOTAL,
								STORE_REPORT_ID
							FROM
								STORE_INCOME,
								SETUP_MONEY
							WHERE
								STORE_INCOME.MONEY_ID = SETUP_MONEY.MONEY
								AND STORE_REPORT_ID IN (#report_id_list#)
							GROUP BY STORE_REPORT_ID
							ORDER BY STORE_REPORT_ID DESC
						</cfquery>
						<cfset store_income_reports=valuelist(GET_GIRISLER_ALL.STORE_REPORT_ID,',')>
					
						<cfquery name="GET_STORE_CASH_POS_ALL" datasource="#dsn2#">
							SELECT
								SUM(SALES_CASH) AS TOTAL_SALES_CASH, 
								SUM(SALES_CREDIT) AS TOTAL_SALES_CREDIT, 
								SUM(GIVEN_TOTAL)AS TOTAL_GIVEN_TOTAL,
								STORE_REPORT_ID
							FROM 
								STORE_POS_CASH 
							WHERE 
								STORE_REPORT_ID IN (#report_id_list#) 
							GROUP BY 
								STORE_REPORT_ID
							ORDER BY 
								STORE_REPORT_ID DESC
						</cfquery>
						<cfset store_pos_cash_list=valuelist(GET_STORE_CASH_POS_ALL.STORE_REPORT_ID,',')>
					
						<cfquery name="GET_STORE_EXPENSE_ALL" datasource="#DSN2#">
							SELECT
								SUM(STORE_EXPENSE.TOTAL*(SETUP_MONEY.RATE2/SETUP_MONEY.RATE1)) AS STORE_EXPENSE_TOTAL,
								STORE_REPORT_ID
							FROM
								STORE_EXPENSE,
								SETUP_MONEY
							WHERE
								STORE_EXPENSE.MONEY_ID = SETUP_MONEY.MONEY
								AND STORE_REPORT_ID IN (#report_id_list#) 
							GROUP BY 
								STORE_REPORT_ID
							ORDER BY 
								STORE_REPORT_ID DESC
						</cfquery>
						<cfset store_expense_reports=valuelist(GET_STORE_EXPENSE_ALL.STORE_REPORT_ID)>
					</cfif>	
				<cfoutput query="get_store_daily_report" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfset search_tarih = date_add("d", -1, get_store_daily_report.store_report_date)>
					<cfquery name="GET_TOTAL_KALAN" datasource="#DSN2#">
					  SELECT 
						  DEVREDEN, 
						  STORE_REPORT_DATE 
					  FROM 
						  STORE_REPORT 
					  WHERE 
						  STORE_REPORT_DATE = #search_tarih# AND
						  BRANCH_ID = #GET_STORE_DAILY_REPORT.BRANCH_ID#
					</cfquery>
					<cfquery name="GET_DAILY_STORE_REPORT" datasource="#DSN2#">
						  SELECT 
							BANKAYA_YATAN 
						  FROM
							STORE_REPORT  
						</cfquery>
						<cfset daily_store_report=valuelist(GET_DAILY_STORE_REPORT.BANKAYA_YATAN)>
					<cfscript>
						cek_toplam = 0;
						toplam_kasa_girisi = 0;
						if(len(GET_GIRISLER_ALL.STORE_INCOME_TOTAL[listfind(store_income_reports,get_store_daily_report.store_report_id,',')]))
							toplam_kasa_girisi =  GET_GIRISLER_ALL.STORE_INCOME_TOTAL[listfind(store_income_reports,get_store_daily_report.store_report_id,',')];
						if ( len(GET_CHEQUE_ALL.CHEQUE_AMOUNT[listfind(report_cheque_list,get_store_daily_report.store_report_id,',')]))
							cek_toplam = GET_CHEQUE_ALL.CHEQUE_AMOUNT[listfind(report_cheque_list,get_store_daily_report.store_report_id,',')];
						
						if (len(GET_STORE_DAILY_REPORT.devreden_in))
							devreden_ = GET_STORE_DAILY_REPORT.devreden_in;
						else if (len(get_total_kalan.devreden))
							devreden_ = get_total_kalan.devreden;
						else
							devreden_ = 0;
						kasa_acigi_miktari = 0;
						toplam_nakit_kasa = 0;
						toplam_kredili_kasa = 0;
						toplam_odenen_miktar = 0;
						if(len(GET_STORE_CASH_POS_ALL.TOTAL_SALES_CASH[listfind(store_pos_cash_list,get_store_daily_report.store_report_id,',')])) toplam_nakit_kasa = GET_STORE_CASH_POS_ALL.TOTAL_SALES_CASH[listfind(store_pos_cash_list,get_store_daily_report.store_report_id,',')];
						if(len(GET_STORE_CASH_POS_ALL.TOTAL_SALES_CREDIT[listfind(store_pos_cash_list,get_store_daily_report.store_report_id,',')])) toplam_kredili_kasa =  GET_STORE_CASH_POS_ALL.TOTAL_SALES_CREDIT[listfind(store_pos_cash_list,get_store_daily_report.store_report_id,',')];
						if(len(GET_STORE_CASH_POS_ALL.TOTAL_GIVEN_TOTAL[listfind(store_pos_cash_list,get_store_daily_report.store_report_id,',')]))toplam_odenen_miktar = GET_STORE_CASH_POS_ALL.TOTAL_GIVEN_TOTAL[listfind(store_pos_cash_list,get_store_daily_report.store_report_id,',')];
						toplam_satis = (toplam_kredili_kasa + toplam_nakit_kasa);
						genel_toplam_odeme=0;
						if(len(GET_STORE_EXPENSE_ALL.STORE_EXPENSE_TOTAL[listfind(store_expense_reports,get_store_daily_report.store_report_id,',')]))
							genel_toplam_odeme =  GET_STORE_EXPENSE_ALL.STORE_EXPENSE_TOTAL[listfind(store_expense_reports,get_store_daily_report.store_report_id,',')];
						if(toplam_odenen_miktar gt 0 and toplam_satis gt 0)
							kasa_acigi_miktari = (toplam_odenen_miktar - toplam_satis);
						if (len(get_store_daily_report.bankaya_yatan))
							deger_bankaya_yatan = get_store_daily_report.bankaya_yatan;
						else
							deger_bankaya_yatan = 0;
							
						if(kasa_acigi_miktari lt 0)
							kalan = ( toplam_satis + devreden_ + toplam_kasa_girisi ) - ( deger_bankaya_yatan + genel_toplam_odeme + toplam_kredili_kasa + cek_toplam);
						else if (kasa_acigi_miktari gte 0)
							kalan = ( toplam_satis + devreden_ + toplam_kasa_girisi ) - ( deger_bankaya_yatan + genel_toplam_odeme + toplam_kredili_kasa + cek_toplam);
						toplam_1 = toplam_1 + toplam_nakit_kasa;
						toplam_2 = toplam_2 + toplam_kredili_kasa;
						toplam_3 = toplam_3 + toplam_satis;
						toplam_4 = toplam_4 + genel_toplam_odeme;
						toplam_5 = toplam_5 + toplam_odenen_miktar;	
						toplam_8 = toplam_8 + deger_bankaya_yatan;
						toplam_6 = toplam_6 + kalan;
						toplam_7 = toplam_7 + toplam_kasa_girisi;
					</cfscript>	
					<tr>
					  <td>#currentrow#</td>
					  <td>#branch_name#</td>
					  <td>#dateformat(store_report_date,dateformat_style)#</td>
					  <td style="text-align:right;">#tlformat(toplam_nakit_kasa)# #session.ep.money#</td>
					  <td style="text-align:right;">#tlformat(toplam_kredili_kasa)# #session.ep.money#</td>
					  <td style="text-align:right;">#tlformat(toplam_satis)# #session.ep.money#</td>
					  <td style="text-align:right;">#tlformat(genel_toplam_odeme)# #session.ep.money#</td>
					  <td style="text-align:right;">#tlformat(toplam_kasa_girisi)# #session.ep.money#</td>
					  <td style="text-align:right;">#tlformat(deger_bankaya_yatan)# #session.ep.money#</td>
					  <td style="text-align:right;">#tlformat(toplam_odenen_miktar)# #session.ep.money#</td>
					  <td style="text-align:right;">#tlformat(kalan)# #session.ep.money#</td>
					<!-- sil -->
					  <td><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_stores_daily_reports&event=upd&id=#store_report_id#"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></a></td>
					<!-- sil -->
					</tr>
				 </cfoutput>
				</tbody>
				<tfooter>
					<cfoutput>
						<tr>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td class="txtboldblue"><cf_get_lang dictionary_id='57492.Toplam'></td>
							<td class="txtboldblue" style="text-align:right;">#tlformat(toplam_1)# #session.ep.money#</td>
							<td class="txtboldblue" style="text-align:right;">#tlformat(toplam_2)# #session.ep.money#</td>
							<td class="txtboldblue" style="text-align:right;">#tlformat(toplam_3)# #session.ep.money#</td>
							<td class="txtboldblue" style="text-align:right;">#tlformat(toplam_4)# #session.ep.money#</td>
							<td class="txtboldblue" style="text-align:right;">#tlformat(toplam_7)# #session.ep.money#</td> 
							<td class="txtboldblue" style="text-align:right;">#tlformat(toplam_8)# #session.ep.money#</td>
							<td class="txtboldblue" style="text-align:right;">#tlformat(toplam_5)# #session.ep.money#</td>
							<td class="txtboldblue" style="text-align:right;">#tlformat(toplam_6)# #session.ep.money#</td>
							<!-- sil --><td class="txtboldblue" style="text-align:right;">&nbsp;</td><!-- sil -->
						</tr>
					</cfoutput>
				</tfooter>
				<cfelse>
				<tbody>
					<tr>
						<td colspan="12"><cfif attributes.is_submitted eq 1 and get_store_daily_report.recordcount eq 0><cf_get_lang dictionary_id='57484.Kayıt Yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
					</tr>
				</tbody>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfset adres="#listgetat(attributes.fuseaction,1,'.')#.list_stores_daily_reports">
		<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
			<cfset adres = '#adres#&keyword=#attributes.keyword#'>
		</cfif>
		<cfif isDefined('attributes.search_date') and len(attributes.search_date)>
			<cfset adres = '#adres#&search_date=#dateformat(attributes.search_date,dateformat_style)#'>
		</cfif>
		<cfif isDefined('attributes.search_date_1') and len(attributes.search_date_1)>
			<cfset adres = '#adres#&search_date_1=#dateformat(attributes.search_date_1,dateformat_style)#'>
		</cfif>
		<cfif isDefined('attributes.is_submitted') and len(attributes.is_submitted)>
			<cfset adres = '#adres#&is_submitted=#attributes.is_submitted#'>
		</cfif>
		<cfif isDefined('attributes.branch_id') and len(attributes.branch_id)>
			<cfset adres = '#adres#&branch_id=#attributes.branch_id#'>
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
	function kontrol()
		{
			if( !date_check(document.getElementById('search_date'),document.getElementById('search_date_1'), "<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
				return false;
			else
				return true;
		}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
