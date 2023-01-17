<div style="position:absolute; margin:35px; left:200px; z-index:99;" id="showCategory"></div>
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.demand_type" default="">
<cfparam name="attributes.is_status" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.company_name" default="">
<cfparam name="product_catid" default="">
<cfparam name="product_cat" default="">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.page" default="1">

<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif len(attributes.start_date)><cf_date tarih = "attributes.start_date"></cfif>
<cfif len(attributes.finish_date)><cf_date tarih = "attributes.finish_date"></cfif>

<cfset cmp = createObject("component","V16.worknet.query.worknet_demand") />
<cfset getProcess = createObject("component","V16.worknet.query.worknet_process").getProcess(fuseaction:attributes.fuseaction)/>


<cfif isdefined('attributes.form_submitted')>
	<cfset getDemand = cmp.getDemand(
			keyword:attributes.keyword,
			sector:attributes.sector,
			demand_type:attributes.demand_type,
			demand_stage:attributes.demand_stage,
			is_status:attributes.is_status,
			company_name:attributes.company_name,
			company_id:attributes.company_id,
			product_catid:attributes.product_catid,
			product_cat:attributes.product_cat,
			start_date:attributes.start_date,
			finish_date:attributes.finish_date
		) 
	/>
<cfelse>
	<cfset getDemand.recordcount = 0>
</cfif>

<cfparam name="attributes.totalrecords" default="#getDemand.recordcount#">
<cfform name="search_demand" id="search_demand" method="post" action="#request.self#?fuseaction=test.popup_listele_deneme"> 
    <cf_medium_list_search title="Talepler">
        <cf_medium_list_search_area>
        <table>
            <tr>
                <td>
                	<input type="hidden" name="field_id" id="field_id" value="<cfif isdefined("attributes.field_id")><cfoutput>#attributes.field_id#</cfoutput></cfif>" />
                    <input type="hidden" name="field_name" id="field_name" value="<cfif isdefined("attributes.field_name")><cfoutput>#attributes.field_name#</cfoutput></cfif>" />
                    <input type="hidden" value="1" id="form_submitted" name="form_submitted" />
                    <cf_get_lang_main no='48.Filtre'> 
                    <cfinput type="text" tabindex="1" name="keyword" id="keyword" value="" maxlength="50" style="width:120px;">
                </td>
                <td>
                     Yayin Tarihi
                    <input type="text" name="start_date" id="start_date" value="<cfif len(attributes.start_date)><cfoutput>#dateformat(attributes.start_date,dateformat_style)#</cfoutput></cfif>" maxlength="10" style="width:65px;">
                    <cf_wrk_date_image date_field="start_date">
                </td>
                <td>
                     <input type="text" name="finish_date" id="finish_date" value="<cfif len(attributes.finish_date)><cfoutput>#dateformat(attributes.finish_date,dateformat_style)#</cfoutput></cfif>" maxlength="10" style="width:65px;">
                     <cf_wrk_date_image date_field="finish_date">
                </td>
                <td>
                    <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" tabindex="3" name="maxrows" id="maxrows" required="yes" onKeyUp="isNumber(this)" maxlength="3" value="#attributes.maxrows#" validate="integer" range="1,250" message="#message#" style="width:25px;">
                </td>
                <td>
                    <td><cf_wrk_search_button is_excel="0"></td>
                </td>
            </tr>
        </table>
        </cf_medium_list_search_area>
        <cf_medium_list_search_detail_area>
        <table>
            <tr>
                <td>
                    Üye
                    <input type="hidden"  id="company_id" name="company_id" />
                    <input type="text" name="company_name" id="company_name" />
                    <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=search_demand.company_id&field_comp_name=search_demand.company_name&select_list=2</cfoutput>&keyword='+encodeURIComponent(search_demand.company_name.value),'list','popup_list_pars');"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>
                </td>
                <td>
                    Ürün Kategorileri
                    <input type="hidden" name="product_catid" id="product_catid" value="<cfif isdefined('attributes.product_catid') and len(attributes.product_catid)><cfoutput>#attributes.product_catid#</cfoutput></cfif>" />
                    <input type="text" name="product_cat" id="product_cat" style="width:130px;" value="<cfif isdefined('attributes.product_cat') and len(attributes.product_cat)><cfoutput>#attributes.product_cat#</cfoutput><cfelse><cf_get_lang_main no='155.Ürün Kategorileri'></cfif>"/> <!---onfocus="goster(showCategory);openProductCat();"--->
                    <a href="javascript://" onClick="goster(showCategory);openProductCat();" class="tableyazi"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>
                </td>
                <td>
                    <select name="demand_type" id="demand_type" style="width:85px;">
                        <option value="">Talep Turu</option>
                        <option value="1" <cfif attributes.demand_type eq 1>selected</cfif>>Alım</option>
                        <option value="2" <cfif attributes.demand_type eq 2>selected</cfif>>Satım</option>
                    </select>
                </td>
           </tr>
        </table>
        <table align="right">
           <tr>     
                <td>
                    <select name="is_status" id="is_status" style="width:90px;">
                        <option value=""><cf_get_lang_main no ='344.Durum'></option>
                        <option value="1" <cfif attributes.is_status eq 1>selected</cfif>><cf_get_lang_main no ='81.Aktif'></option>
                        <option value="0" <cfif attributes.is_status eq 0>selected</cfif>><cf_get_lang_main no ='82.Pasif'></option>
                    </select>
                </td>
                <td>
                    <cfsavecontent variable="text"><cf_get_lang_main no='167.Sektör'></cfsavecontent>
                    <cfif isdefined("attributes.sector") and len(attributes.sector)><cfset attributes.sector = attributes.sector><cfelse><cfset attributes.sector = ''></cfif>
                    <cf_wrk_selectlang 
                        name="sector"
                        option_name="sector_cat"
                        option_value="sector_cat_id"
                        width="100"
                        table_name="SETUP_SECTOR_CATS"
                        option_text="#text#" value="#attributes.sector#">
                </td>
                <td>
                    <!--- Asama --->
                    <select name="demand_stage" id="demand_stage" style="width:90px;">
                        <option value=""><cf_get_lang_main no='70.Aşama'></option>
                        <cfoutput query="getProcess">
                            <option value="#process_row_id#" <cfif attributes.demand_stage eq process_row_id>selected</cfif>>#stage#</option>
                        </cfoutput>
                     </select>
                </td>
            </tr>
        </table>	
        </cf_medium_list_search_detail_area>
    </cf_medium_list_search>  
