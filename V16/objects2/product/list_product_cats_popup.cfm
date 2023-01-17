<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.is_form_submitted" default="0">
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
		PCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">
	ORDER BY
		PC.HIERARCHY
</cfquery>

<cfif isDefined("attributes.is_form_submitted") and attributes.is_form_submitted eq 1>
    <cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
        SELECT
            PC.HIERARCHY,
            PC.PRODUCT_CAT,
            PC.IS_SUB_PRODUCT_CAT,
            PC.PRODUCT_CATID,
            PC.PROFIT_MARGIN,
            PC.PROFIT_MARGIN_MAX,
            PC.POSITION_CODE,
            PC.POSITION_CODE2
        FROM
            PRODUCT_CAT PC,
            PRODUCT_CAT_OUR_COMPANY PCO
        WHERE 
            PC.PRODUCT_CATID IS NOT NULL AND
            PCO.PRODUCT_CATID = PC.PRODUCT_CATID AND
            PCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">
			<cfif isDefined('attributes.category') and len(attributes.category)>
                AND HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.category#%">
            </cfif>
            <cfif isDefined('attributes.keyword') and len(attributes.keyword)>
                AND (PC.PRODUCT_CAT LIKE '<cfif len(attributes.keyword) neq 1>%</cfif>#attributes.keyword#%' OR PC.HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">)
            </cfif>
            <cfif len(attributes.employee) and len(employee_id)>
                AND (PC.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#employee_id#"> OR PC.POSITION_CODE2 = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">)
            </cfif>
        ORDER BY
            PC.HIERARCHY
    </cfquery>
<cfelse>
	<cfset get_product_cat.recordcount=0>
</cfif>
<cfset url_string = ''>
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
<cfif isdefined('attributes.caller_function')>
	<cfset url_string = "#url_string#&caller_function=#attributes.caller_function#">
</cfif>
<cfset url_string2 = ''>
<cfif len(attributes.employee)>
	<cfset url_string2 = "#url_string#&employee=#attributes.employee#&employee_id=#attributes.employee_id#">
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.totalrecords" default="#get_product_cat.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="search_product_cat" action="#request.self#?fuseaction=#attributes.fuseaction##url_string#" method="post"><!--- #url_string# --->
	<cfoutput>
    <cfif isdefined("attributes.product_catid")>
        <input type="hidden" name="product_catid" id="product_catid" value="#attributes.product_catid#">
    </cfif>
    <cfif isdefined("attributes.field_id")>
        <input type="hidden" name="field_id" id="field_id" value="#attributes.field_id#">
    </cfif>
    <cfif isdefined("attributes.field_hierarchy")>
        <input type="hidden" name="field_hierarchy" id="field_hierarchy" value="#attributes.field_hierarchy#">
    </cfif>
    <cfif isdefined("attributes.field_name")>
        <input type="hidden" name="field_name" id="field_name" value="#attributes.field_name#">
    </cfif>
    <cfif isdefined("attributes.field_code")>
        <input type="hidden" name="field_code" id="field_code" value="#attributes.field_code#">
    </cfif>
    <cfif isdefined("attributes.field_min")>
        <input type="hidden" name="field_min" id="field_min" value="#attributes.field_min#">
    </cfif>
    <cfif isdefined("attributes.field_max")>
        <input type="hidden" name="field_max" id="field_max" value="#attributes.field_max#">
    </cfif>
    <cfif isdefined("attributes.is_sub_category")>
        <input type="hidden" name="is_sub_category" id="is_sub_category" value="#attributes.is_sub_category#">
    </cfif>
    <cfif isdefined("attributes.is_multi_selection")>
        <input type="hidden" name="is_multi_selection" id="is_multi_selection" value="#attributes.is_multi_selection#">
    </cfif>
    </cfoutput>
    <table cellpadding="0" cellspacing="0" align="center" class="color-border" style="width:98%; height:35px;">
        <tr>
            <td class="headbold">Ürün Kategorileri</td>
            <td>
                <table style="text-align:right;">
					<tr>
						<cfinput type="hidden" name="is_form_submitted" value="1">
						<td><cf_get_lang_main no='48.Filtre'></td>
						<td><cfinput type="Text" name="keyword" maxlength="255" value="#attributes.keyword#"></td>
						<td><cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;"></td>
						<td><cf_wrk_search_button></td>
					</tr>
				</table>
				<!---<table style="text-align:right;">
					<tr>
						<td>    
							<select name="category" id="category" style="width:225px;">
								<option value="" selected><cf_get_lang_main no='725.Kategoriler'></option>
								<cfoutput query="GET_PRODUCT_CATS">
									<option value="#hierarchy#" <cfif attributes.category is hierarchy>selected</cfif>>#hierarchy# - #product_cat#</option>
								</cfoutput>
							</select>
						</td>
						<td><cf_get_lang_main no='132.Sorumlu'>
					   
							<input type="hidden" name="employee_id" id="employee_id"  value="<cfif len(attributes.employee_id) and len(attributes.employee)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
							<input type="text" name="employee" id="employee" style="width:135px;" value="<cfif len(attributes.employee_id) and len(attributes.employee)><cfoutput>#attributes.employee#</cfoutput></cfif>" maxlength="255">
						</td>
						<td>
							<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_id=search_product_cat.employee_id&field_name=search_product_cat.employee&select_list=1','list');"><img src="/images/plus_thin.gif"></a>
						</td>
					</tr>
				</table>--->
            </td>
        </tr>
    </table>
</cfform>

<table border="0" align="center" cellpadding="0" cellspacing="0" style="width:98%;">
	<thead>
        <tr class="color-header" style="height:22px;">
            <th class="form-title"><cf_get_lang_main no='1173.Kod'></th>
            <th class="form-title"><cf_get_lang_main no='74.Kategori'></th>
            <th class="form-title">Min Marj(%)</th>
            <th class="form-title">Max Marj(%)</th>
        </tr>
    </thead>
    <tbody>
	<cfif get_product_cat.recordcount>
    	<cfoutput query="get_product_cat" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
      		<tr style="height:20px;">
				<cfset cont="#hierarchy#">
                <cfset pro_cont=product_cat>
                <cfset rm = '#chr(13)#'>
                <cfset cont = ReplaceList(cont,rm,'')>
                <cfset pro_cont = ReplaceList(pro_cont,rm,'')>
                <cfset rm = '#chr(10)#'>
                <cfset cont = ReplaceList(cont,rm,'')>
                <cfset pro_cont = ReplaceList(pro_cont,rm,'')>
                <cfset pro_cont = ReplaceList(pro_cont,"'",' ')>
                <cfset pro_cont = Replace(pro_cont,"&",'','all')>
                <cfset hierarchy_ = Replace(hierarchy,"&",'','all')>
                <cfset cont = Replace(cont,"&",'','all')>
                <cfif is_sub_product_cat is 0><!--- altinda kategori yok ise --->
                    <td><a href="javascript://" class="tableyazi" onclick="gonder('#product_catid#','#hierarchy_# #pro_cont#','#hierarchy#','<cfif isnumeric(profit_margin)>#tlformat(profit_margin)#<cfelse>#tlformat(0)#</cfif>','<cfif isnumeric(profit_margin_max)>#tlformat(profit_margin_max)#<cfelse>#tlformat(0)#</cfif>');">#hierarchy#</a></td>
                    <td>
                        <cfloop from="1" to="#listlen(hierarchy,'.')#" index="i">&nbsp;</cfloop>
                        <a href="javascript://" class="tableyazi" onclick="gonder('#product_catid#','#cont# #pro_cont#','#cont#','<cfif isnumeric(profit_margin)>#tlformat(profit_margin)#<cfelse>#tlformat(0)#</cfif>','<cfif isnumeric(profit_margin_max)>#tlformat(profit_margin_max)#<cfelse>#tlformat(0)#</cfif>');">#product_cat#</a>
                    </td>
                <cfelse>
                    <td>
                      <cfif attributes.is_sub_category lte listlen(hierarchy,'.') and attributes.is_sub_category neq 0>
                        <a href="javascript://" class="tableyazi" onclick="gonder('#product_catid#','#hierarchy# #pro_cont#','#hierarchy#','<cfif isnumeric(profit_margin)>#tlformat(profit_margin)#<cfelse>#tlformat(0)#</cfif>','<cfif isnumeric(profit_margin_max)>#tlformat(profit_margin_max)#<cfelse>#tlformat(0)#</cfif>');">#hierarchy#</a>
                      <cfelse>
                        #hierarchy#
                      </cfif>
                    </td>
                    <td>
                      <cfloop from="1" to="#listlen(hierarchy,'.')#" index="i">&nbsp;</cfloop>					
                      <cfif attributes.is_sub_category lte listlen(hierarchy,'.') and attributes.is_sub_category neq 0>
                        <a href="javascript://" class="tableyazi" onclick="gonder('#product_catid#','#hierarchy# #pro_cont#','#hierarchy#','<cfif isnumeric(profit_margin)>#tlformat(profit_margin)#<cfelse>#tlformat(0)#</cfif>','<cfif isnumeric(profit_margin_max)>#tlformat(profit_margin_max)#<cfelse>#tlformat(0)#</cfif>');">#product_cat#</a>
                      <cfelse>
                        #product_cat#
                      </cfif>
                    </td>
                </cfif>
        		<td style="text-align:right;"><cfif isnumeric(profit_margin)>#tlformat(profit_margin)#<cfelse>#tlformat(0)#</cfif></td>
        		<td style="text-align:right;"><cfif isnumeric(profit_margin_max)>#tlformat(profit_margin_max)#<cfelse>#tlformat(0)#</cfif></td>
      		</tr>
    	</cfoutput>
    <cfelse>
    	<tr>
    		<td colspan="4" class="color-row"><cfif isDefined('attributes.is_form_submitted') and attributes.is_form_submitted eq 0><cf_get_lang_main no='289. Filtre Ediniz'>!<cfelse><cf_get_lang_main no='72.Kayit Bulunamadi'>!</cfif><br/>
    	</tr>
    </cfif>
    </tbody>
</table>

<cfif attributes.totalrecords gt attributes.maxrows>
  	<table cellpadding="0" cellspacing="0" border="0" align="center" style="width:99%; height:35px;">
		<tr>
	  		<td>
            	<cfset adres = attributes.fuseaction>
                <cfset adres = "#adres#&is_form_submitted=1">
				<cfif len(attributes.keyword)>
                    <cfset adres = "#adres#&keyword=#attributes.keyword#">
                </cfif>
                <cfif len(attributes.category)>
                    <cfset adres = "#adres#&category=#attributes.category#">
                </cfif>
                <cfif len(attributes.employee)>
                    <cfset adres = "#adres#&employee=#attributes.employee#&employee_id=#attributes.employee_id#">
                </cfif>
            	<cf_pages page="#attributes.page#" 
                    maxrows="#attributes.maxrows#" 
                    totalrecords="#attributes.totalrecords#" 
                    startrow="#attributes.startrow#" 
                    adres="#adres#">
            </td>
	 		<!-- sil --><td style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
		</tr>
  	</table>
</cfif>

<script type="text/javascript">
	document.getElementById('keyword').focus();
	function gonder(p_cat_id,p_cat,p_cat_code,p_min,p_max)
	{
		<cfoutput>
		<!---<cfif isdefined('attributes.call_function')>
			var sayac = opener.document.all.row_count.value;
			window.opener.#attributes.call_function#(sayac++,p_cat_id,p_cat,p_cat_code);
			opener.document.all.row_count.value=sayac++;
		<cfelse>--->
			<cfif isdefined('attributes.field_id') and listlen(attributes.field_id,'.') eq 2>
				<cfif isdefined("attributes.field_id")>
					<cfif isdefined("attributes.is_multi_selection") and attributes.is_multi_selection eq 1>
						if(window.opener.document.#attributes.field_id#.value == '')
							window.opener.document.#attributes.field_id#.value = p_cat_id;
						else
							window.opener.document.#attributes.field_id#.value = window.opener.document.#attributes.field_id#.value + ',' + p_cat_id;
					<cfelse>
						window.opener.document.#attributes.field_id#.value = p_cat_id;
					</cfif>
				</cfif>
				<cfif isdefined("attributes.field_name")>
					<cfif isdefined("attributes.is_multi_selection") and attributes.is_multi_selection eq 1>
						if(window.opener.document.#attributes.field_name#.value == '')
							window.opener.document.#attributes.field_name#.value = p_cat;
						else
							window.opener.document.#attributes.field_name#.value = window.opener.document.#attributes.field_name#.value + ',' + p_cat;
					<cfelse>
						window.opener.document.#attributes.field_name#.value = p_cat;
					</cfif>
				</cfif>
			<cfelse>
				<cfif isdefined("attributes.field_id")>
					window.opener.document.all.#attributes.field_id#.value = p_cat_id;
				</cfif>
				<cfif isdefined("attributes.field_name")>
					window.opener.document.all.#attributes.field_name#.value = p_cat;
				</cfif>
			</cfif>
			<cfif isdefined("attributes.field_code")>
				window.opener.document.#attributes.field_code#.value = p_cat_code;
			</cfif>
			<cfif isdefined("attributes.field_hierarchy")>
				window.opener.document.#attributes.field_hierarchy#.value=p_cat_code;
			</cfif>
			<cfif isdefined("attributes.field_min")>
				window.opener.document.#attributes.field_min#.value = p_min;
			</cfif>
			<cfif isdefined("attributes.field_max")>
				window.opener.document.#attributes.field_max#.value = p_max;
			</cfif>
			<cfif isdefined("attributes.is_select")>
				window.opener.document.calistir();
			</cfif>	
			<cfif isdefined("attributes.process") and attributes.process is "purchase_contract">
				window.opener.document.form_basket.submit();
			</cfif>
			<cfif isdefined('attributes.caller_function')>
				window.opener.#attributes.caller_function#();
			</cfif>
			<cfif (isdefined("attributes.is_multi_selection") and attributes.is_multi_selection eq 0) or not isdefined("attributes.is_multi_selection")>
				self.close();
			</cfif>
		<!---</cfif>--->
		</cfoutput>
	}	
</script>
