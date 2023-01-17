<cfsetting showdebugoutput="no">
<!---
Description :
   convert html pages to xls,do,csv,sxw formats
Parameters : none
syntax1 : #request.self#?fuseaction=objects.popup_documenter
Note1 : Settle '<!-- sil -->' statement into the start and the end point of unnecessary part of the page
--->
<!-- sil -->
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='58066.Dosyaya Dönüştür'></cfsavecontent>
	<cf_box title="#message#">
		<form name="process" action="<cfoutput>#request.self#?fuseaction=objects.emptypopup_get_document&notModal=1</cfoutput>" method="post">
			<cfoutput>
				<input type="hidden" name="#listfirst(session.dark_mode,":").trim()#" id="#listfirst(session.dark_mode,":").trim()#" value="#listlast(session.dark_mode,":").trim()#">
			</cfoutput>
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-12 col-xs-12">
					<textarea name="icerik" id="icerik" style="width:1px;height:1px;display:none;"></textarea>
					<div class="form-group">            
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58067.Döküman Tipi'></label> 
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfloop list="#page_code#" delimiters="&" index="i">
								<cfif listlen(i,'=') gt 1>
									<cfset eleman_2 = ListGetAt(i,2,'=')>
								<cfelse>
									<cfset eleman_2 = "">
								</cfif>
								<cfoutput>
								<input type="hidden" name="#ListGetAt(i,1,'=')#" id="#ListGetAt(i,1,'=')#" value="#eleman_2#">
								</cfoutput>	
							</cfloop>
							<select name="extension" id="extension" >
								<option value="sxw">Open Office(Sxw)</option>
								<option value="sxc">Open Office(Sxc)</option>
								<option value="csv">Open Office(csv)</option>
								<option value="xls">Excel(xls)</option>
								<option value="doc">Word(doc)</option> 
							</select>
						</div>
					</div>
					<div class="form-group">            
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='35948.Döküman Adı'>*</label> 
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<input type="text" name="name" id="name" >
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='58068.Dönüştür'></cfsavecontent>
				<cf_workcube_buttons is_upd='0' is_cancel='0' type_format="1" insert_alert='' is_disable="0" insert_info='#message#' add_function="kontrol()">
			</cf_box_footer>
		</form>
	</cf_box>
</div>
<!-- sil -->
<script language="javascript">
	function kontrol()
	{
		<cfif isdefined("attributes.isAjaxPage") and attributes.isAjaxPage eq 1>
			process.icerik.value = '<!-- sil -->' + stripScripts(process.icerik.value.replace(/<!-- sil -->/g,'')<cfif isdefined("attributes.noShow") and len(attributes.noShow)>,"<cfoutput>#attributes.noShow#</cfoutput>"</cfif>);
		</cfif>
		return true;
	}
	
	<cfif isdefined("attributes.special_module")>
		if(window.opener.<cfoutput>#attributes.module#</cfoutput>.innerHTML != undefined)
		{
			process.icerik.value = '<!-- sil -->' + window.opener.<cfoutput>#attributes.module#</cfoutput>.innerHTML + '<!-- sil -->';
		
		}else
		{
			process.icerik.value = '<!-- sil -->' + window.opener.window.frames['<cfoutput>#attributes.module#</cfoutput>'].document.getElementById('<cfoutput>#attributes.module#</cfoutput>').innerHTML + '<!-- sil -->';
		}
	<cfelse>
	try
	{
		process.icerik.value = window.opener.document.getElementById('<cfoutput>#attributes.module#</cfoutput>').innerHTML;
	}
	catch(e)
	{
		process.icerik.value = window.opener.document.body.innerHTML;
	}
	</cfif>
</script>
