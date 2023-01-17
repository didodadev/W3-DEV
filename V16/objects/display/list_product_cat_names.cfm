<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.category" default="">
<cfparam name="attributes.is_sub_category" default="0"><!--- Eğer formdan 1 gonderildiginde ana kategoriler de seçilebilir hale gelir --->
<cfparam name="attributes.is_multi_selection" default="0"><!--- Formdan 1 gonderildiginde kategoriler coklu olarak secilebilir hale gelir, ancak DIKKAT, gönderilen alanlarin degere uygun olmasi gerekiyor FBS 20100202 --->
<cfquery name="GET_PRODUCT_CATS" datasource="#DSN1#" cachedwithin="#fusebox.general_cached_time#">
	SELECT
		PC.HIERARCHY,
		PC.PRODUCT_CAT
	FROM
		PRODUCT_CAT PC,
		PRODUCT_CAT_OUR_COMPANY PCO
	WHERE 
		PC.PRODUCT_CATID IS NOT NULL AND
		PCO.PRODUCT_CATID = PC.PRODUCT_CATID AND
		<cfif isDefined('attributes.category')>
			PC.HIERARCHY NOT LIKE '%.%' AND
		</cfif>				
		PCO.OUR_COMPANY_ID = #session.ep.company_id#
	ORDER BY
		PC.HIERARCHY
</cfquery>
<cfif isdefined("attributes.is_form_submitted")>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<cfif form_varmi eq 1>
	<cfinclude template="../query/get_product_cat2.cfm">
<cfelse>
	<cfset get_product_cat.recordcount=0>
</cfif>
<cfset url_string = '&is_form_submitted=1'>
 <cfif isdefined("attributes.product_catid")>
	<cfset url_string = "#url_string#&product_catid=#attributes.product_catid#">
</cfif>
<cfif isdefined("attributes.field_id")>
	<cfset url_string = "#url_string#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.field_hierarchy")>
	<cfset url_string="#url_string#&field_hierarchy=#attributes.field_hierarchy#">
</cfif>
<cfif isdefined("attributes.field_name")>
	<cfset url_string = "#url_string#&field_name=#attributes.field_name#">
</cfif>
<cfif isdefined("attributes.field_code")>
	<cfset url_string = "#url_string#&field_code=#attributes.field_code#">
</cfif>
<cfif isdefined("attributes.field_min")>
	<cfset url_string = "#url_string#&field_min=#attributes.field_min#">
</cfif>
<cfif isdefined("attributes.field_max")>
	<cfset url_string = "#url_string#&field_max=#attributes.field_max#">
</cfif>
<cfif isdefined("attributes.is_sub_category")>
	<cfset url_string = "#url_string#&is_sub_category=#attributes.is_sub_category#">
</cfif>
<cfif isdefined("attributes.is_multi_selection")>
	<cfset url_string = "#url_string#&is_multi_selection=#attributes.is_multi_selection#">
</cfif>
<cfif isdefined("attributes.is_select")>
	<cfset url_string = "#url_string#&is_select=#attributes.is_select#">
</cfif>
<cfif isdefined('attributes.call_function')>
	<cfset url_string = "#url_string#&call_function=#attributes.call_function#">
</cfif>
<cfif isdefined("attributes.order_cat")>
	<cfset url_string = '#url_string#&order_cat=#attributes.order_cat#'>
</cfif>
<cfif isdefined('attributes.caller_function')>
	<cfset url_string = "#url_string#&caller_function=#attributes.caller_function#">
</cfif>
<cfif isdefined('attributes.caller_function_paremeter')>
	<cfset url_string = "#url_string#&caller_function_paremeter=#attributes.caller_function_paremeter#">
