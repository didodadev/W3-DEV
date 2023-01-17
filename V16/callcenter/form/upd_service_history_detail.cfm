<cfquery name="GET_DETAIL" datasource="#DSN#">
	SELECT 
		SERVICE_DETAIL,
		SERVICE_HISTORY_ID
	FROM
		G_SERVICE_HISTORY
	WHERE 
		SERVICE_HISTORY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_history_id#">
</cfquery>
<cf_catalystHeader>
<cf_box>
	<cfform name="upd_support" action="#request.self#?fuseaction=call.emptypopup_upd_service_history_detail" method="post" >
		<input type="hidden" name="service_history_id" id="service_history_id" value="<cfoutput>#attributes.service_history_id#</cfoutput>">
		<div class="ui-form-list ui-form-block">
			<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12" id="item-detail">
				<label><cf_get_lang_main no='217.Açıklama'> *</label>
					<cfmodule
					template="/fckeditor/fckeditor.cfm"
					toolbarset="Basic"
					basepath="/fckeditor/"
					instancename="service_detail"
					valign="top"
					value="#get_detail.service_detail#"
					width="800"
					height="400">
			</div>
		</div>
		<cf_box_footer>
			<cf_workcube_buttons type_format='1' is_upd="1" is_delete="0">
		</cf_box_footer>
	</cfform>
</cf_box>
