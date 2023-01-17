<cfquery name="GET_PRODUCT_COMMENT" datasource="#DSN3#">
	SELECT * FROM PRODUCT_COMMENT WHERE	PRODUCT_ID = #attributes.PRODUCT_ID#
</cfquery>
<cfset attributes.PID = attributes.PRODUCT_ID>
<cfparam name="attributes.maxrows" default='25'>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.totalrecords" default='#GET_PRODUCT_COMMENT.recordcount#'>
<cfparam name="attributes.modal_id" default="">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
 <script src="JS/Chart.min.js"></script>
<cfquery name="product_vote_" datasource="#dsn3#">
	SELECT 
		COUNT(PRODUCT_COMMENT_POINT) AS PUAN_YUZDE
	FROM 
		PRODUCT_COMMENT 
	WHERE 
		PRODUCT_ID = #attributes.PRODUCT_ID#
</cfquery>
<cfquery name="get_product_vote" datasource="#dsn3#">
	SELECT 
		PRODUCT_COMMENT_POINT,
		COUNT(PRODUCT_COMMENT_POINT) AS PUAN
	FROM 
		PRODUCT_COMMENT 
	WHERE 
		PRODUCT_ID = #attributes.PRODUCT_ID#
	GROUP BY 
		PRODUCT_COMMENT_POINT
</cfquery>
<cfif isdefined("form.graph_type") and len(form.graph_type)>
	<cfset graph_type = form.graph_type>
<cfelse>
	<cfset graph_type = "bar">
</cfif>
<cfinclude template="../query/get_product_name.cfm">
<cf_box title="#getLang('','Ürün Yorumları',37294)# : #GET_PRODUCT_NAME.PRODUCT_NAME#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cf_grid_list>
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id='57631.Ad'></th>
				<th><cf_get_lang dictionary_id='58726.Soyad'></th>
				<th><cf_get_lang dictionary_id='57428.E-mail'></th>
				<th><cf_get_lang dictionary_id='58984.Puan'></th>
				<th><cf_get_lang dictionary_id='29805.Yorum'></th>
				<th width="20"><i class="fa fa-pencil"></i></th>
			</tr>
		</thead>
		<tbody>
			<cfif GET_PRODUCT_COMMENT.RECORDCOUNT>
				<cfoutput query="GET_PRODUCT_COMMENT" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td>#name#</td>
						<td> #surname#</td>
						<td><a href="mailto:#mail_address#">#mail_address#</a></td>
						<td>#product_comment_point#</td>
						<td>#product_comment#</td>
						<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=product.popup_upd_product_comment&product_id=#attributes.pid#&product_comment_id=#product_comment_id#','large');"> <i class="fa fa-pencil" title="<cf_get_lang dictionary_id='37130.Yorum Düzenle'>"></i></a></td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="6"><cf_get_lang dictionary_id='37299.Ürüne Yorum Eklenmemiş'></td>
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
	<cfif attributes.maxrows lt attributes.totalrecords>
		<cfset adres = "product.popup_view_product_comment&product_id=#attributes.product_id#">
		<cf_paging page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#adres#">
	</cfif>
	<cfif get_product_vote.recordcount>
		<cfoutput query="get_product_vote">
			<cfif product_vote_.puan_yuzde neq 0>
			<cfset my_width = (#get_product_vote.puan#/#product_vote_.puan_yuzde#)>
			<cfelse>
				<cfset my_width = 0>
			</cfif>
			<cfset item="#PRODUCT_COMMENT_POINT#">
			<cfset 'item_#currentrow#'="#my_width#">
			<cfset 'value_#currentrow#'="#item#"> 
		</cfoutput>
		<canvas id="myChart" style="float:left;max-height:450px;max-width:450px;"></canvas>
		<script>
			var ctx = document.getElementById('myChart');
				var myChart = new Chart(ctx, {
					type: '<cfoutput>#graph_type#</cfoutput>',
					data: {
						labels: [<cfloop from="1" to="#get_product_vote.recordcount#" index="jj">
											<cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
						datasets: [{
							label: "grafik durum",
							backgroundColor: [<cfloop from="1" to="#get_product_vote.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
							data: [<cfloop from="1" to="#get_product_vote.recordcount#" index="jj"><cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
						}]
					},
					options: {}
			});
		</script>	
	</cfif>
</cf_box>
