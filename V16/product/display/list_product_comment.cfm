<cfparam name="attributes.page" default=1>
<cfparam name="attributes.keyword" default="">
<script type="text/javascript">
	function connectAjax(div_id,comment_id,status_info)
	{
		var page = <cfoutput>'#request.self#?fuseaction=product.emptypopup_ajax_upd_product_comment_stage&comment_id='+comment_id+''</cfoutput>
		if(eval("document.getElementById('comment_" + comment_id + "')").checked == true)
			AjaxPageLoad(page,div_id);
		eval("document.getElementById('comment_" + comment_id + "')").style.display='none';
		document.getElementById(status_info).innerHTML ='Yayında!';		
	}
</script>
<cfif isdefined("attributes.form_submitted")>
    <cfquery name="get_product_comment" datasource="#dsn3#">
        SELECT 
            PC.PRODUCT_ID,
            PC.NAME +' '+ PC.SURNAME AS YORUM_YAPAN,
            PC.PRODUCT_COMMENT_POINT,
            PC.PRODUCT_COMMENT,
            PC.PRODUCT_COMMENT_ID,
            PC.RECORD_DATE,
            PC.GUEST,
            PC.STAGE_ID,
            P.PRODUCT_NAME
        FROM 
            PRODUCT_COMMENT PC,
            PRODUCT P
        WHERE 
            PC.STAGE_ID <> -2 AND
            P.PRODUCT_ID = PC.PRODUCT_ID 
            <cfif len(attributes.keyword)>
                AND 
                (
                P.PRODUCT_NAME LIKE '%#attributes.keyword#%' OR
                PC.NAME LIKE '%#attributes.keyword#%' OR
                PC.SURNAME LIKE '%#attributes.keyword#%'
                )
            </cfif>
    </cfquery>
<cfelse>
	<cfset get_product_comment.recordcount = 0>
</cfif>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default="#get_product_comment.recordcount#">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="Pod_explanation" action="#request.self#?fuseaction=product.list_product_comment" method="post">
			<input name="form_submitted" id="form_submitted" type="hidden" value="1">
			<cf_box_search more="0">
				<div class="form-group" id="item-keyword">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#message#">
				</div>
				<div class="form-group small" id="item-maxrows">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" onKeyUp="isNumber (this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='37294.Ürün Yorumları'></cfsavecontent>
	<cf_box title="#message#" uidrop="1" hide_table_column="1">
		<cf_flat_list>
			<thead>
				<tr> 
					<th width="20"><cf_get_lang dictionary_id='58577.Sira'></th>
					<th><cf_get_lang dictionary_id='58221.Ürün Adı'></th>
					<th><cf_get_lang dictionary_id='37668.Yorum Yapan'></th>
					<th><cf_get_lang dictionary_id='29805.Yorum'></th>
					<th><cf_get_lang dictionary_id='58984.Puan'></th>
					<th><cf_get_lang dictionary_id='57742.Tarih'></th>
					<th><cf_get_lang dictionary_id='57756.Durum'></th>
					<th class="header_icn_none" width="20"><cf_get_lang dictionary_id='29479.Yayın'></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_product_comment.recordcount>
					<div id="SHOW_MESSAGE" style="display:none;"></div>
					<cfoutput query="get_product_comment" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
						<tr>
							<td>#currentrow#</td>
							<td><a href="#request.self#?fuseaction=product.list_product&event=det&pid=#product_id#" class="tableyazi">#product_name#</a></td>
							<td><cfif GUEST eq 1><cf_get_lang dictionary_id='37187.Ziyaretçi'><cfelse>#yorum_yapan#</cfif></td>
							<td title="#PRODUCT_COMMENT#"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=product.popup_upd_product_comment&product_id=#product_id#&product_comment_id=#product_comment_id#','medium')" class="tableyazi"><cfif len(product_comment)>#left(product_comment,50)#<cfelse><cf_get_lang dictionary_id='60398.Metin Girilmemiş'>!</cfif></a></td>
							<td>#product_comment_point#</td>
							<td>#dateformat(record_date,dateformat_style)#</td>
							<td id="status#currentrow#"><cfif stage_id eq -1><cf_get_lang dictionary_id ='37255.Hazırlık'><cfelseif stage_id eq -2><cf_get_lang dictionary_id='29479.Yayın'> <cfelseif stage_id eq 1>Draft<cfelse>#stage_id#</cfif></td>
							<td><input type="checkbox" name="comment_#PRODUCT_COMMENT_ID#" id="comment_#PRODUCT_COMMENT_ID#" value="1" onclick="connectAjax('SHOW_MESSAGE',#PRODUCT_COMMENT_ID#,'status#currentrow#');" title="<cf_get_lang dictionary_id='60399.Yayın Aşamasına Getir'>"></td>
						</tr>
					</cfoutput> 
				<cfelse>
					<tr> 
						<td colspan="8"><cfif not isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !<cfelse><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_flat_list>
		<cfset url_str = "">
		<cfif isdefined ("attributes.keyword") and len (attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif>
		<cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
			<cfset url_str = "&form_submitted=#attributes.form_submitted#">
		</cfif>
		<cf_paging page="#attributes.page#"
		maxrows="#attributes.maxrows#"
		totalrecords="#attributes.totalrecords#"
		startrow="#attributes.startrow#"
		adres="product.list_product_comment#url_str#">
	</cf_box>
</div>
<script type="text/javascript">
	$('#keyword').focus();
	//document.getElementById('keyword').focus();
</script>
