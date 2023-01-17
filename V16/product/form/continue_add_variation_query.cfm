<cfif isdefined('attributes.configurator_variation_id')><!--- Güncelleme ise --->
    <cfquery name="UPD_SETUP_PRODUCT_CONFIGURATOR_VARIATION" datasource="#DSN3#">
        UPDATE 	SETUP_PRODUCT_CONFIGURATOR_VARIATION
        SET
            VARIATION_PROPERTY_DETAIL_ID=#attributes.TREE_VARIATION_ID#,
            VARIATON_IS_VALUE_1=#attributes.TREE_VAR_IS_VALUE_1#,
            VARIATON_IS_VALUE_2=#attributes.TREE_VAR_IS_VALUE_2#,
            VARIATON_IS_TOLERANCE=#attributes.TREE_VAR_IS_TOLERANCE#,
            VARIATON_IS_UNIT=#attributes.TREE_VAR_IS_UNIT#,
            VARIATION_PRODUCTS_AMOUNT=#attributes.TREE_VAR_MAX_AMOUNT#,
            VARIATON_PROPERTY_DETAIL=<cfif len(attributes.TREE_VAR_PROPERTY_DETAIL)>'#attributes.TREE_VAR_PROPERTY_DETAIL#'<cfelse>NULL</cfif>,
            VARIATION_SCRIPT=<cfif len(attributes.TREE_VAR_PRODUCT_SCRPT)>'#attributes.TREE_VAR_PRODUCT_SCRPT#'<cfelse>NULL</cfif>,
            VARIATION_TYPE=#attributes.TREE_VAR_TYPE#
		WHERE  
        	CONFIGURATOR_VARIATION_ID = #attributes.configurator_variation_id#
    </cfquery>
<cfelseif isdefined('attributes.del_variation_id')>
	<cfscript>
			all_variation_id_list = attributes.del_variation_id;
    	    function get_subs(conf_variation_id){
				queryStr = 'SELECT CONFIGURATOR_VARIATION_ID FROM SETUP_PRODUCT_CONFIGURATOR_VARIATION WHERE RELATION_CONFIGURATOR_VARIATION_ID=#conf_variation_id#';
				queryResult = cfquery(SQLString : queryStr, Datasource : dsn3);
				variation_id_list =ValueList(queryResult.CONFIGURATOR_VARIATION_ID,',');
				all_variation_id_list=ListAppend(all_variation_id_list,variation_id_list,',');
				return variation_id_list;
			}
			function getConfTree(conf_variation_id)
				{
					var i = 1;
					var sub_variation = get_subs(conf_variation_id);
					for (i=1; i lte listlen(sub_variation,','); i = i+1){
						new_variation_id = ListGetAt(sub_variation,i,',');
						getConfTree(new_variation_id);
					}
				}
			getConfTree(attributes.del_variation_id);//silinecek varyasyonun altındakileride silicez..	
			all_variation_id_list=listdeleteduplicates(all_variation_id_list);
    </cfscript>
	<cfquery name="delete_prod_conf" datasource="#dsn3#">
        SET NOCOUNT ON
        DELETE SETUP_PRODUCT_CONFIGURATOR_VARIATION WHERE CONFIGURATOR_VARIATION_ID IN (#all_variation_id_list#)
        SELECT @@Identity AS PRODUCT_CONF_VARIATION_ID      
        SET NOCOUNT OFF
    </cfquery>
    <cfif len(delete_prod_conf.PRODUCT_CONF_VARIATION_ID)><!--- burda gelen değer NULL,sadece ajax ile açılan sayfayı yenilemeden önce query işleminin bitmesini beklemek için eklendi.. --->
		<script type="text/javascript">
			<cfoutput>
			addContinueVariaton(#attributes.chapter_id#,#attributes.compenent_id#,#attributes.sub_variation_id#,tempX,tempY,#attributes.productConfId#);
			</cfoutput>
        </script>
	</cfif>
<cfelse>
    <cfquery name="ADD_SETUP_PRODUCT_CONFIGURATOR_VARIATION" datasource="#DSN3#">
        SET NOCOUNT ON
        INSERT INTO  SETUP_PRODUCT_CONFIGURATOR_VARIATION
        (
            RELATION_CONFIGURATOR_VARIATION_ID,
            PRODUCT_CONFIGURATOR_ID,
            PRODUCT_CHAPTER_ID,
            PRODUCT_COMPENENT_ID,
            VARIATION_PROPERTY_DETAIL_ID,
            VARIATON_IS_VALUE_1,
            VARIATON_IS_VALUE_2,
            VARIATON_IS_TOLERANCE,
            VARIATON_IS_UNIT,
            VARIATION_PRODUCTS_AMOUNT,
            VARIATON_PROPERTY_DETAIL,
            VARIATION_SCRIPT,
            VARIATION_TYPE
        )
        VALUES
        (	
            #attributes.REL_VARIATION_ID#,
            #attributes.productConfId#,
            #attributes.CHAPTER_ID#,
            #attributes.COMPENENT_ID#,
            #attributes.TREE_VARIATION_ID#,
            #attributes.TREE_VAR_IS_VALUE_1#,
            #attributes.TREE_VAR_IS_VALUE_2#,
            #attributes.TREE_VAR_IS_TOLERANCE#,
            #attributes.TREE_VAR_IS_UNIT#,
            #attributes.TREE_VAR_MAX_AMOUNT#,
            <cfif len(attributes.TREE_VAR_PROPERTY_DETAIL)>'#attributes.TREE_VAR_PROPERTY_DETAIL#'<cfelse>NULL</cfif>,
            <cfif len(attributes.TREE_VAR_PRODUCT_SCRPT)>'#attributes.TREE_VAR_PRODUCT_SCRPT#'<cfelse>NULL</cfif>,
            #attributes.TREE_VAR_TYPE#
        )
        SELECT @@Identity AS PRODUCT_CONF_VARIATION_ID      
        SET NOCOUNT OFF
    </cfquery>
    <cfif ADD_SETUP_PRODUCT_CONFIGURATOR_VARIATION.PRODUCT_CONF_VARIATION_ID gt 0>
        <script type="text/javascript">
            <cfoutput>
            addContinueVariaton(#attributes.chapter_id#,#attributes.compenent_id#,#attributes.sub_variation_id#,tempX,tempY,#attributes.productConfId#);
            </cfoutput>
        </script>
    </cfif>
</cfif>

