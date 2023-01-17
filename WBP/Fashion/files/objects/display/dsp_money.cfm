<cfquery name="get_money_bskt" datasource="#dsn3#">
	SELECT *FROM TEXTILE_SAMPLE_REQUEST_MONEY WHERE ACTION_ID=#attributes.req_id#
</cfquery>
<cfif get_money_bskt.recordcount eq 0>
<cfquery name="get_money_bskt" datasource="#dsn3#">
	select 
		MONEY MONEY_TYPE,
			RATE1,
			RATE2,
			0 IS_SELECTED
		from #dsn#.TEXTILE_SETUP_MONEY
		WHERE 
			PERIOD_ID=#session.ep.period_id# AND COMPANY_ID=#session.ep.company_id# AND MONEY_STATUS=1
</cfquery>
</cfif>
<cfscript>
	str_money_bskt_found = true;
</cfscript>
<!--- Benden önceki kod...... Necip MENEKŞE
<th>
<marquee>
<cfoutput query="get_money_bskt">
	
		#MONEY_TYPE# -  #rate2# 
	
	
</cfoutput>
</marquee>
</th>

Buraya kadar olan kod--->
<cfoutput>
<div class="col x-16" id="basket_money_totals_table">
    <div class="totalBox">
        <div class="totalBoxHead font-grey-mint">
            <span class="headText"><cf_get_lang_main no='265.Dövizler'></span>
        </div>
        <div class="totalBoxBody scrollContent">
        <input type="hidden" id="basket_money" name="basket_money" value="TL">
        <input type="hidden" id="kur_say" name="kur_say" value="#get_money_bskt.recordcount#">
        <cfif not isdefined("default_basket_money_")>
            <cfset default_basket_money_=session_base.money>
        </cfif>
                <table cellspacing="0" id="money_rate_table">
                <cfset money_order_ = 0>
				<cfloop query="get_money_bskt">
					<cfif IS_SELECTED>
						<cfset str_money_bskt = money_type>
						<cfset selectedRadioButton = 1>
					</cfif>
				</cfloop>

                <cfloop query="get_money_bskt">
                    <cfset money_order_ = money_order_ + 1>
                    <cfif IS_SELECTED>
                        <cfset sepet_rate1 = rate1>
                        <cfset sepet_rate2 = rate2>
                        <cfset str_money_bskt_found = false>
                    <cfelseif str_money_bskt_found > 
                        <cfset sepet_rate1 = 1>
                        <cfset sepet_rate2 = 1>
						<cfif not isdefined("selectedRadioButton")>
	                        <cfset str_money_bskt = session_base.money>
						</cfif>
                        <cfset str_money_bskt_found = false>
                    <cfelseif str_money_bskt_found and money_type is default_basket_money_>
                        <cfset sepet_rate1 = rate1>
                        <cfset sepet_rate2 = rate2>
						<cfif not isdefined("selectedRadioButton")>
	                        <cfset str_money_bskt = money_type>
						</cfif>
                        <cfset str_money_bskt_found = false>
                    </cfif>
                    
                    <tr height="25">
						<cfset readonly_info = "no">
						<input type="hidden" id="hidden_rd_money_#currentrow#" name="hidden_rd_money_#currentrow#" value="#money_type#">
						<input type="hidden" id="txt_rate1_#currentrow#" name="txt_rate1_#currentrow#" value="#TLFormat(rate1)#">
						<td nowrap="nowrap"><input type="radio" class="rdMoney" id="rd_money" name="rd_money" value="#currentrow#" onclick="selectedCurrency('#money_type#');" <cfif isDefined('str_money_bskt') and str_money_bskt eq money_type>checked="checked"</cfif>></td>
						<td nowrap="nowrap">#money_type# /</td>
						<td nowrap="nowrap">#TLFormat(rate1,0)#</td>
						<td nowrap="nowrap"><input type="text" <cfif readonly_info>readonly</cfif> id="txt_rate2_#currentrow#" name="txt_rate2_#currentrow#" value="#TLFormat(rate2,3)#" style="width:65px;" class="box" onkeyup="return(FormatCurrency(this,event,4));" onblur="if((this.value.length == 0) || filterNum(this.value,4) <=0 ) this.value=commaSplit(1,4);" <cfif money_type eq session_base.money>readonly</cfif>></td>
                    </tr>
            </cfloop>						
                </table>
  
        </div>
    </div>    
</div> 
</cfoutput>

   
<script>
	function selectedCurrency(currency)
	{
		$("#basket_money").val(currency);
	}
</script>  