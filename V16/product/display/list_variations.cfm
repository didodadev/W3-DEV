<cfset url_str = ''>
<cfif isdefined('VARIATION')>
	<cfset url_str = '#url_str#&VARIATION=#attributes.VARIATION#'>
</cfif>
<cfif isdefined('VARIATION_ID')>
	<cfset url_str = '#url_str#&VARIATION_ID=#attributes.VARIATION_ID#'>
</cfif>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfquery name="GET_PROPERTY_DETAIL" datasource="#dsn1#">
    SELECT
        PP.PROPERTY_ID,
        PPD.PROPERTY_DETAIL_ID VARIATION_ID,
        PP.PROPERTY,
        PPD.PROPERTY_DETAIL,
        PPD.PROPERTY_VALUES
        FROM
            PRODUCT_PROPERTY PP,
            PRODUCT_PROPERTY_DETAIL PPD
    WHERE 
    	<cfif len(attributes.keyword)>
        PPD.PROPERTY_DETAIL LIKE '%#attributes.keyword#%' AND
        </cfif>
    	PPD.PRPT_ID = PP.PROPERTY_ID
</cfquery>
<cfif isdefined("attributes.related_variation_id") and len(attributes.related_variation_id)>
	<cfset attributes.related_variation_id = listsort(attributes.related_variation_id,'text')>
<cfelse>
	<cfset attributes.related_variation_id = "">
</cfif>
<cfparam name="attributes.totalrecords" default='#GET_PROPERTY_DETAIL.recordcount#'>
<cfparam name="attributes.modal_id" default="">
<cf_box title="#getLang('','Varyasyonlar',37258)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="search_variations" method="post" action="#request.self#?fuseaction=#url.fuseaction#&#url_str#">
		<cf_box_search more="0">
			<div class="form-group">
				<cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#getLang('','Filtre',57460)#">
			</div>
			<div class="form-group small">
				<cfinput type="text" onKeyUp="isNumber(this)" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
			</div>
			<div class="form-group">
				<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_variations' , #attributes.modal_id#)"),DE(""))#">
			</div>
		</cf_box_search>
	</cfform>
	<cf_grid_list>	
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id='58910.Özellikler'></th>
				<th><cf_get_lang dictionary_id='37258.Varyasyonlar'></th>
				<th><cf_get_lang dictionary_id='37388.Değerler'></th>
				<th width="20" align="center"><input type="checkbox" name="main_variation_" id="main_variation_" title="Hepsini Seç" onClick="wrk_select_all(this.id,'variation_');"></th>
			</tr>
		</thead>
		<tbody>
			<cfif GET_PROPERTY_DETAIL.recordcount>		 
				<cfoutput query="GET_PROPERTY_DETAIL" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
					<tr>
						<td>#PROPERTY#</td>
						<td><a onClick="gonder('#VARIATION_ID#','#PROPERTY_DETAIL#');" style="cursor:pointer;">#PROPERTY_DETAIL#</a></td>
						<td>#PROPERTY_VALUES#</td>
						<td><input type="checkbox" name="variation_" id="variation_" <cfif listfind(attributes.related_variation_id,VARIATION_ID)>checked</cfif> value="#VARIATION_ID#█#PROPERTY_DETAIL#"></td>
					</tr>
				</cfoutput> 
				<cfelse>
					<tr> 
						<td colspan="5" height="20"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
					</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
	<div class="ui-info-bottom flex-end">
		<input type="button" value="Ekle" onClick="add_variation();">
	</div>
	<cfif attributes.totalrecords gt attributes.maxrows>
		<cfset adres = url.fuseaction>
		<cfif len(attributes.keyword)>
			<cfset adres = '#adres#&keyword=#attributes.keyword#'>
		</cfif>
		<cfif isdefined("attributes.related_variation_id")>
			<cfset adres = '#adres#&related_variation_id=#attributes.related_variation_id#'>
		</cfif>
		<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#adres##url_str#"
			isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
	</cfif>
</cf_box>
<script type="text/javascript">
	<cfoutput>
	function add_variation(){
		var check_leng = document.getElementsByName('variation_').length;
		for(var _ind_=0; _ind_<check_leng; _ind_++){
			if(document.getElementsByName('variation_')[_ind_].checked == true){
				<cfif isdefined('attributes.variation_id')><!--- Variation ID --->
					<cfif isdefined("attributes.draggable")>document<cfelse>opener.window.document</cfif>.getElementById('#attributes.variation_id#').value=<cfif isdefined("attributes.draggable")>document<cfelse>opener.window.document</cfif>.getElementById('#attributes.variation_id#').value+','+list_getat(document.getElementsByName('variation_')[_ind_].value,1,'█');
					<cfif isdefined("attributes.draggable")>document<cfelse>opener.window.document</cfif>.getElementById('#attributes.variation_id#').value;
				</cfif>
				<cfif isdefined('attributes.variation')><!--- Variation Name --->
					<cfif isdefined("attributes.draggable")>document<cfelse>opener.window.document</cfif>.getElementById('#attributes.variation#').value=<cfif isdefined("attributes.draggable")>document<cfelse>opener.window.document</cfif>.getElementById('#attributes.variation#').value+','+list_getat(document.getElementsByName('variation_')[_ind_].value,2,'█');
				</cfif>
			}	
		}
	}
	function gonder(variation_id,variation_name){
		<cfif isdefined('attributes.variation_id')><!--- Variation ID --->
			<cfif isdefined("attributes.draggable")>document<cfelse>opener.window.document</cfif>.getElementById('#attributes.variation_id#').value =variation_id;
		</cfif>
		<cfif isdefined('attributes.variation')><!--- Variation Name --->
			<cfif isdefined("attributes.draggable")>document<cfelse>opener.window.document</cfif>.getElementById('#attributes.variation#').value = variation_name;
		</cfif>
	<cfif not isdefined("attributes.draggable")>this.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	}
	</cfoutput>
</script>
