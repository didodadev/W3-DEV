<!--- 
	url üzerinden
	field_id : form_adı.id_alan_adı
	field_name : form_adı.hesapplanı_adı_yazılacak_alan_adı
	yazılacak alanları alır ve yazar

	parametreler gönderilmemisse sadece pencereyi kapar
 --->
<cfif isdefined("attributes.is_form_submitted")>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
<cfelse>
	<cfset attributes.start_date = date_add('d',-7,createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#'))>
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
<cfelse>
	<cfset attributes.finish_date = date_add('d',7,attributes.start_date)>
</cfif>
<cfinclude template="../query/get_p_order_results.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.totalrecords" default='#get_p_order_results.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset url_string = "">
<cfif isdefined("is_form_submitted")><cfset url_string = "#url_string#&is_form_submitted=1"></cfif>
<cfif isdefined("field_id")><cfset url_string = "#url_string#&field_id=#field_id#"></cfif>
<cfif isdefined("field_name")><cfset url_string = "#url_string#&field_name=#field_name#"></cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Üretim Sonuçları',34313)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="list_p_order_results" method="post" action="#request.self#?fuseaction=objects.#fusebox.fuseaction##url_string#">
			<input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1" />
			<cf_box_search more="0">
				<div class="form-group" id="item-keyword">
					<cfinput type="text" name="keyword" placeholder="#getLang('','Filtre','57460')#" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group" id="item-start_date">
					<div class="input-group">			
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi Girmelisiniz'>!</cfsavecontent>
						<cfinput type="text" name="start_date" id="start_date_" maxlength="10" value="#dateformat(attributes.start_date,dateformat_style)#" validate="#validate_style#" message="#message#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_date_"></span>
					</div>
				</div>
				<div class="form-group" id="item-finish_date">
					<div class="input-group">				
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'>!</cfsavecontent>
						<cfinput type="text" name="finish_date" id="finish_date_" maxlength="10" value="#dateformat(attributes.finish_date,dateformat_style)#" validate="#validate_style#" message="#message#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date_"></span>
					</div>
				</div>	
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('list_p_order_results',#attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
		</cfform>
		<cf_grid_list>
			<thead>
				<tr>		
					<th width="100"><cf_get_lang dictionary_id='34314.Sonuc No'></th>
					<th><cf_get_lang dictionary_id='29474.Emir No'></th>
					<th width="100"><cf_get_lang dictionary_id='58053.Baslangıc Tarihi'></th>
					<th width="100"><cf_get_lang dictionary_id='57700.Bitis Tarihi'></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_p_order_results.recordcount and form_varmi eq 1>
					<cfoutput query="get_p_order_results" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">		
						<tr>
							<td><a href="javascript://" onclick="gonder('#P_ORDER_ID#','#PRODUCTION_ORDER_NO#');" class="tableyazi">#result_no#</a></td>
							<td><a href="javascript://" onclick="gonder('#P_ORDER_ID#','#PRODUCTION_ORDER_NO#');" class="tableyazi">#production_order_no#</a></td>
							<td>#dateformat(start_date,dateformat_style)#</td>
							<td>#dateformat(finish_date,dateformat_style)#</td>
						</tr>		
					</cfoutput>
				</cfif>
			</tbody>
		</cf_grid_list>
		<div class="ui-info-bottom">
			<p><cfif form_varmi eq 0><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'>!</cfif></p>
		</div>
		<cfif attributes.maxrows lt attributes.totalrecords>
			<cfif form_varmi eq 1>
				<cfif len(attributes.keyword)>
					<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
				</cfif>
				<cfif isdate(attributes.start_date)>
					<cfset url_string = '#url_string#&start_date=#dateformat(attributes.start_date,dateformat_style)#'>
				</cfif>
				<cfif isdate(attributes.finish_date)>
					<cfset url_string = '#url_string#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#'>
				</cfif>
				<cf_paging page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="objects.popup_p_order_results#url_string#">
			</cfif>
		</cfif> 
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();

	$("#wrk_search_button").click(function() {
		return date_check(document.getElementById('start_date_'),document.getElementById('finish_date_'),"<cf_get_lang dictionary_id='56017.Başlama Tarihi Bitiş Tarihinden Önce Olmalıdır'>!");
	});
	function gonder(no,deger)
	{
		<cfif isDefined("attributes.field_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value=no;
		</cfif>
		<cfif isDefined("attributes.field_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value=deger;
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.focus();
		</cfif>
		<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	}
</script>
