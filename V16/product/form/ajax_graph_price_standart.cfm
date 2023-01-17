<cfquery datasource="#DSN3#" name="UNITS">
	SELECT
		*
	FROM
		PRODUCT_UNIT
	WHERE 
		PRODUCT_ID = #attributes.pid#
</cfquery>
<cfoutput query="UNITS">
	<cfquery name="GET_DATAS"  maxrows="5" datasource="#dsn3#">
		SELECT 
			PRICESTANDART_ID
		FROM 
			PRICE_STANDART
		WHERE 
			PRICE_STANDART.PRODUCT_ID = #URL.PID# 
		AND 
			PURCHASESALES = 1 
		ORDER BY 
			RECORD_DATE DESC
	</cfquery>
	<cfset PRI_ROWS=ValueList(GET_DATAS.PRICESTANDART_ID,",") >
	<cfquery name="GET_GRAPH_DATA#PRODUCT_UNIT_ID#" DATASOURCE="#DSN3#" MAXROWS="5">
		SELECT 
			PRICE_STANDART.RECORD_DATE,PRICE,money 
		FROM 
			PRICE_STANDART, PRODUCT_UNIT
		WHERE 
			PRODUCT_UNIT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID 
			AND PRICE_STANDART.UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID 
			AND PRICE_STANDART.PRODUCT_ID = #URL.PID# 
			AND PURCHASESALES = 1
			AND	PRODUCT_UNIT.PRODUCT_UNIT_ID = #PRODUCT_UNIT_ID#
			AND PRICESTANDART_ID IN (#PRI_ROWS#)
		ORDER BY 
			PRICESTANDART_ID
	</cfquery>
	<cfset QUERYNAME= Evaluate('GET_GRAPH_DATA'&PRODUCT_UNIT_ID)>
</cfoutput>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='57636.Birim'> <cf_get_lang dictionary_id='37199.Fiyat Değişimleri'></cfsavecontent>
<cf_box closable="0" title="#message#">
    <cfform action="#request.self#?fuseaction=product.ajax_graph_price_standart&pid=#attributes.pid#" method="post" name="form_stock">
        <cf_form_list>
            <thead>
                <cfif isDefined("attributes.product_name")>
                    <input type="hidden" name="product_name" id="product_name" value="<cfoutput>#attributes.product_name#</cfoutput>">
                </cfif>	
                <tr>		  		
                    <th style="text-align:right;"> 
                        <select name="graph_type" id="graph_type" style="width:100px;">
                            <option value="" selected><cf_get_lang dictionary_id='57950.Grafik Format'></option>
                            <option value="pie"><cf_get_lang dictionary_id='58728.Pasta'></option>
                            <option value="line"><cf_get_lang dictionary_id='57665.Eğri'></option>
                            <option value="bar"><cf_get_lang dictionary_id='57663.Bar'></option>
                        </select>
                        <cf_wrk_search_button>
                    </th>	
                </tr>
             </thead>
        </cf_form_list>
        <table>
            <tr>          
                <td>
                    <cfif isDefined("form.graph_type") and len(form.graph_type)>
                        <cfset graph_type = form.graph_type>
                    <cfelse>
                        <cfset graph_type = "line">
                    </cfif>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57638.Birim Fiyat'></cfsavecontent>
                    <cfchart format="jpg" show3d="no" yaxistitle="#message#" pieslicestyle="solid" font="arialunicodeMS" chartwidth="280" chartheight="250">
                        <cfloop query="UNITS">
                            <cfchartseries type="#graph_type#" seriesLabel="#UNITS.ADD_UNIT#">
                                <cfset QUERYNAME= Evaluate('GET_GRAPH_DATA'&PRODUCT_UNIT_ID)>
                                <cfloop query="QUERYNAME" startrow="1" endrow="5">
                                    <cfchartdata value="#price#">
                                </cfloop>
                            </cfchartseries>
                        </cfloop>
                    </cfchart>  
                </td>
            </tr>
        </table>
    </cfform>
</cf_box>

