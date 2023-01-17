<cfquery name="get_price_types" datasource="#dsn_dev#">
	SELECT
    	*,
        (SELECT LT.TYPE_NAME FROM LABEL_TYPES LT WHERE LT.TYPE_ID = PRICE_TYPES.LABEL_TYPE_ID) AS LABEL_TYPE
    FROM
    	PRICE_TYPES
</cfquery>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfsavecontent  variable="head"><cf_get_lang dictionary_id='61503.Fiyat Tipleri'></cfsavecontent>
    <cf_box title="#head#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='58527.ID'></th>
                    <th><cf_get_lang dictionary_id='61501.Tip Kodu'></th>
                    <th><cf_get_lang dictionary_id='61480.Fiyat Tipi'></th>
                    <th><cf_get_lang dictionary_id='43116.Default'></th>
                    <th><cf_get_lang dictionary_id='32677.Alış Satış'></th>
                    <th><cf_get_lang dictionary_id='61502.Kasa Çıkış'></th>
                    <th><cf_get_lang dictionary_id='61479.Etiket Tipi'></th>
                    <th><cf_get_lang dictionary_id='57483.Kayıt'></th>
                    <th><cf_get_lang dictionary_id='57703.Güncelleme'></th>
                    <th width="20"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=retail.price_types&event=upd&type_id=0','medium');"><i class="fa fa-plus"></i></a></th>
                </tr>
            </thead>
            <tbody>
            <cfoutput query="get_price_types">
                <tr>
                    <td>#type_id#</td>
                    <td>#TYPE_CODE#</td>
                    <td>#TYPE_name#</td>
                    <td><cfif IS_STANDART eq 1><cf_get_lang dictionary_id='57495.Evet'></cfif></td>
                    <td><cfif IS_PURCHASE_SALE eq 1><cf_get_lang dictionary_id='57495.Evet'></cfif></td>
                    <td><cfif IS_CASH_OUT eq 1><cf_get_lang dictionary_id='57495.Evet'></cfif></td>
                    <td>#LABEL_TYPE#</td>
                    <td>#dateformat(record_Date,'dd/mm/yyyy')#</td>
                    <td>#dateformat(update_Date,'dd/mm/yyyy')#</td>
                    <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=retail.price_types&event=upd&type_id=#type_id#','medium');"><img src="/images/update_list.gif"/></a></td>
                </tr>
            </cfoutput>
            </tbody>
        </cf_grid_list>
    </cf_box>
</div>