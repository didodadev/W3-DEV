<cfsetting showdebugoutput="no">
<!---
Description :
   convert html pages to pdf format
Parameters : none
syntax1 : #request.self#?fuseaction=objects.popup_convertpdf
Note1 : Settle '<!-- sil -->' statement into the start and the end point of unnecessary part of the page
--->
<div id="xxx" style="display:none"></div>
<cfform name="process" action="#request.self#?fuseaction=objects.popup_send_flash_paper_action&notModal=1" method="post">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='32889.Page Engine'></cfsavecontent>
<input type="hidden" name="icerik" id="icerik" value="">
<input type="hidden" name="extra_parameters" id="extra_parameters" value="<cfif isdefined("attributes.extra_parameters")><cfoutput>#attributes.extra_parameters#</cfoutput></cfif>">
<cfif isdefined("attributes.trail") and attributes.trail>
<input type="hidden" name="trail" id="trail" value="1">
<cfelse>
<input type="hidden" name="trail" id="trail" value="0">
</cfif>		
<cfoutput>
	<input type="hidden" name="#listfirst(session.dark_mode,":").trim()#" id="#listfirst(session.dark_mode,":").trim()#" value="#listlast(session.dark_mode,":").trim()#">
</cfoutput>
<cfif isdefined("attributes.print_type") and len(attributes.print_type)	and isdefined("attributes.action_id") and len(attributes.action_id)>
	<input type="hidden" name="action_id" id="action_id" value="<cfoutput>#attributes.action_id#</cfoutput>">
	<input type="hidden" name="print_type" id="print_type" value="<cfoutput>#attributes.print_type#</cfoutput>">
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#message#">
		<cf_box_elements>
			<div class="col col-8 col-md-8 col-sm-12 col-xs-12">
				<div class="form-group">            
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='35948.Döküman Adı'></label> 
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<input type="text" name="name" id="name">
					</div>
				</div>
				<div class="form-group">            
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58067.Döküman Tipi'></label> 
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<select name="sayfa_tipi" id="sayfa_tipi">
							<option value="pdf" <cfif url.ispdf eq 1>selected</cfif>><cf_get_lang dictionary_id='29733.PDF'></option>
							<option value="flashpaper" <cfif url.ispdf eq 0>selected</cfif>><cf_get_lang dictionary_id='60035.Flash Paper'></option>							  							  
						</select>
					</div>						
				</div>
				<div class="form-group">            
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58069.Sayfa Formati'></label> 
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<select name="page_type" id="page_type">
						<option value="A4">A4</option>
						<option value="A5">A5</option>
						<option value="A3">A3</option>
						<option value="B4">B4</option>
						<option value="B5">B5</option>
						<option value="workcubepage">Workcube Page</option>
						</select>
					</div>
				</div>
				<div class="form-group">            
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58070.Layout'></label> 
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<select name="Layout" id="Layout">
							<option value="PORTRAIT">PORTRAIT</option>
							<option value="LANDSCAPE">LANDSCAPE</option>
						</select>
					</div>
				</div>
				<div class="form-group">            
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57696.Yükseklik'></label> 
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<cfsavecontent variable="message5"><cf_get_lang dictionary_id='60036.Lütfen Sayfa Yüksekliğini 3-200 inç Arası Bir Sayi Giriniz'> !</cfsavecontent>
						<cfif isdefined("attributes.page_height")>
							<cfinput type="text" name="page_height" validate="integer" message="#message5#" value="#wrk_round(attributes.page_height,0)#" range="3,5000">
						<cfelse>
							<cfinput type="text" name="page_height" validate="integer" message="#message5#" range="3,200">
						</cfif>
					</div>
				</div>
				<div class="form-group">            
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57695.Genişlik'></label> 
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<cfsavecontent variable="message6"><cf_get_lang dictionary_id='60037.Lütfen Sayfa Genişliğini 3-200 inç Arası Bir Sayi Giriniz'> !</cfsavecontent>
						<cfif isdefined("attributes.page_width")>
							<cfinput type="text" name="page_width" validate="integer" message="#message6#" value="#wrk_round(attributes.page_width,0)#" range="3,5000">
						<cfelse>
							<cfinput type="text" name="page_width" validate="integer" message="#message6#" range="3,200">
						</cfif>
					</div>
				</div>
				<cfif isdefined("is_pdf_header") and is_pdf_header eq 1 and isdefined("session.ep")>
					<div class="form-group">
						<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='60038.PDF te başlık gelsin'><input type="checkbox" name="pdf_header" id="pdf_header" <cfif is_pdf_header eq 1> checked </cfif> /></label>
					</div>
				</cfif>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<cfsavecontent variable="message"><cf_get_lang dictionary_id='58068.Donustur'></cfsavecontent>
			<cf_workcube_buttons is_upd='0' type_format="1" insert_info='#message#' insert_alert='' add_function="kontrol()">
		</cf_box_footer>
	</cf_box>
</div>
</cfform>
<script language="javascript">
function kontrol()
{
/*
	if(document.process.is_related_asset.checked==true && document.process.name.value=="")
		{
		alert('İçeriği Kayıtlı Belge Haline Dönüştürmek İçin İsim Girmelisiniz!');
		return false;
		}
*/
	<cfif isdefined("attributes.isAjaxPage") and attributes.isAjaxPage eq 1>
		process.icerik.value = '<!-- sil -->' + stripScripts(process.icerik.value.replace(/<!-- sil -->/g,'')<cfif isdefined("attributes.noShow") and len(attributes.noShow)>,"<cfoutput>#attributes.noShow#</cfoutput>"</cfif>);
	</cfif>
	return true;
}
	<cfif isdefined("attributes.special_module")>
		if(window.opener.<cfoutput>#attributes.module#</cfoutput>.innerHTML != undefined){
			<cfif isdefined("attributes.extra_parameters") and attributes.extra_parameters eq 'is_puantaj_print'>
				$('#xxx').html( '<!-- sil -->' + window.opener.<cfoutput>#attributes.module#</cfoutput>.innerHTML + '<!-- sil -->'); 
				$("#xxx script").remove();				
				$('#icerik').val($('#xxx').html());
			<cfelse>
				process.icerik.value = '<!-- sil -->' + window.opener.<cfoutput>#attributes.module#</cfoutput>.innerHTML + '<!-- sil -->';
			</cfif>
		}
		else
			{
			process.icerik.value = '<!-- sil -->' + window.opener.window.frames['<cfoutput>#attributes.module#</cfoutput>'].document.getElementById('<cfoutput>#attributes.module#</cfoutput>').innerHTML + '<!-- sil -->';
			}
	<cfelse>
//	if(findObj("<cfoutput>#attributes.module#</cfoutput>",opener.document))
		try
		{
			process.icerik.value = window.opener.<cfoutput>#attributes.module#</cfoutput>.innerHTML;
		}
//	else
		catch(e)
		{
			process.icerik.value = window.opener.document.body.innerHTML;
		}
	</cfif>
</script>
