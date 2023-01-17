<cfparam name="attributes.modal_id" default="">
<cfquery name="GET_STOPPAGE_RATES" datasource="#dsn2#">
  SELECT STOPPAGE_RATE,STOPPAGE_ACCOUNT_CODE,STOPPAGE_RATE_ID,DETAIL FROM SETUP_STOPPAGE_RATES 
  WHERE 
    1=1 
  <cfif isDefined("attributes.bank_code") and len(attributes.bank_code)> 
      AND SETUP_BANK_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bank_code#">
  </cfif>
</cfquery>
<script type="text/javascript">
function add_stoppage(stoppage_rate,stoppage_rate_id)
{
	<cfif isDefined("attributes.field_stoppage_rate")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.field_stoppage_rate#</cfoutput>.value = stoppage_rate;
	</cfif>
	<cfif isDefined("attributes.field_stoppage_rate_id")>
    <cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.field_stoppage_rate_id#</cfoutput>.value = stoppage_rate_id;
	</cfif>
	<cfif isdefined("attributes.call_function")>
		try{<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.call_function#</cfoutput>;}
			catch(e){};
	</cfif>
<cfif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );<cfelse>window.close();</cfif>
}
</script>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='33258.Stopaj Oranları'></cfsavecontent>
  <cf_box title="#message#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cf_flat_list>
    	<thead>
          <tr>
            <th><cf_get_lang dictionary_id="32930.Stopaj Oranı"></th>
            <th><cf_get_lang dictionary_id="32694.Muhasebe Hesabı"></th>
            <th><cf_get_lang dictionary_id="57629.Açıklama"></th>
          </tr>
        </thead>
        <tbody>
		  <cfoutput query="GET_STOPPAGE_RATES">
          <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
            <td>
                <a href="javascript:add_stoppage('#tlformat(STOPPAGE_RATE,attributes.field_decimal)#','#STOPPAGE_RATE_ID#');" class="tableyazi">#tlformat(STOPPAGE_RATE,attributes.field_decimal)#</a>
            </td>
            <td>#STOPPAGE_ACCOUNT_CODE#</td>
            <td>#DETAIL#</td>	
          </tr>
      </cfoutput>
      </tbody>
	</cf_flat_list>
</cf_box>
