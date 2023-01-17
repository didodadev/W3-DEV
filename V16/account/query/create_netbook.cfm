<cftry>
    <cf_date tarih="attributes.start_date">
    <cf_date tarih="attributes.finish_date">
    
    <cfscript>
        netbook = createObject("component","V16.e_government.cfc.netbook");
        netbook.dsn = dsn;
        netbook.dsn2 = dsn2;
        netbook.dsn3 = dsn3;
        get_netbooks = netbook.getNetbooks(
            start_date : attributes.start_date,
            finish_date : attributes.finish_date,
            defter_status : 1,
            topCount: 1 
        );
        if(!isdefined("attributes.acc_card_type")) { attributes.acc_card_type =''; }
        getAccountCard = netbook.getAccountCard(
            acc_card_type : attributes.acc_card_type,
            start_date : attributes.start_date,
            finish_date : attributes.finish_date
        );
        
        getNetbooksRowNumber = netbook.getNetbooks( defter_status: 1, topCount: 1 );
        
        get_our_company = netbook.getNetbookIntegration( control_date : attributes.start_date );
    </cfscript>
    <!--- defter kontrolleri --->
    <cfif not (attributes.start_date gte session.ep.period_start_date and attributes.finish_date lte session.ep.period_finish_date)> <!--- year(attributes.start_date) neq session.ep.period_year or year(attributes.finish_date) neq session.ep.period_year --->
        <script language="javascript">
            alert('<cf_get_lang dictionary_id='64371.Lütfen E-Defter oluşturmak istediğiniz döneme geçiniz'>!');
            history.back();
        </script>
        <cfabort>
    </cfif>
    <cfif get_netbooks.recordcount>
        <script language="javascript">
            alert('<cf_get_lang dictionary_id='64370.Bu döneme ait kayıtlı defter bulunmaktadır. Lütfen kontrol ediniz'>.');
            history.back();
        </script>
        <cfabort>
    </cfif>
    <!--- muhasebe fisleri --->
    <cfquery name="getAccount" dbtype="query">
        SELECT DISTINCT CARD_ID FROM getAccountCard ORDER BY ACTION_DATE,BILL_NO
    </cfquery>
    <!--- muhasebe fisleri --->
    <cftransaction>
        <cfif getNetbooksRowNumber.recordcount and len(getNetbooksRowNumber.bill_start_number)>
            <cfset bill_start_number = getNetbooksRowNumber.bill_finish_number+1> <!--- bir defter x. satırda biterse, diğeri x+1. satırdan başlasın --->
        <cfelse>
            <cfset bill_start_number = 1>
        </cfif>
        <cfif getNetbooksRowNumber.recordcount and len(getNetbooksRowNumber.bill_finish_number)>
            <cfset bill_finish_number = bill_start_number+getAccount.recordcount-1>
        <cfelse>
            <cfset bill_finish_number = getAccount.recordcount>
        </cfif>
        <cfif getNetbooksRowNumber.recordcount and len(getNetbooksRowNumber.bill_start_row_number)>
            <cfset bill_start_row_number = getNetbooksRowNumber.bill_finish_row_number+1>
        <cfelse>
            <cfset bill_start_row_number = 1>
        </cfif>
        <cfif getNetbooksRowNumber.recordcount and len(getNetbooksRowNumber.bill_finish_row_number)>
            <cfset bill_finish_row_number = bill_start_row_number+getAccountCard.recordcount-1>
        <cfelse>
            <cfset bill_finish_row_number = getAccountCard.recordcount>
        </cfif>
    
        <!--- B/A eşitliklerini inceliyoruz: Start --->
        <cfquery name="getBillNo" dbtype="query">
            SELECT
                BILL_NO,
                CARD_TYPE_NO,
                CARD_TYPE,
                SUM(AMOUNT*(2*BA-1)) TOTAL_AMOUNT
            FROM
                getAccountCard
            GROUP BY
                BILL_NO, CARD_TYPE_NO, CARD_TYPE
            ORDER BY
                ACTION_DATE
        </cfquery>
    
        <cfset control_alert = 0>
    
        <cfquery name="getTotalAmount" dbtype="query"> <!--- B/A eşitsizliği olan kayıtları getiriyorum. Açılış ve kapanış hariç. --->
            SELECT BILL_NO FROM getBillNo WHERE CARD_TYPE NOT IN (10,19) AND TOTAL_AMOUNT NOT BETWEEN -0.01 AND 0.01
        </cfquery>
        <cfif getTotalAmount.recordcount>
            <cfset control_alert = 1>
            <cfoutput>#ValueList(getTotalAmount.BILL_NO)#</cfoutput> nolu yevmiye maddelerinde B/A eşitsizliği vardır. Lütfen kontrol ediniz.<br />
        </cfif>
        
        <cfif control_alert eq 1>
            <script language="javascript">
                alert('<cf_get_lang dictionary_id='64368.Defter verisi kontrollerinde hata oluştu'>.');
            </script>
            <cfabort>
        </cfif>
        
        <!--- B/A eşitliklerini inceliyoruz: End --->
        
        <!--- Buraya kadar gelebildiyse, entegrasyon yöntemine uygun dosyayı çağırıyoruz. --->
        <cfif get_our_company.recordcount and get_our_company.netbook_integration_type eq 1><!--- Digital Planet --->
            <cfinclude template="../../e_government/query/netbook_digital_planet.cfm" />
        <cfelse>
            <script language="javascript">
                alert('<cf_get_lang dictionary_id='64367.Lütfen Entegrasyon Yönteminizi ve Muhasebeci Tanımlarınızı Kontrol Ediniz'>!');
                <cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
            </script>
            <cfabort>
        </cfif>
        <cfset netbook_detail = "#dateformat(attributes.start_date,dateformat_style)# - #dateformat(attributes.finish_date,dateformat_style)# arası #get_our_company.company_name#'ye ait e-defter.">
        <cfscript>
            if(!isdefined('Result') or not len(Result)) {
                Result = '';
            }
            if(!isdefined('CustomerId') or not len(CustomerId)) {
                CustomerId = '';
            }
			add_netbook = netbook.addNetbook(
								file_name : file_name,
								netbook_detail: netbook_detail,
								start_date : attributes.start_date,
								finish_date : attributes.finish_date,
								bill_start_number : bill_start_number,
								bill_finish_number : bill_finish_number,
								bill_start_row_number : bill_start_row_number,
								bill_finish_row_number : bill_finish_row_number,
								Result : Result,
								CustomerId : CustomerId
										);
        </cfscript>
        <script language="javascript">
            alert('Defter dosyası oluşturuldu!');
            <cfif not isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>');</cfif>
        </script>
    </cftransaction>
    <cfcatch>
		<cfinclude template="edefter_hata.cfm">
    </cfcatch>
</cftry>