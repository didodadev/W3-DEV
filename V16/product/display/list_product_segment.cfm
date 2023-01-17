<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.is_submit")>
    <cfquery name="get_product_segment" datasource="#dsn1#">
        SELECT
            *
        FROM
            PRODUCT_SEGMENT
        <cfif len(attributes.keyword)>
        WHERE
            PRODUCT_SEGMENT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
        </cfif>
        ORDER BY
            PRODUCT_SEGMENT
    </cfquery>
<cfelse>
	<cfset get_product_segment.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_product_segment.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="list_product_segment" action="#request.self#?fuseaction=product.list_product_segment" method="post">
			<input type="hidden" name="is_submit" id="is_submit" value="1">
			<cf_box_search more="0">
				<div class="form-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" maxlength="50" name="keyword" id="keyword" value="#attributes.keyword#" placeholder="#message#">
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" onKeyUp="isNumber (this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
				<cfoutput>
					<div class="form-group">
						<a class="ui-btn ui-btn-gray" href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=product.list_product_segment&event=add','small');" ><i class="fa fa-plus" title = "<cf_get_lang dictionary_id ='44630.Ekle'>" alt="<cf_get_lang dictionary_id ='44630.Ekle'>"></i></a>
					</div>
				</cfoutput>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='37251.Ürün Hedef Pazar'></cfsavecontent>
	<cf_box title="#title#" uidrop="1" hide_table_column="1">
		<cf_flat_list>
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='37035.Hedef Pazar'></th>
					<th><cf_get_lang dictionary_id='29434.Subeler'></th>
					<th><cf_get_lang dictionary_id='57629.Açiklama'></th>
					<!-- sil -->
					<th class="text-center" width="50"><cf_get_lang dictionary_id='57453.Sube'></th>
					<th class="text-center" width="30"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=product.list_product_segment&event=add</cfoutput>');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='37121.Segment Ekle'>"></i></a></th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_product_segment.recordcount>
					<cfoutput query="get_product_segment" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
						<tr>
							<td>#currentrow#</td>
							<td><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=product.list_product_segment&event=updSegment&id=#product_segment_ID#');" class="tableyazi"> #PRODUCT_SEGMENT#</a></td>
							<td>
								<cfquery name="get_product_segment_branch" datasource="#DSN1#">
									SELECT * FROM PRODUCT_SEGMENT_BRANCH WHERE PRODUCT_SEGMENT_ID = #product_segment_id#
								</cfquery>
								<cfset my_list="">
								<cfif get_product_segment_branch.recordcount>
									<cfset my_list=valuelist(get_product_segment_branch.product_segment_branch_id)>
									<cfquery name="get_name" datasource="#DSN#">
										SELECT BRANCH_NAME FROM BRANCH WHERE BRANCH_ID IN (#my_list#) ORDER BY BRANCH_NAME
									</cfquery>
									<cfloop query="get_name">
										#branch_name# <cfif currentrow neq recordcount>,&nbsp;</cfif>
									</cfloop> 
								</cfif>
							</td>
							<td>#product_segment_detail#</td>
							<!-- sil -->
							<td class="text-center">
								<cfquery name="GET_SEG_PRO" datasource="#DSN1#">
									SELECT * FROM PRODUCT_SEGMENT_BRANCH WHERE PRODUCT_SEGMENT_ID = #product_segment_id#
								</cfquery>
								<cfif get_seg_pro.recordcount eq 0>
									<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=product.list_product_segment&event=addBranch&id=#product_segment_id#','small');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='37162.Sube Ekle'>" alt="<cf_get_lang dictionary_id='37162.Sube Ekle'>"></i></a>
								<cfelse>
									<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=product.list_product_segment&event=updBranch&id=#product_segment_id#','small');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='37160.Sube Güncelle'>"></i></a>
								</cfif>
							</td>
							<td class="text-center"><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=product.list_product_segment&event=updSegment&id=#product_segment_id#');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='37202.Segment Güncelle'>"></i></a></td>
							<!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="8"><cfif isdefined("attributes.is_submit")><cf_get_lang dictionary_id='57484.Kayit Yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_flat_list>
		<cfset url_str = "">
		<cfif isdefined ("attributes.keyword") and len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif>
		<cfif isdefined ("attributes.is_submit") and len(attributes.is_submit)>
			<cfset url_str = "#url_str#&is_submit=#attributes.is_submit#">
		</cfif>
		<cf_paging page="#attributes.page#" 
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="product.list_product_segment#url_str#">
	</cf_box>
</div>
<script type="text/javascript">
	$('#keyword').focus();
	//document.getElementById('keyword').focus();
</script>

