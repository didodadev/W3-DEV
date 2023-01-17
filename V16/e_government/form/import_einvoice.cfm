<!---
    File: import_einvoice.cfm
    Folder: V16\e_government\form\
	Controller: 
    Author: Gramoni-Mahmut Çifçi mahmut.cifci@gramoni.com
    Date: 2020-03-31 00:13:27 
    Description:
		Entegratör portalına Workcube haricinde kayıt edilmiş bir fatura ile Workcubede kayıtlı faturayı ilişkilendirmek için kullanılır.
		UUID değeri parametre olarak girilir.
    History:
        
    To Do:

--->

<cfsetting showdebugoutput="no" />

<cfscript>
	einvoice		= createObject("component","V16.e_government.cfc.einvoice");
	einvoice.dsn	= dsn;
	einvoice.dsn2	= dsn2;
	einvoice_company= einvoice.get_our_company_fnc(company_id:session.ep.company_id);
</cfscript>

<cfif len(einvoice_company.is_efatura) and len(einvoice_company.einvoice_type)>
	<cfoutput>
		<cfform name="upload_form_page" enctype="multipart/form-data" action="#request.self#?fuseaction=invoice.emptypopup_import_einvoice&action_id=#attributes.action_id#&action_type=#attributes.action_type#&invoice_type=#attributes.invoice_type#">
        	<div class="row">
            	<div class="col col-12 uniqueRow">
                	<div class="row formContent">
                		<div class="row" type="row">
                			<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                            	<div class="form-group" id="item-file">
                                	<label for="invoice_uuid" class="col col-4 col-xs-12">UUID *</label>
                                    <div class="col col-8 col-xs-12">
                                    	<input type="text" name="invoice_uuid" id="invoice_uuid" style="width:200px;" onfocus="select();" />
                                    </div>
								</div>
								<div class="form-group" id="item-detail">
                                    <div class="col col-8 col-xs-12">
                                    	<ul>
											<li>* Entegratör sisteminde kayıtlı olan faturanın UUID değerini girmelisiniz.</li>
											<li>* Bu ekran entegratör portalına Workcube haricinde kayıt edilmiş bir fatura ile Workcubede kayıtlı faturayı ilişkilendirmek için kullanılır.</li>
										</ul>
                                    </div>
                                </div>
                            </div>
                		</div>
                        <div class="row formContentFooter">
                        	<div class="col col-12">
                            	<cf_workcube_buttons is_upd='0' is_cancel="0" is_delete=0 add_function='ekle_form_action()'>
                            </div>
                        </div>
                	</div>
                </div>
            </div>
		</cfform>
	</cfoutput>
<cfelse>
	<cf_get_lang dictionary_id="57532.Yetkiniz yok!">   
</cfif>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu alan"> UUID</cfsavecontent>
<script type="text/javascript">
	function ekle_form_action()
	{
		if(document.getElementById('invoice_uuid').value == "")
		{
			alertObject({message:"<cfoutput>#message#</cfoutput>"})
			return false;
		}
		else{
			return true;
		}
	}

	$(document).keydown(function(e){
        // ESCAPE key pressed
        if (e.keyCode == 27) {
            window.close();
        }
    });
</script>