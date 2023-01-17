<!--- Üretim Sonuçları --->
<cfset fuseaction_ = ListGetAt(attributes.fuseaction,2,'.')>
<cfset fuseaction_ = replace(fuseaction_,'emptypopup_','')>
<cfparam name="authority_station_id_list" default="0">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.page" default=1>
<cfif len(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
</cfif>
<cfif len(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
</cfif>
<cfif not (isDefined('attributes.maxrows') and isNumeric(attributes.maxrows))>
  <cfset attributes.maxrows = session.ep.maxrows>
</cfif>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfquery name="GET_W" datasource="#dsn#">
	SELECT 
		STATION_ID 
	FROM 
		#dsn3_alias#.WORKSTATIONS W
	WHERE 
		W.ACTIVE = 1 AND
		W.EMP_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ep.userid#,%">
	ORDER BY 
		STATION_NAME
</cfquery>
<cfset authority_station_id_list = ValueList(get_w.station_id,',')>
<cfif len(authority_station_id_list) and isdefined("attributes.is_form_submitted")>
	<cfscript>
        get_production_order_result_action = createObject("component", "V16.production.cfc.get_production_order_result");
        get_production_order_result_action.dsn3 = dsn3;
        get_production_order_result_action.dsn_alias = dsn_alias;
		get_production_order_result_action.dsn1_alias = dsn1_alias;
        get_po_det = get_production_order_result_action.get_po_det_fnc(
			authority_station_id_list : '#IIf(IsDefined("authority_station_id_list"),"authority_station_id_list",DE(""))#',
			keyword : '#IIf(IsDefined("attributes.keyword"),"attributes.keyword",DE(""))#',
			maxrows : '#IIf(IsDefined("attributes.maxrows"),"attributes.maxrows",DE(""))#',
			start_date : '#IIf(IsDefined("attributes.start_date"),"attributes.start_date",DE(""))#',
			finish_date : '#IIf(IsDefined("attributes.finish_date"),"attributes.finish_date",DE(""))#',
			startrow : '#iif(isdefined("attributes.startrow"),"attributes.startrow",DE(""))#'
		);
	</cfscript>
<cfelse>
	<cfset get_po_det.recordcount = 0>
    <cfset get_po_det.query_count = 0>
</cfif>
<cfif get_po_det.recordcount>
	<cfparam name="attributes.totalrecords" default='#get_po_det.query_count#'>
<cfelse>
	<cfparam name="attributes.totalrecords" default='0'>
</cfif>
<cfif get_po_det.recordcount>
	<cfset prod_dep_id_list = ''>
	<cfoutput query="get_po_det">
		<cfif len(production_dep_id) and not listfind(prod_dep_id_list,production_dep_id)>
			<cfset prod_dep_id_list=listappend(prod_dep_id_list,production_dep_id)>
		</cfif>
	</cfoutput>
	<cfif listlen(prod_dep_id_list)>
		<cfset prod_dep_id_list=listsort(prod_dep_id_list,"numeric","ASC",",")>
		<cfquery name="get_dep" datasource="#DSN#">
			SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID IN (#prod_dep_id_list#) ORDER BY DEPARTMENT_ID
		</cfquery>
		<cfset prod_dep_id_list = listsort(listdeleteduplicates(valuelist(get_dep.DEPARTMENT_ID,',')),'numeric','ASC',',')>
	</cfif>
</cfif>
<cfscript>wrkUrlStrings('url_str','is_form_submitted');</cfscript>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="search_list" action="#request.self#?fuseaction=production.#fuseaction_#" method="post">
			<cf_box_search more="0">
				<input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
				<div class="form-group">
					<cfsavecontent variable="place"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" tabindex="1" name="keyword" value="#attributes.keyword#" maxlength="255" placeholder="#place#" style="width:130px;">
				</div>	
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="place"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
						<cfinput type="text" name="start_date" maxlength="10" validate="#validate_style#" style="width:65px;" placeholder="#place#" value="#dateformat(attributes.start_date,dateformat_style)#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="place"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
						<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" placeholder="#place#" validate="#validate_style#" style="width:65px;">
						<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
					</div>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,255" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" is_excel='0'>
				</div>
				<div class="form-group">
					<a class="ui-btn ui-btn-gray2" href="javascript:history.go(-1);"><i class="fa fa-arrow-left"></i></a>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cfsavecontent variable="box_head"><cf_get_lang dictionary_id='38087.Üretim Emir Sonuçları'></cfsavecontent>
	<cf_box title="#box_head#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<th width="20"><cf_get_lang dictionary_id ='57487.No'></th>
				<th><cf_get_lang dictionary_id ='58053.Başlangıç Tarihi'></th>
				<th><cf_get_lang dictionary_id ='57700.Bitiş Tarihi'></th>
				<th><cf_get_lang dictionary_id ='29474.Emir No'></th>
				<th><cf_get_lang dictionary_id ='38088.Üretim Sonucu No'></th>
				<th><cf_get_lang dictionary_id ='58211.Sipariş No'></th>
				<th><cf_get_lang dictionary_id ='38089.Mamül Adı'></th>
				<th><cf_get_lang dictionary_id ='57647.Spec'></th>
				<th><cf_get_lang dictionary_id ='57629.Açıklama'></th>
				<th><cf_get_lang dictionary_id='57635.Miktar'></th>
				<th><cf_get_lang dictionary_id='38090.Gönderildiği Depo'></th>
			</thead>
			<cfif isdefined("attributes.is_form_submitted") and get_po_det.recordcount>
				<cfoutput query="get_po_det">
					<tbody>
						<tr height="30" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
							<td>&nbsp;#currentrow#</td>
							<td>&nbsp;#DateFormat(start_date,dateformat_style)#</td>
							<td>&nbsp;#DateFormat(finish_date,dateformat_style)#</td>
							<td>&nbsp;#P_ORDER_NO#</td>
							<td>&nbsp;#RESULT_NO#</td>
							<td>&nbsp;#ORDER_NO#</td>
							<td>&nbsp;#PRODUCT_NAME#</td>
							<td>&nbsp;#SPECT_VAR_NAME#</td>
							<td>&nbsp;#REFERENCE_NO#</td>
							<td style="text-align:center">&nbsp;#MIKTAR#</td>
							<td>&nbsp;
								<cfif len(production_dep_id)>
									#get_dep.DEPARTMENT_HEAD[listfind(prod_dep_id_list,production_dep_id,',')]# <cfif len(COMMENT)>- #COMMENT#</cfif>
								</cfif>
							</td>
						</tr>
					</tbody>
				</cfoutput>
			<cfelse>
				<tr height="30" class="color-row"><td colspan="11"><cfif isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!<cfelse><cf_get_lang dictionary_id ='57701.Filtre Ediniz'>!</cfif></td></tr>
			</cfif>
		</cf_grid_list>
	
		<cfset adres = url.fuseaction>
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		<cfset adres = '#adres#&keyword=#attributes.keyword#'>
		</cfif>
		<cfif isdate(attributes.start_date)>
			<cfset adres = "#adres#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
		</cfif>
		<cfif isdate(attributes.finish_date)>
			<cfset adres = "#adres#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
		</cfif>
		<cf_paging 
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#adres#&is_form_submitted=1">
	</cf_box>
</div>
