<cfparam name="attributes.sal_year" default="#year(now())#">
<cfinclude template="../query/get_ssk_offices.cfm">
<cfscript>
	cmp_zone = createObject("component","V16.hr.cfc.get_zones");
	cmp_zone.dsn = dsn;
	zones = cmp_zone.get_zone();
</cfscript>


  <cf_box>
		<cfform name="employee" method="post">
			<cf_box_search more="0">
				<div class="form-group">
					<select name="zone_id" id="zone_id" style="width:200px;" onChange="get_branch_list(this.value)">
						<option value=""><cf_get_lang dictionary_id="53724.Bölge Seçiniz"></option>
						<cfoutput query="zones">
							<option value="#zone_id#"<cfif isdefined("attributes.zone_id") and (attributes.zone_id eq zone_id)> selected</cfif>>#zone_name#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<select name="ssk_office" id="ssk_office" style="width:200px;">
						<option value=""><cf_get_lang dictionary_id ='57453.Şube'></option>
						<cfoutput query="get_ssk_offices">
							<cfif len(ssk_office) and len(ssk_no)>
								<option value="#ssk_office#-#ssk_no#-#branch_id#">#branch_name#-#ssk_office#-#ssk_no#</option>
							</cfif>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<select name="sal_year" id="sal_year">
						<option value=""><cf_get_lang dictionary_id='58455.Yıl'></option>
						<cfloop from="-3" to="3" index="i">
							<cfoutput><option value="#year(now()) + i#"<cfif attributes.sal_year eq (year(now()) + i)> selected</cfif>>#year(now()) + i#</option></cfoutput>
						</cfloop>
					</select>
				</div>
				<div class="form-group">
					<input type="text" name="hierarchy" id="hierarchy" maxlength="50" value="" style="width:100px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="open_form_ajax()">
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id="54298.AGİ Bordrosu"></cfsavecontent>
		<cf_box title="#message#" uidrop="1">

<cf_basket id="bordro_list_layer"></cf_basket>


		</cf_box>
<script type="text/javascript">
	function open_form_ajax()
	{
		var queryStrings = GetFormData(employee);
		//alert(queryStrings);
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_view_bordro_bread_ajax</cfoutput>&' + queryStrings,'bordro_list_layer',1,'<cf_get_lang dictionary_id ="53721.Bordro Görüntüleniyor">');
	}

	function get_branch_list(gelen)
	{
		document.getElementById('ssk_office').options.length = 0;
		var document_id = document.getElementById('zone_id').options.length;	
		var document_name = '';
		for(i=0;i<document_id;i++)
		{
			if(document.employee.zone_id.options[i].selected && document_name.length==0)
				document_name = document_name + document.employee.zone_id.options[i].value;
			else if(document.employee.zone_id.options[i].selected)
				document_name = document_name + ',' + document.employee.zone_id.options[i].value;
		}

		if (document.employee.zone_id.options[0].selected)
		{
			var get_department_name_ = wrk_query('SELECT BRANCH_NAME, SSK_OFFICE, SSK_NO,BRANCH_ID FROM BRANCH WHERE BRANCH_STATUS = 1','dsn');
			if(get_department_name_.recordcount != 0)
			{
				for(var xx = 0; xx < get_department_name_.recordcount; xx++)
					document.employee.ssk_office.options[xx + 1] = new Option(get_department_name_.BRANCH_NAME[xx], get_department_name_.SSK_OFFICE[xx] + '-' + get_department_name_.SSK_NO[xx]+ '-' + get_department_name_.BRANCH_ID[xx]);
			}
		}

		var get_department_name = wrk_query('SELECT BRANCH_NAME, SSK_OFFICE, SSK_NO,BRANCH_ID FROM BRANCH WHERE BRANCH_STATUS = 1 AND ZONE_ID IN ('+document_name+')','dsn');
		document.employee.ssk_office.options[0] = new Option('<cf_get_lang dictionary_id="57453.Sube">','')
		if(get_department_name.recordcount != 0)
		{
			for(var xx=0;xx<get_department_name.recordcount;xx++)
				document.employee.ssk_office.options[xx+1]=new Option(get_department_name.BRANCH_NAME[xx],get_department_name.SSK_OFFICE[xx] + '-' + get_department_name.SSK_NO[xx]+ '-' + get_department_name.BRANCH_ID[xx]);
			document.employee.ssk_office.options[0].selected = true;
		}
	}
</script>
