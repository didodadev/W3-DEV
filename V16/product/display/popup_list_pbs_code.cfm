<cf_get_lang_set module_name="product">
<cfsetting showdebugoutput="yes">
<cfparam name="attributes.is_special" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.pbs_cat_id" default="">
<cfparam name="attributes.sub_pbscode" default="-1">
<cfparam name="attributes.is_price" default="0">
<cfif isdefined('attributes.is_submitted') and len(attributes.is_submitted)>
	<cfquery name="get_pbs_code" datasource="#dsn3#">
		SELECT 
			SPC.PBS_ID,
			SPC.PBS_CODE,
			SPC.PBS_DETAIL,
			SPC.PBS_DETAIL2
		FROM 
			SETUP_PBS_CODE SPC
			<cfif isdefined('attributes.product_id') and len(attributes.product_id) or isdefined('attributes.project_id') and len(attributes.project_id)>
				,RELATION_PBS_CODE RPC
			</cfif>
		WHERE 
			SPC.IS_ACTIVE = 1
			<cfif attributes.is_special eq 1>AND SPC.IS_SPECIAL = 1<cfelseif attributes.is_special eq 0>AND SPC.IS_SPECIAL = 0</cfif>
			<cfif len(attributes.pbs_cat_id)>
				AND SPC.PBS_CAT_ID = #attributes.pbs_cat_id#
			</cfif>
			<cfif attributes.sub_pbscode neq -1>
				AND len(replace(SPC.PBS_CODE, '.', '.' + ' ')) - len(SPC.PBS_CODE) <= #attributes.sub_pbscode# 
			</cfif>
			<cfif len(attributes.keyword)>
				AND (SPC.PBS_CODE LIKE '#attributes.keyword#%' OR
				SPC.PBS_DETAIL LIKE '#attributes.keyword#%' OR
				SPC.PBS_DETAIL2 LIKE '#attributes.keyword#%')
			</cfif>
			<cfif isdefined('attributes.project_id') and len(attributes.project_id)>
				AND RPC.PBS_ID = SPC.PBS_ID
				AND RPC.PROJECT_ID = #attributes.project_id#
			<cfelseif isdefined('attributes.product_id') and len(attributes.product_id)>
				AND RPC.PBS_ID = SPC.PBS_ID
				AND RPC.PRODUCT_ID = #attributes.product_id#
			</cfif>
		ORDER BY
			SPC.PBS_CODE
	</cfquery>
<cfelse>
	<cfset get_pbs_code.recordcount = 0>
</cfif>
<cfquery name="get_pbs_cat" datasource="#dsn3#">
	SELECT PBS_CAT_ID,PBS_CAT_NAME FROM SETUP_PBS_CAT
</cfquery>
<cfquery name="get_max_len" datasource="#dsn3#">
	SELECT ISNULL(MAX(len(replace(SETUP_PBS_CODE.PBS_CODE, '.', '.' + ' ')) - len(SETUP_PBS_CODE.PBS_CODE)),0) MAX_LEN FROM SETUP_PBS_CODE
</cfquery>
<cfparam name='attributes.totalrecords' default='#get_pbs_code.recordcount#'>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset url_string = "">
<cfif isdefined("attributes.record_num_")>
	<cfset url_string = "#url_string#&record_num_=#attributes.record_num_#">
</cfif>
<cfif isdefined("attributes.is_single")>
	<cfset url_string = "#url_string#&is_single=#attributes.is_single#">
</cfif>
<cfif isdefined("attributes.is_special")>
	<cfset url_string = "#url_string#&is_special=#attributes.is_special#">
</cfif>
<cfif isdefined("attributes.field_id")>
	<cfset url_string = "#url_string#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.field_name")>
	<cfset url_string = "#url_string#&field_name=#attributes.field_name#">
</cfif>
<cfif isdefined("attributes.field_is_price")>
	<cfset url_string = "#url_string#&field_is_price=#attributes.field_is_price#">
</cfif>
<cfif isdefined("attributes.project_id")>
	<cfset url_string = "#url_string#&project_id=#attributes.project_id#">
</cfif>
<cfif isdefined("attributes.product_id")>
	<cfset url_string = "#url_string#&product_id=#attributes.product_id#">
</cfif>
<cfif isdefined("attributes.is_from_basket")>
	<cfset url_string = "#url_string#&is_from_basket=#attributes.is_from_basket#">
</cfif>
<cfif isdefined("attributes.row_count")>
	<cfset url_string = "#url_string#&row_count=#attributes.row_count#">
</cfif>
<cfif isdefined("attributes.row_id")>
	<cfset url_string = "#url_string#&row_id=#attributes.row_id#">
</cfif>
<cfif isdefined("attributes.form_name")>
	<cfset url_string = "#url_string#&form_name=#attributes.form_name#">
