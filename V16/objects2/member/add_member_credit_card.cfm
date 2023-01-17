<cfsetting showdebugoutput="no">
<cfquery name="get_card" datasource="#dsn#">
	SELECT CARDCAT,CARDCAT_ID FROM SETUP_CREDITCARD
</cfquery>
<cfquery name="get_bank_type" datasource="#dsn#">
	SELECT BANK_NAME,BANK_ID FROM SETUP_BANK_TYPES ORDER BY BANK_NAME
</cfquery>
<cfform method="post" name="add_credit_card" action="#request.self#?fuseaction=objects2.emptypopup_add_member_credit_card">
	<input type="hidden" name="is_add" id="is_add" value="1">
	<cfif isdefined('session.pp.company_id')>
		<input type="hidden" name="member_id" id="member_id" value="<cfoutput>#session.pp.company_id#</cfoutput>">
		<input type="hidden" name="member_type" id="member_type" value="partner">
	<cfelse>
		<input type="hidden" name="member_id" id="member_id" value="<cfoutput>#session.ww.userid#</cfoutput>">
		<input type="hidden" name="member_type" id="member_type" value="consumer">
	</cfif>
	<table>
		<tr>
			<td width="50"><cf_get_lang_main no='81.Aktif'></td>
			<td><input type="checkbox" name="default_card" id="default_card"></td>
		</tr>
		<tr> 
			<td>Kart Tipi</td>
			<td>
				<select name="card_type" id="card_type" style="width:200px;">
					<option value=" "><cf_get_lang_main no='322.Seçiniz'>
					<cfoutput query="get_card">
						<option value="#CARDCAT_ID#">#CARDCAT#</option>
					</cfoutput>
				</select> 
			</td>
		</tr>
		<tr> 
			<td><cf_get_lang_main no='109.Banka'></td>
			<td>
				<select name="bank_type" id="bank_type" style="width:200px;">
					<option value=""><cf_get_lang_main no='322.Seçiniz'>
					<cfoutput query="get_bank_type">
						<option value="#BANK_ID#">#BANK_NAME#</option>
					</cfoutput>
				</select> 
			</td>
		</tr>
			<tr> 
				<td>Kart Numarası</td>
				<td>
					 <cfsavecontent variable="message">Geçerli Bir Kredi Kartı Numarası Giriniz !</cfsavecontent>
				 	 <cfinput type="Text" name="card_no" validate="creditcard" id="card_no" required="Yes" message="#message#" maxlength="16" onKeyUp="isNumber(this);" style="width:200px;">
				</td>
			</tr>
			<tr> 
				<td>Kart Hamili</td>
				<td><input type="Text"  name="card_owner" id="card_owner" value="" style="width:200px;" maxlength="50"></td>
			</tr>
			<tr> 
				<td>Son Kullanma Tarihi</td>
				<td>           
					<select name="month" id="month" style="width:70px;">
						<cfloop from="1" to="12" index="k">
							<cfoutput>
								<option value="#k#">#k#</option>
							</cfoutput> 
						</cfloop>
					</select>
					Ay&nbsp;&nbsp;&nbsp;
					<select name="year" id="year" style="width:80px;">
						<cfloop from="#dateFormat(now(),'yyyy')#" to="#dateFormat(now(),'yyyy')+10#" index="i">
							<cfoutput>
								<option value="#i#">#i#</option>
							</cfoutput> 
						</cfloop>
					</select>
					Yıl
				</td>
			</tr>
		<tr> 
			<td>CVV No</td>
			<td>
				<cfsavecontent variable="message">CVV No Giriniz!</cfsavecontent>
				<cfinput type="Text" name="CVS" id="CVS" validate="integer" message="#message#" maxlength="3" required="yes" onKeyUp="isNumber(this);" style="width:200px;">
			</td>
		</tr>
		<tr>
			<td>Hesap Kesim Günü</td>
			<td>
				<cfinput type="text" name="acc_off_date" validate="integer" message="Hesap Kesim Günü Girmelisiniz !" onKeyUp="isNumber(this);" style="width:70px;">
			</td>
		</tr>
		<tr>
			<td></td>
			<td height="35">
				<cf_workcube_buttons is_upd='0' is_cancel=0 add_function="cc_controls()">
			</td>
		</tr>
		<tr>
			<td colspan="2"><hr style="height:0.1px;" color="CCCCCC"></td>
		</tr>
	</table>
</cfform>
<script type="text/javascript">
	function cc_controls()
	{
		if(document.add_credit_card.card_type.value == 0){
			alert("Lütfen Kredi Kartı Tipi Seçiniz !");
			return false;
		}
		if(document.getElementById("card_no").value == '')
		{
			alert("Geçerli Bir Kredi Kartı Numarası Giriniz !");
			return false;
		}
		if(document.getElementById("CVS").value == '')
		{
			alert("CVV No Giriniz!");
			return false;
		}
		d = new Date();
		if((document.add_credit_card.year.value < d.getYear() && document.add_credit_card.month.selectedIndex < d.getMonth()) || (document.add_credit_card.year.value == d.getYear() && document.add_credit_card.month.selectedIndex < d.getMonth()))
		{
			alert("Geçerlilik Tarihi Bu Dönemden Küçük Olamaz");
			return false;
		}
		return true;
	}
</script>
