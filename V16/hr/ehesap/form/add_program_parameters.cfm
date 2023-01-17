<cfif not get_module_power_user(48)>
	<script language="javascript">
		{
			alert("<cf_get_lang dictionary_id='59569.Yetki yok'>");
			history.go(-1);
		}
	</script>
</cfif>

<cfsavecontent variable="message"><cf_get_lang dictionary_id="47071.Bordro Akış Parametreleri"></cfsavecontent>
<cfset pageHead = #message#>

<cfform name="form_add" method="post" action="#request.self#?fuseaction=ehesap.emptypopup_add_program_parameters">
	<div class="row">
		<div class="col col-12 uniqueRow">
        	<div class="row formContent">
            	<div class="row" type="row">
                	<div class="col col-4 col-sm-6 col-xs-12" type="column" sort="true" index="1">
                    	<div class="form-group">
                        	<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="58233.Tanım"></label>
                            <div class="col col-9 col-xs-12"><cfinput type="text" name="parameter_name" maxlength="100"></div>
                        </div>
                    </div>
                </div>
                <div class="row formContentFooter">
                	<div class="col col-12">
                		<cf_workcube_buttons add_function='kontrol()' is_upd='0'>
                    </div>
                </div>
            </div>
        </div>
	</div>
</cfform>
<script type="text/javascript">
	function kontrol(){
		if(!$('#parameter_name').val().length){
			alertObject({ message: '<cfoutput><cf_get_lang dictionary_id="54327.Tanım Girmelisiniz"> ! </cfoutput>'})
			return false;
		}
		return true;
	}
</script>
