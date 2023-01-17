<cfquery name="GET_INFO_ASSET" datasource="#dsn#">
SELECT * FROM ASSETP_IT	WHERE ASSETP_ID = #asset_id#
</cfquery>

<table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%" class="color-border">
  <tr class="color-list" valign="middle">
	<td height="35" class="headbold"><cf_get_lang no='53.IT Bilgisi'></td>
  </tr>
  <tr class="color-row" valign="top">
	<td>
	  <table width="537">
		<cfform action="#request.self#?fuseaction=asset.emptypopup_updit_assetp&assetp_id=#asset_id#" method="post" name="asset_care">
		  <tr>
			<td width="5"></td>
			<td width="102"><cf_get_lang no='61.İşlemci'></td>
			<td width="144"><input type="text" style="width:140" value="<cfif LEN(GET_INFO_ASSET.IT_PRO)><cfoutput>#GET_INFO_ASSET.IT_PRO#</cfoutput></cfif>" name="IT_PRO" id="IT_PRO">
			</td>
			<td width="77"><cf_get_lang no='62.Ek Özellik'> 1</td>
			<td width="185"><input type="text" style="width:140" value="<cfoutput>#GET_INFO_ASSET.IT_PROPERTY1#</cfoutput>" name="IT_PROPERTY1" id="IT_PROPERTY1">
			</td>
		  </tr>
		  <tr>
			<td></td>
			<td><cf_get_lang no='63.Bellek'></td>
			<td><input type="text" style="width:140"  name="IT_MEMORY"  id="IT_MEMORY" value="<cfif LEN(GET_INFO_ASSET.IT_MEMORY)><cfoutput>#GET_INFO_ASSET.IT_MEMORY#</cfoutput></cfif>">
			</td>
			<td width="77"><cf_get_lang no='62.Ek Özellik'> 2</td>
			<td><input type="text" style="width:140"  name="IT_PROPERTY2"  id="IT_PROPERTY2" value="<cfif LEN(GET_INFO_ASSET.IT_PROPERTY2)><cfoutput>#GET_INFO_ASSET.IT_PROPERTY2#</cfoutput></cfif>">
			</td>
		  </tr>
		  <tr>
			<td width="5" height="25"></td>
			<td><cf_get_lang no='36.HDD'></td>
			<td><input type="text" style="width:140" name="IT_HDD" id="IT_HDD" value="<cfif LEN(GET_INFO_ASSET.IT_HDD)><cfoutput>#GET_INFO_ASSET.IT_HDD#</cfoutput></cfif>">
			</td>
			<td width="77"><cf_get_lang no='62.Ek Özellik'> 3</td>
			<td><input type="text" style="width:140" name="IT_PROPERTY3" id="IT_PROPERTY3" value="<cfif LEN(GET_INFO_ASSET.IT_PROPERTY3)><cfoutput>#GET_INFO_ASSET.IT_PROPERTY3#</cfoutput></cfif>" >
			</td>
		  <tr>
			<td width="5"></td>
			<td><cf_get_lang no='65.Konfigürasyon'></td>
			<td><input type="text" style="width:140" name="IT_CON"  id="IT_CON" value="<cfif LEN(GET_INFO_ASSET.IT_CON)><cfoutput>#GET_INFO_ASSET.IT_CON#</cfoutput></cfif>">
			</td>
			<td width="77"><cf_get_lang no='62.Ek Özellik'> 4</td>
			<td><input type="text" style="width:140" name="IT_PROPERTY4" id="IT_PROPERTY4" value="<cfif LEN(GET_INFO_ASSET.IT_PROPERTY4)><cfoutput>#GET_INFO_ASSET.IT_PROPERTY4#</cfoutput></cfif>">
			</td>
		  <tr>
			<td width="5"></td>
			<td valign="top"></td>
			<td>&nbsp;</td>
			<td width="77"><cf_get_lang no='62.Ek Özellik'> 5</td>
			<td><input type="text" style="width:140" name="IT_PROPERTY5" id="IT_PROPERTY5" value="<cfif LEN(GET_INFO_ASSET.IT_PROPERTY5)><cfoutput>#GET_INFO_ASSET.IT_PROPERTY5#</cfoutput></cfif>">
			</td>
		  </tr>
		  <tr>
			<td width="5"></td>
			<td valign="top"></td>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td height="35" colspan="5" style="text-align:right;"> 
			<cf_workcube_buttons is_upd='0'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
		  </tr>
		</cfform>
	  </table>
	</td>
  </tr>
</table>
