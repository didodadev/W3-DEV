<cfquery name="get_receive_offer" datasource="#dsn3#">
    SELECT 
        O.OFFER_ID,
        O.OFFER_NUMBER,
        O.REF_NO,
        O.OFFER_HEAD,
        O.OFFER_TO,
        O.OFFER_TO_PARTNER,
        O.OFFER_TO_CONSUMER,
        O.OFFER_DATE,
        O.OFFER_STAGE,
        PTR.STAGE,
        PTR.LINE_NUMBER,
        CTRL.OFFER_ID AS CONTROL_OFFER
    FROM 
        OFFER AS O
        LEFT JOIN #dsn_alias#.PROCESS_TYPE_ROWS PTR ON O.OFFER_STAGE = PTR.PROCESS_ROW_ID
        LEFT JOIN 
          (SELECT FOR_OFFER_ID,OFFER_ID FROM OFFER WHERE OFFER_TO_PARTNER LIKE '%,#session_base.USERID#,%') CTRL ON O.OFFER_ID = CTRL.FOR_OFFER_ID
    WHERE
        OFFER_TO_PARTNER LIKE '%,#session_base.USERID#,%'
        AND O.FOR_OFFER_ID IS NULL
</cfquery>
<div class="protein-table" id="search-results"> 
  <div class="table-responsive">
    <table class="table table-hover">
        <thead class="main-bg-color">
          <tr>    
            <th>#</th>       
            <th><cf_get_lang dictionary_id='58616.Belge Numarası'></th>       
            <th><cf_get_lang dictionary_id='58820.Başlık'></th>
            <th><cf_get_lang dictionary_id='57742.Tarih'></th>
            <th><cf_get_lang dictionary_id='57482.Stage'></th> 
            <th></th>                         
          </tr>
        </thead>
        <tbody>
            <cfoutput query="get_receive_offer">                       
                <tr>
                    <td>#currentrow#</td>
                    <td>#OFFER_NUMBER#</td>
                    <td>#OFFER_HEAD#</td>
                    <td>#dateformat(OFFER_DATE,'dd/mm/yyyy')#</td>
                    <td><span class="badge pl-3 pr-3 py-2 span-color-<cfif line_number lt 8>#line_number#<cfelse>7</cfif>"><cfif len(OFFER_STAGE)>#STAGE#</cfif></span></td>                
                    <td>
                      <cfif LEN(CONTROL_OFFER)>
                        <span class="badge pl-3 pr-3 py-2 span-color-6">Teklif Verildi</span>
                      <cfelse>
                        <a href="javascript://" onclick="openBoxDraggable('widgetloader?widget_load=send_receive_offer&isbox=1&style=lean&offer_id=#OFFER_ID#')">
                            <span class="badge pl-3 pr-3 py-2 span-color-4"><cf_get_lang dictionary_id='40807.Teklif Ver'></span>
                        </a>
                      </cfif>                        
                    </td>
                </tr>
            </cfoutput>
        </tbody>        
      </table>
  </div>      
</div>
