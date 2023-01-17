<cfquery name="GET_POS_CAT_REQ" datasource="#DSN#">
  SELECT 
    * 
  FROM 
    POSITION_REQUIREMENTS 
  WHERE 
	POSITION_CAT_ID = #attributes.POSITION_CAT_ID#
</cfquery>
<cf_box title="#getLang('','Pozisyon Gereklilikleri',55979)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cf_flat_list> 
        <cfif GET_POS_CAT_REQ.RECORDCOUNT>
            <cfform name="list_position_cat_requirement" action="" method="post">
                <input type="hidden" name="record_num" id="record_num" value="">
                <tr>
                    <th width="100"><cf_get_lang dictionary_id="55980.Gereklilik Tipi"></th>
                    <th><cf_get_lang dictionary_id='58984.Puan'></th>
                </tr>
                <cfoutput query="GET_POS_CAT_REQ">
                    <cfquery name="GET_REQ_TYPE" datasource="#DSN#">
                        SELECT REQ_TYPE FROM POSITION_REQ_TYPE WHERE REQ_TYPE_ID = #REQ_TYPE_ID#
                    </cfquery>
                    <tr>
                        <td class="text-center">#GET_REQ_TYPE.REQ_TYPE#</td>
                        <td class="text-center">#GET_POS_CAT_REQ.COEFFICIENT#</td>
                    </tr>
                </cfoutput>
            </cfform>
        <cfelse>
            <tr>
                <td colspan="2"><cf_get_lang dictionary_id="35381.Pozisyon İle İlgili Gereklilik Kaydı Yok"></td>
            </tr>
        </cfif>
	</cf_flat_list>
</cf_box>
