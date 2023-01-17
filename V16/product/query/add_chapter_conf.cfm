<cf_xml_page_edit fuseact="product.popup_upd_product_cat_configuration">
<!--- M.ER
	Sayfa CHAPTER,COMPENENT VE VARITIONS EKLEMELERİNİ YAPAR
	GÖNDERİLEN DEĞİŞKENEN GÖRE YA CHAPTER YA COMPENENT YADA VARITIONS EKLER VEYA GÜNCELLER
	DEĞİŞİKLİK YAPILIRSA İYİCE KONTROL EDİLMELİDİR.
	M.ER 06 05 2009
--->
<cfsetting showdebugoutput="no">
<cfif attributes.type eq 1><!--- TYPE 1 ise eklemedir! --->
	<cfif isdefined('attributes.is_chapter')><!--- CHAPTER İSE --->
        <cfquery name="ADD_SETUP_PRODUCT_CONFIGURATOR_CHAPTER" datasource="#DSN3#">
            SET NOCOUNT ON
            INSERT INTO 
                SETUP_PRODUCT_CONFIGURATOR_CHAPTER
                (
                    PRODUCT_CONFIGURATOR_ID,
                    ORDER_ROW_NO,
                    CONFIGURATOR_CHAPTER_NAME,
                    CONFIGURATOR_CHAPTER_DETAIL
                )
                VALUES
                (
                    #attributes.PRODUCT_CONFIGURATOR_ID#,
                    #attributes.chapter_line#,
                    '#attributes.chapter_name#',
                    '#attributes.detail#'
                )
                SELECT @@Identity AS MAX_ID      
                SET NOCOUNT OFF
        </cfquery>
        <script type="text/javascript">
            <cfoutput>
                document.getElementById('configurator_chapter_id#attributes.chapter_line#').value = '#ADD_SETUP_PRODUCT_CONFIGURATOR_CHAPTER.MAX_ID#';//chapter ile configürasyon arasındaki ilişkiyi input'a yansıttık..
            </cfoutput>
        </script>
    <cfelseif isdefined('attributes.is_compenent')><!--- COMPENENT İSE --->
		<cfquery name="ADD_SETUP_PRODUCT_CONFIGURATOR_COMPENENT" datasource="#DSN3#">
            SET NOCOUNT ON
            INSERT INTO 
                SETUP_PRODUCT_CONFIGURATOR_COMPONENTS
                (
                    PRODUCT_CONFIGURATOR_ID,
                    CONFIGURATOR_CHAPTER_ID,
                    SUB_PRODUCT_CAT_ID,
                    PROPERTY_ID,
                    ORDER_NO,
                    IS_KEY_COMPONENT,
                    MAX_AMOUNT,
                    IS_VALUE_1,
                    IS_VALUE_2,
                    IS_TOLERANCE,
                    IS_UNIT,
                    IS_INFORMATION,
                    TYPE,
                    PROPERTY_DETAIL,
                    RELATION_PRODUCTS
                )
                VALUES
                (
                   #attributes.PRODUCT_CONFIGURATOR_ID#,
                   #attributes.chapter_id#,
                   <cfif len(attributes.PRODUCT_CAT) and len(attributes.PRODUCT_CAT_ID)>#attributes.PRODUCT_CAT_ID#<cfelse>NULL</cfif>,
                   <cfif len(attributes.PROPERTY) and len(attributes.PROPERTY_ID)>#attributes.PROPERTY_ID#<cfelse>NULL</cfif>,
                   <cfif len(attributes.order_no)>#attributes.order_no#<cfelse>NULL</cfif>,
                   <cfif attributes.is_key eq 1>1<cfelse>0</cfif>,
                   <cfif len(attributes.MAX_AMOUNT)>#attributes.MAX_AMOUNT#<cfelse>NULL</cfif>,
                   #attributes.IS_VALUE_1_#,
                   #attributes.IS_VALUE_2_#,
                   #attributes.IS_TOLERANCE#,
                   #attributes.is_unit#,
                   #attributes.COMP_INFORMATION#,
                   <cfif len(attributes.comp_type)>#attributes.comp_type#<cfelse>NULL</cfif>,
                   <cfif len(attributes.PROPERTY_DETAIL)>'#attributes.PROPERTY_DETAIL#'<cfelse>NULL</cfif>,
                   <cfif len(attributes.PRODUCT_NAME) and len(attributes.STOCK_ID)>'#attributes.STOCK_ID#'<cfelse>NULL</cfif>
                )
                SELECT @@Identity AS MAX_ID      
                SET NOCOUNT OFF
        </cfquery>
        <script type="text/javascript">
            <cfoutput>
                document.getElementById('product_configurator_compenents_id#attributes.compenent_row_id#').value = '#ADD_SETUP_PRODUCT_CONFIGURATOR_COMPENENT.MAX_ID#';//chapter ile configürasyon arasındaki ilişkiyi input'a yansıttık..
            </cfoutput>
        </script>
    <cfelseif isdefined('attributes.is_variation')><!--- VARYASYON İSE --->
        <cfquery name="ADD_SETUP_PRODUCT_CONFIGURATOR_VARIATION" datasource="#DSN3#">
        	SET NOCOUNT ON
				INSERT INTO 
                    SETUP_PRODUCT_CONFIGURATOR_VARIATION
                    (
                        PRODUCT_CONFIGURATOR_ID,
                        PRODUCT_CHAPTER_ID,
                        PRODUCT_COMPENENT_ID,
                        VARIATION_PROPERTY_DETAIL_ID,
                        VARIATION_PRODUCTS,
                        VARIATION_PRODUCTS_AMOUNT,
                        VARIATON_IS_VALUE_1,
                        VARIATON_IS_VALUE_2,
                        VARIATON_IS_TOLERANCE,
                        VARIATON_IS_UNIT,
                        VARIATON_PROPERTY_DETAIL,
                        VARIATION_SCRIPT,
                        VARIATION_TYPE,
                        VARIATION_ORDER_NO
                    )
                    VALUES
                    (
                        #attributes.PRODUCT_CONFIGURATOR_ID#,
                        #attributes.VARIATION_CHAPTER_ID#,
                        #attributes.VARIATION_COMPENENT_ID#,
                        #attributes.VARIATION_NAME_ID#,
                        <cfif len(attributes.VARIATION_STOCKS_ID_)>'#attributes.VARIATION_STOCKS_ID_#'<cfelse>NULL</cfif>,
                        <cfif len(attributes.VAR_MAX_AMOUNT)>#attributes.VAR_MAX_AMOUNT#<cfelse>1</cfif>,
                        #attributes.VAR_IS_VALUE_1_#,
                        #attributes.VAR_IS_VALUE_2_#,
                        #attributes.VAR_IS_TOLERANCE#,
                        #attributes.VAR_IS_UNIT#,
                        <cfif len(attributes.VAR_PROPERTY_DETAIL)>'#attributes.VAR_PROPERTY_DETAIL#'<cfelse>NULL</cfif>,
                        <cfif len(attributes.VARIATION_PRODUCT_scrpt_)>'#attributes.VARIATION_PRODUCT_scrpt_#'<cfelse>NULL</cfif>,
						#attributes.VARIATION_TYPE_#,
                        <cfif len(attributes.pv_order_no)>#attributes.pv_order_no#<cfelse>NULL</cfif>
                    )
                SELECT @@Identity AS PRODUCT_CONF_VARIATION_ID      
                SET NOCOUNT OFF     
            </cfquery>
             <script type="text/javascript">
				<cfoutput>
					document.getElementById('product_configurator_variation_id#attributes.VARIATION_ROW_ID#').value = '#ADD_SETUP_PRODUCT_CONFIGURATOR_VARIATION.PRODUCT_CONF_VARIATION_ID#';//chapter ile configürasyon arasındaki ilişkiyi input'a yansıttık..
				</cfoutput>
			</script>
	<cfelseif isdefined('attributes.is_variation_relation')><!--- İlişkili VARYASYON İSE --->
        <cfquery name="ADD_SETUP_PRODUCT_CONFIGURATOR_VARIATION" datasource="#DSN3#">
            SET NOCOUNT ON
            INSERT INTO  SETUP_PRODUCT_CONFIGURATOR_VARIATION
            (
            	RELATION_CONFIGURATOR_VARIATION_ID,
                PRODUCT_CONFIGURATOR_ID,
                PRODUCT_CHAPTER_ID,
                PRODUCT_COMPENENT_ID,
                VARIATION_PROPERTY_DETAIL_ID,
                VARIATION_PRODUCTS,
                VARIATION_PRODUCTS_AMOUNT,
                VARIATON_IS_VALUE_1,
                VARIATON_IS_VALUE_2,
                VARIATON_IS_TOLERANCE,
                VARIATON_IS_UNIT,
                VARIATON_PROPERTY_DETAIL,
                VARIATION_SCRIPT,
                VARIATION_TYPE,
                VARIATION_ORDER_NO
            )
            VALUES
            (
            	#attributes.REL_SUB_CONF_VARIATION_ID#,
                #attributes.PRODUCT_CONFIGURATOR_ID#,
                #attributes.VARIATION_CHAPTER_ID_RELATION#,
                #attributes.VARIATION_COMPENENT_ID_RELATION#,
                #attributes.VARIATION_NAME_ID#,
                <cfif len(attributes.VARIATION_STOCKS_ID_RELATION)>'#attributes.VARIATION_STOCKS_ID_RELATION#'<cfelse>NULL</cfif>,
                <cfif len(attributes.VAR_MAX_AMOUNT_RELATION)>#attributes.VAR_MAX_AMOUNT_RELATION#<cfelse>1</cfif>,
                #attributes.VAR_IS_VALUE_1_RELATION#,
                #attributes.VAR_IS_VALUE_2_RELATION#,
                #attributes.VAR_IS_TOLERANCE_RELATION#,
                #attributes.VAR_IS_UNIT_RELATION#,
                <cfif len(attributes.VAR_PROPERTY_DETAIL_RELATION)>'#attributes.VAR_PROPERTY_DETAIL_RELATION#'<cfelse>NULL</cfif>,
                <cfif len(attributes._VARIATION_PRODUCT_scrpt_RELATION_)>'#attributes._VARIATION_PRODUCT_scrpt_RELATION_#'<cfelse>NULL</cfif>,
                #attributes.VARIATION_TYPE_RELATION#,
                <cfif len(attributes.pv_order_no_relation)>#attributes.pv_order_no_relation#<cfelse>NULL</cfif>
            )
            SELECT @@Identity AS PRODUCT_CONF_VARIATION_ID      
            SET NOCOUNT OFF
        </cfquery>
		<script type="text/javascript">
            <cfoutput>
                document.getElementById('product_configurator_variation_id_rel#attributes.VARIATION_ROW_ID#').value = '#ADD_SETUP_PRODUCT_CONFIGURATOR_VARIATION.PRODUCT_CONF_VARIATION_ID#';//chapter ile configürasyon arasındaki ilişkiyi input'a yansıttık..
            </cfoutput>
        </script>
        
       <!---  <script type="text/javascript">
        	alert('<cfoutput>#attributes.REL_SUB_CONF_VARIATION_ID#</cfoutput>');
        </script> --->
	</cfif>
