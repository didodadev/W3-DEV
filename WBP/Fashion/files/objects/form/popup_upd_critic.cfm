<cfscript>
	CreateCompenent = CreateObject("component","WBP.Fashion.files.cfc.get_req_supplier_rival");
		get_operation=CreateCompenent.getOperation();
</cfscript>
<cfquery name="GET_NOTE" datasource="#DSN#">
	SELECT 
		IS_SPECIAL,
		IS_WARNING,
		NOTE_HEAD,
		NOTE_BODY,
		RECORD_EMP,
		RECORD_PAR,
		RECORD_DATE,
		RECORD_CONS,
		UPDATE_EMP,
		UPDATE_DATE,
		UPDATE_PAR,
		ACTION_ID
	FROM
		NOTES
	WHERE 
		NOTE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.note_id#"> AND
		(
		IS_SPECIAL = 0
	<cfif isDefined('session.ep')>
		OR ( IS_SPECIAL = 1 AND (RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> OR UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">) )
	<cfelseif isDefined('session.pp')>
		OR ( IS_SPECIAL = 1 AND (RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> OR UPDATE_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">) )
	</cfif>
		)
</cfquery>

<cfquery name="GET_OPPORTUNITY" datasource="#DSN3#">
	SELECT 
	TST.*, PRI.PRIORITY
	FROM 
		TEXTILE_SAMPLE_REQUEST AS TST
		LEFT JOIN #dsn#.SETUP_PRIORITY PRI ON PRI.PRIORITY_ID = TST.REQ_TYPE_ID
	WHERE 
	TST.REQ_ID = #GET_NOTE.ACTION_ID#
</cfquery>

<cf_box title="#getLang('','','62736')#" popup_box="1">
	<cfform name="upd_note" method="post" action="#request.self#?fuseaction=textile.emptypopup_upd_critic">
		<input type="Hidden" name="note_id" id="note_id" value="<cfoutput>#attributes.note_id#</cfoutput>">
		<input type="Hidden" name="action_id" id="action_id" value="<cfoutput>#GET_NOTE.action_id#</cfoutput>">	
		<cf_box_elements verticable="1">		
		<div class="col col-4 col-md-4 col-sm-12 col-xs-12 column" id="column-1">
			<div class="form-group">
				<div class="col col-6 col-xs-12">
					<input type="checkbox" value="1" name="is_special" id="is_special-is" <cfif Len(get_note.is_special) and get_note.is_special> checked</cfif>> <label for="is_special-is"><cf_get_lang_main no='567.Özel Not'></label> 
					</div>
					<div class="col col-6 col-xs-12">
						<input type="checkbox" value="1" name="is_warning" id="is_warning-iw" <cfif Len(get_note.is_warning) and get_note.is_warning> checked</cfif>> <label for="is_warning-iw"><cf_get_lang_main no='13.Uyarı'></label>
						</div>
					</div>
					<div class="form-group">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57480.Konu'> *</label>
						<input type="hidden" style="width:290px;" name="note_head" value="<cfoutput>#get_note.note_head#</cfoutput>" required="yes" maxlength="75" align="left">
						<div class="col col-8 col-xs-12">
							<select style="width:70px;" name="operation">
								<option value="">Operasyon Seçiniz</option>
								<cfoutput query="get_operation"><option value="#operation_code#" <cfif operation_code eq get_note.RECORD_CONS>selected</cfif>> #OPERATION_TYPE# - #GET_OPPORTUNITY.PRIORITY#</option></cfoutput>
							</select>
						</div>
						</div>
					</div>
					<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
						<cf_seperator title="#getLang('','','60068')#" id="detail_seperator">
						<div id="detail_seperator">
							<div class="col col-12">
								<div class="form-group" id="item-editor">
								<label style="display:none!important"><cf_get_lang dictionary_id='60068.Kritik'></label>
								<cfmodule
									template="/fckeditor/fckeditor.cfm"
									toolbarset="Basic"
									basepath="/fckeditor/"
									instancename="note_body"
									valign="top"
									value="<cfoutput>#get_note.note_body#</cfoutput>"
									width="1000"
									height="250">
								</div>
							</div>	
						</div>
					</div>
		</cf_box_elements>
		<cf_box_footer>
			<cf_record_info query_name="get_note"> 
				<!---<button type="button" onclick="notkaydet();" class="btn btn-primary">Güncelle</button>--->
			   <cf_workcube_buttons is_upd='1' type_format="1" add_function='notkaydet()' is_delete='1' delete_page_url='#request.self#?fuseaction=objects.emptypopup_del_note&note_id=#attributes.note_id#' delete_alert='Kayıtlı Not Siliyorsunuz! Emin misiniz?'>
		</cf_box_footer>
	</cfform>
</cf_box>
<script>
	function notkaydet()
	{
		if(document.all.operation.value=="")
		{
			alert('Operasyon Seçiniz!');
			return false;
		}
		obj=document.all.operation;
		document.all.note_head.value=obj.options[obj.selectedIndex].text;
		document.upd_note.submit();
		return true;
	}
</script>