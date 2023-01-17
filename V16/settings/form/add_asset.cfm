<table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%" class="color-border">
	<tr class="color-list" valign="middle">
  		<td height="35">
		<table width="98%" align="center">
			<tr>
				<td valign="bottom" class="headbold"><cf_get_lang no='286.Logo Ekle'></td>
		  	</tr>
		</table>
  		</td>
	</tr>
	<tr class="color-row" valign="top">
  		<td>
		<table align="center" width="98%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td colspan="2"> <br/>
			  	<table border="0">
				<form enctype="multipart/form-data" method="post" action="<cfoutput>#request.self#?fuseaction=settings.emptypopup_proadd_asset</cfoutput>">
				  	<tr>
						<td><cf_get_lang no='287.Logo Adı'></td>
						<td><input type="text" name="asset_name" id="asset_name" style="width:250px;"></td>
				  	</tr>
				  	<tr>
						<td><cf_get_lang_main no='668.Resim'></td>
						<td><input type="FILE" name="asset" id="asset" style="width:250px;"></td>
					</tr>
				  	<tr>
						<td valign="top"><cf_get_lang no='289.Keywords'></td>
						<td><textarea name="ASSET_DETAIL" id="ASSET_DETAIL" style="width:250px; height:75px;"></textarea></td>
				  	</tr>
				  	<tr>
						<td align="right" height="35" class="headbig" colspan="2"><cf_workcube_buttons is_upd='0'></td>
				  	</tr>
				</form>
			  	</table>
				</td>
		  	</tr>
		</table>
  		</td>
	</tr>
</table>
