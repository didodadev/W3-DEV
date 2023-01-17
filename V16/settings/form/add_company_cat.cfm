<cfquery name="GET_SITE_MENU" datasource="#DSN#">
	SELECT MENU_ID,SITE_DOMAIN,OUR_COMPANY_ID FROM MAIN_MENU_SETTINGS WHERE SITE_DOMAIN IS NOT NULL
</cfquery>
<cfparam name="is_view" default="">

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='58039.Kurumsal Üye Kategorileri'></cfsavecontent>
	<cf_box title="#head#" add_href="#request.self#?fuseaction=settings.form_add_company_cat" is_blank="0">
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
			<cfinclude template="../display/list_company_cat.cfm">
    	</div>
    	<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
			<cfform action="#request.self#?fuseaction=settings.emptypopup_company_cat_add" method="post" name="company_cat">
			<input type="hidden" name="counter" id="counter">
        		<cf_box_elements>
          			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
						<div class="form-group" id="comp_type">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<input type="radio" name="comp_type" id="comp_type" value="0" checked><cf_get_lang dictionary_id='57457.Müşteri'>
									<input type="radio" name="comp_type" id="comp_type" value="1"><cf_get_lang dictionary_id='29533.Tedarikçi'>					
								</div>	
							</div>
						</div>
						<div class="form-group" id="companyCat">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42003.Kategori Adı'>*</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='58555.Kategori Adı Girmelisiniz'>!</cfsavecontent>
								<cfinput type="Text" name="companyCat" id="companyCat" size="40" value="" maxlength="43" required="Yes" message="#message#">
							</div>
						</div>
						<div class="form-group" id="related_comp">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43477.İlişkili Şirket'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cf_multiselect_check
								name="our_company_ids"
								option_name="nick_name"
								option_value="comp_id"
								table_name="OUR_COMPANY"
								width="180">
							</div>
						</div>
						<div class="form-group" id="detail">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12" style="valign:top"><cf_get_lang dictionary_id='57629.Açıklama'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<textarea name="detail" id="detail" maxlength="100" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="100 Karakterden Fazla Yazmayınız!"></textarea>
							</div>
						</div>
						<div class="form-group" id="is_view">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43339.İnternet ve Extranet'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<input type="Checkbox" name="is_view" id="is_view" value="1" <cfif get_site_menu.recordcount>onClick="gizle_goster(is_site_agenda);"</cfif>> 
								<cf_get_lang dictionary_id='43093.Gözüksün'>
							</div>
						</div>
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<cf_workcube_buttons is_upd='0'  add_function="kontrol()">
				</cf_box_footer>
			</cfform>
				
    	</div>
  	</cf_box>
</div>


<script type="text/javascript">
	function form_kontrol(alan,msg,min_n,max_n)
	{
		if(!checkElementLengthRange(alan, "<cf_get_lang no ='1825.Mesaj bölümüne en fazla 147 karakter girebilirsiniz'>", 1, 147)) return false;
	}
	
	function checkElementLengthRange(target, msg, min_n, max_n) {	
		if (!(target.value.length>=min_n && target.value.length<=max_n))
		{
			alert(msg);
			target.focus();
			return false;
		}
		return true;
	}	
</script>









