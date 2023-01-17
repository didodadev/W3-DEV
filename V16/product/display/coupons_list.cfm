<cfquery name="GET_COUPONS" datasource="#dsn3#">
	SELECT * FROM COUPONS WHERE 1=1 <cfif IsDefined("attributes.keyword") and len(attributes.keyword)> AND COUPON_NO LIKE '%#attributes.keyword#%'</cfif>
</cfquery>
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
</cfif>
<cfif isdefined("attributes.is_form_submitted")>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<cfparam name="attributes.cat" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_coupons.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='37469.Kuponlar'></cfsavecontent>
<cf_box  title="#message#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="search_coupon" action="#request.self#?fuseaction=#url.fuseaction#" method="post">
		<cfinput type="hidden" name="is_form_submitted" value="1">
		<cf_box_search>
			<div class="form-group" id="item-keyword">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
				<cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50"  placeholder="#message#">
			</div>
			<div class="form-group small">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text"  name="maxrows" id="maxrows" required="yes" onKeyUp="isNumber(this)" maxlength="3" value="#attributes.maxrows#" validate="integer" range="1,250" message="#message#" >
			</div>		
			<div class="form-group">
				<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_coupon' , #attributes.modal_id#)"),DE(""))#">
			</div>
		</cf_box_search>		
	</cfform>
	<cf_flat_list>
		<thead>
			<tr>
				<th width="150"><cf_get_lang dictionary_id='37470.Kupon no'></th>
				<th width="150"><cf_get_lang dictionary_id='37471.Kupon Adı'></th>
				<th width="350"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></th>
				<th with="150px"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
				<th width="10"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=product.popup_add_coupon</cfoutput>','small');"><img src="/images/plus_list.gif" border="0" title="<cf_get_lang dictionary_id='37472.Kupon Ekle'>"></a></th>
			</tr>	
		</thead>
		<tbody>		 
			<cfoutput query="get_coupons" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
				<tr>
					<td>#coupon_no#</td>
					<td><a href="javascript://" class="tableyazi" onclick="gonder('#coupon_id#','#coupon_name#');">#coupon_name#</a></td> 
					<td>#dateformat(start_date,dateformat_style)#</td>
					<td>#dateformat(finish_date,dateformat_style)#</td>
					<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=product.popup_upd_coupon&coupon_id=#get_coupons.coupon_id#','small');"><i class="fa fa-pencil"></i></a></td>
				</tr>
			</cfoutput> 
			<cfif not get_coupons.recordcount and form_varmi eq 1>
				<tr> 
					<td colspan="5"><cfif form_varmi eq 0><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</cfif></td>
				</tr>
			</cfif>
		</tbody>
	</cf_flat_list>

	<cfset adres = url.fuseaction>
	<cfif len(attributes.keyword)>
	<cfset adres = '#adres#&keyword=#attributes.keyword#'>
	</cfif>
	<cf_paging page="#attributes.page#" 
	maxrows="#attributes.maxrows#"
	totalrecords="#attributes.totalrecords#"
	startrow="#attributes.startrow#"
	adres="#adres#"
	isAjax="#iif(isdefined("attributes.draggable"),1,0)#">

</cf_box>
<script type="text/javascript">
function gonder(coupon_id,coupon_name)
{
	<cfoutput>
	<cfif isdefined("attributes.field_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.#attributes.field_id#.value = coupon_id;
	</cfif>
	<cfif isdefined("attributes.field_name")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.#attributes.field_name#.value = coupon_name;
	</cfif>
	</cfoutput>
	<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
}		
</script>
