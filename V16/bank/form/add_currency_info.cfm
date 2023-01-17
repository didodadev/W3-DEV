<!---e.a select ifadeleri düzenlendi. 23.07.2012--->
<!--- sadece sistem 2.dövizinin kurunu seçtirir,belgeleri alırken 2.döviz karşılıklarını da tutar.Aysenur2007026 --->
<cfquery name="GET_MONEY_INFO" datasource="#dsn2#">
	SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY WHERE MONEY = '#session.ep.money2#'
</cfquery>
<cf_popup_box title="#getLang('bank',327)#">
<cfform name="add_currency" method="post" action="#request.self#?fuseaction=bank.emptypopupflush_import_pos_file" onsubmit="return(unformat_fields());">
<input type="hidden" name="i_id" id="i_id" value="<cfoutput>#attributes.i_id#</cfoutput>">
	<table>
		<tr>
			<td class="formbold"><cf_get_lang no ='328.Kur Bilgisi'></td>
		</tr>
		<cfif GET_MONEY_INFO.recordcount>
			<cfoutput>
				<tr>
					<td><input type="radio" name="is_selected" id="is_selected" <cfif GET_MONEY_INFO.MONEY eq session.ep.money2>checked</cfif>> #GET_MONEY_INFO.MONEY#</td>
					<td>
						<input type="hidden" name="money_type" id="money_type" value="#GET_MONEY_INFO.MONEY#">
						<input type="hidden" name="money_rate1"  id="money_rate1" value="#GET_MONEY_INFO.RATE1#">
						<cfsavecontent variable="message"><cf_get_lang no ='.Kur Giriniz'>!</cfsavecontent>
						<input type="text" name="money_rate2" id="money_rate2" style="width:65px;" required="yes" value="#TLFormat(GET_MONEY_INFO.RATE2,session.ep.our_company_info.rate_round_num)#" class="box" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(1);" message="#message#">
					</td>
				</tr>
				<tr><td><br/></td></tr>
			</cfoutput>
		<cfelse>
			<tr><td><br/><b><cf_get_lang no ='329.Sistem 2 Dövizi Tanımlayınız'>!</b></td></tr>
		</cfif>
	</table>
	<cf_popup_box_footer><cf_workcube_buttons type_format="1" is_upd='0'></cf_popup_box_footer>
</cfform>
</cf_popup_box>
<script type="text/javascript">
function unformat_fields()
{
	add_currency.money_rate2.value = filterNum(add_currency.money_rate2.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
}	
</script>
