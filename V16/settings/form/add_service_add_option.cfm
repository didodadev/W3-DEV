<!---<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
	<tr>
    	<td class="headbold">Servis Özel Tanımları</td>
	</tr>
</table>
<table border="0" cellspacing="1" cellpadding="2" width="98%" class="color-border" align="center">
	<tr class="color-row" valign="top">
		<td width="200"><cfinclude template="../display/list_service_add_options.cfm"></td>
		<td>
		<table>
		<cfform name="add_service_option" method="post" action="#request.self#?fuseaction=settings.emptypopup_add_service_add_option">
			<tr>
				<td width="100">Servis Özel Tanım *</td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang no='1092.Özel Tanım Girmelisiniz'></cfsavecontent>
					<cfinput type="text" name="add_option_name" maxlength="50" value="" required="yes" message="#message#" style="width:150px;">
				</td>
			</tr>
			<tr>
				<td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
				<td><textarea name="add_option_detail" style="width:150px;height:40px;"  maxlength="250" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="Maksimum Karakter Sayısı : 250"></textarea>
			</td>
			</tr>
			<tr>
				<td></td>
				<td><cf_workcube_buttons is_upd='0'></td>
			</tr>
		</cfform>
		</table>
		</td>
	</tr>
</table>--->

<cf_wrk_grid search_header = "#getLang('','Servis Özel Tanımları',64190)#" table_name="SETUP_SERVICE_ADD_OPTIONS" sort_column="SERVICE_ADD_OPTION_NAME" u_id="SERVICE_ADD_OPTION_ID" datasource="#dsn3#" search_areas = "SERVICE_ADD_OPTION_NAME,DETAIL">
    <cf_wrk_grid_column name="SERVICE_ADD_OPTION_ID" header="#getLang('main',1165)#" display="no" select="yes"/>
    <cf_wrk_grid_column name="SERVICE_ADD_OPTION_NAME" width="200" header="#getLang('','Servis Özel Tanım',59029)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="DETAIL" width="200" header="#getLang('main',217)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="100" select="no" display="yes"/> 
</cf_wrk_grid>
