<cfquery name="get_partner_point" datasource="#dsn#">
	SELECT (USER_POINT-ISNULL(USED_USER_POINT,0)) USER_POINT FROM COMPANY_PARTNER_POINTS WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
</cfquery>

<table cellspacing="2" cellpadding="2" width="100%" border="0">
  <tr>
	<td class="formbold" height="22"><cf_get_lang no='1550.Toplam Hediye Puanınız'> : <cfif get_partner_point.recordcount><cfoutput>#get_partner_point.user_point#</cfoutput><cfelse>0</cfif></td>
  </tr>
</table>

<br/>
<cfset input_count = 1>
<table cellspacing="2" cellpadding="2" border="0">
  <tr>
	<td class="formbold" colspan="7" height="22"><cf_get_lang no='1135.Giriş Yap'></td>
  </tr>
	<cfform action="#request.self#?fuseaction=objects2.emptypopup_add_partner_serials" name="add_serial_returns" method="post">
	<input type="hidden" name="input_count" id="input_count" value="<cfoutput>#input_count#</cfoutput>">
	<tr class="color-list" height="22">
		<td class="txtboldblue"><cf_get_lang_main no='225.Seri No'></td>
		<td class="txtboldblue"><cf_get_lang_main no='816.Güvenlik No'></td>
	</tr>
	<cfloop from="1" to="#input_count#" index="i">
		<cfoutput>
			<tr height="22">
				<td><input type="text" name="seri_no_#i#" id="seri_no_#i#" value=""></td>
				<td><input type="text" name="lot_no_#i#" id="lot_no_#i#" value=""></td>
			</tr>
		</cfoutput>
	</cfloop>
	<tr>
		<td colspan="2" align="right" style="text-align:right;"><cf_workcube_buttons add_function='kontrol_returns()'></td>
	</tr>
	</cfform>
	<tr>
		<td><a href="<cfoutput>#request.self#?fuseaction=objects2.list_partner_serials</cfoutput>" class="tableyazi"><cf_get_lang_main no='817.Geçmiş'></a></td>
	</tr>
</table>
<script type="text/javascript">
	function kontrol_returns()
	{
	var kayit_ = 0;
	var seri_list_ = '*_*';
	<cfloop from="1" to="#input_count#" index="i">
		<cfoutput>
			if(document.add_serial_returns.seri_no_#i#.value!='')
				{
				var bul_ = list_find(seri_list_,document.add_serial_returns.seri_no_#i#.value);
				if(bul_!=0)
					{
					alert('<cf_get_lang no="1551.Lütfen Aynı Seri Noyu İki Kere Kullanmayınız!">');
					return false;
					}
				}
			if(document.add_serial_returns.seri_no_#i#.value!='' && document.add_serial_returns.lot_no_#i#.value=='')
				{
				alert('<cf_get_lang no="1549.Lütfen Lot No Giriniz.">-<cf_get_lang_main no="818.Satır No">: #i#');
				return false;
				}
			if(document.add_serial_returns.seri_no_#i#.value=='' && document.add_serial_returns.lot_no_#i#.value!='')
				{
				alert('<cf_get_lang no="577.Lütfen Seri No Giriniz.">-<cf_get_lang_main no="818.Satır No">: #i#');
				return false;
				}
			if(document.add_serial_returns.seri_no_#i#.value!='')
				{
				kayit_ = 1;
				}
			if(document.add_serial_returns.seri_no_#i#.value!='')
				{
				var seri_list_ = seri_list_ + ',' + document.add_serial_returns.seri_no_#i#.value;
				}
		</cfoutput>
	</cfloop>
	if(kayit_ == 0)
		{
		alert('<cf_get_lang no="577.Lütfen Seri No Giriniz.">');
		return false;
		}
	}
</script>
