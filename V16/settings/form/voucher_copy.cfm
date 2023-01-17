<cfquery name="get_companies" datasource="#dsn#">
	SELECT 
    	COMP_ID, 
        COMPANY_NAME
    FROM 
	    OUR_COMPANY 
</cfquery>
<cfsavecontent variable = "title">
	<cf_get_lang no='1594.Senet Dönem Aktarım'>
</cfsavecontent>
<cf_form_box title="#title#">
	<cf_area width="50%">
		<cfform name="add_cheque_entry" action="#request.self#?fuseaction=settings.emptypopup_voucher_copy" method="post" >
			<table>
			<tr>
				<td><cf_get_lang no='1592.Hangi Şirketten'></td>
				<td>
					<select name="kaynak_period_1" id="kaynak_period_1" style="width:350px;" onchange="show_periods_departments(1)">
						<cfoutput query="get_companies">
							<option value="#comp_id#" <cfif comp_id eq session.ep.company_id>selected</cfif>>#COMPANY_NAME#</option>
						</cfoutput>
					</select>
				</td>  
				<td>
					<div id="source_div">
						<select name="from_cmp" id="from_cmp" style="width:220px;">

						</select>
					</div>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang no='1593.Hangi Şirkete'></td>
				<td>
					<select name="hedef_period_1" id="hedef_period_1" style="width:350px;" onchange="show_periods_departments(2)">
						<cfoutput query="get_companies">
							<option value="#comp_id#" <cfif comp_id eq session.ep.company_id>selected</cfif>>#COMPANY_NAME#</option>
						</cfoutput>
					</select>
				</td>
				<td>
					<div id="target_div">
						<select name="to_cmp" id="to_cmp" style="width:220px;">

						</select>
					</div>
				</td>
			</tr>
			
			<tr>
				<td colspan="2"><input type="checkbox" name="is_cheque_voucher_based_action" id="is_cheque_voucher_based_action" value="1"><cf_get_lang no ='2056.Satır Bazında Çek\Senetleri Carileştir'></td>
			</tr>
			<tr>
				<td height="35" colspan="2" align="right" style="text-align:right;"><cf_workcube_buttons is_upd='0' add_function='kontrol()'></td>
			</tr>
		</table>  
		</cfform>
		
		<font><b><cf_get_lang_main no='1185.Önemli Uyarı'>!</b></font><br>
		<b><cf_get_lang no ='2057.Senet Dönem Aktarımı, Sadece Dönem Başı İşlemi Olarak Kullanılmalıdır'>
		</b><br/><br/>
</cf_area>
	<cf_area width="50%">
		<table>
				<tr height="30">
					<td class="headbold" valign="top"><cf_get_lang_main no='21.Yardım'></td>
				</tr>    
				<tr>
					<td valign="top"> 
						<cftry>
							<cfinclude template="#file_web_path#templates/period_help/voucherTransferPeriod_#session.ep.language#.html">
							<cfcatch>
								<script type="text/javascript">
									alert("<cf_get_lang_main no='1963.Yardım Dosyası Bulunamadı Lutfen Kontrol Ediniz'>");
								</script>
							</cfcatch>
						</cftry>
					</td>
				</tr>
			</table>
	</cf_area>					     
</cf_form_box>
<script type="text/javascript">
	function kontrol()
	{
		if(document.getElementById('from_cmp').value == document.getElementById('to_cmp').value)
		{
			alert("Aynı Dönem İçerisinde Aktarım Yapılamaz !");
			return false;		
		}
		return true;
	}
	$(document).ready(function(){
			var company_id = document.getElementById('kaynak_period_1').value;
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_ajax_periods&company_id="+company_id;
			AjaxPageLoad(send_address,'from_cmp',1,'Dönemler');
		}
	)
	function show_periods_departments(number)
	{
		if(number == 1)
		{
			if(document.getElementById('kaynak_period_1').value != '')
			{
				var company_id = document.getElementById('kaynak_period_1').value;
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_ajax_periods&company_id="+company_id;
				AjaxPageLoad(send_address,'from_cmp',1,'Dönemler');
			}
		}
		else if(number == 2)
		{
			if(document.getElementById('hedef_period_1').value != '')
			{
				var company_id = document.getElementById('hedef_period_1').value;
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_ajax_periods&company_id="+company_id;
				AjaxPageLoad(send_address,'to_cmp',1,'Dönemler');
			}
		}
	}
	$(document).ready(function(){
			var company_id = document.getElementById('hedef_period_1').value;
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_ajax_periods&company_id="+company_id;
			AjaxPageLoad(send_address,'to_cmp',1,'Dönemler');
		}
	)
</script>
