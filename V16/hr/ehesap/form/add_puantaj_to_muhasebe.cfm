<cf_xml_page_edit>
<cfparam name="attributes.is_virtual_puantaj" default="0">
<cfif attributes.is_virtual_puantaj eq 0>
	<cfset main_puantaj_table = "EMPLOYEES_PUANTAJ">
	<cfset row_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS">
	<cfset ext_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS_EXT">
	<cfset add_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS_ADD">
	<cfset maas_puantaj_table = "EMPLOYEES_SALARY">
<cfelse>
	<cfset main_puantaj_table = "EMPLOYEES_PUANTAJ_VIRTUAL">
	<cfset row_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS_VIRTUAL">
	<cfset ext_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS_EXT_VIRTUAL">
	<cfset add_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS_ADD_VIRTUAL">
	<cfset maas_puantaj_table = "EMPLOYEES_SALARY_PLAN">
</cfif>
<cfinclude template="../query/get_puantaj.cfm">
<cfset attributes.sal_mon = get_puantaj.sal_mon>
<cfset attributes.sal_year = get_puantaj.sal_year>
<cfquery name="get_puantaj_branch" datasource="#dsn#" maxrows="1">
	SELECT BRANCH_ID,BRANCH_NAME,COMPANY_ID FROM BRANCH WHERE BRANCH_ID = '#get_puantaj.SSK_BRANCH_ID#'
