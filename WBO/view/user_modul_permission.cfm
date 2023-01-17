<cf_get_lang_set module_name = 'settings'>
<cfset modul_permission = createObject("component", "WBO.model.modul_permission")>
<cfset authority = modul_permission.modul_permission('#attributes.modul_no#','#dsn#','#session.ep.language#')>

<input type="hidden" id="modul_no" name="modul_no" value="">
<cfoutput query="authority" group="SOLUTION">                        	
	<div class="row">
		<div class="col col-12 portBox">
			<!---<div class="color-#Left(SOLUTION, 2)# portHead"><span>#SOLUTION#</span><i class="fa fa-angle-down pull-right"></i></div>--->
			<ul class="solutionUl" >
				<cfoutput group="FAMILY">                                                           									
					 <li class="solutionItem">
                        <ul class="moduleUl">
                            <li class="moduleItem">
                                <div class="row">
                                    <div class="col col-4"></div>
                                    <div class="col col-2 checkbox">
                                        <label><i class="fa fa-eye-slash" title="<cf_get_lang dictionary_id='42134.göremez'>"></i><input style="float:left" type="checkbox" class="nShow" name="listAll" id="listAll" value="1"></label>
                                    </div>
                                    <div class="col col-2 checkbox">
                                        <label><i class="fa fa-plus" title="<cf_get_lang dictionary_id='59022.ekleyemez'>"></i><input style="float:left" type="checkbox" class="nAdd" name="addAll" id="addAll" value="1"></label>
                                    </div>
                                    <div class="col col-2 checkbox">
                                        <label><i class="fa fa-pencil-square-o" title="<cf_get_lang dictionary_id='59023.güncelleyemez'>"></i><input style="float:left" type="checkbox" class="nUpdate" name="updAll" id="updAll" value="1"></label>
                                    </div>
                                    <div class="col col-2 checkbox">
                                        <label><i class="fa fa-eraser" title="<cf_get_lang dictionary_id='42136.silemez'>"></i><input style="float:left" type="checkbox" class="nDelete" name="delAll" id="delAll" value="1"></label>
                                    </div>
                                </div>
                        	</li>
                        </ul>
						<ul class="moduleUl scrollContent" style="max-height:300px;">
							<cfoutput>
                                <li class="moduleItem checkbox">
                                <div class="row">
                                	<div class="col col-4">
                                        <label>
                                            <span style="<cfif TYPE eq 0>color:red;</cfif>">#OBJECT#</span>
                                        </label>
                                    </div>
                                    <div class="col col-2">
                                        <label>
                                            <input style="float:left" type="checkbox" class="list" name="list_#WRK_OBJECTS_ID#_#attributes.modul_no#" id="list_#WRK_OBJECTS_ID#_#attributes.modul_no#" value="1" <cfif listFindNoCase(attributes.nListObject,'#WRK_OBJECTS_ID#_#attributes.modul_no#',',')>checked</cfif> onclick="checkField()">
                                        </label>
                                    </div>
                                    <div class="col col-2">
                                        <label>
                                            <input style="float:left" type="checkbox" class="add" name="add_#WRK_OBJECTS_ID#_#attributes.modul_no#" id="add_#WRK_OBJECTS_ID#_#attributes.modul_no#" value="1" <cfif listFindNoCase(attributes.nAddObject,'#WRK_OBJECTS_ID#_#attributes.modul_no#',',')>checked</cfif> onclick="checkField()">
                                        </label>
                                    </div>
                                    <div class="col col-2">
                                        <label>
                                            <input style="float:left" type="checkbox" class="upd" name="upd_#WRK_OBJECTS_ID#_#attributes.modul_no#" id="upd_#WRK_OBJECTS_ID#_#attributes.modul_no#" value="1" <cfif listFindNoCase(attributes.nUpdObject,'#WRK_OBJECTS_ID#_#attributes.modul_no#',',')>checked</cfif> onclick="checkField()">
                                        </label>
                                    </div>
                                    <div class="col col-2">
                                        <label>
                                            <input style="float:left" type="checkbox" class="del" name="del_#WRK_OBJECTS_ID#_#attributes.modul_no#" id="del_#WRK_OBJECTS_ID#_#attributes.modul_no#" value="1" <cfif listFindNoCase(attributes.nDelObject,'#WRK_OBJECTS_ID#_#attributes.modul_no#',',')>checked</cfif> onclick="checkField()">
                                        </label>
                                    </div>
								</div>
                                </li>
							</cfoutput>
						</ul>
					</li>                                    
				</cfoutput>
			</ul>
		</div>
	</div>    
