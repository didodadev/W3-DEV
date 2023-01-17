<!--- 
açan penceredeki istenen alana seçilenleri kaydeder
	form_name :  Formun adi gelicek
	field_name : departman adinin  gidecegi 
	field_id : departman id si 
	fis_type : Eger Stok acilis Fisi ekliyorsak (donem basinda) bir depoda acils fisi varsa odepoyu listelememsi icin parametre olarak gonderiliyor.
	<a href="#" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_stores_locations&form_name=#formunadi#&field_name=##&field_id=##','list')">
--->
<script type="text/javascript">
function add_location(in_coming_id, in_coming_name, in_coming_store_name, in_coming_store_id, basket)
{
	opener.document.<cfoutput>#form_name#</cfoutput>.<cfoutput>#field_name#</cfoutput>.value = in_coming_name;
	opener.document.<cfoutput>#form_name#</cfoutput>.<cfoutput>#field_id#</cfoutput>.value = in_coming_id;
	if (basket == 1)
		{
		window.opener.clear_fields();/* kalsın erk 20031106*/
		opener.form_basket.submit();
		}
	window.close();
}
	function add_store(in_coming_id, in_coming_name, basket)
{
	opener.document.<cfoutput>#form_name#</cfoutput>.<cfoutput>#field_name#</cfoutput>.value = in_coming_name ;
	opener.document.<cfoutput>#form_name#</cfoutput>.<cfoutput>#field_id#</cfoutput>.value = in_coming_id;
	if (basket == 1)
		{
			window.opener.clear_fields();/* kalsın erk 20031106*/
			opener.form_basket.submit();
		}
	window.close();
}
</script>

<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td class="headbold"><cf_get_lang dictionary_id='32719.Lokasyonlar'></td>
  </tr>
</table>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr class="color-border">
    <td>
      <table width="100%" border="0" cellspacing="1" cellpadding="2">
				<tr height="22" class="color-header">
				  <td width="100" class="form-title"><cf_get_lang dictionary_id='32720.Lokasyon Adı'></td>
				  <td class="form-title"><cf_get_lang dictionary_id='57629.Açıklama'></td>
				</tr>
				<cfquery name="get_location" datasource="#dsn#">
					SELECT
						*
					FROM
						STOCKS_LOCATION SL ,DEPARTMENT D
					WHERE	
						SL.DEPARTMENT_ID=D.DEPARTMENT_ID
					AND
						D.DEPARTMENT_ID=#attributes.dept_main#					 
				</cfquery>
				<cfif GET_LOCATION.RECORDCOUNT >
					<cfoutput query="get_location">
						<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
							<td>#DEPARTMENT_LOCATION#</td>
							<td>
								<a href="javascript://" onClick="add_location('#department_LOCATION# ','#COMMENT#','#DEPARTMENT_HEAD#','#DEPARTMENT_ID#',<cfif isdefined('url.basket')>1<cfelse>0</cfif>)" class="tableyazi" >
									#COMMENT#
								</a>
							</td>
						</tr>
					</cfoutput>
				</cfif>
      </table>
    </td>
  </tr>
</table>

