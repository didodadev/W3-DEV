<cfsetting showdebugoutput="no">
<cfif isdefined('attributes.cat_id') and len(attributes.cat_id)>
    <cfquery name="get_property_variation" datasource="#dsn1#">
       SELECT
            PP.PROPERTY_ID,
            PP.PROPERTY,
            PPD.PROPERTY_DETAIL_ID,
            PPD.PROPERTY_DETAIL,
            PCP.PRODUCT_CAT_ID
        FROM
            PRODUCT_PROPERTY PP,
            PRODUCT_PROPERTY_DETAIL PPD,
            PRODUCT_CAT_PROPERTY PCP
        WHERE
            PP.PROPERTY_ID = PPD.PRPT_ID
            AND PP.PROPERTY_ID=PCP.PROPERTY_ID
            AND PCP.PROPERTY_ID=PPD.PRPT_ID
            AND PCP.PRODUCT_CAT_ID=#attributes.cat_id#
        ORDER BY
            PP.PROPERTY,
            PPD.PROPERTY_DETAIL
    </cfquery>
<cfelse>
	<cfquery name="get_property_variation" datasource="#dsn1#">
	SELECT
		PP.PROPERTY_ID,
		PP.PROPERTY,
		PPD.PROPERTY_DETAIL_ID,
		PPD.PROPERTY_DETAIL
	FROM
		PRODUCT_PROPERTY PP,
		PRODUCT_PROPERTY_DETAIL PPD
	WHERE
		PP.PROPERTY_ID = PPD.PRPT_ID
	ORDER BY
		PP.PROPERTY,
		PPD.PROPERTY_DETAIL
	</cfquery>
</cfif>
<cfparam name="attributes.mode" default="7">
<table border="0">
	<cfif get_property_variation.recordcount eq 0>
        <tr><td><cf_get_lang dictionary_id='37315.Bu kategoriye göre özellik mevcut değildir'>.</td></tr>
	<cfelse>
    <tr>
        <td class="formbold" colspan="7"><cf_get_lang dictionary_id ='37955.Ürün Özelliklerine Göre Detaylı Arama'></td>
    </tr>
    <cfoutput>
        <cfset a=0>
        <cfloop from="1" to="#get_property_variation.recordcount#" index="main_str">
			<cfif ((a mod attributes.mode is 0)) or (a eq 0)>
                <tr id="frm_row#main_str#">
			</cfif>
            <cfif get_property_variation.property_id[main_str] neq get_property_variation.property_id[main_str-1]>
                <td>
                	<table>
                    	<tr>
                        	<td>
                                <input type="hidden" name="row_kontrol#main_str#" id="row_kontrol#main_str#" value="1">
                                <input type="hidden" name="property_id#main_str#" id="property_id#main_str#" value="#get_property_variation.property_id[main_str]#">
                                <select name="variation_id#main_str#" id="variation_id#main_str#" style="width:150px" onchange="showInformation(#main_str#);">
                                    <option value="">#get_property_variation.property[main_str]#</option>
                                    <cfloop from="#main_str#" to="#get_property_variation.recordcount#" index="str">
                                    	<cfif get_property_variation.property_id[main_str] eq get_property_variation.property_id[str]>
                                            <option value="#get_property_variation.property_detail_id[str]#" <cfif isdefined('attributes.list_variation_id') and listfind(attributes.list_variation_id,get_property_variation.property_detail_id[str])>selected</cfif>>&nbsp;&nbsp;&nbsp;#get_property_variation.property_detail[str]#</option>
                                        <cfelse>
                                            <cfbreak>
                                        </cfif>
                                    </cfloop>
                                 </select>
                                <cfset a=a+1>
                            </td>
                        </tr>
                        <tr  id="information_row#main_str#" <cfif isdefined('attributes.list_variation_id') and listfind(attributes.list_property_id,get_property_variation.property_id[main_str])><cfelse>style="display:none;"</cfif>>
                        	<td>
                            	<input type="hidden" name="information_select#main_str#" style="width:80px;" id="information_select" value="<cfif isdefined('attributes.list_property_value') and listfind(attributes.list_property_id,get_property_variation.property_id[main_str]) and listgetat(attributes.list_property_value,listfind(attributes.list_property_id,get_property_variation.property_id[main_str]),',') neq 'empty'>#listgetat(attributes.list_property_value,listfind(attributes.list_property_id,get_property_variation.property_id[main_str]),',')#</cfif>" />
                            </td>
                        </tr>
                    </table>
				 </td>
            </cfif>
            <cfif ((a mod attributes.mode eq 0)) or (a eq get_property_variation.recordcount)>
                </tr>
            </cfif>
        </cfloop>
	</cfoutput>
</cfif>
</table>
<script type="text/javascript">
	function showInformation(row)
	{
		if(document.getElementById("variation_id"+row).value=='')
			document.getElementById("information_row"+row).style.display='none';
		else
			document.getElementById("information_row"+row).style.display='';
	}
</script>
<cfabort>
