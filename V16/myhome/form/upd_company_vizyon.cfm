<!---tüm pozisyonları getiriliyor--->
<cfquery name="get_pos_dep" datasource="#dsn#">
	SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID=#session.ep.userid#
</cfquery>
<cfif get_pos_dep.recordcount>
	<cfset pos_list=valuelist(get_pos_dep.POSITION_CODE,',')>
<cfelse>
	<cfset pos_list=session.ep.position_code>
</cfif>
<cfquery name="GET_ADMIN_COMP" datasource="#dsn#">
	SELECT 
		COMPANY_NAME,
		COMP_ID,
		NICK_NAME,
		MANAGER_POSITION_CODE,
		MANAGER_POSITION_CODE2
	FROM 
		OUR_COMPANY 
	WHERE 
		COMP_ID =(#attributes.company_id#)
</cfquery>
<cfquery name="GET_COMP_VIZ" datasource="#dsn#">
	SELECT
		COMP_VIZYON
	FROM 
		OUR_COMPANY_INFO
	WHERE 
		COMP_ID=#attributes.company_id#
</cfquery>
<cfsavecontent variable="head_">
	<cf_get_lang no='597.Şirket Vizyonu Güncelle'>:<cfoutput>#GET_ADMIN_COMP.NICK_NAME#</cfoutput>
</cfsavecontent>
<cf_popup_box title='#head_#'>
<cfform name="add_comp_viz" method="post" action="#request.self#?fuseaction=myhome.emptypopup_company_vizyon">
<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
	<table>
		<tr>
			<td class="txtbold" valign="top"><cf_get_lang_main no='346.Şirket Vizyonu'></td>
			<td class="txtbold"><textarea name="comp_vizyon" id="comp_vizyon" style="width:275px;height:100px;"><cfoutput>#GET_COMP_VIZ.COMP_VIZYON#</cfoutput></textarea></td>
		</tr>
	</table>
	<cf_popup_box_footer>
		<cfif listfind(pos_list,GET_ADMIN_COMP.MANAGER_POSITION_CODE,',') or listfind(pos_list,GET_ADMIN_COMP.MANAGER_POSITION_CODE2,',')>
			<cf_workcube_buttons type_format='1' is_upd='1' is_delete='0' add_function='kontrol()'>
		</cfif>
	</cf_popup_box_footer>
</cfform>
</cf_popup_box>
<script type="text/javascript">
	function kontrol(){
		if(document.add_comp_viz.comp_vizyon.value.length>2000){
			document.add_comp_viz.comp_vizyon.value = document.add_comp_viz.comp_vizyon.value.substring(0,2000);
			alert("<cf_get_lang no='667.Şirket Vizyonu Alanı 2000 karakterden fazla olamaz'>!");
			return false;
		}
		return true;
	}
</script>