</cfif>
<cfform action="#request.self#?fuseaction=#fusebox.circuit#.popup_list_pbs_code#url_string#" method="post" name="search_pbs_code">
<input type="hidden" name="is_submitted" id="is_submitted" value="1">
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='37058.PBS Kodları'></cfsavecontent>
	<cf_big_list_search title="#message#">
		<cf_big_list_search_area>
	<div class="row form-inline">	
		<div class="form-group" id="item-keyword">
			<div class="input-group x-12">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
						<cfinput type="text" name="keyword" maxlength="50" placeholder="#message#" value="#attributes.keyword#" style="width:100px;">
					</div>
				</div>
		<div class="form-group" id="item-pbs_cat_id">
        	<div class="input-group x-12">			
						<select name="pbs_cat_id" id="pbs_cat_id">
							<option value=""><cf_get_lang dictionary_id='37088.PBS Kategorisi'></option>
							<cfoutput query="get_pbs_cat">
								<option value="#pbs_cat_id#" <cfif pbs_cat_id eq attributes.pbs_cat_id>selected</cfif>>#pbs_cat_name#</option>
							</cfoutput>
						</select>
					</div>
				</div>	
		<div class="form-group" id="item-sub_pbscode">
        	<div class="input-group x-12">
						<select name="sub_pbscode" id="sub_pbscode">
							<option value="0" <cfif attributes.sub_pbscode eq 0>selected</cfif>><cf_get_lang dictionary_id='37113.Üst Kırılımlar'></option>
							<cfloop from="1" to="#get_max_len.max_len#" index="kk">
								<option value="<cfoutput>#kk#</cfoutput>" <cfif attributes.sub_pbscode eq kk>selected</cfif>><cfoutput>#kk#</cfoutput>.<cf_get_lang dictionary_id="37450.Kırılımlar"></option>
							</cfloop>
							<option value="-1" <cfif attributes.sub_pbscode eq -1>selected</cfif>><cf_get_lang dictionary_id='37108.Tüm Kırılımlar'></option>
						</select>
					</div>
				</div>	
		<div class="form-group" id="item-is_special">
        	<div class="input-group x-12">
						<select name="is_special" id="is_special">
							<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
							<option value="1"<cfif attributes.is_special eq 1>selected</cfif>><cf_get_lang dictionary_id='57979.Özel'></option>
							<option value="0"<cfif attributes.is_special eq 0>selected</cfif>><cf_get_lang dictionary_id='29954.Genel'></option>
						</select>
					</div>
				</div>	
		<div class="form-group" id="item-is_price">
        	<div class="input-group x-8">
					<cf_get_lang no='96.Fiyatları Düşür'><input type="checkbox" name="is_price" id="is_price" value="1" <cfif attributes.is_price eq 1>checked</cfif>/>
					</div>
		<div class="form-group x-3_5">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
					</div>
		<div class="form-group">			
					<cf_wrk_search_button>
					</div>          
				</div>
		</cf_big_list_search_area>
	</cf_big_list_search>
</cfform> 
<cf_medium_list>
	<thead>
		<tr>
			<th width="25"><cf_get_lang dictionary_id='57487.No'></th>
			<th><cf_get_lang dictionary_id='37123.PBS Kod'></th>
			<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
			<th><cf_get_lang dictionary_id='57629.Açıklama'>2</th>
			<cfif not isdefined('attributes.is_single')>
			<th width="20">
			<cfif attributes.totalrecords neq 0><input type="Checkbox" name="all" id="all" value="1" onClick="javascript: hepsi();"></cfif>
			</th>
			</cfif>
		</tr>
	</thead>
	<tbody>
		<cfif get_pbs_code.recordcount>
			<form name="form_name" method="post" action="<cfoutput>#request.self#</cfoutput>?fuseaction=product.emptypopup_add_product_pbs_code_row">
				<cfoutput>
					<cfif isdefined("attributes.record_num_")><input type="hidden" name="record_num_" id="record_num_" value="#attributes.record_num_#"></cfif>
					<input type="hidden" name="fuseaction_name" id="fuseaction_name" value="#attributes.fuseaction#" />
				</cfoutput>
				<cfoutput query="get_pbs_code" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td width="30">#currentrow#</td>
						<td><cfif isdefined('attributes.is_single')>
								<a href="javascript://" class="tableyazi" onclick="gonder('#pbs_id#','#pbs_code#','#attributes.is_price#');">#pbs_code#&nbsp;</a>
							<cfelse>
								#pbs_code#
							</cfif>
						</td>
						<td>#pbs_detail#</td>
						<td>#pbs_detail2#</td>
						<cfif not isdefined('attributes.is_single')>
							<td><input type="checkbox" value="#pbs_id#" name="pbs_ids" id="pbs_ids"></td>
						</cfif>
					</tr>
				</cfoutput>
				<cfif not isdefined('attributes.is_single')>
				<tfoot>
					<tr>
						<td colspan="5" style="text-align:right;"><input type="submit" value="<cf_get_lang dictionary_id ='57461.Kaydet'>" onClick="return add_checked();"></td>
					</tr>
					</tfoot>
				</cfif>
			</form>
		<cfelse>
			<tr>
				<td colspan="5"><cfif isdefined('attributes.is_submitted') and len(attributes.is_submitted)><cf_get_lang dictionary_id='57484.Kayıt Yok'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
			</tr>
		</cfif>
	</tbody>
