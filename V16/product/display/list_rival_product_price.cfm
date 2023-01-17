<cfinclude template="../query/get_prod_unit_with_func.cfm">
<cfinclude template="../query/get_rivals.cfm">
<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.is_submit")>
	<cfinclude template="../query/get_rival_price_list.cfm">
<cfelse>
	<cfset get_rival_prices.recordcount = 0>
</cfif>
<cfif not isDefined("dsn_dev")>
	<cfset dsn_dev= dsn & '_retail' >
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.pid" default="">
<cfparam name="attributes.txt_product" default="">
<cfparam name="attributes.r_id" default="">
<cfif not len(attributes.maxrows)><cfset attributes.maxrows = 20></cfif>
<cfparam name="attributes.totalrecords" default=#get_rival_prices.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="form" id="form" action="#request.self#?fuseaction=product.list_rival_product_prices" method="post">
            <input type="hidden" name="is_submit" id="is_submit" value="1">
            <cf_box_search>
                <div class="form-group">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                    <cfinput type="text" name="keyword" id="keyword" placeholder="#message#" value="#attributes.keyword#" maxlength="50">
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfoutput>
                            <input type="hidden" name="pid" id="pid" value="#attributes.pid#"> 
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57657.Ürün'></cfsavecontent>
                            <input type="Text" style="width:150px;" name="txt_product" id="txt_product" placeholder="#message#" value="#attributes.txt_product#"> 
                            <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('#request.self#?fuseaction=objects.popup_product_names&product_id=form.pid&field_name=form.txt_product','list');"></span>
                        </cfoutput>
                    </div>
                </div>
                <div class="form-group">
                    <select name="r_id" id="r_id" style="width:150px;">
                        <option value=""><cf_get_lang dictionary_id='58779.Rakip'></option> 
                        <cfoutput query="get_rivals"> 
                            <option value="#R_ID#" <cfif attributes.r_id eq r_id>selected</cfif>>#rival_name#</option> 
                        </cfoutput> 
                    </select>
                </div>
                <div class="form-group">
                    <cfinclude template="../query/get_branch.cfm">
                    <select name="branch_id" id="branch_id" style="width:150px;">
                        <option value="0"><cf_get_lang dictionary_id='29495.Tüm Şubeler'></option>
                        <cfoutput query="get_branch">
                            <option value="#branch_id#" <cfif isDefined('attributes.branch_id') and (attributes.branch_id eq branch_id)>selected</cfif>>#branch_name#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" onKeyUp="isNumber (this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id='37026.Rakip Fiyatlar'></cfsavecontent>
    <cf_box title="#message#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr> 
                    <th width="20"><cf_get_lang dictionary_id='58577.Sira'></th>
                    <th><cf_get_lang dictionary_id='58779.Rakip'></th>
                    <th><cf_get_lang dictionary_id='61480.Fiyat Tipi'></th>
                    <th><cf_get_lang dictionary_id='57657.Ürün'></th>
                    <th><cf_get_lang dictionary_id='57636.Birim'></th>
                    <th><cf_get_lang dictionary_id='58084.Fiyat'></th>
                    <th><cf_get_lang dictionary_id='57655.Başlangıç Tarihi'></th>
                    <th><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
                    <!-- sil -->
                    <th width="20" class="header_icn_none">
                        <a href="javascript:openBoxDraggable('<cfoutput>#request.self#?fuseaction=product.list_rival_product_prices&event=add</cfoutput>')"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                    <!-- sil -->		
                </tr>
            </thead>
            <tbody>
                <cfif get_rival_prices.recordcount>
                    <cfoutput query="get_rival_prices" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
                    <tr> 
                            <td width="35">#currentrow#</td>
                            <td><a class="tableyazi" href="javascript:openBoxDraggable('#request.self#?fuseaction=product.rivals&event=upd&r_id=#r_id#');">#rival_name#</a></td>
                            <td>
                                <cfif len(PRICE_TYPE)>
                                    <cfquery name="GET_PRICE_TYPE" datasource="#dsn_dev#">
                                        SELECT TYPE_NAME FROM RIVAL_PRICE_TYPES WHERE TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRICE_TYPE#">
                                    </cfquery>
                                    #GET_PRICE_TYPE.TYPE_NAME#
                                </cfif>
                            </td>
                            <td>#PRODUCT_NAME#</td>
                            <td>#UNIT#</td>
                            <td align="right" style="text-align:right;"> <a href="javascript:openBoxDraggable('#request.self#?fuseaction=product.list_rival_product_prices&event=upd&pr_id=#pr_id#&pid=#PRODUCT_ID#');">#TLFormat(PRICE)#&nbsp;#MONEY#</a></td>
                            <td>#dateformat(STARTDATE,dateformat_style)#</td>
                            <td>#dateformat(FINISHDATE,dateformat_style)#</td>
                            <!-- sil -->
                            <td align="center"><a href="javascript:openBoxDraggable('#request.self#?fuseaction=product.list_rival_product_prices&event=upd&pr_id=#pr_id#&pid=#PRODUCT_ID#')"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                            <!-- sil -->
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr> 
                        <td colspan="8"><cfif isdefined("attributes.is_submit")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
                    </tr>
                </cfif>
            <tbody>
        </cf_grid_list>

        <cfset url_str = "">    
        <cfif len(attributes.keyword)>
            <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
        </cfif>
        <cfif isDefined("attributes.branch_id")>
            <cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
        </cfif>
        <cfif isDefined("attributes.is_submit") and len(attributes.is_submit)>
            <cfset url_str = "#url_str#&is_submit=#attributes.is_submit#">
        </cfif>
        <cfif isDefined("attributes.pid") and len(attributes.pid)>
            <cfset url_str = "#url_str#&pid=#attributes.pid#">
        </cfif>
        <cfif isDefined("attributes.r_id") and len(attributes.r_id)>
            <cfset url_str = "#url_str#&r_id=#attributes.r_id#">
        </cfif>
        <cf_paging page="#attributes.page#" 
            maxrows="#attributes.maxrows#" 
            totalrecords="#attributes.totalrecords#" 
            startrow="#attributes.startrow#" 
            adres="product.list_rival_product_prices#url_str#"> 
    </cf_box>
</div>
<script type="text/javascript">
	$('#keyword').focus();
	//document.getElementById('keyword').focus();
</script>
