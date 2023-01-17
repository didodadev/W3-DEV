<cfif isdefined('attributes.form_submit') and len(attributes.form_submit)>
	<cfquery name="GET_SALEABLE_STOCK_ACTION" datasource="#DSN3#">
		SELECT
			STOCK_ACTION_ID,
			#dsn#.Get_Dynamic_Language(STOCK_ACTION_ID,'#session.ep.language#','SETUP_SALEABLE_STOCK_ACTION','STOCK_ACTION_NAME',NULL,NULL,STOCK_ACTION_NAME) AS STOCK_ACTION_NAME,
			STOCK_ACTION_TYPE
		FROM
			SETUP_SALEABLE_STOCK_ACTION
		<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
		WHERE
			STOCK_ACTION_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
		</cfif>
	</cfquery>
</cfif>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfif isdefined('attributes.form_submit') and len(attributes.form_submit)>
	<cfparam name="attributes.totalrecords" default="#GET_SALEABLE_STOCK_ACTION.RECORDCOUNT#">
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">
</cfif>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="search_product" action="#request.self#?fuseaction=product.list_saleable_stock_action" method="post">
			<input type="hidden" name="form_submit" id="form_submit" value="1">		
			<cf_box_search more="0">				
				<div class="form-group">
					<cfinput type="text" name="keyword" id="keyword" placeholder="#getLang('','Filtre',57460)#" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" onKeyUp="isNumber (this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>					
			</cf_box_search>
		</cfform>
	</cf_box>

	<cf_box title="#getLang('','Satılabilir Stok Prensipleri',58747)#" uidrop="1" hide_table_column="1">
		<cf_flat_list>
			<thead>
				<tr>
					<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='37778.Prensip Adı'></th>
					<th><cf_get_lang dictionary_id='37779.Prensip Türü'></th>
					<!-- sil -->
					<th width="20" class="header_icn_none" width="20"><a onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=product.list_saleable_stock_action&event=add','','ui-draggable-box-small');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='37157.Ürün Kategorisi Ekle'>"></i></a></th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif isdefined('GET_SALEABLE_STOCK_ACTION')>
				<cfif GET_SALEABLE_STOCK_ACTION.RECORDCOUNT>
					<cfoutput query="GET_SALEABLE_STOCK_ACTION" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#CURRENTROW#</td>
							<td>#STOCK_ACTION_NAME#</td>
							<td>
								<cfif STOCK_ACTION_TYPE eq 1>
									<cf_get_lang dictionary_id='37167.Bekleyen Sipariş Alınamaz'>
								<cfelseif STOCK_ACTION_TYPE eq 2>
									<cf_get_lang dictionary_id='37169.Bekleyen Siparişe Alınır. Silinemez'>
								<cfelseif STOCK_ACTION_TYPE eq 3>
									<cf_get_lang dictionary_id='37174.Bekleyen Siparişe Alınır. Silinebilir'>
								<cfelseif STOCK_ACTION_TYPE eq 4>
									<cf_get_lang dictionary_id='37178.Alternatif Ürün Gönderilebilir'>
								</cfif>
							</td>
							<!-- sil -->
							<td><a onClick="openBoxDraggable('#request.self#?fuseaction=product.list_saleable_stock_action&event=upd&stock_action_id=#STOCK_ACTION_ID#','','ui-draggable-box-small');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id ='57464.Güncelle'>" alt="<cf_get_lang dictionary_id ='57464.Güncelle'>"></i></a></td>
							<!-- sil -->
						</tr>
						</cfoutput>
					<cfelse>
						<tr>
							<td colspan="4"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
						</tr>
					</cfif>
				<cfelse>
					<tr>
						<td colspan="4"><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</td>
					</tr>
				</cfif>				
			</tbody>
		</cf_flat_list>
		<cfset adres = "product.list_saleable_stock_action">
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
			<cfset adres = "#adres#&keyword=#attributes.keyword#">
		</cfif>
		<cfif isDefined("attributes.form_submit") and len(attributes.form_submit)>
			<cfset adres = "#adres#&form_submit=#attributes.form_submit#">
		</cfif>
		<cf_paging 
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#adres#">
	</cf_box>  
</div>
<script type="text/javascript">
	$('#keyword').focus();
</script>