</cfoutput>
<script>
$(document).ready(function () {
	<cfif attributes.FamilyId eq 0>
		$('#modul<cfoutput>#attributes.modul_no#</cfoutput> input[type=checkbox]').attr('disabled',true);
	
	</cfif>
	$('.nShow').click(function () {
		$(this).closest('div[class=row][id=modul<cfoutput>#attributes.modul_no#</cfoutput>]').find('.list').prop('checked', this.checked);
		checkAreas('<cfoutput>#attributes.modul_no#</cfoutput>');
	});
	$('.nShow').change(function () {
		var check = ($(this).closest('div[class=row][id=modul<cfoutput>#attributes.modul_no#</cfoutput>]').find('.list').filter(":checked").length == $(this).closest('div[class=row][id=modul<cfoutput>#attributes.modul_no#</cfoutput>]').find('.list').length);
		$(this).closest('div[class=row][id=modul<cfoutput>#attributes.modul_no#</cfoutput>]').find('.list').prop('checked', check);
		checkAreas('<cfoutput>#attributes.modul_no#</cfoutput>');
	});
	$('.nAdd').click(function () {
		$(this).closest('div[class=row][id=modul<cfoutput>#attributes.modul_no#</cfoutput>]').find('.add').prop('checked', this.checked);
		checkAreas('<cfoutput>#attributes.modul_no#</cfoutput>');
	});
	$('.nAdd').change(function () {
		var check = ($(this).closest('div[class=row][id=modul<cfoutput>#attributes.modul_no#</cfoutput>]').find('.add').filter(":checked").length == $(this).closest('div[class=row][id=modul<cfoutput>#attributes.modul_no#</cfoutput>]').find('.add').length);
		$(this).closest('div[class=row][id=modul<cfoutput>#attributes.modul_no#</cfoutput>]').find('.add').prop('checked', check);
		checkAreas('<cfoutput>#attributes.modul_no#</cfoutput>');
	});
	$('.nUpdate').click(function () {
		$(this).closest('div[class=row][id=modul<cfoutput>#attributes.modul_no#</cfoutput>]').find('.upd').prop('checked', this.checked);
		checkAreas('<cfoutput>#attributes.modul_no#</cfoutput>');
	});
	$('.nUpdate').change(function () {
		var check = ($(this).closest('div[class=row][id=modul<cfoutput>#attributes.modul_no#</cfoutput>]').find('.upd').filter(":checked").length == $(this).closest('div[class=row][id=modul<cfoutput>#attributes.modul_no#</cfoutput>]').find('.upd').length);
		$(this).closest('div[class=row][id=modul<cfoutput>#attributes.modul_no#</cfoutput>]').find('.upd').prop('checked', check);
		checkAreas('<cfoutput>#attributes.modul_no#</cfoutput>');
	});
	$('.nDelete').click(function () {
		$(this).closest('div[class=row][id=modul<cfoutput>#attributes.modul_no#</cfoutput>]').find('.del').prop('checked', this.checked);
		checkAreas('<cfoutput>#attributes.modul_no#</cfoutput>');
	});
	$('.nDelete').change(function () {
		var check = ($(this).closest('div[class=row][id=modul<cfoutput>#attributes.modul_no#</cfoutput>]').find('.del').filter(":checked").length == $(this).closest('div[class=row][id=modul<cfoutput>#attributes.modul_no#</cfoutput>]').find('.del').length);
		$(this).closest('div[class=row][id=modul<cfoutput>#attributes.modul_no#</cfoutput>]').find('.del').prop('checked', check);
		checkAreas('<cfoutput>#attributes.modul_no#</cfoutput>');
	});
});
function checkField()
{
	checkAreas('<cfoutput>#attributes.modul_no#</cfoutput>');
	/*if(type == 1)
	{
		var elementName = objectName.replace('list_','');
		if($("#"+objectName).filter(":checked").length)
		if(list_find($('#nListObject').val(),elementName) == -1)
		{
			$('#nListObject').val($('#nListObject').val()+','+elementName);
		}
	}*/
}
</script>
