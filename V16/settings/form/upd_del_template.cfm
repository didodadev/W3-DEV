<cfquery name="TEMPLATES" datasource="#DSN#">
	SELECT 
		IS_PURSUIT_TEMPLATE,
		TEMPLATE_CONTENT,
		TEMPLATE_HEAD,
		TEMPLATE_ID,
		TEMPLATE_MODULE 
	FROM 
		TEMPLATE_FORMS
	ORDER BY 
		TEMPLATE_HEAD	
</cfquery>
<cfquery name="TEMPLATE" datasource="#DSN#">
	SELECT 
		TEMPLATE_MODULE, 
		IS_PURSUIT_TEMPLATE, 
		TEMPLATE_HEAD, 
		IS_LOGO,
		TEMPLATE_CONTENT,
        IS_LICENCE,
		RECORD_EMP,
		RECORD_DATE,
		UPDATE_EMP,
		UPDATE_DATE
	FROM 
		TEMPLATE_FORMS 
	WHERE 
		TEMPLATE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
</cfquery>
<cfquery name="MODULES" datasource="#DSN#">
	SELECT
   		SLT.ITEM_#Ucase(session.ep.language)# AS MODULE,
        WM.MODULE_ID
    FROM
    	WRK_MODULE AS WM
        LEFT JOIN SETUP_LANGUAGE_TR AS SLT ON WM.MODULE_DICTIONARY_ID = SLT.DICTIONARY_ID
</cfquery>

<div class="col col-2 col-md-2 col-sm-2 col-xs-12" type="column" index="1" sort="true">
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='42149.Belge Şablonları'></cfsavecontent>
	<cf_box title="#title#">            
			<ul class="ui-list">
				<cfif TEMPLATES.recordcount>
					<cfoutput query="TEMPLATES">
						<li>
							<a href="#request.self#?fuseaction=settings.form_upd_del_template&id=#template_id#">
								<div class="ui-list-left">
									<span class="ui-list-icon ctl-web-page"></span>
									#template_head#
								</div> 
							</a>
						</li>
					</cfoutput>
				<cfelse>
					<li><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!</font></li>  
				</cfif>
			</ul>            
	</cf_box>
</div>
<div class="col col-10 col-md-10 col-sm-10 col-xs-12">
	<cfsavecontent variable="title">Belge Şablonu Güncelle</cfsavecontent>
	<cf_box title="#title#" add_href="#request.self#?fuseaction=settings.form_add_template&event=add&" is_blank="0">
		<cfform name="template_form" action="#request.self#?fuseaction=settings.emptypopup_template_upd" method="post">
			<input type="hidden" name="template_id" id="template_id" value="<cfoutput>#url.id#</cfoutput>">
			<cf_box_elements>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='34970.Modül'>*</label>
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
							<select name="module" id="module">
								<cfoutput query="modules">
									<option value="#module_id#"<cfif template.template_module eq module_id> selected</cfif>>#MODULE#</option>
								</cfoutput>
							</select>
						</div>
					</div>						
				</div>

				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group col col-4 col-md-4 col-sm-4 col-xs-12" id="item-checkbox">
						<div class="col col-12 col-md-12 col-sm-12 col-xs-12"><label><input type="checkbox" name="is_pursuit_template" id="is_pursuit_template"<cfif template.is_pursuit_template eq 1> checked</cfif>> <cf_get_lang dictionary_id='42824.Takip Şablonu Olarak da Kullan.'></label></div>
					</div>
					<div class="form-group col col-4 col-md-4 col-sm-4 col-xs-12" id="item-checkbox">
						<div class="col col-12 col-md-12 col-sm-12 col-xs-12"><label><input type="checkbox" name="is_logo" id="is_logo"<cfif template.is_logo eq 1> checked</cfif>><cf_get_lang dictionary_id='61298.E-postada Logo Gösterilsin'></label></div>
					</div>
					<div class="form-group col col-4 col-md-4 col-sm-4 col-xs-12" id="item-checkbox">
						<div class="col col-12 col-md-12 col-sm-12 col-xs-12"><label><input type="checkbox" name="is_licence" id="is_licence"<cfif template.is_licence eq 1> checked</cfif>><cf_get_lang dictionary_id='61297.Lisans Sözleşmesi'></label></div>
					</div>
				</div>
			
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="4" sort="true">
					<div class="form-group">							
						<cfsavecontent variable="place"><cf_get_lang dictionary_id='61299.Belge Şablonu Adı'></cfsavecontent>
						<input type="text" name="template_head" id="template_head" placeholder="<cfoutput>#place#</cfoutput>" value="<cfoutput>#template.template_head#</cfoutput>">						
					</div>
				</div>
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="5" sort="true">
					<cfmodule
						template="/fckeditor/fckeditor.cfm"
						toolbarSet="WRKContent"
						basePath="/fckeditor/"
						instanceName="template_content"
						value=""
						width="99%"
						height="350">
				</div>
			</cf_box_elements>				
			<cf_box_footer>
				<cf_record_info query_name="TEMPLATE" record_emp="record_emp" update_emp="update_emp">				
				<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_template_del&template_id=#url.id#' add_function='check()' ><!--- OnFormSubmit()&& --->
			</cf_box_footer>				
		</cfform>
	</cf_box>
</div>

<script type="text/javascript">
	document.getElementById('template_content').value = '<cfoutput>#template.template_content#</cfoutput>';
	function check()
	{
		if (document.getElementById('template_head').value == '')
		{
			alert("\'<cf_get_lang dictionary_id='57631.Ad'>\' <cf_get_lang dictionary_id='43296.alanını boş bırakmamalısınız'>!!");
			return false;
		}
		return true;
	} 
</script>
