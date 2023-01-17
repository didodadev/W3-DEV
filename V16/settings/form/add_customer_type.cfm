<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
	<td  class="headbold"><cf_get_lang_main no='45.Müşteri'> <cf_get_lang no='1627.Tipi'> <cf_get_lang_main no='170.Ekle'></td>
  </tr>
</table>
<table width="98%" border="0" align="center" cellpadding="2" cellspacing="1" class="color-border">
	<tr class="color-row">
		<td width="200" valign="top"><cfinclude template="../display/list_customer_type.cfm"></td>
		<td valign="top">
		<table>
		<cfform name="add_customer_type" method="post" action="#request.self#?fuseaction=settings.emptypopup_add_customer_type">
			<tr>
				<td width="100"><cf_get_lang_main no='218.Tip'> *</td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang no='1755.Tip Girmelisiniz'> !</cfsavecontent>
					<cfinput type="text" name="customer_type" value="" maxlength="25" required="yes" message="#message#" style="width:180px;">
				</td>
			</tr>
			<tr>
				<td width="100" valign="top"><cf_get_lang_main no='217.Açıklama'></td>
				<td><textarea name="detail" id="detail" style="width:180px;height:90px;"></textarea></td>
			</tr>
			<tr>
				<td><cf_get_lang no='1710.Tutar Kontrolü'></td>
				<td><input type="checkbox" value="1" name="is_control" id="is_control" onClick="is_control_function()"></td>
			</tr>
			<tr>
				<td><span id="span_1" style="display:none;"><cf_get_lang no='1354.Zorunluluk Oranı'></span></td>
				<td>
					<span id="span_2" style="display:none;">
						<input type="text" name="control_rate" id="control_rate" value="" maxlength="3" onkeyup="return(FormatCurrency(this,event,0));" class="moneybox" style="width:30px;">
					</span>
				</td>
			</tr>
		  	<tr>
				<td></td>
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
	if(document.add_customer_type.detail.value.length>1000)
	{
		alert("<cf_get_lang no='1362.Açıklama Karakterden Uzun Olamaz'> 1000 !");
		return false;
	}
	if(document.add_customer_type.is_control.checked == true)
	{
		if(document.add_customer_type.control_rate.value == '')
		{
			alert("<cf_get_lang no='1376.Zorunluluk Oranı Girmelisiniz'> !");
			return false;		
		}
		else
		{
			if(document.add_customer_type.control_rate.value > 100)
			{
				alert("<cf_get_lang no='1377.Zorunluluk Oranı Kontrol Ediniz'> !");
				return false;
			}
		}
		
	}
	document.add_customer_type.control_rate.value = filterNum(document.add_customer_type.control_rate.value);
	return true;
}

function is_control_function()
{
	if(document.add_customer_type.is_control.checked == true)
	{
		goster(span_1);
		goster(span_2);
	}
	else
	{
		gizle(span_1);
		gizle(span_2);
	}
}
</script>



<!---<cf_wrk_grid search_header = "#lang_array_main.item[45]#" table_name="SETUP_CUSTOMER_TYPE" sort_column="CUSTOMER_TYPE" u_id="CUSTOMER_TYPE_ID" datasource="#dsn#" search_areas = "CUSTOMER_TYPE">
    <cf_wrk_grid_column name="CUSTOMER_TYPE_ID" header="#lang_array_main.item[1165]#" display="no" select="yes"/>
    <cf_wrk_grid_column name="CUSTOMER_TYPE" width="200" header="#lang_array_main.item[218]#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="DETAIL" width="200" header="#lang_array_main.item[217]#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="IS_CONTROL" type="boolean" width="100" header="#lang_array.item[1710]#" select="yes" display="yes"/>
	<cf_wrk_grid_column name="CONTROL_RATE" type="boolean" width="100" header="#lang_array.item[1354]#" select="yes" display="yes"/>    <cf_wrk_grid_column name="RECORD_DATE" header="#lang_array_main.item[215]#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#lang_array.item[1180]#" type="date" mask="date" width="100" select="no" display="yes"/> 
</cf_wrk_grid>--->
