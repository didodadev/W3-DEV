<cfquery name="GET_PROPERTY" datasource="#DSN1#" maxrows="10">
	SELECT DISTINCT
		PP.PROPERTY,
		PP.PROPERTY_ID
	FROM 
		PRODUCT_PROPERTY PP,
		PRODUCT_PROPERTY_OUR_COMPANY PPO
	WHERE
		PP.PROPERTY_ID = PPO.PROPERTY_ID AND
		PPO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#"> AND
		PP.IS_INTERNET = 1 AND
		PP.IS_ACTIVE = 1
</cfquery>

<cfquery name="GET_ALL_PROPERTY_DETAIL" datasource="#DSN1#">
	SELECT
		PRPT_ID,
		PROPERTY_DETAIL_ID,
		PROPERTY_DETAIL
	FROM
		PRODUCT_PROPERTY_DETAIL
</cfquery>
<cfquery name="GET_LANGUAGE_INFOS" datasource="#DSN#">
    SELECT
        ITEM,
        UNIQUE_COLUMN_ID
    FROM
        SETUP_LANGUAGE_INFO
    WHERE
        <cfif isdefined('session.pp')>
            LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pp.language#"> AND
        <cfelse>
            LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ww.language#"> AND
        </cfif>
        COLUMN_NAME = 'PROPERTY' AND
        TABLE_NAME = 'PRODUCT_PROPERTY'
</cfquery>
<cfquery name="GET_LANGUAGE_INFOS2" datasource="#DSN#">
    SELECT
        ITEM,
        UNIQUE_COLUMN_ID
    FROM
        SETUP_LANGUAGE_INFO
    WHERE
        <cfif isdefined('session.pp')>
            LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pp.language#"> AND
        <cfelse>
            LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ww.language#"> AND
        </cfif>
        COLUMN_NAME = 'PROPERTY_DETAIL' AND
        TABLE_NAME = 'PRODUCT_PROPERTY_DETAIL'
</cfquery>

<cfform name="search_product_property" action="#request.self#?fuseaction=objects2.view_product_list" method="post">
	<table align="center">
		<input type="hidden" name="form_submitted" id="form_submitted">
   		<cfif get_property.recordcount>
			<tr>
                <td style="vertical-align:top;">
                    <table>
                        <input type="hidden" name="product_catid" id="product_catid" value="<cfif isdefined("attributes.product_catid") and len(attributes.product_catid)><cfoutput>#attributes.product_catid#</cfoutput></cfif>">
                        <input type="hidden" name="hierarchy" id="hierarchy" value="<cfif isdefined("attributes.hierarchy") and len(attributes.hierarchy)><cfoutput>#attributes.hierarchy#</cfoutput></cfif>">
                		<input type="hidden" name="list_property_id" id="list_property_id" value="<cfif isdefined("attributes.list_property_id") and len(attributes.list_property_id)><cfoutput>#attributes.list_property_id#</cfoutput></cfif>">
                      	<input type="hidden" name="list_variation_id" id="list_variation_id" value="<cfif isdefined("attributes.list_variation_id") and len(attributes.list_variation_id)><cfoutput>#attributes.list_variation_id#</cfoutput></cfif>">
                      	<cfoutput query="get_property">
                          	<cfquery name="GET_VARIATION" dbtype="query">
                                SELECT
                                    PROPERTY_DETAIL_ID,
                                    PROPERTY_DETAIL
                                FROM
                                    GET_ALL_PROPERTY_DETAIL
                                WHERE
                                    PRPT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#property_id#">
                          	</cfquery>
                          	<cfquery name="GET_LANGUAGE_INFO" dbtype="query">
                                SELECT
                                    *
                                FROM
                                    GET_LANGUAGE_INFOS
                                WHERE
                                    UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#property_id#">
                          	</cfquery>
                         	<cfif ((currentrow mod 5 is 1)) or (currentrow eq 1)><tr></cfif>
                            	<!---<td width="90">#property#</td> --->
                            	<td <cfif ((currentrow mod 2 is 1)) or (currentrow eq 1)> style="width:140px;"</cfif>>
                              		<input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
                              		<input type="hidden" name="property_id#currentrow#" id="property_id#currentrow#" value="#property_id#">
                              		<select name="variation_id#currentrow#" id="variation_id#currentrow#" style="width:135px;">
                              			<option value=""><cfif len(get_language_info.recordcount)>#get_language_info.item#<cfelse>#property#</cfif></option>
                              			<cfloop query="get_variation">	
                              				<cfquery name="GET_LANGUAGE_INFO2" dbtype="query">
                                                SELECT
                                                    *
                                                FROM
                                                    GET_LANGUAGE_INFOS2
                                                WHERE
                                                    UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#property_detail_id#">
                                            </cfquery>
                                			<option value="#property_detail_id#" <cfif isdefined("attributes.list_variation_id") and listfind(attributes.list_variation_id,get_variation.property_detail_id,',')>selected</cfif>>&nbsp;&nbsp;&nbsp;<cfif len(get_language_info2.recordcount)>#get_language_info2.item#<cfelse>#property_detail#</cfif></option>
                              			</cfloop>
                              		</select>
                            	</td>
                          	<cfif ((currentrow mod 5 is 0)) or (currentrow eq recordcount)></tr></cfif>
                      	</cfoutput>
                    </table>
                </td>
				<cfsavecontent variable="alert"><cf_get_lang_main no ='153.Ara'></cfsavecontent>
				<td valign="bottom"><cf_workcube_buttons is_cancel="0" insert_info="#alert#" add_function='gonder()' insert_alert=''></td>
			</tr>
		</cfif>
	</table>
</cfform>

<script type="text/javascript">
	row_count=<cfoutput>#get_property.recordcount#</cfoutput>;
	function gonder()
	{
		document.getElementById('list_property_id').value= '';
		document.getElementById('list_variation_id').value= '';
		for(r=1;r<=row_count;r++)
		{
			deger_property_id = eval("document.getElementById('property_id"+r+"')");
			deger_variation_id = eval("document.getElementById('variation_id"+r+"')");
			if(deger_variation_id.value != "")
			{
				if(document.getElementById('list_property_id').value.length==0) ayirac=''; else ayirac=',';
				document.getElementById('list_property_id').value=document.getElementById('list_property_id').value+ayirac+deger_property_id.value;
				document.getElementById('list_variation_id').value=document.getElementById('list_variation_id').value+ayirac+deger_variation_id.value;
			}
		}
		return true;
	}
</script>

