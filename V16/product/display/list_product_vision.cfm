<cfif not isdefined("attributes.startdate")>
	<cfset base_date = createdate(year(now()),month(now()),day(now()))>
	<cfset attributes.startdate = date_add("ww",-2,base_date)>
	<cfset attributes.finishdate = date_add("ww",2,base_date)>
</cfif>
<cfparam name="attributes.keyword" default="">
<cfset adres = url.fuseaction>
<cfset adres = "#adres#&is_submit=1">
<cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>
	<cfset adres = "#adres#&startdate=#attributes.startdate#">
</cfif>
<cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
	<cfset adres = "#adres#&finishdate=#attributes.finishdate#">
</cfif>
<cfif isdefined("attributes.is_active") and isdate(attributes.is_active)>
	<cfset adres = "#adres#&is_active=#attributes.is_active#">
</cfif>
<cfif isdefined("attributes.vision_type") and isdate(attributes.vision_type)>
	<cfset adres = "#adres#&vision_type=#attributes.vision_type#">
</cfif>

<cfif isdefined("attributes.is_submit")>
<cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>
	<cf_date tarih = "attributes.startdate">
</cfif>
<cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
	<cf_date tarih = "attributes.finishdate">
</cfif>
<cfquery name="GET_VISIONS" datasource="#dsn3#">
	SELECT 
		PV.*,
		S.PRODUCT_NAME,
		S.PROPERTY
	FROM 
		PRODUCT_VISION PV,
		STOCKS S
	WHERE 
		S.PRODUCT_NAME LIKE '%#attributes.keyword#%' AND
		S.PRODUCT_ID = PV.PRODUCT_ID AND
		S.STOCK_ID = PV.STOCK_ID
		<cfif isDefined("attributes.vision_type") and len(attributes.vision_type)>
			AND PV.VISION_TYPE LIKE '%#attributes.vision_type#%' 
		</cfif>
		<cfif (isDefined("attributes.is_active") and (attributes.is_active neq 2))>
			AND IS_ACTIVE = #attributes.is_active# 
		</cfif>
		<cfif len(attributes.startdate) and not len(attributes.finishdate)>
			AND FINISHDATE >= #attributes.startdate#
		<cfelseif len(attributes.finishdate) and not len(attributes.startdate)>
			AND STARTDATE <= #attributes.finishdate#
		<cfelseif len(attributes.startdate) and len(attributes.finishdate)>
			AND STARTDATE <= #attributes.finishdate# AND FINISHDATE >= #attributes.startdate#
		</cfif>
	ORDER BY PV.RECORD_DATE DESC
</cfquery>
<cfelse>
	<cfset GET_VISIONS.recordcount = 0>
</cfif>
<cfquery name="get_vision_type" datasource="#dsn#">
	SELECT VISION_TYPE_ID,VISION_TYPE_NAME FROM SETUP_VISION_TYPE
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#GET_VISIONS.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="search" action="#request.self#?fuseaction=#url.fuseaction#" method="post">
<input type="hidden" name="is_submit" id="is_submit" value="1">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='37480.Vitrin'></cfsavecontent>
<cf_big_list_search title="#message#"> 
	<cf_big_list_search_area>
		<table>
			<tr>
				<td><cf_get_lang dictionary_id='57460.Filtre'></td>
				<td><cfinput type="text" name="keyword" id="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="50"></td>
				<td>
					<select name="vision_type" id="vision_type" style="width:150px;">
						<option value=""><cf_get_lang dictionary_id='37480.Vitrin'> <cf_get_lang dictionary_id='37165.Tipi'></option>
						<cfoutput query="get_vision_type">
							<option value="#vision_type_id#" <cfif isdefined("attributes.vision_type") and (attributes.vision_type eq vision_type_id)>selected</cfif>>#vision_type_name#</option>
						</cfoutput>
					</select>
				</td>
				<td>
					<select name="is_active" id="is_active" style="width:50px;">
						<option value="1"<cfif isDefined("attributes.is_active") and (attributes.is_active eq 1)> selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
						<option value="0"<cfif isDefined("attributes.is_active") and (attributes.is_active eq 0)> selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
						<option value="2"<cfif isDefined("attributes.is_active") and (attributes.is_active eq 2)> selected</cfif>><cf_get_lang dictionary_id='57708.T??m??'></option>
					</select>
				</td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='58745.Ba??lama Tarihi Girmelisiniz'>!</cfsavecontent>
					<cfinput type="text" name="startdate" value="#dateformat(attributes.startdate,dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10" message="#message#">
					<cf_wrk_date_image date_field="startdate">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Biti?? Tarihi Girmelisiniz'>!</cfsavecontent>
					<cfinput type="text" name="finishdate" value="#dateformat(attributes.finishdate,dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10" message="#message#">
					<cf_wrk_date_image date_field="finishdate">
				</td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber(this)" style="width:25px;">
				</td>
				<td>
					<cfsavecontent variable="message_date"><cf_get_lang dictionary_id='57782.Tarih De??erini Kontrol Ediniz'>!</cfsavecontent>
					<cf_wrk_search_button search_function="date_check(search.startdate,search.finishdate,'#message_date#')">
				</td>
			</tr>
		</table>
	</cf_big_list_search_area>
</cf_big_list_search> 
</cfform>
<cf_big_list>
	<thead>
		<tr>
			<th width="25"><cf_get_lang dictionary_id='58577.S??ra'></th>
			<th><cf_get_lang dictionary_id='57657.??r??n'></th>
			<th nowrap="nowrap"><cf_get_lang dictionary_id='57655.Ba??lama'></th>
			<th nowrap="nowrap"><cf_get_lang dictionary_id='57700.Biti??'></th>
			<!-- sil --><th class="header_icn_none"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=product.popup_add_product_vision</cfoutput>','medium');"><img src="/images/plus_list.gif" title="<cf_get_lang dictionary_id='57582.Ekle'>"></a></th><!-- sil -->
		</tr>	
	</thead>	
	<tbody>	 
		<cfif GET_VISIONS.recordcount>
			<cfoutput query="GET_VISIONS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
				<tr>
					<td>#currentrow#</td>
					<td><a href="#request.self#?fuseaction=product.list_product&event=det&pid=#product_id#" class="tableyazi">#product_name# #property#</a></td>
					<td>#dateformat(startdate,dateformat_style)#</td>
					<td>#dateformat(finishdate,dateformat_style)#</td>
					<!-- sil --><td width="15"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=product.popup_upd_product_vision&vision_id=#vision_id#','medium');"><img src="/images/update_list.gif" title="<cf_get_lang dictionary_id='57464.G??ncelle'>"></a></td><!-- sil -->
				</tr>
			</cfoutput> 
		<cfelse>
			<tr> 
				<td colspan="5"><cfif isdefined("attributes.is_submit")><cf_get_lang dictionary_id='57484.Kay??t Bulunamad??'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
			</tr>
		</cfif>
	</tbody>
</cf_big_list>
<cfif isdefined("keyword") and len(attributes.keyword)>
	<cfset adres = '#adres#&keyword=#attributes.keyword#'>
</cfif>
<cf_paging page="#attributes.page#" 
    maxrows="#attributes.maxrows#"
    totalrecords="#attributes.totalrecords#"
    startrow="#attributes.startrow#"
    adres="#adres#">
<script type="text/javascript">
	$('#keyword').focus();
	//document.getElementById('keyword').focus();
</script>
