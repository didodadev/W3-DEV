      <table cellspacing="1" cellpadding="2" width="98%" border="0" class="color-border">
        <tr class="color-header" height="22">
          <td class="form-title" width="250" style="cursor:pointer;" onclick="gizle_goster(varlik);"><cf_get_lang dictionary_id='57564.Ürünler'></td>
          <td align="center" width="15"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_form_add_route_product&ROUTE_id=#attributes.ROUTE_id#</cfoutput>','small');"><img src="/images/plus_square.gif" border="0" title="<cf_get_lang dictionary_id='35595.Varlik Ekle'>"></a></td>
        </tr>
        <tr class="color-row" height="20" style="display:visible;" id="varlik">
          <td colspan="2">
            <!--- Bunu include hale getir.--->
            <cfquery name="GET_ROUTE_PRODUCTS" datasource="#DSN3#">
				SELECT 
					* 
				FROM 
					ROUTE_PRODUCTS 
				WHERE 
					ROUTE_ID=#attributes.ROUTE_ID#
            </cfquery>
            <cfif GET_ROUTE_PRODUCTS.recordcount>
                <table cellpadding="0" cellspacing="0" border="0" width="100%">
                   <cfoutput query="GET_ROUTE_PRODUCTS">
				   <tr>
                    <td width="155"><a class="tableyazi" href="#request.self#?fuseaction=prod.add_product_tree&stock_id=#STOCK_ID#">#GET_PRODUCT_NAME(stock_id:STOCK_ID)#</a></td>
                    <td align="right" style="text-align:right;"> 
					<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.popup_form_add_route_product&upd=#id#&ROUTE_id=#attributes.ROUTE_id#','small');"><img src="/images/update_list.gif" border="0"></a> 
					<cfsavecontent variable="del_cont"><cf_get_lang dictionary_id ='36932.Kayıtı Siliyorsunuz Emin misiniz'></cfsavecontent>
					<a style="cursor:pointer;" onClick="javascript:if (confirm('#del_cont#')) windowopen('#request.self#?fuseaction=prod.popup_del_route_product&del=#ID#&ROUTE_id=#attributes.ROUTE_id#','date');else return false;"><img src="/images/delete_list.gif" border="0"></a> 
					</td>
                  </tr>
				  </cfoutput>
                </table>
              <cfelse>
              <cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!
            </cfif>
          </td>
        </tr>
      </table>

