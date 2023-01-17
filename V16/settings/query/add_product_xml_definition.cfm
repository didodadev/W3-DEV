<cflock name="#CreateUUID()#" timeout="500">
	<cftransaction>
        <cfquery name="ADD_SETUP_PRODUCT_XML_DEFINITION" datasource="#DSN3#"> 
            INSERT INTO 
                SETUP_PRODUCT_XML_DEFINITION
            (
                XML_DEFINITION_NAME,
                RECORD_DATE,
                RECORD_EMP,
                RECORD_IP
            ) 
            VALUES 
            (
                '#trim(attributes.xml_definition_name)#',
                #now()#,
                #session.ep.userid#,
                '#cgi.remote_addr#'
            )
        </cfquery>
        
        <cfquery name="GET_MAX" datasource="#DSN3#">
            SELECT MAX(XML_DEFINITION_ID) XML_DEFINITION_ID FROM SETUP_PRODUCT_XML_DEFINITION
        </cfquery>
        
        <cfquery name="ADD_SETUP_PRODUCT_XML_DEFINITION_ROW" datasource="#DSN3#">
            <cfloop index = "LoopCount" from = "1" to = "#listlen(attributes.product_catid)#"> 
                INSERT INTO SETUP_PRODUCT_XML_DEFINITION_ROW (XML_DEFINITION_ID,ACTION_TYPE,ACTION_ID) VALUES (#get_max.xml_definition_id#,'PRODUCT_CATID',#listgetat(attributes.product_catid,LoopCount)#)
            </cfloop>
            <cfloop index = "LoopCount" from = "1" to = "#listlen(attributes.price_catid)#"> 
                INSERT INTO SETUP_PRODUCT_XML_DEFINITION_ROW (XML_DEFINITION_ID,ACTION_TYPE,ACTION_ID) VALUES (#get_max.xml_definition_id#,'PRICE_CATID',#listgetat(attributes.price_catid,LoopCount)#)
            </cfloop>    
            <cfloop index = "LoopCount" from = "1" to = "#listlen(attributes.file_name)#"> 
                INSERT INTO SETUP_PRODUCT_XML_DEFINITION_ROW (XML_DEFINITION_ID,ACTION_TYPE,ACTION_VALUE) VALUES (#get_max.xml_definition_id#,'FILE_NAME','#trim(listgetat(attributes.file_name,LoopCount))#')
            </cfloop>
                INSERT INTO SETUP_PRODUCT_XML_DEFINITION_ROW (XML_DEFINITION_ID,ACTION_TYPE,ACTION_ID) VALUES (#get_max.xml_definition_id#,'DETAIL1','#attributes.detail1#')
				INSERT INTO SETUP_PRODUCT_XML_DEFINITION_ROW (XML_DEFINITION_ID,ACTION_TYPE,ACTION_ID) VALUES (#get_max.xml_definition_id#,'DETAIL2','#attributes.detail2#')
        </cfquery>
	</cftransaction>
</cflock>
 
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
