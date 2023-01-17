<!--- bu sayfaının nerde ise aynısı hr modülündede var bu sayfada yapılan değişiklikler hr deki dosyayada taşınsın--->
<cfquery name="get_list" datasource="#dsn#">
	SELECT
		*
	FROM
		EMPLOYEES_APP_SEL_LIST
	WHERE 
		LIST_ID=#attributes.list_id#
</cfquery>
		<table cellspacing="1" cellpadding="2" width="98%" height="100%" border="0" class="color-border" align="center">
			<tr class="color-list">
				<td class="headbold" height="35"><cf_get_lang dictionary_id ='31917.Seçim Listesi Güncelle'></td>
			</tr> 
			<tr class="color-row">
			<td valign="top">
			<table>
			<form name="upd_list" id="upd_list" action="<cfoutput>#request.self#?fuseaction=myhome.emptypopup_upd_select_emp_list</cfoutput>" method="post">
				<tr>
				  <td width="70"><cf_get_lang dictionary_id='57480.Başlık'></td>
				  <td width="200">
				 	<input type="text" name="list_name" id="list_name" style="width:175px;" value="<cfoutput>#get_list.list_name#</cfoutput>" readonly="">
				  </td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id ='57482.Aşama'></td>
					<td><cf_workcube_process
							is_upd='0' 
							select_value ='#get_list.sel_list_stage#'
							process_cat_width='175' 
							is_detail='0'>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<input type="hidden" name="list_id" id="list_id" value="<cfoutput>#attributes.list_id#</cfoutput>">
						<cf_get_lang dictionary_id='57483.Kayıt'>: <cfoutput>#get_emp_info(get_list.record_emp,0,0)# #dateformat(date_add('h',session.ep.time_zone,get_list.record_date),dateformat_style)#  (#timeformat(date_add('h',session.ep.time_zone,get_list.record_date),timeformat_style)#)</cfoutput> 
						<br/><cfif len(get_list.update_emp)><cfoutput><cf_get_lang dictionary_id='57703.Güncelleme'>: #get_emp_info(get_list.update_emp,0,0)# #dateformat(date_add('h',session.ep.time_zone,get_list.update_date),dateformat_style)#  (#timeformat(date_add('h',session.ep.time_zone,get_list.update_date),timeformat_style)#)</cfoutput></cfif>
					</td>
				</tr>
				<tr>
					<td colspan="2"  style="text-align:right;">
						<cf_workcube_buttons is_upd='1' is_delete='0' add_function="kontrol()">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					</td>
				</tr>
				</form>
			</table>
			</td>
			</tr>
		</table>
<script type="text/javascript">
function kontrol()
{
	return process_cat_control();
}
</script>
