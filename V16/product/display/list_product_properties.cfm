<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.value_deger" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.modal_id" default="">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfscript>
		get_all_property_action=createobject("component","V16.product.cfc.getAllProperty");
		get_all_property_action.DSN1=#DSN1#;
		get_all_property_action.page=attributes.page;
		get_all_property_action.maxrows=attributes.maxrows;
		GET_PROPERTY_CAT=get_all_property_action.getAllProperty(keyword:attributes.keyword,our_company:session.ep.company_id,is_active:1);
	</cfscript>
<cfif GET_PROPERTY_CAT.recordcount>
	<cfquery name="GET_ALL_PROPERTY_DETAIL" datasource="#DSN1#">
		SELECT
			PRPT_ID,
			PROPERTY_DETAIL
		FROM
			PRODUCT_PROPERTY_DETAIL
		WHERE
			PRPT_ID IN (#valueList(GET_PROPERTY_CAT.property_id)#)
		ORDER BY
			PROPERTY_DETAIL
	</cfquery>
<cfelse>
	<cfset Get_All_Property_Detail.recordcount=0>
</cfif>
<cfparam name="attributes.totalrecords" default='#get_property_cat.query_count#'>
<cfset adres = url.fuseaction>
<cfif isdefined("attributes.property") and len(attributes.property)><cfset adres = '#adres#&property=#attributes.property#'></cfif>
<cfif isdefined("attributes.property_id") and len(attributes.property_id)><cfset adres = '#adres#&property_id=#attributes.property_id#'></cfif>
<cfif isdefined("attributes.record_num_value") and len(attributes.record_num_value)><cfset adres = '#adres#&record_num_value=#attributes.record_num_value#'></cfif>
<cfif isdefined("attributes.ajax_form") and len(attributes.ajax_form)><cfset adres = '#adres#&ajax_form=1'></cfif>
<cfif isdefined("attributes.call_function") and len(attributes.call_function)><cfset adres = '#adres#&call_function=#attributes.call_function#'></cfif>
<cfif isdefined("attributes.call_function_paremeter") and len(attributes.call_function_paremeter)><cfset adres = '#adres#&call_function_paremeter=#attributes.call_function_paremeter#'></cfif>
<cfif isdefined("attributes.form_name") and len(attributes.form_name)><cfset adres = '#adres#&form_name=#attributes.form_name#'></cfif>
<cfset adres = '#adres#&value_deger=#attributes.value_deger#'>

<cf_box title="#getLang('','Özellik',59106)# - #getLang('','Varyasyon',37249)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="search_product" action="#request.self#?fuseaction=#adres#" method="post">
		<cfoutput>#attributes.value_deger#</cfoutput>
		<cf_box_search more="0">
			<!-- sil -->
			<cfif isdefined("attributes.property_id")><input type="hidden" name="property_id" id="property_id" value="<cfoutput>#attributes.property_id#</cfoutput>"></cfif>
			<cfif isdefined("attributes.property")><input type="hidden" name="property" id="property" value="<cfoutput>#attributes.property#</cfoutput>"></cfif>
			<cfif isdefined("attributes.record_num_value")><input type="hidden" name="record_num_value" id="record_num_value" value="<cfoutput>#attributes.record_num_value#</cfoutput>"></cfif>
			<div class="form-group">
				<cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255" placeholder="#getLang('','Filtre',57460)#">
			</div>
			<div class="form-group small">
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
			</div>
			<div class="form-group">
				<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_product' , #attributes.modal_id#)"),DE(""))#">
			</div>
			<!-- sil -->
		</cf_box_search>
	</cfform>
	<cf_grid_list>
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id='57632.Özellik'></th>
				<th><cf_get_lang dictionary_id='37258.Varyasyonlar'></th>
				<th><cf_get_lang dictionary_id='57789.Özel Kod'></th>
				<th width="20"><a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=product.popup_add_property_main</cfoutput>');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='37191.Özellik Ekle'>"></i></a></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_property_cat.recordcount>
			<cfoutput query="get_property_cat">
				<tr>
					<td>
						<cfquery name="GET_ALL_PROPERTY_DETAIL_ROW" dbtype="query">
							SELECT
								PRPT_ID,PROPERTY_DETAIL
							FROM
								GET_ALL_PROPERTY_DETAIL
							WHERE
								PRPT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_property_cat.property_id#">
						</cfquery>
						<cfif isdefined("attributes.record_num_value")>
						<a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=product.emptypopup_add_product_property_row<cfif isdefined("form_name")>&form_name=#attributes.form_name#</cfif>&record_num_value=#attributes.record_num_value#&property_id=#get_property_cat.property_id#&property=#property#&back_modal_id=#attributes.modal_id#')">#property#</a>
						<cfelse>
							<a href="javascript://" onclick="add_property('#property#','#property_ID#');" class="tableyazi">#property#</a>
						</cfif>
					</td>
					<td><cfloop query="Get_All_Property_Detail_Row">#property_detail#<cfif not currentrow eq recordcount>,</cfif> </cfloop></td>
					<td>#property_code#</td>
					<td width="10"><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=product.popup_add_property&prpt_id=#get_property_cat.property_ID#&property=#get_property_cat.property#');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='37203.Özelliğe Varyasyon Ekle'>"></i></a></td>
				</tr>
			</cfoutput>
			<cfelse>
				<tr>
					<td colspan="4"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
	<cfif attributes.totalrecords gt attributes.maxrows>
		<cfif len(attributes.keyword)><cfset adres = '#adres#&keyword=#attributes.keyword#'></cfif>
		<cf_paging page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="#adres#" isAjax="#iif(isdefined("attributes.draggable"),1,0)#">		
	</cfif>
</cf_box>

<script type="text/javascript">
	document.search_product.keyword.focus();
	function add_property(property,property_id)
	{
		<cfoutput>
			<cfif isdefined('attributes.ajax_form')><!--- ajax_form ise form adı olmaksızın veri opener sayfaya gönderilir!--->
				<cfif isdefined("attributes.property")>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('#attributes.property#').value =property ;
				</cfif>
				<cfif isdefined("attributes.property_id")>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('#attributes.property_id#').value =property_id ;
				</cfif>
			<cfelse>
				<cfif isdefined("attributes.property")>
					<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.#attributes.property#.value = property ;
				</cfif>
				<cfif isdefined("attributes.property_id")>
					<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.#attributes.property_id#.value = property_id ;
				</cfif>
			</cfif>
			<cfif isdefined('attributes.call_function')>
				<cfif not isdefined("attributes.draggable")>window.opener.</cfif>#attributes.call_function#(<cfif isdefined('attributes.call_function_paremeter')>#attributes.call_function_paremeter#</cfif>);
			</cfif>
		</cfoutput>
		//<cfif not isdefined("attributes.draggable")>window.opener.</cfif>fillVariation('<cfoutput>#attributes.value_deger#</cfoutput>');
		<cfif not isdefined("attributes.draggable")>
			window.close();
		<cfelse>
			closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
		</cfif>
	}
</script>
