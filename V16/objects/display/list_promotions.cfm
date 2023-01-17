<cfset url_string = "">
<cfif isdefined("attributes.prom_head")>
	<cfset url_string = "#url_string#&prom_head=#attributes.prom_head#">
</cfif>
<cfif isdefined("attributes.prom_id")>
	<cfset url_string = "#url_string#&prom_id=#attributes.prom_id#">
</cfif>
<cfif isdefined("attributes.prom_no")>
	<cfset url_string = "#url_string#&prom_no=#attributes.prom_no#">
</cfif>
<cfparam name="attributes.keyword" default="">
<cfquery name="get_promotions" datasource="#dsn3#">
	SELECT
		*
	FROM
		PROMOTIONS
	WHERE
		PROM_ID IS NOT NULL
		<cfif len(attributes.keyword)>
			AND
			(
				PROM_NO LIKE '%#attributes.keyword#%' OR
				PROM_HEAD LIKE '%#attributes.keyword#%'
			)
		</cfif>
	ORDER BY 
		PROM_ID
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_promotions.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Promosyonlar | SATIŞ',57583)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="search_prom" action="#request.self#?fuseaction=objects.popup_list_promotions&#url_string#" method="post">
			<cf_box_search>
				<div class="form-group">
					<cfinput type="Text" name="keyword" value="#attributes.keyword#" placeholder="#getLang('','Filtre',57460)#">
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Sayi_Hatasi_Mesaj',57537)#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_prom' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
		</cfform>
		<cf_flat_list>
			<thead>
				<tr>		
					<th width="50"><cf_get_lang dictionary_id='57487.No'></th>
					<th width="150"><cf_get_lang dictionary_id='58820.Başlık'></th>
				</tr>
			</thead>
			<cfif get_promotions.recordcount>
				<cfoutput query="get_promotions" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">		
					<tbody>					
						<tr>
							<td>#prom_no#</td>
							<td><a href="javascript://" onclick="add_prom('#prom_id#','#prom_head#','#prom_no#')">#prom_head#</a></td>
						</tr>
					</tbody>		
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="3"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
				</tr>
			</cfif>
		</cf_flat_list>
		<cfif isdefined("attributes.keyword")>
			<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
		</cfif>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<table width="99%" align="center">
				<tr>
					<td>
						<cfif isDefined("attributes.draggable") and len(attributes.draggable)>
							<cfset url_string = '#url_string#&draggable=#attributes.draggable#'>
						</cfif>
						<cf_pages page="#attributes.page#" 
						maxrows="#attributes.maxrows#" 
						totalrecords="#attributes.totalrecords#" 
						startrow="#attributes.startrow#" 
						adres="objects.popup_list_promotions&#url_string#"
						isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
					</td>
					<!-- sil -->
					<td style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
					<!-- sil -->
				</tr>
			</table>
		</cfif>
	</cf_box>
</div>

<!-- sil -->

<script type="text/javascript">
	document.getElementById('keyword').focus();
	function add_prom(prom_id,prom_head,prom_no)
	{
		<cfif isDefined("attributes.prom_id")>
			opener.<cfoutput>#attributes.prom_id#</cfoutput>.value = prom_id;
		</cfif>
		<cfif isDefined("attributes.prom_head")>
			opener.<cfoutput>#attributes.prom_head#</cfoutput>.value = prom_head;
		</cfif>
		<cfif isDefined("attributes.prom_no")>
			opener.<cfoutput>#attributes.prom_no#</cfoutput>.value = prom_no;
		</cfif>
		window.close();
		
	}
</script>