<cfelseif TYPE eq 0><!--- TYPE 0 İSE GÜNCELLEMEDİR --->
	<cfif isdefined('attributes.is_chapter')><!--- CHAPTER İSE --->
        <cfquery name="UPDATE_SETUP_PRODUCT_CONFIGURATOR_CHAPTER" datasource="#DSN3#">
            UPDATE SETUP_PRODUCT_CONFIGURATOR_CHAPTER SET
            ORDER_ROW_NO = #attributes.chapter_line#,
            CONFIGURATOR_CHAPTER_NAME= '#attributes.chapter_name#',
            CONFIGURATOR_CHAPTER_DETAIL ='#attributes.detail#'
            WHERE CONFIGURATOR_CHAPTER_ID = #attributes.CONFIGURATOR_CHAPTER_ID#
        </cfquery>
	<cfelseif isdefined('attributes.is_compenent')><!--- COMPENENT İSE --->
		<cfloop from="2" to="#x_product_count#" index="rcc">
			<cfif len(evaluate("attributes.s#rcc#_STOCK_ID"))>
				<cfset attributes.STOCK_ID = listappend(attributes.STOCK_ID,'#evaluate("attributes.s#rcc#_STOCK_ID")#')>
			</cfif>
		</cfloop>
		<cfset max_list_ = attributes.MAX_AMOUNT>
		<cfloop from="2" to="#x_product_count#" index="rcc">
			<cfif len(evaluate("attributes.s#rcc#_max_amount"))>
				<cfset max_list_ = listappend(max_list_,'#evaluate("attributes.s#rcc#_max_amount")#')>
			</cfif>
		</cfloop>
		<cfquery name="UPDATE_SETUP_PRODUCT_CONFIGURATOR_COMPENENT" datasource="#DSN3#">
            UPDATE 
				SETUP_PRODUCT_CONFIGURATOR_COMPONENTS 
			SET
				PRODUCT_CONFIGURATOR_ID = #attributes.PRODUCT_CONFIGURATOR_ID#,
				CONFIGURATOR_CHAPTER_ID = #attributes.chapter_id#,
				SUB_PRODUCT_CAT_ID=<cfif len(attributes.PRODUCT_CAT) and len(attributes.PRODUCT_CAT_ID)>#attributes.PRODUCT_CAT_ID#<cfelse>NULL</cfif>,
				PROPERTY_ID=<cfif len(attributes.PROPERTY) and len(attributes.PROPERTY_ID)>#attributes.PROPERTY_ID#<cfelse>NULL</cfif>,
				ORDER_NO=<cfif len(attributes.order_no)>#attributes.order_no#<cfelse>NULL</cfif>,
				IS_KEY_COMPONENT=<cfif attributes.is_key eq 1>1<cfelse>0</cfif>,
				MAX_AMOUNT=<cfif len(attributes.MAX_AMOUNT)>#attributes.MAX_AMOUNT#<cfelse>NULL</cfif>,
				IS_VALUE_1=#attributes.IS_VALUE_1_#,
				IS_VALUE_2=#attributes.IS_VALUE_2_#,
				IS_TOLERANCE=#attributes.IS_TOLERANCE#,
				IS_UNIT=#attributes.is_unit#,
				IS_INFORMATION=<cfif len(attributes.COMP_INFORMATION)>#attributes.COMP_INFORMATION#<cfelse>NULL</cfif>,
				TYPE=<cfif len(attributes.comp_type)>#attributes.comp_type#<cfelse>NULL</cfif>,
				PROPERTY_DETAIL=<cfif len(attributes.PROPERTY_DETAIL)>'#attributes.PROPERTY_DETAIL#'<cfelse>NULL</cfif>,
				RELATION_PRODUCTS=<cfif len(attributes.PRODUCT_NAME) and len(attributes.STOCK_ID)>'#attributes.STOCK_ID#'<cfelse>NULL</cfif>,
				RELATION_PRODUCTS_AMOUNTS=<cfif len(attributes.PRODUCT_NAME) and len(attributes.STOCK_ID) and listlen(max_list_)>'#max_list_#'<cfelse>NULL</cfif>
            WHERE 
            	PRODUCT_CONFIGURATOR_COMPENENTS_ID = #attributes.PRODUCT_CONFIGURATOR_COMPENENTS_ID#
        </cfquery>
		
		<script type="text/javascript">
			<cfoutput>
				document.getElementById("max_amount#attributes.COMPENENT_ROW_ID#").value = commaSplit(document.getElementById("max_amount#attributes.COMPENENT_ROW_ID#").value);
				<cfloop from="2" to="#x_product_count#" index="rcc">
					<cfoutput>
						document.getElementById("s#rcc#_max_amount#attributes.COMPENENT_ROW_ID#").value = commaSplit(document.getElementById("s#rcc#_max_amount#attributes.COMPENENT_ROW_ID#").value);
					</cfoutput>
				</cfloop>
			</cfoutput>
		</script>	  	
	<cfelseif isdefined('attributes.is_variation')><!--- varyasyon --->
		<cfloop from="2" to="#x_product_count#" index="rcc">
			<cfif len(evaluate("attributes.v#rcc#_VARIATION_STOCKS_ID_"))>
				<cfset attributes.VARIATION_STOCKS_ID_ = listappend(attributes.VARIATION_STOCKS_ID_,'#evaluate("attributes.v#rcc#_VARIATION_STOCKS_ID_")#')>
			</cfif>
		</cfloop>
		<cfset max_list_ = attributes.VAR_MAX_AMOUNT>
		<cfloop from="2" to="#x_product_count#" index="rcc">
			<cfif len(evaluate("attributes.v#rcc#_var_max_amount"))>
				<cfset max_list_ = listappend(max_list_,'#evaluate("attributes.v#rcc#_var_max_amount")#')>
			</cfif>
		</cfloop>		
		<cfquery name="UPD_SETUP_PRODUCT_CONFIGURATOR_VARIATION" datasource="#DSN3#">
            UPDATE  SETUP_PRODUCT_CONFIGURATOR_VARIATION SET
                PRODUCT_CONFIGURATOR_ID = #attributes.PRODUCT_CONFIGURATOR_ID#,
                PRODUCT_CHAPTER_ID = #attributes.VARIATION_CHAPTER_ID#,
                PRODUCT_COMPENENT_ID = #attributes.VARIATION_COMPENENT_ID#,
                VARIATION_PROPERTY_DETAIL_ID = #attributes.VARIATION_NAME_ID#,
                VARIATION_PRODUCTS=<cfif len(attributes.VARIATION_STOCKS_ID_)>'#attributes.VARIATION_STOCKS_ID_#'<cfelse>NULL</cfif>,
                VARIATION_PRODUCTS_AMOUNTS=<cfif len(attributes.VARIATION_STOCKS_ID_) and listlen(max_list_)>'#max_list_#'<cfelse>NULL</cfif>,
				VARIATION_PRODUCTS_AMOUNT=<cfif len(attributes.VAR_MAX_AMOUNT)>#attributes.VAR_MAX_AMOUNT#<cfelse>1</cfif>,
                VARIATON_IS_VALUE_1=#attributes.VAR_IS_VALUE_1_#,
                VARIATON_IS_VALUE_2=#attributes.VAR_IS_VALUE_2_#,
                VARIATON_IS_TOLERANCE=#attributes.VAR_IS_TOLERANCE#,
                VARIATON_IS_UNIT=#attributes.VAR_IS_UNIT#,
                VARIATON_PROPERTY_DETAIL=<cfif len(attributes.VAR_PROPERTY_DETAIL)>'#attributes.VAR_PROPERTY_DETAIL#'<cfelse>NULL</cfif>,
                VARIATION_SCRIPT=<cfif len(attributes.VARIATION_PRODUCT_scrpt_)>'#attributes.VARIATION_PRODUCT_scrpt_#'<cfelse>NULL</cfif>,
                VARIATION_TYPE=#attributes.VARIATION_TYPE_#,
                VARIATION_ORDER_NO=<cfif len(attributes.pv_order_no)>#attributes.pv_order_no#<cfelse>NULL</cfif>
			WHERE 
            	CONFIGURATOR_VARIATION_ID = #attributes.product_configurator_variation_id#
            </cfquery>
			
		<script type="text/javascript">
			<cfoutput>
				document.getElementById("var_max_amount#attributes.variation_row_id#").value = commaSplit(document.getElementById("var_max_amount#attributes.variation_row_id#").value);
				<cfloop from="2" to="#x_product_count#" index="rcc">
					<cfoutput>
						document.getElementById("v#rcc#_var_max_amount#attributes.variation_row_id#").value = commaSplit(document.getElementById("v#rcc#_var_max_amount#attributes.variation_row_id#").value);
					</cfoutput>
				</cfloop>
			</cfoutput>
		</script>
		<cfelseif isdefined('attributes.is_variation_relation')><!--- İlişkili VARYASYON İSE --->
			<cfloop from="2" to="#x_product_count#" index="rcc">
				<cfif len(evaluate("attributes.vr#rcc#_variation_stocks_id_relation"))>
					<cfset attributes.variation_stocks_id_relation = listappend(attributes.variation_stocks_id_relation,'#evaluate("attributes.vr#rcc#_variation_stocks_id_relation")#')>
				</cfif>
			</cfloop>
			<cfset max_list_ = attributes.var_max_amount_relation>
			<cfloop from="2" to="#x_product_count#" index="rcc">
				<cfif len(evaluate("attributes.vr#rcc#_var_max_amount_relation"))>
					<cfset max_list_ = listappend(max_list_,'#evaluate("attributes.vr#rcc#_var_max_amount_relation")#')>
				</cfif>
			</cfloop>          
		   
		    <cfquery name="UPD_SETUP_PRODUCT_CONFIGURATOR_VARIATION" datasource="#DSN3#">
                 UPDATE  
				 	SETUP_PRODUCT_CONFIGURATOR_VARIATION 
				SET
					RELATION_CONFIGURATOR_VARIATION_ID = #attributes.REL_SUB_CONF_VARIATION_ID#,
					PRODUCT_CONFIGURATOR_ID = #attributes.PRODUCT_CONFIGURATOR_ID#,
					PRODUCT_CHAPTER_ID = #attributes.VARIATION_CHAPTER_ID_RELATION#,
					PRODUCT_COMPENENT_ID = #attributes.VARIATION_COMPENENT_ID_RELATION#,
					VARIATION_PROPERTY_DETAIL_ID=#attributes.VARIATION_NAME_ID#,
					VARIATION_PRODUCTS=<cfif len(attributes.VARIATION_STOCKS_ID_RELATION)>'#attributes.VARIATION_STOCKS_ID_RELATION#'<cfelse>NULL</cfif>,
					VARIATION_PRODUCTS_AMOUNT=<cfif len(attributes.VAR_MAX_AMOUNT_RELATION)>#attributes.VAR_MAX_AMOUNT_RELATION#<cfelse>1</cfif>,
					VARIATION_PRODUCTS_AMOUNTS=<cfif len(attributes.variation_stocks_id_relation) and listlen(max_list_)>'#max_list_#'<cfelse>NULL</cfif>,
					VARIATON_IS_VALUE_1=#attributes.VAR_IS_VALUE_1_RELATION#,
					VARIATON_IS_VALUE_2=#attributes.VAR_IS_VALUE_2_RELATION#,
					VARIATON_IS_TOLERANCE=#attributes.VAR_IS_TOLERANCE_RELATION#,
					VARIATON_IS_UNIT=#attributes.VAR_IS_UNIT_RELATION#,
					VARIATON_PROPERTY_DETAIL=<cfif len(attributes.VAR_PROPERTY_DETAIL_RELATION)>'#attributes.VAR_PROPERTY_DETAIL_RELATION#'<cfelse>NULL</cfif>,
					VARIATION_SCRIPT=<cfif len(attributes._VARIATION_PRODUCT_scrpt_RELATION_)>'#attributes._VARIATION_PRODUCT_scrpt_RELATION_#'<cfelse>NULL</cfif>,
					VARIATION_TYPE=#attributes.VARIATION_TYPE_RELATION#,
					VARIATION_ORDER_NO=<cfif len(attributes.pv_order_no_relation)>#attributes.pv_order_no_relation#<cfelse>NULL</cfif>
               WHERE 
                    CONFIGURATOR_VARIATION_ID = #attributes.product_configurator_variation_id_rel#
            </cfquery>
			
			<script type="text/javascript">
				<cfoutput>
					document.getElementById("var_max_amount_relation#attributes.variation_row_id#").value = commaSplit(document.getElementById("var_max_amount_relation#attributes.variation_row_id#").value);
					<cfloop from="2" to="#x_product_count#" index="rcc">
						document.getElementById("vr#rcc#_var_max_amount_relation#attributes.variation_row_id#").value = commaSplit(document.getElementById("vr#rcc#_var_max_amount_relation#attributes.variation_row_id#").value);
					</cfloop>
				</cfoutput>
			</script>
   </cfif>
