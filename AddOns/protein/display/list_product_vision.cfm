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
<cfinclude template="../protein_upper.cfm">
<cfform name="search" action="#request.self#?fuseaction=#url.fuseaction#" method="post">
<input type="hidden" name="is_submit" id="is_submit" value="1">
<cf_big_list_search title="#getLang('product',469)#"> 
	<cf_big_list_search_area>
		<div class="row form-inline">
				<div class="form-group">
						 <div class="input-group">
							<select name="vision_type" id="vision_type" style="width:150px;">
								<option value=""><cfoutput>#getLang('product',469)#</cfoutput></option>
								<cfoutput query="get_vision_type">
									<option value="#vision_type_id#" <cfif isdefined("attributes.vision_type") and (attributes.vision_type eq vision_type_id)>selected</cfif>>#vision_type_name#</option>
								</cfoutput>
							</select>
						</div>
						 <div class="input-group">
							<select name="is_active" id="is_active" style="width:50px;">
								<option value="1"<cfif isDefined("attributes.is_active") and (attributes.is_active eq 1)> selected</cfif>><cf_get_lang_main no='81.Aktif'></option>
								<option value="0"<cfif isDefined("attributes.is_active") and (attributes.is_active eq 0)> selected</cfif>><cf_get_lang_main no='82.Pasif'></option>
								<option value="2"<cfif isDefined("attributes.is_active") and (attributes.is_active eq 2)> selected</cfif>><cf_get_lang_main no='296.Tümü'></option>
							</select>
						</div>
						 <div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang_main no='1333.Başlama Tarihi Girmelisiniz'>!</cfsavecontent>
							<cfinput type="text" name="startdate" value="#dateformat(attributes.startdate,'dd/mm/yyyy')#" style="width:65px;" validate="eurodate" maxlength="10" message="#message#">
							<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
						</div>
						 <div class="input-group">	
							<cfsavecontent variable="message"><cf_get_lang_main no ='327.Bitiş Tarihi Girmelisiniz'>!</cfsavecontent>
							<cfinput type="text" name="finishdate" value="#dateformat(attributes.finishdate,'dd/mm/yyyy')#" style="width:65px;" validate="eurodate" maxlength="10" message="#message#">
							<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
						</div>
						 <div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber(this)" style="width:30px !important;;">
						</div>
						 <div class="input-group">
							<cfsavecontent variable="message_date"><cf_get_lang_main no='370.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
							<cf_wrk_search_button search_function="date_check(search.startdate,search.finishdate,'#message_date#')">
						</div>						
					</div>
				</div>
			
	</cf_big_list_search_area>
</cf_big_list_search> 
</cfform>

<div class="row">
	<div class="col col-12 uniqueRow">
		<div class="col col-12 col-md-12 col-xs-12 col-sm-12">
			<div class="form-group require">
				<table class="cart_summary">
					<thead>
						<tr>
							<th width="25"><cf_get_lang_main no='1165.Sıra'></th>
							<th><cf_get_lang_main no='245.Ürün'></th>
							<th nowrap="nowrap"><cf_get_lang_main no='243.Başlama'></th>
							<th nowrap="nowrap"><cf_get_lang_main no='288.Bitiş'></th>
							<!-- sil --><th class="header_icn_none"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=product.popup_add_product_vision</cfoutput>','medium');"><img src="/images/plus_list.gif" title="<cf_get_lang_main no ='170.Ekle'>"></a></th><!-- sil -->
						</tr>	
					</thead>	
					<tbody>	 
						<cfif GET_VISIONS.recordcount>
							<cfoutput query="GET_VISIONS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
								<tr>
									<td>#currentrow#</td>
									<td><a href="#request.self#?fuseaction=product.list_product&event=det&pid=#product_id#" class="tableyazi">#product_name# #property#</a></td>
									<td>#dateformat(startdate,'dd/mm/yyyy')#</td>
									<td>#dateformat(finishdate,'dd/mm/yyyy')#</td>
									<!-- sil --><td width="15"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=product.popup_upd_product_vision&vision_id=#vision_id#','medium');"><img src="/images/update_list.gif" title="<cf_get_lang_main no ='52.Güncelle'>"></a></td><!-- sil -->
								</tr>
							</cfoutput> 
						<cfelse>
							<tr> 
								<td colspan="5"><cfif isdefined("attributes.is_submit")><cf_get_lang_main no='72.Kayıt Bulunamadı'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz'>!</cfif></td>
							</tr>
						</cfif>
					</tbody>
				</table>
			</div>
		</div>
	</div>
</div>

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
