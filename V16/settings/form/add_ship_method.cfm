<!---<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT
		MONEY,
		RATE2,
		RATE1
	FROM 
		SETUP_MONEY
	WHERE
		PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND
		MONEY_STATUS = 1
	ORDER BY
		MONEY_ID
</cfquery>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td height="35" class="headbold"><cf_get_lang no='540.Sevk Metodu Ekle'></td>
  </tr>
</table>
	<table width="98%" border="0" cellspacing="1" cellpadding="2" class="color-border" align="center">
	  <tr class="color-row" valign="top">
		<td width="200"><cfinclude template="../display/list_ship_method.cfm"></td>
		<td>
		<table border="0">
		<cfform name="add_ship_method" method="post" action="#request.self#?fuseaction=settings.emptypopup_ship_method_add">
		  <tr>
			<td width="100"><cf_get_lang_main no='1703.Sevk Yöntemi'> *</td>
		 	<td>
			  <cfsavecontent variable="message"><cf_get_lang no='301.Metod Adı girmelisiniz'></cfsavecontent>
		  	  <cfinput type="text" name="ship_method" value="" maxlength="50" required="Yes" message="#message#" style="width:150px;">
			</td>
		  </tr>
		  <tr>
		  	<td><cf_get_lang_main no='78.Süre (Gün)'></td>
		  	<td><cfinput type="text" name="ship_day" value="" maxlength="3" onKeyUp="isNumber(this);" style="width:150px;"></td>
		  </tr>
		  <tr>
		  	<td><cf_get_lang no='543.Süre (Saat)'></td>
		 	<td><cfinput type="text" name="ship_hour" value="" maxlength="3" onKeyUp="isNumber(this);" style="width:150px;"></td>
		  </tr>
		  <tr>
		  	<td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
		  	<td><textarea name="calculate" style="width:150px;height:60px;"></textarea></td>
		  </tr>
		  <tr>
			<td></td>
			<td><input type="checkbox" name="is_opposite">&nbsp;<cf_get_lang no='1024.Karşı Ödemeli'></td>
		  </tr>
		  <tr>
			<td></td>
			<td><input type="checkbox" name="is_internet">&nbsp;<cf_get_lang no='1025.Internet de Gözüksün'>.</td>
		  </tr>
		  <tr>
		  	<td></td>
		  	<td><cf_workcube_buttons is_upd='0'></td>
		  </tr>
		</cfform>
		</table>
		</td>
	  </tr>
	</table>
<script type="text/javascript">
function get_member()
{
	windowopen("<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_type=add_ship_method.member_type&field_comp_id=add_ship_method.comp_id&field_comp_name=add_ship_method.comp_name&select_list=1,2,3,5,6","list");
}
</script>--->

<cf_wrk_grid search_header = "#getLang('settings',192)#" table_name="SHIP_METHOD" sort_column="SHIP_METHOD" u_id="SHIP_METHOD_ID" datasource="#dsn#" search_areas = "SHIP_METHOD,CALCULATE">
    <cf_wrk_grid_column name="SHIP_METHOD_ID" header="#getLang('main',1165)#" display="no" select="yes"/>
    <cf_wrk_grid_column name="SHIP_METHOD" width="200" header="#getLang('main',1703)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="SHIP_DAY" width="200" header="#getLang('main',78)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="SHIP_HOUR" width="100" header="#getLang('settings',543)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="CALCULATE" width="100" header="#getLang('main',217)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="IS_OPPOSITE" type="boolean" width="100" header="#getLang('settings',1024)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="IS_INTERNET" width="100" type="boolean" header="#getLang('settings',1025)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="100" select="no" display="yes"/> 
</cf_wrk_grid>
