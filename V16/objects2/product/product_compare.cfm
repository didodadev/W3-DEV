<cfquery name="GET_CATS" datasource="#DSN3#">
	SELECT DISTINCT PRODUCT_CATID FROM PRODUCT WHERE PRODUCT_ID IN (#attributes.product_id#)
</cfquery>
<cfif get_cats.recordcount gt 1>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1201.Farklı Kategorideki Ürünleri Karşılaştıramazsınız'>!");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfinclude template='../query/get_product_properties.cfm'>
<cfquery name="GET_LANGUAGE_INFOS" datasource="#DSN#">
    SELECT
        ITEM,
        UNIQUE_COLUMN_ID
    FROM
        SETUP_LANGUAGE_INFO
    WHERE
        <cfif isdefined('session.pp')>
            LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pp.language#"> AND
        <cfelse>
            LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ww.language#"> AND
        </cfif>
        COLUMN_NAME = 'PROPERTY' AND
        TABLE_NAME = 'PRODUCT_PROPERTY'
</cfquery>
<cfquery name="GET_LANGUAGE_INFOS2" datasource="#DSN#">
    SELECT
        ITEM,
        UNIQUE_COLUMN_ID
    FROM
        SETUP_LANGUAGE_INFO
    WHERE
        <cfif isdefined('session.pp')>
            LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pp.language#"> AND
        <cfelse>
            LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ww.language#"> AND
        </cfif>
        COLUMN_NAME = 'PROPERTY_DETAIL' AND
        TABLE_NAME = 'PRODUCT_PROPERTY_DETAIL'
</cfquery>
<table border="0" cellspacing="0" cellpadding="0" align="center" style="width:100%; height:25px;">
	<tr>
    	<td class="headbold"><cf_get_lang no='407.Ürün Karşılaştırması'></td>
	</tr>
</table>
<table cellspacing="1" cellpadding="2" border="0" class="color-border" style="width:100%">
	<tr class="color-header" style="height:22px;">
    	<td class="form-title"><cf_get_lang_main no='245.Ürün'></td>
	  	<cfloop list="#attributes.product_id#" index="prod_ind">
			<cfquery name="GET_STOCK" datasource="#DSN3#" maxrows="1">
				SELECT STOCK_ID FROM STOCKS WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#prod_ind#">
		  	</cfquery>
	  		<cfset fiyat_stock_id = get_stock.stock_id>	  
	  		<td class="form-title" align="center"><cfoutput><a href="#request.self#?fuseaction=objects2.detail_product&product_id=#prod_ind#&stock_id=#fiyat_stock_id#" target="_blank" class="form-title">#get_product_name(product_id:prod_ind)#</a></cfoutput>
            </td>
	  	</cfloop>
	</tr>
	<tr style="background-color:##FFFFFF;">
		<td class="txtbold"><cf_get_lang_main no='668.Resim'></td>
		<cfloop list="#attributes.product_id#" index="prod_ind">
			<td align="center" style="vertical-align:top;">
            <cfquery name="GET_IMAGE" datasource="#DSN3#" maxrows="1">
                SELECT PATH, PRODUCT_ID,PATH_SERVER_ID,DETAIL FROM PRODUCT_IMAGES WHERE IMAGE_SIZE = 0 AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#prod_ind#"> ORDER BY PRODUCT_IMAGEID DESC
            </cfquery>
            <cfquery name="GET_IMAGE_BIG" datasource="#DSN3#" maxrows="1">
                SELECT PATH, PRODUCT_ID,PATH_SERVER_ID,DETAIL FROM PRODUCT_IMAGES WHERE IMAGE_SIZE = 2 AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#prod_ind#"> ORDER BY PRODUCT_IMAGEID DESC
            </cfquery>
			<!---<cfif get_image.recordcount>
                <cfoutput>
                    <cf_get_server_file output_file="product/#get_image_big.path#" title="#get_image.detail#" output_server="#get_image_big.path_server_id#" output_type="0" image_link="1" image_width="120" image_height="120" alt="#lang_array_main.item[668]#" title="#lang_array_main.item[668]#">
                </cfoutput>
            </cfif>--->
			<cfif isdefined('attributes.is_product_comment') and attributes.is_product_comment eq 1>
				<br/>
                <cfquery name="GET_PRODUCT_COMMENT_" datasource="#DSN3#">
                    SELECT 
                        COUNT(PRODUCT_COMMENT_ID) AS YORUM_SAYISI,
                        SUM(PRODUCT_COMMENT_POINT) AS YORUM_PUANI
                    FROM
                        PRODUCT_COMMENT
                    WHERE
                        PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#prod_ind#"> AND
                        STAGE_ID = -2
                </cfquery>
				<cfoutput>
				<cfif not get_product_comment_.recordcount or get_product_comment_.yorum_sayisi eq 0>
                    <cfloop from="1" to="5" index="sss">
                        <img src="../objects2/image/point_empty.gif" border="0" align="absmiddle" />
                    </cfloop>
					<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects2.popup_add_product_comment&pid=#prod_ind#','large');" class="tableyazi"><cf_get_lang no ='359.Yorum Ekle'></a>
				<cfelse>
					<cfset oran_ = get_product_comment_.yorum_puani / get_product_comment_.yorum_sayisi>
					<cfif listlen(oran_,'.') eq 2>
                        <cfloop from="1" to="#ceiling(oran_)-1#" index="cc">
                            <img src="../objects2/image/point_full.gif" border="0" align="absmiddle" />
                        </cfloop>
                            <img src="../objects2/image/point_half.gif" border="0" align="absmiddle" />
                        <cfloop from="1" to="#5 - ceiling(oran_)#" index="cc">
                            <img src="../objects2/image/point_empty.gif" border="0" align="absmiddle" />
                        </cfloop>
                    <cfelse>
                        <cfloop from="1" to="#oran_#" index="cc">
                            <img src="../objects2/image/point_full.gif" border="0" align="absmiddle" />
                        </cfloop>
                        <cfloop from="1" to="#5 - oran_#" index="cc">
                            <img src="../objects2/image/point_empty.gif" border="0" align="absmiddle" />
                        </cfloop>
                    </cfif>
					<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects2.popup_view_all_product_comment&product_id=#prod_ind#','large');" class="tableyazi">&nbsp;<cf_get_lang no ='360.Yorum Oku'> : #get_product_comment_.yorum_sayisi#</a>
					-
					<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects2.popup_add_product_comment&pid=#prod_ind#','large');" class="tableyazi"><cf_get_lang no ='359.Yorum Ekle'></a>
				</cfif>
				</cfoutput>
			</cfif>
		 	</td>
		</cfloop>
	</tr>
	<cfif isdefined("attributes.compare_prices") and attributes.compare_prices eq 1>
		<cfoutput>
			<tr class="color-header" style="height:20px;">
				<td class="form-title"><cf_get_lang_main no='672.Fiyat'></td>
			  	<cfloop list="#attributes.product_id#" index="prod_ind">
					<cfset fiyat_product_id = prod_ind>
					<cfquery name="GET_STOCK" datasource="#DSN3#" maxrows="1">
						SELECT STOCK_ID FROM STOCKS WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#prod_ind#">
					</cfquery>
					<cfset fiyat_stock_id = get_stock.stock_id>
					<cfinclude template="get_product_fiyat.cfm">
					<cfquery name="GET_MONEY_INFO" datasource="#DSN2#">
						SELECT
							(RATE2/RATE1) RATE
						FROM 
							SETUP_MONEY
						WHERE
							MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.price_money#">
					</cfquery>
					<td align="center"  class="form-title">
						#tlformat(attributes.price_kdv * get_money_info.RATE)# #session_base.money# (KDV Dahil)
					</td>
			  	</cfloop>
			</tr>
		</cfoutput>
	</cfif>
	<tr class="color-row" style="height:22px;">
    	<td class="txtbold" align="center" colspan="<cfoutput>#listlen(attributes.product_id)+1#</cfoutput>"><cf_get_lang_main no='1498.Özellikler'></td>
	</tr>
	<cfif attributes.is_compare_content eq 1>
		<cfif get_product_properties.recordcount>
		  	<cfquery name="GET_ALL_PROPERTIES" datasource="#DSN1#">
				SELECT
					PRODUCT_DT_PROPERTIES.PRODUCT_ID,
					PRODUCT_PROPERTY.PROPERTY_ID,
					PRODUCT_DT_PROPERTIES.DETAIL,
					PRODUCT_PROPERTY_DETAIL.PROPERTY_DETAIL,
                    PRODUCT_PROPERTY_DETAIL.PROPERTY_DETAIL_ID
				FROM
					PRODUCT_DT_PROPERTIES,
					PRODUCT_PROPERTY,
					PRODUCT_PROPERTY_DETAIL
				WHERE
					PRODUCT_PROPERTY.IS_ACTIVE = 1 AND
					PRODUCT_PROPERTY_DETAIL.IS_ACTIVE = 1 AND
					PRODUCT_DT_PROPERTIES.IS_INTERNET = 1 AND
					PRODUCT_DT_PROPERTIES.VARIATION_ID = PRODUCT_PROPERTY_DETAIL.PROPERTY_DETAIL_ID AND
					PRODUCT_DT_PROPERTIES.PRODUCT_ID IN (#attributes.product_id#) AND
					PRODUCT_PROPERTY.PROPERTY_ID IN (#property_list#) AND
					PRODUCT_PROPERTY.PROPERTY_ID = PRODUCT_DT_PROPERTIES.PROPERTY_ID AND
					PRODUCT_PROPERTY_DETAIL.PRPT_ID = PRODUCT_PROPERTY.PROPERTY_ID
				ORDER BY
					PRODUCT_DT_PROPERTIES.PRODUCT_DT_PROPERTY_ID
		  	</cfquery>
		  	<cfoutput query="get_product_properties">
                <cfquery name="GET_LANGUAGE_INFO" dbtype="query">
                    SELECT
                        *
                    FROM
                        GET_LANGUAGE_INFOS
                    WHERE
                        UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#property_id#">
                </cfquery>
                <tr class="color-row" style="height:20px;">
                  	<td class="txtbold" nowrap><cfif get_language_info.recordcount>#get_language_info.item#<cfelse>#property#</cfif></td>
                 	<cfloop list="#attributes.product_id#" index="prod_ind">
                  		<td>
                    		<cfquery name="GET_VARIATION" dbtype="query">
                                SELECT
                                    *
                                FROM
                                    GET_ALL_PROPERTIES
                                WHERE
                                    PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#prod_ind#"> AND
                                    PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#property_id#">
                                ORDER BY
                                    PROPERTY_ID
                            </cfquery>
                            <cfquery name="GET_LANGUAGE_INFO2" dbtype="query">
                                SELECT
                                    *
                                FROM
                                    GET_LANGUAGE_INFOS2
                                WHERE
                                    UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_variation.property_detail_id#">
                            </cfquery>
                    		<li><cfif get_language_info2.recordcount>#get_language_info2.item#<cfelse>#get_variation.property_detail#</cfif> - #get_variation.detail#</li><br/>
                  		</td>
                 	</cfloop>
                </tr>
		  	</cfoutput>
		<cfelse>
		  	<tr class="color-row" style="height:20px;">
				<td td colspan="4"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
		  	</tr>
		</cfif>
	<cfelse>
		<cfif get_product_content.recordcount>
			<cfquery name="GET_CONTENT_RELATION" datasource="#DSN#">
				SELECT 
					CONTENT_RELATION.ACTION_TYPE_ID,
					CONTENT_RELATION.CONTENT_ID, 
					C.CONT_BODY,
					C.CONTENT_PROPERTY_ID
				FROM 
					CONTENT_RELATION, 
					CONTENT C,
					CONTENT_CHAPTER CH,
					CONTENT_CAT CC
				WHERE 
					C.CHAPTER_ID = CH.CHAPTER_ID AND
					CH.CONTENTCAT_ID = CC.CONTENTCAT_ID AND
					CC.IS_RULE <> 1 AND	  
					CC.CONTENTCAT_ID <> 0 AND
					CONTENT_RELATION.CONTENT_ID = C.CONTENT_ID AND
					CONTENT_RELATION.ACTION_TYPE_ID IN (#attributes.product_id#) AND
					CONTENT_RELATION.ACTION_TYPE = 'PRODUCT_ID'
			</cfquery>
			<cfoutput query="get_product_content">
			<tr class="color-row">
				<td class="txtbold" nowrap style="vertical-align:top;">#name#</td>
				<cfloop list="#attributes.product_id#" index="prod_ind">
					<cfquery name="GET_ALL_CONTENT" dbtype="query">
						SELECT
							*
						FROM
							GET_CONTENT_RELATION
						WHERE
							ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#prod_ind#"> AND
							CONTENT_PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#content_property_id#">
						ORDER BY
							CONTENT_PROPERTY_ID
					</cfquery>
					<td>#get_all_content.cont_body#</td>
				</cfloop>
			</tr>
			</cfoutput>
		</cfif>
	</cfif>
</table>

