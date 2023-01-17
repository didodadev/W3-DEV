<cf_get_lang_set module_name="finance"><!--- sayfanin en altinda kapanisi var --->
<cfquery name="GET_BRANCHES" datasource="#DSN#">
	SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH <cfif session.ep.isBranchAuthorization>WHERE BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#</cfif> ORDER BY BRANCH_NAME
</cfquery>
<cfparam name="attributes.modal_id" default="">

<cfif not isDefined("attributes.draggable")><cf_catalystHeader></cfif>
<div id="add_stores" class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box id="box_counter" title="#iif(isDefined("attributes.draggable"),"getLang('','Şube Günlük Kasa Raporu Ekle',31689)",DE(''))#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),DE(1),DE(0))#">
		<cfform name="add_stores" action="" method="post">
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-promotion_head">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                        <div class="col col-8 col-sm-12">
                            <select name="stores" id="stores" style="width:250;">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="GET_BRANCHES">
									<option value="#branch_id#">#branch_name#</option>
								</cfoutput>
							</select>
                        </div>
                    </div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cfsavecontent variable="button"><cf_get_lang_main no='714.Devam'></cfsavecontent>
				<cf_workcube_buttons type_format='1' is_upd='0' add_function="#iif(isdefined("attributes.draggable"),DE("kontrol() && loadPopupBox('add_stores' , #attributes.modal_id#)"),DE(""))#" insert_info='#button#' insert_alert=''>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div> 
<script type="text/javascript">
function kontrol()
{
	x = document.add_stores.stores.selectedIndex;
	if (document.add_stores.stores[x].value == "")
	{ 
		alert ("<cf_get_lang dictionary_id='30332.Şube Seçmelisiniz'> !");
		return false;
	}
	if (document.add_stores.stores[x].value != "")
	{
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_stores_daily_reports&event=addSub&store_id='+document.add_stores.stores[x].value</cfoutput>;
			<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	}
}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
