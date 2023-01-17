<cfset cfc=createObject("component","V16.objects.cfc.recycle_group")> 
<cfset url_string = "">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.modal_id" default="">
<cfif isdefined("attributes.field_id")>
	<cfset url_string = "#url_string#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.field_main_id")>
	<cfset url_string = "#url_string#&field_main_id=#attributes.field_main_id#">
</cfif>
<cfif isdefined("attributes.field_name")>
	<cfset url_string = "#url_string#&field_name=#attributes.field_name#">
</cfif>
<cfif isdefined("attributes.field_code")>
	<cfset url_string = "#url_string#&field_code=#attributes.field_code#">
</cfif>
<cfset adres = "">
<cfif len(attributes.keyword)>
	<cfset adres = "#adres#&draggable=1&keyword=#attributes.keyword#">
</cfif>
<cfset get_recycle_group=cfc.get_recycle_group(keyword:attributes.keyword)>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_recycle_group.recordCount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>	
<script type="text/javascript">
	function add_store(recycle_group_id,recycle_group,recycle_group_main_id,recycle_group_code)
	{
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value = recycle_group_id;
		<cfif isdefined("attributes.field_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value = recycle_group;
		</cfif>
        <cfif isdefined("attributes.field_main_id")>
            <cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.field_main_id#</cfoutput>.value = recycle_group_main_id;
        </cfif>
		<cfif isdefined("attributes.field_code")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.field_code#</cfoutput>.value = recycle_group_code;
		</cfif>
		<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	}
</script>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='1002.Geri Kazanım Grupları'></cfsavecontent>
<div class="col col-12 col-xs-12">
	<cf_box title="#message#" scroll="0" collapsable="1" resize="1"  popup_box="#iif(isdefined("attributes.draggable"),1,0)#">			
		<cfform name="recycle_group" action="#request.self#?fuseaction=objects.popup_list_recycle_group#url_string#" method="post">
			<cf_box_search>
				<div class="form-group" id="keyword">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" placeholder="#message#" style="width:100px;" value="#attributes.keyword#">
				</div>		
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" onKeyUp="isNumber(this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('recycle_group' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
		</cfform>
		<cf_flat_list>
			<thead>
				<tr> 
					<th><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='58585.Kod'></th>
					<th><cf_get_lang dictionary_id='65342.Geri Kazanım Grubu'></th>
					<th><cf_get_lang dictionary_id='65343.Geri Kazanım Ana Grup'></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_recycle_group.recordcount>
				<cfoutput query="get_recycle_group" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td>#currentrow#</td>
                    <td>#RECYCLE_SUB_GROUP_CODE#</td>
					<td><a href="javascript://" onClick="add_store('#SUB_GROUP_ID#','#RECYCLE_SUB_GROUP#','#MAIN_GROUP_ID#','#RECYCLE_SUB_GROUP_CODE#')" class="tableyazi">#RECYCLE_SUB_GROUP#</a></td>
					<td>#MAIN_GROUP#</td>
				</tr>
				</cfoutput>
				<cfelse>
					<tr>
						<td colspan="2"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
					</tr>
				</cfif>
			</tbody>
		</cf_flat_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
            <cf_paging
					page="#attributes.page#"
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="objects.popup_list_recycle_group#adres##url_string#"
					isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
		</cfif>
	</cf_box>
</div>
