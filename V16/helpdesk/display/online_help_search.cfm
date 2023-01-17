<cfparam name="attributes.search_key" default="">
<!--- <cf_get_lang_set module_name="help"> ---><!--- sayfanin en altinda kapanisi var --->
<cfquery name="GET_MODULES" datasource="#DSN#">
	SELECT 
			*
	FROM 
		MODULES
</cfquery>
<cfform name="online_help" action="http://www.workcube.com/index.cfm?fuseaction=objects.popup_online_help">
<table width="100%">
	<tr class="color-list">
		<td class="formbold" height="30" colspan="2"><img src="../../images/abc_dic.gif" border="0" align="absmiddle"> <cf_get_lang no ='33.Workcube Kullanım Yardımı'></td>
	</tr>
	<tr>
		<td colspan="2" class="txtbold" height="30"><cf_get_lang no ='9.Aradığınız kelimeyi veya modülü giriniz'>.</td>
	</tr>
	<tr>
		<td><cf_get_lang no ='10.Kelime'></td>
		<td><input type="text" name="search_key" id="search_key" value="" style="width:150px;"></td>
	</tr>
	<tr>
		<td><cf_get_lang no ='18.Modül'></td>
		<td><select name="module_id" id="module_id" style="width:150px;">
		<option value=""><cf_get_lang no ='32.Tüm Modüller'></option>
		<cfoutput query="GET_MODULES">
		<option value="#MODULE_ID#">#MODULE_NAME_TR#</option>
		</cfoutput>	
		</select>
		<input type="submit" name="search" id="search" value="<cf_get_lang_main no ='153.ARA'>" style="width:30px;"></td>
	</tr>
	</cfform>
</table>
<!--- <cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"> ---> <!--- sayfanin en ustunde acilisi var --->


