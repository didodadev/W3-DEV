<cfparam name="attributes.keyword" default="">
<cfset attributes.catalog_id = attributes.catalog_promotion_id>
<cfinclude template="../query/get_catalog_head.cfm">
<cfinclude template="../query/get_catalog_promotion_pluses.cfm">

<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#GET_CATALOG_PROMOTION_PLUSES.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Tutanaklar','37466')#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform action="#request.self#?fuseaction=product.popup_list_catalog_promotion_pluses" name="form" method="post">
			<cf_box_search>
				<input type="hidden" name="catalog_promotion_id" id="catalog_promotion_id" value="<cfoutput>#attributes.catalog_promotion_id#</cfoutput>">
				<div class="form-group">
					<cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255" placeholder="#getLang('','Filtre',57460)#">
				</div>
				<div class="form-group">
					<div class="input-group small">
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" maxlength="3" placeholder="#getLang('','Sayi_Hatasi_Mesaj',57537)#">
					</div>
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('form' , #attributes.modal_id#)"),DE(""))#">
				</div>
				<div class="form-group">
					<cfoutput><a class="ui-btn ui-btn-gray" href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=product.popup_form_add_catalog_promotion_plus&catalog_promotion_id=#attributes.catalog_promotion_id#','','ui-draggable-box-medium');"><i class="fa fa-plus"></i></a></cfoutput>
				</div>
			</cf_box_search>
		</cfform>
		<cf_flat_list>
			<thead>   
				<tr>
					<th colspan="2">
						<cfoutput>#GET_CATALOG_HEAD.CATALOG_HEAD#</cfoutput>
					</th>
				</tr>
			</thead>
			<cfif GET_CATALOG_PROMOTION_PLUSES.recordcount>
				<cfoutput query="GET_CATALOG_PROMOTION_PLUSES" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tbody>
						<tr>
							<td class="txtboldblue" width="100%">#PLUS_SUBJECT#</td>
							<!-- sil -->
							<td width="15"><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=product.popup_form_upd_catalog_promotion_plus&plus_id=#plus_id#','','ui-draggable-box-medium');"><i class="fa fa-pencil"></i></a></td>
							<!-- sil -->
						</tr>
						<tr>
						<td colspan="2">
								<b><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></b> : #dateformat(record_date,dateformat_style)# &nbsp;&nbsp;&nbsp;
								<b><cf_get_lang dictionary_id='57483.Kayıt'></b> : <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_emp#');" class="tableyazi">#employee_name# #employee_surname#</a>
								<b><cf_get_lang dictionary_id='58090.İletişim Yöntemi'></b> : 
									<cfset attributes.commethod_id = commethod_id>
									<cfinclude template="../query/get_commethod.cfm">
									#GET_COMMETHOD.commethod#
								<br/><br/>
								#plus_content#
							</td>
						</tr>
					</tbody>
				</cfoutput>
			<cfelse>
				<tbody>
					<tr>
						<td colspan="2"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
					</tr>
				</tbody>
			</cfif>
		</cf_flat_list>
		<cf_paging page="#attributes.page#" 
		maxrows="#attributes.maxrows#"
		totalrecords="#attributes.totalrecords#"
		startrow="#attributes.startrow#"
		adres="product.popup_list_catalog_promotion_pluses&keyword=#attributes.keyword#&catalog_promotion_id=#attributes.catalog_promotion_id#">
	</cf_box>
</div>

