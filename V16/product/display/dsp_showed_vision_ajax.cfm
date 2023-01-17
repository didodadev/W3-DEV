<!--- ürün detayda ürünün gösterildiği vitrinler --->
<cfsetting showdebugoutput="no">
<cfquery name="GET_SHOWED_VISION" datasource="#DSN3#">
	SELECT 
    	PV.VISION_ID,
   		PV.VISION_TYPE,
        PV.STARTDATE,
        PV.FINISHDATE,
        PV.STOCK_ID,
        P.PRODUCT_ID,
        S.STOCK_CODE
    FROM 
    	PRODUCT_VISION PV,
        #dsn1_alias#.PRODUCT P,
        #dsn1_alias#.STOCKS S
    WHERE
    	S.STOCK_ID = PV.STOCK_ID AND
    	PV.PRODUCT_ID = P.PRODUCT_ID AND
        P.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
</cfquery>
<cfquery name="GET_VISION_TYPES" datasource="#DSN#">
	SELECT VISION_TYPE_ID, VISION_TYPE_NAME FROM SETUP_VISION_TYPE
</cfquery>
<cf_flat_list>
    <tbody>
        <cfif get_showed_vision.recordcount>   
            <cfoutput query="get_showed_vision">
                <cfquery name="GET_SHOWED" dbtype="query">
                    SELECT * FROM GET_SHOWED_VISION WHERE VISION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_showed_vision.vision_id#">
                </cfquery>
                <cfset vision_id_list = listsort(valuelist(get_showed.vision_type,','),'numeric','ASC',',')>
                <tr>
                    <td>
                        #stock_code# <br/>
                        #DateFormat(startdate,dateformat_style)# - #DateFormat(finishdate,dateformat_style)#                            
                    </td> 
                    <td>                           
                        <cfloop from="1" to="#listlen(vision_id_list,',')#" index="i">
                            <cfquery name="GET_VISION_TYPE" dbtype="query">
                                SELECT * FROM GET_VISION_TYPES WHERE VISION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(vision_id_list,i,',')#">
                            </cfquery>
                            #get_vision_type.vision_type_name#<br/>
                        </cfloop>
                    </td>
                    <td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=product.popup_upd_product_vision&vision_id=#vision_id#&product_id=#product_id#','','ui-draggable-box-small');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                </tr>
            </cfoutput>
         <cfelse>
            <tr>
                <td colspan="2"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
            </tr>    
        </cfif>
    </tbody> 
</cf_flat_list>

