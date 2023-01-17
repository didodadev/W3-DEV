<cfquery name="get_piece" datasource="#dsn3#">
  	SELECT MASTER_PRODUCT_ID FROM EZGI_DESIGN_PIECE WHERE PIECE_ROW_ID = #attributes.design_piece_row_id#
</cfquery>
<cfif not get_piece.recordcount>
	<script type="text/javascript">
		alert("Parça Silindiğinden Güncelleme Yapılamaz!");
		window.close()
	</script>
    <cfabort>
</cfif>
<cftransaction>
	<!---<cfif isdefined('attributes.is_common_piece_list')>
    	<cfdump var="#attributes#"><cfabort>
    </cfif>--->
	<cfquery name="upd_piece" datasource="#dsn3#">
        UPDATE
            EZGI_DESIGN_PIECE_ROWS
      	SET
            <cfif attributes.PIECE_TYPE eq 4>
            	PIECE_RELATED_ID = #attributes.related_stock_id#,
                PIECE_NAME = '#attributes.RELATED_PRODUCT_NAME#',
          	<cfelse>
                PIECE_NAME = '#attributes.DESIGN_NAME_PIECE_ROW#', 
                PIECE_COLOR_ID = <cfif attributes.PIECE_TYPE eq 1 or attributes.PIECE_TYPE eq 2 or attributes.PIECE_TYPE eq 3>#attributes.COLOR_TYPE#<cfelse>0</cfif>, 
                MASTER_PRODUCT_ID = #attributes.DEFAULT_TYPE#, 
                MATERIAL_ID = <cfif attributes.PIECE_TYPE eq 1>#attributes.PIECE_YONGA_LEVHA#<cfelse>NULL</cfif>, 
                TRIM_TYPE = #attributes.trim_type#,
                TRIM_SIZE = <cfif attributes.trim_type eq 1>#Filternum(attributes.trim_rate,1)#<cfelse>0</cfif>, 
                IS_FLOW_DIRECTION = <cfif isdefined('attributes.PIECE_SU_YONU') and attributes.PIECE_SU_YONU eq 1>1<cfelse>0</cfif>, 
                BOYU = <cfif len(attributes.PIECE_BOY)>#FilterNum(attributes.PIECE_BOY,1)#<cfelse>0</cfif>, 
                ENI = <cfif len(attributes.PIECE_EN)>#FilterNum(attributes.PIECE_EN,1)#<cfelse>0</cfif>, 
                KALINLIK = <cfif isdefined('attributes.PIECE_KALINLIK') and len(attributes.PIECE_KALINLIK)>#attributes.PIECE_KALINLIK#<cfelse>NULL</cfif>,
         	</cfif>
            PIECE_DETAIL = '#attributes.piece_detail#', 
            PIECE_CODE = '#attributes.DESIGN_CODE_PIECE_ROW#',
            PIECE_TYPE = #attributes.PIECE_TYPE#,
            DESIGN_MAIN_ROW_ID = #attributes.design_main_row_id#, 
          	DESIGN_PACKAGE_ROW_ID = <cfif len(attributes.piece_package_no)>#attributes.piece_package_no#<cfelse>NULL</cfif>, 
          	DESIGN_ID = #attributes.design_id#,
            PIECE_STATUS = 1,
            PIECE_AMOUNT = #FilterNum(attributes.PIECE_AMOUNT,4)#,
            PIECE_FLOOR =<cfif isdefined('attributes.piece_package_floor_no') and len(attributes.piece_package_floor_no)>#attributes.piece_package_floor_no#<cfelse>NULL</cfif>,
            PIECE_PACKAGE_ROTA =<cfif isdefined('attributes.piece_package_rota') and len(attributes.piece_package_rota)>'#attributes.piece_package_rota#'<cfelse>NULL</cfif>,
            UPDATE_EMP = #session.ep.userid#, 
            UPDATE_IP = '#cgi.remote_addr#', 
            UPDATE_DATE = #now()#
      	WHERE
        	PIECE_ROW_ID = #attributes.design_piece_row_id#
    </cfquery>
    <cfquery name="del_process_row" datasource="#dsn3#">
        DELETE FROM EZGI_DESIGN_PIECE_ROW WHERE PIECE_ROW_ID = #attributes.design_piece_row_id#
    </cfquery>
    <cfset get_max_id.MAX_ID = attributes.design_piece_row_id>
    <cfif not len(attributes.PIECE_BOY)><cfset attributes.PIECE_BOY = 0></cfif>
  	<cfif not len(attributes.PIECE_EN)><cfset attributes.PIECE_EN = 0></cfif>
 	<cfinclude template="hsp_ezgi_product_tree_creative_piece_row.cfm">
  	<cfif isdefined('attributes.is_common_piece_list')> <!---Ortak Parça Varmı--->
        <cfquery name="upd_piece" datasource="#dsn3#">
            UPDATE
                EZGI_DESIGN_PIECE_ROWS
            SET
           		PIECE_COLOR_ID = <cfif attributes.PIECE_TYPE eq 1 or attributes.PIECE_TYPE eq 2 or attributes.PIECE_TYPE eq 3>#attributes.COLOR_TYPE#<cfelse>0</cfif>, 
             	MASTER_PRODUCT_ID = #attributes.DEFAULT_TYPE#, 
              	MATERIAL_ID = <cfif attributes.PIECE_TYPE eq 1>#attributes.PIECE_YONGA_LEVHA#<cfelse>NULL</cfif>, 
             	TRIM_TYPE = #attributes.trim_type#,
               	TRIM_SIZE = <cfif attributes.trim_type eq 1>#Filternum(attributes.trim_rate,1)#<cfelse>0</cfif>, 
             	IS_FLOW_DIRECTION = <cfif isdefined('attributes.PIECE_SU_YONU') and attributes.PIECE_SU_YONU eq 1>1<cfelse>0</cfif>, 
              	BOYU = <cfif len(attributes.PIECE_BOY)>#FilterNum(attributes.PIECE_BOY,1)#<cfelse>0</cfif>, 
              	ENI = <cfif len(attributes.PIECE_EN)>#FilterNum(attributes.PIECE_EN,1)#<cfelse>0</cfif>, 
             	KALINLIK = <cfif isdefined('attributes.PIECE_KALINLIK') and len(attributes.PIECE_KALINLIK)>#attributes.PIECE_KALINLIK#<cfelse>NULL</cfif>,
                PIECE_DETAIL = '#attributes.piece_detail#', 
                PIECE_TYPE = #attributes.PIECE_TYPE#,
                PIECE_STATUS = 1,
                PIECE_FLOOR =<cfif isdefined('attributes.piece_package_floor_no') and len(attributes.piece_package_floor_no)>#attributes.piece_package_floor_no#<cfelse>NULL</cfif>,
                PIECE_PACKAGE_ROTA =<cfif isdefined('attributes.piece_package_rota') and len(attributes.piece_package_rota)>'#attributes.piece_package_rota#'<cfelse>NULL</cfif>,
                UPDATE_EMP = #session.ep.userid#, 
                UPDATE_IP = '#cgi.remote_addr#', 
                UPDATE_DATE = #now()#
            WHERE
                PIECE_ROW_ID IN (#attributes.is_common_piece_list#)
        </cfquery>
        <cfif attributes.PIECE_TYPE eq 3> <!---Parça Montajlı Ürün İse--->
        	<cfquery name="get_sub_pieces" datasource="#dsn3#"><!--- Bu Üründeki Montaj Alt Parçaları Bulunuyor--->
        		SELECT RELATED_PIECE_ROW_ID, AMOUNT FROM EZGI_DESIGN_PIECE_ROW WHERE PIECE_ROW_ID = #attributes.design_piece_row_id# AND PIECE_ROW_ROW_TYPE = 4
        	</cfquery>
            <cfif get_sub_pieces.recordcount> <!---Montaj Alt Parçaları Mevcutsa--->
            	<cfset related_piece_row_id_list = ValueList(get_sub_pieces.RELATED_PIECE_ROW_ID)>
                <cfloop list="#attributes.is_common_piece_list#" index="zag"> <!---Ortak Parçalar Tektek Kontrol ediliyor--->
                	<cfquery name="get_common_sub_pieces" datasource="#dsn3#"><!--- Ortak Parçanın Montaj Alt Parçaları Bulunuyor--->
                        SELECT RELATED_PIECE_ROW_ID, AMOUNT FROM EZGI_DESIGN_PIECE_ROW WHERE PIECE_ROW_ID = #zag# AND PIECE_ROW_ROW_TYPE = 4
                    </cfquery>
                    <cfif get_common_sub_pieces.recordcount neq get_sub_pieces.recordcount> <!---Bu Parçanın alt parça miktarıyla Ortak parçanın altparça miktarı eşit değilse--->
                    	<script type="text/javascript">
							alert("Alt Parçalar Farklı Olduğundan Güncelleme Yapılamaz!");
							window.close()
						</script>
						<cfabort>
                    <cfelse> <!---Bu Parçanın alt parça miktarıyla Ortak parçanın altparça miktarı eşitse--->
                    
                    	<cfquery name="del_process_row" datasource="#dsn3#"><!--- Montajlı Otak Parçaların Alt parçalaı Silinmeyecek--->
                            DELETE FROM EZGI_DESIGN_PIECE_ROW WHERE PIECE_ROW_ID = #zag# AND PIECE_ROW_ROW_TYPE <> 4
                        </cfquery>
                        <cfset get_max_id.MAX_ID = zag>
                        <cfif not len(attributes.PIECE_BOY)><cfset attributes.PIECE_BOY = 0></cfif>
                        <cfif not len(attributes.PIECE_EN)><cfset attributes.PIECE_EN = 0></cfif>
                        <cfset ortak_update = 1> <!---Bir Alt İşlemde Ortak Olt Paröçalar Eklenmesin Diye Parametre Gönderiyorum--->
                        <cfinclude template="hsp_ezgi_product_tree_creative_piece_row.cfm">
                        
                    </cfif>
                </cfloop>
            <cfelse><!---Montaj Alt Parçaları Mevcut değilse--->
            	<cfloop list="#attributes.is_common_piece_list#" index="zag"> <!---Ortak Parçalar Tektek Bileşenleri Düzenleniyor--->
                    <cfquery name="del_process_row" datasource="#dsn3#">
                        DELETE FROM EZGI_DESIGN_PIECE_ROW WHERE PIECE_ROW_ID = #zag#
                    </cfquery>
                    <cfset get_max_id.MAX_ID = zag>
                    <cfif not len(attributes.PIECE_BOY)><cfset attributes.PIECE_BOY = 0></cfif>
                    <cfif not len(attributes.PIECE_EN)><cfset attributes.PIECE_EN = 0></cfif>
                    <cfinclude template="hsp_ezgi_product_tree_creative_piece_row.cfm">
                </cfloop>
            </cfif>
        <cfelse> <!---Yonga Levha veya Genel Reçete İse--->
        	<cfloop list="#attributes.is_common_piece_list#" index="zag"> <!---Ortak Parçalar Tektek Bileşenleri Düzenleniyor--->
                <cfquery name="del_process_row" datasource="#dsn3#">
                    DELETE FROM EZGI_DESIGN_PIECE_ROW WHERE PIECE_ROW_ID = #zag#
                </cfquery>
                <cfset get_max_id.MAX_ID = zag>
                <cfif not len(attributes.PIECE_BOY)><cfset attributes.PIECE_BOY = 0></cfif>
                <cfif not len(attributes.PIECE_EN)><cfset attributes.PIECE_EN = 0></cfif>
                <cfinclude template="hsp_ezgi_product_tree_creative_piece_row.cfm">
            </cfloop>
        </cfif>
    </cfif>
</cftransaction>
<cflocation url="#request.self#?fuseaction=prod.popup_upd_ezgi_product_tree_creative_piece_row&design_piece_row_id=#attributes.design_piece_row_id#" addtoken="no">