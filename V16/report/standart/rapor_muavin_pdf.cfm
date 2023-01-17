<cfset drc_name_ = "#dateformat(now(),'yyyymmdd')#">
<cfif not directoryexists("#upload_folder#reserve_files#dir_seperator##drc_name_#")>
	<cfdirectory action="create" directory="#upload_folder#reserve_files#dir_seperator##drc_name_#">
</cfif>
<cfset satir_sayisi=0>
<cfdocument format="pdf" filename="#upload_folder#reserve_files#dir_seperator##drc_name_##dir_seperator##filename#.pdf" orientation="portrait" backgroundvisible="false" pagetype="custom" unit="cm" pageheight="28" pagewidth="21">
	<cfoutput>
	<style type="text/css">
		.tr{font-size:#attributes.fontsize#;font-family:#attributes.fontfamily#;}
		.th{font-size:#attributes.fontsize#;font-family:#attributes.fontfamily#; font-weight:bold;}
	</style>
	</cfoutput>
	<cfloop from="1" to="#totalrecords#" index="I">
		<cfset dev_borc = 0>
		<cfset dev_alacak = 0>
		<cfset attributes.CODE = trim(get_account_id.ACCOUNT_CODE[I])>
		<cfset main_code = trim(get_account_id.ACCOUNT_CODE[I])>
		<cfif i eq 1>
			<cfset main_code_pre = trim(get_account_id.ACCOUNT_CODE[I])>
		<cfelse>
			<cfset main_code_pre = trim(get_account_id.ACCOUNT_CODE[I-1])>
		</cfif>
		<!--- devreden icin --->
		<cfquery name="devreden_alacak" dbtype="query">
			SELECT
				SUM(AMOUNT) AS AMOUNT
			FROM
				get_account_card_rows_all
			WHERE
				ACCOUNT_ID = '#attributes.CODE#'
				AND BA = 1
				AND ACTION_DATE < #attributes.date1#
		</cfquery>
		<cfquery name="devreden_borc" dbtype="query">
			SELECT
				SUM(AMOUNT) AS AMOUNT
			FROM
				get_account_card_rows_all
			WHERE
				ACCOUNT_ID = '#attributes.CODE#'
				AND BA = 0
				AND ACTION_DATE  < #attributes.date1#
		</cfquery>
		<cfif not len(devreden_borc.AMOUNT)><cfset dev_borc = 0 ><cfelse><cfset dev_borc = devreden_borc.AMOUNT ></cfif>
		<cfif not len(devreden_alacak.AMOUNT)><cfset dev_alacak = 0 ><cfelse><cfset dev_alacak = devreden_alacak.AMOUNT ></cfif>
		<cfset muavin_borc=muavin_borc+dev_borc>
		<cfset muavin_alacak=muavin_alacak+dev_alacak>
		<!--- //devreden son --->
		<cfquery name="get_account_card_rows"  dbtype="query">
			SELECT
				*
			FROM
				get_account_card_rows_all
			WHERE
				ACCOUNT_ID = '#attributes.CODE#' AND
				ACTION_DATE BETWEEN  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
				<cfif len(attributes.project_id) and len(attributes.project_head)>
                	AND ACC_PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
                </cfif>
            ORDER BY ACTION_DATE, BILL_NO
		</cfquery>
		<table cellpadding="0" cellspacing="0" border="0" width="100%" align="center">
			<cfif i eq 1>
				<tr class="th" valign="top" height="40">
					<td colspan="9" align="center"><big><cf_get_lang dictionary_id='40645.Muavin Defteri'></big></td>
				</tr>
				<tr class="th" valign="top" height="40">
					<td colspan="9"><cfoutput>#session.ep.company# (#DateFormat(attributes.date1,dateformat_style)# - #DateFormat(attributes.date2,dateformat_style)#)</cfoutput></td>
				</tr>
			</cfif>
			<cfif (isdefined("attributes.is_acc_based_page") and main_code neq main_code_pre)>
				<cfset satir_sayisi=0>
				</table>
				<cfdocumentitem type="pagebreak"/>
				<table cellpadding="0" cellspacing="0" border="0" width="98%">
			</cfif>
			<tr class="th" valign="top" height="20">
				<cfset satir_sayisi=satir_sayisi+1>
				<td colspan="8"><cfoutput><strong>#attributes.CODE# / <cfif ListFindNoCase(display_hesap_codes,"'#attributes.CODE#'",',')>#listgetat(display_hesap_list,listfind(display_hesap_codes,"'#attributes.CODE#'",','),'§')#</cfif></strong></cfoutput></td>
			</tr>
			<cfif (satir_sayisi neq 1 and len(attributes.pdf_page_row) and attributes.pdf_page_row neq 0 and (satir_sayisi mod attributes.pdf_page_row) eq 1)><!--- satır sayısı belirtilmisse sayfalama yapılıyor --->
				</table>
				<cfdocumentitem type="pagebreak"/>
				<table cellpadding="0" cellspacing="0" border="0" width="98%">
				<cfif isdefined("attributes.is_show_cumulative_sum") and attributes.is_show_cumulative_sum eq 1>
					<tr class="th">
					<cfset satir_sayisi=satir_sayisi+1>
						<td width="435" colspan="6">&nbsp;</td>
						<td width="125" align="center"><cf_get_lang dictionary_id='60795.Devreden Borç'></td>
						<td width="125" align="center"><cf_get_lang dictionary_id='60796.Devreden Alacak'></td>
						<td width="155">&nbsp;</td>
					</tr>
					<tr class="th">
					<cfset satir_sayisi=satir_sayisi+1>
						<td width="435" colspan="6"><cf_get_lang dictionary_id='60797.Devreden Küm. Toplam'></td>
						<td width="125" align="right" style="text-align:right;"><cfoutput>#TLFormat(muavin_borc)#</cfoutput></td>
						<td width="125" align="right" style="text-align:right;"><cfoutput>#TLFormat(muavin_alacak)#</cfoutput></td>
						<td width="155">&nbsp;</td>
					</tr>
				</cfif>
			</cfif>
			<tr align="center" class="th" valign="top" height="20">
				<cfset satir_sayisi=satir_sayisi+1>
				<td width="60"><cf_get_lang dictionary_id='57742.Tarih'></td>
				<td width="35"><cf_get_lang dictionary_id='57487.No'></td>
				<td width="70"><cf_get_lang dictionary_id='39346.Fiş Türü'></td>
				<td width="70"><cf_get_lang dictionary_id='57946.Fiş No'></td>
                <td width="100"><cf_get_lang dictionary_id='57416.Proje'></td>
				<td width="150"><cf_get_lang dictionary_id='57629.Açıklama'></td>
				<td width="100"><cf_get_lang dictionary_id='57587.Borç'></td>
				<td width="100"><cf_get_lang dictionary_id='57588.Alacak'></td>
				<td width="155"><cf_get_lang dictionary_id='57589.Bakiye'></td>
			</tr>
			<cfif (len(attributes.pdf_page_row) and attributes.pdf_page_row neq 0 and (satir_sayisi mod attributes.pdf_page_row) eq 1)><!--- satır sayısı belirtilmisse sayfalama yapılıyor --->
				</table>
				<cfdocumentitem type="pagebreak"/>
				<table cellpadding="0" cellspacing="0" border="0" width="98%">
				<cfif isdefined("attributes.is_show_cumulative_sum") and attributes.is_show_cumulative_sum eq 1>
					<tr class="th">
					<cfset satir_sayisi=satir_sayisi+1>
						<td width="435" colspan="6">&nbsp;</td>
						<td width="125" align="center"><cf_get_lang dictionary_id='60795.Devreden Borç'></td>
						<td width="125" align="center"><cf_get_lang dictionary_id='60796.Devreden Alacak'></td>
						<td width="155">&nbsp;</td>
					</tr>
					<tr class="th">
					<cfset satir_sayisi=satir_sayisi+1>
						<td width="435" colspan="6">&nbsp;<cf_get_lang dictionary_id='60797.Devreden Küm. Toplam'></td>
						<td width="125" align="right" style="text-align:right;"><cfoutput>#TLFormat(muavin_borc)#</cfoutput></td>
						<td width="125" align="right" style="text-align:right;"><cfoutput>#TLFormat(muavin_alacak)#</cfoutput></td>
						<td width="155">&nbsp;</td>
					</tr>
				</cfif>
			</cfif>
			<tr class="th" valign="top" height="20">
				<cfset satir_sayisi=satir_sayisi+1>
				<td colspan="6"><cf_get_lang dictionary_id ='58034.Devreden'></td>
				<td align="right" style="text-align:right;"><cfoutput>#TLFormat(dev_borc)#</cfoutput><!--- <cfset muavin_borc=muavin_borc+dev_borc> ---></td>
				<td align="right" style="text-align:right;"><cfoutput>#TLFormat(dev_alacak)#</cfoutput><!--- <cfset muavin_alacak=muavin_alacak+dev_alacak> ---></td>
				<td align="right" style="text-align:right;"><cfset bakiye = dev_borc-dev_alacak><cfoutput>#TLFormat(abs(bakiye))#</cfoutput><cfif bakiye lt 0>(A)<cfelse>(B)</cfif></td>
			</tr>
			<cfif (len(attributes.pdf_page_row) and attributes.pdf_page_row neq 0 and (satir_sayisi mod attributes.pdf_page_row) eq 1)><!--- satır sayısı belirtilmisse sayfalama yapılıyor --->
				</table>
				<cfdocumentitem type="pagebreak"/>
				<table cellpadding="0" cellspacing="0" border="0" width="98%">
				<cfif isdefined("attributes.is_show_cumulative_sum") and attributes.is_show_cumulative_sum eq 1>
					<tr class="th">
					<cfset satir_sayisi=satir_sayisi+1>
						<td width="435" colspan="6">&nbsp;</td>
						<td width="125" align="center"><cf_get_lang dictionary_id='60795.Devreden Borç'></td>
						<td width="125" align="center"><cf_get_lang dictionary_id='60796.Devreden Alacak'></td>
						<td width="155">&nbsp;</td>
					</tr>
					<tr class="th">
					<cfset satir_sayisi=satir_sayisi+1>
						<td width="435" colspan="6">&nbsp;<cf_get_lang dictionary_id='60797.Devreden Küm. Toplam'></td>
						<td width="125" align="right" style="text-align:right;"><cfoutput>#TLFormat(muavin_borc)#</cfoutput></td>
						<td width="125" align="right" style="text-align:right;"><cfoutput>#TLFormat(muavin_alacak)#</cfoutput></td>
						<td width="155">&nbsp;</td>
					</tr>
				</cfif>
			</cfif>
			<cfif get_account_card_rows.RECORDCOUNT>
				<cfoutput query="get_account_card_rows">
					<cfif CARD_TYPE EQ 10><cfset TYPE='AÇILIŞ'><cfset CARD_TYPE_NO = 1>
					<cfelseif CARD_TYPE EQ 11><cfset TYPE='TAHSİL'>
					<cfelseif CARD_TYPE EQ 12><cfset TYPE='TEDİYE'>
					<cfelseif listfind('13,14',CARD_TYPE)><cfset TYPE='MAHSUP'>
					<cfelseif CARD_TYPE EQ 19><cfset TYPE='KAPANIS'></cfif>
					<tr class="tr" valign="top" height="20">
						<cfset satir_sayisi=satir_sayisi+1>
						<td align="center">#dateformat(ACTION_DATE,dateformat_style)#</td>
						<td align="center">#BILL_NO#</td>
						<td align="center">#TYPE#</td>
						<td align="center">#CARD_TYPE_NO#</td>
                        <td>#PROJECT_NAME#</td>
						<td>#left(DETAIL,25)#</td>
						<cfif BA eq 0><!--- borc --->
						<td align="right" style="text-align:right;">#TLFormat(amount)#<cfset muavin_borc=muavin_borc+amount></td>
						<td align="right" style="text-align:right;"></td>
						<cfset bakiye = bakiye + amount><cfset dev_borc = dev_borc + amount>
						<cfelse><!--- alacak --->
						<td align="right" style="text-align:right;"></td>
						<td align="right" style="text-align:right;">#TLFormat(amount)#<cfset muavin_alacak=muavin_alacak+amount></td>
						<cfset bakiye = bakiye - amount><cfset dev_alacak = dev_alacak + amount >
						</cfif>
						<td align="right" style="text-align:right;">#TLFormat(abs(bakiye))# <cfif bakiye gte 0>(B)<cfelse>(A)</cfif></td>
					</tr>
					<cfif (len(attributes.pdf_page_row) and attributes.pdf_page_row neq 0 and (satir_sayisi mod attributes.pdf_page_row) eq 1)><!--- satır sayısı belirtilmisse sayfalama yapılıyor --->
						</table>
						<cfdocumentitem type="pagebreak"/>
						<table cellpadding="0" cellspacing="0" border="0" width="98%">
							<cfif isdefined("attributes.is_show_cumulative_sum") and attributes.is_show_cumulative_sum eq 1>
								<tr class="th">
								<cfset satir_sayisi=satir_sayisi+1>
									<td width="435" colspan="6">&nbsp;</td>
									<td width="125" align="center"><cf_get_lang dictionary_id='60795.Devreden Borç'></td>
									<td width="125" align="center"><cf_get_lang dictionary_id='60796.Devreden Alacak'></td>
									<td width="155">&nbsp;</td>
								</tr>
								<tr class="th">
								<cfset satir_sayisi=satir_sayisi+1>
									<td width="435" colspan="6">&nbsp;<cf_get_lang dictionary_id='60797.Devreden Küm. Toplam'></td>
									<td width="125" align="right" style="text-align:right;">#TLFormat(muavin_borc)#</td>
									<td width="125" align="right" style="text-align:right;">#TLFormat(muavin_alacak)#</td>
									<td width="155">&nbsp;</td>
								</tr>
							</cfif>
					</cfif>
				</cfoutput>
				<tr class="th" valign="top" height="20">
					<cfset satir_sayisi=satir_sayisi+1>
					<td colspan="6" align="right" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'>:</td>
					<td align="right" nowrap="nowrap" style="text-align:right;"><cfoutput>#TLFormat(Evaluate(dev_borc))# #session.ep.money#</cfoutput></td>
					<td align="right" nowrap="nowrap" style="text-align:right;"><cfoutput>#TLFormat(Evaluate(dev_alacak))# #session.ep.money#</cfoutput></td>
					<td align="right" nowrap="nowrap" style="text-align:right;"><cfoutput>#TLFormat(abs(evaluate(bakiye)))# #session.ep.money#</cfoutput> <cfif bakiye gte 0>(B)<cfelse>(A)</cfif></td>
				</tr>
				<cfset toplam_borc = toplam_borc + dev_borc>
				<cfset toplam_alacak = toplam_alacak + dev_alacak>
				<cfset toplam_bakiye = toplam_bakiye + bakiye>
				<cfif (len(attributes.pdf_page_row) and attributes.pdf_page_row neq 0 and (satir_sayisi mod attributes.pdf_page_row) eq 1)><!--- satır sayısı belirtilmisse sayfalama yapılıyor --->
					</table>
					<cfdocumentitem type="pagebreak"/>
					<table cellpadding="0" cellspacing="0" border="0" width="98%">
						<cfif isdefined("attributes.is_show_cumulative_sum") and attributes.is_show_cumulative_sum eq 1>
							<tr class="th">
							<cfset satir_sayisi=satir_sayisi+1>
								<td width="435" colspan="5">&nbsp;</td>
								<td width="125" align="center"><cf_get_lang dictionary_id='60795.Devreden Borç'></td>
								<td width="125" align="center"><cf_get_lang dictionary_id='60796.Devreden Alacak'></td>
								<td width="155">&nbsp;</td>
							</tr>
							<tr class="th">
							<cfset satir_sayisi=satir_sayisi+1>
								<td width="435" colspan="5">&nbsp;<cf_get_lang dictionary_id='60797.Devreden Küm. Toplam'></td>
								<td width="125" align="right" style="text-align:right;"><cfoutput>#TLFormat(muavin_borc)#</cfoutput></td>
								<td width="125" align="right" style="text-align:right;"><cfoutput>#TLFormat(muavin_alacak)#</cfoutput></td>
								<td width="155">&nbsp;</td>
							</tr>
						</cfif>
				</cfif>
			<cfelse>
				<tr class="tr" valign="top" height="20">
					<cfset satir_sayisi=satir_sayisi+1>
					<td colspan="9"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
				</tr>
				<cfif (len(attributes.pdf_page_row) and attributes.pdf_page_row neq 0 and (satir_sayisi mod attributes.pdf_page_row) eq 1)><!--- satır sayısı belirtilmisse sayfalama yapılıyor --->
					</table>
					<cfdocumentitem type="pagebreak"/>
					<table cellpadding="0" cellspacing="0" border="0" width="98%">
						<cfif isdefined("attributes.is_show_cumulative_sum") and attributes.is_show_cumulative_sum eq 1>
							<tr class="th">
							<cfset satir_sayisi=satir_sayisi+1>
								<td width="435" colspan="6">&nbsp;</td>
								<td width="125" align="center"><cf_get_lang dictionary_id='60795.Devreden Borç'></td>
								<td width="125" align="center"><cf_get_lang dictionary_id='60796.Devreden Alacak'></td>
								<td width="155">&nbsp;</td>
							</tr>
							<tr class="th">
							<cfset satir_sayisi=satir_sayisi+1>
								<td width="435" colspan="6">&nbsp;<cf_get_lang dictionary_id='60797.Devreden Küm. Toplam'></td>
								<td width="125" align="right" style="text-align:right;"><cfoutput>#TLFormat(muavin_borc)#</cfoutput></td>
								<td width="125" align="right" style="text-align:right;"><cfoutput>#TLFormat(muavin_alacak)#</cfoutput></td>
								<td width="155">&nbsp;</td>
							</tr>
						</cfif>
				</cfif>
			</cfif>
		</table>
	</cfloop>
</cfdocument>
<script type="text/javascript">
		<cfoutput>
			get_wrk_message_div("#getLang('main',1931)#","#getLang('main',1936)#","/documents/reserve_files/#drc_name_#/#filename#.pdf")  
		</cfoutput>
	</script>

