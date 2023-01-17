<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.modal_id" default="">
<cfif isdefined("attributes.is_submit")>
    <cfif isDefined("attributes.assurance_id") and len(attributes.assurance_id)>
        <cfquery name="get_decision_medicine" datasource="#dsn#">
            SELECT 
                SD.DRUG_ID, 
                DRUG_MEDICINE 
            FROM 
                SETUP_DECISIONMEDICINE SD LEFT JOIN SETUP_HEALTH_ASSURANCE_TYPE_MEDICATION SHATM ON SHATM.DRUG_ID = SD.DRUG_ID
            WHERE
                1=1 
                AND SHATM.ASSURANCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assurance_id#">
                <cfif isDefined("attributes.keyword") and len(attributes.keyword)>
                    <cfif len(attributes.keyword) eq 1>
                        AND DRUG_MEDICINE LIKE '#attributes.keyword#%'
                    <cfelse>
                        AND DRUG_MEDICINE LIKE '%#attributes.keyword#%'
                    </cfif>
                </cfif>
            ORDER BY 
                DRUG_MEDICINE 
        </cfquery>
    <cfelse>
        <cfquery name="get_decision_medicine" datasource="#dsn#">
            SELECT 
                DRUG_ID, 
                DRUG_MEDICINE 
            FROM 
                SETUP_DECISIONMEDICINE 
            WHERE
                1=1 
                <cfif isDefined("attributes.keyword") and len(attributes.keyword)>
                    <cfif len(attributes.keyword) eq 1>
                        AND DRUG_MEDICINE LIKE '#attributes.keyword#%'
                    <cfelse>
                        AND DRUG_MEDICINE LIKE '%#attributes.keyword#%'
                    </cfif>
                </cfif>
            ORDER BY 
                DRUG_MEDICINE 
        </cfquery>
    </cfif>
<cfelse>
	<cfset get_decision_medicine.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_decision_medicine.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset url_string = "">
<cfif isdefined("attributes.field_name") and len(attributes.field_name)>
	<cfset url_string = "#url_string#&field_name=#attributes.field_name#">
</cfif>
<cfif isdefined("attributes.field_id") and len(attributes.field_id)>
	<cfset url_string = "#url_string#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.assurance_id") and len(attributes.assurance_id)>
	<cfset url_string = "#url_string#&assurance_id=#attributes.assurance_id#">
</cfif>
<cfif isdefined("attributes.medicine_id") and len(attributes.medicine_id)>
	<cfset url_string = "#url_string#&medicine_id=#attributes.medicine_id#">
</cfif>

<div class="col col-12">
    <cfsavecontent variable="message"><cf_get_lang dictionary_id='55882.İlaç Ve Tıbbı Malzemeler'></cfsavecontent>
    <cf_box title="#message#" add_href="#request.self#?fuseaction=hr.popup_add_decisionmedicine&is_popup=1" closable="0" collapsable="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cf_wrk_alphabet keyword="url_string"  popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform action="#request.self#?fuseaction=objects.popup_list_decision_medicines#url_string#" method="post" name="search">
            <input type="hidden" name="is_submit" id="is_submit" value="1">
            <cf_big_list_search_area> 
                <div class="ui-form-list flex-list">
                    <div class="form-group" id="keyword">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                        <cfinput type="text" name="keyword" placeholder="#message#" value="#attributes.keyword#" maxlength="255">                        
                    </div>    
                    <div class="form-group small">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
                    </div>
                    <div class="form-group">
                        <cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search' , #attributes.modal_id#)"),DE(""))#">
                    </div>     
                </div>                    
            </cf_big_list_search_area>
        </cfform>
        <cf_ajax_list>
            <thead>
                <tr>
                    <th width="20"><cf_get_lang dictionary_id='57487.no'></th>
                    <th width="178"><cf_get_lang dictionary_id='32412.Verilen İlaçlar'></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_decision_medicine.recordcount>
                    <cfoutput query="get_decision_medicine" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td>#currentrow#</td>
                        <cfif isdefined("url.medicine_id") and url.medicine_id eq 1>
                            <td><a href="javascript://" class="tableyazi"  onClick="gonder_medicine(#drug_id#,'#drug_medicine#')">#drug_medicine#</a></td>
                        <cfelse>
                            <td><a href="javascript://" class="tableyazi"  onClick="gonder(#drug_id#,'#drug_medicine#')">#drug_medicine#</a></td>
                        </cfif>
                    </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="2" height="20"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
                    </tr>
                </cfif>
            </tbody>
        </cf_ajax_list>
        <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
            <cfset url_string = "#url_string#&keyword=#keyword#">
        </cfif>
        <cfif isdefined("attributes.is_submit") and len(attributes.is_submit)>
            <cfset url_string = "#url_string#&is_submit=#attributes.is_submit#">
        </cfif>  
        <cfif attributes.totalrecords gt attributes.maxrows>
        <cf_paging 
            page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="objects.popup_list_decision_medicines#url_string#"
            isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
        </cfif>
    </cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
    function gonder(decision_medicine_id,decision_medicine)
	{
		<cfif isDefined("attributes.field_name")>
			x = <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.length;
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.length = parseInt(x + 1);
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.options[x].value = decision_medicine_id;
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.options[x].text = decision_medicine;
		</cfif>
    }
        function gonder_medicine(id,name)
        { 
            <cfif isDefined("attributes.field_id")>
            
                <cfif listlen(attributes.field_id,".") eq 1>
                
                    <cfoutput>
                        <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("#attributes.field_id#").value=id;
                    </cfoutput>
                <cfelse>
                    <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value=id;
                </cfif>
            </cfif>
            <cfif isDefined("attributes.field_name")>
            
                <cfif listlen(attributes.field_name,".") eq 1>
                    <cfoutput>
                        <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("#attributes.field_name#").value=name;
                        <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("#attributes.field_name#").focus();
                    </cfoutput>
                <cfelse>
                    <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value=name;
                        <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.focus();
                </cfif>
            </cfif>
            
            <cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
           
        }
</script>
