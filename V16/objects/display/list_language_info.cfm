<cfsetting showdebugoutput="no">
<cfquery name="get_langs" datasource="#dsn#">
	SELECT LANGUAGE_SHORT,LANGUAGE_SET FROM SETUP_LANGUAGE
</cfquery>
<cfquery name="get_default_value" datasource="#attributes.d_alias#">
	SELECT #attributes.c_name# AS D_VALUE FROM #attributes.t_name# WHERE #attributes.c_id# = #attributes.c_id_value#
</cfquery>
<cfquery name="get_language_sets" datasource="#DSN#">
	SELECT
		ITEM,
		LANGUAGE
	FROM 
		SETUP_LANGUAGE_INFO
	WHERE
		<cfif attributes.c_type eq 1>
			COMPANY_ID = #session.ep.company_id# AND
		<cfelseif  attributes.c_type eq 2>
			PERIOD_ID = #session.ep.period_id# AND
		</cfif>
		UNIQUE_COLUMN_ID = #attributes.c_id_value# AND
		COLUMN_NAME = '#attributes.c_name#' AND
		TABLE_NAME = '#attributes.t_name#'	
</cfquery>
<cfoutput query="get_language_sets">
	<cfset 'define_lang_#LANGUAGE#' = ITEM>
</cfoutput>
<div class="col col-12 col-xs-12">
<cfform id="form_lang_info" name="form_lang_info" action="#request.self#?fuseaction=objects.emptypopup_language_info">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='29526.Kelime Ekle'></cfsavecontent>
<cf_box title="#message#" popup_box="1">
		<input type="hidden" name="c_name" id="c_name" value="<cfoutput>#attributes.c_name#</cfoutput>">
		<input type="hidden" name="c_id_value" id="c_id_value" value="<cfoutput>#attributes.c_id_value#</cfoutput>" />
		<input type="hidden" name="t_name" id="t_name" value="<cfoutput>#attributes.t_name#</cfoutput>"/>
		<input type="hidden" name="d_alias" id="d_alias" value="<cfoutput>#attributes.d_alias#</cfoutput>"/>
		<input type="hidden" name="c_id" id="c_id" value="<cfoutput>#attributes.c_id#</cfoutput>"/>
		<input type="hidden" name="c_type" id="c_type" value="<cfoutput>#attributes.c_type#</cfoutput>"/>
		<cfsavecontent variable="msg"><cf_get_lang dictionary_id="29484.Fazla karakter sayıısı"></cfsavecontent>
		<cf_box_elements>
 			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
			<cfloop query="get_langs">
				<div class="form-group" id="item-process_cat">
                    <label class="col col-4 col-xs-12"><cfoutput>#LANGUAGE_SET#</cfoutput></label>
                    <div class="col col-8 col-xs-12">
                        <cfif attributes.input_type is 'text'>
							<cfif get_language_sets.recordcount and isdefined("define_lang_#language_short#")>
								<cfset item_ = evaluate("define_lang_#language_short#")>
							<cfelse>
								<cfset item_ = "">
							</cfif>
							<cfif session.ep.language is language_short and not get_language_sets.recordCount>
								<cfoutput><cfsavecontent variable="deger">#get_default_value.D_VALUE#</cfsavecontent></cfoutput>
							<cfelse>
								<cfoutput><cfsavecontent variable="deger"><cfif isdefined("define_lang_#language_short#")>#item_#</cfif></cfsavecontent></cfoutput>
							</cfif>
								<cfoutput><input type="text" value="#deger#"  name="deger_#language_short#" id="deger_#language_short#" message="#msg#" maxlength="#attributes.maxlength#" style="width:150px;"></cfoutput>
							<cfelseif attributes.input_type is 'textarea'>
							<cfoutput>
								<textarea maxlength="<cfoutput>#attributes.maxlength#</cfoutput>" onkeyup="return ismaxlength(this);" onblur="return ismaxlength(this);" message="<cfoutput>#msg#</cfoutput>" <cfif lang_list is language_short>readonly="readonly"</cfif> name="deger_#language_short#" id="deger_#language_short#" style="width:150px;"><cfif lang_list is language_short>#get_default_value.D_VALUE#<cfelse><cfif isdefined('define_lang_#language_short#')>#evaluate('define_lang_#language_short#')#</cfif></cfif></textarea>
							</cfoutput>
						</cfif>
                    </div>
                </div>
			</cfloop> 
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<cf_workcube_buttons is_cancel="0" is_upd="1" is_del="1" delete_page_url="#request.self#?fuseaction=objects.emptypopup_del_language_info&c_type=#attributes.c_type#&c_id_value=#attributes.c_id_value#&c_name=#attributes.c_name#&t_name=#attributes.t_name#">
		</cf_box_footer>	
</cf_box>
</cfform>
</div>