<cfelseif TYPE eq 2><!--- 2 ise SİLME --->
	<cfif isdefined('attributes.is_chapter')><!--- CHAPTER İSE --->
    	<cfquery name="DELETE_SETUP_PRODUCT_CONFIGURATOR_CHAPTER" datasource="#dsn3#">
        	DELETE SETUP_PRODUCT_CONFIGURATOR_CHAPTER WHERE CONFIGURATOR_CHAPTER_ID = #attributes.CONFIGURATOR_CHAPTER_ID#<!--- ÖNCE BÖLÜMÜMÜZÜ SİLDİK --->
            DELETE SETUP_PRODUCT_CONFIGURATOR_COMPONENTS WHERE CONFIGURATOR_CHAPTER_ID = #attributes.CONFIGURATOR_CHAPTER_ID#<!--- DAHA SONRA BU BÖLÜM İLE İLİŞKİLENDİRİLMİŞ OLAN COMPENENTLERİ SİLDİK. --->
            DELETE SETUP_PRODUCT_CONFIGURATOR_VARIATION WHERE PRODUCT_CHAPTER_ID = #attributes.CONFIGURATOR_CHAPTER_ID#<!--- dAHA SONRADA COMPENENTE AİT VARYASYONLARI SİLDİK! --->     
        </cfquery>
    <cfelseif isdefined('attributes.is_compenent')><!--- COMPENENT İSE --->
        <cfquery name="DELETE_SETUP_PRODUCT_CONFIGURATOR_COMPENENT" datasource="#dsn3#">
            DELETE SETUP_PRODUCT_CONFIGURATOR_COMPONENTS WHERE PRODUCT_CONFIGURATOR_COMPENENTS_ID = #attributes.PRODUCT_CONFIGURATOR_COMPENENTS_ID#<!--- COMPENENT'İ SİLDİK --->
            DELETE SETUP_PRODUCT_CONFIGURATOR_VARIATION WHERE PRODUCT_COMPENENT_ID = #attributes.PRODUCT_CONFIGURATOR_COMPENENTS_ID#<!--- dAHA SONRADA COMPENENTE AİT VARYASYONLARI SİLDİK! --->            
        </cfquery>
    <cfelseif isdefined('attributes.is_variation')><!--- VARYASYON İSE --->
    	 <cfquery name="DELETE_SETUP_PRODUCT_CONFIGURATOR_COMPENENT" datasource="#dsn3#">
			DELETE SETUP_PRODUCT_CONFIGURATOR_VARIATION WHERE CONFIGURATOR_VARIATION_ID = #attributes.product_confg_id# OR RELATION_CONFIGURATOR_VARIATION_ID = #attributes.product_confg_id#
        </cfquery>
    <cfelseif isdefined('attributes.is_variation_relation')><!---İLİŞKİLİ VARYASYON İSE --->
    	 <cfquery name="DELETE_SETUP_PRODUCT_CONFIGURATOR_COMPENENT" datasource="#dsn3#">
			DELETE SETUP_PRODUCT_CONFIGURATOR_VARIATION WHERE CONFIGURATOR_VARIATION_ID = #attributes.product_confg_id# 
        </cfquery>
    </cfif>
</cfif>