</cfform>

<cf_medium_list>
    <thead>
        <tr>
            <th>Talep</th>
            <th>Şirket</th>
            <th>Aşama</th>
            <th>Yayın Tarihi</th>
        </tr>
    </thead> 
    <tbody>
        <cfif getDemand.recordcount>
            <cfoutput query="getDemand" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
            <tr>
                     <td><a href="javascript://" onclick="atama('#demand_id#','#demand_head#');" class="tableyazi">#demand_head#</a></td>
                     <td>#fullname#</td>
                     <cfset getProductProcess = createObject("component","V16.worknet.query.worknet_process").getProcess(fuseaction:attributes.fuseaction,process_row_id:getDemand.stage_id)/>
                     <td>#getProductProcess.stage#</td>
                     <td>#dateformat(start_date,dateformat_style)# <cfif len(finish_date)>- #dateformat(finish_date,dateformat_style)#</cfif></td>
            </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td colspan="4"><cfif isdefined("attributes.form_submitted")><cf_get_lang_main no='72.Kayıt Bulunamadı'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz'>!</cfif></td>
           </tr>
        </cfif>
    </tbody>
</cf_medium_list>
    <!---<cf_paging page="#attributes.page#"
        maxrows="#attributes.maxrows#"
        totalrecords="#attributes.totalrecords#"
        startrow="#attributes.startrow#"
        adres="objects.#fusebox.fuseaction##url_string#">	--->
				

<script type="text/javascript">
function openProductCat()
	{
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=worknet.selected_product_cat','showCategory',1,'Loading..');
	}
function atama (d_id,d_name)
	{
		<cfif isdefined("attributes.field_id")>
			window.opener.document.<cfoutput>#attributes.field_id#</cfoutput>.value = d_id;
		</cfif>
		<cfif isdefined("attributes.field_name")>
			window.opener.document.<cfoutput>#attributes.field_name#</cfoutput>.value = d_name;
		</cfif>	
		window.close();
	}
</script>	