</cfquery>
<cfquery name="get_period_id" datasource="#dsn#" maxrows="1">
	SELECT PERIOD_ID,PERIOD_YEAR FROM SETUP_PERIOD WHERE (FINISH_DATE IS NULL OR (FINISH_DATE IS NOT NULL AND FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdate(get_puantaj.sal_year,get_puantaj.sal_mon,1)#">)) AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_branch.company_id#">
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="53378.Puantaj Muhasebe Aktarımı"></cfsavecontent>
<cf_box title="#message# : #get_puantaj_branch.BRANCH_NAME# (#listgetat(ay_list(),attributes.sal_mon)# - #attributes.sal_year# <cf_get_lang dictionary_id ='53379.Dönemi'> )">
	<table>
		<tr>
			<td valign="top">
				<cfif get_period_id.recordcount>
					<cfset new_period_id = get_period_id.period_id>
					<cfset new_dsn2 = '#dsn#_#get_period_id.period_year#_#get_puantaj_branch.COMPANY_ID#'>
					<cfset new_dsn3_alias = '#dsn#_#get_puantaj_branch.company_id#'>
					<cfinclude template="../query/get_puantaj_rows.cfm">
					<cfquery name="GET_IS_INTEGRATED" datasource="#dsn#">
						SELECT IS_INTEGRATED FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#new_period_id#">
					</cfquery>
					<cfif get_puantaj_rows.recordcount>
						<cfset in_out_list = listdeleteduplicates(valuelist(get_puantaj_rows.in_out_id))>
					<cfelse>
						<script type="text/javascript">
							alert("<cf_get_lang dictionary_id ='53377.Puantaja Bağlı Satır Bulunamadı'>!");
							window.close();
						</script>
						<cfabort>
					</cfif>
					<cfset kontrol_process_type = 0>
					<cfif not len(account_process_cat) or not len(budget_process_cat)>
						<font color="FF0000"><cf_get_lang dictionary_id='53341.Muhasebe işlemi yapabilmek için XML tanımlama sayfasında İşlem Kategorilerini tanımlamalısınız'> ! </font>
						<cfset kontrol_process_type = 1>
					</cfif>
					<cfif kontrol_process_type eq 0>
					<cfif GET_PUANTAJ.IS_ACCOUNT EQ 1>
						<font color="FF0000">*** <cf_get_lang dictionary_id ='53380.Puantaj Daha Önce Muhasebeleştirildi'>!<br/><br/></font>
						<cfquery name="get_account_cards" datasource="#new_dsn2#">
							SELECT 
								AC.*,
								E.EMPLOYEE_NAME,
								E.EMPLOYEE_SURNAME 
							FROM 
								ACCOUNT_CARD AC,
								#dsn_alias#.EMPLOYEES E 
							WHERE 
								AC.RECORD_EMP = E.EMPLOYEE_ID AND
								AC.ACTION_TYPE = 130 AND 
								AC.CARD_TYPE = 13 AND 
								AC.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj.puantaj_id#"> AND
								<cfif isdefined("attributes.is_virtual_puantaj") and attributes.is_virtual_puantaj eq 1>
									ACTION_TABLE = 'EMPLOYEES_PUANTAJ_VIRTUAL'
								<cfelse>
									ACTION_TABLE = 'EMPLOYEES_PUANTAJ'
								</cfif>
							UNION ALL
							SELECT 
								AC.*,
								E.EMPLOYEE_NAME,
								E.EMPLOYEE_SURNAME 
							FROM 
								ACCOUNT_CARD AC,
								#dsn_alias#.EMPLOYEES E 
							WHERE 
								AC.RECORD_EMP = E.EMPLOYEE_ID AND
								AC.ACTION_TYPE = 161 AND 
								AC.CARD_TYPE = 13 AND 
								AC.ACTION_ID = #GET_PUANTAJ.PUANTAJ_ID# AND
								<cfif isdefined("attributes.is_virtual_puantaj") and attributes.is_virtual_puantaj eq 1>
									ACTION_TABLE = 'EMPLOYEES_PUANTAJ_VIRTUAL'
								<cfelse>
									ACTION_TABLE = 'EMPLOYEES_PUANTAJ'
								</cfif>
						</cfquery>	
						<cfquery name="get_cari_rows" datasource="#new_dsn2#">
							SELECT  DISTINCT
								CR.ACTION_DATE,
								CONVERT(VARCHAR(10), CR.RECORD_DATE, 103) AS RECORD_DATE,
								CR.ACTION_NAME,
								E.EMPLOYEE_NAME,
								E.EMPLOYEE_SURNAME 
							FROM 
								CARI_ROWS CR,
								#dsn_alias#.EMPLOYEES E 
							WHERE 
								CR.RECORD_EMP = E.EMPLOYEE_ID AND
								CR.ACTION_TYPE_ID =161 AND 
								CR.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj.puantaj_id#"> AND
								<cfif isdefined("attributes.is_virtual_puantaj") and attributes.is_virtual_puantaj eq 1>
									ACTION_TABLE = 'EMPLOYEES_PUANTAJ_VIRTUAL'
								<cfelse>
									ACTION_TABLE = 'EMPLOYEES_PUANTAJ'
								</cfif>
						</cfquery>	
						<table>
							<tr height="25" class="formbold">
								<td colspan="7"><cf_get_lang dictionary_id='53319.Muhasebe ve Tahakkuk Fişleri'></td>
							</tr>
							<tr class="txtboldblue">
								<td width="50"><cf_get_lang dictionary_id='57946.Fiş No'></td>
								<td><cf_get_lang dictionary_id ='57629.Açıklama'></td>
								<td width="75"><cf_get_lang dictionary_id ='57879.İşlem Tarihi'></td>
								<td width="75"><cf_get_lang dictionary_id ='57627.Kayıt Tarihi'></td>
								<td width="125"><cf_get_lang dictionary_id ='57483.Kayıt'></td>
							</tr>
							<tr height="25" class="txtboldblue">
								<td colspan="7"><cf_get_lang dictionary_id='53381.Muhasebe Fişleri'></td>
							</tr>
							<cfif get_account_cards.recordcount>
								<cfoutput query="get_account_cards">
									<tr height="20">
										<td>#card_type_no#</td>
										<td nowrap>
											<cfif get_module_user(22) and new_period_id eq session.ep.period_id>
												<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=account.popup_list_card_rows&card_id=#card_id#','list')" class="tableyazi">#card_detail#</a>
											<cfelse>
												#card_detail#
											</cfif>
										</td>
										<td>#dateformat(action_date,dateformat_style)#</td>
										<td>#dateformat(record_date,dateformat_style)#</td>
										<td>#employee_name# #employee_surname#</td>
										<cfif get_module_user(22) and new_period_id eq session.ep.period_id>
											<td align="center"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=account.form_add_bill_cash2cash&event=upd&var_=cash2cash_card&card_id=#get_account_cards.card_id#','longpage','muhasebe_list');"><img src="/images/update_list.gif" border="0" style="vertical-align:middle" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></a></td>
										</cfif>
									</tr>
								</cfoutput>
							<cfelse>
								<tr>
									<td colspan="6"><cf_get_lang dictionary_id ='57484.Kayıt Bulunamadı'>!</td>
								</tr>
							</cfif>
							<tr height="25" class="txtboldblue">
								<td colspan="7"><cf_get_lang dictionary_id='53337.Cari Tahakkuk Fişleri'></td>
							</tr>
							<cfif get_cari_rows.recordcount>
								<cfoutput query="get_cari_rows">
									<tr height="20">
										<td></td>
										<cfif new_period_id eq session.ep.period_id>
											<td nowrap>
												<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_puantaj_act&type=2&puantaj_id=#get_puantaj.puantaj_id#','medium')" class="tableyazi">#action_name#</a>
											</td>
										</cfif>
										<td>#dateformat(action_date,dateformat_style)#</td>
										<td>#dateformat(record_date,dateformat_style)#</td>
										<td>#employee_name# #employee_surname#</td>
										<cfif new_period_id eq session.ep.period_id>
											<td align="center"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_puantaj_act&type=2&puantaj_id=#get_puantaj.puantaj_id#','medium')" class="tableyazi"><img src="/images/update_list.gif" border="0" style="vertical-align:middle" alt="Detay" title="Detay"></a></td>
										</cfif>
									</tr>
								</cfoutput>
							<cfelse>
								<tr>
									<td colspan="6"><cf_get_lang dictionary_id ='57484.Kayıt Bulunamadı'>!</td>
								</tr>
							</cfif>
							<tr>
                            	<cfform name="del_account_card" action="">
                                    <input type="hidden" name="puantaj_account_date_del" id="puantaj_account_date_del" value="<cfoutput>#dateFormat(CREATEDATE(get_puantaj.sal_year,get_puantaj.sal_mon,puantaj_gun_),dateformat_style)#</cfoutput>">
									<cfif get_account_cards.IS_COMPOUND neq 1 and not listfindnocase(denied_pages,'ehesap.del_card') and get_account_cards.recordcount><!--- listgetat(session.ep.user_level, 22) and structkeyexists(fusebox.circuits,'account') and--->
                                        <td colspan="6" style="text-align:right;">
                                        	<input type="button" value="<cf_get_lang dictionary_id='53344.Fişleri Sil'>" onclick="if(!chk_period(document.getElementById('puantaj_account_date_del'),'İşlem')) return false; go_to_sil('<cfoutput>#valuelist(get_account_cards.CARD_ID)#</cfoutput>');"> 
                                        </td>
                                    </cfif>
                             	</cfform>
							</tr>
						</table>
					<cfelseif not (isdefined("attributes.is_submitted") and attributes.is_submitted eq 1)>
						<cfform name="add_account_card" action="">
							<input type="hidden" name="is_submitted" id="is_submitted" value="1">
                            <input type="hidden" name="puantaj_account_date" id="puantaj_account_date" value="<cfoutput>#dateFormat(CREATEDATE(get_puantaj.sal_year,get_puantaj.sal_mon,puantaj_gun_),dateformat_style)#</cfoutput>">
							<table>
								<tr>
									<td>
										<b><cfoutput> #get_puantaj_branch.BRANCH_NAME# (#listgetat(ay_list(),attributes.sal_mon)# - #attributes.sal_year# <cf_get_lang dictionary_id ='53379.Dönemi'> )</cfoutput></b>
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='53486.Muhasebe Fişi Oluştur'></cfsavecontent>
										<input type="button" name="add_acc_card" id="add_acc_card" value="<cfoutput>#message#</cfoutput>" onclick="if(!chk_period(document.getElementById('puantaj_account_date'),'İşlem')) return false; add_account_card.submit(); add_acc_card.disabled=true;">
									</td>
								</tr>
							</table>
						</cfform>
					</cfif>
					<cfif isdefined("attributes.is_submitted") and attributes.is_submitted eq 1 and GET_PUANTAJ.IS_ACCOUNT neq 1>
						<cfif attributes.sal_year gte 2011>
							<cfinclude template="add_puantaj_to_muhasebe_2011.cfm">
						<cfelseif attributes.sal_year gte 2009>
							<cfinclude template="add_puantaj_to_muhasebe_2009.cfm">
						<cfelse>
							<cfinclude template="add_puantaj_to_muhasebe_2008.cfm">
						</cfif>
					</cfif>
					</cfif>
					<script language="javascript">
						function go_to_sil(int_card)
						{
							if (confirm("<cf_get_lang dictionary_id='53358.Kayıtlı Muhasebe Fişlerini ve Cari Hareketleri Siliyorsunuz. Emin misiniz?'>"))
							{
								windowopen('<cfoutput>#request.self#?fuseaction=ehesap.del_card<cfif isdefined("attributes.is_virtual_puantaj") and attributes.is_virtual_puantaj eq 1>&is_virtual_puantaj=1</cfif>&is_puantaj=1&puantaj_id=#get_puantaj.puantaj_id#&new_dsn2=#new_dsn2#&card_id=</cfoutput>'+int_card,'small');
							}
							else
								return false;
						}
					</script>
				<cfelse>
					<font color="FF0000"><cf_get_lang dictionary_id="59571.Puantajın Ait Olduğu Şirket ve Yıl İçin Dönem Kaydı Bulunamadı"> !</font>
				</cfif>
			</td>
		</tr>
	</table>
</cf_box>