</cfif>
<cfset url_string2 = ''>
<cfif len(attributes.employee)>
	<cfset url_string2 = "#url_string#&employee=#attributes.employee#&employee_id=#attributes.employee_id#">
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.totalrecords" default="#get_product_cat.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Ürün Kategorileri',57567)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cf_wrk_alphabet keyword="url_string,url_string2" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="search_product_cat" action="#request.self#?fuseaction=objects.popup_product_cat_names#url_string#" method="post"><!--- #url_string# --->
			<cf_box_search>
				<div class="form-group" id="keyword">
					<cfinput type="hidden" name="is_form_submitted"  value="1">
					<cfinput type="Text" name="keyword"  maxlength="255" value="#attributes.keyword#" placeholder= "#getLang(48,'Filtre',57460)#">
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','ÜKayıt Sayısı Hatalı!',57537)#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_product_cat' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
			<cf_box_search_detail search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_product_cat' , #attributes.modal_id#)"),DE(""))#">
				<div class="form-group col col-3 col-md-4 col-sm-6 col-xs-12" id="category">
					<select name="category" id="category">
						<option value="" selected><cf_get_lang dictionary_id='58137.Kategoriler'></option>
						<cfoutput query="GET_PRODUCT_CATS">
							<option value="#hierarchy#" <cfif attributes.category is hierarchy>selected</cfif>>#hierarchy# - #product_cat#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group col col-3 col-md-4 col-sm-6 col-xs-12" id="responsible">
					<div class="input-group">
						<input type="hidden" name="employee_id" id="employee_id"  value="<cfif len(attributes.employee_id) and len(attributes.employee)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
						<input type="text" name="employee" placeholder ="<cfoutput>#getLang('','Sorumlu',57544)#</cfoutput>" id="employee" value="<cfif len(attributes.employee_id) and len(attributes.employee)><cfoutput>#attributes.employee#</cfoutput></cfif>" maxlength="255">
						<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_id=search_product_cat.employee_id&field_name=search_product_cat.employee&select_list=1');"></span>
					</div>
				</div>
			</cf_box_search_detail>
		 </cfform>
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"></th>
					<th width="100"><cf_get_lang dictionary_id='58585.Kod'></th>
					<th><cf_get_lang dictionary_id='57486.Kategori'></th>
					<th width="80"><cf_get_lang dictionary_id ='33950.Min Marj'>(%)</th>
					<th width="80"><cf_get_lang dictionary_id ='33951.Max Marj'>(%)</th>
				</tr>
			</thead>
			<tbody>
				<cfif get_product_cat.recordcount and form_varmi eq 1>
					<cfoutput query="get_product_cat" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<cfset cont="#HIERARCHY#">
							<cfset pro_cont=product_cat>
							<cfset rm = '#chr(13)#'>
							<cfset cont = ReplaceList(cont,rm,'')>
							<cfset pro_cont = ReplaceList(pro_cont,rm,'')>
							<cfset rm = '#chr(10)#'>
							<cfset cont = ReplaceList(cont,rm,'')>
							<cfset pro_cont = ReplaceList(pro_cont,rm,'')>
							<cfset pro_cont = ReplaceList(pro_cont,"'",' ')>
							<!---<cfset pro_cont = Replace(pro_cont,"&",'','all')>--->
							<cfset hierarchy_ = Replace(hierarchy,"&",'','all')>
							<cfset sub = hierarchy_>
							<cfset commaString = ''>
							<cfset cont = Replace(cont,"&",'','all')>
							<cfset tempHier = Replace(hierarchy_,'.','_','all')>
							<cfloop index="ind" from="1" to="#len(hierarchy_)#">
								<cfif mid(hierarchy_,ind,1) is '.'>
									<cfset commaString = listAppend(commaString,ind,',')>
								</cfif>
							</cfloop>
							<cfif len(commaString)>
								<cfset sub = Replace(left(hierarchy_,listLast(commaString,',')-1),'.','_','all')>
							<cfelse>
								<cfset sub = Replace(hierarchy_,'.','_','all')>
							</cfif>
							<cfif is_sub_product_cat is 0><!--- altinda kategori yok ise --->
								<tr class="<cfif listlen(hierarchy_,'.') lte 2>show</cfif> sub#sub# main#tempHier#" test="#sub#" id="main#tempHier#">
								<td style="padding-left:#(listlen(hierarchy_,'.')-1)*20#px;"><a href="javascript://" onClick="showHier('#tempHier#')"><img id="showImage#tempHier#" src="/images/listele.gif" class="show"><img id="hideImage#tempHier#" src="/images/listele_down.gif" class="hide"></a></td>
								<td><a href="javascript://" class="tableyazi" onclick="gonder('#product_catid#','#hierarchy_# #pro_cont#','#hierarchy#','<cfif isnumeric(profit_margin)>#tlformat(profit_margin)#<cfelse>#tlformat(0)#</cfif>','<cfif isnumeric(profit_margin_max)>#tlformat(profit_margin_max)#<cfelse>#tlformat(0)#</cfif>');">#hierarchy#</a></td>
								<td>
									<cfloop from="1" to="#listlen(hierarchy,'.')#" index="i">&nbsp;</cfloop>
									<a href="javascript://" class="tableyazi" onclick="gonder('#product_catid#','#cont# #pro_cont#','#cont#','<cfif isnumeric(profit_margin)>#tlformat(profit_margin)#<cfelse>#tlformat(0)#</cfif>','<cfif isnumeric(profit_margin_max)>#tlformat(profit_margin_max)#<cfelse>#tlformat(0)#</cfif>');">#product_cat#</a>
								</td>
							<cfelse>
							<tr class="<cfif listlen(hierarchy_,'.') lte 2>show</cfif> sub#sub# main#tempHier#" test="#sub#" id="main#tempHier#">
								<td style="padding-left:#(listlen(hierarchy_,'.')-1)*20#px;"><a href="javascript://" onClick="showHier('#tempHier#')"><img id="showImage#tempHier#" src="/images/listele.gif" class="hide"><img id="hideImage#tempHier#" src="/images/listele_down.gif" class="show"></a></td>
								<td>
								<cfif attributes.is_sub_category lte listlen(hierarchy,'.') and attributes.is_sub_category neq 0>
									<a href="javascript://" class="tableyazi" onclick="gonder('#product_catid#','#hierarchy# #pro_cont#','#hierarchy#','<cfif isnumeric(profit_margin)>#tlformat(profit_margin)#<cfelse>#tlformat(0)#</cfif>','<cfif isnumeric(profit_margin_max)>#tlformat(profit_margin_max)#<cfelse>#tlformat(0)#</cfif>');">#hierarchy#</a>
								<cfelse>
									#hierarchy#
								</cfif>
								</td>
								<td>
								<cfloop from="1" to="#listlen(HIERARCHY,'.')#" index="i">&nbsp;</cfloop>					
								<cfif attributes.is_sub_category lte listlen(HIERARCHY,'.') and attributes.is_sub_category neq 0>
									<a href="javascript://" class="tableyazi" onclick="gonder('#product_catid#','#hierarchy# #pro_cont#','#hierarchy#','<cfif isnumeric(profit_margin)>#tlformat(profit_margin)#<cfelse>#tlformat(0)#</cfif>','<cfif isnumeric(profit_margin_max)>#tlformat(profit_margin_max)#<cfelse>#tlformat(0)#</cfif>');">#product_cat#</a>
								<cfelse>
									#product_cat#
								</cfif>
								</td>
							</cfif>
							<td class="text-right"><cfif isnumeric(profit_margin)>#tlformat(profit_margin)#<cfelse>#tlformat(0)#</cfif></td>
							<td class="text-right"><cfif isnumeric(profit_margin_max)>#tlformat(profit_margin_max)#<cfelse>#tlformat(0)#</cfif></td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="5" class="color-row"><cfif form_varmi eq 0><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'>!</cfif>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>

	   	<cfif attributes.totalrecords gt attributes.maxrows>
	   		<cfset url_string = "#url_string#&is_form_submitted=1">
			<cfif len(attributes.keyword)>
				<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
			</cfif>
			<cfif len(attributes.category)>
				<cfset url_string = "#url_string#&category=#attributes.category#">
			</cfif>
			<cfif len(attributes.employee)>
				<cfset url_string = "#url_string#&employee=#attributes.employee#&employee_id=#attributes.employee_id#">
			</cfif>
			<cfif isdefined("attributes.draggable") and len(attributes.draggable)>
				<cfset url_string = "#url_string#&draggable=#attributes.draggable#">
			</cfif>
			<cf_paging page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="objects.popup_product_cat_names&#url_string#"
				isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
		</cfif>
 	</cf_box>
