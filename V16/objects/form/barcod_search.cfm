<cfparam name="attributes.page" default=1>
<cfparam name="attributes.barcod" default="">
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.totalrecords" default="">
<cfparam name="attributes.startrow" default="">
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default="100">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1 >
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfsavecontent variable='message'><cf_get_lang dictionary_id='37699.Barkod Ara'></cfsavecontent>
    <cf_box title="#message#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="search_barcod" action="#request.self#?fuseaction=objects.popup_barcod_search" method="post">
            <cf_box_search more="0">
                <div class="form-group">
                    <input type="text" placeholder="<cfoutput><cf_get_lang dictionary_id='57633.Barkod'></cfoutput>" name="barcod" id="barcod" maxlength="13" onKeyUp="isNumber(this)" style="width:150px;" value="<cfoutput>#attributes.barcod#</cfoutput>">
                </div>
                <div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3">
				</div>
                <div class="form-group"><cf_wrk_search_button button_type="4" search_function="loadPopupBox('search_barcod','#attributes.modal_id#')"></div>
            </cf_box_search>
        </cfform>
        <cf_flat_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='57633.Barkod'></th>
                    <th><cf_get_lang dictionary_id='57452.Stok'></th>
                </tr>
            </thead>
            <tbody>
                <cfif len(attributes.barcod)>
                    <cfquery name="GET_BARCODE" datasource="#DSN3#">
                        SELECT
                            PRODUCT_ID
                        FROM
                            GET_STOCK_BARCODES
                        WHERE
                            BARCODE = '#attributes.barcod#'
                    </cfquery>
                    <cfif GET_BARCODE.recordcount>
                        <cfquery name="GET_STOCKS" datasource="#DSN3#">
                            SELECT
                                GET_STOCK_BARCODES.BARCODE,
                                S.PRODUCT_ID,
                                S.PRODUCT_NAME,
                                S.STOCK_ID,
                                S.PROPERTY
                            FROM
                                GET_STOCK_BARCODES,
                                STOCKS AS S
                            WHERE
                                S.PRODUCT_ID = #GET_BARCODE.PRODUCT_ID# AND
                                S.PRODUCT_ID = GET_STOCK_BARCODES.PRODUCT_ID AND
                                S.STOCK_ID = GET_STOCK_BARCODES.STOCK_ID
                        </cfquery>
                        <cfif GET_STOCKS.recordcount>
                        <cfset attributes.totalrecords=GET_STOCKS.recordcount>
                        <cfelse>
                        <cfset attributes.totalrecords =0>
                        </cfif>
                    </cfif>

                        <cfif GET_BARCODE.recordcount and GET_STOCKS.RecordCount>
                            <cfoutput query="GET_STOCKS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <tr>
                                <td>#BARCODE#</td>
                                <td><a href="#request.self#?fuseaction=product.list_product&event=det&pid=#product_id#" class="tableyazi">#product_name# <cfif len(PROPERTY) and trim(PROPERTY) neq "-">-#PROPERTY#</cfif></a></td>
                            </tr>
                            </cfoutput>
                        <cfelse>
                            <tr> 
                                <td colspan="2"><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'>!</td>
                            </tr>
                        </cfif>
                    
                <cfelse>
                    <tr><td colspan="2"><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'>! </td></tr>
                </cfif>
            </tbody>
        </cf_flat_list>

        <cfif attributes.maxrows lt attributes.totalrecords>
        <cfset adres = 'objects.popup_barcod_search'>
		<cfif isDefined('attributes.barcod') and len(attributes.barcod)>
		<cfset adres = '#adres#&barcod=#attributes.barcod#'>
		</cfif>
        <cfif isDefined("attributes.draggable") and len(attributes.draggable)>
            <cfset adres = '#adres#&draggable=#attributes.draggable#'>
        </cfif>
        <cf_paging 
        page="#attributes.page#" 
        maxrows="#attributes.maxrows#" 
        totalrecords="#attributes.totalrecords#" 
        startrow="#attributes.startrow#" 
        adres="#adres#" 
        isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
    </cfif>
    </cf_box>
</div>