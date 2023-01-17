<cfsetting showdebugoutput="no">
<cfquery name="get_list_items" datasource="#attributes.datasource#">
	SELECT
		#attributes.TABLE_NAME#.#attributes.wrk_list_object_id#,
		#attributes.TABLE_NAME#.#attributes.wrk_list_object_name#
	FROM
		#attributes.TABLE_NAME#
        <cfif isdefined("attributes.comp") and attributes.comp eq 1>
        ,PRODUCT_BRANDS_OUR_COMPANY AS PBOC
        </cfif>
	<cfif isdefined("attributes.comp") and attributes.comp eq 1>
    WHERE
    	PBOC.BRAND_ID = #attributes.TABLE_NAME#.#attributes.wrk_list_object_id#
        AND PBOC.OUR_COMPANY_ID = #session.ep.company_id#
    </cfif>
	ORDER BY
		 #attributes.wrk_list_object_name#
</cfquery>
<cfparam name="attributes.id" default="wrkdepartmentlocation_#round(rand()*10000000)#">
<cfsavecontent variable="message"><cfoutput>#attributes.header_name#</cfoutput></cfsavecontent>
<cf_box id="#attributes.wrk_list_object_id#_#attributes.wrk_list_object_name#" title="#message#" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#"> 
    <div>
		<cf_ajax_list>
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id='57487.No'></th>
					<th width="102"><cfoutput>#attributes.sub_header_name#</cfoutput></th>
					<th width="50"><input type="checkbox" name="all_checked" id="all_checked_<cfoutput>#attributes.id#</cfoutput>" value="1" onClick="all_select_<cfoutput>#attributes.id#</cfoutput>();" title="Hepsi"></th>
				</tr>
			</thead>
			<tbody>
				<cfoutput query="get_list_items">
					<tr>
						<td width="20">#currentrow#</td>
						<td width="102">#Evaluate('#attributes.wrk_list_object_name#')#</td>
						<td>
							<input type="checkbox" name="list_area_name_#attributes.sub_header_name#" id="list_area_name_#attributes.sub_header_name#"  value="#Evaluate('#attributes.wrk_list_object_name#')#" <cfif listfindnocase(attributes.selected,Evaluate('#attributes.wrk_list_object_name#'))>checked</cfif>><!--- <cfif listfind(attributes.id_list,brand_id)> checked </cfif> --->
							<input type="hidden" name="list_area_id_#attributes.sub_header_name#" id="list_area_id_#attributes.sub_header_name#" value="#Evaluate('#attributes.wrk_list_object_id#')#" >
						</td>
					</tr>
				</cfoutput>
			</tbody>    
		</cf_ajax_list>
	</div>
	<cf_box_footer>
		<input type="button" value="<cf_get_lang dictionary_id ='57582.Ekle'>" onClick="add_new_items();">
	</cf_box_footer>
</cf_box>
<cfoutput>
<script type="text/javascript">
function add_new_items()
{ 
	var _fiel_id_list_ ='';
	var _field_name_list_ ='';		

	if(document.getElementsByName('list_area_name_#attributes.sub_header_name#').length >=1)
	{
		for(i=0;i<=document.getElementsByName('list_area_name_#attributes.sub_header_name#').length-1;i++) 
		{
			if (document.getElementsByName('list_area_name_#attributes.sub_header_name#')[i].checked == true)
			{
				 _fiel_id_list_ += document.getElementsByName('list_area_id_#attributes.sub_header_name#')[i].value + ',';
				 _field_name_list_ += document.getElementsByName('list_area_name_#attributes.sub_header_name#')[i].value + ','; 
			}
			/*else if(document.all.all_checked.checked == true)
			{
				 _fiel_id_list_ += document.all.list_area_id[i].value + ',';
				 _field_name_list_ += document.all.list_area_name[i].value + ','; 
			}*/
		}
	}
	else
	{
		if (document.getElementsByName('list_area_name').checked == true)
		{
			 _fiel_id_list_ += document.getElementsByName('list_area_id_#attributes.sub_header_name#').value + ',';
			 _field_name_list_ += document.getElementsByName('list_area_name_#attributes.sub_header_name#').value + ','; 
		}
	}
	_fiel_id_list_ = _fiel_id_list_.substr(0,_fiel_id_list_.length-1);
	_field_name_list_ = _field_name_list_.substr(0,_field_name_list_.length-1);
	//document.getElementById('brand_id').value =_fiel_id_list_;
	document.getElementById('#attributes.wrk_list_object_name#').value = _field_name_list_;
	document.getElementById('#attributes.wrk_list_object_id#').value = _fiel_id_list_;
	document.getElementById('#attributes.wrk_list_object_id#_#attributes.wrk_list_object_name#').style.display ='none';
	closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>');
}
function all_select_#attributes.id#()
{
	if (document.getElementById('all_checked_#attributes.id#').checked)
		{
			for(say=0;say<#get_list_items.recordcount#;say++)
			document.getElementsByName('list_area_name_#attributes.sub_header_name#')[say].checked = true;
		}
	else 
		{
			for(say=0;say<#get_list_items.recordcount#;say++)
			document.getElementsByName('list_area_name_#attributes.sub_header_name#')[say].checked = false;
		}
}
</script>
</cfoutput>
<cfabort><!--- Bu abort'u kaldırmaın,autocomplete kullanılan sayfalarda sorun çıkarmaması için eklendi! --->