</div>

<script type="text/javascript">
$(document).ready(function(){
    $( "#keyword" ).focus();
});
function gonder(p_cat_id,p_cat,p_cat_code,p_min,p_max)
{
	<cfoutput>
	<cfif isdefined('attributes.call_function')>
		var sayac = <cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.all.row_count.value;
			<cfif not isdefined("attributes.draggable")>window.opener.</cfif>#attributes.call_function#(sayac++,p_cat_id,p_cat,p_cat_code);
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.all.row_count.value=sayac++;
	<cfelse>
		<cfif isdefined('attributes.field_id') and listlen(attributes.field_id,'.') eq 2>
			<cfif isdefined("attributes.field_id")>
				<cfif isdefined("attributes.is_multi_selection") and attributes.is_multi_selection eq 1>
					if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.#attributes.field_id#.value == '')
						<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.#attributes.field_id#.value = p_cat_id;
					else
						<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.#attributes.field_id#.value = document.#attributes.field_id#.value + ',' + p_cat_id;
				<cfelse>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.#attributes.field_id#.value = p_cat_id;
				</cfif>
			</cfif>
			<cfif isdefined("attributes.field_name")>
				<cfif isdefined("attributes.is_multi_selection") and attributes.is_multi_selection eq 1>
					if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.#attributes.field_name#.value == '')
						<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.#attributes.field_name#.value = p_cat;
					else
						<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.#attributes.field_name#.value = <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.#attributes.field_name#.value + ',' + p_cat;
				<cfelse>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.#attributes.field_name#.value = p_cat;
				</cfif>
			</cfif>
		<cfelse>
			<cfif isdefined("attributes.field_id")>
				if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('#attributes.field_id#') != undefined)
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('#attributes.field_id#').value = p_cat_id;
				else
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.#attributes.field_id#.value = p_cat_id;
			</cfif>
			<cfif isdefined("attributes.field_name")>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.#attributes.field_name#.value = p_cat;
			</cfif>
		</cfif>
		<cfif isdefined("attributes.field_code")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.#attributes.field_code#.value = p_cat_code;
		</cfif>
		<cfif isdefined("attributes.field_hierarchy")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.#attributes.field_hierarchy#.value=p_cat_code;
		</cfif>
		<cfif isdefined("attributes.field_min")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.#attributes.field_min#.value = p_min;
		</cfif>
		<cfif isdefined("attributes.field_max")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.#attributes.field_max#.value = p_max;
		</cfif>
		<cfif isdefined("attributes.is_select")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.calistir();
		</cfif>	
		<cfif isdefined("attributes.process") and attributes.process is "purchase_contract">
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.form_basket.submit();
		</cfif>
		<cfif isdefined('attributes.caller_function')>
			<cfif not isdefined("attributes.draggable")>window.opener.</cfif>#attributes.caller_function#(<cfif isdefined('attributes.caller_function_paremeter')><cfoutput>#attributes.caller_function_paremeter#</cfoutput></cfif>);
		</cfif>
		<cfif (isdefined("attributes.is_multi_selection") and attributes.is_multi_selection eq 0) or not isdefined("attributes.is_multi_selection")>
			<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>');</cfif>
		</cfif>
		<cfif isdefined("attributes.order_cat") and isdefined("attributes.is_multi_selection") and attributes.is_multi_selection eq 1>
			x = <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.order_cat#</cfoutput>.length;
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.order_cat#</cfoutput>.length = parseInt(x + 1);
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.order_cat#</cfoutput>.options[x].value = p_cat_id;
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.order_cat#</cfoutput>.options[x].text = p_cat;
		</cfif>
	</cfif>
	</cfoutput>
}	
function showHier(hierarchy){
	if($("#showImage"+hierarchy).hasClass('show')){
		$("#showImage"+hierarchy).removeClass('show').addClass('hide');
		$("#hideImage"+hierarchy).removeClass('hide').addClass('show');
		$("tr.sub"+hierarchy).removeClass('hide').addClass('show');
	}
	else{
		$("#showImage"+hierarchy).removeClass('hide').addClass('show');
		$("#hideImage"+hierarchy).removeClass('show').addClass('hide');
		$("tr[test^="+hierarchy+"]").removeClass('show').addClass('hide');
		$("#main"+hierarchy).show();
		$("[id^=hideImage"+hierarchy+"]").removeClass('show').addClass('hide');
		$("[id^=showImage"+hierarchy+"]").removeClass('hide').addClass('show');
	}
}
</script>