</cf_medium_list>
<cf_popup_box_footer>
<cfif attributes.totalrecords gt attributes.maxrows>
	<table width="99%" align="center" cellpadding="0" cellspacing="0" height="35">
		<tr>
			<td><cf_pages 
				page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#fusebox.circuit#.#fusebox.fuseaction##url_string#">
			</td>
			<td style="text-align:right;"><cf_get_lang dictionary_id='57540.Toplam Kayıt'><cfoutput>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
		</tr>
	</table>
</cfif>  
</cf_popup_box_footer>
<script type="text/javascript">
search_pbs_code.keyword.focus();
function hepsi()
{
	if (document.getElementById('all').checked)
	{
		<cfif attributes.totalrecords gt 1 and attributes.maxrows gt 1>	
			for(var i=0;i<form_name.pbs_ids.length;i++) form_name.pbs_ids[i].checked = true;
		<cfelseif attributes.totalrecords eq 1 or attributes.maxrows eq 1>
			form_name.pbs_ids.checked = true;
		</cfif>
			}
		else
			{
		<cfif attributes.totalrecords gt 1 and attributes.maxrows gt 1>	
			for(var i=0;i<form_name.pbs_ids.length;i++) form_name.pbs_ids[i].checked = false;
		<cfelseif attributes.totalrecords eq 1>
			form_name.pbs_ids.checked = false;
		</cfif>
	}
}
function add_checked()
{
	var counter = 0;
	<cfif attributes.totalrecords gt 1 and attributes.maxrows gt 1>	
		for (var i=0 ; i < form_name.pbs_ids.length ; i++) 
			if (form_name.pbs_ids[i].checked == true) 
			{
				counter = counter + 1;
			}
			if (counter == 0)
			{
				alert("<cf_get_lang dictionary_id='37131.PBS Kodu Seçmelisiniz'> !");
				return false;
			}
	<cfelseif attributes.totalrecords eq 1 or attributes.maxrows eq 1>
		if (form_name.pbs_ids.checked == true) 
		{
			counter = counter + 1;
		}
		if (counter == 0)
		{
			alert("<cf_get_lang dictionary_id='37131.PBS Kodu Seçmelisiniz'> !");
			return false;
		}
	</cfif>
}
function gonder(id,code,price_)
{	
	<cfif isdefined("attributes.row_id") and isdefined('attributes.row_count')><!--- Basketten geliyorsa --->
		<cfif attributes.row_count neq 1>
			<cfif isdefined("attributes.field_id")>
				opener.document.<cfoutput>#form_name#.#field_id#[#attributes.row_id-1#]</cfoutput>.value = id;
			</cfif>
			<cfif isdefined("attributes.field_name")>
				opener.document.<cfoutput>#form_name#.#field_name#[#attributes.row_id-1#]</cfoutput>.value = code;	
			</cfif>	
		<cfelse>
			<cfif isdefined("attributes.field_id")>
				opener.document.<cfoutput>#form_name#.#field_id#</cfoutput>.value = id;
			</cfif>
			<cfif isdefined("attributes.field_name")>
				opener.document.<cfoutput>#form_name#.#field_name#</cfoutput>.value = code;
			</cfif>
		</cfif>
	<cfelse>
		<cfif isdefined("attributes.field_is_price")>
			<cfif listlen(attributes.field_is_price,'.') eq 2>
				window.opener.document.<cfoutput>#attributes.field_is_price#</cfoutput>.value = price_;
			<cfelse>
				window.opener.document.all.<cfoutput>#attributes.field_is_price#</cfoutput>.value = price_;
			</cfif>
		</cfif>
		<cfif isdefined("attributes.field_id")>
			<cfif listlen(attributes.field_id,'.') eq 2>
				window.opener.document.<cfoutput>#attributes.field_id#</cfoutput>.value = id;
			<cfelse>
				window.opener.document.all.<cfoutput>#attributes.field_id#</cfoutput>.value = id;
			</cfif> 
		</cfif>
		<cfif isdefined("attributes.field_name")>
			<cfif listlen(attributes.field_name,'.') eq 2>
				window.opener.document.<cfoutput>#attributes.field_name#</cfoutput>.value = code;
				window.opener.document.<cfoutput>#attributes.field_name#</cfoutput>.focus();
			<cfelse>
				window.opener.document.all.<cfoutput>#attributes.field_name#</cfoutput>.value = code;
				window.opener.document.all.<cfoutput>#attributes.field_name#</cfoutput>.focus();
			</cfif>
		</cfif>
	</cfif>
	window.close();
}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
