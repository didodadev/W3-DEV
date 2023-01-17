<cf_get_lang_set module_name="hr"><!--- sayfanin en altinda kapanisi var --->
<cfparam name="attributes.keyword" default="">
<cfset url_list="">

<cfif isdefined("attributes.field_name")>
	<cfset url_list = "&field_name=#attributes.field_name#">
</cfif>
<cfif isdefined("attributes.field_id")>
	<cfset url_list = url_list & "&field_id=#attributes.field_id#">
</cfif>

<cfinclude template="../query/get_position_names.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_pos_name.recordcount#>
<cfparam name="attributes.empty_pos" default = 0><!--- Boş pozisyonlar selecti --->
<cfif isdefined("attributes.empty_pos")>
	<cfset url_list = url_list & "&empty_pos=#attributes.empty_pos#">
</cfif>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.attributes_json")>
    <cfset deserialize_atributes = DeserializeJSON(URLDecode(attributes.ATTRIBUTES_JSON))>
    <cfset StructAppend(attributes,deserialize_atributes,true)>
</cfif>
<cfset attributes_json = Replace(SerializeJSON(attributes),"//","")>
<cf_box title="#getLang('','Pozisyon Adları',55479)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform action="#request.self#?fuseaction=#fusebox.circuit#.popup_list_position_names#url_list#" method="post" name="position_names_search">
		<cf_box_search>
			<div class="form-group" id="keyword">
				<cfinput type="text" name="keyword" placeholder="#getLang('','Filtre',57460)#" value="#attributes.keyword#" maxlength="255">
			</div>	
			<div class="form-group small">
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
			</div>
			<cfif attributes.empty_pos eq 1>
				<div class="form-group small">
					<select name="empty_position" onChange="<cfif isdefined("attributes.draggable")>openBoxDraggable(this.value,#attributes.modal_id#);<cfelse>location.href=this.value;</cfif>">
						<option value="<cfoutput>#request.self#?fuseaction=hr.popup_list_position_names&attributes_json=#URLEncodedFormat(attributes_json)#</cfoutput>"><cf_get_lang dictionary_id='32229.Pozisyon Adları'></option>
						<option value="<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&attributes_json=#URLEncodedFormat(attributes_json)#&show_empty_pos=1&select_list=1,9</cfoutput>"><cf_get_lang dictionary_id='55587.Boş Pozisyonlar'></option>
					</select>
				</div>
			</cfif>
			<div class="form-group">
				<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('position_names_search' , #attributes.modal_id#)"),DE(""))#">
			</div>
		</cf_box_search>
	</cfform>
	<cf_grid_list>
		<thead>
			<tr>
				<th width="30"><cf_get_lang dictionary_id='57487.No'></th>
				<th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_pos_name.recordcount>
				<cfoutput query="get_pos_name" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td>#currentrow#</td>
						<td><a href="javascript://" onClick="add_name('#POSITION_NAME#','#POS_NAME_ID#');">#POSITION_NAME#</a></td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr class="color-row" height="20">
					<td colspan="2"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
	<cfif attributes.totalrecords gt attributes.maxrows>
		<cfif len(attributes.keyword)>
			<cfset url_list = url_list & "&keyword=#attributes.keyword#">
		</cfif>
		<cf_paging
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#"
			adres="hr.popup_list_position_names#url_list#"
			isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
	</cfif>
	
</cf_box>

<script type="text/javascript">
	document.position_names_search.keyword.select();
	function add_name(deger, id)
	{
		<cfif isdefined("attributes.field_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value=deger;
		</cfif>
		<cfif isdefined("attributes.field_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value=id;
		</cfif>
		<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
