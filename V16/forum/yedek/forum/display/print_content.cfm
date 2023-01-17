<cfquery name="GET_TOPIC" datasource="#DSN#">
	SELECT TITLE FROM FORUM_TOPIC WHERE TOPICID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.topicid#">
</cfquery>

<cfquery name="GET_REPLIES" datasource="#DSN#">
    SELECT 
        FP.SPECIAL_DEFINITION_ID, 
        FP.REPLY,
        SSD.SPECIAL_DEFINITION 
    FROM 
        FORUM_REPLYS FP,
        SETUP_SPECIAL_DEFINITION SSD
    WHERE 
        FP.SPECIAL_DEFINITION_ID = SSD.SPECIAL_DEFINITION_ID AND 
        FP.TOPICID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.topicid#">
    UNION ALL
    SELECT 
        FP.SPECIAL_DEFINITION_ID, 
        FP.REPLY, 
        '' SPECIAL_DEFINITION 
    FROM 
        FORUM_REPLYS FP
    WHERE 
        FP.SPECIAL_DEFINITION_ID IS NULL AND
        FP.TOPICID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.topicid#"> 
    ORDER BY
        FP.SPECIAL_DEFINITION_ID ASC 
</cfquery>

<table style="width:100%;">
	<tr style="height:50px;">
    	<td style="font-size:20px; font-weight:bold; color:#FF6600; text-align:center;"><cfoutput>#get_topic.title#</cfoutput></td>
    </tr>  
    <cfquery name="GET_NON_SPEC_DEF_REPLIES" dbtype="query">
    	SELECT * FROM GET_REPLIES WHERE SPECIAL_DEFINITION_ID IS NULL
    </cfquery>
    <cfif get_non_spec_def_replies.recordcount>
    	<tr>
        	<td>
            	<div style="font-size:14px; font-weight:bold; color:#FF6600; text-align:center;">Özel Tanımı Olmayanlar</div>
                <cfoutput query="get_non_spec_def_replies">
                    <table>
                        <tr>
                            <td>#reply#</td>
                        </tr>
                    </table>
                </cfoutput>
            </td>
        </tr>
    </cfif>
	<cfset spec_list = listsort(listdeleteduplicates(ValueList(get_replies.special_definition_id,',')),'numeric','ASC',',')>
    <cfif len(spec_list)>
        <cfloop from="1" to="#listlen(spec_list)#" index="i">
            <cfquery name="GET_REPLIES_SPEC" dbtype="query">
                SELECT
                    *
                FROM
                    GET_REPLIES
                WHERE
                    SPECIAL_DEFINITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(spec_list,i,',')#">
            </cfquery>
            <tr>
                <td>
                    <div style="font-size:14px; font-weight:bold; color:#FF6600; text-align:center;"><cfoutput>#get_replies_spec.special_definition#</cfoutput></div> 
                    <cfif get_replies_spec.recordcount>  
                        <table style="width:100%;">                        	      
                        <cfoutput query="get_replies_spec">
                            <tr>
                                <td>#reply#</td>
                            </tr>   
                            <tr>
                                <td><hr style="height:1px; width:99%;" /></td>
                            </tr>
                        </cfoutput>
                        </table>
                    </cfif>
                </td>
            </tr>
        </cfloop>    
    <cfelse>
    	<tr>
        	<td>Kayıt Yok!</td>
        </tr>
    </cfif>
</table>
