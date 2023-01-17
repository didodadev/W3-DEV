<cf_catalystHeader>
<div class="imp-tool">
    <div class="page-wrapper">
        <main class="page-content">
            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                <cfsavecontent variable = "box_title">Sayistay Raporlari</cfsavecontent>
                <cf_box title="#box_title#" closable="0" collapsed="0">
                    <cfoutput>
                        <ul class="ui-list">
                            <li class="list-group-item" id="headQuerter0">
                                <a href="javascript://" onclick="showWO(0)">
                                    <div class="ui-list-left">Parametreler</div>
                                </a>
                            </li>
							<li class="list-group-item" id="headQuerter1">
                                <a href="javascript://" onclick="showWO(1)">
                                    <div class="ui-list-left">4.1 Muhasebe Bilgi Formu</div>
                                </a>
                            </li>
							<li class="list-group-item" id="headQuerter2">
                                <a href="javascript://" onclick="showWO(2)">
                                    <div class="ui-list-left">4.2 Banka Hesaplari Bilgi Formu</div>
                                </a>
                            </li>
							<li class="list-group-item" id="headQuerter3">
                                <a href="javascript://" onclick="showWO(3)">
                                    <div class="ui-list-left">4.3 Bilanço</div>
                                </a>
                            </li>
							<li class="list-group-item" id="headQuerter4">
                                <a href="javascript://" onclick="showWO(4)">
                                    <div class="ui-list-left">4.4 Gelir Tablosu</div>
                                </a>
                            </li>
							<li class="list-group-item" id="headQuerter5">
                                <a href="javascript://" onclick="showWO(5)">
                                    <div class="ui-list-left">4.5 Dip Notlar (Nazım Hesaplar)</div>
                                </a>
                            </li>
							<li class="list-group-item" id="headQuerter6">
                                <a href="javascript://" onclick="showWO(6)">
                                    <div class="ui-list-left">4.6 Birleştirilmiş Veriler Defteri (Yevmiye)</div>
                                </a>
                            </li>
							<li class="list-group-item" id="headQuerter7">
                                <a href="javascript://" onclick="showWO(7)">
                                    <div class="ui-list-left">4.7 Envanter Defteri</div>
                                </a>
                            </li>
							<li class="list-group-item" id="headQuerter8">
                                <a href="javascript://" onclick="showWO(8)">
                                    <div class="ui-list-left">4.8 Geçici Mizan</div>
                                </a>
                            </li>
							<li class="list-group-item" id="headQuerter9">
                                <a href="javascript://" onclick="showWO(9)">
                                    <div class="ui-list-left">4.9 Kesin Mizan</div>
                                </a>
                            </li>
                        </ul>
                    </cfoutput> 
                </cf_box>
            </div>            
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                <div id="ajax_right">
                </div>           
            </div>
        </main>
    </div>  
</div>
<script> 
    function showWO(objectType) {
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=account.government_audit&event=ajaxSub&type=' + objectType,'ajax_right');  
    }   
</script>