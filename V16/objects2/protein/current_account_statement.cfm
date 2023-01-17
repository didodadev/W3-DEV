<cfset corporate_actions = createObject('component','V16.objects2.finance.cfc.CorporateActions') />
<cfif isDefined("session.pp")>
    <cfset get_extre = corporate_actions.get_remainder( company_id : session.pp.company_id )>
    <cfset money = session.pp.money>
<cfelseif isDefined("session.ww")>
    <cfset get_extre = corporate_actions.get_remainder( consumer_id : session.ww.company_id )>
    <cfset money = session.ww.money>
</cfif>

<cfif get_extre.recordcount>
    <cfset borc = get_extre.borc>
    <cfset alacak = get_extre.alacak>
    <cfset bakiye = get_extre.bakiye>
<cfelse>
    <cfset borc = 0>
    <cfset alacak = 0>
    <cfset bakiye = 0>
</cfif>

<div class="row">
    <div class="col-md-12 mb-2">
        <div class="col-md-12">
            <div class="progress">
                <div class="progress-bar bg-color-1 w-100" role="progressbar"
                    aria-valuenow="100" aria-valuemin="0" aria-valuemax="100"></div>
            </div>
        </div>
    </div>
    <div class="col-md-12 mb-2">
        <div class="col-md-12">
            <div class="progress">
                <div class="progress-bar bg-color-2 w-75" role="progressbar" 
                    aria-valuenow="75" aria-valuemin="0" aria-valuemax="100"></div>
            </div>
        </div>
    </div>

        <div class="col-md-12 col-sm-12 col-xs-12">
            <label class="font-weight-bold float-left project-color-g w-30"><cf_get_lang dictionary_id='57587.Borç'></label>                    
            <label class="font-weight-bold float-right text-right w-70"><cfoutput>#tlformat(ABS(borc))# #money#</cfoutput></label>                       
        </div>

        <div class="col-md-12 col-sm-12 col-xs-12">
            <label class="font-weight-bold text-color-1 w-30"><cf_get_lang dictionary_id='57588.Alacak'></label>                   
            <label class="font-weight-bold float-right text-right w-70"><cfoutput>#tlformat(ABS(alacak))# #money#</cfoutput></label>                   
        </div>

        <div class="col-md-12 col-sm-12 col-xs-12">
            <label class="font-weight-bold float-left text-color-2 w-30"><cf_get_lang dictionary_id='57589.Bakiye'></label>                    
            <label class="font-weight-bold float-right text-right w-70"><cfoutput>#tlformat(ABS(bakiye))# #money#</cfoutput> <cfif borc gte alacak>(B)<cfelse>(A)</cfif></label>                       
        </div>

        <!--- <div class="col-sm-12">
            <label class="font-weight-bold text-color-3"><cf_get_lang dictionary_id='61795.Gecikmiş Bakiye'></label>
        </div>
        
        <div class="col-12">
            <label class="font-weight-bold float-left text-color-3 w-25">42 Gün</label>                    
            <label class="font-weight-bold float-right text-right w-75">870,00 TL</label>                       
        </div> --->
    <div class="col-md-12">
        <div class="col-md-12 d-flex justify-content-center">
            <button type="button" class="btn btn-color-2"><i class="far fa-credit-card"></i> <cf_get_lang dictionary_id='61796.Ödeme Yap'></button>
        </div>
    </div>   
</div>