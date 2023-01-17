
<script type="text/javascript">
	alert("<cf_get_lang dictionary_id='64424.Aksiyon kuralları seçtiğiniz şirketlerde uygulanır'>");
</script>
<cfquery name="GET_OUR_COMPANIES" datasource="#DSN#">
	SELECT
		OUR_COMPANY_INFO.COMP_ID,
		OUR_COMPANY.NICK_NAME		
	FROM 
		OUR_COMPANY,
		OUR_COMPANY_INFO 
	WHERE 
		OUR_COMPANY.COMP_ID = OUR_COMPANY_INFO.COMP_ID AND
		OUR_COMPANY_INFO.WORKCUBE_SECTOR = 'per' AND
		OUR_COMPANY.COMP_ID <> #session.ep.company_id#
</cfquery>
<cfparam name="attributes.modal_id" default="">


<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box id="company_form" title="#iif(isDefined("attributes.draggable"),"getLang('','Şirketler',29531)",DE(''))#" popup_box="#iif(isdefined("attributes.draggable"),DE(1),DE(0))#">
		<cfform name="company_form" action="">
			<cf_box_elements>
				<div class="col col-12 col-md-6 col-sm-6 col-xs-12">
					<div class="form-group" id="item-our_company_id">
						<cfoutput query="get_our_companies">
							<label class="col col-4">#nick_name#</label>
							<div class="col col-8">
								<input type="radio" name="our_company_id" id="our_company_id" value="#comp_id#" checked>
							</div>
						</cfoutput>
					</div>
					<div class="form-group" id="item-copy">
						<cfif get_our_companies.recordcount>
							<cfsavecontent variable="alert"><cf_get_lang dictionary_id='57476.Kopyala'></cfsavecontent>
						<cfelse> 
							<cf_get_lang dictionary_id='57484.Kayıt Yok'> !
						</cfif> 
					</div>
				</div>
			</cf_box_elements>
			<cfif get_our_companies.recordcount>
				<cf_box_footer>
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57476.Kopyala'></cfsavecontent>
					<cf_workcube_buttons type_format='1' is_upd='0' insert_info="#message#" add_function='changeAction()'>
				</cf_box_footer>
			</cfif>
		</cfform>
	</cf_box>
</div>
 
<script type="text/javascript">
	function changeAction()
	{
		<cfif get_our_companies.recordcount gt 1>
			for (i=0; i < <cfoutput>#get_our_companies.recordcount#</cfoutput>; i++)
			{
				if(eval('company_form.our_company_id['+i+'].checked') == true)
				{
					compid = eval('company_form.our_company_id['+i+'].value');
					break;
				}
			}
		<cfelse>
			compid = company_form.our_company_id.value;
		</cfif>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.aksiyon_kopya.compid.value = compid;
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.aksiyon_kopya.action='<cfoutput>#request.self#</cfoutput>?fuseaction=product.form_add_copy_catalog_prom&id=<cfoutput>#attributes.id#</cfoutput>';
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.aksiyon_kopya.submit();
		<cfif isdefined("attributes.draggable")>
			closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
		<cfelse>
			window.close();
		</cfif>
	}
</script>
