<table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%" class="color-border">
	<tr class="color-list" valign="middle">
		<td height="35" class="headbold"><cf_get_lang no ='867.Tarih Bilgisi'></td>
	</tr>
	<tr>
		<td valign="top" class="color-row">
			<table border="0">
			<cfform name="form_closer" method="post" action="#request.self#?fuseaction=crm.emptypopup_add_change_is_closed">
				<input type="hidden" name="related_id" id="related_id" value="<cfoutput>#attributes.related_id#</cfoutput>">
				<input type="hidden" name="cpid" id="cpid" value="<cfoutput>#attributes.cpid#</cfoutput>">
				<input type="hidden" name="is_closed" id="is_closed" value="<cfoutput>#attributes.is_closed#</cfoutput>">
				<input type="hidden" name="bugun_" id="bugun_" value="<cfoutput>#DateFormat(now(),dateformat_style)#</cfoutput>">
				<tr>
					<td width="100"><cf_get_lang_main no ='641.Başlangıç Tarihi'></td>
					<td>
						<input type="text" name="closed_start_date" id="closed_start_date" value="<cfoutput>#DateFormat(now(),dateformat_style)#</cfoutput>" maxlength="10" style="width:135px;">
						<cf_wrk_date_image date_field="closed_start_date">
					</td>
				</tr>
				<tr>
					<td><cf_get_lang_main no ='288.Bitiş Tarihi'></td>
					<td>
						<input type="text" name="closed_finish_date" id="closed_finish_date" value="<cfoutput>#DateFormat(date_add('d',30,now()),dateformat_style)#</cfoutput>" maxlength="10" style="width:135px;">
						<cf_wrk_date_image date_field="closed_finish_date">
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td><cf_workcube_buttons is_upd='0' add_function='kontrol()'></td>
				</tr>
			</cfform>
			</table>
		</td>
	</tr>
</table>
<script type="text/javascript">
	function kontrol()
	{
		if(document.form_closer.closed_start_date.value == "" || document.form_closer.closed_finish_date.value == "")
		{
			alert("<cf_get_lang_main no='370.Tarih Değerlerini Kontrol Ediniz!'>");
			return false;
		}
	
		tarih1_ = document.form_closer.bugun_.value.substr(6,4) + document.form_closer.bugun_.value.substr(3,2) + document.form_closer.bugun_.value.substr(0,2);
		tarih2_ = document.form_closer.closed_start_date.value.substr(6,4) + document.form_closer.closed_start_date.value.substr(3,2) + document.form_closer.closed_start_date.value.substr(0,2);
		if(tarih1_ > tarih2_)
		{
			alert("<cf_get_lang no ='868.Başlangıç Tarihi Bugünden Büyük Olmalıdır'> !");
			return false;
		}
		
		deger = datediff(document.form_closer.closed_start_date.value,document.form_closer.closed_finish_date.value,0);
		if(deger > 30 || deger <= 0)
		{
			alert("<cf_get_lang no ='869.Başlangıç ve Bitiş Tarihleri Arasındaki Fark En Çok 30 Gün Olmalıdır'> !");
			return false;
		}
		return true;
	}
</script>
