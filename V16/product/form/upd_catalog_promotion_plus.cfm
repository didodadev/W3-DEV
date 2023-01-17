<CFQUERY name="GET_CATALOG_PROMOTION_PLUS" datasource="#DSN3#">
	SELECT 
		CPP.*,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME 
	FROM 
		CATALOG_PROMOTION_PLUS CPP,
		#dsn_alias#.EMPLOYEES E
	WHERE 
		CPP.PLUS_ID = #ATTRIBUTES.PLUS_ID#
		AND
		E.EMPLOYEE_ID = CPP.RECORD_EMP
</CFQUERY>
<cfset attributes.catalog_id = GET_CATALOG_PROMOTION_PLUS.catalog_promotion_id>
<cfinclude template="../query/get_catalog_head.cfm">
<cfinclude template="../query/get_commethod_cats.cfm">
<cfparam name="attributes.modal_id" default="">
<!---<cfsavecontent variable="right_">
	<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=product.popup_form_add_catalog_promotion_plus&catalog_promotion_id=#attributes.catalog_id#</cfoutput>','page');"><img src="/images/plus1.gif" title="<cf_get_lang dictionary_id='57582.Ekle'>"></a>
</cfsavecontent>--->
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box id="add_plus" title="#iif(isDefined("attributes.draggable"),"getLang('','Tutanak',39486)",DE(''))#" popup_box="#iif(isdefined("attributes.draggable"),DE(1),DE(0))#">
		<cfform name="add_plus" method="post" action="#request.self#?fuseaction=product.emptypopup_upd_catalog_promotion_plus">
			<input type="hidden" name="plus_id" id="plus_id" value="<cfoutput>#attributes.plus_id#</cfoutput>">
			<cf_box_elements>
				<div class="col col-12 col-md-6 col-sm-6 col-xs-12">
					<div class="form-group" id="item-commethod_id">
						<label class="col col-4"><cf_get_lang dictionary_id='58090.İletişim Yöntemi'></label>
						<div class="col col-8">
							<select name="commethod_id" id="commethod_id" >
								<option value="0"><cf_get_lang dictionary_id='58090.İletişim Yöntemi'></option>
								<cfoutput query="get_commethod_cats">
								  <option value="#commethod_id#" <cfif commethod_id eq GET_CATALOG_PROMOTION_PLUS.commethod_id>selected</cfif>>#commethod#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-plus_date">
						<label class="col col-4"><cf_get_lang dictionary_id='57742.Tarihi'></label>
						<div class="col col-8">
							<div class="input-group">
								<cfinput required="Yes" validate="#validate_style#" message="#getLang('','Lutfen Tarih Giriniz',58503)#" type="text" name="plus_date" maxlength="10" value="#dateformat(GET_CATALOG_PROMOTION_PLUS.plus_date,dateformat_style)#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="plus_date"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-plus_subject">
						<label class="col col-4"><cf_get_lang dictionary_id='57480.Başlık'></label>
						<div class="col col-8">
							<cfinput type="text" name="plus_subject" value="#GET_CATALOG_PROMOTION_PLUS.plus_subject#" maxlength="250">
						</div>
					</div>
					<div class="form-group">
						<cfmodule
							template="/fckeditor/fckeditor.cfm"
							toolbarSet="WRKContent"
							basePath="/fckeditor/"
							instanceName="plus_content"
							valign="top"
							value="#GET_CATALOG_PROMOTION_PLUS.plus_content#"
							width="545"
							height="320">
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_record_info query_name="GET_CATALOG_PROMOTION_PLUS">
				<cf_workcube_buttons is_upd='0' button_type="1" add_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('add_plus' , #attributes.modal_id#)"),DE(""))#">
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
           
