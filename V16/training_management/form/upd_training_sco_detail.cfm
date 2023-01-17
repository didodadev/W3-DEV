<!--- Eğitim İçerik paketi ek bilgiler--->
<cfquery name="get_sco" datasource="#dsn#">
	SELECT
		NAME,
		IS_FREE,
		WIDTH,
		HEIGHT,
		RECORD_EMP,
		RECORD_DATE,
		UPDATE_EMP,
		UPDATE_DATE
	FROM
		TRAINING_CLASS_SCO
	WHERE
		SCO_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.scoid#">
</cfquery>
<cf_popup_box title="Scorm Güncelle : #get_sco.name#">
	<cfform name="upd_detail" method="post" action="#request.self#?fuseaction=training_management.emptypopup_upd_train_sco_detail">
	<cfoutput>
	<input type="hidden" name="sco_id" id="sco_id" value="#scoid#">
		<table width="99%" border="0">
			<tr>
				<td>Herkese Açık</td>
				<td><input type="checkbox" name="is_free" id="is_free" value="1" <cfif get_sco.is_free is 1>checked</cfif>></td>
			</tr>
			<tr>
				<td>Çözünürlük(piksel)</td>
				<td><cfinput type="text" name="width" style="width:50px;" value="#get_sco.width#" validate="integer"  maxlength="5" onKeyUp="isNumber(this)"> X <cfinput type="text" name="height" style="width:50px;" value="#get_sco.height#" validate="integer" maxlength="5" onKeyUp="isNumber(this)"></td>
			</tr>
		</table>
		</cfoutput>
		<cf_popup_box_footer>
			<cf_record_info query_name="get_sco">
			<cf_workcube_buttons is_upd='0'>
		</cf_popup_box_footer>
	</cfform>
</cf_popup_box>
