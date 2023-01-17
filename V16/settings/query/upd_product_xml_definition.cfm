<cflock name="#CreateUUID()#" timeout="500">
	<cftransaction>
        <cfquery name="UPD_SETUP_PRODUCT_XML_DEFINITION" datasource="#DSN3#">
            UPDATE 
                SETUP_PRODUCT_XML_DEFINITION 
            SET 
                XML_DEFINITION_NAME =  '#trim(attributes.xml_definition_name)#',
                RECORD_DATE = #now()#,
                RECORD_EMP = #session.ep.userid#,
                RECORD_IP = '#cgi.remote_addr#'
            WHERE 
                XML_DEFINITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_xml_definition_id#">
        </cfquery> 
        
        <cfquery name="DEL_SETUP_PRODUCT_XML_DEFINITION_ROW" datasource="#DSN3#">
            DELETE FROM SETUP_PRODUCT_XML_DEFINITION_ROW WHERE XML_DEFINITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_xml_definition_id#">
        </cfquery>
        
        <cfquery name="ADD_SETUP_PRODUCT_XML_DEFINITION_ROW" datasource="#DSN3#">
            <cfloop index = "LoopCount" from = "1" to = "#listlen(attributes.product_catid)#"> 
                INSERT INTO SETUP_PRODUCT_XML_DEFINITION_ROW (XML_DEFINITION_ID,ACTION_TYPE,ACTION_ID) VALUES (#attributes.product_xml_definition_id#,'PRODUCT_CATID',#listgetat(attributes.product_catid,LoopCount)#)
            </cfloop>
            <cfloop index = "LoopCount" from = "1" to = "#listlen(attributes.price_catid)#"> 
                INSERT INTO SETUP_PRODUCT_XML_DEFINITION_ROW (XML_DEFINITION_ID,ACTION_TYPE,ACTION_ID) VALUES (#attributes.product_xml_definition_id#,'PRICE_CATID',#listgetat(attributes.price_catid,LoopCount)#)
            </cfloop>    
            <cfloop index = "LoopCount" from = "1" to = "#listlen(attributes.file_name)#"> 
                INSERT INTO SETUP_PRODUCT_XML_DEFINITION_ROW (XML_DEFINITION_ID,ACTION_TYPE,ACTION_VALUE) VALUES (#attributes.product_xml_definition_id#,'FILE_NAME','#trim(listgetat(attributes.file_name,LoopCount))#')
            </cfloop>
            	INSERT INTO SETUP_PRODUCT_XML_DEFINITION_ROW (XML_DEFINITION_ID,ACTION_TYPE,ACTION_ID) VALUES (#attributes.product_xml_definition_id#,'DETAIL1','#attributes.detail1#')
				INSERT INTO SETUP_PRODUCT_XML_DEFINITION_ROW (XML_DEFINITION_ID,ACTION_TYPE,ACTION_ID) VALUES (#attributes.product_xml_definition_id#,'DETAIL2','#attributes.detail2#')
        </cfquery>
        
	</cftransaction>
</cflock>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
