<cfquery name="get_price_types" datasource="#dsn_dev#">
    SELECT
        *
    FROM
        PRICE_TYPES
    ORDER BY
    	IS_STANDART DESC,
    	TYPE_ID ASC
</cfquery>
<cfquery name="get_price" datasource="#dsn_Dev#">
	SELECT * FROM PRICE_TABLE WHERE ROW_ID = #attributes.row_id#
</cfquery>
<cf_popup_box title="Fiyat Güncelle">	
	<cfform name="add_pos" id="add_pos" method="post" action="#request.self#?fuseaction=retail.emptypopup_upd_price">
		<cfinput type="hidden" name="row_id" value="#attributes.row_id#"/>
        <cfoutput query="get_price">
        <table>
        	<tr>
            	<td width="75">Tablo Kodu</td>
                <td>#table_code#</td>
            </tr>
            <tr>
            	<td>Alış KDVli</td>
                <td>#tlformat(NEW_ALIS_KDV)#</td>
            </tr>  
            <tr>
            	<td>Satış KDVli</td>
                <td>#tlformat(NEW_PRICE_KDV)#</td>
            </tr>
            <tr>
            	<td>Fiyat Tipi</td>
                <td>
                	<select name="price_type" id="price_type">
                        <cfloop query="get_price_types">
                            <cfoutput><option value="#get_price_types.type_id#" <cfif get_price.price_type eq get_price_types.type_id>selected</cfif>>#get_price_types.TYPE_code#</option></cfoutput>
                        </cfloop>
                    </select>
                </td>
            </tr>
            <tr>
            	<td>Alış Tarihler</td>
                <td>
                	<cfinput type="text" name="p_startdate" id="p_startdate" maxlength="10" value="#dateformat(p_startdate,'dd/mm/yyyy')#" style="width:65px;" required="yes" validate="eurodate" message="Tarih Hatalı!">
                	<cf_wrk_date_image date_field="p_startdate">
                    
                    <cfinput type="text" name="p_finishdate" id="p_finishdate" maxlength="10" value="#dateformat(p_finishdate,'dd/mm/yyyy')#" style="width:65px;" required="yes" validate="eurodate" message="Tarih Hatalı!">
                	<cf_wrk_date_image date_field="p_finishdate">
                </td>
            </tr>
            <tr>
            	<td>Satış Tarihler</td>
                <td>
                	<cfinput type="text" name="startdate" id="startdate" maxlength="10" value="#dateformat(startdate,'dd/mm/yyyy')#" style="width:65px;" required="yes" validate="eurodate" message="Tarih Hatalı!">
                	<cf_wrk_date_image date_field="startdate">
                    
                    <cfinput type="text" name="finishdate" id="finishdate" maxlength="10" value="#dateformat(finishdate,'dd/mm/yyyy')#" style="width:65px;" required="yes" validate="eurodate" message="Tarih Hatalı!">
                	<cf_wrk_date_image date_field="finishdate">
                </td>
            </tr>      
        </table>
        </cfoutput>
		<cf_popup_box_footer>
			<cf_workcube_buttons is_upd='0'>
		</cf_popup_box_footer>
	</cfform>
</cf_popup_box>	
