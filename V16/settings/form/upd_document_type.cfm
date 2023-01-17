<cfquery name="GET_DOCUMENT_TYPE" datasource="#DSN#" maxrows="1">
	SELECT
		DOCUMENT_TYPE_ID,
		#dsn#.Get_Dynamic_Language(DOCUMENT_TYPE_ID,'#session.ep.language#','SETUP_DOCUMENT_TYPE','DOCUMENT_TYPE_NAME',NULL,NULL,DOCUMENT_TYPE_NAME) AS DOCUMENT_TYPE_NAME,
		DOCUMENT_TYPE_DETAIL,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP,
		UPDATE_DATE,
		UPDATE_EMP,
		UPDATE_IP
	FROM
		SETUP_DOCUMENT_TYPE
	WHERE
		DOCUMENT_TYPE_ID = #attributes.document_type_id#
</cfquery>
<cfquery name="GET_DOCUMENT_TYPE_ROW" datasource="#DSN#">
	SELECT
		*
	FROM
		SETUP_DOCUMENT_TYPE_ROW
	WHERE
		DOCUMENT_TYPE_ID = #attributes.document_type_id#
</cfquery>
<div class="col col-12 col-xs-12">
	<cf_box title="#getLang('','settings',42870)#" add_href="#request.self#?fuseaction=settings.form_add_document_type" is_blank="0"><!--- Belge tipleri --->
        <cfform name="upd_document_type" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_document_type">
			<cf_box_elements>	
			<input type="hidden" name="document_type_id" id="document_type_id" value="<cfoutput>#attributes.document_type_id#</cfoutput>"> 
		  <div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="1" sort="true">
			<cfinclude template="../display/list_document_type.cfm">
		  </div>
		  <div class="col col-9 col-md-9 col-sm-9 col-xs-12" type="column" index="2" sort="true">
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
			  <div class="form-group" id="item-time_cost_cat">
				<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='43282.Belge Adı'> *</label>
				<div class="col col-8 col-md-6 col-xs-12">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='43283.Belge Adı Girmelisiniz'> !</cfsavecontent>
						<cfinput type="text" name="document_name"  value="#get_document_type.document_type_name#" required="yes" message="#message#" maxlength="100">				
						<span class="input-group-addon">
							<cf_language_info
							table_name="SETUP_DOCUMENT_TYPE"
							column_name="DOCUMENT_TYPE_NAME"
							column_id_value="#attributes.document_type_id#"
							maxlength="500"
							datasource="#dsn#" 
							column_id="DOCUMENT_TYPE_ID" 
							control_type="0">
						</span>
					</div>
				</div>
			  </div>
			  <div class="form-group" id="item-time_cost_cat">
				<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='52734.Wo'>-<cf_get_lang dictionary_id='40574.FuseAction'></label>
				<div class="col col-8 col-md-6 col-xs-12">
				  <div class="input-group">
					<textarea name="module_field_name" id="module_field_name" style="width:250px;height:60px;"><cfif (get_document_type_row.recordcount)><cfoutput query="get_document_type_row"><cfif currentrow neq recordcount>#fuseaction#,<cfelse>#fuseaction#</cfif></cfoutput></cfif></textarea>
					<span class="input-group-addon icon-pluss btnPointer" onclick="gonder();"></span>                    
				  </div>
				</div>
			  </div>
			  <div class="form-group" id="item-time_cost_cat">
				<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main dictionary_id='57629.Açıklama'></label>
				<div class="col col-8 col-md-6 col-xs-12">
				<td valign="top"><textarea name="detail" id="detail" style="width:250px;height:60px;" maxlength="250" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="Kullanılabilecek Maksimum Karakter Sayısı : 250!"><cfoutput>#get_document_type.document_type_detail#</cfoutput></textarea>
				</div>
			  </div>
			</div>
			</div>
		</cf_box_elements>
		<cf_box_footer>	
			<cf_record_info query_name="GET_DOCUMENT_TYPE">
			<cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
		</cf_box_footer>
	  </cfform>
	</cf_box>
  </div>

<script type="text/javascript">
function gonder()
{
	if(upd_document_type.module_field_name.value=="")
		windowopen('<cfoutput>#request.self#?fuseaction=settings.popup_dsp_faction_list&field_name=upd_document_type.module_field_name&is_upd=0</cfoutput>','list');
	else
		windowopen('<cfoutput>#request.self#?fuseaction=settings.popup_dsp_faction_list&field_name=upd_document_type.module_field_name&is_upd=1</cfoutput>','list');
}

function kontrol()
	{
		if(document.getElementById("document_name").value == '')
		{
			alert('<cf_get_lang dictionary_id='43283.Belge Adı Girmelisiniz'> !')
			return false;
		}
	}
</script>
