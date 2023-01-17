<cfsavecontent variable="title"><cf_get_lang dictionary_id='58006.Rapor Sakla'></cfsavecontent>
<cfparam name="attributes.modal_id" default="">
<cf_box title="#title#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform action="#request.self#?fuseaction=report.emptypopup_add_saved_report" method="post" name="add_report" >
		<cfloop list="#page_code#" delimiters="&" index="i">
			<cfif listlen(i,'=') gt 1>
				<cfset eleman_2 = ListGetAt(i,2,'=')>
			<cfelse>
				<cfset eleman_2 = "">
			</cfif>
			<cfif not (ListGetAt(i,1,'=') is "maxrows")>
				<cfoutput>
					<input type="hidden" name="#ListGetAt(i,1,'=')#" id="#ListGetAt(i,1,'=')#" value="#eleman_2#">
				</cfoutput>
			</cfif>
		</cfloop>
		<input type="hidden" name="count" id="count" value="">		
		<cf_box_elements vertical="1">
				<div class="form-group">            
					<label class="col col-12 col-xs-3"><cf_get_lang dictionary_id='57434.Rapor'></label> 
					<div class="col col-12 col-xs-7">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='38811.Rapor Adı girmelisiniz'></cfsavecontent>
						<cfinput type="text" name="Report_Name" required="yes" message="#message#" maxlength="100">
					</div>
				</div>
				<div class="form-group">            
					<label class="col col-12 col-xs-3"><cf_get_lang dictionary_id='58829.Kayıt Sayısı'></label> 
					<div class="col col-12 col-xs-7">
						<select name="maxrows" id="maxrows">
						<cfoutput>
							<option value="<cfif isdefined("attributes.maxrows")>#attributes.maxrows#<cfelse>#session.ep.maxrows#</cfif>"><cfif isdefined("attributes.maxrows")>#attributes.maxrows#<cfelse>#session.ep.maxrows#</cfif></option>
						</cfoutput>
						<option value="9999999"><cf_get_lang dictionary_id='57708.Tümü'></option>
						</select>
					</div>
				</div>
				<div class="form-group">            
					<label class="col col-12 col-xs-3"><cf_get_lang dictionary_id='57629.Açıklama'></label> 
					<div class="col col-12 col-xs-7">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
						<textarea name="report_detail" id="report_detail" maxlength="250" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea>
					</div>
				</div>
			</cf_box_elements>
		<cf_box_footer>
			<cf_workcube_buttons is_upd='0' add_function="control()&&loadPopupBox('add_report')">
		</cf_box_footer>		
	</cfform>
</cf_box>
<script>
	function control() {		
		$("#report_part script").remove();
		//console.log($("#report_part").html());
		document.getElementById('count').value =  $("#report_part").html();
		loadPopupBox('add_report' , <cfoutput>#attributes.modal_id#</cfoutput>);
	}		
</script>